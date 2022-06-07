const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require("../constants");

const main = async () => {
  const whitelistContract = WHITELIST_CONTRACT_ADDRESS;
  const metadataURL = METADATA_URL;
  const nftCollectionContract = await ethers.getContractFactory(
    "NFTCollection"
  );
  const deployedNFTCollectionContract = await nftCollectionContract.deploy(
    metadataURL,
    whitelistContract
  );
  console.log(
    "NFT Collection Contract Address: ",
    deployedNFTCollectionContract.address
  );
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
