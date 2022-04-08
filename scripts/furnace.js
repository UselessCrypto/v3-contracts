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
  const Useless = await hre.ethers.getContractFactory("Furnace");
  const useless = await Useless.deploy("0xC079d0385492Ac2D0e89ca079c186Dd71ef49B1e", "0xaa8f34c62c5dce55290d301a39932e843968e5de", "0x29999A965FBD70DCCD805efC5e6701FAd141D164");

  await useless.deployed();

  console.log("Furnace deployed to:", useless.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
