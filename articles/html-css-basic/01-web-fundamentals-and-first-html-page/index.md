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

Khi bắt đầu học lập trình web, bài tập đầu tiên của hầu hết mọi người là tạo một tập tin văn bản mang phần mở rộng `.html` với cấu trúc kinh điển:

```html
<!doctype html>
<html lang="vi">
  <head>
    <meta charset="utf-8" />
    <title>Trang web đầu tiên</title>
  </head>
  <body>
    <p>Chào mừng đến với <strong>trang web</strong> đầu tiên.</p>
  </body>
</html>
```

Chỉ cần lưu tập tin này lại và nhấp đúp để mở bằng trình duyệt (Chrome, Safari, Firefox), một giao diện trực quan lập tức xuất hiện. 

Nhiều người thường nghĩ HTML chỉ đơn giản là một chuỗi văn bản được bao bọc bởi các cặp dấu ngoặc nhọn `<>`. Tuy nhiên, ẩn bên dưới cú pháp đơn giản đó là một cỗ máy xử lý phức tạp: **trình duyệt không bao giờ thao tác trực tiếp trên tập tin `.html` tĩnh lưu trên ổ đĩa**. Thay vào đó, nó phân tích cú pháp (parse) mã đánh dấu và chuyển đổi toàn bộ tài liệu thành một mô hình đối tượng sống động trong bộ nhớ RAM có tên gọi là **Document Object Model (DOM)**.

---

## 1. Cấu tạo của một phần tử HTML

HTML (HyperText Markup Language) là ngôn ngữ đánh dấu dùng để cấu trúc hóa nội dung. Một phần tử HTML thông thường đóng vai trò như một "vỏ bọc" (container) gồm 3 thành phần:

* **Thẻ mở (Opening tag)**: Đánh dấu điểm bắt đầu (ví dụ: `<p>`), có thể chứa các thuộc tính (attributes) như `class`, `id`, `lang`.
* **Nội dung (Content)**: Phần dữ liệu văn bản hoặc các phần tử con lồng bên trong.
* **Thẻ đóng (Closing tag)**: Chứa dấu gạch chéo trước tên thẻ (ví dụ: `</p>`) để phân định điểm kết thúc.

```text
  Thẻ mở            Nội dung            Thẻ đóng
 ┌──────┐ ┌───────────────────────────┐ ┌──────┐
   <p>     Chào mừng đến với website!     </p>
 └─────────────────────────────────────────────┘
               Phần tử HTML (Element)
```

### Phần tử rỗng (Void Elements)
Không phải thẻ nào cũng cần có nội dung bao bọc. HTML định nghĩa một nhóm 13 phần tử đặc biệt gọi là **void elements** (như `<img>`, `<input>`, `<meta>`, `<link>`, `<br>`, `<hr>`):
* **Bản chất**: Chúng là các phần tử tự thân hoàn chỉnh (biểu diễn tài nguyên thay thế từ bên ngoài hoặc đánh dấu vị trí), content model của chúng là rỗng (`Nothing`).
* **Quy tắc**: Chúng **không có thẻ đóng** (nghiêm cấm viết `<img></img>`).
* **Cạm bẫy cần tránh**: Tránh nhầm lẫn void element với thẻ bình thường đang để trống (`<div></div>`). Nếu bạn viết `<div />` với hy vọng nó tự đóng, HTML parser sẽ bỏ qua dấu `/` và coi đó là thẻ mở `<div>`, nuốt toàn bộ các phần tử phía sau vào trong nó.

---

## 2. Từ mã HTML thành Cây DOM trong bộ nhớ

Khi tải một tập tin HTML, trình duyệt đọc mã từ trên xuống dưới và dựng nên một cấu trúc phân cấp dạng cây (Tree):

```text
Tập tin index.html (Chuỗi ký tự tĩnh trên đĩa)
                   │
                   ▼ (Trình duyệt phân tích cú pháp - HTML Parser)
       CÂY ĐỐI TƯỢNG DOM (Nằm trong RAM)
                   │
                Document
                   │
                 <html> (Root Element)
             ┌─────┴─────┐
             │           │
          <head>       <body>
             │           │
          <title>       <p>
             │         ┌─┴─────────┐
          "Trang..."  "Chào..." <strong>
                                   │
                              "trang web"
```

