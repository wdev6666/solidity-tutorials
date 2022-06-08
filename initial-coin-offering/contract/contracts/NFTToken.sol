// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./INFTCollection.sol";

contract NFTToken is ERC20, Ownable{

    // Price of one token
    uint256 public constant tokenPrice = 0.001 ether;

    uint256 public constant tokenPerNFT = 10 * 10**18;

    // Max token supply
    uint256 public constant maxTotalSupply = 10000 * 10**18;

    // NFTCollection contract instance
    INFTCollection NFTCollection;

    mapping(uint256 => bool) public tokenIdsClaimed;

    constructor(address _nftCollectionContract) ERC20("NFT Token", "NFT"){
        NFTCollection = INFTCollection(_nftCollectionContract);
    }

    function mint(uint256 amount) public payable{
        uint256 _requiredAmount = tokenPrice * amount;
        require(msg.value >= _requiredAmount, "Ether sent is incorrect!");
        uint256 amountWithDecimals = amount * 10**18;
        require((totalSupply() + amountWithDecimals) <= maxTotalSupply, "Exceeded max total supply available!");
        _mint(msg.sender, amountWithDecimals);
    }

    function claim() public {
        address sender = msg.sender;
        uint256 balance = NFTCollection.balanceOf(sender);
        require(balance > 0, "You don't own any NFT");
        uint256 amount = 0;
        for (uint256 i = 0; i < balance; i++){
            uint256 tokenId = NFTCollection.tokenOfOwnerByIndex(sender, i);
            if(!tokenIdsClaimed[tokenId]){
                amount += 1;
                tokenIdsClaimed[tokenId] = true;
            }
        }
        require(amount > 0, "You have already claimed all the tokens.");
        _mint(msg.sender, amount * tokenPerNFT);
    }

    // Withdraw all ETH and tokens sent to the contract
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether!");
    }

    receive() external payable{}
    fallback() external payable{}
}