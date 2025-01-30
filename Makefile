-include .env

.PHONY: all test deploy

build :; forge build

test :; forge test

install :; forge install cyfrin/foundry-devops@0.2.2 --no-commit && forge install smartcontractkit/chainlink-brownie-contracts@1.1.1 --no-commit && forge install foundry-rs/forge-std@v1.8.2 --no-commit && forge install transmissions11/solmate@v6 --no-commit 

# Always deploy on a local testnet like anvil first
deploy-sepolia:
	@forge script script/DeployRaffle.s.sol:DeployRaffle --rpc-url $(SEPOLIA_RPC_URL) --account dev --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

verify-contract:
	# If for some reason, the previous command didn't verify it
	# You can verify it with standard json input
	@forge verify-contract $(RAFFLE_CA) src/Raffle.sol:Raffle --etherscan-api-key $(ETHERSCAN_API_KEY) --rpc-url $(SEPOLIA_RPC_URL) --show-standard-json-input > foo.json
