# HELLO WORLD

### SETUP ENV:

- #### INSTALL SUI:
  - **INSTALL RUST & CARGO FIRST:**

    Use the following command to install Rust and Cargo on macOS or Linux:
    
    ```
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    ```

    If you use Windows 11, see information about using the [Rust installer](https://www.rust-lang.org/tools/install) on the Rust website. The installer checks for C++ build tools and prompts you to install them if necessary. Select the option that best defines your environment and follow the instructions in the install wizard.

    Sui uses the latest version of Cargo to build and manage dependencies. See the [Cargo installation](https://doc.rust-lang.org/cargo/getting-started/installation.html) page on the Rust website for more information.

    Use the following command to update Rust with ```rustup```:
    ```
    rustup update stable
    ```
  - **Additional prerequisites by operating system:**
    
    [References](https://docs.sui.io/guides/developer/getting-started/sui-install)
    ```
    Incase i will use ubuntu as the example
    ```
    The prerequisites needed for the Linux operating system include:

    - cURL
    - Rust and Cargo
    - Git CLI
    - CMake
    - GCC
    - libssl-dev
    - libclang-dev
    - libpq-dev
    - build-essential

    Install the prerequisites listed in this section. Use the following command to update apt-get:
      ```
      sudo apt-get update
      ```
    **All Linux prerequisites**

    Reference the relevant sections that follow to install each prerequisite individually, or run the following to install them all at once:
    ```
    sudo apt-get install curl git-all cmake gcc libssl-dev pkg-config libclang-dev libpq-dev build-essential
    ```
    **cURL**

    Install cURL with the following command:
    ```
    sudo apt-get install curl
    ```
    Verify that cURL installed correctly with the following command:
    ```
    curl --version
    ```
    **Git CLI**

    Run the following command to install Git, including the Git CLI:
    ```
    sudo apt-get install git-all
    ```
    For more information, see Install Git on Linux on the GitHub website.

    **CMake**

    Use the following command to install CMake.
    ```
    sudo apt-get install cmake
    ```
    To customize the installation, see Installing CMake on the CMake website.

    **GCC**

    Use the following command to install the GNU Compiler Collection, gcc:
    ```
    sudo apt-get install gcc
    ```
    **libssl-dev**

    Use the following command to install libssl-dev:
    ```
    sudo apt-get install libssl-dev
    ```
    If the version of Linux you use doesn't support libssl-dev, find an equivalent package for it on the ROS Index.

    (Optional) If you have OpenSSL you might also need to also install pkg-config:
    ```
    sudo apt-get install pkg-config
    ```
    **libclang-dev**

    Use the following command to install libclang-dev:
    ```
    sudo apt-get install libclang-dev
    ```
    If the version of Linux you use doesn't support libclang-dev, find an equivalent package for it on the ROS Index.

    **libpq-dev**

    Use the following command to install libpq-dev:
    ```
    sudo apt-get install libpq-dev
    ```
    If the version of Linux you use doesn't support libpq-dev, find an equivalent package for it on the ROS Index.

    **build-essential**

    Use the following command to install build-essential:
    ```
    sudo apt-get install build-essential
    ```

    

  - **Install Sui binaries from source**
    
    Run the following command to install Sui binaries from the testnet branch:
    ```
    cargo install --locked --git https://github.com/MystenLabs/sui.git --branch testnet sui
    ```
    The install process can take a while to complete. You can monitor installation progress in the terminal. If you encounter an error, make sure to install the latest version of all prerequisites and then try the command again.

    To update to the latest stable version of Rust:
    ```
    rustup update stable
    ```
    The command installs Sui components in the ~/.cargo/bin folder.
    
    - if you have issue with `wsl` when building. Pleas follow [this solution](https://github.com/MystenLabs/sui/issues/14255#issuecomment-1794062489)
  - **Upgrade Sui binaries**
    
    If you previously installed the Sui binaries, you can update them to the most recent release with the same command you used to install them:
    ```
    cargo install --locked --git https://github.com/MystenLabs/sui.git --branch devnet sui
    ```

### Sui Project Structure 

- #### Sui Module and Package

  - A Sui module is a set of functions and types packed together which the developer publishes under a specific address 

  - The Sui standard library is published under the `0x2` address, while user-deployed modules are published under a pseudorandom address assigned by the Sui Move VM

  - Module starts with the `module` keyword, which is followed by the module name and curly braces - inside them, module contents are placed:

      ```rust
      module hello_world::hello_world {
          // module contents
      }
      ```

  - Published modules are immutable objects in Sui; an immutable object is an object that can never be mutated, transferred, or deleted. Because of this immutability, the object is not owned by anyone, and hence it can be used by anyone

  - A Move package is just a collection of modules with a manifest file called Move.toml

- #### Initializing a Sui Move Package

  `sui move new <PACKAGE NAME>`

  For our example in this unit, we will start a Hello World project:

  `sui move new hello_world`

  This creates: 
  - the project root folder `hello_world`
  - the `Move.toml` manifest file
  - the `sources` subfolder, which will contain Sui Move smart contract source files

    - ##### `Move.toml` Manifest Structure

      `Move.toml` is the manifest file of a package and is automatically generated in the project root folder. 

      `Move.toml` consists of three sections:

    - `[package]` Defines the name and version number of the package
    - `[dependencies]` Defines other packages that this package depends on, such as the Sui standard library; other third-party dependencies should be added here as well
    - `[addresses]` Defines aliases for addresses in the package source code

  - ##### Sample `Move.toml` File

    This is the `Move.toml` generated by the Sui CLI with the package name `hello_world`:


    ```rust
    [package]
    name = "hello_world"
    version = "0.0.1"

    [dependencies]
    Sui = { git = "https://github.com/MystenLabs/sui.git", subdir = "crates/sui-framework/packages/sui-framework", rev = "framework/testnet" }


    [addresses]
    hello_world =  "0x0"
    ```

    We see that the Sui standard library dependency here is defined using a GitHub repo, but it can also point to a local binary using its relative or absolute file path, for example:

    ```rust
    [dependencies]
    Sui = { local = "../sui/crates/sui-framework/packages/sui-framework" } 
    ```

- #### Sui Module and Package Naming

  - Sui Move module and package naming convention uses snake casing, i.e. this_is_snake_casing.

  - A Sui module name uses the Rust path separator `::` to divide the package name and the module name, examples:
      1. `unit_one::hello_world` - `hello_world` module in `unit_one` package
      2. `capy::capy` - `capy` module in `capy` package

  - For more information on Move naming conventions, please check [the style section](https://move-language.github.io/move/coding-conventions.html#naming) of the Move book. 
