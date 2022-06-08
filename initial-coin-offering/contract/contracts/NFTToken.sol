// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/access/Ownable.sol";
import "./INFTCollection.sol";

contract NFTToken is ERC20, Ownable{

    // Price of one token
    uint256 public constant tokenPrice = 0.001 ether;

    uint256 public constant tokenPerNFT = 10 * 10**18;

    // Max token supply
    uint256 public constant maxTotalSupply = 10000 * 10**18;

    // NFTCollection contract instance
    INFTCollection NFTCollection;

    mapping()
}