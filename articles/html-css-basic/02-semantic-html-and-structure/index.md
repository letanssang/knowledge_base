---
title: "Semantic HTML: Đừng chỉ dùng thẻ `<div>`"
description: "Tìm hiểu cơ chế vận hành của Semantic HTML, lý do nên từ bỏ 'div soup' và cách xây dựng cấu trúc trang web chuẩn mực cho SEO lẫn trợ năng."

date:
updated:

series: "HTML & CSS Basic"
series_order: 2

tags:
  - html
  - semantic-html
  - accessibility
  - beginner

status: draft
language: vi
---

# Semantic HTML: Đừng chỉ dùng thẻ `<div>`

Khi mở tệp mã nguồn của một trang web, bạn có thể dễ dàng bắt gặp một cấu trúc quen thuộc với hàng loạt thẻ `<div>` lồng ghép vào nhau:

```html
<div class="header">
  <div class="logo">My Site</div>
  <div class="nav">
    <div class="nav-item">Trang chủ</div>
    <div class="nav-item">Bài viết</div>
  </div>
</div>
<div class="main-content">
  <div class="article">
    <div class="title">Tiêu đề bài viết</div>
    <div class="body">Nội dung bài viết...</div>
  </div>
</div>
<div class="footer">
  <div class="copyright">© 2026 My Site</div>
</div>
```

Trên màn hình trình duyệt, sự kết hợp với CSS vẫn giúp giao diện hiển thị vô cùng đẹp mắt và gọn gàng. Tuy nhiên, đằng sau vẻ ngoài chỉn chu đó, trình duyệt, các cỗ máy tìm kiếm và trình đọc màn hình dành cho người khiếm thị lại chỉ nhìn thấy một mê cung thẻ vô danh—thường được gọi trong giới kỹ thuật là hiện tượng **"div soup"**.

Vấn đề trung tâm nằm ở chỗ: thẻ `<div>` chỉ là một phần tử chứa trung tính thuần túy, hoàn toàn không mang bất kỳ ý nghĩa ngữ nghĩa (semantics) nào về mặt nội dung. Khi toàn bộ cấu trúc trang bị phụ thuộc vào thẻ `<div>`, các công cụ tự động sẽ không thể phân biệt đâu là thanh điều hướng chính, đâu là phần bài viết quan trọng hay đâu chỉ là thông tin bản quyền ở chân trang. Việc hiểu rõ cơ chế của Semantic HTML chính là chìa khóa giúp chúng ta xây dựng những trang web vừa chuẩn mực về mặt kỹ thuật, vừa thân thiện với mọi đối tượng người dùng.

## Ý nghĩa ngữ nghĩa và cơ chế vận hành bên dưới

Mã HTML (HyperText Markup Language) về bản chất là một ngôn ngữ đánh dấu được dùng để bao bọc và xác định cấu trúc cho các thành phần nội dung trên trang web. Khi chúng ta bọc một đoạn văn bản vào thẻ thích hợp, chúng ta không chỉ yêu cầu trình duyệt hiển thị nội dung đó mà còn gán cho nó một vai trò chức năng cụ thể trong tài liệu. 

Một thẻ HTML chuẩn mực bao gồm thẻ mở, phần nội dung bên trong và thẻ đóng để phân định ranh giới phần tử. Bên cạnh đó, các thuộc tính mở rộng như `lang` hay `alt` cung cấp thêm thông tin bổ trợ vô cùng giá trị cho máy móc:

- Khi thẻ gốc `<html>` được khai báo thuộc tính ngôn ngữ `lang="vi"`, công cụ tổng hợp giọng nói (speech synthesis) và trình đọc màn hình (screen reader) sẽ biết chính xác bộ phát âm tiếng Việt cần áp dụng thay vì đọc bằng ngữ điệu tiếng Anh.
- Thuộc tính `alt` trong thẻ ảnh `<img>` giúp trình đọc màn hình diễn giải nội dung bức ảnh cho người khiếm thị, đồng thời giúp bot tìm kiếm hiểu được ngữ cảnh của hình ảnh.

Từng phần tử có ngữ nghĩa rõ ràng sẽ đóng vai trò làm cột mốc định vị cấu trúc, giúp các thiết bị tự động duyệt qua trang web một cách chính xác và hiệu quả.

## Chuyển đổi từ "div soup" sang cấu trúc Semantic HTML chuẩn mực

Để hình dung rõ sự khác biệt, hãy cùng theo dõi quá trình tái cấu trúc đoạn mã trên sang cấu trúc Semantic HTML chuẩn hóa:

