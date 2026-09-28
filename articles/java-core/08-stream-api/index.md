---
title: "Java Stream API: Xử lý dữ liệu tuần tự, Song song và Cơ chế Lazy Evaluation"
description: "Stream biến các bước lọc và chuyển đổi dữ liệu thành một pipeline dễ đọc. Bài viết giải thích khi nào pipeline chạy, vì sao không nên sửa state dùng chung và lúc nào nên cân nhắc parallel."

date:
updated:

series: "Java Core"
series_order: 8

tags:
  - java
  - stream-api
  - functional-programming
  - collections

status: draft
language: vi
---

# Java Stream API: Xử lý dữ liệu tuần tự, Song song và Cơ chế Lazy Evaluation

Khi lọc một danh sách bằng vòng lặp, thường phải tự tạo danh sách kết quả, kiểm tra từng phần tử rồi thêm phần tử đạt điều kiện. Với Stream, mình có thể viết các bước ấy nối tiếp nhau: lấy dữ liệu từ nguồn, lọc, chuyển đổi, rồi thu kết quả. Cách viết mới dễ theo dõi hơn khi mỗi bước làm một việc rõ ràng — miễn là hiểu lúc nào các bước thật sự chạy.

## Pipeline được mô tả trước, thực thi sau

```java
import java.util.List;
import java.util.stream.Stream;

class NameFilter {
    List<String> longNames() {
        return Stream.of("An", "Mai", "Minh")
            .filter(name -> name.length() > 2)
            .map(String::toUpperCase)
            .toList();
    }
}
```

`Stream.of` tạo nguồn dữ liệu. `filter` giữ lại tên dài hơn hai ký tự; `map` đổi từng tên sang chữ hoa. Hai bước này là intermediate operations: chúng mô tả pipeline và trả về stream tiếp theo, nhưng chưa cần duyệt dữ liệu ngay. `toList` là terminal operation; khi gọi nó, pipeline chạy và tạo danh sách kết quả.

Đó là lazy evaluation: Java trì hoãn việc thực thi intermediate operations cho tới khi có terminal operation. Nhờ vậy, Stream có thể nối các bước xử lý mà không cần tạo một collection trung gian sau mỗi bước. Sau terminal operation, stream đã được tiêu thụ; nếu muốn xử lý lại dữ liệu, hãy tạo stream mới từ nguồn.

Stream không phải collection thứ hai. Nó không chứa các phần tử theo cách `List` chứa dữ liệu; nó mô tả cách lấy phần tử từ một nguồn và đưa chúng qua các thao tác. Phân biệt hai vai trò này giúp tránh việc giữ một Stream như thể có thể đọc đi đọc lại.

## Parallel không phải nút tăng tốc miễn phí

Thông thường, gọi `stream()` tạo pipeline tuần tự. `parallelStream()` hoặc `parallel()` yêu cầu thư viện xử lý các phần tử song song. Việc chia công việc có thể có ích, nhưng còn phụ thuộc vào kích thước dữ liệu, chi phí mỗi thao tác và cách kết quả được gộp; vì vậy, parallel không đảm bảo chương trình nhanh hơn.

Pipeline an toàn hơn khi mỗi lambda xử lý phần tử của mình mà không sửa nguồn đang được duyệt hoặc ghi vào state mutable dùng chung. Nếu nhiều phần tử cùng thêm vào một `ArrayList` bên ngoài, các thao tác có thể đụng nhau khi chạy song song. Để Stream tự thu kết quả bằng `toList` hoặc `collect` thay vì tự quản lý danh sách dùng chung.

Với nguồn có thứ tự như `List`, một số thao tác giữ encounter order trong kết quả. Nhưng thứ tự lambda được thực thi trên các thread không nhất thiết giống thứ tự đầu vào; `forEach` cũng không hứa gọi action theo thứ tự đó. Nếu thứ tự side effect quan trọng, đừng dựa vào thời điểm một thread chạy trước thread khác.

## Kết luận

Khi đọc một pipeline, tìm terminal operation để biết lúc nào dữ liệu bắt đầu được xử lý và kết quả được tạo ở đâu. Dùng Stream để diễn đạt chuỗi biến đổi rõ ràng; tạo pipeline mới nếu cần duyệt nguồn lần nữa. Chỉ cân nhắc xử lý song song khi các phép tính độc lập và cách thu kết quả an toàn, rồi đo hiệu quả trong workload thực tế.

## References

- [java.util.stream (Java SE 25)](https://docs.oracle.com/en/java/javase/25/docs/api/java.base/java/util/stream/package-summary.html)
- [Lambda Expressions](https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html)

## Series

- Previous: [Lambda Expressions và Functional Interfaces trong Java 8+](../07-lambda-and-functional-interfaces/index.md)
