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
    use debug::PrintTrait;
    use starknet::testing::{set_caller_address};

    fn DAO() -> ContractAddress {
        contract_address_const::<0x168893664220f03a74a9bce84228b009df46040c08bb308783dcf130790335f>()
    }

    fn deploy() -> IBeastsDispatcher {
        set_caller_address(DAO());

        let calldata = array![DAO().into(), DAO().into(), 'Beasts', 'Beasts'];

        let (addr, _) = starknet::deploy_syscall(
            Beasts::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .expect('Fail to deploy_syscall');

        IBeastsDispatcher { contract_address: addr }
    }
    #[test]
    #[available_gas(1000000000000000)]
    fn test_deploy_args() {
        let contract = deploy();
        let owner = contract.owner();

        assert(contract.name() == 'Beasts', 'Wrong name');
        assert(contract.symbol() == 'Beasts', 'Wrong symbol');
        assert(contract.tokenSupply() == 0, 'Wrong supply');
    }

    #[test]
    #[available_gas(1000000000000000)]
    fn test_mint_genesis() {
        let contract = deploy();
        let owner = contract.owner();

        assert(DAO().into() == owner, 'Wrong owner');
        set_caller_address(DAO());
        contract.mintGenesis(DAO());

        assert(starknet::get_caller_address() == owner, 'Wrong caller');
        assert(contract.tokenSupply() == 75, 'Wrong supply');
        contract.tokenURI(1).print();
    }
}
// assert(contract.supportsInterface(0x80ac58cd), 'No support interface');
// assert(!contract.supportsInterface(0x150b7a02), 'No support interface');
// contract.registerInterface(0x150b7a02);
// assert(contract.supportsInterface(0x150b7a02), 'No support interface');
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


