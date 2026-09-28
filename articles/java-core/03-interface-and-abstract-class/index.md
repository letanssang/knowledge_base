---
title: "Phân biệt Interface và Abstract Class: Bản chất, Khác biệt và Cách thiết kế"
description: "Interface là contract, abstract class chia sẻ code và state, cùng default method để thêm hành vi mà vẫn giữ binary compatibility."

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

> **Tóm tắt:** Abstract class không tạo được instance và có thể giữ field không static, không final. Interface là reference type dùng như contract. Field của interface tự động public, static và final. Default method thêm hành vi mới vào interface mà code cũ vẫn tương thích ở mức binary.

*Thời gian đọc: ~9 phút*

---

## 1. Interface là contract giữa hai nhóm không cần đọc code của nhau

Tutorial mở bài Interfaces bằng tình huống các nhóm lập trình viên cần thống nhất một contract về cách phần mềm tương tác. Mỗi nhóm viết code mà không cần biết code nhóm kia viết thế nào.

Ví dụ trên trang là xe robotic. Hãng xe công bố interface chuẩn, nêu method nào được gọi để làm xe chuyển động, với mọi xe của mọi hãng. Hãng thiết bị dẫn đường viết phần mềm gọi các method đó. Không nhóm nào cần biết nhóm kia hiện thực ra sao. Mỗi bên giữ quyền sửa phần mềm của mình, miễn là vẫn bám interface đã công bố.

Trong ngôn ngữ Java, interface là một reference type, giống class, và chỉ chứa constant, method signature, default method, static method, và nested type. Thân method chỉ có ở default method và static method. Interface không tạo được instance. Class *implement* nó, hoặc interface khác *extend* nó. Một class chỉ extend được một class. Một interface extend được bất kỳ số lượng interface nào. Danh sách interface cha viết cách nhau bởi dấu phẩy ngay trong khai báo.

Class khởi tạo được mà implement một interface thì cung cấp thân method cho mỗi method được khai báo trong interface. Hãng Chevrolet và Toyota cùng implement `OperateCar`, phần hiện thực khác nhau, còn bên dẫn đường chỉ gọi `turn`, `changeLanes` và các method khác trong interface. Tutorial gọi cách dùng này là một Application Programming Interface. Bên bán API công bố signature và return type. Phần hiện thực giữ kín và được sửa sau, miễn là vẫn implement đúng interface mà khách đang dựa vào.

---

## 2. Abstract class chia sẻ code và state

Abstract class là class khai báo `abstract`. Nó có thể có abstract method, hoặc không. Không tạo được instance. Subclass thì được.

Abstract method khai báo không có phần hiện thực: không có cặp ngoặc nhọn, kết thúc bằng dấu chấm phẩy, như `abstract void moveTo(double deltaX, double deltaY)`. Class nào chứa abstract method thì bản thân class đó phải khai báo `abstract`.

Subclass của abstract class thường hiện thực mọi abstract method của parent. Nếu không hiện thực đủ, subclass cũng phải khai báo `abstract`.

Method trong interface không khai báo `default` hoặc `static` thì *ngầm* abstract. Modifier `abstract` không dùng với các method đó. Dùng được, nhưng không cần.

`GraphicObject` trên trang giữ vị trí hiện tại và method `moveTo` dùng chung, rồi khai báo `draw` và `resize` là abstract vì mỗi hình vẽ làm khác nhau. `Circle` và `Rectangle` không abstract nên phải viết cả hai method.

Abstract class có thể có static field và static method. Mình gọi chúng qua tên class, ví dụ `AbstractClass.staticMethod()`, như với class khác.

Một class implement interface mà không hiện thực hết method thì vẫn hợp lệ nếu class đó là `abstract`. Trang đưa `abstract class X implements Y` hiện thực tất cả trừ một method, rồi `class XX extends X` viết nốt method còn lại. `X` phải abstract vì chưa hiện thực đủ `Y`. `XX` thì có hiện thực `Y`.

---

## 3. Chỗ hai thứ giống nhau và chỗ tutorial bắt mình chọn

Abstract class giống interface ở hai điểm trên trang so sánh: không tạo được instance, và có thể trộn method có phần hiện thực với method không có.

Phần khác nằm ở state và ở số lượng kiểu mình được kế thừa:

| | Abstract class | Interface |
| --- | --- | --- |
| Field | Khai báo được field không static và không final | Mọi field tự động `public`, `static` và `final` |
| Method cụ thể | `public`, `protected` và `private` | Method mình khai báo hoặc định nghĩa dưới dạng default method đều là `public` |
| Kế thừa | Extend đúng một class, dù class đó có abstract hay không | Implement bất kỳ số lượng interface nào |

Tutorial không đưa một luật cứng. Nó nói *consider using* abstract class khi một trong các câu sau đúng:

- Muốn chia sẻ code giữa vài class gắn chặt với nhau.
- Class extend abstract class sẽ có nhiều method hoặc field chung, hoặc cần access modifier khác `public`, như `protected` và `private`.
- Muốn khai báo field không static hoặc không final, để method đọc và sửa state của object mà method thuộc về.

Và *consider using* interface khi:

- Các class không liên quan sẽ cùng implement. `Comparable` và `Cloneable` được nhiều class không liên quan implement.
- Muốn nêu behavior của một kiểu dữ liệu, không quan tâm ai hiện thực behavior đó.
- Muốn multiple inheritance of type.

