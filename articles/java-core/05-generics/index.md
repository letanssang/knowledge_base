---
title: "Generics trong Java: Type Safety, Wildcards và Cơ chế Type Erasure"
description: "Type parameter, raw type, bound, wildcard in/out và type erasure theo The Java Tutorials, cùng heap pollution trong JLS SE 25."

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

> **Tóm tắt:** Generics đưa kiểu vào chỗ tham số để compiler kiểm tra sớm hơn và bỏ bớt cast. Raw type còn để nói chuyện với code trước JDK 5.0. Type erasure thay type parameter bằng bound hoặc `Object`, nên không sinh class mới cho từng parameterized type.

*Thời gian đọc: ~9 phút*

---

## 1. Kiểm tra lúc biên dịch thay cho cast lúc chạy

Bug lúc biên dịch hiện sớm. Bug lúc chạy có thể hiện ở chỗ rất xa nguyên nhân. Lesson Generics nói generics làm code ổn hơn bằng cách đưa nhiều bug hơn vào lúc biên dịch.

Generics cho phép *type*, tức class và interface, làm tham số khi định nghĩa class, interface và method. Khác với formal parameter của method, đầu vào của formal parameter là giá trị, còn đầu vào của type parameter là kiểu. Cùng một đoạn code dùng lại với các kiểu khác nhau.

Tutorial liệt kê ba lợi ích so với code không generic:

- Compiler kiểm tra kiểu mạnh hơn và báo lỗi nếu code phá type safety. Sửa lỗi biên dịch dễ hơn sửa lỗi runtime.
- Hết cast. `List list = new ArrayList(); list.add("hello");` rồi `String s = (String) list.get(0);` đổi thành `List<String>` thì `list.get(0)` không cần cast.
- Viết được thuật toán generic trên collection của nhiều kiểu, tùy biến được, type safe và dễ đọc hơn.

---

## 2. Raw type là tên generic không có type argument

Raw type là tên của generic class hoặc interface không kèm type argument. `Box<Integer> intBox = new Box<>();` là parameterized type. `Box rawBox = new Box();` là raw type của `Box<T>`. Class hoặc interface không generic thì không phải raw type.

Raw type có trong legacy code vì nhiều API, như các class Collections, chưa generic trước JDK 5.0. Dùng raw type thì mình nhận behavior thời trước generics: một `Box` đưa cho mình `Object`.

Gán parameterized type sang raw type thì được, để tương thích ngược:

```java
Box<String> stringBox = new Box<>();
Box rawBox = stringBox;               // OK
```

Gán raw type sang parameterized type thì có warning unchecked conversion. Gọi method generic qua raw type cũng vậy. `rawBox.set(8)` là unchecked invocation tới `set(T)`. Warning cho thấy raw type đi vòng kiểm tra generic và để phần không an toàn tới runtime. Tutorial nói mình nên tránh raw type.

"Unchecked" nghĩa là compiler không đủ thông tin kiểu để làm mọi kiểm tra cần cho type safety. Warning unchecked tắt mặc định, nhưng compiler vẫn gợi ý. Muốn thấy chi tiết thì biên dịch lại với `-Xlint:unchecked`. Tắt hẳn bằng `-Xlint:-unchecked`. Annotation `@SuppressWarnings("unchecked")` cũng chặn warning này.

JLS SE 25 nói thêm vì sao raw type còn tồn tại. Để nối với legacy code không generic, mình được dùng erasure của một parameterized type. Đó là raw type. Thiết kế generic theo đuổi migration compatibility: code cũ tiến lên generic mà không bắt các module phát triển độc lập phải phụ thuộc nhau. Cái giá là không thể reify đầy đủ và đúng hệ thống generic, ít nhất trong lúc quá trình chuyển còn diễn ra.

Heap pollution, cũng trong JLS §4.12.2, là việc một biến của parameterized type trỏ tới object không phải parameterized type đó. Nó chỉ xảy ra nếu chương trình làm một thao tác raw type đáng lẽ ra unchecked warning, hoặc alias một array có element type không reifiable qua một array supertype raw hoặc non-generic. Ví dụ:

```java
List l = new ArrayList<Number>();
List<String> ls = l;  // unchecked warning
```

