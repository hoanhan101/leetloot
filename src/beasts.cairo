//
// Beasts is an onchain pixel art collection
// It consists of 75 Beasts for Loot Survivor, an onchain arcade machine game
// ERC721 implementation is based on OpenZeppelin's
// By hoanh.eth & loothero.eth
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
    use starknet::contract_address_const;

    use openzeppelin_token::erc721::interface::{IERC721_ID, IERC721_METADATA_ID};
    use openzeppelin_introspection::interface::{ISRC5_ID};

    use pixel_beasts::long_string::{LongString};
    use pixel_beasts::interfaces::{IBeasts};
    use pixel_beasts::pack::{mask, pow, PackableBeast};
    use pixel_beasts::beast::{get_hash, get_content};
    use core::starknet::storage::Map;

    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
    const IERC721_ID_EIP: felt252 = 0x80ac58cd;
    const IERC721_METADATA_ID_EIP: felt252 = 0x5b5e139f;

    #[storage]
    struct Storage {
        _owner: ContractAddress,
        _minter: ContractAddress,
        _name: felt252,
        _symbol: felt252,
        _owners: Map<u256, ContractAddress>,
        _balances: Map<ContractAddress, u256>,
        _tokenApprovals: Map<u256, ContractAddress>,
        _operatorApprovals: Map<(ContractAddress, ContractAddress), bool>,
        _tokenIndex: u256,
        _supportedInterfaces: Map<felt252, bool>,
        _minted: Map::<felt252, bool>,
        _beast: Map<u256, PackableBeast>,
        _genesis_mint: bool,
        _airdrop_issued: bool,
    }

    const START_TOKEN_ID: u8 = 1;

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
        ref self: ContractState, owner: ContractAddress, name: felt252, symbol: felt252
    ) {
        self.initializer(owner, name, symbol);
        self._tokenIndex.write(START_TOKEN_ID.into());
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn initializer(
            ref self: ContractState, owner: ContractAddress, name: felt252, symbol: felt252
        ) {
            self._transferOwnership(owner);
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

        fn _mint(
            ref self: ContractState, token_id: u256, beast: PackableBeast, to: ContractAddress
        ) {
            self._beast.write(token_id, beast);
            self._minted.write(get_hash(beast.id, beast.prefix, beast.suffix), true);
            self._balances.write(to, self._balances.read(to) + 1);
            self._owners.write(token_id, to);
            self._tokenIndex.write(token_id + 1);
            self.emit(Transfer { from: Zeroable::zero(), to, token_id });
        }
        fn _mint_genesis_beasts(ref self: ContractState, to: ContractAddress) {
            let mut id = 1;
            loop {
                if id == 76 {
                    break;
                }
                let token_id: u256 = self._tokenIndex.read();
                let beast = PackableBeast { id: id, prefix: 0, suffix: 0, level: 0, health: 0 };
                self._mint(token_id, beast, to);
                id += 1;
            };
        }

        fn _airdrop(ref self: ContractState) {
            let airdrops = get_airdrops();
            let mut i = 0;
            loop {
                if i == airdrops.len() {
                    break;
                }
                let airdrop = *airdrops.at(i);
                let token_id: u256 = self._tokenIndex.read();
                self._mint(token_id, airdrop.beast, airdrop.address);
                i += 1;
            };
        }
    }

    #[abi(embed_v0)]
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

        fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
            assert(!account.is_zero(), 'Invalid account');
            self._balances.read(account)
        }

        fn ownerOf(self: @ContractState, tokenID: u256) -> ContractAddress {
            self._ownerOf(tokenID)
        }

        fn owner_of(self: @ContractState, tokenID: u256) -> ContractAddress {
            self._ownerOf(tokenID)
        }

        fn approve(ref self: ContractState, to: ContractAddress, tokenID: u256) {
            let owner = self._ownerOf(tokenID);

            let caller = get_caller_address();
            assert(
                owner == caller || Self::isApprovedForAll(@self, owner, caller),
                'ERC721: unauthorized caller'
            );
            self._approve(to, tokenID);
        }

        fn setApprovalForAll(ref self: ContractState, operator: ContractAddress, approved: bool) {
            self._setApprovalForAll(get_caller_address(), operator, approved)
        }

        fn set_approval_for_all(
            ref self: ContractState, operator: ContractAddress, approved: bool
        ) {
            self._setApprovalForAll(get_caller_address(), operator, approved)
        }

        fn getApproved(self: @ContractState, tokenID: u256) -> ContractAddress {
            assert(self._exists(tokenID), 'ERC721: invalid token ID');
            self._tokenApprovals.read(tokenID)
        }

        fn get_approved(self: @ContractState, tokenID: u256) -> ContractAddress {
            assert(self._exists(tokenID), 'ERC721: invalid token ID');
            self._tokenApprovals.read(tokenID)
        }

        fn isApprovedForAll(
            self: @ContractState, owner: ContractAddress, operator: ContractAddress
        ) -> bool {
            self._operatorApprovals.read((owner, operator))
        }

        fn is_approved_for_all(
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

        fn transfer_from(
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

        fn token_uri(self: @ContractState, tokenID: u256) -> Array::<felt252> {
            assert(self._exists(tokenID), 'Invalid token ID');
            let beast = self._beast.read(tokenID);
            get_content(beast)
        }

        fn supportsInterface(self: @ContractState, interfaceId: felt252) -> bool {
            self._supportsInterface(interfaceId)
        }

        fn supports_interface(self: @ContractState, interfaceId: felt252) -> bool {
            self._supportsInterface(interfaceId)
        }

        fn registerInterface(ref self: ContractState, interface_id: felt252) {
            self._registerInterface(interface_id);
        }

        fn register_interface(ref self: ContractState, interface_id: felt252) {
            self._registerInterface(interface_id);
        }
        fn tokenSupply(self: @ContractState) -> u256 {
            self._tokenIndex.read() - START_TOKEN_ID.into()
        }

        fn token_supply(self: @ContractState) -> u256 {
            self._tokenIndex.read() - START_TOKEN_ID.into()
        }

        fn setMinter(ref self: ContractState, to: ContractAddress) {
            self._assertOnlyOwner();
            self._minter.write(to);
        }

        fn getMinter(self: @ContractState) -> ContractAddress {
            return self._minter.read();
        }

        fn isMinted(self: @ContractState, beast_id: u8, prefix: u8, suffix: u8) -> bool {
            self._minted.read(get_hash(beast_id, prefix, suffix))
        }

        fn mint(
            ref self: ContractState,
            to: ContractAddress,
            beast_id: u8,
            prefix: u8,
            suffix: u8,
            level: u16,
            health: u16
        ) {
            assert(!to.is_zero(), 'Invalid receiver');
            let caller: ContractAddress = get_caller_address();
            assert(!caller.is_zero(), 'Invalid caller');
            assert(caller == self.getMinter(), 'Not authorized to mint');
            assert(!self.isMinted(beast_id, prefix, suffix), 'Beast already minted');
            let token_id: u256 = self._tokenIndex.read();
            let beast = PackableBeast { id: beast_id, prefix, suffix, level, health };
            self._mint(token_id, beast, to);
        }

        fn mintGenesisBeasts(ref self: ContractState, to: ContractAddress) {
            self._assertOnlyOwner();
            assert(self._genesis_mint.read() == false, 'Already minted');
            self._mint_genesis_beasts(to);
            self._genesis_mint.write(true);
        }

        fn airdrop(ref self: ContractState) {
            self._assertOnlyOwner();
            assert(self._airdrop_issued.read() == false, 'Airdropped already issued');
            self._airdrop();
            self._airdrop_issued.write(true);
        }

        fn getBeast(self: @ContractState, token_id: u256) -> PackableBeast {
            assert(self._exists(token_id), 'Invalid token ID');
            self._beast.read(token_id)
        }
    }

    #[derive(Drop, Copy)]
    struct Airdrop {
        address: ContractAddress,
        beast: PackableBeast
    }

    fn get_airdrops() -> Array<Airdrop> {
        let mut airdrops = ArrayTrait::<Airdrop>::new();
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05b0a0def8c8eea7c4b1002502386c067d218d95a8346b0842f7b8cd53447201
                    >(),
                    beast: PackableBeast { id: 23, prefix: 68, suffix: 17, level: 23, health: 33 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05b0a0def8c8eea7c4b1002502386c067d218d95a8346b0842f7b8cd53447201
                    >(),
                    beast: PackableBeast { id: 74, prefix: 38, suffix: 11, level: 19, health: 159 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x0154c4a6e48b66bd77e8c7786e2de6a037af7104cfbec10f9fb2e5cedc0e56b1
                    >(),
                    beast: PackableBeast { id: 20, prefix: 32, suffix: 8, level: 20, health: 30 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x071538f6445e0c6179b786230a3e7b5ddee40b72673a9b5a395da20f4657bdca
                    >(),
                    beast: PackableBeast { id: 61, prefix: 4, suffix: 10, level: 28, health: 236 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x071538f6445e0c6179b786230a3e7b5ddee40b72673a9b5a395da20f4657bdca
                    >(),
                    beast: PackableBeast { id: 68, prefix: 44, suffix: 11, level: 21, health: 183 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x071538f6445e0c6179b786230a3e7b5ddee40b72673a9b5a395da20f4657bdca
                    >(),
                    beast: PackableBeast { id: 36, prefix: 33, suffix: 18, level: 28, health: 496 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x071538f6445e0c6179b786230a3e7b5ddee40b72673a9b5a395da20f4657bdca
                    >(),
                    beast: PackableBeast { id: 75, prefix: 63, suffix: 3, level: 25, health: 115 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x071538f6445e0c6179b786230a3e7b5ddee40b72673a9b5a395da20f4657bdca
                    >(),
                    beast: PackableBeast { id: 73, prefix: 10, suffix: 16, level: 40, health: 158 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x071538f6445e0c6179b786230a3e7b5ddee40b72673a9b5a395da20f4657bdca
                    >(),
                    beast: PackableBeast { id: 30, prefix: 57, suffix: 6, level: 32, health: 430 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x071538f6445e0c6179b786230a3e7b5ddee40b72673a9b5a395da20f4657bdca
                    >(),
                    beast: PackableBeast { id: 72, prefix: 27, suffix: 9, level: 47, health: 497 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x071538f6445e0c6179b786230a3e7b5ddee40b72673a9b5a395da20f4657bdca
                    >(),
                    beast: PackableBeast { id: 32, prefix: 50, suffix: 8, level: 28, health: 511 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x071538f6445e0c6179b786230a3e7b5ddee40b72673a9b5a395da20f4657bdca
                    >(),
                    beast: PackableBeast { id: 36, prefix: 45, suffix: 12, level: 26, health: 206 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x066f04f184ddbc8e10d53540b724a336bda64222d916f277030ec9d99cf99460
                    >(),
                    beast: PackableBeast { id: 21, prefix: 6, suffix: 12, level: 20, health: 16 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x066f04f184ddbc8e10d53540b724a336bda64222d916f277030ec9d99cf99460
                    >(),
                    beast: PackableBeast { id: 24, prefix: 60, suffix: 15, level: 19, health: 109 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x066f04f184ddbc8e10d53540b724a336bda64222d916f277030ec9d99cf99460
                    >(),
                    beast: PackableBeast { id: 66, prefix: 3, suffix: 9, level: 19, health: 211 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x0261069892eca8e8d4d45b31a36eed8b188aaa9c3b4afc43e799f6a8ee3ff158
                    >(),
                    beast: PackableBeast { id: 67, prefix: 37, suffix: 7, level: 19, health: 62 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x03474353878b236171e4c08e52465d9f2cf6c3babf726cc292ff1566e68612c3
                    >(),
                    beast: PackableBeast { id: 58, prefix: 43, suffix: 13, level: 19, health: 113 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x03474353878b236171e4c08e52465d9f2cf6c3babf726cc292ff1566e68612c3
                    >(),
                    beast: PackableBeast { id: 23, prefix: 41, suffix: 17, level: 31, health: 153 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x01046e44faf09e4e69ba96180a545882e196c34ffcfc3598c4ab15a3a442d319
                    >(),
                    beast: PackableBeast { id: 26, prefix: 8, suffix: 11, level: 25, health: 21 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x01046e44faf09e4e69ba96180a545882e196c34ffcfc3598c4ab15a3a442d319
                    >(),
                    beast: PackableBeast { id: 28, prefix: 13, suffix: 1, level: 19, health: 233 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x01046e44faf09e4e69ba96180a545882e196c34ffcfc3598c4ab15a3a442d319
                    >(),
                    beast: PackableBeast { id: 45, prefix: 6, suffix: 15, level: 29, health: 295 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x069cca516f5f6fd67e007bc73808e908755b3fd9a87e4856a05d8c6536688674
                    >(),
                    beast: PackableBeast { id: 61, prefix: 13, suffix: 7, level: 19, health: 71 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x04e8fa25c1c786bb014311ed21cd5c5e0aa0b44a276fa6c6775f26febaaed2fb
                    >(),
                    beast: PackableBeast { id: 63, prefix: 9, suffix: 6, level: 22, health: 88 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x0378b9c3cb6be32d087d1af8a91c1484226ac8b009f502e12b06ffd46d94f014
                    >(),
                    beast: PackableBeast { id: 70, prefix: 7, suffix: 13, level: 21, health: 20 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x0716e39b21fe7062421cb0056e1e3323ded9e9154915c0e89f1c9dff206ba459
                    >(),
                    beast: PackableBeast { id: 13, prefix: 25, suffix: 13, level: 27, health: 173 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05c387425d73abc847ca158f6a5da1eaa34f2c024d195de70a4c522fe8eb4b5c
                    >(),
                    beast: PackableBeast { id: 64, prefix: 13, suffix: 16, level: 22, health: 44 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05c387425d73abc847ca158f6a5da1eaa34f2c024d195de70a4c522fe8eb4b5c
                    >(),
                    beast: PackableBeast { id: 50, prefix: 56, suffix: 11, level: 25, health: 165 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05c387425d73abc847ca158f6a5da1eaa34f2c024d195de70a4c522fe8eb4b5c
                    >(),
                    beast: PackableBeast { id: 43, prefix: 13, suffix: 10, level: 28, health: 128 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05c387425d73abc847ca158f6a5da1eaa34f2c024d195de70a4c522fe8eb4b5c
                    >(),
                    beast: PackableBeast { id: 64, prefix: 10, suffix: 1, level: 19, health: 209 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05c387425d73abc847ca158f6a5da1eaa34f2c024d195de70a4c522fe8eb4b5c
                    >(),
                    beast: PackableBeast { id: 23, prefix: 47, suffix: 2, level: 38, health: 348 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05c387425d73abc847ca158f6a5da1eaa34f2c024d195de70a4c522fe8eb4b5c
                    >(),
                    beast: PackableBeast { id: 71, prefix: 59, suffix: 11, level: 21, health: 111 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05c387425d73abc847ca158f6a5da1eaa34f2c024d195de70a4c522fe8eb4b5c
                    >(),
                    beast: PackableBeast { id: 75, prefix: 66, suffix: 6, level: 52, health: 340 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05c387425d73abc847ca158f6a5da1eaa34f2c024d195de70a4c522fe8eb4b5c
                    >(),
                    beast: PackableBeast { id: 48, prefix: 3, suffix: 18, level: 28, health: 118 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05c387425d73abc847ca158f6a5da1eaa34f2c024d195de70a4c522fe8eb4b5c
                    >(),
                    beast: PackableBeast { id: 61, prefix: 37, suffix: 7, level: 21, health: 371 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05c387425d73abc847ca158f6a5da1eaa34f2c024d195de70a4c522fe8eb4b5c
                    >(),
                    beast: PackableBeast { id: 57, prefix: 57, suffix: 18, level: 32, health: 511 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x06f490c0ec49fe17148af6f83ebebd9d31e5a06dc46bdbe5c5e0657c23a4ff4f
                    >(),
                    beast: PackableBeast { id: 23, prefix: 20, suffix: 8, level: 24, health: 153 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x06f490c0ec49fe17148af6f83ebebd9d31e5a06dc46bdbe5c5e0657c23a4ff4f
                    >(),
                    beast: PackableBeast { id: 26, prefix: 20, suffix: 14, level: 24, health: 51 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x0154c4a6e48b66bd77e8c7786e2de6a037af7104cfbec10f9fb2e5cedc0e56b1
                    >(),
                    beast: PackableBeast { id: 69, prefix: 15, suffix: 3, level: 27, health: 79 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05f17eb829583374661a8ae382333b34a046345dfbe26fa51bdf4a30ff6548bd
                    >(),
                    beast: PackableBeast { id: 42, prefix: 15, suffix: 6, level: 22, health: 172 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05f17eb829583374661a8ae382333b34a046345dfbe26fa51bdf4a30ff6548bd
                    >(),
                    beast: PackableBeast { id: 69, prefix: 54, suffix: 12, level: 30, health: 274 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05f17eb829583374661a8ae382333b34a046345dfbe26fa51bdf4a30ff6548bd
                    >(),
                    beast: PackableBeast { id: 20, prefix: 59, suffix: 5, level: 19, health: 105 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05f17eb829583374661a8ae382333b34a046345dfbe26fa51bdf4a30ff6548bd
                    >(),
                    beast: PackableBeast { id: 73, prefix: 55, suffix: 4, level: 28, health: 398 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05f17eb829583374661a8ae382333b34a046345dfbe26fa51bdf4a30ff6548bd
                    >(),
                    beast: PackableBeast { id: 57, prefix: 66, suffix: 3, level: 25, health: 157 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x074f91d284351a8603933b648684b6a990126d7c78a1b867353a57a3bc2097da
                    >(),
                    beast: PackableBeast { id: 63, prefix: 9, suffix: 15, level: 23, health: 313 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x074f91d284351a8603933b648684b6a990126d7c78a1b867353a57a3bc2097da
                    >(),
                    beast: PackableBeast { id: 67, prefix: 4, suffix: 1, level: 23, health: 347 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x06984560836d038e6e42226351eb70e627afc7879df11aa3cfc383d41f6701a2
                    >(),
                    beast: PackableBeast { id: 38, prefix: 44, suffix: 11, level: 23, health: 93 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x06984560836d038e6e42226351eb70e627afc7879df11aa3cfc383d41f6701a2
                    >(),
                    beast: PackableBeast { id: 33, prefix: 18, suffix: 3, level: 25, health: 133 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x02cd97240db3f679de98a729ae91eb996cab9fd92a9a578df11a72f49be1c356
                    >(),
                    beast: PackableBeast { id: 12, prefix: 66, suffix: 9, level: 27, health: 172 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x02cd97240db3f679de98a729ae91eb996cab9fd92a9a578df11a72f49be1c356
                    >(),
                    beast: PackableBeast { id: 72, prefix: 6, suffix: 18, level: 36, health: 172 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x02cd97240db3f679de98a729ae91eb996cab9fd92a9a578df11a72f49be1c356
                    >(),
                    beast: PackableBeast { id: 48, prefix: 45, suffix: 18, level: 28, health: 133 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x02cd97240db3f679de98a729ae91eb996cab9fd92a9a578df11a72f49be1c356
                    >(),
                    beast: PackableBeast { id: 19, prefix: 22, suffix: 10, level: 44, health: 194 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x02cd97240db3f679de98a729ae91eb996cab9fd92a9a578df11a72f49be1c356
                    >(),
                    beast: PackableBeast { id: 18, prefix: 27, suffix: 12, level: 46, health: 283 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x04461b5e6a40da71a2ea718e8e2cbde18109f5d55ec3ffc29f44086d8a7a6649
                    >(),
                    beast: PackableBeast { id: 40, prefix: 40, suffix: 13, level: 25, health: 50 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x04461b5e6a40da71a2ea718e8e2cbde18109f5d55ec3ffc29f44086d8a7a6649
                    >(),
                    beast: PackableBeast { id: 46, prefix: 28, suffix: 4, level: 30, health: 56 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x04e8fa25c1c786bb014311ed21cd5c5e0aa0b44a276fa6c6775f26febaaed2fb
                    >(),
                    beast: PackableBeast { id: 64, prefix: 28, suffix: 1, level: 19, health: 29 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x02cd97240db3f679de98a729ae91eb996cab9fd92a9a578df11a72f49be1c356
                    >(),
                    beast: PackableBeast { id: 38, prefix: 14, suffix: 14, level: 28, health: 138 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x02cd97240db3f679de98a729ae91eb996cab9fd92a9a578df11a72f49be1c356
                    >(),
                    beast: PackableBeast { id: 60, prefix: 21, suffix: 9, level: 27, health: 85 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x02cd97240db3f679de98a729ae91eb996cab9fd92a9a578df11a72f49be1c356
                    >(),
                    beast: PackableBeast { id: 12, prefix: 12, suffix: 9, level: 33, health: 157 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x02cd97240db3f679de98a729ae91eb996cab9fd92a9a578df11a72f49be1c356
                    >(),
                    beast: PackableBeast { id: 56, prefix: 2, suffix: 17, level: 31, health: 381 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x02cd97240db3f679de98a729ae91eb996cab9fd92a9a578df11a72f49be1c356
                    >(),
                    beast: PackableBeast { id: 17, prefix: 8, suffix: 5, level: 45, health: 177 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x02cd97240db3f679de98a729ae91eb996cab9fd92a9a578df11a72f49be1c356
                    >(),
                    beast: PackableBeast { id: 57, prefix: 15, suffix: 9, level: 37, health: 127 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x02cd97240db3f679de98a729ae91eb996cab9fd92a9a578df11a72f49be1c356
                    >(),
                    beast: PackableBeast { id: 40, prefix: 25, suffix: 1, level: 35, health: 245 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x02cd97240db3f679de98a729ae91eb996cab9fd92a9a578df11a72f49be1c356
                    >(),
                    beast: PackableBeast { id: 45, prefix: 66, suffix: 18, level: 30, health: 220 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x02cd97240db3f679de98a729ae91eb996cab9fd92a9a578df11a72f49be1c356
                    >(),
                    beast: PackableBeast { id: 20, prefix: 29, suffix: 5, level: 31, health: 225 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x02cd97240db3f679de98a729ae91eb996cab9fd92a9a578df11a72f49be1c356
                    >(),
                    beast: PackableBeast { id: 37, prefix: 13, suffix: 1, level: 31, health: 317 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x02cd97240db3f679de98a729ae91eb996cab9fd92a9a578df11a72f49be1c356
                    >(),
                    beast: PackableBeast { id: 12, prefix: 12, suffix: 15, level: 41, health: 287 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x02cd97240db3f679de98a729ae91eb996cab9fd92a9a578df11a72f49be1c356
                    >(),
                    beast: PackableBeast { id: 48, prefix: 39, suffix: 3, level: 25, health: 443 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x02cd97240db3f679de98a729ae91eb996cab9fd92a9a578df11a72f49be1c356
                    >(),
                    beast: PackableBeast { id: 64, prefix: 37, suffix: 4, level: 46, health: 511 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x04461b5e6a40da71a2ea718e8e2cbde18109f5d55ec3ffc29f44086d8a7a6650
                    >(),
                    beast: PackableBeast { id: 23, prefix: 26, suffix: 17, level: 23, health: 153 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x04461b5e6a40da71a2ea718e8e2cbde18109f5d55ec3ffc29f44086d8a7a6649
                    >(),
                    beast: PackableBeast { id: 59, prefix: 5, suffix: 5, level: 23, health: 159 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05f17eb829583374661a8ae382333b34a046345dfbe26fa51bdf4a30ff6548bd
                    >(),
                    beast: PackableBeast { id: 39, prefix: 69, suffix: 6, level: 24, health: 124 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05f17eb829583374661a8ae382333b34a046345dfbe26fa51bdf4a30ff6548bd
                    >(),
                    beast: PackableBeast { id: 71, prefix: 68, suffix: 2, level: 22, health: 96 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x066f04f184ddbc8e10d53540b724a336bda64222d916f277030ec9d99cf99460
                    >(),
                    beast: PackableBeast { id: 44, prefix: 65, suffix: 14, level: 24, health: 294 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x06984560836d038e6e42226351eb70e627afc7879df11aa3cfc383d41f6701a2
                    >(),
                    beast: PackableBeast { id: 10, prefix: 22, suffix: 1, level: 21, health: 185 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x06984560836d038e6e42226351eb70e627afc7879df11aa3cfc383d41f6701a2
                    >(),
                    beast: PackableBeast { id: 11, prefix: 32, suffix: 5, level: 21, health: 201 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x06984560836d038e6e42226351eb70e627afc7879df11aa3cfc383d41f6701a2
                    >(),
                    beast: PackableBeast { id: 5, prefix: 50, suffix: 14, level: 24, health: 15 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x06984560836d038e6e42226351eb70e627afc7879df11aa3cfc383d41f6701a2
                    >(),
                    beast: PackableBeast { id: 62, prefix: 2, suffix: 11, level: 21, health: 42 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x06984560836d038e6e42226351eb70e627afc7879df11aa3cfc383d41f6701a2
                    >(),
                    beast: PackableBeast { id: 47, prefix: 8, suffix: 8, level: 32, health: 42 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x06984560836d038e6e42226351eb70e627afc7879df11aa3cfc383d41f6701a2
                    >(),
                    beast: PackableBeast { id: 32, prefix: 26, suffix: 8, level: 22, health: 117 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x01f447b1d086c66533b481311813a68cde116aacf39fb9611636f18c79502241
                    >(),
                    beast: PackableBeast { id: 21, prefix: 27, suffix: 9, level: 19, health: 16 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x01f447b1d086c66533b481311813a68cde116aacf39fb9611636f18c79502241
                    >(),
                    beast: PackableBeast { id: 63, prefix: 15, suffix: 18, level: 28, health: 238 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x01f447b1d086c66533b481311813a68cde116aacf39fb9611636f18c79502241
                    >(),
                    beast: PackableBeast { id: 72, prefix: 33, suffix: 15, level: 31, health: 187 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x06984560836d038e6e42226351eb70e627afc7879df11aa3cfc383d41f6701a2
                    >(),
                    beast: PackableBeast { id: 74, prefix: 35, suffix: 11, level: 19, health: 159 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x066f04f184ddbc8e10d53540b724a336bda64222d916f277030ec9d99cf99460
                    >(),
                    beast: PackableBeast { id: 73, prefix: 16, suffix: 13, level: 19, health: 128 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x03573910f5b33ca8249412ef469a5cc35dd6629ebe034d2b3098bc3c5ba9dcbd
                    >(),
                    beast: PackableBeast { id: 72, prefix: 60, suffix: 3, level: 21, health: 67 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x03573910f5b33ca8249412ef469a5cc35dd6629ebe034d2b3098bc3c5ba9dcbd
                    >(),
                    beast: PackableBeast { id: 44, prefix: 35, suffix: 17, level: 19, health: 99 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x03573910f5b33ca8249412ef469a5cc35dd6629ebe034d2b3098bc3c5ba9dcbd
                    >(),
                    beast: PackableBeast { id: 24, prefix: 60, suffix: 18, level: 24, health: 109 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x03573910f5b33ca8249412ef469a5cc35dd6629ebe034d2b3098bc3c5ba9dcbd
                    >(),
                    beast: PackableBeast { id: 11, prefix: 53, suffix: 8, level: 26, health: 171 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x03573910f5b33ca8249412ef469a5cc35dd6629ebe034d2b3098bc3c5ba9dcbd
                    >(),
                    beast: PackableBeast { id: 74, prefix: 5, suffix: 17, level: 29, health: 39 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x01046e44faf09e4e69ba96180a545882e196c34ffcfc3598c4ab15a3a442d319
                    >(),
                    beast: PackableBeast { id: 19, prefix: 40, suffix: 1, level: 23, health: 89 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x01046e44faf09e4e69ba96180a545882e196c34ffcfc3598c4ab15a3a442d319
                    >(),
                    beast: PackableBeast { id: 9, prefix: 51, suffix: 6, level: 22, health: 49 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x01046e44faf09e4e69ba96180a545882e196c34ffcfc3598c4ab15a3a442d319
                    >(),
                    beast: PackableBeast { id: 71, prefix: 23, suffix: 14, level: 48, health: 411 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x01046e44faf09e4e69ba96180a545882e196c34ffcfc3598c4ab15a3a442d319
                    >(),
                    beast: PackableBeast { id: 66, prefix: 60, suffix: 18, level: 28, health: 406 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x01046e44faf09e4e69ba96180a545882e196c34ffcfc3598c4ab15a3a442d319
                    >(),
                    beast: PackableBeast { id: 15, prefix: 18, suffix: 15, level: 43, health: 445 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05f17eb829583374661a8ae382333b34a046345dfbe26fa51bdf4a30ff6548bd
                    >(),
                    beast: PackableBeast { id: 21, prefix: 33, suffix: 9, level: 27, health: 241 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05f17eb829583374661a8ae382333b34a046345dfbe26fa51bdf4a30ff6548bd
                    >(),
                    beast: PackableBeast { id: 71, prefix: 20, suffix: 2, level: 44, health: 366 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05f17eb829583374661a8ae382333b34a046345dfbe26fa51bdf4a30ff6548bd
                    >(),
                    beast: PackableBeast { id: 65, prefix: 35, suffix: 5, level: 25, health: 511 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x06984560836d038e6e42226351eb70e627afc7879df11aa3cfc383d41f6701a2
                    >(),
                    beast: PackableBeast { id: 68, prefix: 5, suffix: 5, level: 23, health: 78 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x06984560836d038e6e42226351eb70e627afc7879df11aa3cfc383d41f6701a2
                    >(),
                    beast: PackableBeast { id: 48, prefix: 36, suffix: 3, level: 21, health: 133 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x06984560836d038e6e42226351eb70e627afc7879df11aa3cfc383d41f6701a2
                    >(),
                    beast: PackableBeast { id: 65, prefix: 41, suffix: 17, level: 27, health: 75 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x06984560836d038e6e42226351eb70e627afc7879df11aa3cfc383d41f6701a2
                    >(),
                    beast: PackableBeast { id: 21, prefix: 57, suffix: 6, level: 52, health: 331 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x06984560836d038e6e42226351eb70e627afc7879df11aa3cfc383d41f6701a2
                    >(),
                    beast: PackableBeast { id: 28, prefix: 64, suffix: 13, level: 25, health: 323 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x04e8fa25c1c786bb014311ed21cd5c5e0aa0b44a276fa6c6775f26febaaed2fb
                    >(),
                    beast: PackableBeast { id: 25, prefix: 31, suffix: 7, level: 19, health: 185 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x04e8fa25c1c786bb014311ed21cd5c5e0aa0b44a276fa6c6775f26febaaed2fb
                    >(),
                    beast: PackableBeast { id: 47, prefix: 26, suffix: 5, level: 25, health: 147 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x04e8fa25c1c786bb014311ed21cd5c5e0aa0b44a276fa6c6775f26febaaed2fb
                    >(),
                    beast: PackableBeast { id: 12, prefix: 69, suffix: 15, level: 37, health: 187 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x04e8fa25c1c786bb014311ed21cd5c5e0aa0b44a276fa6c6775f26febaaed2fb
                    >(),
                    beast: PackableBeast { id: 29, prefix: 68, suffix: 8, level: 22, health: 354 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x04e8fa25c1c786bb014311ed21cd5c5e0aa0b44a276fa6c6775f26febaaed2fb
                    >(),
                    beast: PackableBeast { id: 33, prefix: 3, suffix: 6, level: 36, health: 103 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x04e8fa25c1c786bb014311ed21cd5c5e0aa0b44a276fa6c6775f26febaaed2fb
                    >(),
                    beast: PackableBeast { id: 67, prefix: 61, suffix: 13, level: 29, health: 167 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x04e8fa25c1c786bb014311ed21cd5c5e0aa0b44a276fa6c6775f26febaaed2fb
                    >(),
                    beast: PackableBeast { id: 50, prefix: 47, suffix: 14, level: 48, health: 390 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x021cfa1ab62008896f10b50d972ed0f53c12eae2cf636b03f47f0962dfdffe6c
                    >(),
                    beast: PackableBeast { id: 45, prefix: 51, suffix: 12, level: 24, health: 130 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x021cfa1ab62008896f10b50d972ed0f53c12eae2cf636b03f47f0962dfdffe6c
                    >(),
                    beast: PackableBeast { id: 22, prefix: 64, suffix: 16, level: 24, health: 47 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x0444f4350539b01ace59d37a3eb58710c737f3d3640e7f2e43721c5dd8fec9e6
                    >(),
                    beast: PackableBeast { id: 5, prefix: 17, suffix: 8, level: 20, health: 90 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x0378b9c3cb6be32d087d1af8a91c1484226ac8b009f502e12b06ffd46d94f014
                    >(),
                    beast: PackableBeast { id: 9, prefix: 66, suffix: 9, level: 21, health: 109 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x06984560836d038e6e42226351eb70e627afc7879df11aa3cfc383d41f6701a2
                    >(),
                    beast: PackableBeast { id: 75, prefix: 33, suffix: 12, level: 22, health: 130 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x06984560836d038e6e42226351eb70e627afc7879df11aa3cfc383d41f6701a2
                    >(),
                    beast: PackableBeast { id: 64, prefix: 64, suffix: 1, level: 19, health: 74 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x06984560836d038e6e42226351eb70e627afc7879df11aa3cfc383d41f6701a2
                    >(),
                    beast: PackableBeast { id: 47, prefix: 5, suffix: 8, level: 22, health: 192 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x044081ea31b076fd7daf9f66e5405a64bf3f6384d9ffea6c6b8c45e5524c60f3
                    >(),
                    beast: PackableBeast { id: 21, prefix: 48, suffix: 6, level: 20, health: 151 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x0620b2e12fb8d195ce384512d65fbbddbdea26c4610a49f7630282ea7e55077c
                    >(),
                    beast: PackableBeast { id: 18, prefix: 27, suffix: 3, level: 21, health: 193 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x0620b2e12fb8d195ce384512d65fbbddbdea26c4610a49f7630282ea7e55077c
                    >(),
                    beast: PackableBeast { id: 69, prefix: 63, suffix: 9, level: 19, health: 109 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x0620b2e12fb8d195ce384512d65fbbddbdea26c4610a49f7630282ea7e55077c
                    >(),
                    beast: PackableBeast { id: 37, prefix: 52, suffix: 16, level: 22, health: 362 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x0620b2e12fb8d195ce384512d65fbbddbdea26c4610a49f7630282ea7e55077c
                    >(),
                    beast: PackableBeast { id: 17, prefix: 65, suffix: 5, level: 27, health: 417 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x0620b2e12fb8d195ce384512d65fbbddbdea26c4610a49f7630282ea7e55077c
                    >(),
                    beast: PackableBeast { id: 70, prefix: 4, suffix: 1, level: 39, health: 511 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05b0a0def8c8eea7c4b1002502386c067d218d95a8346b0842f7b8cd53447201
                    >(),
                    beast: PackableBeast { id: 65, prefix: 26, suffix: 2, level: 24, health: 90 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05b0a0def8c8eea7c4b1002502386c067d218d95a8346b0842f7b8cd53447201
                    >(),
                    beast: PackableBeast { id: 70, prefix: 19, suffix: 13, level: 25, health: 230 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x066f04f184ddbc8e10d53540b724a336bda64222d916f277030ec9d99cf99460
                    >(),
                    beast: PackableBeast { id: 40, prefix: 61, suffix: 4, level: 22, health: 140 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x066f04f184ddbc8e10d53540b724a336bda64222d916f277030ec9d99cf99460
                    >(),
                    beast: PackableBeast { id: 14, prefix: 29, suffix: 5, level: 29, health: 24 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x021cfa1ab62008896f10b50d972ed0f53c12eae2cf636b03f47f0962dfdffe6c
                    >(),
                    beast: PackableBeast { id: 68, prefix: 35, suffix: 14, level: 20, health: 63 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x05b0a0def8c8eea7c4b1002502386c067d218d95a8346b0842f7b8cd53447201
                    >(),
                    beast: PackableBeast { id: 45, prefix: 66, suffix: 12, level: 20, health: 130 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x0620b2e12fb8d195ce384512d65fbbddbdea26c4610a49f7630282ea7e55077c
                    >(),
                    beast: PackableBeast { id: 75, prefix: 33, suffix: 9, level: 21, health: 115 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x066f04f184ddbc8e10d53540b724a336bda64222d916f277030ec9d99cf99460
                    >(),
                    beast: PackableBeast { id: 49, prefix: 52, suffix: 1, level: 19, health: 59 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x066f04f184ddbc8e10d53540b724a336bda64222d916f277030ec9d99cf99460
                    >(),
                    beast: PackableBeast { id: 45, prefix: 33, suffix: 6, level: 22, health: 70 }
                }
            );
        airdrops
            .append(
                Airdrop {
                    address: contract_address_const::<
                        0x066f04f184ddbc8e10d53540b724a336bda64222d916f277030ec9d99cf99460
                    >(),
                    beast: PackableBeast { id: 38, prefix: 2, suffix: 11, level: 23, health: 213 }
                }
            );
        airdrops
    }
}
