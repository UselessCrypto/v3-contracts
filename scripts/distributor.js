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
  const Distributor = await hre.ethers.getContractFactory("Distributor");
  
  //ARGS Viper Router, WONE
  const distributor = await Distributor.deploy('0xea589e93ff18b1a1f1e9bac7ef3e86ab62addc79', '0xcf664087a5bb0237a0bad6742852ec6c8d69a27a');

  await distributor.deployed();

  console.log("Distributor deployed to:", distributor.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
