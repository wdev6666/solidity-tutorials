const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
const { NFT_COLLECTION_ADDRESS } = require("../constants");

const main = async () => { 
    const NFTCollectionContract = NFT_COLLECTION_ADDRESS;
    const nftTokenContract = await ethers.getContractFactory("NFTToken");
    const deployedNftTokenContract = await nftTokenContract.deploy(NFTCollectionContract);
    console.log("NFT Token Contract Address:", deployedNftTokenContract.address);
};

main().then(() => process.exit(0)).catch((error) => { 
    console.error(error);
    process.exit(1);
});