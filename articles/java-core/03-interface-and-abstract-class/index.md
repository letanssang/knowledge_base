---
title: "Phân biệt Interface và Abstract Class: Bản chất, Khác biệt và Cách thiết kế"
description: "Interface là hợp đồng không giữ state của từng object. Abstract class chia sẻ field và method đã viết. Default method thêm hành vi mà class cũ không phải sửa."

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

> **Tóm tắt:** Interface công bố method để các class không cùng họ cùng làm theo, và field của nó là hằng. Abstract class dùng khi vài class gần nhau cần chung field của từng object và chung đoạn code đã viết. Default method thêm method vào interface mà class đã implement không phải viết lại.

*Thời gian đọc: ~9 phút*

---

## 1. Hai nhóm không cần đọc code của nhau

Hãng xe và hãng dẫn đường không cần đọc source của nhau. Họ cần một hợp đồng: method nào làm xe rẽ, method nào đổi làn, tham số và giá trị trả về là gì. Hãng xe công bố interface. Hãng dẫn đường chỉ gọi các method đó. Chevrolet và Toyota cùng implement `OperateCar`, phần bên trong khác nhau. Bên dẫn đường không đổi.

Interface là một reference type. Nó chứa hằng, chữ ký method, default method, static method, và kiểu lồng nhau. Thân method chỉ có ở default method và static method. Không viết `new` một interface. Class implement nó, hoặc interface khác extend nó.

Một class chỉ extend được một class. Một interface extend được nhiều interface, danh sách cách nhau bởi dấu phẩy. Class tạo được instance mà implement interface thì phải có thân cho mỗi method được khai báo. Abstract method trong interface kết thúc bằng dấu chấm phẩy, không có ngoặc nhọn. Mọi abstract method, default method, static method, và mọi hằng trong interface đều ngầm `public`. Hằng còn ngầm `static` và `final`. Modifier đó viết hay không cũng vậy.

Bên bán một thư viện xử lý ảnh làm đúng việc này. Họ công bố chữ ký. Phần hiện thực giữ kín và được sửa sau, miễn là vẫn implement đúng interface khách đang gọi.

---

## 2. Abstract class giữ phần đã viết và state của từng object

`GraphicObject` có tọa độ và method `moveTo` đã viết sẵn, mọi hình dùng chung. `draw` và `resize` thì mỗi hình làm một kiểu, nên chúng không có thân:

```java
abstract void draw();
abstract void resize();
```

Class chứa method không có thân thì bản thân class phải là `abstract`. Không `new GraphicObject()` được. `Circle` và `Rectangle` không abstract nên phải viết cả `draw` và `resize`. Subclass không viết đủ method trừu tượng thì subclass cũng phải là `abstract`.

Abstract class vẫn có field và method `static`, gọi qua tên class như class thường: `AbstractClass.staticMethod()`.

Một class implement interface mà chưa viết hết method thì vẫn hợp lệ nếu class đó là `abstract`. `abstract class X implements Y` viết tất cả trừ một method. `class XX extends X` viết nốt method còn lại. `X` phải abstract vì chưa hiện thực đủ `Y`. `XX` thì có hiện thực `Y`.

Method trong interface không ghi `default` hoặc `static` thì ngầm abstract. Không cần viết thêm modifier `abstract`.

---

## 3. Chọn theo state và theo số lượng kiểu

Hai thứ giống nhau ở chỗ không tạo được instance, và đều có thể trộn method đã có thân với method chưa có thân.

| | Abstract class | Interface |
| --- | --- | --- |
| Field của từng object | Được. Field không cần `static` hay `final` | Không. Mọi field là `public static final` |
| Method đã có thân | `public`, `protected`, `private` | Method mình khai báo hoặc viết dưới dạng default đều là `public` |
| Số lượng | Extend đúng một class | Implement bao nhiêu interface cũng được |

Mình dùng abstract class khi vài class gắn với nhau cần chung code, khi chúng cần nhiều field hoặc method chung, khi cần `protected` hoặc `private`, hoặc khi method phải đọc và sửa state của chính object.

