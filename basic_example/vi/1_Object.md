# Sui Objects

*Sui là ngôn ngữ lập trình tập trung vào **object***

## Introduction

Sui move là 1 ngôn ngữ lập trình tập trung hoàn toàn vào **object**. Transactions trên Sui được hiểu như là các hoạt động có đầu vào và kết quả đều là các **object**. Sui object là các đơn vị lưu trữ cơ bản trong Sui. Tất cả đều có bắt đầu bằng keyword `struct`

Cùng bắt đầu với ví dụ về 1 bản ghi bảng điểm lưu trữ điểm của 1 học sinh:

```rust
struct Transcript {
    history: u8,
    math: u8,
    literature: u8,
}
```

Đoạn code khai báo bên trên là cách khai báo thông thường với `Move struct`, nhưng nó sẽ không trở thành 1 Sui object. Để tạo ra 1 object Sui ở trong bộ nhớ chung, chúng ta cần thêm thuộc tính `key` và thêm vào trường `id: UID` có giá trị duy nhất trên toàn bộ hệ thống vào trong kiểu dữ liệu đã định nghĩa ở trên
```rust
use sui::object::{UID};

struct TranscriptObject has key {
    id: UID,
    history: u8,
    math: u8,
    literature: u8,
}
```

## Khởi tạo a Sui Object

Để khởi tạo 1 Sui object sẽ cần có 1 ID duy nhất. Chúng ta sẽ sử dụng hàm `sui::object::new` để khởi tạo 1 ID mới và truyền vào trong `TxContext`.

Trong Sui tất cả các object đều phải có 1 chủ sở hữu, Chủ sở hữu có thể là 1 address, 1 object khác hoặc là object có kiểu "Shared". Trong ví dụ sau, chúng ta sẽ tạo ra object `transcriptObject` được sở hữu bởi người gửi transaction. Chúng ta sử dụng hàm `transfer` của Sui framework và sử dụng hàm `tx_context::sender` để lấy địa chỉ của sender hiển tại

Chúng ta sẽ bàn kỹ hơn về sở hữu của object trong bài sau của seri:

```rust
use sui::object::{Self};
use sui::tx_context::{Self, TxContext};
use sui::transfer;

public fun create_transcript_object(history: u8, math: u8, literature: u8, ctx: &mut TxContext) {
  let transcriptObject = TranscriptObject {
    id: object::new(ctx),
    history,
    math,
    literature,
  };
  transfer::transfer(transcriptObject, tx_context::sender(ctx))
}
```


*💡Note: Move hỗ trợ cho phép bỏ qua các trường nếu tên trường trùng tên với tên của biến giá trị mà nó được liên kết.*