const https = require('https');
const fs = require('fs');

const API_KEY = "ckey_432ee5593c1040b397d5a74c95a"
const ADDRESS = "0x2cd2664Ce5639e46c6a3125257361e01d0213657"
const CHAIN_ID = 56
const SNAPSHOT_FILE_NAME = "useless-snapshot.json"
const ARRAY_FILE_NAME = "arrays.json"
const TAKE_SNAPSHOT = true;
const BUILD_ARRAY = true;

/*
    Simple function for creating a snapshot of holders
    fileName: name of the file you want the json or csv out put written to.
    covalentApiKey: register for a free account at covalent for an api key
    chainID: blockchain ID
    address: contract address
    block: block number
    pageSize: results per request
    format: json or csv (default: json)
 */
function takeSnapshot(fileName, covalentApiKey, chainID, address, block, pageSize, format, callback=()=>{}) {
    block = block ? `block-height=${block}&`: '';
    pageSize = pageSize ? `page-size=${pageSize}&` : '';
    format = format ? `format=${format}&` : '';
    const options = {
        hostname: 'api.covalenthq.com',
        port: 443,
        path: `/v1/${chainID}/tokens/${address}/token_holders/?quote-currency=USD&${block}${pageSize}${format}&key=${covalentApiKey}`,
        method: 'GET'
    }
    const stream = fs.createWriteStream(fileName);
    stream.on("close", callback)
    https.request(options, (results) => {
        results.pipe(stream);
    }).on('error', error=>console.error(error)).end();
}

/*
10546288 (3.0s)https://bscscan.com/blocks
TRANSACTIONS
 */

if (TAKE_SNAPSHOT) {
    takeSnapshot('useless-snapshot.json', API_KEY, CHAIN_ID, ADDRESS, undefined, 20600, undefined,() => {
        if (BUILD_ARRAY) {
            buildArray()
        }
    });

} else if (BUILD_ARRAY) {

    buildArray()
}

function buildArray(arrayLength=1) {
    console.log(`Building array from snapshot ${SNAPSHOT_FILE_NAME}`)
    let rawdata = fs.readFileSync(SNAPSHOT_FILE_NAME);
    let snapshot = JSON.parse(rawdata);
    let block = 1;
    let users = [];
    let output = {}
    let amounts = []
    let holders = 0
    let arrays = 0
    snapshot.data.items.forEach(
        (item) => {

            users.push(item.address);
            amounts.push(item.balance);
            holders++;
            if (users.length > arrayLength) {
                output[`block${block++}`] = {users, amounts};
                users = [];
                amounts = []
                arrays++;
            }
        }
    )

    fs.writeFileSync(ARRAY_FILE_NAME, JSON.stringify(output, null, 0));
    console.log(`build total of ${arrays} arrays for ${holders} holders`);
}