//
// @title LeetLoot is an onchain pixel art collection.
// It consists of 75 characters for Loot Survivor, an onchain arcade machine game.
// @author hoanh.eth
//

use super::long_string::LongString;

// LeetLoot interface.
#[starknet::interface]
trait ILeetLoot<T> {
    fn name(ref self: T, key: felt252, content: felt252);
    fn getName(self: @T, key: felt252) -> felt252;
    fn storeArt(ref self: T, key: felt252, name: felt252, content: LongString);
    fn getArt(self: @T, key: felt252) -> LongString;
    fn getArtSVG(self: @T, key: felt252) -> Array::<felt252>;
    fn getArtSVGLongSring(self: @T, key: felt252) -> LongString;
}

// LeetLoot contract.
#[starknet::contract]
mod LeetLoot {
    use super::{ILeetLoot, LongString};
    use array::{ArrayTrait};
    use core::traits::{Into};


    #[storage]
    struct Storage {
        names: LegacyMap<felt252, felt252>,
        arts: LegacyMap<felt252, LongString>,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
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
        self.storeArt(0, 'Chimera', ls);
    }

    #[external(v0)]
    impl MyContract of ILeetLoot<ContractState> {
        fn name(ref self: ContractState, key: felt252, content: felt252) {
            self.names.write(key, content);
        }

        fn getName(self: @ContractState, key: felt252) -> felt252 {
            return self.names.read(key);
        }

        fn storeArt(ref self: ContractState, key: felt252, name: felt252, content: LongString) {
            self.name(key, name);
            self.arts.write(key, content);
        }

        fn getArt(self: @ContractState, key: felt252) -> LongString {
            return self.arts.read(key);
        }

        fn getArtSVG(self: @ContractState, key: felt252) -> Array::<felt252> {
            let mut content = ArrayTrait::<felt252>::new();
            content.append('<svg id="leetart" width="100%" ');
            content.append('height="100%" viewBox="0 0 2000');
            content.append('0 20000" xmlns="http://www.w3.o');
            content.append('rg/2000/svg"><style>#leetart{ba');
            content.append('ckground-image:url(');

            let ls: LongString = self.arts.read(key);
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

        fn getArtSVGLongSring(self: @ContractState, key: felt252) -> LongString {
            return self.getArtSVG(key).into();
        }
    }
}

#[cfg(test)]
mod tests {
    use serde::Serde;
    use array::{ArrayTrait, SpanTrait};
    use traits::{TryInto, Into};
    use option::OptionTrait;
    use result::ResultTrait;
    use super::{LongString};
    use super::{LeetLoot, ILeetLootDispatcher, ILeetLootDispatcherTrait};

    fn deploy() -> ILeetLootDispatcher {
        let mut calldata: Array<felt252> = array::ArrayTrait::new();
        let (addr, _) = starknet::deploy_syscall(
            LeetLoot::TEST_CLASS_HASH.try_into().unwrap(), 0, calldata.span(), false
        )
            .expect('failed deploy_syscall');

        ILeetLootDispatcher { contract_address: addr }
    }


    #[test]
    #[available_gas(2000000000)]
    fn simple() {
        let contract = deploy();

        let mut content = ArrayTrait::<felt252>::new();
        content.append('foo');
        content.append('bar');
        content.append('foobar');

        let ls: LongString = content.into();
        assert(ls.len == 3, 'Unequal length');
        assert(ls.content.len() == 3, 'Unequal length');
        assert(*ls.content[0] == 'foo', 'Wrong content 0');
        assert(*ls.content[1] == 'bar', 'Wrong content 1');
        assert(*ls.content[2] == 'foobar', 'Wrong content 2');

        contract.storeArt(0, 'Test', ls);
        assert(contract.getName(0) == 'Test', 'Wrong name');
        assert(contract.getArt(0) == ls, 'Wrong art');
    }

    #[test]
    #[available_gas(2000000000)]
    fn mock() {
        let contract = deploy();

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

        let ls: LongString = content.into();
        assert(contract.getName(0) == 'Chimera', 'Wrong name');
        assert(contract.getArtSVGLongSring(0) == ls, 'Wrong art');
    }
}
