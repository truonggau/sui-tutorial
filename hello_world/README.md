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
     sui client call --package 0x62d06aca19767830bf2307d0653ba0d1808ec5640ef40d8f1c79143916f16efb --module transcript  --function create_transcript_object --args 8 8 9 --gas-budget 20000000

     sui client call --package f54e9aff4606d7b92a1e4c2cc844706bb45c4200d6348af1a3a3f7b3d3f7c3ad --module transcript_2  --function unpack_wrapped_transcript --args 0xe0806b7d811c7d1aedeaac14999d011f6f832636f941235512fefd563cef21d9 --gas-budget 20000000
    ```
    expect result:
      ![Screenshot 2023-11-14 at 16 25 48](https://github.com/truonggau/sui-tutorial/assets/87189382/285374e6-5815-4ba0-9949-51fd388f18fd)
    object show on sui-scan:
      ![Screenshot 2023-11-14 at 16 27 05](https://github.com/truonggau/sui-tutorial/assets/87189382/942b8b3e-92d8-44da-90d4-83fec86dafba)

