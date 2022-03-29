const fs = require("fs");
const bscholders = require('./bscscan-export.js')

let rawdata = fs.readFileSync('./useless-snapshot.json');
let snapshot = JSON.parse(rawdata);

const snapshotItems = snapshot.data.items.map(x => x.address);
const bscHolders = bscholders.default;

console.log(snapshotItems.length);
console.log(bscHolders.length);


const total = snapshotItems.concat(bscHolders);

fs.writeFileSync('all-addresses.json', JSON.stringify(total));



//let intersection = snapshot.data.items.filter(x => bscholders.default.includes(x));

// Array.prototype.diff = function(arr2) { return this.filter(x => !arr2.includes(x)); }
// //console.log(snapshotItems.diff(bscHolders));
// console.log(bscHolders.diff(snapshotItems));