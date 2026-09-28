---
title: "Xử lý ngoại lệ trong Java: Checked vs Unchecked Exception và Best Practices"
description: "Checked exception buộc method khai báo hoặc xử lý. RuntimeException và Error thì không. try-with-resources đóng resource theo thứ tự ngược lúc tạo và không nuốt exception gốc."

date:
updated:

series: "Java Core"
series_order: 6

tags:
  - java
  - exception
  - error-handling
  - best-practices

status: draft
language: vi
---

# Xử lý ngoại lệ trong Java: Checked vs Unchecked Exception và Best Practices

> **Tóm tắt:** Trả `-1` khi lỗi thì người gọi dễ quên kiểm tra. Exception nhảy tới chỗ mình đã chuẩn bị sẵn. Checked exception phải được xử lý hoặc ghi trong `throws`. `RuntimeException` và `Error` thì compiler không bắt. Resource mở trong `try` được đóng ngược thứ tự tạo.

*Thời gian đọc: ~9 phút*

---

## 1. Đừng trả một con số lạ

Method tìm vị trí trả `-1` khi không thấy. Người gọi quên kiểm tra `-1` rồi dùng nó như một chỉ số. Chương trình chạy tiếp, sai ở chỗ khác.

Exception làm việc khác. Chương trình vi phạm một ràng buộc của ngôn ngữ, ví dụ chỉ số mảng nằm ngoài biên, thì JVM ném một exception và nhảy tới chỗ mình chỉ định. Dừng cả process, hoặc để máy ảo phản ứng tùy ý, không hợp với mục tiêu chương trình Java chạy được trên nhiều nền và vẫn kiểm soát được lỗi.

Exception là một object `Throwable` hoặc class con. Nó mang thông tin từ chỗ lỗi tới khối `catch`. Mình cũng ném tường minh bằng `throw`.

---

## 2. Ba tầng, và chỉ một tầng bị compiler hỏi

`Throwable` là con trực tiếp của `Object`. Hai con trực tiếp của nó là `Exception` và `Error`.

`Exception` là những gì chương trình bình thường có thể muốn phục hồi. `RuntimeException` là con trực tiếp của `Exception`: lỗi ném ra khi đang tính biểu thức, và phục hồi vẫn có thể làm được. `Error` là những gì chương trình bình thường không được kỳ vọng sẽ gượng lại, như hết bộ nhớ. `Error` tách khỏi `Exception` để `catch (Exception e)` bắt phần còn có thể xử lý mà không nuốt `Error`.

Unchecked là `RuntimeException`, `Error`, và mọi class con của chúng. Checked là phần còn lại: `Throwable` và các class con, trừ hai nhánh unchecked đó. Class con của `Throwable` không được là generic.

Compiler đòi handler hoặc `throws` cho checked exception mà method hoặc constructor có thể ném. `throws` phải nêu đúng class đó hoặc một class cha. Đó là một phần hợp đồng, ngang với tham số và giá trị trả về. Method override không được khai báo thêm checked exception mà method bị override không được phép ném.

Thiếu `throws` hoặc thiếu `catch` cho checked exception là lỗi biên dịch. Lambda cũng vậy, đối chiếu với `throws` của function type mà lambda đang gán vào. Khối khởi tạo `static`, hoặc khởi tạo field `static`, mà ném checked exception thì không biên dịch. Field và khối khởi tạo của instance chỉ được ném checked exception khi class có ít nhất một constructor viết tường minh, và mỗi constructor đó khai báo exception này hoặc class cha của nó trong `throws`.

`RuntimeException` và `Error` được miễn. `Error` có thể xảy ra ở rất nhiều chỗ và thường không phục hồi được. Khai báo hết sẽ làm chữ ký method dày mà không thêm được gì. Chương trình vẫn có thể `catch` một số `Error` nếu nó thực sự muốn thử. `RuntimeException` được miễn vì bắt khai báo chúng không giúp chứng minh chương trình đúng hơn bao nhiêu. Rất nhiều phép tính trong ngôn ngữ có thể ném chúng.

