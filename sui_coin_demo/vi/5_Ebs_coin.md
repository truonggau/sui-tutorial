# EBS Coin Example

Chúng ta đã tìm hiểu mã nguồn về `sui::coin` module, sau đây hãy cùng xem 1 ví dụ đơn gỉan để tạo 1 fungible token với 1 smart contract quản lý đáng tin cũng như có khả năng mint, burn cũng như nhiều ví dụ ERC-20

## Smart Contract

Bạn có thể tham khảo toàn bộ code ở [EBS Coin example contract](./sources/ebs_coin.move).

Với những chi tiết chúng ta đã tìm hiểu đến giờ smart contract này sẽ khá dễ hiểu. Nó sẽ tuân theo [One Time Witness](./witness_design_pattern.md#one-time-witness) pattern với `witness` có tên là `EBSCOIN`, và sẽ được tự động tạo ra bởi hàm `init`.

Hàm `init` gọi đến `coin::create_currency` để lấy `TreasuryCap` và `CoinMetadata`. Tham số được truyền vào hàm là các trường của object `CoinMetadata`, bao gồm tên, ký hiệu, icon URl, ...

`CoinMetadata` sẽ ngay lập tức bị đóng băng ngày lập tức thông qua hàm `transfer::freeze_object`, và nó trở thành [shared immutable object](../basic_example/2_ownership.md#shared-immutable-objects) và nó có thể được đọc bởi bất kỳ địa chỉ nào.

[TreasuryCap Capability](../basic_example/6_capability_design_pattern.md) đã được sử dụng như 1 cách để quản lý quyền `mint` và `burn` để tạo và tiêu huỷ object `Coin<EBSCOIN>`.

## Publishing and CLI Testing

### Publish the Module

Trong folder [fungible_tokens](./), chạy lệnh:

```bash
    sui client publish --gas-budget 10000000
```

Bạn nên nhận được output:

![Publish Output](https://github.com/truonggau/sui-tutorial/assets/87189382/a6a3aee1-ca0e-4ece-b2b8-19cd942a3b3a)

The two immutable objects created are respectively the package itself and the `CoinMetadata` object of `EBS Coin`. And the owned object passed to the transaction sender is the `TreasuryCap` object of `EBS Coin`. 

Export the object IDs of the package object and the `TreasuryCap` object to environmental variables:

```bash
export PACKAGE_ID=<package object ID from previous output>
export TREASURYCAP_ID=<treasury cap object ID from previous output>
```

### Minting Tokens

Để mint `EBS` tokens, chúng ta có thể tham khảo lệnh dưới đây:

```bash
    sui client call --function mint --module EBS --package $PACKAGE_ID --args $TREASURYCAP_ID \"<amount to mint>\" <recipient address> --gas-budget 10000000
```

*💡Lưu ý: như trong Sui binary phiên bản 0.21.0, `u64` phải được truyền trong chuỗi nháy "" như lệnh ở trên. Điều này có thể thay đổi trong tương lai.*

![Minting](https://github.com/truonggau/sui-tutorial/assets/87189382/c8c40802-1b00-4a5a-9fc5-c60e592d4295)

Export object ID của object `COIN<EBSCOIN>` vừa tạo trên bash:

```bash
export COIN_ID=<coin object ID from previous output>
```

Kiểm tra `Supply` trong `TreasuryCap<EBSCOIN>` nên tăng với mỗi coin được mint ra. 

### Burning Tokens

Để burn 1 object `COIN<EBSCOIN>` đã tồn tại, chúng ta sẽ sử dụng lệnh sau:

```bash
    sui client call --function burn --module <Module_name> --package $PACKAGE_ID --args $TREASURYCAP_ID $COIN_ID --gas-budget 10000000
```

Kiểm tra `Supply` trong `TreasuryCap<EBSCOIN>` nên giảm với mỗi coin được mint ra. 

*Exercise: 1 fungible token cần những tính năng gì nữa? Bạn nên tìm hiểu thêm về lập trình trong Move để có thể viết các phương thức này.*

