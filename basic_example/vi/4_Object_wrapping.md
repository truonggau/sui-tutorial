*Ở phần này chúng ta sẽ tìm hiểu về cách chuyển 1 object vào trong 1 object khác*
# Object Wrapping

Có nhiều cách để chuyển 1 object vào trong 1 object khác trong Sui move. Cách đầu tiên chúng ta sẽ giới thiệu sau đây được gọi là object wrapping.

Hãy tiếp tục với ví dụ về bảng điểm học sinh ở các phần trước đó. Chúng ta sẽ định nghĩa 1 kiểu dữ liệu mới `WrappableTranscript`, và kiểu dữ liệu bao bọc lấy dữ liệu về điểm là `Folder`.

```rust
struct WrappableTranscript has store {
    history: u8,
    math: u8,
    literature: u8,
}

struct Folder has key {
    id: UID,
    transcript: WrappableTranscript,
}
```

Trong ví dụ trên, `Folder` chứa `WrappableTranscript`, và `Folder` có thể được truy cập bởi id bởi vì nó có thuộc tính `key`. 

## Object Wrapping Properties

Để 1 loại struct có thể được nhúng vào 1 ovject khác thì nó thường có thuộc tính `key`, lại struct được nhúng sẽ phải có khả năng `store`.

Khi 1 object được nhúng, object đã đc nhúng sẽ không còn có thể được truy cập thông qua objectID. Thay vào đó nó trở thành 1 phần của object chứa nó. Điều quan trọng hơn là object đã được nhúng sẽ không còn có thể được truyền vào 1 hàm move như 1 tham số mà nó chỉ có thể được truy cập thông qua object chứa nó

Bởi vì thuộc tính này nên object wrapping có thể được sử dụng để làm 1 object không thể được truy cập từ bên ngoài ngoại trừ các contract cụ thể. Để hiểu hơn về Object wrapping tham khảo thêm ở [đây](https://docs.sui.io/devnet/build/programming-with-objects/ch4-object-wrapping).


# Object Wrapping Example

Chúng ta sẽ cùng ứng dụng cụ thể vào 1 ví dụ về bảng điểm mà chúng ta đang làm. Object `WrappableTranscript` được nhúng vào trong object `Folder` và object `Folder` chỉ có thể được giản nén. Do đó bản ghi bên trong chỉ có thể được truy cập bởi 1 address cụ thể.

## Modify `WrappableTranscript` and `Folder`

Đầu tiên chúng ta cần điều chỉnh với 2 struct chúng ta đã tạo ra từ trước `WrappableTranscript` và `Folder`

1. Chúng ta cần thêm thuộc tính `Key` vào struct `WrappableTranscript` để giúp biến nó trở thành tài sản và có thể được trao đổi

Chú ý rằng kiểu struct có thuộc tính `Key` và `store` sẽ được hiểu như kiểu tài sản - assets trong Sui Move

```rust
struct WrappableTranscript has key, store {
        id: UID,
        history: u8,
        math: u8,
        literature: u8,
}
```

1. Chúng ta cần thêm trường `intended_address` vào struc `Folder` để cho biết địa chỉ của người xem dự tính của bảng điểm đã nhúng

``` rust
struct Folder has key {
    id: UID,
    transcript: WrappableTranscript,
    intended_address: address
}
```

## Request Transcript Method

```rust
public fun request_transcript(transcript: WrappableTranscript, intended_address: address, ctx: &mut TxContext){
    let folderObject = Folder {
        id: object::new(ctx),
        transcript,
        intended_address
    };
    //We transfer the wrapped transcript object directly to the intended address
    transfer::transfer(folderObject, intended_address)
}
```

Hàm trên sẽ lấy 1 object `WrappableTranscript` và nhúng nó vào object `Folder`, và chuyển bảng điểm đã được nhúng cho address dự định sẽ sở hữu của bảng điểm
## Unwrap Transcript Method

```rust
public fun unpack_wrapped_transcript(folder: Folder, ctx: &mut TxContext){
    // Check that the person unpacking the transcript is the intended viewer
    assert!(folder.intended_address == tx_context::sender(ctx), 0);
    let Folder {
        id,
        transcript,
        intended_address:_,
    } = folder;
    transfer::transfer(transcript, tx_context::sender(ctx));
    // Deletes the wrapper Folder object
    object::delete(id)
    }
```

Hàm trên sẽ giải nén object `Folder` và lấy ra object `WrappableTranscript` nếu hàm được gọi bởi address dự định sẽ sở hữu của bảng điểm và gửi nó cho address đã gọi hàm 

*Quiz: Why do we need to delete the wrapper object here manually? What happens if we don't delete it?*

### Assert

Chúng ta sử dụng hàm `assert!` để kiểm tra address gửi transaction tới để giải nén bảng điểm có đúng là `intended_address` được lưu trong `Folder` chứa bảng điểm không

Hàm `assert!` cần 2 tham số theo mẫu sau:
```
assert!(<bool expression>, <code>)
```

Khi giá trị trả về là true nó sẽ đánh giá là đúng, trong trường hợp ngược lại nó huỷ bỏ lệnh với mã lỗi `<code>`.

### Custom Errors

Chúng ta đang sử dụng giá trị 0 mặc định cho lỗi code trên nhưng chúng ta cũng có thể khai báo 1 hằng số mã lỗi tuỳ chỉnh như sau:

```rust
    const ENotIntendedAddress: u64 = 1;
```

Mã lỗi này có thể được sử dụng ở trên cấp ứng dụng và được xử lý 1 cách thích hợp

**Đây là phần code ví dụ chi tiết: [WIP transcript.move](../example_projects/transcript/sources/transcript_2.move_wip)**
