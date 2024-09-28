# Chainlink Cross-Chain Interoperability Protocol

* **TokenTransfer Smart Contract**

This contract contains the `TokenTransfer` smart contract built using Solidity and Chainlink's Cross-Chain Interoperability Protocol (CCIP). The contract allows transferring tokens across multiple blockchains using Chainlink's router.

## Features

- **Cross-Chain Token Transfer**: Transfer ERC20 tokens across different blockchains using Chainlink's CCIP.
- **Fee Payment Options**: Supports paying fees with LINK tokens or native chain currency.
- **Allowlisted Chains**: Only transfers to specified allowlisted chains are allowed.
- **Receiver Validation**: Ensures the receiver address is valid before executing a transfer.
- **Owner Access Control**: The contract owner can manage allowlisted chains and execute transfers.

## Installation

To use or develop this project, follow these steps:

1. **Clone the repository**:

   ```bash
   git clone https://github.com/anurag-iitk/chainlink-ccip.git
   cd chainlink-ccip
   ```

2. **Install Foundry**:

   Foundry is a blazing fast, portable, and modular toolkit for Ethereum application development written in Rust. If you don't have Foundry installed, you can install it [here](https://book.getfoundry.sh/getting-started/installation).

   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   ```

3. **Install Dependencies**:

   ```bash
   forge install
   ```

4. **Compile Contracts**:

   ```bash
   forge build
   ```

5. **Run Tests**:

   ```bash
   forge test
   ```

6. ### Deploy

   ```bash
    forge script script/TokenTransfer.s.sol --rpc-url <your_rpc_url> --private-key 
    <your_private_key>
   ```

## Usage

1. **Deploy Contract**: Deploy the contract to the desired blockchain network using your preferred method (Remix, Hardhat, etc.).

2. **Add Allowlisted Chains**: Use the `allowlistDestinationChain` function to specify the chains to which tokens can be transferred.

3. **Transfer Tokens**:
   - Use `transferTokensPayLINK` for transfers paying fees in LINK tokens.
   - Use `transferTokensPayNative` for transfers paying fees in the native chain currency.

4. **Withdraw**: Withdraw any remaining tokens or ETH in the contract using the `withdraw` or `withdrawToken` functions.


## Acknowledgments

- [Chainlink](https://chain.link/)
- [Foundry](https://getfoundry.sh/)
- [OpenZeppelin](https://openzeppelin.com/)

For more information, visit the project [repository](https://github.com/anurag-iitk/chainlink-ccip.git).

---