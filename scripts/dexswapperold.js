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
  const Useless = await hre.ethers.getContractFactory("DEXSwapper");
  const useless = await Useless.deploy("0xcF664087a5bB0237a0BAd6742852ec6c8d69A27a", "0x091dD81C8B9347b30f1A4d5a88F92d6F2A42b059");
  
  await useless.deployed();

  console.log("Old Dex Swapper deployed to:", useless.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
