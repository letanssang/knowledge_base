---
title: "Phân biệt Interface và Abstract Class: Bản chất, Khác biệt và Cách thiết kế"
description: "Interface mô tả điều một class có thể làm; abstract class phù hợp khi các class liên quan cần chia sẻ state hoặc implementation. Bài viết dùng một ví dụ để chọn đúng giữa hai cách."

date:
updated:

series: "Java Core"
series_order: 3

tags:
  - java
  - oop
  - interface
  - abstract-class

status: draft
language: vi
---

# Phân biệt Interface và Abstract Class: Bản chất, Khác biệt và Cách thiết kế

Một ứng dụng gửi thông báo có thể gửi email, tin nhắn hoặc thông báo trong app. Phần code quyết định “gửi” thường không cần biết từng loại thông báo kết nối ra sao; nó chỉ cần gọi một thao tác chung. Nhưng nếu các loại gửi đều cần dùng chung cấu hình hoặc một phần cách xử lý, chỉ một interface có thể chưa đủ.

Đây là lúc câu hỏi “dùng interface hay abstract class?” trở nên thực tế. Cách chọn dễ nhớ nhất không phải dựa vào tên gọi, mà là xem mình muốn thống nhất khả năng hay muốn chia sẻ cả state và implementation.

## Interface mô tả hợp đồng mà class có thể cung cấp

Ta có thể khai báo một interface `Notifier` với method `send`. `EmailNotifier` và `AppNotifier` cùng implement interface đó, mỗi class tự quyết định cách gửi. Nơi gọi chỉ cần nhận một `Notifier` rồi gọi `send`; nó không cần rẽ nhánh theo từng implementation.

Điểm mạnh của interface là nó mô tả một khả năng, không đòi hỏi những class thực hiện khả năng ấy phải cùng một nhánh kế thừa. Một class có thể implement nhiều interface, nên nó có thể thể hiện nhiều vai trò độc lập. Chẳng hạn, một object vừa có thể gửi thông báo, vừa có thể ghi log, miễn là nó cung cấp các method tương ứng.

```java
interface Notifier {
    String send(String message);
}

class EmailNotifier implements Notifier {
    public String send(String message) {
        return "Email: " + message;
    }
}

class App {
    String createMessage() {
        Notifier notifier = new EmailNotifier();
        return notifier.send("Your order is ready");
    }
}
```

Caller dùng biến `notifier` qua kiểu interface và không cần biết class cụ thể để gọi `send`. Interface cũng có thể có `default method`: một method đã có phần implementation chung. Điều này hữu ích khi muốn bổ sung hành vi dùng chung cho các class đang implement interface. Class có thể dùng phần mặc định hoặc override lại nếu cần cách làm riêng.

## Abstract class chia sẻ phần nền giữa các class liên quan

Giờ giả sử các loại thông báo đều thuộc cùng một hệ thống và cùng cần lưu tên người gửi, kiểm tra message rỗng, rồi ghi lại trạng thái đã gửi. Nếu mỗi class phải viết lại phần đó, một abstract class có thể giữ state và implementation chung; các class con chỉ bổ sung phần đặc thù.

Abstract class không thể được tạo object trực tiếp. Nó có thể chứa fields, method đã triển khai và method abstract mà class con cần hoàn thiện. Khác với interface, một class chỉ có thể kế thừa một class cha trực tiếp, nên lựa chọn abstract class gắn các class con vào cùng một nhánh kế thừa.

## Một câu hỏi giúp chọn nhanh

Hãy tự hỏi: “Mình đang mô tả một khả năng mà nhiều loại object có thể cung cấp, hay một họ class cần chia sẻ state và code?” Nếu là khả năng, bắt đầu bằng interface. Nếu các class có quan hệ rõ ràng và thật sự cần dùng chung phần dữ liệu hoặc implementation, cân nhắc abstract class.

Hai cách này cũng có thể đi cùng nhau: abstract class có thể implement một interface. Khi ấy interface là hợp đồng cho bên gọi, còn abstract class là một cách triển khai chung cho một số class. Tránh tạo abstract class chỉ để gom vài method tiện ích; một quan hệ kế thừa không phù hợp thường khiến class con khó thay thế hoặc mở rộng hơn.

## Kết luận

Chọn interface để diễn đạt điều caller có thể yêu cầu, nhất là khi nhiều class không liên quan cần cùng đáp ứng một contract. Chọn abstract class khi các class liên quan cần dùng chung state hay implementation. Nếu chưa cần chia sẻ code, interface thường giữ cho quan hệ giữa các class linh hoạt hơn.

## References

- [Defining an Interface](https://docs.oracle.com/javase/tutorial/java/IandI/interfaceDef.html)
- [Interfaces](https://docs.oracle.com/javase/tutorial/java/IandI/createinterface.html)
- [Abstract Methods and Classes](https://docs.oracle.com/javase/tutorial/java/IandI/abstract.html)
- [Default Methods](https://docs.oracle.com/javase/tutorial/java/IandI/defaultmethods.html)

## Series

- Previous: [Lập trình hướng đối tượng (OOP) trong Java: 4 Trụ cột và Ứng dụng thực tế](../02-object-oriented-programming/index.md)
- Next: [Java Collections Framework: Phân tích kiến trúc List, Set, Map và Queue](../04-collections-framework/index.md)