Nếu chạy, `ls` không trỏ tới một `List<String>`. Không nhận ra lúc chạy vì type variable không được reify. Instance không mang type argument đã dùng để tạo ra chúng. JLS gọi kiểu gán này là very bad style.

---

## 3. Bound và wildcard không cùng một việc

Bounded type parameter hạn chế kiểu được dùng làm type argument. Method chỉ muốn `Number` hoặc subclass thì khai báo tên type parameter, rồi `extends`, rồi upper bound. Trong ngữ cảnh này `extends` nghĩa rộng: extends với class, hoặc implements với interface.

`public <U extends Number> void inspect(U u)` làm `inspect("some text")` không biên dịch, vì `String` không phải `Number`. Bound còn cho phép gọi method định nghĩa trên bound. `NaturalNumber<T extends Integer>` gọi được `n.intValue()` vì `intValue` nằm trên `Integer`.

Nhiều bound viết `<T extends B1 & B2 & B3>`. Type variable là subtype của mọi kiểu trong bound. Nếu một bound là class, class đó phải đứng đầu. `T extends B & A & C` khi `A` là class và không đứng đầu thì là lỗi biên dịch.

Wildcard là chuyện khác, dùng khi thiết kế tham số của method. Trang Guidelines for Wildcard Use chia biến thành hai vai:

- Biến "in" cung cấp dữ liệu cho code. Trong `copy(src, dest)`, `src` là "in". Khai báo bằng upper bounded wildcard, keyword `extends`.
- Biến "out" giữ dữ liệu để chỗ khác dùng. `dest` nhận dữ liệu, nên là "out". Khai báo bằng lower bounded wildcard, keyword `super`.
- Nếu biến "in" chỉ cần method của `Object`, dùng unbounded wildcard.
- Nếu code cần dùng biến vừa như "in" vừa như "out", không dùng wildcard.

Các guideline này không áp dụng cho return type của method. Dùng wildcard làm return type nên tránh, vì người gọi phải đối mặt với wildcard.

`List<? extends ...>` có thể nghĩ một cách không chính thức là read-only, nhưng đó không phải đảm bảo chặt. `List<EvenNumber>` là subtype của `List<? extends NaturalNumber>`, nên gán được. `ln.add(new NaturalNumber(35))` là lỗi biên dịch: không dùng `ln` để thêm một natural number vào list các even number. Vẫn làm được bốn việc trang liệt kê: thêm `null`, gọi `clear`, lấy iterator rồi `remove`, và capture wildcard để ghi các phần tử đã đọc từ list. Không cất được phần tử mới và không đổi được phần tử đang có. Vì vậy mình có thể nghĩ nó là read-only, trong khi nó không read-only theo nghĩa chặt nhất.

---

## 4. Type erasure

Compiler áp dụng type erasure để hiện thực generics. Tutorial mô tả ba việc:

- Thay mọi type parameter trong generic type bằng bound của chúng, hoặc bằng `Object` nếu type parameter không bound. Bytecode sinh ra chỉ còn class, interface và method bình thường.
- Chèn cast khi cần để giữ type safety.
- Sinh bridge method để giữ polymorphism ở generic type được extend.

Type erasure bảo đảm không tạo class mới cho parameterized type. Hệ quả trang nêu: generics không phát sinh runtime overhead.

Mình không đọc câu này thành "mọi thông tin kiểu đều biến mất và cast không bao giờ được chèn". Cùng trang nói compiler chèn cast khi cần, và sinh bridge method. Phần biến mất là class riêng cho từng `Box<String>` hay `Box<Integer>`.

---

## Kết luận

Mình khai báo type argument ở collection và ở class generic của mình, vì đó là chỗ compiler bắt cast sai trước khi chạy. Raw type chỉ còn khi phải chạm API viết trước JDK 5.0. Gán raw type vào biến generic là unchecked conversion, không phải một phép gán im lặng an toàn.

Wildcard mình chọn theo vai của tham số trên trang guideline: dữ liệu đi vào method thì `extends`, dữ liệu đi ra khỏi method thì `super`, còn vừa đọc vừa ghi thì không wildcard. `List<? extends ...>` không phải một list cấm mọi sửa đổi. Nó cấm thêm phần tử mới không phải `null`, và vẫn cho `clear` cùng `remove` của iterator.

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
