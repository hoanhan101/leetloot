//
// LeetLoot is an onchain pixel art collection.
// It consists of 75 characters for Loot Survivor, an onchain arcade machine game.
// ERC721 implementation is based on OpenZeppelin's implementation.
// By hoanh.eth
//

use starknet::ContractAddress;
use super::long_string::LongString;

// LeetLoot interface.
#[starknet::interface]
trait ILeetLoot<T> {
    // Ownership
    fn owner(self: @T) -> ContractAddress;
    fn transfer_ownership(ref self: T, new_owner: ContractAddress);
    fn renounce_ownership(ref self: T);

    // ERC721
    fn name(self: @T) -> felt252;
    fn symbol(self: @T) -> felt252;
    fn balance_of(self: @T, account: ContractAddress) -> u256;
    fn owner_of(self: @T, token_id: u256) -> ContractAddress;
    fn transfer_from(ref self: T, from: ContractAddress, to: ContractAddress, token_id: u256);
    fn approve(ref self: T, to: ContractAddress, token_id: u256);
    fn set_approval_for_all(ref self: T, operator: ContractAddress, approved: bool);
    fn get_approved(self: @T, token_id: u256) -> ContractAddress;
    fn is_approved_for_all(self: @T, owner: ContractAddress, operator: ContractAddress) -> bool;
    fn token_uri(self: @T, token_id: u256) -> felt252;

    // Main
    fn artName(self: @T, key: felt252) -> felt252;
    fn artSVG(self: @T, key: felt252) -> Array::<felt252>;
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

    #[storage]
    struct Storage {
        _owner: ContractAddress,
        _name: felt252,
        _symbol: felt252,
        _owners: LegacyMap<u256, ContractAddress>,
        _balances: LegacyMap<ContractAddress, u256>,
        _token_approvals: LegacyMap<u256, ContractAddress>,
        _operator_approvals: LegacyMap<(ContractAddress, ContractAddress), bool>,
        _token_uri: LegacyMap<u256, felt252>,
        _token_index: u256,
        _artsNames: LegacyMap<felt252, felt252>,
        _arts: LegacyMap<felt252, LongString>,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState, owner: ContractAddress, name: felt252, symbol: felt252
    ) {
        self.initializer(owner, name, symbol);

        self._mint(owner);

        let mut content = ArrayTrait::<felt252>::new();
        content.append('data:image/png;base64,iVBORw0KG');
        content.append('goAAAANSUhEUgAAACAAAAAgCAYAAABz');
        content.append('enr0AAAAAXNSR0IArs4c6QAAAXdJREF');
        content.append('UWIXFVkkOwyAMNFEfnSfwa3opiTPM2B');
        content.append('ClrSVEwuJlvFHMrNkf6ZUdaPX8Lvt3l');
        content.append('GhqtMrnJ8eWalevM66r/xUKEUCr/f8T');
        content.append('yFwQaPUcZqfPvxkHhwKtnszLziH1a9n');
        content.append('+LBX7pKG3uiuDSGRC7qCzoXCvBGNadi');
        content.append('6IrXl3qmA2uxFMPjjV3ShY/X0aA4pU6');
        content.append('rF1H8AeWT8vIaCswFRlvPAsyOH5HinB');
        content.append('GGdQK7dsCIlKL8wMRiqDovQdChG7gP5');
        content.append('EJmwfi5jiaRb42Ez7T0V95gYcEgEFN7');
        content.append('OQ3cug7/+HAhnMTMlMeSxazB20HWc1n');
        content.append('THKEFCUvge8AD/jXuSGjgTjcTQjtE4p');
        content.append('kVmXKYMGTSPABOB6JBwFd1pWQPUM1c7');
        content.append('7rBS6NKMMfmbB0FgWERgeJEr4UL2Squ');
        content.append('jPRHR5kGTCVdp5YmcyGVPdcKYEi3Ybt');
        content.append('vvy2Zh6z7E06usqzdhdv38ooC5GTFYE');
        content.append('+b2hn6iOx4bqerP7ZNy++MgYSvGv6Q3');
        content.append('l4pZkdWJdwgAAAABJRU5ErkJggg==');

        let ls: LongString = content.into();
        self._storeArt(0, 'Chimera', ls);
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn initializer(
            ref self: ContractState, owner: ContractAddress, name: felt252, symbol: felt252
        ) {
            self._transfer_ownership(owner);
            self._name.write(name);
            self._symbol.write(symbol);
        }

        fn _assert_only_owner(self: @ContractState) {
            let owner: ContractAddress = self._owner.read();
            let caller: ContractAddress = get_caller_address();
            assert(!caller.is_zero(), 'Zero address');
            assert(caller == owner, 'Not owner');
        }

        fn _transfer_ownership(ref self: ContractState, new_owner: ContractAddress) {
            let previous_owner: ContractAddress = self._owner.read();
            self._owner.write(new_owner);
        }

        fn _owner_of(self: @ContractState, token_id: u256) -> ContractAddress {
            let owner = self._owners.read(token_id);
            match owner.is_zero() {
                bool::False(()) => owner,
                bool::True(()) => panic_with_felt252('Invalid token ID')
            }
        }

        fn _approve(ref self: ContractState, to: ContractAddress, token_id: u256) {
            let owner = self._owner_of(token_id);
            assert(owner != to, 'ERC721: approval to owner');

            self._token_approvals.write(token_id, to);
        }

        fn _set_approval_for_all(
            ref self: ContractState,
            owner: ContractAddress,
            operator: ContractAddress,
            approved: bool
        ) {
            assert(owner != operator, 'ERC721: self approval');
            self._operator_approvals.write((owner, operator), approved);
        }

        fn _is_approved_or_owner(
            self: @ContractState, spender: ContractAddress, token_id: u256
        ) -> bool {
            let owner = self._owner_of(token_id);
            let is_approved_for_all = LeetLootImpl::is_approved_for_all(self, owner, spender);
            owner == spender
                || is_approved_for_all
                || spender == LeetLootImpl::get_approved(self, token_id)
        }

        fn _exists(self: @ContractState, token_id: u256) -> bool {
            !self._owners.read(token_id).is_zero()
        }

        fn _transfer(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, token_id: u256
        ) {
            assert(!to.is_zero(), 'ERC721: invalid receiver');
            let owner = self._owner_of(token_id);
            assert(from == owner, 'ERC721: wrong sender');

            self._token_approvals.write(token_id, Zeroable::zero());

            self._balances.write(from, self._balances.read(from) - 1);
            self._balances.write(to, self._balances.read(to) + 1);
            self._owners.write(token_id, to);
        }

        fn _mint(ref self: ContractState, to: ContractAddress) {
            assert(!to.is_zero(), 'Invalid receiver');
            let current: u256 = self._token_index.read();
            self._balances.write(to, self._balances.read(to) + 1);
            self._owners.write(current, to);
            self._token_index.write(current + 1);
        }

        fn _storeArt(ref self: ContractState, key: felt252, name: felt252, content: LongString) {
            self._artsNames.write(key, name);
            self._arts.write(key, content);
        }
    }

