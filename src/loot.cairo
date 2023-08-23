//
// LeetLoot is an onchain pixel art collection
// It consists of 75 Beasts for Loot Survivor, an onchain arcade machine game
// ERC721 implementation is based on OpenZeppelin's
// By hoanh.eth
//

use starknet::ContractAddress;
use super::long_string::LongString;
use super::beast;

// LeetLoot interface
#[starknet::interface]
trait ILeetLoot<T> {
    // Ownership
    fn owner(self: @T) -> ContractAddress;
    fn transferOwnership(ref self: T, to: ContractAddress);
    fn renounceOwnership(ref self: T);

    // ERC721
    fn name(self: @T) -> felt252;
    fn symbol(self: @T) -> felt252;
    fn balanceOf(self: @T, account: ContractAddress) -> u256;
    fn ownerOf(self: @T, tokenID: u256) -> ContractAddress;
    fn transferFrom(ref self: T, from: ContractAddress, to: ContractAddress, tokenID: u256);
    fn approve(ref self: T, to: ContractAddress, tokenID: u256);
    fn setApprovalForAll(ref self: T, operator: ContractAddress, approved: bool);
    fn getApproved(self: @T, tokenID: u256) -> ContractAddress;
    fn isApprovedForAll(self: @T, owner: ContractAddress, operator: ContractAddress) -> bool;

    // ERC165
    fn supportsInterface(self: @T, interfaceId: felt252) -> bool;
    fn registerInterface(ref self: T, interface_id: felt252);

    // Core functions
    fn whitelist(ref self: T, to: ContractAddress);
    fn getWhitelist(self: @T) -> ContractAddress;
    fn mint(ref self: T, to: ContractAddress, beast: u8, prefix: u8, suffix: u8, level: felt252);
    fn isMinted(ref self: T, beast: u8, prefix: u8, suffix: u8) -> bool;
    fn tokenURI(self: @T, tokenID: u256) -> Array::<felt252>;
    fn tokenSupply(self: @T) -> u256;
}

// LeetLoot contract
#[starknet::contract]
mod LeetLoot {
    use array::{ArrayTrait};
    use core::traits::{Into};
    use super::{ILeetLoot, LongString};
    use starknet::get_caller_address;
    use starknet::ContractAddress;
    use zeroable::Zeroable;
    use super::beast::{
        CHIMERA, getBeastName, getBeastNamePrefix, getBeastNameSuffix, getBeastType, getBeastTier,
        getBeastPixel
    };
    use poseidon::poseidon_hash_span;
    use debug::PrintTrait;

    // https://github.com/OpenZeppelin/cairo-contracts/blob/cairo-2/src/token/erc721/interface.cairo
    const ISRC5_ID: felt252 = 0x3f918d17e5ee77373b56385708f855659a07f75997f365cf87748628532a055;
    const IERC721_ID: felt252 = 0x33eb2f84c309543403fd69f0d0f363781ef06ef6faeb0131ff16ea3175bd943;
    const IERC721_METADATA_ID: felt252 =
        0x6069a70848f907fa57668ba1875164eb4dcee693952468581406d131081bbd;

    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
    const IERC721_ID_EIP: felt252 = 0x80ac58cd;
    const IERC721_METADATA_ID_EIP: felt252 = 0x5b5e139f;

    #[storage]
    struct Storage {
        _owner: ContractAddress,
        _whitelist: ContractAddress,
        _name: felt252,
        _symbol: felt252,
        _owners: LegacyMap<u256, ContractAddress>,
        _balances: LegacyMap<ContractAddress, u256>,
        _tokenApprovals: LegacyMap<u256, ContractAddress>,
        _operatorApprovals: LegacyMap<(ContractAddress, ContractAddress), bool>,
        _tokenIndex: u256,
        _supportedInterfaces: LegacyMap<felt252, bool>,
        _beasts: LegacyMap<u256, u8>,
        _prefixes: LegacyMap<u256, u8>,
        _suffixes: LegacyMap<u256, u8>,
        _levels: LegacyMap<u256, felt252>,
        _minted: LegacyMap::<felt252, bool>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Transfer: Transfer,
        Approval: Approval,
        ApprovalForAll: ApprovalForAll
    }

    #[derive(Drop, starknet::Event)]
    struct Transfer {
        from: ContractAddress,
        to: ContractAddress,
        token_id: u256
    }

    #[derive(Drop, starknet::Event)]
    struct Approval {
        owner: ContractAddress,
        approved: ContractAddress,
        token_id: u256
    }

