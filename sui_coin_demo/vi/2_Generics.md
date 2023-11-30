*Đầu tiên chúng ta sẽ tìm hiểu về Generics*
# Intro to Generics

Generics là đại diện thay thế trưu tượng cho các type hoặc các thuộc tính cụ thể. Chúng hoạt động tương tự như [generics in Rust](https://doc.rust-lang.org/stable/book/ch10-00-generics.html), và có thể được sử dụng cho phép code linh hoạt hơn, tránh sự trùng lặp code khi viết code Move.

Generics là một khái niệm quan trọng trong Sui Move, và rất quan trọng để hiểu cũng như hình dung về cách nó hoạt động, vì vậy hãy dành thời gian để chắc chắn bạn hiểu đầy đủ về `Generics`

## Generics Usage

### Using Generics in Structs

Sau đây hãy cùng xem xét 1 ví dụ cơ bản để generics tạo ra object `Box` và `Box` có thể giữa bất kỳ kiểu nào trong Sui Move

Đầu tiên nếu không dùng generics, chúng ta có thể định nghĩa 1 `Box` chứa kiểu `u64` như sau:
```rust
module  generics::storage {
    struct Box {
        value: u64
    }
}
```

Tuy nhiên kiểu `Box` như trên sẽ chỉ có thể giữa 1 giá trị có kiểu `u64`. Để `Box` có thể giữa bất kỳ kiểu dữ liệu nào chúng ta cần áp dụng generics. Code sẽ được sửa lại như sau:
```rust
module  generics::storage {
    struct Box<T> {
        value: T
    }
}
```

#### Ability Constraints

Chúng ta có thể thêm điều kiện thi hành để chắc chắn kiểu được truyền vào `Box` phải có những khả năng nhất định - ở đây là có thể được lưu trữ store và drop. Code sẽ trở thành như sau:
```rust
module  generics::storage {
    // T must be copyable and droppable 
    struct Box<T: store + drop> has key, store {
        value: T
    }
}
```

Phải lưu ý là loại bên trong `T` trong ví dụ trên phải đáp ứng các hạn chế về khả năng do cùng chưa bên ngoài quy định. Trong ví dụ trên `T` phải có thuộc tính `store`, như `Box` có `store` và `Key`. Tuy nhiên, `T` cũng có thể có các khả năng mà vùng chứa không có như `drop` chẳng hạn. 

Chú ý nếu vùng chứa đc phép chứa 1 loại mà không tuân theo các quy định của chính nó, nó sẽ vi phạm thuộc tính của chính nó. 1 `Box` không thể lựu trữ được nếu nội dung của nó không thể được lưu trữ.

Trong phần tiếp theo chúng ta sẽ tìm hiểu thêm về 1 số cách khác để lách qua quy tắc này bằng cách sử dụng `phantom`.

*Xem thêm [generics project](./sources/generics.move) ở trong `example_projects` để hiểu hơn về ví dụ cụ thể.*

### Using Generics in Functions

Để viết 1 hàm trả về 1 thể hiện của `Box` và cho phép đối số truyền vào là bất kỳ loại nào cho trường `value`, chúng ta có thể sử dụng generics khi định nghĩa hàm. Hàm có thể được định nghĩa như sau:

```rust
public fun create_box<T>(value: T): Box<T> {
        Box<T> { value }
    }
```

Nếu chúng ta muốn hạn chế phương thúc chỉ cho phép các loại cụ thể cho `value`, chúng ta sẽ chỉ định loại dữ liệu mong muốn vào hàm như sau:

```rust
public fun create_box(value: u64): Box<u64> {
        Box<u64>{ value }
    }
```
 
Hàm trên sẽ chỉ cho phép đầu vào là kiểu `u64`, trong khi vẫn sử dụng 1 cấu trúc `Box`. 

#### Calling Functions with Generics

Để gọi hàm có chứa kiểu dữ liệu generics, chúng ta phải chỉ định loại trong dấu `<>` như sau:

```rust
// value will be of type storage::Box<bool>
    let bool_box = storage::create_box<bool>(true);
// value will be of the type storage::Box<u64>
    let u64_box = storage::create_box<u64>(1000000);
```

#### Calling Functions with Generics using Sui CLI

Để tương tác với 1 hàm có tham số `generics` trong chữ ký từ Sui CLI, bạn sẽ phải định nghĩa kiểu truyền vào của đối số với cú pháp `--type-args`.

Ví dụ dưới đây là gọi hàm `create_box` để tạo ra 1 `box` chứa 1 object coin có kiểu `0x2::sui::SUI`:

```bash
sui client call --package 0xbff5d0f3202e3b19e622b13819f269ae9aad904436cc557bace358266938e2ec --module generics --function create_box --args $OBJECT_ID --type-args 0x2::sui::SUI --gas-budget 10000000
```

*Note: tạo 1 object simple_box sau đó chuyển nó vào trong 1 box*
## Advanced Generics Syntax
 
Hãy tham khảo thêm [section on generics in the Move Book](https://move-book.com/advanced-topics/understanding-generics.html) để biết thêm nhiều ứng dụng cũng như các loại generic nâng cao trong Sui Move.

Ở trong phần tìm hiểu về fungible token này chúng ta sẽ dừng tìm hiểu về generics ở đây.