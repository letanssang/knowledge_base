---
title: "Generics trong Java: Type Safety, Wildcards và Cơ chế Type Erasure"
description: "Generic đưa kiểu vào lúc biên dịch để khỏi cast. Raw type là dạng cũ trước JDK 5.0. Wildcard chọn theo dữ liệu đi vào hay đi ra. Lúc chạy không có class riêng cho từng kiểu tham số."

date:
updated:

series: "Java Core"
series_order: 5

tags:
  - java
  - generics
  - type-safety
  - type-erasure

status: draft
language: vi
---

# Generics trong Java: Type Safety, Wildcards và Cơ chế Type Erasure

> **Tóm tắt:** `List` không generic bắt mình cast khi lấy phần tử, và cast sai chỉ nổ lúc chạy. Khai báo `List<String>` thì compiler chặn từ lúc biên dịch. Lúc chạy, `List<String>` và `List<Integer>` vẫn là cùng một class `List`. Wildcard `extends` nhận dữ liệu ra, `super` nhận dữ liệu vào.

*Thời gian đọc: ~9 phút*

---

## 1. Cast ở chỗ lấy phần tử là chỗ bug nấp

Bug lúc biên dịch hiện ngay. Bug lúc chạy có thể hiện ở dòng rất xa chỗ mình nhét nhầm kiểu. Generic kéo nhiều lỗi kiểu về lúc biên dịch.

Type parameter là kiểu đóng vai tham số của class, interface hoặc method. Tham số thường nhận giá trị. Type parameter nhận kiểu, nên cùng một đoạn code chạy cho nhiều kiểu.

```java
List list = new ArrayList();
list.add("hello");
String s = (String) list.get(0);
```

Đổi thành `List<String>` thì `get` trả `String`. Không còn cast. Compiler cũng không cho `add` một `Integer`. Cùng cơ chế đó, một thuật toán viết một lần chạy trên collection của nhiều kiểu mà vẫn được kiểm kiểu.

---

## 2. Raw type là tên generic bỏ mất kiểu tham số

`Box<Integer>` là kiểu đã gắn tham số. `Box` trơn, không có `<...>`, là raw type của `Box<T>`. Class không generic thì không gọi là raw type.

Trước JDK 5.0, các class collection chưa có kiểu tham số. Code cũ vẫn còn, nên gán `Box<String>` vào một biến `Box` thì được. Chiều ngược lại thì compiler cảnh báo unchecked conversion: nó không đủ thông tin để chứng minh an toàn. Gọi `set` trên raw type cũng vậy. Cảnh báo đó nghĩa là phần kiểm tra bị hoãn tới lúc chạy. Mình tránh raw type, trừ khi đang chạm API viết trước generic.

Warning unchecked mặc định không in chi tiết. Biên dịch với `-Xlint:unchecked` thì thấy dòng nào đang chuyển kiểu mà compiler không kiểm hết. `@SuppressWarnings("unchecked")` tắt cảnh báo ở đúng chỗ. `-Xlint:-unchecked` tắt hết.

Trộn raw type vào biến generic tạo heap pollution: biến khai báo `List<String>` nhưng object bên trong không phải `List<String>`.

```java
List l = new ArrayList<Number>();
List<String> ls = l;  // unchecked warning
```

Nếu đoạn này chạy, `ls` không trỏ tới một `List<String>`. Lúc chạy không phát hiện được, vì object không mang type argument đã dùng để tạo nó. Gán kiểu này là kiểu viết rất xấu. Raw type còn để nói chuyện với code cũ, không phải để viết code mới cho gọn.

---

## 3. Bound giới hạn kiểu, wildcard mô tả hướng dữ liệu

Method chỉ nhận số thì khai báo `<U extends Number>`. Ở đây `extends` nghĩa cả "kế thừa class" lẫn "implement interface". `inspect("some text")` không biên dịch vì `String` không phải `Number`. Bound còn cho phép gọi method của bound đó. `T extends Integer` thì `n.intValue()` gọi được.

