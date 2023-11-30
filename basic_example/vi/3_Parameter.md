*Ở phần trước chúng ta đã tìm hiểu về object cũng như các kiểu sở hữu object, tiếp theo chúng ta sẽ tìm hiểu về tham số truyền vào trong 1 hàm cũng như các để xoá bỏ 1 object*
# Parameter Passing and Object Deletion

## Parameter Passing (by `value`, `ref` and `mut ref`)

Nếu bạn quen thuộc với rust, và bạn cũng quen thuộc với hệ thống sở hữu của Rust. Một điểm mạnh của của movelang so với Solidity là bạn có thể hiểu lệnh gọi hàm có thể tác động như thế nào đến các tài sản bạn đã sử dụng để tương tác với hàm đó. Hãy cùng xem xét ví dụ sau:

```rust
use sui::object::{Self};

// You are allowed to retrieve the score but cannot modify it
public fun view_score(transcriptObject: &TranscriptObject): u8{
    transcriptObject.literature
}

// You are allowed to view and edit the score but not allowed to delete it
public fun update_score(transcriptObject: &mut TranscriptObject, score: u8){
    transcriptObject.literature = score
}

// You are allowed to do anything with the score, including view, edit, or delete the entire transcript itself.
public fun delete_transcript(transcriptObject: TranscriptObject){
    let TranscriptObject {id, history: _, math: _, literature: _ } = transcriptObject;
    object::delete(id);
}
```

## Object Deletion and Struct Unpacking

Hàm `delete_transcript trong ví dụ trên minh hoạ cách để xoá 1 ọbject trong Sui.

1. Để xoá 1 object, đầu tiên bạn phải giải nén object và lấy lại objectID của nó. Giải nén chỉ có thể được hoàn thành bên trong module mà đã định nghĩa object đó do quy định Move's privileged struct operation:

- Các kiêu Struct chỉ có thể được khởi tạo ("packed") hay huỷ ("unpacked") bên trong các module đã định nghĩa struct đó
- Các trường của struct chỉ có thể được truy cập bên trong module đã định nghĩa struct đó

Hãy tuân theo những luật sau, nếu bạn muốn sửa đổi struct của bạn bên ngoài module nó đã định nghĩa, bạn sẽ cần cung cấp 1 hàm public cho các hoạt động mong muốn này

1. Sau khi giải nén struct và lấy lại ID của nó, object có thể bị xoá bỏ đơn giản bằng cách gọi hàm `object::delete`

*💡Note: dấu gạch dưới `_` thể hiện việc biến hoặc tham số đó không được sử dụng.*


