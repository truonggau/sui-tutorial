### CLI:
- **BUILD**
    ```
    sui move build
    ```
    expect result:
    ![Screenshot 2023-11-14 at 16 17 55](https://github.com/truonggau/sui-tutorial/assets/87189382/408655cf-8349-4c8f-9dcb-90ad21f53457)

- **PUBLISH**
    ```
    sui client publish --gas-budget 20000000 --skip-dependency-verification
    ```
    expect result:
    ![Screenshot 2023-11-14 at 16 22 08](https://github.com/truonggau/sui-tutorial/assets/87189382/6022a0c0-6307-4fcd-8e74-c595deb09dc5)

- **INTERACTIVE**
    ```
     sui client call --package <PACKGE_ID> --module <MODULE_NAME>  --function <FUNCTION_NAME> --args <TREASURY_CAP> <AMOUNT> <RECIPIENT> --gas-budget 20000000
    ```
    expect result:
      ![Screenshot 2023-11-14 at 16 25 48](https://github.com/truonggau/sui-tutorial/assets/87189382/285374e6-5815-4ba0-9949-51fd388f18fd)
    object show on sui-scan:
      ![Screenshot 2023-11-14 at 16 27 05](https://github.com/truonggau/sui-tutorial/assets/87189382/942b8b3e-92d8-44da-90d4-83fec86dafba)