    #[derive(Drop, starknet::Event)]
    struct ApprovalForAll {
        owner: ContractAddress,
        operator: ContractAddress,
        approved: bool
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        owner: ContractAddress,
        whitelist: ContractAddress,
        name: felt252,
        symbol: felt252
    ) {
        self.initializer(owner, whitelist, name, symbol);
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn initializer(
            ref self: ContractState,
            owner: ContractAddress,
            whitelist: ContractAddress,
            name: felt252,
            symbol: felt252
        ) {
            self._transferOwnership(owner);
            self._whitelist.write(whitelist);

            self._registerInterface(ISRC5_ID);
            self._registerInterface(IERC721_ID);
            self._registerInterface(IERC721_METADATA_ID);
            self._registerInterface(IERC721_ID_EIP);
            self._registerInterface(IERC721_METADATA_ID_EIP);

            self._name.write(name);
            self._symbol.write(symbol);
        }

        fn _assertOnlyOwner(self: @ContractState) {
            let owner: ContractAddress = self._owner.read();
            let caller: ContractAddress = get_caller_address();
            assert(!caller.is_zero(), 'Zero address');
            assert(caller == owner, 'Not owner');
        }

        fn _transferOwnership(ref self: ContractState, to: ContractAddress) {
            self._owner.write(to);
        }

        fn _ownerOf(self: @ContractState, tokenID: u256) -> ContractAddress {
            let owner = self._owners.read(tokenID);
            match owner.is_zero() {
                bool::False(()) => owner,
                bool::True(()) => panic_with_felt252('Invalid token ID')
            }
        }

        fn _approve(ref self: ContractState, to: ContractAddress, tokenID: u256) {
            let owner = self._ownerOf(tokenID);
            assert(owner != to, 'ERC721: approval to owner');

            self._tokenApprovals.write(tokenID, to);
            self.emit(Approval { owner, approved: to, token_id: tokenID });
        }

        fn _setApprovalForAll(
            ref self: ContractState,
            owner: ContractAddress,
            operator: ContractAddress,
            approved: bool
        ) {
            assert(owner != operator, 'ERC721: self approval');
            self._operatorApprovals.write((owner, operator), approved);
            self.emit(ApprovalForAll { owner, operator, approved });
        }

        fn _isApprovedOrOwner(
            self: @ContractState, spender: ContractAddress, tokenID: u256
        ) -> bool {
            let owner = self._ownerOf(tokenID);
            let isApprovedForAll = LeetLootImpl::isApprovedForAll(self, owner, spender);
            owner == spender
                || isApprovedForAll
                || spender == LeetLootImpl::getApproved(self, tokenID)
        }

        fn _exists(self: @ContractState, tokenID: u256) -> bool {
            !self._owners.read(tokenID).is_zero()
        }

        fn _transfer(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, tokenID: u256
        ) {
            assert(!to.is_zero(), 'ERC721: invalid receiver');
            let owner = self._ownerOf(tokenID);
            assert(from == owner, 'ERC721: wrong sender');

            self._tokenApprovals.write(tokenID, Zeroable::zero());

            self._balances.write(from, self._balances.read(from) - 1);
            self._balances.write(to, self._balances.read(to) + 1);
            self._owners.write(tokenID, to);
            self.emit(Transfer { from, to, token_id: tokenID });
        }

        fn _supportsInterface(self: @ContractState, interface_id: felt252) -> bool {
            self._supportedInterfaces.read(interface_id)
        }

        fn _registerInterface(ref self: ContractState, interface_id: felt252) {
            self._supportedInterfaces.write(interface_id, true);
        }

        fn _deregisterInterface(ref self: ContractState, interface_id: felt252) {
            self._supportedInterfaces.write(interface_id, false);
        }

        fn _mint(ref self: ContractState, to: ContractAddress) {
            let current: u256 = self._tokenIndex.read();
            self._balances.write(to, self._balances.read(to) + 1);
            self._owners.write(current, to);
            self._tokenIndex.write(current + 1);
            self.emit(Transfer { from: Zeroable::zero(), to, token_id: current });
        }

        fn _getBeastHash(ref self: ContractState, beast: u8, prefix: u8, suffix: u8) -> felt252 {
            let mut content = ArrayTrait::new();
            content.append(getBeastName(beast));
            content.append(getBeastNamePrefix(prefix));
            content.append(getBeastNameSuffix(suffix));
            return poseidon_hash_span(content.span());
        }
    }

    #[external(v0)]
    impl LeetLootImpl of ILeetLoot<ContractState> {
        fn owner(self: @ContractState) -> ContractAddress {
            self._owner.read()
        }

