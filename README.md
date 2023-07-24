# LeetLoot

## Deploy

Test and build
```
scarb test && scarb build
```

Create new account
```
starknet new_account --account pusscode
```

Fund with Starknet Goerli, e.g. https://faucet.goerli.starknet.io/, then deploy account
```
starknet deploy_account --account=pusscode
```

Declare contract
```
starknet declare --contract target/dev/leetloot_LeetLoot.sierra.json --account pusscode
```

Deploy contract
```
starknet deploy --class_hash <CLASS_HASH> --max_fee 100000000000000000 --account pusscode
```

If compiling error happens, try building with a recent version manually in the home dir
```
cd ~/
git clone https://github.com/starkware-libs/cairo/ .cairo
cd .cairo/
git checkout tags/v2.0.2
cargo build --all --release
```

Check transaction
```
starknet get_transaction --hash <TX_HASH>
```

Interact with contract
```
starknet call --function getArtSVG --address <CONTRACT_ADDRESS> --account pusscode --input 0
```