    #[external(v0)]
    impl LeetLootImpl of ILeetLoot<ContractState> {
        fn owner(self: @ContractState) -> ContractAddress {
            self._owner.read()
        }

        fn transfer_ownership(ref self: ContractState, new_owner: ContractAddress) {
            assert(!new_owner.is_zero(), 'New owner is the zero address');
            self._assert_only_owner();
            self._transfer_ownership(new_owner);
        }

        fn renounce_ownership(ref self: ContractState) {
            self._assert_only_owner();
            self._transfer_ownership(Zeroable::zero());
        }

        fn name(self: @ContractState) -> felt252 {
            self._name.read()
        }

        fn symbol(self: @ContractState) -> felt252 {
            self._symbol.read()
        }

        fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
            assert(!account.is_zero(), 'Invalid account');
            self._balances.read(account)
        }

        fn owner_of(self: @ContractState, token_id: u256) -> ContractAddress {
            self._owner_of(token_id)
        }

        fn approve(ref self: ContractState, to: ContractAddress, token_id: u256) {
            let owner = self._owner_of(token_id);

            let caller = get_caller_address();
            assert(
                owner == caller || LeetLootImpl::is_approved_for_all(@self, owner, caller),
                'ERC721: unauthorized caller'
            );
            self._approve(to, token_id);
        }

        fn set_approval_for_all(
            ref self: ContractState, operator: ContractAddress, approved: bool
        ) {
            self._set_approval_for_all(get_caller_address(), operator, approved)
        }

