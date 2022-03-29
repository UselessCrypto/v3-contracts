const Web3 = require("web3");
const abi = require("./abi-migration.json");
const abiAirdrop = require("./abi-airdrop.json");
const fs = require('fs');
var BN = Web3.utils.BN;


const rpcUrlBSC = "http://172.18.2.152:8545";
const deployerPrivateKey = process.env.PRIVATE_KEY || undefined;
const snapshotArrays = "mapped-arrays.json";

//BSC AIRDROP CONTRACT
const addressAirdrop = "0x43DA04C2fb4AE4E7b6Ed67a3ec9Be776F3400846";

if (!deployerPrivateKey) {
  console.error('Missing Deployer Private Key');
  process.exit(1);
}

let total = BigInt(0);

(async () => {
  const web3 = new Web3(rpcUrlBSC);    
  const airdrop = new web3.eth.Contract(abiAirdrop, addressAirdrop);  
  const account = web3.eth.accounts.privateKeyToAccount(deployerPrivateKey);
  web3.eth.accounts.wallet.add(account);

  const blocks = JSON.parse(fs.readFileSync(snapshotArrays));

  

  for (const [block, data] of Object.entries(blocks)) {

    console.log(`-=-=-=-=-=-=-=-=-=-=-=-= ${block} =-=-=-=-=-=-=-=-=-=-=-=-=-=-`);
    //console.log(data.users);
    data.amounts.forEach(a => {
      //console.log(a);
      total = total + BigInt(a);
      //total.add(new BN(a));
    })
  }

  console.log(Web3.utils.fromWei(total.toString(), 'gwei'));

  // console.log(`TOTAL: ${addresses.length}`)
    
  // for (let i = 0; i < addresses.length; i += thread) {
  //   let users = [];
  //   let amounts = [];
  //   const chunk = addresses.slice(i, i + thread);
  //   console.log(`CHUNK: ${i}`);
  //   for (let j = 0; j < chunk.length; j++) {
  //      users[j] = chunk[j].value.address;
  //      amounts[j] = chunk[j].value.useless;       
  //   }

  //   const result = await web3Harmony.eth.sendTransaction({
  //     "from": account.address,
  //     "to": addressAirdrop,
  //     "gas": 2000000,
  //     "data": airdrop.methods.airDrop(users, amounts).encodeABI()
  //   }).on('error', console.error);

  //   console.log(`Send tx: ${result.transactionHash} result: `, result.status);
  //   process.exit(0);
  // }
})();
