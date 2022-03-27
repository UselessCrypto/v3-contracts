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
  const useless = await Useless.deploy("0x3485D4C9E7a7717466b3276Fbf3311aD3C1bE7Af", "0xD6C5B67a1989bA893f68C1f17fC6AC15a5C893A8", "0x2E77a36Bb7F5Da99b9224DA2165D57cF7aD3cd95");

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