        fn transferOwnership(ref self: ContractState, to: ContractAddress) {
            assert(!to.is_zero(), 'New owner is the zero address');
            self._assertOnlyOwner();
            self._transferOwnership(to);
        }

        fn renounceOwnership(ref self: ContractState) {
            self._assertOnlyOwner();
            self._transferOwnership(Zeroable::zero());
        }

        fn name(self: @ContractState) -> felt252 {
            self._name.read()
        }

        fn symbol(self: @ContractState) -> felt252 {
            self._symbol.read()
        }

        fn balanceOf(self: @ContractState, account: ContractAddress) -> u256 {
            assert(!account.is_zero(), 'Invalid account');
            self._balances.read(account)
        }

        fn ownerOf(self: @ContractState, tokenID: u256) -> ContractAddress {
            self._ownerOf(tokenID)
        }

        fn approve(ref self: ContractState, to: ContractAddress, tokenID: u256) {
            let owner = self._ownerOf(tokenID);

            let caller = get_caller_address();
            assert(
                owner == caller || LeetLootImpl::isApprovedForAll(@self, owner, caller),
                'ERC721: unauthorized caller'
            );
            self._approve(to, tokenID);
        }

        fn setApprovalForAll(ref self: ContractState, operator: ContractAddress, approved: bool) {
            self._setApprovalForAll(get_caller_address(), operator, approved)
        }

        fn getApproved(self: @ContractState, tokenID: u256) -> ContractAddress {
            assert(self._exists(tokenID), 'ERC721: invalid token ID');
            self._tokenApprovals.read(tokenID)
        }

        fn isApprovedForAll(
            self: @ContractState, owner: ContractAddress, operator: ContractAddress
        ) -> bool {
            self._operatorApprovals.read((owner, operator))
        }

        fn transferFrom(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, tokenID: u256
        ) {
            assert(self._isApprovedOrOwner(get_caller_address(), tokenID), 'Unauthorized caller');
            self._transfer(from, to, tokenID);
        }

        fn tokenURI(self: @ContractState, tokenID: u256) -> Array::<felt252> {
            assert(self._exists(tokenID), 'Invalid token ID');
            let mut content = ArrayTrait::<felt252>::new();
            let beast: u8 = self._beasts.read(tokenID);
            let name: felt252 = getBeastName(beast);
            let prefix: felt252 = getBeastNamePrefix(self._prefixes.read(tokenID));
            let suffix: felt252 = getBeastNameSuffix(self._suffixes.read(tokenID));
            let btype: felt252 = getBeastType(beast);
            let tier: felt252 = getBeastTier(beast);
            let level: felt252 = self._levels.read(tokenID);

            // Name & description
            content.append('data:application/json;utf8,');
            content.append('{"name":"');
            content.append(prefix);
            content.append('%20');
            content.append(suffix);
            content.append('%20');
            content.append(name);
            content.append('","description":"LEETLOOT_2"');

            // Metadata
            content.append(',"attributes":[{"trait_type":');
            content.append('"prefix","value":"');
            content.append(prefix);
            content.append('"},{"trait_type":');
            content.append('"name","value":"');
            content.append(name);
            content.append('"},{"trait_type":');
            content.append('"suffix","value":"');
            content.append(suffix);
            content.append('"},{"trait_type":');
            content.append('"type","value":"');
            content.append(btype);
            content.append('"},{"trait_type":');
            content.append('"tier","value":"');
            content.append(tier);
            content.append('"},{"trait_type":');
            content.append('"level","value":"');
            content.append(level);
            content.append('"}]');

            // Image
            content.append(',"image":"');
            content.append('data:image/svg+xml;utf8,<svg%20');
            content.append('width=\\"100%\\"%20height=\\"100%\\');
            content.append('"%20viewBox=\\"0%200%2020000%202');
            content.append('0000\\"%20xmlns=\\"http://www.w3.');
            content.append('org/2000/svg\\"><style>svg{backg');
            content.append('round-image:url(');
            content.append('data:image/png;base64,');
            let ls: LongString = getBeastPixel(beast);
            let mut i = 0_usize;
            loop {
                if i == ls.len {
                    break;
                }

                content.append(*ls.content[i]);
                i += 1;
            };

            content.append(');background-repeat:no-repeat;b');
            content.append('ackground-size:contain;backgrou');
            content.append('nd-position:center;image-render');
            content.append('ing:-webkit-optimize-contrast;-');
            content.append('ms-interpolation-mode:nearest-n');
            content.append('eighbor;image-rendering:-moz-cr');
            content.append('isp-edges;image-rendering:pixel');
            content.append('ated;}</style></svg>"}');

            return content;
        }

