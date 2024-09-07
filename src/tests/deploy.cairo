#[cfg(test)]
mod tests {
    use starknet::contract_address_const;
    use starknet::ContractAddress;
    use serde::Serde;
    use array::{ArrayTrait, SpanTrait};
    use traits::{TryInto, Into};
    use option::OptionTrait;
    use result::ResultTrait;
    use beasts::beasts::{LongString, Beasts};
    use beasts::interfaces::{IBeastsDispatcher, IBeastsDispatcherTrait};
    use starknet::testing::{set_caller_address, set_contract_address};

    fn OWNER() -> ContractAddress {
        contract_address_const::<
            0x168893664220f03a74a9bce84228b009df46040c08bb308783dcf130790335f
        >()
    }

    fn deploy() -> IBeastsDispatcher {
        set_caller_address(OWNER());
        set_contract_address(OWNER());

        let calldata = array![OWNER().into(), 'Beasts', 'Beasts'];

        let (addr, _) = starknet::deploy_syscall(
            Beasts::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), true
        )
            .expect('Fail to deploy_syscall');

        IBeastsDispatcher { contract_address: addr }
    }
    #[test]
    #[available_gas(1000000)]
    fn test_deploy_args() {
        let contract = deploy();
        let owner = contract.owner();

        assert(OWNER().into() == owner, 'Wrong owner');
        assert(contract.name() == 'Beasts', 'Wrong name');
        assert(contract.symbol() == 'Beasts', 'Wrong symbol');
        assert(contract.tokenSupply() == 0, 'Wrong supply');
    }

    #[test]
    #[available_gas(3000000)]
    #[should_panic(expected: ('Not authorized to mint', 'ENTRYPOINT_FAILED'))]
    fn test_mint_not_authorized() {
        let contract = deploy();
        let owner = contract.owner();
        contract.mint(owner, 1, 1, 1, 13104, 1);
    }

    #[test]
    #[available_gas(3000000)]
    fn test_mint() {
        let contract = deploy();
        let owner = contract.owner();

        assert(contract.supportsInterface(0x80ac58cd), 'No support interface');
        assert(!contract.supportsInterface(0x150b7a02), 'No support interface');
        contract.registerInterface(0x150b7a02);
        assert(contract.supportsInterface(0x150b7a02), 'No support interface');
        assert(!contract.isMinted(1, 1, 1), 'Already minted');
        assert(!contract.isMinted(1, 1, 1), 'Not minted');
        contract.setMinter(owner);
        contract.mint(owner, 1, 1, 1, 13104, 1);
        assert(contract.isMinted(1, 1, 1), 'Already minted');
        assert(contract.tokenSupply() == 1, 'Wrong supply');
    }
}
