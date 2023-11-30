*Chúng ta đã hoàn thành việt phát hành 1 đồng coin - fungible token trên Sui ở phần trước. Để kết thúc seri chúng ta sẽ tìm hiểu về viết Test trên Sui.*
# Unit Testing

Sui hỗ trợ test framework. Tham khảo [Move Testing Framework](https://github.com/move-language/move/blob/main/language/documentation/book/src/unit-testing.md). Here, we will create some unit tests for `Ebs Coin` để hiểu kỹ hơn về các viết unit test và chạy unit test.

## Testing Environment

Sui Move test code sẽ giống như tất cả Sui Move code, nhưng nó sẽ có 1 số chú thích và phương thức để phân biết nó và phần code thật sự của dự án.
Phương thức Test hay module sẽ bắt đầu với chú thích `#[test]` hoặc `#[test_only]`

```rust
#[test_only]
module fungible_tokens::ebs_tests {
  #[test]
  fun mint_burn() {
  }
}
```
Chúng ta sẽ thêm unit test cho `Ebs Coin` vào trong 1 module test riêng biệt gọi là `ebs_tests`.

Mỗi phương thức trong module có thể xem như 1 bài test gồm nhiều giao dịch. Chúng ta sẽ viết 1 unit test gọi là `mint_burn`.

## Test Scenario

Trong môi trường testing environment, chúng ta sẽ chủ yếu dùng gói [`test_scenario` package](https://github.com/MystenLabs/sui/blob/main/crates/sui-framework/packages/sui-framework/sources/test/test_scenario.move) để mô phỏng thực tế. Object chính mà chúng ta cần hiểu và tương tác với là `Scenario`. 1 object `Scenario` mô phỏng 1 chuỗi nhiều giao dịch và nó có thể được tạo với địa chỉ người gửi như dưới đây:

```rust
  // Initialize a mock sender address
  let addr1 = @0xA;
  // Begins a multi-transaction scenario with addr1 as the sender
  let scenario = test_scenario::begin(addr1);
  ...
  // Cleans up the scenario object
  test_scenario::end(scenario);  
```

*💡Lưu ý rằng object `Scenario` không thể bị huỷ, Nên nó cần được dọn dẹp triệt để ở kết thúc của kịch bản test với hàm `test_scenario::end`.*

### Initializing the Module State

Để test module `EBS Coin` chúng ta cần khởi tại trạng thái của module. Vì module chúng ta có hàm `init`, đầu tiên chúng ta tạo ra hàm init `test_only` bên trong module `ebs`:

```rust
#[test_only]
    /// Wrapper of module initializer for testing
    public fun test_init(ctx: &mut TxContext) {
        init(EBS {}, ctx)
    }
```

Sau đây là một hàm `init` mô phỏng chỉ được sử dụng trong testing. Sau đó chúng ta sẽ khởi tại trạng thái như môi trường thật bằng hàm sau:

```rust
    // Run the Ebs Coin module init function
    {
        ebs::test_init(ctx(&mut scenario))
    };
```

### Minting 

Chúng ta sẽ sử dụng hàm [`next_tx`](https://github.com/MystenLabs/sui/blob/main/crates/sui-framework/packages/sui-framework/sources/test/test_scenario.move#L103) để đi đến giao dịch tiếp thep trong kịch bản của chúng ta khi muốn mint 1 object `Coin<EBS>`.

Để làm được thế chúng ta cần trích xuất object `TreasuryCap<EBS>`. Chúng ta sử dụng 1 phương thức testing đặc biệt là `take_from_sender` để truy suất thông tin từ kịch bản của chúng ta. Lưu ý rằng chúng ta cần truyền tham số vào trong `take_from_sender` - type object chúng ta muốn truy suất. 

Sau đó chúng ta gọi hàm `ebs::mint` cùng với tất cả các tham số cần thiết.

Cuối cùng, chúng ta sẽ thử trả về object `TreasuryCap<EBS>` đến địa chỉ người gửi bằng phương thức `test_scenario::return_to_address`.

```rust
next_tx(&mut scenario, addr1);
        {
            let treasurycap = test_scenario::take_from_sender<TreasuryCap<EBS>>(&scenario);
            ebs::mint(&mut treasurycap, 100, addr1, test_scenario::ctx(&mut scenario));
            test_scenario::return_to_address<TreasuryCap<EBS>>(addr1, treasurycap);
        };
```

### Burning 

Để test việc burn 1 token, quy trình cũng sẽ tương tự như khi mint 1 token. Chỉ khác là để burn 1 token chúng ta cần trích suất object `Coin<EBS>` từ người đã mint ra object đó.

## Running Unit Tests

Toàn bộ [`ebs_tests`](./sources/ebs_coin_test.move) nằm trong folder `example_projects`.

Để thực thi unit tests chúng ta đi đến thư mục dự án và chạy lệnh dưới đây:

```bash
  sui move test
```

Bạn sẽ thấy kết quả console như sau để biết unit test thành công hay thất bại.
![Screenshot from 2023-11-24 23-14-17](https://github.com/truonggau/sui-tutorial/assets/87189382/aee02c8c-cd7f-4ca2-9af5-4789346ac36c)

