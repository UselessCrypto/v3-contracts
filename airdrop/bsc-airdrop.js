const Web3 = require("web3");
const abi = require("./abi.json");
const abiAirdrop = require("./abi-airdrop.json");
const fs = require("fs");

const bigInt = require('big-integer');

const dryrun = false;

const rpcUrl = "http://172.18.2.152:8545";
const address = "0x2cd2664ce5639e46c6a3125257361e01d0213657";
const addressAirdrop = "0x43DA04C2fb4AE4E7b6Ed67a3ec9Be776F3400846";
const thread = 200;
const oldDeployerAmount = "398106534399733599862522000";


const deployerPrivateKey = process.env.PRIVATE_KEY || undefined;

if (!deployerPrivateKey) {
  console.error("Missing Deployer Private Key");
  process.exit(1);
}

let rawdata = fs.readFileSync("./lib/all-addresses.json");
let addys = JSON.parse(rawdata);

const lowerAddresses = addys.map(address => address.toLowerCase());
const uniqueAddress = Array.from(new Set(lowerAddresses));

let addresses = {};
const deployerAddress = "0x091dD81C8B9347b30f1A4d5a88F92d6F2A42b059";

const exclude = [
  "0x000000000000000000000000000000000000dead",  
];

const reclaim = [
  "0x2d045410f002a95efcee67759a92518fa3fce677",
  "0x8c128DBA2cB66399341AA877315BE1054be75da8",
  "0x2e62e57d1d36517d4b0f329490ac1b78139967c0",
  "0x2cd2664Ce5639e46c6a3125257361e01d0213657",
  "0x03F9332cBA1dFc80b503b7EE3A085FBB8532abea",
  "0xAA20a42631E8743132A35FE7337E5197dd78270B",
  "0x08A6cD8a2E49E3411d13f9364647E1f2ee2C6380",
  "0x8d2F3CA0e254e1786773078D69731d0c03fBc8DF",
  "0x91D3e6F63C910D11a0b52E9B7510734D4d131641",
  "0x429e3a111bE9896eD386D116d56907Af62232033",
  "0x2F72231f7A5d39317818Ab80dBBF7094D6398E7B",
  "0x022F269ecff478603a9Dd1FaECf6F1C64BcAfF8C",
  "0x2773eF6dc621C902DC14AE9949B5DA72C93fa38e",
  "0x1A1b088556206e5B24aeF1D4ba8c5fBAaDc8FbF1",
  "0x46F4cfd5e54b1c7527f1e961693F464FB1d1A755",
  "0xD886dd5D9f89dc5B589DFa4f72f26f8288e3e78A",
  "0x984D374aBC1BA7549df8a7D6d0242eE5E4E800E1",
  "0xF0514485F370D25bF5012c093514d520353D3415",
  "0x7c391fD1a8896Ef7F81C3230b44AEf685dc9b221",
  "0xc0D7979bE5E6189eD6a6FBd1B29c1b38Eb424FfB",
  "0x3316Fc333A85b7F0701166CB56d1D1742263b321",
  "0xea26191BA4d9CBbbE7Dd9eC911E00Dce740cE8fF",
  "0x138B98c68902ad50F50aFA0AaFb46160E5941D26",
  "0x2d72aAb6d81E8EE681430C13850bD77585F222Cb",
  "0x41d7acf06a064c8592c5f79ff53b15c6f2828cb9",
  "0x3799d7798c040826aa310c71107f20ec7315bb4f",
  "0x0a0944867ac84472d24deb09501cc78f73466fa0",
  "0xFE189c037286096a30dACc078d31546499104fb5",
];

const remapToDeployer = reclaim.map((x) => x.toString().toLowerCase());
const excludeAddresses = exclude.map((x) => x.toString().toLowerCase());

const web3 = new Web3(rpcUrl);

var BN = web3.utils.BN;

const account = web3.eth.accounts.privateKeyToAccount(deployerPrivateKey);
web3.eth.accounts.wallet.add(account);

(async () => {
  const token = new web3.eth.Contract(abi, address);
  const airdrop = new web3.eth.Contract(abiAirdrop, addressAirdrop);

  let totalWei = new BN(0);
  let totalTransactions = 0;
  let totalAddresses = 0;

  for (let i = 0; i < uniqueAddress.length; i += thread) {
    let users = [];
    let amounts = [];
    let totalChunkCount = 0;
    const chunk = uniqueAddress.slice(i, i + thread);
    // console.log(`CHUNK: ${i}`);
    for (let j = 0; j < chunk.length; j++) {
      try {
        let OGbalance = await token.methods.balanceOf(chunk[j]).call();
        
        let balance;

        balance = ((BigInt(OGbalance) * BigInt(1000))).toString();
        
        //Only used to fix air drop issue
        // if (BigInt(OGbalance) > BigInt(100000000000000000)) {
        //   balance = ((BigInt(OGbalance) * BigInt(1000)) - BigInt(OGbalance)).toString();
        // } else {
        //   balance = ((BigInt(OGbalance) * BigInt(1000))).toString();
        // }

        if (balance !== "0" && (BigInt(balance) < BigInt(100000000000000000000)) && (BigInt(balance) > BigInt(1000000000000000000))) {
          //Remap
          if (remapToDeployer.includes(chunk[j].toLowerCase())) {

            //LP POOL
            if (chunk[j].toLowerCase() === "0x08a6cd8a2e49e3411d13f9364647e1f2ee2c6380") {
              balance = (new BN(balance).sub(new BN(oldDeployerAmount))).toString()
            }

            console.log("REMAP: ", chunk[j]);
            chunk[j] = deployerAddress;
          }

          if (!excludeAddresses.includes(chunk[j].toLowerCase())) {
            users[j] = chunk[j];
            amounts[j] = balance;
            console.log(users[j], amounts[j]);          
            
            totalWei = new BN(totalWei).add(new BN(balance));
            totalChunkCount++;
          }
        }
      } catch (e) {
        console.log(e);
      }
    }

    let usersFiltered = users.filter(n => n);
    let amountsFiltered = amounts.filter(n => n);

    if (!dryrun && totalChunkCount > 0) {
      totalAddresses += usersFiltered.length;
      totalTransactions++;
      try {
        const result = await web3.eth
          .sendTransaction({
            from: account.address,
            to: addressAirdrop,
            gas: 25000000,
            data: airdrop.methods.airDrop(usersFiltered, amountsFiltered).encodeABI(),
          })
          .on("error", console.error);
        console.log(
          `Send tx: ${result.transactionHash} result: `,
          result.status
        );

      } catch (e) {
        console.log(e);
      }
      console.log("Total Chunk Count: ", totalChunkCount);
    }

    console.log('TOTAL: ', totalWei.toString())
    console.log('TRANSACTIONS COUNT: ', totalTransactions.toString())
    console.log('totalAddresses: ', totalAddresses.toString())
    
  }

})();
