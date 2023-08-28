#[cfg(test)]
mod tests {
    use starknet::contract_address_const;
    use starknet::ContractAddress;
    use serde::Serde;
    use array::{ArrayTrait, SpanTrait};
    use traits::{TryInto, Into};
    use option::OptionTrait;
    use result::ResultTrait;
    use leetloot::loot::{LongString};
    use leetloot::loot::{LeetLoot, ILeetLootDispatcher, ILeetLootDispatcherTrait};
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
