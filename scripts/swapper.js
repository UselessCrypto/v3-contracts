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
  const Swap = await hre.ethers.getContractFactory("Swapper");
  const useless = await Swap.deploy('0xf012702a5f0e54015362cBCA26a26fc90AA832a3', '0xC079d0385492Ac2D0e89ca079c186Dd71ef49B1e');

  await useless.deployed();

  console.log("Swapper v3 deployed to:", useless.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
