// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract NFTCollection is ERC721Enumerable, Ownable{
    
    // @dev _baseTokenURI for computing {tokenURI}. 
    //If set, the resulting URI for each token will be the concatenation of the `baseURI` and the `tokenId`.
    string _baseTokenURI;

    // _price is the price of one NFT-Collection NFT
    uint256 public _price = 0.01 ether;

    // _paused is used to pause the contract in the case of emergency
    bool public _paused;

    // Max number of NFTs
    uint256 public _maxTokenIds = 20;

    // Total NFTs minted
    uint256 public tokenIds;

    // Whitelist Contract instance
    IWhitelist whitelist;

    // Whether presale started or not
    bool public presaleStarted;

    // Whether presale ended or not
    uint256 public presaleEnded;

    modifier onlyWhenNotPaused {
        require(!_paused, "Contract currently paused!");
        _;
    }

    /**
    * @dev ERC721 constructor takes in a `name` and a `symbol` to the token collection.
    * name in our case is `NonFungibleToken` and symbol is `NFT`.
    * Constructor for NFTCollection takes in the baseURI to set _baseTokenURI for the collection.
    * It also initializes an instance of whitelist interface.
    */
    constructor(string memory baseURI, address whitelistContract) ERC721("NonFungibleToken", "NFT"){
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    // startPresale start the sale for whitelisted addresses
    function startPresale() public onlyOwner {
        presaleStarted = true;
        // Set presaleEnded time as current timestamp + 5 minutes
        presaleEnded = block.timestamp + 5 minutes;
    }

    // presaleMint allows a user to mint one NFT per transaction during presale
    function presaleMint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp < presaleEnded, "Presale is not started");
        require(whitelist.whitelistedAddresses(msg.sender), "You are not whitelisted");
        require(tokenIds < _maxTokenIds, "Exceeded max tokens");
        require(msg.value >= _price, "Ether sent is not correct");
        tokenIds += 1;
        // _safeMint is a safer version of _mint function
        _safeMint(msg.sender, tokenIds);
    }

    // mint allows a user to mint 1 NFT per transaction after the presale has ended
    function mint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp >= presaleEnded, "Presale has not ended yet.");
        require(tokenIds < _maxTokenIds, "Exceeded max tokens!");
        require(msg.value >= _price, "Ether sent is not correct!");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds);
    }

    /**
    * @dev _baseURI overides the Openzeppelin's ERC721 implementation which by default
    * returned an empty string for the baseURI
    */
    function _baseURI() internal view virtual override returns(string memory){
        return _baseTokenURI;
    }

    // setPaused makes the contract paused and unpaused
    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    // withdraw sends all the ether in the contract to the owner of the contract
    function withdraw() public onlyOwner {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send ether!");
    }

    // To receive Ether. msg.data must be empty
    receive() external payable{}

    // When msg.data is not empty
    fallback() external payable {}
}