        fn supportsInterface(self: @ContractState, interfaceId: felt252) -> bool {
            return self._supportsInterface(interfaceId);
        }

        fn registerInterface(ref self: ContractState, interface_id: felt252) {
            self._registerInterface(interface_id);
        }

        fn whitelist(ref self: ContractState, to: ContractAddress) {
            self._assertOnlyOwner();
            self._whitelist.write(to);
        }

        fn getWhitelist(self: @ContractState) -> ContractAddress {
            return self._whitelist.read();
        }

        fn isMinted(ref self: ContractState, beast: u8, prefix: u8, suffix: u8) -> bool {
            return self._minted.read(self._getBeastHash(beast, prefix, suffix));
        }

        fn mint(
            ref self: ContractState,
            to: ContractAddress,
            beast: u8,
            prefix: u8,
            suffix: u8,
            level: felt252
        ) {
            assert(!to.is_zero(), 'Invalid receiver');
            // let caller: ContractAddress = get_caller_address();
            // assert(
            //     caller == self.owner() || caller == self.getWhitelist(), 'Not owner or whitelist'
            // );
            assert(!self.isMinted(beast, prefix, suffix), 'Already minted');
            let current: u256 = self._tokenIndex.read();
            self._beasts.write(current, beast);
            self._prefixes.write(current, prefix);
            self._suffixes.write(current, suffix);
            self._levels.write(current, level);
            self._minted.write(self._getBeastHash(beast, prefix, suffix), true);
            self._mint(to);
        }


        fn tokenSupply(self: @ContractState) -> u256 {
            return self._tokenIndex.read();
        }
    }
}

#[cfg(test)]
mod tests {
    use starknet::contract_address_const;
    use starknet::ContractAddress;
    use serde::Serde;
    use array::{ArrayTrait, SpanTrait};
    use traits::{TryInto, Into};
    use option::OptionTrait;
    use result::ResultTrait;
    use super::{LongString};
    use super::{LeetLoot, ILeetLootDispatcher, ILeetLootDispatcherTrait};
    use debug::PrintTrait;

    const DEPLOYER_CONTRACT: felt252 =
        0x168893664220f03a74a9bce84228b009df46040c08bb308783dcf130790335f;

    fn deploy() -> ILeetLootDispatcher {
        let mut calldata: Array<felt252> = array::ArrayTrait::new();
        calldata.append(DEPLOYER_CONTRACT);
        calldata.append(DEPLOYER_CONTRACT);
        calldata.append('LeetLoot');
        calldata.append('LEETLOOT');

        let (addr, _) = starknet::deploy_syscall(
            LeetLoot::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .expect('Fail to deploy_syscall');

        ILeetLootDispatcher { contract_address: addr }
    }

    #[test]
    #[available_gas(1000000000000000)]
    fn test_basics() {
        let contract = deploy();
        let owner = contract.owner();
        assert(contract.name() == 'LeetLoot', 'Wrong name');
        assert(contract.symbol() == 'LEETLOOT', 'Wrong symbol');
        assert(contract.tokenSupply() == 0, 'Wrong supply');
        assert(contract.supportsInterface(0x80ac58cd), 'No support interface');
        assert(!contract.supportsInterface(0x150b7a02), 'No support interface');
        contract.registerInterface(0x150b7a02);
        assert(contract.supportsInterface(0x150b7a02), 'No support interface');
    // // Comment out because there's no good way to mock caller address yet
    // // Also, felt252 13104 is string 30
    // assert(!contract.isMinted(1, 1, 1), 'Already minted');
    // contract.mint(owner, 1, 1, 1, 13104);
    // // contract.mint(owner, 1, 1, 1, 13104); // should panic here
    // assert(contract.isMinted(1, 1, 1), 'Already minted');
    // assert(contract.isMinted(1, 1, 1), 'Already minted');
    // assert(contract.tokenSupply() == 1, 'Wrong supply');
    // let uri = contract.tokenURI(0);
    // let mut i = 0_usize;
    // loop {
    //     if i == uri.len() {
    //         break;
    //     }

    //     (*uri[i]).print();
    //     i += 1;
    // };

    // assert(!contract.isMinted(2, 2, 2), 'Already minted');
    // contract.mint(owner, 2, 2, 2, 13104);
    // assert(contract.tokenSupply() == 2, 'Wrong supply');
    }
}
