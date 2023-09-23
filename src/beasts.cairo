//
// Beasts is an onchain pixel art collection
// It consists of 75 Beasts for Loot Survivor, an onchain arcade machine game
// ERC721 implementation is based on OpenZeppelin's
// By hoanh.eth
//

use super::long_string::LongString;
use super::beast;

#[starknet::contract]
mod Beasts {
    use array::{ArrayTrait};
    use traits::{Into, TryInto};
    use option::OptionTrait;
    use zeroable::Zeroable;
    use poseidon::poseidon_hash_span;
    use integer::{
        U8IntoFelt252, Felt252TryIntoU16, U16DivRem, u16_as_non_zero, U16IntoFelt252,
        Felt252TryIntoU8
    };

    use starknet::get_caller_address;
    use starknet::ContractAddress;
    use starknet::storage_access::StorePacking;

    use openzeppelin::utils::constants::{IERC721_ID, IERC721_METADATA_ID, ISRC5_ID};

    use LootSurvivorBeasts::long_string::{LongString};
    use LootSurvivorBeasts::interfaces::{IBeasts};
    use LootSurvivorBeasts::pack::{mask, pow, PackableBeast};
    use LootSurvivorBeasts::beast::{get_hash, get_content};

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
        _minted: LegacyMap::<felt252, bool>,
        _beast: LegacyMap<u256, PackableBeast>
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
            let caller: ContractAddress = get_caller_address();
            assert(!caller.is_zero(), 'Zero address');
            assert(caller == self.owner(), 'Not owner');
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
            let isApprovedForAll = BeastsImpl::isApprovedForAll(self, owner, spender);
            owner == spender
                || isApprovedForAll
                || spender == BeastsImpl::getApproved(self, tokenID)
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
    }

    #[external(v0)]
    impl BeastsImpl of IBeasts<ContractState> {
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
                owner == caller || BeastsImpl::isApprovedForAll(@self, owner, caller),
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
            let beast = self._beast.read(tokenID);
            get_content(beast)
        }

        fn supportsInterface(self: @ContractState, interfaceId: felt252) -> bool {
            self._supportsInterface(interfaceId)
        }

        fn registerInterface(ref self: ContractState, interface_id: felt252) {
            self._registerInterface(interface_id);
        }

        fn setMinter(ref self: ContractState, to: ContractAddress) {
            self._assertOnlyOwner();
            self._whitelist.write(to);
        }

        fn getMinter(self: @ContractState) -> ContractAddress {
            return self._whitelist.read();
        }

        fn isMinted(self: @ContractState, beast: u8, prefix: u8, suffix: u8) -> bool {
            self._minted.read(get_hash(beast, prefix, suffix))
        }

        fn mint(
            ref self: ContractState,
            to: ContractAddress,
            beast: u8,
            prefix: u8,
            suffix: u8,
            level: u16
        ) {
            assert(!to.is_zero(), 'Invalid receiver');
            let caller: ContractAddress = get_caller_address();
            assert(caller == self.getMinter(), 'Not authorized to mint');
            assert(!self.isMinted(beast, prefix, suffix), 'Already minted');
            let current: u256 = self._tokenIndex.read();

            self._beast.write(current, PackableBeast { id: beast, prefix, suffix, level });

            self._minted.write(get_hash(beast, prefix, suffix), true);
            self._mint(to);
        }


        fn tokenSupply(self: @ContractState) -> u256 {
            self._tokenIndex.read()
        }

        fn mintGenesisBeasts(ref self: ContractState, to: ContractAddress) {
            self._assertOnlyOwner();

            let mut id = 1;
            loop {
                if id == 76 {
                    break;
                }
                let current: u256 = self._tokenIndex.read();
                self
                    ._beast
                    .write(current, PackableBeast { id: id, prefix: 0, suffix: 0, level: 0 });
                self._minted.write(get_hash(id, 0, 0), true);
                self._mint(to);

                id += 1;
            }
        }
    }
}

