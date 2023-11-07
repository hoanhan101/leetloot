use starknet::ContractAddress;

// contract interface
#[starknet::interface]
trait IBeasts<T> {
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
    fn registerInterface(ref self: T, interface_id: felt252);

    // Core functions
    fn mintGenesisBeasts(ref self: T, to: ContractAddress);
    fn setMinter(ref self: T, to: ContractAddress);
    fn getMinter(self: @T) -> ContractAddress;
    fn mint(ref self: T, to: ContractAddress, beast: u8, prefix: u8, suffix: u8, level: u16, health: u16);
    fn isMinted(self: @T, beast: u8, prefix: u8, suffix: u8) -> bool;
    fn tokenURI(self: @T, tokenID: u256) -> Array::<felt252>;
    fn tokenSupply(self: @T) -> u256;
}
