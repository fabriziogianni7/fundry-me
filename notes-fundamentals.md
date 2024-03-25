# General

foundry is based on solidity
that's why it's faster

## install foundry

download foundry from getfoundry
run `foundryup`

Installed:
forge
cast
anvil
chisel

## create new foundery project

forge init
forge build / forge compile to compile
forge create to deploy smart contract
anvil spins a local network
forge create SimpleStorage --http-url **_url_** (optional, if ytou got another rpcurl)--interactive // deploy contract

## Deploy with script

need to create a .s.sol file and import Script from forge-std/Script.sol
then run `forge script script/DeploySimpleStorage.s.sol` or `forge script DeploySimpleStorage`

if there is no local rpc it will be a temporary network created by foundry

`forge script script/DeploySimpleStorage.s.sol`
`forge script DeploySimpleStorage --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast`

broadcast will create a file with info of the deployment

you can also doit with thirdweb

## cool things for tx

use cast to convert hex to number
`cast to-dec  0x1cbcf //117711`

## how to protect pk

-- its dangersous
`source .env` will put your .env in the environment

`forge script DeploySimpleStorage --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast`

you can use cast to encrypt the pk
ERC2335 (encrypt pk in a json format)
`forge script --help`
`cast wallet import defaultKey --interactive` (do it in a terminal not in vscode)

then you use a password so you'll encrypt the pk

getting something like `/`defaultKey`/ keystore was saved successfully. Address: 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266`

to list the imported wallets:

`cast wallet list`

to run a command

`forge script DeploySimpleStorage --rpc-url $RPC_URL --account defaultKey --sender 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266 --broadcast`

## interact to contract using cli

`cast send 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9 "set(uint256 _value)" 123 --account defaultKey`

`cast call 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9 "get()"`

returns: `0x000000000000000000000000000000000000000000000000000000000000007b`

`cast to-dec 0x000000000000000000000000000000000000000000000000000000000000007b`
