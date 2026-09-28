---
title: "Lambda Expressions và Functional Interfaces trong Java 8+"
description: "Lambda thay anonymous class một method, functional interface trong java.util.function, và target type theo The Java Tutorials cùng API Java SE 25."

date:
updated:

series: "Java Core"
series_order: 7

tags:
  - java
  - lambda
  - functional-programming
  - java-8

status: draft
language: vi
---

# Lambda Expressions và Functional Interfaces trong Java 8+

> **Tóm tắt:** Lambda là cách viết gọn một instance của class chỉ có một method, để đưa hành vi vào chỗ đang cần đối số. Functional interface chỉ có một abstract method. Compiler lấy kiểu của lambda từ target type của chỗ lambda xuất hiện.

*Thời gian đọc: ~9 phút*

---

## 1. Đưa hành vi vào một đối số

Anonymous class trở nên cồng kềnh khi phần hiện thực rất đơn giản, chẳng hạn một interface chỉ có một method. Trường hợp đó thường là đưa một hành vi vào method khác, ví dụ việc phải làm khi người dùng bấm nút. Lambda cho phép coi chức năng như đối số của method, hoặc coi code như dữ liệu. Tutorial nói lambda diễn tả instance của class một method một cách gọn hơn.

Ví dụ xuyên suốt là lọc thành viên trong một `List<Person>`. Method `printPersonsOlderThan` chỉ in người lớn hơn một tuổi. Trang gọi cách này là có thể làm ứng dụng *brittle*: đổi cấu trúc `Person` thì phải viết lại nhiều API, và method cũng không in được người trẻ hơn một tuổi. `printPersonsWithinAgeRange` rộng hơn nhưng vẫn vỡ nếu mỗi truy vấn là một method mới.

`printPersons(List<Person> roster, CheckPerson tester)` tách tiêu chí ra interface:

```java
interface CheckPerson {
    boolean test(Person p);
}
```

Anonymous class implement `test` vẫn dài, vì interface chỉ có một method. Lambda thay chỗ đó:

```java
printPersons(
    roster,
    (Person p) -> p.getGender() == Person.Sex.MALE
        && p.getAge() >= 18
        && p.getAge() <= 25
);
```

`CheckPerson` là functional interface vì nó chỉ chứa một abstract method. Functional interface vẫn được chứa một hoặc nhiều default method hoặc static method. Vì chỉ có một abstract method, mình bỏ được tên method khi hiện thực.

---

## 2. Bốn hình cơ bản trong `java.util.function`

Package `java.util.function` có từ Java SE 1.8. Tài liệu package nói functional interface cung cấp target type cho lambda expression và method reference. Mỗi functional interface có một abstract method, gọi là *functional method*. Parameter và return type của lambda được khớp hoặc thích ứng với method đó.

Các interface trong package là hình tổng quát mà JDK dùng và code người dùng cũng dùng được. Chúng không phải tập đầy đủ mọi hình lambda có thể thích ứng, nhưng đủ cho nhu cầu thường gặp. Interface chuyên việc, như `FileFilter`, nằm ở package nơi nó được dùng.

Annotation `@FunctionalInterface` không phải điều kiện để compiler nhận một interface là functional interface. Nó ghi ý đồ thiết kế và nhờ compiler bắt chỗ vô tình phá ý đồ đó.

Quy ước tên trên package có vài hình cơ bản:

| Interface | Hình |
| --- | --- |
| `Function<T, R>` | hàm một ngôi từ `T` sang `R` |
| `Consumer<T>` | hàm một ngôi từ `T` sang void |
| `Predicate<T>` | hàm một ngôi từ `T` sang boolean |
| `Supplier<R>` | hàm không đối số trả `R` |

Hình cơ bản đổi arity bằng tiền tố, như `BiFunction`. `UnaryOperator` extend `Function`. `BinaryOperator` extend `BiFunction`. Tham số kiểu được chuyên biệt hóa sang primitive bằng tiền tố kiểu, như `ToIntFunction` khi chuyên biệt hóa kiểu trả về, hoặc `DoubleConsumer` khi chuyên biệt hóa đối số từ trái sang phải.

Tutorial dùng đúng các method đó. `Predicate<T>` có `boolean test(T t)`, nên thay được `CheckPerson`. `Consumer<T>` có `void accept(T t)`, nên thay được lời gọi `printPerson`. `Function<T, R>` có `R apply(T t)`, nên lấy email từ `Person` rồi đưa cho một `Consumer<String>`.

