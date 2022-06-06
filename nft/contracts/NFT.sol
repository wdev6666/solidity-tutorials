// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// GameItem is ERC721: says that the contract we are creating is importing ERC721.sol contract from openzeppelin contracts and using it
contract GameItem is ERC721{
    constructor() ERC721("GameItem", "ITM"){
        // mint an NFT to myself
        _mint(msg.sender, 1);
    }
}