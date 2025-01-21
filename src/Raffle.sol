// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * @title A simple raffle contract
 * @author Sixtus Agbo
 * @notice This contract is for creating a simple raffle
 * @dev Implements Chainlink VRFv 2.5
 */
contract Raffle {
    /* Errors */
    error Raffle__SendMoreToEnterRaffle();

    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() public payable {
        // require(msg.value >= i_entranceFee, "Not enough ETH sent!"); //! Not very gas efficient because we're storing a giant string
        // require(msg.value >= i_entranceFee, SendMoreToEnterRaffle()); //! Still not really gas efficient and it requires specific version of Solidity and specific compiler version
        if (msg.value < i_entranceFee) {
            //? Most gas efficient way to handle this
            revert Raffle__SendMoreToEnterRaffle();
        }
    }

    function pickWinner() public {}

    // Getter functions
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
