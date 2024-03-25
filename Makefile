-include .env

build:; forge build

deploy-anvil:
	forge script DeployFundMe --rpc-url $(ANVIL_RPC) --private-key $(ANVIL_PK) --broadcast

deploy-sepolia:
	forge script DeployFundMe --rpc-url $(SEPOLIA_RPC) --private-key $(SEPOLIA_PK) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY)