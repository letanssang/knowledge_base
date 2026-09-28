---
title: "Xử lý ngoại lệ trong Java: Checked vs Unchecked Exception và Best Practices"
description: "Checked exception, unchecked exception và try-with-resources theo JLS SE 25 cùng The Java Tutorials."

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

> **Tóm tắt:** Exception là cách Java báo một vi phạm ràng buộc ngữ nghĩa và chuyển điều khiển tới chỗ lập trình viên chỉ định. Checked exception phải có handler hoặc nằm trong `throws`. `RuntimeException` và `Error` được miễn kiểm tra lúc biên dịch. `try`-with-resources đóng resource theo thứ tự ngược lúc tạo.

*Thời gian đọc: ~9 phút*

---

## 1. Ném exception thay vì trả một giá trị lạ

Khi chương trình vi phạm ràng buộc ngữ nghĩa của ngôn ngữ, JVM báo cho chương trình bằng một exception. Ví dụ JLS đưa là truy cập ngoài biên của một mảng. Một số ngôn ngữ dừng chương trình ngay. Một số khác để implementation phản ứng tùy tiện. Cả hai cách đó không hợp mục tiêu của Java SE Platform là portability và robustness.

Ngôn ngữ quy định một exception sẽ được ném khi ràng buộc ngữ nghĩa bị vi phạm, và sẽ gây chuyển điều khiển không cục bộ từ chỗ exception xảy ra tới một điểm lập trình viên chỉ định. Exception được *thrown* từ chỗ nó xảy ra và được *caught* ở chỗ điều khiển được chuyển tới. Chương trình cũng ném exception tường minh bằng lệnh `throw`.

JLS đối chiếu với kiểu xử lý lỗi cũ: trả một giá trị lạ, như số nguyên `-1` ở chỗ giá trị âm vốn không được kỳ vọng. Kinh nghiệm trên trang là các giá trị đó quá thường bị người gọi bỏ qua hoặc không kiểm tra, và chương trình không robust, hoặc cư xử không như mong muốn, hoặc cả hai.

Mọi exception là một instance của class `Throwable` hoặc một subclass. Object đó mang thông tin từ chỗ exception xảy ra tới handler bắt nó. Handler được lập bằng mệnh đề `catch` của lệnh `try`.

---

## 2. Checked, run-time, và error không cùng một tập

`Throwable` là subclass trực tiếp của `Object`. `Throwable` và mọi subclass gọi chung là exception class. `Exception` và `Error` là hai subclass trực tiếp của `Throwable`.

`Exception` là superclass của mọi exception mà chương trình thông thường có thể muốn phục hồi. `RuntimeException` là subclass trực tiếp của `Exception`. Nó là superclass của các exception có thể bị ném vì nhiều lý do trong lúc tính biểu thức, nhưng phục hồi vẫn có thể còn. `RuntimeException` và mọi subclass gọi chung là run-time exception class.

`Error` là superclass của các exception mà chương trình thông thường không được kỳ vọng sẽ phục hồi. `Error` và mọi subclass gọi chung là error class. `Error` tách khỏi `Exception` trên cây class để idiom `catch (Exception e)` bắt được các exception còn có thể phục hồi mà không bắt các error mà phục hồi thường không thể.

Unchecked exception class là run-time exception class và error class. Checked exception class là mọi exception class còn lại. Nghĩa là `Throwable` và mọi subclass, trừ `RuntimeException` cùng subclass của nó, và trừ `Error` cùng subclass của nó.

Subclass của `Throwable` không được generic.

Ngôn ngữ đòi chương trình có handler cho checked exception có thể phát sinh khi thực thi method hoặc constructor. Với mỗi checked exception là kết quả có thể, mệnh đề `throws` phải nêu class của exception đó hoặc một superclass của class đó. Các checked exception class trong `throws` là một phần contract giữa người hiện thực và người dùng method hoặc constructor. Method override không được khai báo rằng nó sẽ ném checked exception nào mà method bị override không được phép ném theo `throws` của method đó.

Là lỗi biên dịch nếu thân method hoặc constructor *can throw* một checked exception class mà class đó không phải subclass của một class khai báo trong `throws`. Lambda body cũng vậy, đối với `throws` của function type mà lambda nhắm tới. Class variable initializer hoặc static initializer của named class hoặc interface mà *can throw* checked exception thì cũng là lỗi biên dịch.

Unchecked exception class được miễn kiểm tra lúc biên dịch. Error class được miễn vì chúng có thể xảy ra ở nhiều chỗ và phục hồi thì khó hoặc không thể. Khai báo chúng sẽ làm chương trình rối mà không ích. Chương trình tinh vi vẫn có thể muốn catch và thử phục hồi một số điều kiện đó. Run-time exception class được miễn vì, theo đánh giá của người thiết kế ngôn ngữ, bắt khai báo chúng không giúp đáng kể cho việc xác lập tính đúng của chương trình. Nhiều thao tác của ngôn ngữ có thể gây exception lúc chạy.

Tutorial *Unchecked Exceptions — The Controversy* nói ngôn ngữ không bắt method catch hoặc specify unchecked exception (`RuntimeException`, `Error`, và subclass của chúng). Người viết có thể bị cám dỗ chỉ ném unchecked exception, hoặc cho mọi exception subclass kế thừa `RuntimeException`, để khỏi đụng lỗi compiler. Trang nói cả hai đường tắt đó đi vòng ý định của yêu cầu catch hoặc specify, và gây vấn đề cho người dùng class.

