const Web3 = require("web3");
const abi = require("./abi-migration.json");
const abiAirdrop = require("./abi-airdrop.json");

const rpcUrlBSC = "http://172.18.2.152:8545";
const rpcUrlHarmony = "https://api.s0.t.hmny.io/";
const deployerPrivateKey = process.env.PRIVATE_KEY || undefined;

//MIGRATION CONTRACT ON BSC
const addressMigration = "0xF4C1e1a747BdC22147b40349e8b6252360f55eea";

//AIRDROP CONTRACT ON HARMONY
const addressAirdrop = "0x40904e30f3D584cAB73C06b540020fA9F242D435";

const thread = 50;

if (!deployerPrivateKey) {
  console.error('Missing Deployer Private Key');
  process.exit(1);
}

(async () => {
  const web3 = new Web3(rpcUrlBSC);
  const migration = new web3.eth.Contract(abi, addressMigration);  
  const recipients = await migration.methods.getAllRecipients().call();

  let promises = recipients.map(async address => {
    const useless = await migration.methods.recipients(address).call();    
    return { address, useless }
  })

  const addresses = await Promise.allSettled(promises);

  const web3Harmony = new Web3(rpcUrlHarmony);
  const airdrop = new web3Harmony.eth.Contract(abiAirdrop, addressAirdrop);  
  const account = web3Harmony.eth.accounts.privateKeyToAccount(deployerPrivateKey);
  web3Harmony.eth.accounts.wallet.add(account);

  console.log(`TOTAL: ${addresses.length}`)
    
  for (let i = 0; i < addresses.length; i += thread) {
    let users = [];
    let amounts = [];
    const chunk = addresses.slice(i, i + thread);
    console.log(`CHUNK: ${i}`);
    for (let j = 0; j < chunk.length; j++) {
       users[j] = chunk[j].value.address;
       amounts[j] = chunk[j].value.useless;
       console.log(users[j], amounts[j]);
    }

    // const result = await web3Harmony.eth.sendTransaction({
    //   "from": account.address,
    //   "to": addressAirdrop,
    //   "gas": 2000000,
    //   "data": airdrop.methods.airDrop(users, amounts).encodeABI()
    // }).on('error', console.error);

    // console.log(`Send tx: ${result.transactionHash} result: `, result.status);
    
  }
})();
