### DOCS
- https://github.com/sui-foundation/sui-move-intro-course/blob/main/unit-one/lessons/2_sui_project_structure.md

### CLI
- build
    ```
    sui move build
    ```
- publish:
    ```
    sui client publish --gas-budget 20000000 --skip-dependency-verification
    ```
- call:
    ```
    sui client call --package <PACKAGE_ID> --module <MODULE_NAME> --function <FUNCTION> --gas-budget 200000000
    ```