Cùng trang nói runtime exception biểu diễn vấn đề do lỗi lập trình, và client của API không thể được kỳ vọng một cách hợp lý là phục hồi hoặc xử lý chúng. Ví dụ trang đưa là chia cho không, truy cập object qua null reference, và chỉ số mảng quá lớn hoặc quá nhỏ. Chúng có thể xảy ra ở bất kỳ đâu và trong một chương trình điển hình thì rất nhiều. Thêm chúng vào mọi khai báo method sẽ giảm độ rõ. Compiler không đòi catch hoặc specify runtime exception, dù mình vẫn làm được.

JLS nói phục hồi từ `RuntimeException` vẫn có thể còn. Tutorial nói client không được kỳ vọng hợp lý là phục hồi. Mình giữ cả hai câu, không gộp thành một luật "unchecked thì không bao giờ phục hồi được".

Guideline cuối trang tutorial: nếu client có thể được kỳ vọng hợp lý là phục hồi, hãy làm checked exception. Nếu client không làm gì để phục hồi, hãy làm unchecked exception. Đừng ném `RuntimeException` hoặc tạo subclass của nó chỉ vì không muốn phải specify exception mà method có thể ném. Một chỗ trang gọi là thực hành phổ biến là ném `RuntimeException` khi người dùng gọi method sai, ví dụ đối số `null` thì ném `NullPointerException`, một unchecked exception.

JLS nói điều điển hình là định nghĩa hầu hết exception class mới như checked exception class, tức subclass của `Exception` mà không phải subclass của `RuntimeException`, để tận dụng kiểm tra handler lúc biên dịch.

---

## 3. Đóng resource bằng try-with-resources

`try`-with-resources là lệnh `try` khai báo một hoặc nhiều resource. Resource là object phải được đóng sau khi chương trình dùng xong. Lệnh này bảo đảm mỗi resource được đóng ở cuối lệnh. Mọi object implement `java.lang.AutoCloseable`, gồm mọi object implement `java.io.Closeable`, dùng được làm resource.

`FileReader` và `BufferedReader`, từ Java SE 7, implement `AutoCloseable`. Khai báo chúng trong ngoặc ngay sau `try` thì chúng được đóng dù lệnh `try` kết thúc bình thường hay đột ngột, kể cả khi `readLine` ném `IOException`.

Trước Java SE 7, `finally` được dùng để đóng resource dù `try` kết thúc thế nào. Trang chỉ một lỗ hổng của mẫu đó. Nếu `readLine` ném exception và `br.close()` trong `finally` cũng ném exception, thì `FileReader` bị leak. Method đó ném exception từ `finally`. Exception từ khối `try` bị suppressed. Với `try`-with-resources, method ném exception từ khối `try`. Exception từ việc đóng resource bị suppressed.

Nhiều resource cách nhau bởi dấu chấm phẩy. `close` được gọi theo thứ tự *ngược* lúc tạo. `catch` hoặc `finally` của `try`-with-resources chạy sau khi các resource đã khai báo được đóng.

Exception từ khối `try` và một hoặc nhiều exception lúc đóng thì các exception lúc đóng bị suppressed. Lấy chúng bằng `Throwable.getSuppressed` trên exception do khối `try` ném.

`Closeable` extend `AutoCloseable`. `Closeable.close` ném `IOException`. `AutoCloseable.close` ném `Exception`. Subclass của `AutoCloseable` được override `close` để ném exception chuyên biệt hơn, như `IOException`, hoặc không ném exception nào.

`StackOverflowError` và `OutOfMemoryError` là subclass của `VirtualMachineError`. JLS nói `StackOverflowError` có thể bị ném đồng bộ khi gọi method, và cũng bất đồng bộ do thực thi method `native` hoặc do giới hạn tài nguyên của JVM. `OutOfMemoryError` có thể bị ném đồng bộ khi tạo class instance, tạo array, khởi tạo class, và boxing conversion, và cũng có thể bất đồng bộ. Asynchronous exception chỉ xảy ra vì lỗi nội bộ hoặc giới hạn tài nguyên của JVM khiến nó không hiện thực được ngữ nghĩa của ngôn ngữ. Exception bất đồng bộ được ném là instance của một subclass của `VirtualMachineError`.

---

## Kết luận

Mình đọc `throws` của một method như một phần contract, ngang với parameter và giá trị trả về, đúng câu tutorial. Checked exception mà thân method có thể ném thì phải có trong `throws` hoặc được xử lý, nếu không là lỗi biên dịch. Unchecked thì compiler không đòi điều đó.

Exception class mới mình để là subclass của `Exception` và không phải `RuntimeException` khi muốn compiler nhắc người gọi, vì đó là hướng JLS gọi là điển hình. Mình không đổi nó thành `RuntimeException` chỉ để khỏi viết `throws`. Resource implement `AutoCloseable` thì mình đóng bằng `try`-with-resources, vì `finally` tự gọi `close` có thể nuốt exception gốc và làm leak resource còn lại.

## References

- [Chapter 11. Exceptions](https://docs.oracle.com/javase/specs/jls/se25/html/jls-11.html)
- [Unchecked Exceptions — The Controversy](https://docs.oracle.com/javase/tutorial/essential/exceptions/runtime.html)
- [The try-with-resources Statement](https://docs.oracle.com/javase/tutorial/essential/exceptions/tryResourceClose.html)

## Series

- Previous: [Generics trong Java: Type Safety, Wildcards và Cơ chế Type Erasure](../05-generics/index.md)
- Next: [Lambda Expressions và Functional Interfaces trong Java 8+](../07-lambda-and-functional-interfaces/index.md)