```html
<header>
  <h1>My Site</h1>
  <nav aria-label="Điều hướng chính">
    <ul>
      <li><a href="/">Trang chủ</a></li>
      <li><a href="/articles">Bài viết</a></li>
    </ul>
  </nav>
</header>

<main>
  <article>
    <h2>Tiêu đề bài viết</h2>
    <p>Nội dung bài viết...</p>
  </article>
</main>

<footer>
  <p>© 2026 My Site</p>
</footer>
```

Trong cấu trúc ngữ nghĩa này:
- Thẻ `<header>` đại diện cho nhóm phần tử giới thiệu hoặc điều hướng mở đầu của trang web.
- Thẻ `<nav>` khoanh vùng các liên kết điều hướng chính, giúp trình đọc màn hình cung cấp phím tắt cho phép người dùng nhảy nhanh qua menu mà không cần đọc từng liên kết một.
- Thẻ `<main>` đánh dấu vùng nội dung trọng tâm và độc nhất của tài liệu. Mỗi trang web chỉ nên có một phần tử `<main>` hiển thị trực tiếp.
- Thẻ `<article>` bọc khối nội dung độc lập, có thể tự đứng vững và phát hành lại ở một nơi khác (như một bài báo, một bài đăng blog hay một bình luận của người dùng).
- Thẻ `<section>` đại diện cho một phân đoạn chuyên đề trong tài liệu, thường có tiêu đề riêng (`<h2>`–`<h6>`).
- Thẻ `<aside>` chứa thông tin phụ trợ, liên quan gián tiếp đến nội dung chính (như thanh bên sidebar, danh mục gợi ý, hoặc trích dẫn).
- Thẻ `<footer>` đánh dấu chân trang, chứa thông tin tác giả, bản quyền, liên kết điều khoản hoặc thông tin liên hệ.

## Cạm bẫy thường gặp khi áp dụng Semantic HTML

Mặc dù Semantic HTML mang lại lợi ích lớn về SEO và khả năng truy cập (accessibility), lập trình viên vẫn rất dễ mắc một số sai lầm:

### 1. Lạm dụng thẻ `<section>` và `<article>` để thay thế mọi `<div>`
Thẻ `<section>` không phải là một chiếc thẻ `<div>` cao cấp hơn. Chuẩn W3C quy định `<section>` là một phân đoạn theo chủ đề nội dung và thông thường cần có một thẻ tiêu đề đi kèm. Nếu một phần tử bọc bên ngoài chỉ đơn thuần đóng vai trò làm khung chứa để phục vụ việc căn chỉnh CSS, tạo khoảng cách hay dàn layout Flexbox, việc sử dụng thẻ `<div>` trung tính vẫn là giải pháp hoàn toàn chính xác.

### 2. Dùng sai phạm vi của `<main>`
Thẻ `<main>` không được dùng để chứa các thành phần lặp đi lặp lại xuyên suốt toàn bộ website như thanh menu chung, banner quảng cáo đầu trang hay chân trang bản quyền.

### 3. Nhảy cóc cấp độ tiêu đề (`<h1>`–`<h6>`)
Thứ tự các cấp độ tiêu đề phản ánh cây cấu trúc phác thảo (outline) của tài liệu. Việc chọn thẻ tiêu đề dựa trên kích thước font chữ (chẳng hạn dùng `<h4>` thay vì `<h2>` chỉ vì muốn chữ nhỏ hơn) sẽ phá vỡ cấu trúc tài liệu. Việc định dạng kích thước hiển thị thuộc về trách nhiệm của CSS.

## Ứng dụng thực tế

Semantic HTML không phải là lý thuyết khô khan, mà là tư duy tổ chức dữ liệu có cấu trúc. Việc lựa chọn đúng thẻ ngữ nghĩa ngay từ đầu giúp mã nguồn trong sáng, dễ đọc và dễ bảo trì hơn cho các thành viên trong nhóm phát triển. 

Quan trọng hơn, khi bạn bước sang học các framework như Angular, toàn bộ kiến trúc Component và Accessibility (ARIA landmarks) đều dựa trên nền tảng hiểu biết vững chắc về Semantic HTML.

## References

- [The basics of HTML • W3C Wiki](https://www.w3.org/wiki/The_basics_of_HTML)
- [HTML 5.2: Semantics, structure, and APIs of HTML documents • W3C](https://www.w3.org/TR/html52/semantics.html)

## Series

Previous: [Web hoạt động thế nào và Trang HTML đầu tiên](../01-web-fundamentals-and-first-html-page/index.md)
Next: [Thu thập Dữ liệu Người dùng với HTML Forms](../03-html-forms-and-validation/index.md)
