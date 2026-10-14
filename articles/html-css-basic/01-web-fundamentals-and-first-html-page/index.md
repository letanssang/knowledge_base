---
title: "Web hoạt động thế nào và Trang HTML đầu tiên"
description: "Khám phá cơ chế vận hành của HTML và Document Object Model (DOM): từ cách trình duyệt phân tích mã nguồn thành cây đối tượng đến các cạm bẫy kỹ thuật thường gặp khi thao tác Node."

date:
updated:

series: "HTML & CSS Basic"
series_order: 1

tags:
  - html
  - dom
  - web-development
  - beginner

status: draft
language: vi
---

# Web hoạt động thế nào và Trang HTML đầu tiên

Khi bắt đầu làm quen với lập trình web, đoạn mã HTML đầu tiên bạn viết thường bắt đầu bằng một tập tin văn bản có phần mở rộng `.html` rất đơn giản:

```html
<!doctype html>
<html lang="en-US">
  <head>
    <meta charset="utf-8" />
    <title>Trang web đầu tiên</title>
  </head>
  <body>
    <p>Chào mừng đến với <strong>trang web</strong> đầu tiên.</p>
  </body>
</html>
```

Nhìn vào tập tin này, nhiều người thường nghĩ HTML chỉ là một chuỗi văn bản được bao bọc bởi các cặp dấu ngoặc nhọn `<>`. Tuy nhiên, khi mở tập tin bằng trình duyệt, những dòng chữ thô ráp đó lập tức trở thành một giao diện hiển thị trực quan và có thể tương tác. 

Vấn đề cốt lõi nằm ở chỗ: trình duyệt không bao giờ thao tác trực tiếp trên tập tin văn bản tĩnh lưu trên ổ đĩa. Thay vào đó, nó phân tích cú pháp mã đánh dấu và chuyển đổi toàn bộ tài liệu thành một mô hình đối tượng động trong bộ nhớ có tên gọi là **Document Object Model (DOM)**.

## Bản chất của HTML và cách hình thành cây tài liệu

HTML (HyperText Markup Language) là ngôn ngữ đánh dấu dùng để cấu trúc hóa nội dung của trang web. Một phần tử HTML hoàn chỉnh thông thường được tạo thành từ:
- **Thẻ mở (Opening tag)**: Đánh dấu điểm bắt đầu của phần tử (ví dụ: `<p>`), có thể chứa thêm các thuộc tính (attributes) để cung cấp thông tin phụ trợ.
- **Nội dung (Content)**: Phần dữ liệu văn bản hoặc các phần tử lồng bên trong.
- **Thẻ đóng (Closing tag)**: Chứa dấu gạch chéo trước tên thẻ (ví dụ: `</p>`) để đánh dấu kết thúc phần tử.

Bên cạnh các phần tử thông thường, HTML còn có các phần tử rỗng (**void elements**) như `<img>`, `<meta>` hoặc `<br>`. Các phần tử này chỉ gồm một thẻ đơn lẻ và không chứa nội dung hay thẻ đóng.

Mỗi khi nạp tài liệu HTML, trình duyệt đọc các thẻ lồng nhau theo thứ tự phân cấp để dựng nên một cấu trúc dạng cây. Trong cây phân cấp này, phần tử `<html>` đóng vai trò là nút gốc (root element), bao bọc toàn bộ nội dung của trang và phân nhánh thành hai khối chức năng chính: `<head>` (chứa siêu dữ liệu không hiển thị trực tiếp) và `<body>` (chứa toàn bộ nội dung trực quan hiển thị cho người dùng).

Mô hình cấu trúc này có tính chất **đồng dạng cấu trúc (structural isomorphism)**: bất kỳ hai trình duyệt hoặc triển khai DOM nào tuân thủ tiêu chuẩn, khi phân tích cùng một tài liệu HTML hợp lệ, đều sẽ sinh ra cùng một cấu trúc cây thống nhất. Nếu người viết mã lồng thẻ sai quy tắc (chẳng hạn mở thẻ `<p>` rồi mở thẻ `<strong>`, nhưng lại đóng thẻ `</p>` trước `</strong>`), trình duyệt sẽ buộc phải tự đoán ý định của tác giả, dẫn đến việc dựng cây sai lệch và giao diện hiển thị bất thường.

## Cơ chế vận hành của DOM và tính độc lập ngôn ngữ

Document Object Model (DOM) không phải là một ngôn ngữ lập trình, cũng không phải một cấu trúc nhị phân đặc thù của riêng một hệ điều hành. W3C định nghĩa DOM là một giao diện lập trình ứng dụng (API) dành cho các tài liệu HTML hợp lệ và XML đúng chuẩn.

DOM được thiết kế theo tư duy hướng đối tượng truyền thống:
- Toàn bộ tài liệu được mô hình hóa thành các đối tượng đại diện (**Node**).
- Dữ liệu bên trong đối tượng được đóng gói và che giấu, chỉ cho phép truy cập hoặc thay đổi thông qua các phương thức và thuộc tính đã chuẩn hóa.

