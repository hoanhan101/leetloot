//
// LeetLoot is an onchain pixel art collection.
// It consists of 75 Beasts for Loot Survivor, an onchain arcade machine game.
// ERC721 implementation is based on OpenZeppelin's.
// By hoanh.eth & the 1337 5325.
//

use starknet::ContractAddress;
use super::long_string::LongString;
use super::beast;

// LeetLoot interface.
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

    // Main
    fn whitelist(ref self: T, to: ContractAddress);
    fn getWhitelist(self: @T) -> ContractAddress;
    fn mint(ref self: T, to: ContractAddress, beast: u8);
    fn tokenURI(self: @T, tokenID: u256) -> felt252;
    fn tokenSVG(self: @T, tokenID: u256) -> Array::<felt252>;
}

// LeetLoot contract.
#[starknet::contract]
mod LeetLoot {
    use array::{ArrayTrait};
    use core::traits::{Into};
    use super::{ILeetLoot, LongString};
    use starknet::get_caller_address;
    use starknet::ContractAddress;
    use zeroable::Zeroable;
    use super::beast::{CHIMERA, getBeastName, getBeastPixel};

    const ISRC5_ID: felt252 = 0x3f918d17e5ee77373b56385708f855659a07f75997f365cf87748628532a055;
    const IERC721_ID: felt252 = 0x33eb2f84c309543403fd69f0d0f363781ef06ef6faeb0131ff16ea3175bd943;
    const IERC721_METADATA_ID: felt252 =
        0x6069a70848f907fa57668ba1875164eb4dcee693952468581406d131081bbd;

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

            self._name.write(name);
            self._symbol.write(symbol);
        }

        fn _assert_only_owner(self: @ContractState) {
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
        }

        fn _setApprovalForAll(
            ref self: ContractState,
            owner: ContractAddress,
            operator: ContractAddress,
            approved: bool
        ) {
            assert(owner != operator, 'ERC721: self approval');
            self._operatorApprovals.write((owner, operator), approved);
        }

        fn _is_approved_or_owner(
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
        }
    }

    #[external(v0)]
    impl LeetLootImpl of ILeetLoot<ContractState> {
        fn owner(self: @ContractState) -> ContractAddress {
            self._owner.read()
        }

        fn transferOwnership(ref self: ContractState, to: ContractAddress) {
            assert(!to.is_zero(), 'New owner is the zero address');
            self._assert_only_owner();
            self._transferOwnership(to);
        }

        fn renounceOwnership(ref self: ContractState) {
            self._assert_only_owner();
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
            assert(
                self._is_approved_or_owner(get_caller_address(), tokenID), 'Unauthorized caller'
            );
            self._transfer(from, to, tokenID);
        }

        fn tokenURI(self: @ContractState, tokenID: u256) -> felt252 {
            assert(self._exists(tokenID), 'Invalid token ID');
            return '1337';
        }

        fn supportsInterface(self: @ContractState, interfaceId: felt252) -> bool {
            return self._supportsInterface(interfaceId);
        }

        fn whitelist(ref self: ContractState, to: ContractAddress) {
            self._assert_only_owner();
            self._whitelist.write(to);
        }

        fn getWhitelist(self: @ContractState) -> ContractAddress {
            return self._whitelist.read();
        }

        fn mint(ref self: ContractState, to: ContractAddress, beast: u8) {
            assert(!to.is_zero(), 'Invalid receiver');
            assert(to == self.getWhitelist() || to == self.owner(), 'Not owner or whitelist');
            self._beasts.write(self._tokenIndex.read(), beast);
            self._mint(to);
        }

        fn tokenSVG(self: @ContractState, tokenID: u256) -> Array::<felt252> {
            assert(tokenID <= self._tokenIndex.read(), 'Invalid token ID');
            let mut content = ArrayTrait::<felt252>::new();
            content.append('<svg id="leetart" width="100%" ');
            content.append('height="100%" viewBox="0 0 2000');
            content.append('0 20000" xmlns="http://www.w3.o');
            content.append('rg/2000/svg"><style>#leetart{ba');
            content.append('ckground-image:url(data:image/p');
            content.append('ng;base64,');

            let ls: LongString = getBeastPixel(self._beasts.read(tokenID));
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
            content.append('ated;}</style></svg>');

            return content;
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
    #[available_gas(2000000000)]
    fn mock() {
        let contract = deploy();
        contract.owner().print();
        assert(contract.name() == 'LeetLoot', 'Wrong name');
        assert(contract.symbol() == 'LEETLOOT', 'Wrong symbol');

        contract.mint(contract.owner(), 9);

        let mut content = ArrayTrait::<felt252>::new();
        content.append('<svg id="leetart" width="100%" ');
        content.append('height="100%" viewBox="0 0 2000');
        content.append('0 20000" xmlns="http://www.w3.o');
        content.append('rg/2000/svg"><style>#leetart{ba');
        content.append('ckground-image:url(data:image/p');
        content.append('iVBORw0KGgoAAAANSUhEUgAAACAAAAA');
        content.append('gCAYAAABzenr0AAAAAXNSR0IArs4c6Q');
        content.append('AAAXxJREFUWIXFV8kNwzAMU4Iulp0yR');
        content.append('nbKaO2ndhWGFJ2ihwAj9aWDutwpIu7x');
        content.append('R7q5A1vs/fcay1eUuKuxxU6/nxyz064');
        content.append('hkJEYmV+hEgG0Os8/gcwBgS32PiJePv');
        content.append('9mHHQFttg78zUWCmlec/ujNMUzDbPVT');
        content.append('RlEwgl5B50ZhWclGNM1FiqIrWV3qmCO');
        content.append('eCOYcnCqu1Ww5vs0BhSp1GPrOYAzsgy');
        content.append('tIQSUFZiqjBeeBTk83yslGGMHtXLLjJ');
        content.append('Co9MLMYKQyqErfUyFiF9CfyITtYxFTP');
        content.append('AMhcb52Ue/cgEMioOBmFrJ7Dvo2nzPj');
        content.append('CmampFMeixZzB23HrqYzRg4BRfY9kAX');
        content.append('kL+5VbmhIMB69GaF1SglnnVMGDRpGgA');
        content.append('nA9Uo4Cm50WQHVM1Q7b1+l0KEZOfiZB');
        content.append('Ti/isDpQaKEIyNXFfOZig4PEidcpV0m');
        content.append('dsbJGOqGIyVYtNuy3U/PjaH3HEujtq7');
        content.append('SjN3N+10BdbFickVQ3kP3uRfLUNcb3S');
        content.append('fjd/8D2TiV4l/TA52mfrhX+5pzAAAAA');
        content.append('ElFTkSuQmCC');
        content.append(');background-repeat:no-repeat;b');
        content.append('ackground-size:contain;backgrou');
        content.append('nd-position:center;image-render');
        content.append('ing:-webkit-optimize-contrast;-');
        content.append('ms-interpolation-mode:nearest-n');
        content.append('eighbor;image-rendering:-moz-cr');
        content.append('isp-edges;image-rendering:pixel');
        content.append('ated;}</style></svg>');

        let art: Array<felt252> = contract.tokenSVG(0);
        art.len().print();
        assert(art.len() == 34_usize, 'Wrong length');
    }
}
