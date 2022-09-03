const ethers = require("ethers");
const abi = require("./abi.json");

const provider = new ethers.providers.JsonRpcProvider(
  "https://api.harmony.one"
);
const signer = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
const contract = new ethers.Contract(
   // "0xa002430E7895a6112A882DbC638486c20a697193",
  "0x0A34fE479d2442fB51333ac373dD2CBF02B6D949",
  abi,
  signer
);

(async () => {
  const tokenA = "0xC079d0385492Ac2D0e89ca079c186Dd71ef49B1e";
  const tokenB = "0xcF664087a5bB0237a0BAd6742852ec6c8d69A27a";
  const liquidity = "1911197320930000000000000";
  const amountAMin = "0";
  const amountBMin = "0";
  const to = "0x091dD81C8B9347b30f1A4d5a88F92d6F2A42b059";
  const deadline = Date.now() + 500;

  const result = await contract.functions.removeLiquidity(
    tokenA,
    tokenB,
    liquidity,
    amountAMin,
    amountBMin,
    to,
    deadline,
    {
      gasLimit: 6721900,
    }
  );
  console.log(result);
  console.log(await result.wait());
})();

//BALANCE 2123835756910000000000000
//HERMES LP 0xa002430E7895a6112A882DbC638486c20a697193
//USE 0xC079d0385492Ac2D0e89ca079c186Dd71ef49B1e
//ONE 0xcF664087a5bB0237a0BAd6742852ec6c8d69A27a
// HOW MUCH USE IN LP 8165132445220955662955848