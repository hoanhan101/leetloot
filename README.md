# LeetLoot

## Deploy with Starkli


Initialize a signer and account if haven't. Otherwise check its correctness
```
starkli signer keystore new keys/key.json
export STARKNET_KEYSTORE="/workspaces/leetloot/keys/key.json"
```

```
starkli account oz init accounts/account.json
export STARKNET_ACCOUNT="/workspaces/leetloot/accounts/account.json"
```

Deploy the account if haven't
```
starkli account deploy accounts/account.json
```

Test and build the contract
```
scarb test && scarb build
```

Declare contract
```
starkli declare --account accounts/account.json --rpc <RPC_URL> --network goerli-1 ./target/dev/LootSurvivorBeasts_Beasts.sierra.json
```

Helpful Cairo string conversion
```
starkli to-cairo-string BEASTS
```

Deploy contract with argument resolution
```
starkli deploy --account accounts/account.json --rpc <RPC_URL> <CLASS_HASH> <OWNER_ADDRESS> <WHITELIST_ADDRESS> str:Beasts str:BEASTS
```

Get transaction
```
starkli transaction --rpc <RPC_URL> <TRANSACTION_HASH>
```

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

Make sure to use the correct environments
```
export STARKNET_WALLET=starkware.starknet.wallets.open_zeppelin.OpenZeppelinAccount
export CAIRO_COMPILER_DIR=~/.cairo/target/release/
export CAIRO_COMPILER_ARGS=--add-pythonic-hints
```

Goerli
```
0x168893664220f03a74a9bce84228b009df46040c08bb308783dcf130790335f
export STARKNET_NETWORK=alpha-goerli
```

Mainnet
```
0x63f6757aa16f7039e50e3df9235ec3532c52c8bbdff99e4de087f80d10ba68a
export STARKNET_NETWORK=alpha-mainnet
```

Declare contract
```
starknet declare --contract target/dev/LootSurvivorBeasts_Beasts.sierra.json --account pusscode
```

If compiling error happens, try building with a recent version manually in the home dir
```
cd ~/
git clone https://github.com/starkware-libs/cairo/ .cairo
cd .cairo/
git checkout tags/v2.1.1
cargo build --all --release
```

Declare again if failed earlier
```
cd /workspaces/leetloot
starknet declare --contract target/dev/LootSurvivorBeasts_Beasts.sierra.json --account pusscode
```

Deploy contract
```
starknet deploy --class_hash <CLASS_HASH> --max_fee 1000000000000000 --input <OWNER_ADDR> <WHITELIST_ADDR> 5504917669703282548 5495875148635393876 --account pusscode
```

Check transaction
```
starknet get_transaction --hash <TX_HASH>
```

Interact with contract
```
starknet call --function name --address <CONTRACT_ADDRESS> --account pusscode

starknet invoke --function whitelist --address <CONTRACT_ADDRESS> --account pusscode --max_fee 1000000000000000 --input <TO_ADDR>
starknet invoke --function mint --address <CONTRACT_ADDRESS> --account pusscode --max_fee 1000000000000000 --input <TO_ADDR> 1 1 1 13104
```



## Test

```
starknet deploy --class_hash 0x5b465308d15885b3b7ed9e8ceb31ec686bbdb817c2ecf96c93d976c7723b281 --max_fee 1000000000000000 --input 0x07862d11bf327959b7989cb158def3b8debf8948813150e43689485706f3db53 0x07862d11bf327959b7989cb158def3b8debf8948813150e43689485706f3db53 5504917669703282548 5495875148635393876 --account pusscode
```

```
starkli deploy 0x02cb532fc4a77e28eca87132b5326830aaf5fa87c6fb3cdc4314a4219ce0545f 0x3481bceb5771419b69cac998eece0cbf6be21699cdfb1a736f3c28796efbd7d 0x0 0x424541535453 0x424541535453 --account ./account --keystore ./keys
```