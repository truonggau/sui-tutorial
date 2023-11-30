*Trong phần trước chúng ta đã tìm hiểu về Object_wrapping tiếp theo chúng ta sẽ tìm hiểu về Capability_design_pattern*

# Capability Design Pattern

Hiện tại chúng ta có 1 hệ thống tạo ra bảng điểm, chúng ta muốn thêm 1 số quyền kiểm soát vào cho smart contract của chúng ta

Capability là 1 kiểu kiến trúc thường dùng trong Move cho phép tinh chỉnh quyền điều khiển sử dụng object là trung tâm. Hãy cùng xem làm thế nào để chúng ta định nghĩa 1 capability object:

```rust
  // Type that marks the capability to create, update, and delete transcripts
  struct TeacherCap has key {
    id: UID
  }
```

Chúng ta định nghĩa struct `TeacherCap` đánh dấu khả năng thực hiện các hành động đặc quyền trên bảng điểm. Nếu chúng ta muốn capability object không thể chuyển nhượng được chúng ta chỉ cần không thêm thuộc tính `storage` cho struct.

*💡Note: Đây cũng là cách để triển khai giống với soulbound tokens (SBT) có thể triểm khai với Move. Bạn định nghĩa 1 struct có thuộc tính `key`, nhưng không có thuộc tính `store`.

## Passing and Consuming Capability Objects

Tiếp theo chúng ta sẽ chỉnh sửa hàm có thể được gọi bởi bất kỳ ai có có `TeacherCap` - capability object để lấy capabilyti object này làm tham số và sử dụng nó.

Ví dụ, với hàm `create_wrappable_transcript_object`. chúng ta sửa nó như sau:

```rust
    public fun create_wrappable_transcript_object(_: &TeacherCap, history: u8, math: u8, literature: u8, ctx: &mut TxContext) {
        let wrappableTranscript = WrappableTranscript {
            id: object::new(ctx),
            history,
            math,
            literature,
        };
        transfer::transfer(wrappableTranscript, tx_context::sender(ctx))
    }
```

Chúng ta truyền 1 tham chiếu capability objecy `TeacherCap` và sử dụng nó với ký hiệu `_` - ký hiệu sử dụng cho các biến hoặc tham số không được sử dụng. Chú ý rằng bởi vì chúng ta chỉ truyền vào tham chiếu tới object, nên việc sử dụng tham chiếu đố không ảnh hưởng tới object ban đầu.

*Quiz: Điều gì sẽ xảy ra khi cố gắng truyền `TeacherCap` với 1 giá trị*

Nó có nghĩa sẽ chỉ có 1 địa chỉ mà có 1 `TeacherCap` object có thể gọi phương thức này, thực hiện kiểm soát truy cập trên phương thức này.

Chúng ta thực hiện sửa đổi các hàm tương tự với các phước thức khác trong smart contract thực hiện các hành động đặc quyền trên bản điểm.


## Initializer Function

Hàm khởi tạo của module được gọi 1 lần vào lúc xuất bản module đó. Điều này có ích cho việc khởi tạo trạng thái của smart contract, và thường được dùng để cài đặt các capability object.

Trong ví dụ mà chúng ta đang xét chúng ta định nghĩa hàm `init` như sau:
```rust
    /// Module initializer is called only once on module publish.
    fun init(ctx: &mut TxContext) {
        transfer::transfer(TeacherCap {
            id: object::new(ctx)
        }, tx_context::sender(ctx))
    }
```

Hàm khởi tạo sẽ tạo ra 1 `TeacherCap` object và gửi nó đến cho người phát hình module khi module được phát hành.

Chúng ta có thể xem transaction phát hành trên [Sui Explorer](https://suiscan.xyz/devnet/home):
![Screenshot 2023-11-16 at 11 39 50](https://github.com/truonggau/sui-tutorial/assets/87189382/8dad4d2b-2d72-40bf-ae9b-d1c36eee1ab1)

Object thứ 2 được khởi tạo là 1 thể hiện của `TeacherCap` object và nó được gửi cho người phát hành:
![Screenshot 2023-11-16 at 11 36 24](https://github.com/truonggau/sui-tutorial/assets/87189382/42daee3d-256e-4d24-95cc-85184d236dc7)

*Quiz: Object đầu tiên được khởi tạo là gì?*

## Add Additional Teachers or Admins

Để thêm 1 địa chỉ có quyền admin, chúng ta sẽ định nghĩa 1 hàm để tạo và gửi 1 object `TeacherCap` như sau:

```rust
    public fun add_additional_teacher(_: &TeacherCap, new_teacher_address: address, ctx: &mut TxContext){
        transfer::transfer(
            TeacherCap {
                id: object::new(ctx)
            },
        new_teacher_address
        )
    }
```

This method re-uses the `TeacherCap` to control access, but if needed, you can also define a new capability struct indicating sudo access. 
Hàm trên sử dụng lại `TeacherCap` để quản lý quyền truy cập, nhưng nếu cần chúng ta cũng có thể định nghĩa 1 capability object mới để chỉ định quyền sudo

