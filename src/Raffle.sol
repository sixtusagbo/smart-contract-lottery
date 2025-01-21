// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * @title A simple raffle contract
 * @author Sixtus Agbo
 * @notice This contract is for creating a simple raffle
 * @dev Implements Chainlink VRFv 2.5
 */
contract Raffle {
    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() public payable {}

    function pickWinner() public {}

    // Getter functions
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
