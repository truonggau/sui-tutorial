*Trong bài trước [Object](./1_Object.md) chúng ta đã hiểu về `Sui object`. Tiếp theo chúng ta sẽ tìm hiểu về `Ownership` trong Sui*
# Types of Ownership of Sui Objects

Mỗi object trong Sui có 1 trường `owner` cho biết đối tượng này được sở hữu như thế nào. Trong Sui Move có tổng cộng 1 kiểu sở hữu:

- Owned
    - Owned by an address
    - Owned by another object 
- Shared
    - Shared immutable
    - Shared mutable

## Owned Objects

Trong 2 kiểu sở hữu đầu tiên dưới dạng `Owned Objects`. Owned Objects trong Sui được xử lý khác với các `shared object` và không yêu cầu thứ tự chung. 

### Owned by an Address

Cùng tiếp tục với ví dụ về `transcript`. Kiểu sở hữu này đc hiểu khá đơn giản như là object được sở hữu bởi 1 address mà object được chuyển đến khi tạo đối tượng, như ví dụ dưới đây:

```rust
    transfer::transfer(transcriptObject, tx_context::sender(ctx)) // where tx_context::sender(ctx) is the recipient
```

Trong đoạn code trên `transcriptObject` được chuyển đến địa chỉ người gửi transaction.

### Owned by An Object

Để 1 object được sở hữu bởi 1 object khác, chúng ta sử dụng `dynamic_object_field` - chúng ta sẽ cùng tìm hiểu chi tiết ở phần sau. Đơn giản thì khi 1 object được sở hữu 1 object khác - chúng ta sẽ gọi nó là object con. 1 Object con có thể được tra cứu onchain bằng objectID của nó.

## Shared Objects

## Shared Immutable Objects

Một số object trong Sui không thể bị thay đổi bởi bất kỳ ai, và vì thế nên những object này sẽ không có 1 owner. Tất cả các packages và modules đã được publish trong Sui đều là immutable objects

Để biến 1 object trở thành immutable object, chúng ta sử dụng hàm sau:
```rust
    transfer::freeze_object(obj);
```

## Shared Mutable Objects

Shared objects in Sui can be read or mutated by anyone. Shared object transactions require global ordering through a consensus layer protocol, unliked owned objects.

Shared objects trong Sui có thể được đọc hoặc thay đổi bởi bất kỳ ai. Các transaction liên quan đến Shared object sẽ yêu cầu hàng chờ thứ tự chung thông qua lớp đồng thuận, không như object owned

Để tạo ra 1 shared object chúng ta có thể sử dụng hàm:

```rust
    transfer::share_object(obj);
```

Mỗi lần 1 object được chia sẻ, nó sẽ có thể thay đổi và có thể được truy cập bởi bất kỳ ai gửi transactions để thay đổi object đó