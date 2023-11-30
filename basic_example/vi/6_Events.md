*Trong các phần trước chúng ta đã tìm hiểu và cùng viết 1 smart contract để quản lý bảng điểm cho giáo viên. Tiếp theo chúng ta sẽ tìm hiểu về Event để code client có thể theo dõi hoạt động onchain*
# Events

Events là 1 phần quan trọng trong Sui Move smart contract, nó là cách chính để indexers theo dõi các hành động onchain. Bạn có thể hiểu nó như 1 hệ thống logging của server backends truyền thống, và indexers thì như là parsers.

Events trong Sui cũng được đại diện như 1 object. Có 1 số loại sự kiện ở level hệ thống trong Sui, bao gồm Move event, Publish event, Transfer event,... Để hiểu kỹ hơn về Event cũng như tất cả các kiểu event trong Sui. Tham khảo thêm ở tài liệu sau [Sui Events API page here](https://docs.sui.io/build/event_api).

Chi tiết event của 1 transaction có thể được tìm thấy ở [Sui Explorer](https://suiexplorer.com/) trong tab `Events`:
![Screenshot 2023-11-16 at 16 30 48](https://github.com/truonggau/sui-tutorial/assets/87189382/b3292df5-1180-4807-b38f-440d916407f3)
## Custom Events

Deverloper cũng có thể tự định nghĩa 1 event cho riêng mình trên Sui. Chúng ta có thể định nghĩa 1 event đánh dấu khi bảng điểm được yêu cầu như sau.


```rust
    /// Event marking when a transcript has been requested
    struct TranscriptRequestEvent has copy, drop {
        // The Object ID of the transcript wrapper
        wrapper_id: ID,
        // The requester of the transcript
        requester: address,
        // The intended address of the transcript
        intended_address: address,
    }
```

1 kiểu đại diện cho event sẽ có 2 thuộc tính `copy` và `drop`. Event object không thể đại diện cho tài sản, và chúng ta chỉ quan tâm đến dữ liệu chứa trong nó. Nên nó có thể được sao chép vào loại bỏ ở cuối hàm.

Để gửi 1 event trong Sui, bạn chỉ cần sử dụng hàm [`sui::event::emit`](https://github.com/MystenLabs/sui/blob/main/crates/sui-framework/docs/event.md#function-emit).
Hãy cùng sử đổi hàm `request_transcript` của chúng ta trước đó:

```rust
    public fun request_transcript(transcript: WrappableTranscript, intended_address: address, ctx: &mut TxContext){
        let folderObject = Folder {
            id: object::new(ctx),
            transcript,
            intended_address
        };
        event::emit(TranscriptRequestEvent {
            wrapper_id: object::uid_to_inner(&folderObject.id),
            requester: tx_context::sender(ctx),
            intended_address,
        });
        //We transfer the wrapped transcript object directly to the intended address
        transfer::transfer(folderObject, intended_address);
    }
```

Trên Sui explorer, chúng ta có thể xem các event đã được gửi đi hiển thị như sau:
![Screenshot 2023-11-16 at 16 29 52](https://github.com/truonggau/sui-tutorial/assets/87189382/b7378a85-456e-43b3-a3cb-974b6d20cde4)

Hãy thử tự tạo 1 project với tất cả seri ở trên: khai báo object, yêu cầu, đóng gói, giải nén, quản lý quyền, bắn event và thử tương tác với smart contract thông qua Sui CLI và xem kết quả trên Sui explorer.

Đây là bài kết thúc trong seri basic example
great job!
