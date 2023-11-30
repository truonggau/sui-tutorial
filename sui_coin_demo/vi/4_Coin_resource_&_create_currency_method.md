# The `Coin` Resource and `create_currency` Method

Hãy cùng nhớ lại về generics cũng như witness pattern, Tiếp theo chúng ta sẽ cùng xem mã nguồn của `Coin` và hàm `create_currency`.

## The `Coin` Resource

Now we understand how generics work. We can revisit the `Coin` resource from `sui::coin`.  It's [defined](https://github.com/MystenLabs/sui/blob/main/crates/sui-framework/packages/sui-framework/sources/coin.move#L29) as the following:

Trước tiên hãy nhớ lại generics hoạt động như thế nào. Chúng ta có thể tìm thấy mã nguồn về `Coin` ở `sui::coin`.  It's [defined](https://github.com/MystenLabs/sui/blob/main/crates/sui-framework/packages/sui-framework/sources/coin.move#L29) giống như code dưới đây:

```rust
struct Coin<phantom T> has key, store {
        id: UID,
        balance: Balance<T>
    }
``` 

Mã nguồn `Coin` là 1 struct có 1 kiểu generic `T` và 2 trường dữ liệu, `id` và `balance`. `id` có kiểu `sui::object::UID` mà chúng ta đã thấy trong seri basic.

`balance` có kiểu [`sui::balance::Balance`](https://github.com/MystenLabs/sui/blob/main/crates/sui-framework/docs/balance.md#0x2_balance_Balance) và [defined](https://github.com/MystenLabs/sui/blob/main/crates/sui-framework/packages/sui-framework/sources/balance.move#L25)như sau:

```rust 
struct Balance<phantom T> has store {
    value: u64
}
```

Hãy nhớ lại [`phantom`](./3_witness_design_pattern.md#the-phantom-keyword), kiểu `T` được sử dụng trong `Coin` chỉ là tham số của 1 `phantom` type khác cho `Balance`, và trong `Balance` nó không được sử dụng trong bất kỳ trường nào do đó `T` là 1 tham số kiểu `phantom`.

`Coin<T>` phục vụ như 1 tài sản có thể trao đổi của 1 lượng nhất định các token loại `T`. Tài sản này có thể trao đổi giữa 2 địa chỉ hoặc là tiêu thụ bởi hàm trong smart contract.

## The `create_currency` Method

Hãy cùng xem xét cách hoạt động của `coin::create_currency` ở [source code](https://github.com/MystenLabs/sui/blob/main/crates/sui-framework/packages/sui-framework/sources/coin.move#L251):

```rust
    public fun create_currency<T: drop>(
        witness: T,
        decimals: u8,
        symbol: vector<u8>,
        name: vector<u8>,
        description: vector<u8>,
        icon_url: Option<Url>,
        ctx: &mut TxContext
    ): (TreasuryCap<T>, CoinMetadata<T>) {
        // Make sure there's only one instance of the type T
        assert!(sui::types::is_one_time_witness(&witness), EBadWitness);

        // Emit Currency metadata as an event.
        event::emit(CurrencyCreated<T> {
            decimals
        });

        (
            TreasuryCap {
                id: object::new(ctx),
                total_supply: balance::create_supply(witness)
            },
            CoinMetadata {
                id: object::new(ctx),
                decimals,
                name: string::utf8(name),
                symbol: ascii::string(symbol),
                description: string::utf8(description),
                icon_url
            }
        )
    }
``` 

`assert` kiểm tra rằng `witness` được truyền vào là 1 OTW hay không bằng cách sử dụng hàm [`sui::types::is_one_time_witness`](https://github.com/MystenLabs/sui/blob/main/crates/sui-framework/packages/sui-framework/sources/types.move) trong Sui Framework.

Hàm trên tạo và trả về 2 object, 1 là `TreasuryCap` và 1 là `CoinMetadata`.

### `TreasuryCap`

`TreasuryCap` là 1 tài sản và được đảm bảo chỉ tồn tại duy nhất bởi One Time Witness pattern:

```rust
    /// Capability allowing the bearer to mint and burn
    /// coins of type `T`. Transferable
    struct TreasuryCap<phantom T> has key, store {
            id: UID,
            total_supply: Supply<T>
        }
```

Nó chưa 1 trường là `total_supply` và có kiểu `Balance::Supply`:
```rust
/// A Supply of T. Used for minting and burning.
    /// Wrapped into a `TreasuryCap` in the `Coin` module.
    struct Supply<phantom T> has store {
        value: u64
    }
```

`Supply<T>` kiểm tra tổng số lượng của fungible token của type `T` hiện đang lưu hành. Bạn có thể thấy tại sao trường này phải là duy nhất vì việc có nhiều phiên bản `Supply` cho một token là vô nghĩa.
### `CoinMetadata`

`CoinMetadata` là nơi lưu trữ metadata của 1 fungible token đã được tạo. Nó gồm những trường sau:

- `decimals`: độ chính xác (số số 0 sau dấu ',') của fungible token
- `name`: Tên của fungible token
- `symbol`: Ký hiệu của fungible token
- `description`: Mô tả về fungible token
- `icon_url`: đường dẫn đến file chưa icon của fungible token

Thông tin chứa trong `CoinMetadata` có thể coi là tiêu chuẩn của 1 fungible token trong Sui, và có thể được sửa dụng bởi các ví cũng như trình duyệt để hiển thị fungible token đã được tạo thông qua `sui::coin` module.