`StackOverflowError` và `OutOfMemoryError` là con của `VirtualMachineError`, tức là `Error`. Chúng có thể ném đồng bộ, đúng chỗ ngôn ngữ đã nói, và cũng có thể ném bất đồng bộ khi máy ảo hết khả năng thực hiện ngữ nghĩa của ngôn ngữ. Exception bất đồng bộ chỉ thuộc nhánh `VirtualMachineError`.

---

## 3. Exception mới để checked khi người gọi làm được việc gì đó

Bỏ qua checked exception bằng cách cho mọi lỗi kế thừa `RuntimeException` thì compiler im, nhưng người dùng class không còn thấy method có thể thất bại thế nào.

Runtime exception thường là lỗi lập trình: chia cho không, gọi method trên `null`, chỉ số mảng sai. Chúng có thể xảy ra hầu như ở mọi dòng. Khai báo hết sẽ làm chữ ký method không đọc được. Compiler không bắt mình catch chúng, nhưng mình vẫn catch được.

Một chỗ hay ném `RuntimeException` là khi người gọi dùng method sai. Đối số `null` trong khi method không nhận `null` thì `NullPointerException` là unchecked exception phù hợp.

Khi mình tạo class exception mới, câu để quyết định là người gọi có làm được gì không. Họ phục hồi được, ví dụ thử file khác hoặc báo cho user, thì class đó là checked: con của `Exception`, không phải con của `RuntimeException`. Họ không làm được gì, thì unchecked. Đừng chọn `RuntimeException` chỉ vì không muốn viết `throws`. Hướng thông thường khi thêm exception mới là checked, để compiler nhắc người gọi.

`RuntimeException` vẫn là loại mà chương trình có thể phục hồi. Lời khuyên "đừng bắt người gọi xử lý" là về thiết kế API, không phải về việc JVM cấm `catch`.

---

## 4. Đóng resource mà không nuốt lỗi gốc

Resource là object phải đóng sau khi dùng xong. Mọi object implement `AutoCloseable` làm được việc này, kể cả object implement `Closeable`. `FileReader` và `BufferedReader` implement `AutoCloseable` từ Java SE 7.

```java
try (BufferedReader br = new BufferedReader(new FileReader(path))) {
    return br.readLine();
}
```

Dù `readLine` ném `IOException` hay chạy xong, reader vẫn được đóng. Nhiều resource khai báo cách nhau bởi dấu chấm phẩy. `close` chạy ngược thứ tự tạo. `catch` và `finally` của chính câu `try` chạy sau khi các resource đã đóng.

`finally` tự gọi `close` có một lỗ. `readLine` ném exception, rồi `br.close()` trong `finally` cũng ném. Exception từ `finally` bay ra. Exception từ `try` bị chôn, và `FileReader` bên trong có thể không được đóng. `try`-with-resources để exception của khối `try` bay ra. Exception lúc đóng bị gắn kèm, lấy bằng `Throwable.getSuppressed`.

`Closeable` là con của `AutoCloseable`. `Closeable.close` ném `IOException`. `AutoCloseable.close` ném `Exception`. Class con được thu hẹp, ném `IOException`, hoặc không ném gì.

---

## Kết luận

Method thất bại theo một cách người gọi xử lý được thì mình để checked exception và ghi trong `throws`. Lỗi do người gọi dùng sai, như `null` ở chỗ không nhận `null`, thì `RuntimeException`. Không đổi checked thành unchecked chỉ để chữ ký method sạch.

File, socket, và mọi thứ implement `AutoCloseable` thì mở trong ngoặc của `try`. Không đóng bằng `finally` nếu `close` cũng có thể ném, vì exception gốc sẽ mất và resource tạo trước có thể không được đóng.

## References

- [Chapter 11. Exceptions](https://docs.oracle.com/javase/specs/jls/se25/html/jls-11.html)
- [Unchecked Exceptions — The Controversy](https://docs.oracle.com/javase/tutorial/essential/exceptions/runtime.html)
- [The try-with-resources Statement](https://docs.oracle.com/javase/tutorial/essential/exceptions/tryResourceClose.html)

## Series

- Previous: [Generics trong Java: Type Safety, Wildcards và Cơ chế Type Erasure](../05-generics/index.md)
- Next: [Lambda Expressions và Functional Interfaces trong Java 8+](../07-lambda-and-functional-interfaces/index.md)