Khi tài liệu nói một method nhận hoặc trả một functional interface theo cách "áp dụng function được cung cấp", câu đó hiểu là một reference *không null* tới object implement functional interface phù hợp, trừ khi khả năng null được nêu rõ.

---

## 3. Cú pháp, scope, và target type

Một lambda gồm danh sách formal parameter trong ngoặc, token `->`, và một thân. Thân là một biểu thức hoặc một khối lệnh. Bỏ được kiểu của parameter. Nếu chỉ một parameter thì bỏ được cả ngoặc. Một biểu thức thì runtime tính biểu thức rồi trả giá trị của nó. Lệnh `return` không phải biểu thức, nên phải nằm trong `{}`. Lời gọi method void thì không bắt buộc ngoặc. Tutorial coi lambda như method không tên.

`Calculator` trên trang định nghĩa `IntegerMath` với `int operation(int a, int b)`. `(a, b) -> a + b` và `(a, b) -> a - b` đưa vào `operateBinary`. Output trang in là `40 + 2 = 42` và `20 - 10 = 10`.

Lambda scoped theo từ vựng. Nó không kế thừa tên từ supertype và không mở một tầng scope mới. Khai báo trong lambda được hiểu như trong môi trường bao quanh. Vì vậy parameter của lambda không được khai báo lại local variable của scope bao. Tutorial đưa lỗi "Lambda expression's parameter x cannot redeclare another local variable defined in an enclosing scope". `this` trong ví dụ `LambdaScopeTest` trỏ tới member của class bao trong, `FirstLevel.x`, không phải một instance của lambda. `LambdaScopeTest.this.x` mới tới field của class ngoài.

Giống local class và anonymous class, lambda chỉ truy cập local variable và parameter của khối bao nếu chúng là final hoặc effectively final. Gán `z = 99` bên trong lambda làm `z` không còn effectively final, và compiler báo lỗi dạng "Local variable z defined in an enclosing scope must be final or effectively final". Khác local class và anonymous class, lambda không có vấn đề shadowing theo cách trang mô tả ở mục scope.

Kiểu của lambda không nằm trên chính nó. Compiler lấy *target type* từ ngữ cảnh. Cùng một lambda là `CheckPerson` khi method đang chờ `CheckPerson`, và là `Predicate<Person>` khi method đang chờ `Predicate<Person>`. Lambda chỉ dùng được ở chỗ compiler xác định được target type. Trang liệt kê: khai báo biến, phép gán, lệnh return, array initializer, đối số của method hoặc constructor, thân lambda, biểu thức điều kiện `?:`, và cast.

Với đối số method, compiler dùng overload resolution và type argument inference. `invoke(Runnable)` không trả giá trị. `invoke(Callable<T>)` trả giá trị. `String s = invoke(() -> "done")` chọn `invoke(Callable<T>)` vì method đó trả giá trị. Kiểu của lambda trong câu đó là `Callable<T>`.

Serialize một lambda được nếu target type và các đối số nó capture là serializable. Tutorial nói việc serialize lambda bị strongly discouraged, giống inner class.

---

## Kết luận

Mình viết interface một abstract method khi muốn nhận một hành vi, rồi để chỗ gọi truyền lambda thay vì một class có tên. Nếu hình đã có trong `java.util.function`, mình dùng `Predicate`, `Consumer`, `Function` hoặc `Supplier` thay vì khai báo interface mới cùng hình. Kiểu của lambda là kiểu chỗ nó được gắn vào, không phải một kiểu mình đọc được từ mũi tên `->`.

Local variable mà lambda đọc phải final hoặc effectively final. Gán lại biến đó trong lambda là lỗi biên dịch, không phải một cập nhật thấy được lúc chạy. Serialize lambda thì trang khuyên không làm, kể cả khi target type có serializable.

## References

- [Lambda Expressions](https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html)
- [java.util.function (Java SE 25)](https://docs.oracle.com/en/java/javase/25/docs/api/java.base/java/util/function/package-summary.html)

## Series

- Previous: [Xử lý ngoại lệ trong Java: Checked vs Unchecked Exception và Best Practices](../06-exception-handling/index.md)
- Next: [Java Stream API: Xử lý dữ liệu tuần tự, Song song và Cơ chế Lazy Evaluation](../08-stream-api/index.md)
