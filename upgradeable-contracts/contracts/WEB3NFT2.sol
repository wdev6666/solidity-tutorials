//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./WEB3NFT.sol";

contract WEB3NFT2 is WEB3NFT {
    function test() pure public returns(string memory){
        return "upgraded";
    }
}