---
title: "Xử lý ngoại lệ trong Java: Checked vs Unchecked Exception và Best Practices"
description: "Exception giúp chuyển lỗi tới nơi có thể quyết định cách xử lý. Bài viết giải thích checked/unchecked exception và cách try-with-resources đóng tài nguyên đúng lúc."

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

Một method đọc file có thể chạy tốt trong nhiều lần thử, rồi gặp file không mở được ở lần tiếp theo. Nếu nó chỉ trả về một giá trị đặc biệt như `-1`, mỗi nơi gọi phải nhớ `-1` có nghĩa gì và tự kiểm tra. Exception đưa lỗi thành một đường đi rõ ràng trong chương trình: method có thể xử lý lỗi, hoặc báo cho caller rằng họ cần quyết định tiếp.

## Checked và unchecked: Java buộc caller biết về lỗi nào?

Checked exception là lỗi mà compiler yêu cầu method phải `catch` hoặc khai báo bằng `throws`. Khi đọc chữ ký một method có `throws IOException`, caller biết thao tác có thể thất bại theo cách cần được xử lý. Quy tắc đó buộc lỗi không bị lờ đi một cách tình cờ.

`RuntimeException` và các class con của nó, cùng với `Error`, là unchecked: compiler không yêu cầu khai báo hoặc bắt chúng. Ranh giới này không nói rằng unchecked exception không quan trọng; nó cho biết ngôn ngữ không bắt mọi method phải chuyển chúng lên chữ ký.

Khi thiết kế API, hãy cân nhắc điều caller có thể làm. Nếu caller có khả năng phục hồi — ví dụ yêu cầu chọn file khác — checked exception có thể làm hợp đồng rõ hơn. Nếu lỗi thường do gọi API sai và không có cách phục hồi có ích tại caller, unchecked exception có thể phù hợp hơn. Đây là quyết định thiết kế theo tình huống, không phải quy tắc “mọi lỗi đều phải checked” hay “cứ dùng runtime cho gọn”.

## Đọc file cũng có nghĩa là phải đóng resource

Đọc xong file, chương trình cần giải phóng resource đã mở. Đặt `FileReader` và `BufferedReader` trong try-with-resources để Java tự đóng chúng khi khối `try` kết thúc — dù kết thúc bình thường hay do exception:

```java
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

class FirstLineReader {
    static String readFirstLine(String path) throws IOException {
        try (FileReader file = new FileReader(path);
             BufferedReader reader = new BufferedReader(file)) {
            return reader.readLine();
        }
    }
}
```

Những resource khai báo trong ngoặc phải implement `AutoCloseable`. Khi có nhiều resource, Java đóng chúng theo thứ tự ngược với lúc tạo: `reader` được đóng trước, sau đó đến `file`. Nhờ vậy, resource được bọc bên ngoài đóng trước resource mà nó đang dùng.

Việc xử lý exception khi đóng cũng có quy tắc. Nếu phần thân `try` đã ném exception rồi việc `close` cũng thất bại, exception ban đầu được giữ lại; lỗi khi đóng được lưu dưới dạng suppressed exception. Cách này tránh để lỗi dọn dẹp che mất lý do chính khiến thao tác thất bại.

## Bắt lỗi ở nơi có thể quyết định

Không phải `catch` exception ngay nơi nó xuất hiện. Method đọc file thường không biết nên yêu cầu người dùng chọn file khác, ghi log, hay dừng tác vụ. Hãy chuyển exception tới tầng hiểu đủ ngữ cảnh để quyết định. Ngược lại, đừng bắt rồi bỏ qua lỗi: chương trình có thể tiếp tục như thể thao tác đã thành công trong khi dữ liệu thực tế chưa được đọc.

## Kết luận

Dùng checked exception khi caller cần thấy và có thể phản ứng với khả năng thất bại; cân nhắc unchecked exception khi lỗi không có cách phục hồi hợp lý ở caller. Với resource như file reader, dùng try-with-resources để việc đóng được gắn với vòng đời của khối `try`, thay vì tự quản lý nhiều nhánh đóng trong `finally`.

## References

- [Chapter 11. Exceptions](https://docs.oracle.com/javase/specs/jls/se25/html/jls-11.html)
- [Unchecked Exceptions — The Controversy](https://docs.oracle.com/javase/tutorial/essential/exceptions/runtime.html)
- [The try-with-resources Statement](https://docs.oracle.com/javase/tutorial/essential/exceptions/tryResourceClose.html)

## Series

- Previous: [Generics trong Java: Type Safety, Wildcards và Cơ chế Type Erasure](../05-generics/index.md)
- Next: [Lambda Expressions và Functional Interfaces trong Java 8+](../07-lambda-and-functional-interfaces/index.md)
