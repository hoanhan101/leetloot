#[cfg(test)]
mod tests {
    use starknet::contract_address_const;
    use starknet::ContractAddress;
    use serde::Serde;
    use array::{ArrayTrait, SpanTrait};
    use traits::{TryInto, Into};
    use option::OptionTrait;
    use result::ResultTrait;
    use LootSurvivorBeasts::beasts::{LongString, Beasts};
    use LootSurvivorBeasts::interfaces::{IBeastsDispatcher, IBeastsDispatcherTrait};
    use starknet::testing::{set_caller_address, set_contract_address};

    fn DAO() -> ContractAddress {
        contract_address_const::<0x168893664220f03a74a9bce84228b009df46040c08bb308783dcf130790335f>()
    }

    fn deploy() -> IBeastsDispatcher {
        set_caller_address(DAO());
        set_contract_address(DAO());

        let calldata = array![DAO().into(), DAO().into(), 'Beasts', 'Beasts'];

        let (addr, _) = starknet::deploy_syscall(
            Beasts::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .expect('Fail to deploy_syscall');

        IBeastsDispatcher { contract_address: addr }
    }
    #[test]
    #[available_gas(1000000)]
    fn test_deploy_args() {
        let contract = deploy();
        let owner = contract.owner();

        assert(DAO().into() == owner, 'Wrong owner');
        assert(contract.name() == 'Beasts', 'Wrong name');
        assert(contract.symbol() == 'Beasts', 'Wrong symbol');
        assert(contract.tokenSupply() == 0, 'Wrong supply');
    }

    #[test]
    #[available_gas(136114530)]
    fn test_mint_genesis() {
        let contract = deploy();
        let owner = contract.owner();

        contract.mintGenesis(owner);
        assert(starknet::get_caller_address() == owner, 'Wrong caller');
        assert(contract.tokenSupply() == 75, 'Wrong supply');
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
        contract.mint(owner, 1, 1, 1, 13104);
        assert(contract.isMinted(1, 1, 1), 'Already minted');
        assert(contract.tokenSupply() == 1, 'Wrong supply');
    }
}
