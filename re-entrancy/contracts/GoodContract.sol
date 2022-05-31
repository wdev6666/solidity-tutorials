// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract GoodContract {
    mapping(address => uint) public balances;

    function addBalance() public payable{
        balances[msg.sender] += msg.value; // Update the `balances` mapping to include the new ETH deposited by msg.sender
    }

    function withdraw() public {
        require(balances[msg.sender] > 0);
        (bool sent, ) = msg.sender.call{value: balances[msg.sender]}(""); // Send ETH worth `balances[msg.sender]` back to msg.sender

        /* This code becomes unreachable because the contract's balance is drained
         before user's balance could have been set to 0 */
        require(sent, "Failed to send ether");
    }
}