Để đảm bảo tính trung lập, giao diện của DOM được đặc tả bằng ngôn ngữ định nghĩa giao diện **OMG IDL** (Interface Definition Language). Trình duyệt đóng vai trò là môi trường thực thi lưu trữ (**host implementation**), cung cấp các liên kết ngôn ngữ (**language bindings**)—trong đó phổ biến nhất là ECMAScript (JavaScript).

Khi một đoạn mã script chạy trên trình duyệt thay đổi màu chữ hay thêm một đoạn văn mới, mã nguồn đó hoàn toàn không tác động lên tập tin `.html` gốc trên máy chủ hay ổ đĩa. Script đang đóng vai trò là ứng dụng máy khách (**client application**), gọi đến các phương thức của DOM API để cập nhật trực tiếp trạng thái của các đối tượng Node đang nằm trên bộ nhớ RAM của trình duyệt.

## Những cạm bẫy cơ chế thường gặp khi làm việc với DOM

Khi bắt đầu tương tác với cây tài liệu bằng mã lệnh, có ba cơ chế nội tại của DOM rất dễ gây nhầm lẫn:

### 1. Nút văn bản khoảng trắng (Whitespace Text Nodes)
Khi bạn xuống dòng hoặc thụt lề mã HTML cho đẹp mắt, trình duyệt vẫn tiếp nhận các ký tự khoảng trắng và ngắt dòng đó. Khi dựng cây DOM, các khoảng trắng này được biểu diễn dưới dạng các nút văn bản (`Text node`). Do đó, khi dùng thuộc tính `childNodes` để duyệt các nút con của một phần tử, bạn sẽ thấy số lượng nút thực tế nhiều hơn đáng kể so với số lượng thẻ HTML mà bạn đã khai báo.

### 2. Sự dịch chuyển chỉ số trong NodeList động
Phương thức truy vấn nút con thường trả về một danh sách `NodeList`. Trong mô hình MVC, cây tài liệu là **Model**, DOM API là **Controller**, còn `NodeList` đóng vai trò là một **View** phản ánh trạng thái của Model.

`NodeList` là một hình chiếu động: nó tự động cập nhật ngay khi cấu trúc cây thay đổi mà không cần người dùng truy vấn lại. Nếu bạn viết một vòng lặp tăng dần từ `0` đến `length - 1` để xóa các phần tử trong `NodeList`:
- Khi phần tử đầu tiên bị xóa khỏi cây, toàn bộ các phần tử phía sau sẽ lập tức trượt chỉ số sang trái (phần tử vị trí số 1 trở thành vị trí số 0).
- Vòng lặp tăng biến đếm lên 1, dẫn đến việc bỏ sót phần tử kế tiếp và làm sai lệch độ dài của danh sách.

Để thao tác an toàn khi xóa hàng loạt nút con, quy tắc kinh điển là duyệt vòng lặp ngược từ `length - 1` về `0`.

### 3. Ràng buộc sở hữu tài liệu với ownerDocument
Mỗi nút trong DOM luôn gắn liền với một tài liệu sở hữu duy nhất thông qua thuộc tính `ownerDocument`. Thuộc tính này được xác định vĩnh viễn ngay tại thời điểm nút được khởi tạo và không bao giờ bị gán lại.

Nếu bạn tạo một nút từ tài liệu này (hoặc từ một `iframe` khác) rồi dùng phương thức `appendChild` để gắn trực tiếp vào cây của một tài liệu khác, DOM sẽ ném ra ngoại lệ `WRONG_DOCUMENT_ERR` để bảo vệ tính toàn vẹn dữ liệu. Để sao chép hoặc chuyển giao nút giữa các tài liệu khác nhau một cách hợp lệ, lập trình viên bắt buộc phải sử dụng các phương thức chuyển giao chuẩn hóa như `importNode()` (tạo bản sao thuộc tài liệu mới) hoặc `adoptNode()` (chuyển quyền sở hữu sang tài liệu mới).

## Ứng dụng thực tế

Hiểu rõ sự khác biệt giữa văn bản đánh dấu HTML và mô hình đối tượng DOM là bước chuyển đổi tư duy then chốt của mọi lập trình viên web. 

HTML thuần túy là định dạng truyền tải dữ liệu qua mạng giữa máy chủ và trình duyệt. Nhưng một khi tài liệu đã được nạp, toàn bộ các hành vi tương tác, hiệu ứng hiển thị, cho đến cách các thư viện hay framework hiện đại như Angular quản lý giao diện, đều vận hành dựa trên việc thao tác và cập nhật cây đối tượng DOM. Nắm vững bản chất này giúp bạn viết mã đánh dấu chuẩn xác hơn, tránh được các lỗi vỡ layout khó lường và không bị bối rối trước các hành vi bất đồng bộ khi điều khiển giao diện bằng JavaScript.

## References

- [The basics of HTML • W3C Wiki](https://www.w3.org/wiki/The_basics_of_HTML)
- [What is the Document Object Model? • W3C](https://www.w3.org/TR/DOM-Level-2-Core/introduction.html)
- [Document Object Model FAQ • W3C](https://www.w3.org/DOM/faq.html)

## Series

Next: [Semantic HTML: Đừng chỉ dùng thẻ `<div>`](../02-semantic-html-and-structure/index.md)
