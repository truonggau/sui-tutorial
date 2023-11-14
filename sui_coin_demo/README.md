# Sui-coin-demo

- **Docs**: https://github.com/sui-foundation/sui-move-intro-course/blob/main/unit-three/lessons/5_managed_coin.md

- **Cli**:
  - fauct:
    ``` 
    curl --location --request POST 'https://faucet.devnet.sui.io/gas' \
          --header 'Content-Type: application/json' \
          --data-raw '{
          "FixedAmountRequest": {
              "recipient": "<YOUR SUI ADDRESS>"
            }  
      }'
    ```
  - build: ``` sui move build ```
  - pulish: ``` sui client publish --gas-budget 20000000 --skip-dependency-verification```
  - mint:
    ```
      sui client call --package 0xda461615b9a44e4fe24a41321563299552c3682c44f854c97b35d1917db95c81 --module ebscoin  --function mint --args 0x5449caac1bd57de2c807f09ba1eb8ea04d5cd62805680e03e657b10866ad18a7 100000000 0xa86926937f93a1a5f1c37e247de3b571b781f988b3628f56e7d3956b6bd7f9e4 --gas-budget 20000000
    ```
  - sui scan: https://suiscan.xyz/devnet/home
