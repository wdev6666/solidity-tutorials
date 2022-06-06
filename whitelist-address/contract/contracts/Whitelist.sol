// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Whitelist{
    // Max number of whitelisted addresses allowed
    uint8 public maxWhitelistedAddresses;

    // Mapping of whitelisted addresses
    // if an address is whitelisted, set true, false otherwise
    mapping(address => bool) public whitelistedAddresses;

    // numAddressesWhitelisted would be used to keep track of many addresses whitelisted
    uint8 public numAddressesWhitelisted;

    // Max number of whitelisted addresses
    // User will put at the time of deployment
    constructor(uint8 _maxWhitelistedAddresses){
        maxWhitelistedAddresses = _maxWhitelistedAddresses;
    }

    // addAddressToWhitelist - Adds the address of sender to the whitelist
    function addAddressToWhitelist() public {
        // check if address has already been whitelisted
        require(!whitelistedAddresses[msg.sender], "Sender has already been whitelisted!");

        //check if the numAddressesWhitelisted < maxWhitelistedAddress
        require(numAddressesWhitelisted < maxWhitelistedAddresses, "Limit reached!");

        // Add the address to whitelist
        whitelistedAddresses[msg.sender] = true;

        // Increase the number of whitelisted addresses
        numAddressesWhitelisted += 1;
    }
}