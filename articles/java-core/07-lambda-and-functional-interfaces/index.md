---
title: "Lambda Expressions và Functional Interfaces trong Java 8+"
description: "Lambda là thân của một method duy nhất, truyền vào chỗ đang cần hành vi. Kiểu của lambda là kiểu chỗ nó được gắn vào. Biến bên ngoài mà lambda đọc thì không được gán lại."

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

> **Tóm tắt:** Khi mình chỉ cần đưa một việc vào một method, anonymous class của interface một method dài hơn việc đó. Lambda viết mỗi phần việc. Compiler lấy kiểu của lambda từ chỗ nó đang đứng. Package `java.util.function` có sẵn các hình hay gặp, từ Java SE 8.

*Thời gian đọc: ~9 phút*

---

## 1. Một method dài vì mỗi điều kiện là một API

`printPersonsOlderThan` chỉ in người lớn hơn một tuổi. Đổi class `Person`, method này phải viết lại. Muốn in người trẻ hơn thì lại một method mới. `printPersonsWithinAgeRange` cũng vậy: mỗi câu hỏi mới là một method mới, và method đó vỡ khi `Person` đổi field.

Việc lọc tách ra một interface:

```java
interface CheckPerson {
    boolean test(Person p);
}
```

`printPersons` nhận danh sách và một `CheckPerson`. Anonymous class implement `test` vẫn dài, vì cả khối class chỉ để chứa một method. Lambda là phần method đó:

```java
printPersons(
    roster,
    (Person p) -> p.getGender() == Person.Sex.MALE
        && p.getAge() >= 18
        && p.getAge() <= 25
);
```

`CheckPerson` là functional interface vì nó chỉ có một abstract method. Interface vẫn được có default method và static method. Vì chỉ một abstract method, mình không cần nhắc tên method khi viết lambda.

---

## 2. Bốn hình mình hết phải tự khai báo

`java.util.function` có từ Java SE 8. Mỗi interface trong đó có một abstract method, gọi là functional method. Lambda và method reference được khớp vào method đó. `@FunctionalInterface` không bắt buộc để compiler nhận ra interface. Nó ghi ý đồ, và compiler báo khi mình lỡ thêm abstract method thứ hai.

Bốn hình cơ bản:

| Interface | Việc |
| --- | --- |
| `Predicate<T>` | nhận `T`, trả `boolean`. Method là `test`. |
| `Consumer<T>` | nhận `T`, không trả gì. Method là `accept`. |
| `Function<T, R>` | nhận `T`, trả `R`. Method là `apply`. |
| `Supplier<R>` | không nhận gì, trả `R`. |

`Predicate<Person>` thay được `CheckPerson`. `Consumer<Person>` thay được lời gọi in một người. `Function<Person, String>` lấy email rồi đưa cho một `Consumer<String>`.

Hình hai tham số thêm tiền tố `Bi`, như `BiFunction`. `UnaryOperator` là `Function` mà kiểu vào và kiểu ra giống nhau. `BinaryOperator` là `BiFunction` cùng kiểu. Kiểu primitive có tiền tố riêng: `ToIntFunction` khi kết quả là `int`, `DoubleConsumer` khi đối số là `double`.

Các interface này không phủ hết mọi hình lambda có thể có. Chúng đủ cho việc hay gặp. Interface chuyên một việc, như `FileFilter`, nằm ở package của việc đó.

Khi một method nói nó nhận "function", nghĩa là một reference không `null` tới object implement functional interface đó, trừ khi tài liệu của method nói rõ là được `null`.

---

## 3. Cú pháp, biến bên ngoài, và kiểu lấy từ chỗ đứng

Lambda gồm tham số, mũi tên `->`, và một thân. Thân là một biểu thức hoặc một khối `{}`. Một tham số thì bỏ được ngoặc. Kiểu của tham số cũng bỏ được khi compiler suy ra. Biểu thức thì giá trị của nó là giá trị trả về. `return` không phải biểu thức, nên phải nằm trong ngoặc nhọn.

```java
interface IntegerMath {
    int operation(int a, int b);
}

int operateBinary(int a, int b, IntegerMath op) {
    return op.operation(a, b);
}

IntegerMath addition = (a, b) -> a + b;
IntegerMath subtraction = (a, b) -> a - b;
```

`operateBinary(40, 2, addition)` trả `42`. `operateBinary(20, 10, subtraction)` trả `10`.

Lambda không mở một tầng scope mới. Tên trong lambda hiểu như trong khối bao quanh. Tham số của lambda không được trùng biến local của khối đó. `this` trong lambda là `this` của class bao, không phải một object riêng của lambda.

Lambda chỉ đọc biến local và tham số của khối bao khi biến đó là `final` hoặc effectively final. Gán lại biến đó trong lambda thì compiler báo lỗi: biến phải final hoặc effectively final. Đây là ràng buộc thật, không phải cảnh báo.

Lambda không mang kiểu của riêng nó. Cùng một `() -> "done"` là `Callable` khi method cần giá trị trả về, và không được chọn overload `Runnable` vì `Runnable.run` không trả gì. Compiler nhìn chỗ lambda đứng: biến đang gán, `return`, đối số method, toán tử `?:`, hoặc một cast. Không suy ra chỗ đứng thì lambda không dùng được.

Serialize một lambda được khi kiểu đích và các giá trị nó giữ từ bên ngoài đều serializable. Việc serialize lambda không nên làm, cùng lý do với inner class.

---

## Kết luận

Chỗ nào mình đang viết anonymous class chỉ để có một method, mình đổi thành lambda. Hình đã có trong `java.util.function` thì dùng `Predicate`, `Consumer`, `Function` hoặc `Supplier`, không khai báo interface mới cùng hình.

Lambda đọc biến local thì biến đó không được gán lại sau khi khởi tạo. Cùng một lambda gán được vào nhiều kiểu. Kiểu nào được chọn là kiểu của chỗ nó đang đứng, thường là tham số của method.

## References

- [Lambda Expressions](https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html)
- [java.util.function (Java SE 25)](https://docs.oracle.com/en/java/javase/25/docs/api/java.base/java/util/function/package-summary.html)

## Series

- Previous: [Xử lý ngoại lệ trong Java: Checked vs Unchecked Exception và Best Practices](../06-exception-handling/index.md)
- Next: [Java Stream API: Xử lý dữ liệu tuần tự, Song song và Cơ chế Lazy Evaluation](../08-stream-api/index.md)