Trong cây phân cấp này:
1. `<html>` đóng vai trò là **nút gốc (Root element)**, phân nhánh thành `<head>` (chứa siêu dữ liệu cấu hình) và `<body>` (chứa nội dung hiển thị).
2. Mỗi thẻ HTML trở thành một **Element Node**, còn phần chữ bên trong trở thành một **Text Node**.
3. **Tính đồng dạng cấu trúc (Structural Isomorphism)**: Bất kỳ trình duyệt nào tuân thủ tiêu chuẩn W3C/WHATWG, khi nạp cùng một tài liệu HTML hợp lệ, đều sẽ sinh ra một cấu trúc cây đối tượng thống nhất trong bộ nhớ.

---

## 3. DOM là gì và JavaScript tương tác như thế nào?

> **Tập tin HTML là bản thiết kế tĩnh. Cây DOM là công trình thực tế đang hoạt động trong RAM.**

Document Object Model (DOM) là một **giao diện lập trình ứng dụng (API)**. Khi một đoạn mã JavaScript thay đổi màu nền hay thêm một nút bấm, mã nguồn đó **hoàn toàn không chạm vào tập tin `.html` gốc** trên máy chủ hay ổ đĩa. JavaScript đang đóng vai trò là ứng dụng máy khách, gọi các phương thức của DOM API để cập nhật trực tiếp trạng thái của các đối tượng Node đang nằm trên bộ nhớ RAM.

```javascript
// Thử nghiệm ngay trong Console (F12):
// Lệnh này không sửa file HTML, nó chỉ thay đổi đối tượng document trong RAM:
document.body.style.backgroundColor = "#f0fdf4";
```

> [!NOTE]
> ### Góc chuyên sâu: Web IDL và Tính độc lập ngôn ngữ
> DOM không thuộc riêng về JavaScript. Để đảm bảo tính trung lập, W3C và WHATWG đặc tả giao diện của DOM bằng ngôn ngữ **Web IDL** (trước đây là OMG IDL). Các kỹ sư phát triển trình duyệt hiện thực hóa giao diện này bằng C++ (trong Chromium, WebKit) hoặc Rust (trong Servo/Gecko), sau đó cung cấp các cổng liên kết ngôn ngữ (**language bindings**) cho JavaScript. Khi bạn truy cập `document.getElementById()`, JavaScript Engine đang gọi xuyên qua lớp liên kết để giao tiếp với các đối tượng C++ bên dưới.

---

## 4. Ba cạm bẫy cơ chế kinh điển khi thao tác DOM

Khi bắt đầu điều khiển cây tài liệu bằng mã lệnh, có ba cơ chế nội tại rất dễ gây ra lỗi tiềm ẩn (bugs) nếu bạn không nắm vững cách DOM vận hành:

### Cạm bẫy 1: Nút văn bản khoảng trắng (Whitespace Text Nodes)

Khi bạn định dạng mã nguồn HTML bằng các phím xuống dòng (Enter) hoặc thụt lề (Tab) cho đẹp mắt, trình duyệt vẫn tiếp nhận các ký tự khoảng trắng đó. Khi dựng DOM, chúng được biểu diễn dưới dạng các nút văn bản (`Text node`).

Xét đoạn mã sau:
```html
<ul id="menu">
  <li>Trang chủ</li>
  <li>Bài viết</li>
</ul>
```

Nếu bạn dùng thuộc tính `childNodes` để đếm số lượng nút con của `#menu`:
```javascript
const menu = document.getElementById("menu");
console.log(menu.childNodes.length); // Kết quả in ra là 5, không phải 2!
```
* **Lý do**: Danh sách con gồm: `[Text (xuống dòng), li, Text (xuống dòng), li, Text (xuống dòng)]`.
* **Giải pháp**: Nếu chỉ muốn lấy các thẻ phần tử thực tế (bỏ qua khoảng trắng), hãy sử dụng thuộc tính `children`:
  ```javascript
  console.log(menu.children.length); // Trả về đúng 2 thẻ <li>
  ```

---

### Cạm bẫy 2: Sự dịch chuyển chỉ số trong Live NodeList

Một số phương thức truy vấn nút con (như `element.childNodes` hay `getElementsByTagName`) trả về một danh sách có tên là **`NodeList` động (Live NodeList)**.

`NodeList` động hoạt động như một "hình chiếu trực tiếp" vào bộ nhớ RAM: nó tự động cập nhật ngay khi cấu trúc cây thay đổi. Điều này dẫn đến lỗi kinh điển khi xóa phần tử:

```javascript
const items = container.childNodes; // Live NodeList

// LỖI: Vòng lặp xuôi sẽ bị xóa sót một nửa số phần tử!
for (let i = 0; i < items.length; i++) {
  container.removeChild(items[i]);
}
```

