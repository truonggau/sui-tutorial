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
    
    expect result:

    ![Screenshot 2023-11-14 at 16 40 08](https://github.com/truonggau/sui-tutorial/assets/87189382/9d5ab74d-3fbe-474e-a2eb-adec10da3ddb)
    
  - pulish: ``` sui client publish --gas-budget 20000000 --skip-dependency-verification```

    expect result:

    ![Screenshot 2023-11-14 at 16 43 21](https://github.com/truonggau/sui-tutorial/assets/87189382/a6a3aee1-ca0e-4ece-b2b8-19cd942a3b3a)

  - mint:
    ```
      sui client call --package 0xda461615b9a44e4fe24a41321563299552c3682c44f854c97b35d1917db95c81 --module ebscoin  --function mint --args 0x5449caac1bd57de2c807f09ba1eb8ea04d5cd62805680e03e657b10866ad18a7 100000000 0xa86926937f93a1a5f1c37e247de3b571b781f988b3628f56e7d3956b6bd7f9e4 --gas-budget 200000000
    ```

     expect result:

    ![Screenshot 2023-11-14 at 16 46 36](https://github.com/truonggau/sui-tutorial/assets/87189382/a27325c5-5043-4b1c-a823-bcfb186ee609)

    result on suiscan:

    ![Screenshot 2023-11-14 at 16 50 56](https://github.com/truonggau/sui-tutorial/assets/87189382/c8c40802-1b00-4a5a-9fc5-c60e592d4295)

  - sui scan: https://suiscan.xyz/devnet/home
