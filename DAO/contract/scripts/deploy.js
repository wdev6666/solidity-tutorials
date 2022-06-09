const { ethers } = require("hardhat");
const { NFT_CONTRACT_ADDRESS } = require("../constants");

const main = async () => {
  // Deploy the FakeNFTMarketplace contract first
  const FakeNFTMarketplace = await ethers.getContractFactory(
    "FakeNFTMarketplace"
  );
  const fakeNftMarketplace = await FakeNFTMarketplace.deploy();
  await fakeNftMarketplace.deployed();

  console.log("FakeNFTMarketplace deployed to: ", fakeNftMarketplace.address);

  // Now deploy the CryptoDevsDAO contract
  const DAO = await ethers.getContractFactory("DAO");
  const DAOdeploy = await DAO.deploy(
    fakeNftMarketplace.address,
    NFT_CONTRACT_ADDRESS,
    {
      // This assumes your account has at least 1 ETH in it's account
      // Change this value as you want
      value: ethers.utils.parseEther("1"),
    }
  );
  await DAOdeploy.deployed();

  console.log("DAO deployed to: ", DAOdeploy.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });