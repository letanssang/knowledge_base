---
title: "Lambda Expressions và Functional Interfaces trong Java 8+"
description: "Lambda cho phép truyền hành vi vào method gọn hơn anonymous class. Functional interface cung cấp kiểu đích để compiler hiểu lambda phải làm gì."

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

Một method nhận danh sách điểm số có thể cần lọc theo những ngưỡng khác nhau. Nếu mỗi ngưỡng cần một method gần như giống hệt nhau, phần khác biệt thật sự — điều kiện lọc — bị chôn trong rất nhiều code lặp.

Lambda expression giúp truyền chính phần hành vi thay đổi ấy vào method. Để hiểu vì sao compiler biết lambda phải nhận tham số nào và trả về kiểu gì, cần nhìn thêm khái niệm functional interface.

## Lambda là phần hành vi mình muốn truyền vào

Ta có thể định nghĩa một kiểu kiểm tra nhỏ:

```java
import java.util.function.Predicate;

class FilterExample {
    void run() {
        Predicate<Integer> isPositive = number -> number > 0;
    }
}
```

Lambda `number -> number > 0` mô tả điều kiện kiểm tra một số nguyên. Thay vì viết một class đầy đủ chỉ để cung cấp method `test`, lambda cho biết tham số và nội dung cần thực hiện. Khi yêu cầu lọc thay đổi, mình có thể truyền một lambda khác mà không viết lại phần duyệt danh sách.

`Predicate<Integer>` là functional interface có method `test` trả về `boolean`. Functional interface có một abstract method để lambda cung cấp implementation; nó vẫn có thể có `default` hoặc `static` methods. “Functional” không có nghĩa interface chỉ được phép chứa đúng một method dưới mọi hình thức. Annotation `@FunctionalInterface` giúp compiler kiểm tra ý định này.

## Vì sao compiler biết kiểu của lambda?

Lambda không tự mang một kiểu độc lập trong khai báo như `Integer` hay `Predicate<Integer>`. Compiler hiểu nó theo functional interface mà ngữ cảnh yêu cầu. Ở ví dụ trên, kiểu đích là `Predicate<Integer>`, nên `number` được hiểu là `Integer`, và biểu thức phải tạo ra kết quả `boolean` như method `test` yêu cầu.

Java có sẵn một số functional interfaces thường dùng trong `java.util.function`. `Predicate<T>` biểu diễn điều kiện trả về `boolean`; `Function<T, R>` nhận một giá trị và trả về giá trị khác; `Consumer<T>` nhận một giá trị để thực hiện hành động; `Supplier<T>` cung cấp một giá trị mà không nhận tham số. Dùng đúng kiểu giúp chữ ký method nói rõ đoạn hành vi được truyền vào sẽ làm gì.

## Lambda dùng biến bên ngoài theo một giới hạn

Lambda có thể đọc biến local ở scope bên ngoài, miễn là biến đó `final` hoặc effectively final — nghĩa là sau khi gán, code không gán lại nó. Ví dụ, mình có thể đặt `int limit = 5` rồi để lambda so sánh một số với `limit`. Nếu sau đó gán lại `limit`, compiler báo lỗi.

Giới hạn này giúp tránh một nhầm lẫn: lambda không giữ một bản sao có thể tự thay đổi của local variable. Nếu logic cần state có thể đổi trong lúc lambda chạy, hãy thiết kế state đó rõ ràng thay vì cố sửa biến local bị capture.

## Kết luận

Khi một method cần hành vi thay đổi theo từng lần gọi, xem liệu có thể truyền lambda thay vì tạo nhiều method gần giống nhau. Functional interface là hợp đồng cho lambda; kiểu đích cho compiler biết tham số và kết quả mong đợi. Bắt đầu bằng `Predicate`, `Function`, `Consumer` hoặc `Supplier` khi chữ ký của chúng diễn đạt đúng nhu cầu.

## References

- [Lambda Expressions](https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html)
- [java.util.function (Java SE 25)](https://docs.oracle.com/en/java/javase/25/docs/api/java.base/java/util/function/package-summary.html)

## Series

- Previous: [Xử lý ngoại lệ trong Java: Checked vs Unchecked Exception và Best Practices](../06-exception-handling/index.md)
- Next: [Java Stream API: Xử lý dữ liệu tuần tự, Song song và Cơ chế Lazy Evaluation](../08-stream-api/index.md)