        fn get_approved(self: @ContractState, token_id: u256) -> ContractAddress {
            assert(self._exists(token_id), 'ERC721: invalid token ID');
            self._token_approvals.read(token_id)
        }

        fn is_approved_for_all(
            self: @ContractState, owner: ContractAddress, operator: ContractAddress
        ) -> bool {
            self._operator_approvals.read((owner, operator))
        }

        fn transfer_from(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, token_id: u256
        ) {
            assert(
                self._is_approved_or_owner(get_caller_address(), token_id), 'Unauthorized caller'
            );
            self._transfer(from, to, token_id);
        }

        fn token_uri(self: @ContractState, token_id: u256) -> felt252 {
            assert(self._exists(token_id), 'Invalid token ID');
            self._token_uri.read(token_id)
        }

        fn artName(self: @ContractState, key: felt252) -> felt252 {
            return self._artsNames.read(key);
        }

        fn artSVG(self: @ContractState, key: felt252) -> Array::<felt252> {
            let mut content = ArrayTrait::<felt252>::new();
            content.append('<svg id="leetart" width="100%" ');
            content.append('height="100%" viewBox="0 0 2000');
            content.append('0 20000" xmlns="http://www.w3.o');
            content.append('rg/2000/svg"><style>#leetart{ba');
            content.append('ckground-image:url(');

            let ls: LongString = self._arts.read(key);
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

    fn deploy() -> ILeetLootDispatcher {
        let mut calldata: Array<felt252> = array::ArrayTrait::new();
        calldata.append('1');
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
        assert(contract.balance_of(contract.owner()) == 1_u256, 'Wrong symbol');

        let mut content = ArrayTrait::<felt252>::new();
        content.append('<svg id="leetart" width="100%" ');
        content.append('height="100%" viewBox="0 0 2000');
        content.append('0 20000" xmlns="http://www.w3.o');
        content.append('rg/2000/svg"><style>#leetart{ba');
        content.append('ckground-image:url(');
        content.append('data:image/png;base64,iVBORw0KG');
        content.append('goAAAANSUhEUgAAACAAAAAgCAYAAABz');
        content.append('enr0AAAAAXNSR0IArs4c6QAAAXdJREF');
        content.append('UWIXFVkkOwyAMNFEfnSfwa3opiTPM2B');
        content.append('ClrSVEwuJlvFHMrNkf6ZUdaPX8Lvt3l');
        content.append('GhqtMrnJ8eWalevM66r/xUKEUCr/f8T');
        content.append('yFwQaPUcZqfPvxkHhwKtnszLziH1a9n');
        content.append('+LBX7pKG3uiuDSGRC7qCzoXCvBGNadi');
        content.append('6IrXl3qmA2uxFMPjjV3ShY/X0aA4pU6');
        content.append('rF1H8AeWT8vIaCswFRlvPAsyOH5HinB');
        content.append('GGdQK7dsCIlKL8wMRiqDovQdChG7gP5');
        content.append('EJmwfi5jiaRb42Ez7T0V95gYcEgEFN7');
        content.append('OQ3cug7/+HAhnMTMlMeSxazB20HWc1n');
        content.append('THKEFCUvge8AD/jXuSGjgTjcTQjtE4p');
        content.append('kVmXKYMGTSPABOB6JBwFd1pWQPUM1c7');
        content.append('7rBS6NKMMfmbB0FgWERgeJEr4UL2Squ');
        content.append('jPRHR5kGTCVdp5YmcyGVPdcKYEi3Ybt');
        content.append('vvy2Zh6z7E06usqzdhdv38ooC5GTFYE');
        content.append('+b2hn6iOx4bqerP7ZNy++MgYSvGv6Q3');
        content.append('l4pZkdWJdwgAAAABJRU5ErkJggg==');
        content.append(');background-repeat:no-repeat;b');
        content.append('ackground-size:contain;backgrou');
        content.append('nd-position:center;image-render');
        content.append('ing:-webkit-optimize-contrast;-');
        content.append('ms-interpolation-mode:nearest-n');
        content.append('eighbor;image-rendering:-moz-cr');
        content.append('isp-edges;image-rendering:pixel');
        content.append('ated;}</style></svg>');

        assert(contract.artName(0) == 'Chimera', 'Wrong name');
        let art: Array<felt252> = contract.artSVG(0);
        art.len().print();
        assert(art.len() == 33_usize, 'Wrong length');
    }
}
