//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.0;

import "hardhat/console.sol";

// This is the main building block for smart contracts.
contract Token {
    // Some string type variables to identify the token.
    string public name = "My Hardhat Token";
    string public symbol = "MHT";

    // The fixed amount of tokens, stored in an unsigned integer type variable.
    uint256 public totalSupply = 1000000;

    // Global constant variables
    uint256 constant INTEREST_RATE = 2; // interst rate in %
    uint256 constant TIME_INTERVAL = 300; // 300 seconds = 5 minutes

    // An address type variable is used to store ethereum accounts.
    address public owner;

    // A mapping is a key/value map. Here we store each account's balance.
    mapping(address => uint256) balances;

    // A mapping to store deposits made by owners
    mapping(address => uint256) deposits;

    // A mapping that stores the timestamp of the deposits
    mapping(address => uint256) public depositTimestamp;

    // The Transfer event helps off-chain applications understand
    // what happens within your contract.
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    // The Deposit event helps off-chain applications when the user deposits an amount
    event Deposit(address indexed _depositor, address indexed _receiver, uint256 _amount);

    // The Withdrawal event helps off-chain applications when the user withdraws an amount
    event Withdrawal(address indexed _sender, address indexed _withdrawer, uint256 _amount);

    /**
     * Contract initialization.
     */
    constructor() {
        // The totalSupply is assigned to the transaction sender, which is the
        // account that is deploying the contract.
        balances[msg.sender] = totalSupply;
        owner = msg.sender;
    }

    /**
     * A function to transfer tokens.
     *
     * The `external` modifier makes a function *only* callable from *outside*
     * the contract.
     */
    function transfer(address to, uint256 amount) external {
        // Check if the transaction sender has enough tokens.
        // If `require`'s first argument evaluates to `false` then the
        // transaction will revert.
        require(balances[msg.sender] >= amount, "Not enough tokens");

        // Transfer the amount.
        balances[msg.sender] -= amount;
        balances[to] += amount;

        // Notify off-chain applications of the transfer.
        emit Transfer(msg.sender, to, amount);
    }

    /**
     * Read only function to retrieve the token balance of a given account.
     *
     * The `view` modifier indicates that it doesn't modify the contract's
     * state, which allows us to call it without executing a transaction.
     */
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }

    /**
     * Function to calculate interest accrued by depositor (Current timestamp - Deposited timestamp)
     * Simple Interest Formula: I = Prt (Principal Amount * 2% Interest Rate * Time in seconds)
     */
    function calculateInterest(address depositor, uint256 amount) public view returns (uint256) {
        uint256 elapsedTime = block.timestamp - depositTimestamp[depositor];

        // Calculate block periods
        uint256 periods = elapsedTime / TIME_INTERVAL;

        // Calculate interest earned
        uint256 interestEarned = (amount * INTEREST_RATE * periods) / 100;

        return interestEarned;
    }

    /**
     * Modifier to ensure only the depositor can withdraw
     */
    modifier onlyDepositor() {
        require(balances[msg.sender] > 0, "Not a depositor");
        _;
    }

    /**
     * Deposit function that adds
     *
     */
    function deposit(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Not enough tokens");

        // Update the deposit timestamp
        depositTimestamp[msg.sender] = block.timestamp;

        // Update the mapping to store the deposit amount
        deposits[msg.sender] = amount;

        // Update the balance of the depositor
        balances[msg.sender] -= amount;

        // Update the balance of totalSupply
        totalSupply += amount;

        emit Deposit(msg.sender, address(this), amount);
    }

    /**
     * Withdrawal function that adds
     *
     */
    function withdraw() external onlyDepositor {
        uint256 amount = deposits[msg.sender];
        require(amount > 0, "No tokens to withdraw");

        // Calculate interest
        uint256 interest = calculateInterest(msg.sender, amount);

        // Calculate amount available to withdraw with interest
        uint256 withdrawalAmount = amount + interest;

        // Update the balance of the depositor
        balances[msg.sender] += withdrawalAmount;

        // Update total supply
        totalSupply -= withdrawalAmount;

        emit Withdrawal(address(this), msg.sender, withdrawalAmount);
    }
}
