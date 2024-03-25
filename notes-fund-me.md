# General

## install dependency

`forge install smartcontractkit/foundry-chainlink-toolkit --no-commit`

remap in toml file eg : `remappings = ["@chainlink/contracts/src/v0.8/shared/interfaces/=./lib/foundry-chainlink-toolkit/src/interfaces/feeds/"]`

## Testing

`forge test`
`forge test -vv` --> logs (need to import console from script)
`forge test  --match-test testPriceOracle` to test just a function
using -vvv will get more logs and info

if you run test with `--fork-url` you'll fork the chain:

`forge test  --fork-url $SEPOLIA_RPC`
`forge test  --match-test testPriceOracle --fork-url $SEPOLIA_RPC`
will spin up an anvil forked from the chain we pass the rpc
`forge test  --match-test testCheckOwner --fork-url $ANVIL_RPC`

### Coverage

`forge coverage --fork-url $SEPOLIA_RPC`

## Magic number

just replace hardcoded numbers with constant variables. that's important in auditing

## cheatcodes

### prank

[impersonate an account](https://book.getfoundry.sh/cheatcodes/prank)

### deal

[fund an account](https://book.getfoundry.sh/cheatcodes/deal)

### makeAddr (util)

`makeAddr` makes a new address

## Chisel

running `chisel` on our terminal will allow to run small chunks of solidity

```
uint cat = 1;
➜ cat
Type: uint256
├ Hex: 0x0000000000000000000000000000000000000000000000000000000000000001
├ Hex (full word): 0x0000000000000000000000000000000000000000000000000000000000000001
└ Decimal: 1
```

## Storage optimization

`forge inspect FundMe storageLayout` inspect what's in the storage of the contracts

```
"storage": [
    {
      "astId": 46846,
      "contract": "src/FundMe.sol:FundMe",
      "label": "s_addressToAmountFunded",
      "offset": 0,
      "slot": "0",
      "type": "t_mapping(t_address,t_uint256)"
    },
    {
      "astId": 46849,
      "contract": "src/FundMe.sol:FundMe",
      "label": "s_funders",
      "offset": 0,
      "slot": "1",
      "type": "t_array(t_address)dyn_storage"
    }...]
```

### storage variables

State variables (global variables) are variables stored in the storage (memory) of the contract. It's a giant list of variables.stored in our contract

Each storage slot is 32 bytes.

Dynamic values like array or mapping are stored by some hash function in a storage slot

constant and immutable variables are part of the contract bytecode and are not stored in storage (don't take a storage slot).

You specify memory for eg. strings bc those are dynamic as arrays and you need to specify if it's an operation done in memory or storage.

`forge inspect FundMe storageLayout`

```forge script DeployFundMe --rpc-url $ANVIL_RPC --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
## Contract Address: 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512

cast storage 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 1 # pick what is it in storage slot
# result
# cast storage 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 1
# 0x0000000000000000000000000000000000000000000000000000000000000000
```

evm.codes (website) to see the opcodes and gas consumption (for instance, SLOAD, SSTORE cost min 100 gas)

`forge snapshot` to look at the gas cost

```
FundMeTest:testWithdrawFromMultipleFunders() (gas: 536647)
FundMeTest:testWithdrawFromMultipleFundersOptimized() (gas: 535698)
```

see the difference, we just optimized a function to make it cheaper

## Integrations

### fundry devops

package to get the last deployed contract
`forge install Cyfrin/foundry-devops --no-commit` ([other commands here](https://github.com/Cyfrin/foundry-devops))

forge script FundFundMe --rpc-url $ANVIL_RPC --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

# Finally

check out the verified contract on [etherscan](https://sepolia.etherscan.io/address/0xfcc09dd4e6b531cadd538cebcfe676f0733ca01a)