* **Cơ chế gây lỗi**: Khi phần tử tại vị trí `0` bị xóa, phần tử tại vị trí `1` lập tức trượt chỉ số sang trái trở thành vị trí `0`. Vòng lặp tăng biến đếm lên `i = 1`, vô tình nhảy cóc qua phần tử vừa bị trượt sang.
* **Giải pháp chuẩn mực**:
  1. **Duyệt ngược từ cuối về đầu**:
     ```javascript
     for (let i = items.length - 1; i >= 0; i--) {
       container.removeChild(items[i]);
     }
     ```
  2. **Hoặc chuyển đổi thành Mảng tĩnh**: Sử dụng cú pháp Spread `[...items]` để tách rời khỏi cơ chế live của DOM trước khi thao tác.

*(Lưu ý: Phương thức phổ biến `document.querySelectorAll()` trả về một **Static NodeList** — danh sách chụp ảnh tĩnh tại thời điểm gọi lệnh, nên không gặp phải hiện tượng trượt chỉ số tự động này).*

---

### Cạm bẫy 3: Ràng buộc sở hữu tài liệu (`ownerDocument`) và Cơ chế tự động Adopt

Mỗi nút trong DOM luôn gắn liền với một tài liệu sở hữu duy nhất thông qua thuộc tính chỉ đọc `ownerDocument`, được xác lập ngay tại thời điểm nút được tạo ra.

Nếu bạn lấy một phần tử từ một tài liệu khác (ví dụ từ một khung nhúng `<iframe>` hoặc tài liệu XML):

```javascript
const iframeDoc = document.querySelector("iframe").contentDocument;
const externalNode = iframeDoc.querySelector(".badge");

// Gắn nút của iframe vào tài liệu chính:
document.body.appendChild(externalNode);
```

> [!NOTE]
> ### Sự khác biệt giữa DOM cũ và DOM hiện đại
> * **Trong chuẩn cũ (W3C DOM Level 2 - năm 2000):** Hành động trên sẽ lập tức ném ra ngoại lệ `WRONG_DOCUMENT_ERR` vì DOM ngày xưa nghiêm cấm việc đưa một Node chưa đổi quyền sở hữu vào tài liệu mới.
> * **Trong chuẩn hiện đại (WHATWG DOM Living Standard):** Thuật toán chèn (`insert` algorithm) của trình duyệt hiện nay đã **tự động gọi bước `adopt`** ngầm. Trình duyệt tự chuyển `ownerDocument` của `externalNode` sang tài liệu mới mà không ném lỗi nữa!

#### Vậy cạm bẫy thực tế hiện nay là gì? (Di chuyển vs Sao chép)
Vì `appendChild()` tự động thực hiện thao tác `adopt`, nó sẽ **bứng phần tử đó ra khỏi tài liệu cũ** (tức là nút `.badge` trong `iframe` sẽ lập tức biến mất).

* **Nếu bạn muốn DI CHUYỂN hẳn nút sang trang mới**: Bạn có thể gọi trực tiếp `document.body.appendChild(externalNode)` (hoặc tường minh bằng `document.adoptNode(externalNode)`).
* **Nếu bạn muốn GIỮ NGUYÊN nút gốc và chỉ lấy một bản copy sang trang mới**: Bạn bắt buộc phải dùng **`document.importNode(externalNode, true)`** để tạo ra một bản sao độc lập (clone) thuộc về tài liệu hiện tại (đây cũng là kỹ thuật bắt buộc khi làm việc với thẻ `<template>`).


---

## 5. Tổng kết

* **HTML**: Ngôn ngữ đánh dấu dùng để truyền tải cấu trúc văn bản qua mạng.
* **DOM**: Cây đối tượng sống trong RAM được trình duyệt dựng nên từ HTML, đóng vai trò là cầu nối duy nhất để JavaScript tương tác với giao diện.
* **Tư duy cốt lõi**: Mọi thao tác hiển thị, hoạt ảnh và quản lý trạng thái của các framework hiện đại (React, Angular) thực chất đều là các bài toán tìm cách thao tác và tối ưu hóa trên cây DOM.

---

## References

- [HTML Standard — Living Standard • WHATWG](https://html.spec.whatwg.org/)
- [DOM Standard — Living Standard • WHATWG](https://dom.spec.whatwg.org/)
- [Document Object Model (DOM) • MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model)

---

## Series

- [Thực hành](./practice.md)
- Next: [Semantic HTML: Đừng chỉ dùng thẻ `<div>`](../02-semantic-html-and-structure/index.md)

