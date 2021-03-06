// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Migration = await hre.ethers.getContractFactory("Airdrop");
  const migration = await Migration.deploy("0xa4352f5Dd01ebde2d413D3a4B315fDFBc19879bC");
  //("0xC079d0385492Ac2D0e89ca079c186Dd71ef49B1e");

  await migration.deployed();

  console.log("Migration deployed to:", migration.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