`AbstractMap` là abstract class trong JDK, thuộc Collections Framework. Subclass gồm `HashMap`, `TreeMap` và `ConcurrentHashMap` dùng chung nhiều method mà `AbstractMap` định nghĩa, trong đó có `get`, `put`, `isEmpty`, `containsKey` và `containsValue`.

`HashMap` implement `Serializable`, `Cloneable` và `Map<K, V>`. Đọc danh sách interface đó, tutorial nói mình suy ra được một instance của `HashMap`, dù ai viết class, có thể được clone, là serializable, nghĩa là chuyển được thành một byte stream, và có chức năng của một map. `Map<K, V>` còn được bổ sung nhiều default method như `merge` và `forEach`. Class cũ đã implement interface này không phải định nghĩa các method đó.

Cùng một class dùng cả hai. `HashMap` implement nhiều interface và đồng thời extend abstract class `AbstractMap`. Tutorial nói nhiều thư viện làm vậy.

---

## 4. Default method và static method

Thêm method mới vào interface cũ buộc người đã implement phải viết lại, nếu method đó không có thân. Thêm dưới dạng static method thì người dùng coi đó là utility method, không phải method lõi. Default method cho phép thêm chức năng vào interface của thư viện và bảo đảm binary compatibility với code viết cho bản interface cũ.

`TimeClient` ban đầu có `setTime`, `setDate`, `setDateAndTime` và `getLocalDateTime`. Thêm `getZonedDateTime` như abstract method thì `SimpleTimeClient` phải viết method đó. Định nghĩa một default implementation thì không phải sửa `SimpleTimeClient`. Class này, và mọi class implement `TimeClient`, đã có `getZonedDateTime`.

Thân interface chứa abstract method, default method và static method. Abstract method kết thúc bằng dấu chấm phẩy và không có ngoặc nhọn. Default method dùng modifier `default`. Static method dùng keyword `static`. Mọi abstract method, default method và static method trong interface đều ngầm `public`, nên bỏ được modifier đó. Constant trong interface cũng ngầm `public`, `static` và `final`.

Static method `getZoneId` trên cùng interface gọi `ZoneId.of(zoneString)`. Nếu ném `DateTimeException`, nó in ra stderr và trả `ZoneId.systemDefault()`. Default method `getZonedDateTime` dựng `ZonedDateTime` từ `getLocalDateTime()` và `getZoneId(zoneString)`.

Interface extend một interface đang có default method thì làm được một trong ba việc:

- Không nhắc tới default method. Interface mới inherit nó. Class implement `AnotherTimeClient extends TimeClient` dùng đúng `TimeClient.getZonedDateTime`.
- Khai báo lại method, và việc đó làm method thành `abstract`. Class implement `AbstractZoneTimeClient` phải tự viết `getZonedDateTime`. Method này abstract như mọi method không default và không static khác trong interface.
- Định nghĩa lại default method, và việc đó override bản cũ. Class implement `HandleInvalidTimeZoneClient` dùng bản `getZonedDateTime` của interface này, không dùng bản của `TimeClient`.

Static method trong interface gắn với interface nơi nó được định nghĩa, không gắn với một object. Mọi instance chia sẻ static method đó. Tutorial nói cách này giúp để helper method của một interface ngay trong interface, thay vì một class riêng. Static method cũng ngầm `public`.

Default method còn để thêm method nhận lambda expression vào interface đã có. Trang chỉ `Comparator` đã được bổ sung static method `comparing`, `comparingDouble`, `comparingLong`, và default method `thenComparing`, `thenComparingDouble`, `thenComparingLong`, cùng `reversed`. `Comparator` là functional interface, nên `sort` nhận được lambda. `Comparator.comparing(Card::getRank).thenComparing(Comparator.comparing(Card::getSuit))` dựng tiêu chí sắp xếp mà không cần một class `Comparator` mới cho mỗi cách xếp. `.reversed()` đảo chiều `Comparator` đang có.

---

## Kết luận

Mình chọn abstract class khi vài class gần nhau cần chung field của từng object và chung method đã viết, kể cả method `protected` hoặc `private`. Mình chọn interface khi muốn một contract mà các class không cùng họ vẫn implement được, và khi cần nhiều kiểu cùng lúc. `HashMap` trên trang làm cả hai: extend `AbstractMap`, implement `Map` cùng các interface khác.

Default method là cách thêm method vào interface mà class implement cũ không phải viết lại, và tutorial gắn điều đó với binary compatibility. Static method trên interface là helper gắn với interface, không phải behavior của từng instance. Field của interface vẫn là constant: `public`, `static` và `final`. State riêng của từng object, nếu cần, nằm ở abstract class.

## References

- [Interfaces](https://docs.oracle.com/javase/tutorial/java/IandI/createinterface.html)
- [Abstract Methods and Classes](https://docs.oracle.com/javase/tutorial/java/IandI/abstract.html)
- [Default Methods](https://docs.oracle.com/javase/tutorial/java/IandI/defaultmethods.html)
- [Defining an Interface](https://docs.oracle.com/javase/tutorial/java/IandI/interfaceDef.html)

## Series

- Previous: [Lập trình hướng đối tượng (OOP) trong Java: 4 Trụ cột và Ứng dụng thực tế](../02-object-oriented-programming/index.md)
- Next: [Java Collections Framework: Phân tích kiến trúc List, Set, Map và Queue](../04-collections-framework/index.md)
