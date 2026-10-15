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

Trên màn hình trình duyệt, sự kết hợp với CSS vẫn giúp giao diện hiển thị vô cùng đẹp mắt và gọn gàng. Tuy nhiên, đằng sau vẻ ngoài chỉn chu đó, trình duyệt, các cỗ máy tìm kiếm (Googlebot) và trình đọc màn hình (Screen Reader cho người khiếm thị) lại chỉ nhìn thấy một mê cung thẻ vô danh—thường được gọi trong giới kỹ thuật là hiện tượng **"div soup"** (canh hẹ thẻ div).

Vấn đề cốt lõi nằm ở chỗ: thẻ `<div>` chỉ là một **khung chứa trung tính thuần túy**, hoàn toàn không mang bất kỳ ý nghĩa ngữ nghĩa (semantics) nào về mặt nội dung. Khi toàn bộ cấu trúc trang bị phụ thuộc vào thẻ `<div>`, các công cụ tự động sẽ không thể phân biệt đâu là thanh điều hướng chính, đâu là phần bài viết quan trọng hay đâu chỉ là thông tin bản quyền ở chân trang. 

Việc hiểu rõ cơ chế của **Semantic HTML** chính là chìa khóa giúp chúng ta xây dựng những trang web chuẩn mực về kỹ thuật, tối ưu SEO và thân thiện với khả năng tiếp cận (Accessibility - a11y).

---

## 1. Bản chất của Semantic HTML là gì?

HTML (HyperText Markup Language) không chỉ dùng để hiển thị chữ to chữ nhỏ. Khi bọc một đoạn văn bản vào một thẻ ngữ nghĩa thích hợp, bạn đang **gán cho nó một vai trò chức năng cụ thể trong tài liệu**:

* Thẻ `<p>` nói với máy móc: *"Đây là một đoạn văn bản thông thường."*
* Thẻ `<nav>` nói với máy móc: *"Đây là thanh điều hướng chính của trang."*
* Thẻ `<button>` nói với máy móc: *"Đây là nút bấm có thể nhấp chuột hoặc kích hoạt bằng phím Enter/Space."*

Ngoài tên thẻ, các thuộc tính mở rộng cũng mang lại giá trị rất lớn cho các công cụ tự động:
* `lang="vi"` trong thẻ `<html>`: Giúp công cụ tổng hợp giọng nói và trình đọc màn hình biết chính xác bộ phát âm tiếng Việt cần áp dụng thay vì đọc theo ngữ điệu tiếng Anh.
* `alt="Biểu đồ doanh thu quý 3"` trong thẻ `<img>`: Giúp người khiếm thị "nghe" được nội dung bức ảnh, đồng thời giúp bot tìm kiếm Google hiểu được ngữ cảnh hình ảnh để xếp hạng SEO.

---

## 2. Bố cục tổng thể của một trang web Semantic chuẩn mực

Dưới đây là sơ đồ "bộ xương" chuẩn hóa của một trang web hiện đại sử dụng Semantic HTML:

```text
┌────────────────────────────────────────────────────────────┐
│                        <header>                            │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                       <nav>                          │  │
│  │   [Trang chủ]   [Bài viết]   [Dịch vụ]   [Liên hệ]   │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────┘
┌───────────────────────────────────────────┬────────────────┐
│                  <main>                   │    <aside>     │
│                                           │                │
│  ┌─────────────────────────────────────┐  │  Thanh bên     │
│  │              <article>              │  │  (Sidebar)     │
│  │  <h1>Tiêu đề bài viết</h1>          │  │                │
│  │                                     │  │  • Tin tức phụ │
│  │  ┌───────────────────────────────┐  │  │  • Quảng cáo   │
│  │  │           <section>           │  │  │  • Tác giả     │
│  │  │  <h2>Phần 1: Giới thiệu</h2>  │  │  │                │
│  │  └───────────────────────────────┘  │  │                │
│  └─────────────────────────────────────┘  │                │
└───────────────────────────────────────────┴────────────────┘
┌────────────────────────────────────────────────────────────┐
│                        <footer>                            │
│  © 2026 Bản quyền thuộc về My Site • Điều khoản sử dụng    │
└────────────────────────────────────────────────────────────┘
```

### Chuyển đổi mã nguồn thực tế

Hãy so sánh đoạn mã "div soup" ở đầu bài khi được chuyển đổi sang mã ngữ nghĩa:

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

### Ý nghĩa của từng thẻ ngữ nghĩa cốt lõi:

