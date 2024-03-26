# StraitsX Take Home Test

## Contract Address

```
Deployed Contract Address: 0x1AFdaD6Ac74b117433aaA8C88EF95669839b7B0d
```

## Setup

1. Fork the `.env.example` file and rename it to `.env`. Fill in the required fields.

2. Install Dependencies

```
npm install
```

3. Compile Contracts

```
npx hardhat compile
```

## Commands to test smart contract

### Transfer 1000 tokens to a second account

```
npx hardhat run --network sepolia ./ignition/scripts/transferTokens.js
```

### Deposit 500 tokens to the contract

```
npx hardhat run --network sepolia ./ignition/scripts/depositTokens.js
```

### Withdraw 500 tokens from the contract

For this function, I removed the ability to input a specific amount of tokens to withdraw to avoid owners from withdrawing more funds than they have deposited.
The amount to withdraw is based on a deposits mapping that keeps track of the amount of tokens deposited by each address.

```
npx hardhat run --network sepolia ./ignition/scripts/withdrawTokens.js
```

### Query account balance

```
npx hardhat run --network sepolia ./ignition/scripts/queryAccountBalance.js
```
