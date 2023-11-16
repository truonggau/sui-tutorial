import { getFaucetHost, requestSuiFromFaucetV0 } from '@mysten/sui.js/faucet';
import fetch from "node-fetch";
globalThis.fetch = fetch
// const faucet = await requestSuiFromFaucetV0({
// 	host: getFaucetHost('devnet'),
// 	recipient: '0xa86926937f93a1a5f1c37e247de3b571b781f988b3628f56e7d3956b6bd7f9e4',
// });

// console.log("faucet: ", faucet);
import { getFullnodeUrl, SuiClient } from '@mysten/sui.js/client';

// Package is on Testnet.
const rpcUrl = getFullnodeUrl('devnet');
const client = new SuiClient({ url: rpcUrl });

const Package = '0x1f979e1e0931d5f162ce2ea755de3c638321db8dfa58c0b00601c43a0851eec4';

const MoveEventType = '<PACKAGE_ID>::<MODULE_NAME>::<METHOD_NAME>';

console.log(
    await client.getObject({
        id: Package,
        options: { showPreviousTransaction: true },
    }),
);

let unsubscribe = await client.subscribeEvent({
    filter: { Package },
    onMessage: (event) => {
        console.log('subscribeEvent', JSON.stringify(event, null, 2));
    },
});

process.on('SIGINT', async () => {
    console.log('Interrupted...');
    if (unsubscribe) {
        await unsubscribe();
        unsubscribe = undefined;
    }
});