* **`<header>`**: Đại diện cho nhóm phần tử mở đầu của trang web hoặc của một phân đoạn (thường chứa logo, thanh tìm kiếm hoặc tiêu đề bài viết).
* **`<nav>`**: Khoanh vùng các liên kết điều hướng quan trọng. Trình đọc màn hình sẽ cung cấp phím tắt cho người khiếm thị nhảy thẳng qua danh sách menu này mà không cần phải bấm nghe từng liên kết một.
* **`<main>`**: Đánh dấu vùng **nội dung trọng tâm và duy nhất** của tài liệu. Mỗi trang web chỉ nên có một phần tử `<main>` hiển thị trực tiếp.
* **`<article>`**: Bọc một khối nội dung **độc lập**, có thể tách rời và tái sử dụng ở nơi khác (như một bài báo, một bài đăng blog, hoặc một bình luận).
* **`<section>`**: Đại diện cho một **phân đoạn chuyên đề** trong tài liệu (thường cần có tiêu đề `<h2>`–`<h6>` đi kèm).
* **`<aside>`**: Chứa nội dung phụ trợ, liên quan gián tiếp đến nội dung chính (thanh bên sidebar, mục bài viết liên quan, quảng cáo).
* **`<footer>`**: Chân trang, chứa thông tin tác giả, bản quyền, liên kết điều khoản hoặc thông tin liên hệ.

---

## 3. Phân biệt kinh điển: `<article>` vs `<section>`

Rất nhiều lập trình viên băn khoăn khi nào nên dùng `<article>` và khi nào dùng `<section>`. Có một bài kiểm tra tư duy rất đơn giản:

> **Quy tắc trích xuất độc lập (The Syndication Test):**
> * Nếu bạn cắt khối nội dung đó ra và mang sang một trang web khác (hoặc đưa vào bảng tin RSS) mà **người đọc vẫn hiểu trọn vẹn ý nghĩa của nó** mà không cần đọc phần còn lại của trang $\rightarrow$ Dùng **`<article>`** (ví dụ: bài post Facebook, bài báo, card sản phẩm).
> * Nếu khối nội dung đó chỉ là **một phần, một chương hoặc một giai đoạn** trong tổng thể tài liệu $\rightarrow$ Dùng **`<section>`** (ví dụ: phần "Giới thiệu", phần "Bảng giá", phần "Liên hệ").

---

## 4. Ba cạm bẫy thường gặp khi áp dụng Semantic HTML

### Cạm bẫy 1: Cực đoan hóa — Lạm dụng `<section>` và `<article>` để thay thế mọi `<div>`
Thẻ `<section>` không phải là một chiếc thẻ `<div>` "cao cấp hơn". Chuẩn WHATWG quy định `<section>` là một phân đoạn theo chủ đề nội dung. 
* **Quy tắc đúng**: Nếu một phần tử bọc ngoài chỉ đơn thuần phục vụ mục đích dàn layout CSS (như tạo khung Flexbox, tạo khoảng cách margin/padding), việc sử dụng thẻ `<div>` trung tính là **hoàn toàn chính xác và khuyến khích**.

### Cạm bẫy 2: Dùng sai phạm vi của `<main>`
Thẻ `<main>` chỉ dành cho nội dung độc nhất của trang đó. Tuyệt đối không nhét các thành phần lặp đi lặp lại ở mọi trang (như thanh menu chung, banner quảng cáo đầu trang hay bản quyền chân trang) vào trong thẻ `<main>`.

### Cạm bẫy 3: Nhảy cóc cấp độ tiêu đề (`<h1>`–`<h6>`)
Thứ tự các cấp độ tiêu đề phản ánh cây phác thảo phân cấp (document outline) của tài liệu:
* Mỗi trang nên có duy nhất **một** thẻ `<h1>` đại diện cho chủ đề chính.
* Dưới `<h1>` là các `<h2>`, dưới `<h2>` là các `<h3>`.
* **Sai lầm phổ biến**: Chọn thẻ tiêu đề chỉ vì kích thước hiển thị mặc định (ví dụ: dùng `<h4>` thay vì `<h2>` chỉ vì muốn chữ nhỏ hơn). Kích thước hiển thị là việc của CSS; hãy chọn thẻ HTML dựa trên cấu trúc phân cấp nội dung.

---

## 5. Tổng kết

* **Semantic HTML** biến trang web từ một mớ ký tự vô danh thành một tài liệu có cấu trúc logic rõ ràng.
* Giúp tối ưu SEO tự nhiên (Google hiểu chính xác nội dung quan trọng) và hỗ trợ khả năng tiếp cận (Accessibility - a11y).
* Hãy dùng đúng vai trò: Dùng thẻ ngữ nghĩa cho cấu trúc nội dung, và dùng thẻ `<div>`/`<span>` trung tính cho việc căn chỉnh giao diện CSS.

---

## References

- [HTML Standard — Sections and Grouping Content • WHATWG](https://html.spec.whatwg.org/multipage/sections.html)
- [HTML elements reference • MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/HTML/Element)

---

## Series

- Previous: [Web hoạt động thế nào và Trang HTML đầu tiên](../01-web-fundamentals-and-first-html-page/index.md)
- [Thực hành](./practice.md)
- Next: [Thu thập Dữ liệu Người dùng với HTML Forms](../03-html-forms-and-validation/index.md)

