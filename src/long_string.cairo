//
// LongString is a list of felt252 with defined length.
// Based on https://gist.github.com/glihm/cc83a37f549f1c4e7b3a25fd8aa193cd
//

use array::{ArrayTrait, SpanTrait};
use integer::{U8IntoFelt252, U32IntoFelt252, Felt252TryIntoU32};
use option::OptionTrait;
use serde::Serde;
use starknet::{SyscallResult, Store, StorageBaseAddress};
use traits::{Into, TryInto};

#[derive(Copy, Drop)]
struct LongString {
    len: usize,
    content: Span<felt252>,
}

// Initialize from Array<felt252>.
impl ArrayIntoLongString of Into<Array<felt252>, LongString> {
    fn into(self: Array<felt252>) -> LongString {
        LongString { len: self.len(), content: self.span() }
    }
}

/// Comparison implementation.
impl PartialEqLongString of PartialEq<LongString> {
    fn eq(lhs: @LongString, rhs: @LongString) -> bool {
        if lhs.len != rhs.len {
            return false;
        }

        let mut i = 0_usize;
        return loop {
            if i == *lhs.len {
                break true;
            }

            if lhs.content[i] != rhs.content[i] {
                break false;
            }

            i += 1;
        };
    }

    fn ne(lhs: @LongString, rhs: @LongString) -> bool {
        if lhs.len != rhs.len {
            return true;
        }

        let mut i = 0_usize;
        return loop {
            if i == *lhs.len {
                break false;
            }

            if lhs.content[i] != rhs.content[i] {
                break true;
            }

            i += 1;
        };
    }
}

// Serialization implementation.
impl LongStringSerde of serde::Serde<LongString> {
    fn serialize(self: @LongString, ref output: Array<felt252>) {
        self.content.serialize(ref output);
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<LongString> {
        let content = Serde::<Span<felt252>>::deserialize(ref serialized)?;
        Option::Some(LongString { len: content.len(), content, })
    }
}

// LegacyHash implementation.
impl LongStringLegacyHash of hash::LegacyHash<LongString> {
    fn hash(state: felt252, value: LongString) -> felt252 {
        let mut buf: Array<felt252> = ArrayTrait::new();
        value.serialize(ref buf);

        let k = poseidon::poseidon_hash_span(buf.span());
        hash::LegacyHash::hash(state, k)
    }
}

// StorageAccess implementation with a max length of 256.
impl LongStringStorageAccess of starknet::Store<LongString> {
    fn read(
        address_domain: u32, base: starknet::StorageBaseAddress
    ) -> SyscallResult::<LongString> {
        let len = Store::<u32>::read(address_domain, base)?;

        let mut content: Array<felt252> = ArrayTrait::new();
        let mut offset: u8 = 1;
        loop {
            if offset.into() == len + 1 {
                break ();
            }

            match starknet::storage_read_syscall(
                address_domain, starknet::storage_address_from_base_and_offset(base, offset)
            ) {
                Result::Ok(r) => content.append(r),
                Result::Err(e) => panic(e)
            };

            offset += 1;
        };

        SyscallResult::Ok(LongString { len, content: content.span(), })
    }

    fn write(
        address_domain: u32, base: StorageBaseAddress, value: LongString
    ) -> SyscallResult::<()> {
        assert(value.len < 255, 'Max length');

        Store::<u32>::write(address_domain, base, value.len)?;

        let mut offset: u8 = 1;

        loop {
            if offset.into() == value.len + 1 {
                break ();
            }

            let index = offset - 1;
            let chunk = value.content[index.into()];

            match starknet::storage_write_syscall(
                address_domain, starknet::storage_address_from_base_and_offset(base, offset), *chunk
            ) {
                Result::Ok(r) => r,
                Result::Err(e) => panic(e),
            }

            offset += 1;
        };

        SyscallResult::Ok(())
    }

    fn read_at_offset(
        address_domain: u32, base: StorageBaseAddress, offset: u8
    ) -> SyscallResult<LongString> {
        Self::read_at_offset(address_domain, base, offset)
    }

    fn write_at_offset(
        address_domain: u32, base: StorageBaseAddress, offset: u8, value: LongString
    ) -> SyscallResult<()> {
        Self::write_at_offset(address_domain, base, offset, value)
    }

    fn size() -> u8 {
        // this is wrong, but it's not used anywhere
        0
    }
}
