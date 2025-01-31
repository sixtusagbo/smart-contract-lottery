# Smart Contract Lottery

A decentralized and verifiably random smart contract lottery system built with Solidity. Check it out on [Etherscan](https://sepolia.etherscan.io/address/0xbca7b3ac35eb848c88e86e5503c0cff2c31598c8/)

## About

This project implements a lottery system on the blockchain where:

- Players can enter by paying for a ticket
- Each ticket costs a fixed amount of Ether which contributes to the prize pool
  and must be greater than the minimum ticket price which is the entrance fee (currently 0.01 ether)
  > See [HelperConfig.s.sol](./script/HelperConfig.s.sol) for the entrance fee
- After the interval (currently 30s) passes, the lottery will automatically draw a winner
  > See [HelperConfig.s.sol](./script/HelperConfig.s.sol) for the interval (in seconds)
- Winner selection is provably random and automated with [Chainlink VRF](https://vrf.chain.link)
- The winner will receive the entire prize pool

## Getting Started

### Prerequisites

- [foundry](https://getfoundry.sh/)

### Installation

```bash
git clone https://github.com/yourusername/smart-contract-lottery
cd smart-contract-lottery
make install
make build
```