Mình dùng interface khi các class không cùng họ vẫn phải làm cùng một việc. `Comparable` và `Cloneable` là hai trường hợp đó. Interface cũng là chỗ mình nêu behavior của một kiểu mà không quan tâm class nào làm, và là chỗ một class nhận nhiều kiểu cùng lúc.

`AbstractMap` là abstract class. `HashMap`, `TreeMap` và `ConcurrentHashMap` dùng chung các method nó đã viết, trong đó có `get`, `put`, `isEmpty`, `containsKey` và `containsValue`. `HashMap` đồng thời implement `Serializable`, `Cloneable` và `Map<K, V>`. Nhìn danh sách đó mình biết một instance clone được, chuyển được thành byte stream, và dùng được như một map. Cùng một class vừa extend abstract class vừa implement nhiều interface. Nhiều thư viện làm vậy.

---

## 4. Thêm method vào interface mà class cũ không phải sửa

`TimeClient` đã có `setTime`, `setDate`, `setDateAndTime` và `getLocalDateTime`. `SimpleTimeClient` đã implement xong. Nay mình muốn thêm `getZonedDateTime`.

Thêm nó như abstract method thì mọi class đã implement phải viết method mới, nếu không không biên dịch. Thêm như static method thì người gọi coi đó là hàm tiện ích, không phải việc của từng object. Default method có thân sẵn. `SimpleTimeClient` không sửa vẫn có `getZonedDateTime`. Đó là cách thêm chức năng vào interface của thư viện mà code biên dịch với interface cũ vẫn tương thích ở mức binary.

Default method mở đầu bằng `default`. Static method `getZoneId` gọi `ZoneId.of(zoneString)`. Nếu ném `DateTimeException`, nó in ra stderr và trả `ZoneId.systemDefault()`. Default method dựng `ZonedDateTime` từ giờ local và zone đó. Static method gắn với interface, mọi instance dùng chung, và cũng ngầm `public`. Helper của interface để ngay trong interface, không cần một class riêng.

Interface con đối xử với default method của interface cha theo ba cách. Không nhắc tới thì được kế thừa nguyên. Khai báo lại, không có thân, thì method thành abstract và class implement phải tự viết. Định nghĩa lại thì bản mới override bản cũ.

Default method còn để nhét lambda vào thư viện đã có. `Comparator` là functional interface. `sort` nhận lambda. `comparing`, `comparingDouble` và `comparingLong` là static method. `thenComparing`, `thenComparingDouble`, `thenComparingLong` và `reversed` là default method. `Comparator.comparing(Card::getRank).thenComparing(Comparator.comparing(Card::getSuit))` xếp bài theo chất rồi theo rank mà không cần một class `Comparator` mới cho mỗi cách xếp. `.reversed()` đảo chiều comparator đang có.

---

## Kết luận

Cần một hợp đồng cho nhiều class không cùng cha, mình viết interface. Cần vài class gần nhau dùng chung field của từng object và đoạn code đã viết, mình viết abstract class. `HashMap` làm cả hai: extend `AbstractMap`, implement `Map` và các interface khác.

Thêm method vào interface đã có người implement thì mình cho nó thân mặc định, nếu không mọi class cũ vỡ lúc biên dịch. Field trong interface là hằng dùng chung, không phải state của từng object. State đó nằm ở class.

## References

- [Interfaces](https://docs.oracle.com/javase/tutorial/java/IandI/createinterface.html)
- [Defining an Interface](https://docs.oracle.com/javase/tutorial/java/IandI/interfaceDef.html)
- [Abstract Methods and Classes](https://docs.oracle.com/javase/tutorial/java/IandI/abstract.html)
- [Default Methods](https://docs.oracle.com/javase/tutorial/java/IandI/defaultmethods.html)

## Series

- Previous: [Lập trình hướng đối tượng (OOP) trong Java: 4 Trụ cột và Ứng dụng thực tế](../02-object-oriented-programming/index.md)
- Next: [Java Collections Framework: Phân tích kiến trúc List, Set, Map và Queue](../04-collections-framework/index.md)
