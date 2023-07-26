# LeetLoot

## Deploy

If you have a deployer account, double check its correctness
```
vi ~/.starknet_accounts/starknet_open_zeppelin_accounts.json
{
    "alpha-goerli": {
        "pusscode": {
            "private_key": "REDACTED",
            "public_key": "REDACTED",
            "salt": "REDACTED",
            "address": "REDACTED",
            "deployed": true
        }
    }
}
```

If not, create a new account and fund with Starknet Goerli, e.g. https://faucet.goerli.starknet.io/, then deploy account
```
starknet new_account --account pusscode
starknet deploy_account --account=pusscode
```

Test and build the contract
```
scarb test && scarb build
```

Declare contract
```
starknet declare --contract target/dev/leetloot_LeetLoot.sierra.json --account pusscode
```

Deploy contract
```
starknet deploy --class_hash <CLASS_HASH> --max_fee 100000000000000000 --input 0x168893664220f03a74a9bce84228b009df46040c08bb308783dcf130790335f 0x168893664220f03a74a9bce84228b009df46040c08bb308783dcf130790335f 5504917669703282548 5495875148635393876 --account pusscode
```

If compiling error happens, try building with a recent version manually in the home dir
```
cd ~/
git clone https://github.com/starkware-libs/cairo/ .cairo
cd .cairo/
git checkout tags/v2.0.2
cargo build --all --release

export STARKNET_NETWORK=alpha-goerli
export STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount
export CAIRO_COMPILER_DIR=~/.cairo/target/release/
export CAIRO_COMPILER_ARGS=--add-pythonic-hints
```

Check transaction
```
starknet get_transaction --hash <TX_HASH>
```

Interact with contract
```
starknet call --function getArtSVG --address <CONTRACT_ADDRESS> --account pusscode --input 0
```