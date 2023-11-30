*Trong phần trước chúng ta đã tìm hiểu thêm về generics. Tiếp theo hãy cùng tìm hiểu về witness_design_pattern*
# The Witness Design Pattern

Đầu tiên chúng ta cần hiểu về witness pattern để cùng hiểu 1 cách chi tiết về cách để triển khai 1 fungible token trong Sui Move.

Witness là 1 design pattern thường được sử dụng để chứng minh cho resource hoặc type được đề cập đến, ví dụ `A`  chỉ có thể được khởi tạo mỗi khi `witness` được sử dụng hoặc loại bỏ. `witness` phải được sử dụng hoặc loại bỏ sau khi sử dụng, hãy chắc chắn nó không thể được tái sử dụng để tại ra nhiều thể hiện của `A`

## Witness Pattern Example

Trong ví dụ sau, `witness` là `PEACE` trong khi kiểu `A` mà chúng ta muốn kiểm soát việc khởi tạo `Guardian`.

Kiểu `witness` phải có thuộc tính `drop` nên tài nguyên này sẽ có thể bị huỷ sau khi được truyền vào trong hàm. Chúng ta sẽ kiểm tra thể hiện của `PEACE` được truyền vào trong hàm `create_guardian` và huỷ bỏ (chú ý thêm '_' đằng trước biến `witness`), hãy chắc chắn chỉ có thể tạo 1 thể hiẹn của `Guardian`.

```rust
    /// Module that defines a generic type `Guardian<T>` which can only be
    /// instantiated with a witness.
    module witness::peace {
        use sui::object::{Self, UID};
        use sui::transfer;
        use sui::tx_context::{Self, TxContext};

        /// Phantom parameter T can only be initialized in the `create_guardian`
        /// function. But the types passed here must have `drop`.
        struct Guardian<phantom T: drop> has key, store {
            id: UID
        }

        /// This type is the witness resource and is intended to be used only once.
        struct PEACE has drop {}

        /// The first argument of this function is an actual instance of the
        /// type T with `drop` ability. It is dropped as soon as received.
        public fun create_guardian<T: drop>(
            _witness: T, ctx: &mut TxContext
        ): Guardian<T> {
            Guardian { id: object::new(ctx) }
        }

        /// Module initializer is the best way to ensure that the
        /// code is called only once. With `Witness` pattern it is
        /// often the best practice.
        fun init(witness: PEACE, ctx: &mut TxContext) {
            transfer::transfer(
                create_guardian(witness, ctx),
                tx_context::sender(ctx)
            )
        }
    }
```

*Ví dụ trên đã được sử đổi thì tài liệu [Sui Move by Example](https://examples.sui.io/patterns/witness.html) viết bởi [Damir Shamanaev](https://github.com/damirka).*

### The `phantom` Keyword

Trong ví dụ trên chúng ta muốn kiểu `Guardian` có thuộc tính `key` và `store`, nên nó là 1 loại tài sản và có thể lưu trữ cũng như trao đổi onchain.

Chúng ta cũng muốn truyền `witness`, `PEACE`, vào trong `Guardian`, nhưng `PEACE` chỉ có thuộc tính `drop`. Hãy nhớ lại nội dung về [ability constraints](./2_intro_to_generics.md#ability-constraints). Quy tắc nói rằng `PEACE` nên có 2 thuốc tính `key` and `storage` giống như lại `Guardian`. Nhưng trong trường hợp này, chúng ta không muốn thêm những thuốc tính không cần thiết cho `witness` vì làm vậy có thể gây ra những lỗ hổng hành động không mong muốn.

Chúng ta có thể sử dụng keyword `phantom` để khắc phục tình trạng này. Khi 1 kiểu dữ liệu tham số truyền vào không cần sử dụng bên trong `struct` hoặc chỉ được sử dung như 1 đối số của 1 tham số `phantom`, chúng ta có thể sử dụng `phantom` để yêu cầu Move nới lỏng các quy tắc ràng buộc với type được chứa bên trong. Chúng ta có thể thấy `Guardian` không sử dụng type `T` trong bất kỳ trường nào của nó vì thế chúng ta có thể khai báo kiểu `T` như 1 `phantom`.

Hãy xem thêm [relevant section](https://github.com/move-language/move/blob/main/language/documentation/book/src/generics.md#phantom-type-parameters) để tìm hiểu kỹ hơn về keyword `phantom`.
## One Time Witness

One Time witness(OTW) là 1 sub-pattern của Witness pattern, nơi chúng ta sử dụng module `init`
để chắc chắn chỉ có 1 thể hiện của `witness` được tạo ra (do đó type `A` được đảm bảo chỉ tồn tại duy nhất)

Trong Sui Move 1 type được coi là giống với OTW nếu nó có các thuộc tính sau:
- Type sẽ được đặt tên theo module nhưng được viết hoa
- Type này sẽ chỉ có thuộc tính `drop`

Để lấy ra 1 thể hiện của type này, bạn cần thêm nó như là đối số đầu tiên của hàm `init` như ví dụ ở trên. Sui runtime sẽ tự động tạo ra cấu trúc OTW  tại thời điểm publish module.

Trong ví dụ trên sử dụng OTW để đảm bảo `Guardian` là 1 singtleton.