Nhiều bound viết `<T extends A & B & C>`. `T` là subtype của tất cả. Nếu có một class trong bound, class đó đứng đầu. `T extends B & A & C` khi `A` là class và không đứng đầu thì không biên dịch.

Wildcard dùng cho tham số của method, khi mình chưa muốn chốt một kiểu. Nghĩ theo hướng dữ liệu:

- Tham số đưa dữ liệu vào cho method đọc, như `src` của `copy(src, dest)`, dùng `? extends ...`.
- Tham số nhận dữ liệu method ghi ra, như `dest`, dùng `? super ...`.
- Chỉ cần method của `Object` thì `?` không bound.
- Vừa đọc vừa ghi trên cùng biến thì không dùng wildcard.

Không trả wildcard từ method. Người gọi sẽ phải xử lý wildcard đó tiếp.

`List<? extends NaturalNumber>` trông như danh sách chỉ đọc. Không phải. `List<EvenNumber>` gán được vào biến đó, vì mọi even number là natural number. `add(new NaturalNumber(35))` thì không biên dịch: danh sách thật có thể toàn số chẵn, mình không được nhét một số tự nhiên bất kỳ. Vẫn làm được bốn việc: `add(null)`, `clear`, `remove` trên iterator, và ghi lại phần tử vừa đọc ra sau khi đã capture wildcard. Không thêm được phần tử mới khác `null`, và không đổi được phần tử đang có.

---

## 4. Lúc chạy không có class Box của String

Compiler hiện thực generic bằng type erasure. Type parameter có bound thì bị thay bằng bound. Không có bound thì bị thay bằng `Object`. Bytecode chỉ còn class, interface và method bình thường. Compiler chèn cast ở chỗ cần để kiểu vẫn đúng, và sinh bridge method để override vẫn chạy khi class con mở rộng kiểu generic.

Không có class `Box<String>` riêng và class `Box<Integer>` riêng. Vì không sinh class mới cho từng kiểu tham số, generic không thêm chi phí lúc chạy theo kiểu "mỗi tham số một class". Cast mà compiler chèn vẫn còn. Đó là lý do trộn raw type có thể qua mặt biên dịch rồi mới vỡ lúc cast.

---

## Kết luận

Collection và class của mình, mình ghi kiểu tham số. `List<String>` bắt nhét nhầm từ lúc biên dịch. `List` trơn hoãn việc đó tới lúc chạy.

Method chỉ đọc từ một collection thì tham số là `? extends`. Method chỉ ghi vào thì `? super`. Method vừa đọc vừa ghi thì chốt một kiểu, không wildcard. Đừng coi `List<? extends ...>` là danh sách đóng băng: `clear` và `remove` vẫn sửa được nó.

Raw type chỉ còn khi gọi API cũ. Gán nó vào biến generic mà thấy unchecked warning thì đó là chỗ heap pollution bắt đầu, không phải cảnh báo để tắt cho hết.

## References

- [Lesson: Generics (Updated)](https://docs.oracle.com/javase/tutorial/java/generics/index.html)
- [Why Use Generics?](https://docs.oracle.com/javase/tutorial/java/generics/why.html)
- [Raw Types](https://docs.oracle.com/javase/tutorial/java/generics/rawTypes.html)
- [Bounded Type Parameters](https://docs.oracle.com/javase/tutorial/java/generics/bounded.html)
- [Guidelines for Wildcard Use](https://docs.oracle.com/javase/tutorial/java/generics/wildcardGuidelines.html)
- [Type Erasure](https://docs.oracle.com/javase/tutorial/java/generics/erasure.html)
- [Chapter 4. Types, Values, and Variables](https://docs.oracle.com/javase/specs/jls/se25/html/jls-4.html)

## Series

- Previous: [Java Collections Framework: Phân tích kiến trúc List, Set, Map và Queue](../04-collections-framework/index.md)
- Next: [Xử lý ngoại lệ trong Java: Checked vs Unchecked Exception và Best Practices](../06-exception-handling/index.md)
