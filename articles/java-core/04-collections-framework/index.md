---
title: "Java Collections Framework: Phân tích kiến trúc List, Set, Map và Queue"
description: "Chọn collection bắt đầu từ cách chương trình cần dùng dữ liệu. Bài viết đi từ List, Set, Map đến ArrayList, LinkedList và HashMap bằng một ví dụ quản lý công việc."

date:
updated:

series: "Java Core"
series_order: 4

tags:
  - java
  - collections
  - data-structures
  - hashmap

status: draft
language: vi
---

# Java Collections Framework: Phân tích kiến trúc List, Set, Map và Queue

Một bảng việc cần làm thường phải giải quyết hai nhu cầu khác nhau: hiển thị các việc theo thứ tự, và tìm nhanh một việc khi biết mã của nó. Nếu cố dùng một cấu trúc dữ liệu cho cả hai nhu cầu, code sẽ khó đọc hoặc phải tự viết thêm logic tra cứu.

Java Collections Framework cung cấp các interface để mô tả cách mình muốn làm việc với dữ liệu, cùng những class cụ thể để lưu trữ và truy cập dữ liệu đó. Bắt đầu từ nhu cầu giúp chọn đúng cấu trúc dễ hơn là học thuộc danh sách class.

## Chọn cách biểu diễn trước khi chọn class

Nếu cần một dãy phần tử có thứ tự và có thể lặp lại phần tử, `List` phù hợp. Nếu cần một tập hợp không chứa phần tử trùng, dùng `Set`. Còn khi cần tra một giá trị bằng khóa — ví dụ mã công việc để tìm nội dung — `Map` lưu cặp key/value.

`Queue` dành cho các phần tử đang chờ được xử lý. Nhiều queue hoạt động theo kiểu vào trước, xử lý trước, nhưng interface không bắt buộc mọi implementation phải dùng đúng một thứ tự. Vì vậy, hãy dựa vào hợp đồng cụ thể của queue mình chọn.

Khác biệt giữa interface và implementation cũng đáng giữ trong code. Khai báo biến bằng `List<String>` nói rằng nơi này cần làm việc với một danh sách chuỗi; `ArrayList` là một lựa chọn lưu trữ cụ thể. Nếu sau này cách lưu thay đổi, phần code dựa vào các thao tác của `List` có thể ít phải sửa hơn.

## ArrayList và LinkedList: khác biệt nằm ở cách truy cập

`ArrayList` dùng mảng có thể tăng kích thước. Đọc hoặc thay phần tử theo chỉ số nhanh; thêm phần tử ở cuối thường nhanh, dù đôi khi phải tăng kích thước mảng. Tính qua nhiều lần thêm, thao tác thêm cuối có chi phí trung bình thấp. Vì thế đây thường là lựa chọn dễ bắt đầu khi cần một `List` thông thường.

`LinkedList` lưu các node nối với nhau theo hai chiều. Nếu đã đứng ở đúng vị trí, thao tác với node kề bên thuận tiện; nhưng tìm phần tử theo chỉ số phải đi dọc danh sách. Điều đó có nghĩa là đổi `ArrayList` sang `LinkedList` không tự làm thao tác chèn ở một chỉ số bất kỳ nhanh hơn — chương trình vẫn cần tìm tới vị trí ấy trước.

Hãy chọn theo thao tác chương trình thực sự làm nhiều nhất. Nếu thường xuyên đọc bằng chỉ số hoặc duyệt danh sách, `ArrayList` thường là điểm bắt đầu hợp lý. Chỉ chọn `LinkedList` khi các thao tác ở đầu/cuối hoặc qua iterator phù hợp với cách chương trình truy cập dữ liệu.

## HashMap dành cho bài toán tra cứu bằng khóa

Để tìm công việc theo mã, `HashMap<Integer, String>` ánh xạ key sang value. `put` thêm hoặc thay một mapping; `get` tìm value theo key. Với cách phân tán hash phù hợp, các thao tác này thường có thời gian kỳ vọng ổn định, nhưng `HashMap` không hứa thứ tự khi duyệt các phần tử.

Điểm cuối này quan trọng khi hiển thị dữ liệu: nếu thứ tự là một phần của yêu cầu, đừng dựa vào thứ tự tình cờ của `HashMap`. Hãy chọn cấu trúc có hợp đồng thứ tự phù hợp hoặc giữ danh sách riêng cho phần cần hiển thị.

`HashMap` cũng không tự đồng bộ khi nhiều thread cùng thay đổi nó. Nếu nhiều luồng có thể ghi đồng thời, cần chọn cách đồng bộ phù hợp thay vì nghĩ rằng mọi collection đều thread-safe sẵn. Nhưng trong ứng dụng một luồng, không cần thêm đồng bộ chỉ vì đang dùng collection.

## Kết luận

Hãy bắt đầu bằng câu hỏi dữ liệu cần được dùng thế nào: theo thứ tự, không trùng, theo key hay theo hàng chờ. Sau đó chọn implementation dựa trên thao tác chính — truy cập theo chỉ số, duyệt, thêm/xóa hay tra cứu — và yêu cầu về thứ tự hoặc đồng bộ. Interface giúp phần code thể hiện nhu cầu; implementation đáp ứng nhu cầu ấy bằng một cách lưu cụ thể.

## References

- [Introduction to Collections](https://docs.oracle.com/javase/tutorial/collections/intro/index.html)
- [Collection Interfaces](https://docs.oracle.com/javase/tutorial/collections/interfaces/index.html)
- [ArrayList (Java SE 25)](https://docs.oracle.com/en/java/javase/25/docs/api/java.base/java/util/ArrayList.html)
- [LinkedList (Java SE 25)](https://docs.oracle.com/en/java/javase/25/docs/api/java.base/java/util/LinkedList.html)
- [HashMap (Java SE 25)](https://docs.oracle.com/en/java/javase/25/docs/api/java.base/java/util/HashMap.html)

## Series

- Previous: [Phân biệt Interface và Abstract Class: Bản chất, Khác biệt và Cách thiết kế](../03-interface-and-abstract-class/index.md)
- Next: [Generics trong Java: Type Safety, Wildcards và Cơ chế Type Erasure](../05-generics/index.md)
