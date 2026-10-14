---
title: "Thực hành Tổng hợp: Dựng Landing Page hoàn chỉnh từ con số 0"
description: "Kết nối các kiến thức HTML ngữ nghĩa, Box Model, Flexbox, CSS Grid và Mobile-First để xây dựng một trang Landing Page thực tế hoàn chỉnh."

date:
updated:

series: "HTML & CSS Basic"
series_order: 10

tags:
  - html
  - css
  - project
  - beginner

status: draft
language: vi
---

# Thực hành Tổng hợp: Dựng Landing Page hoàn chỉnh từ con số 0

Khi mới bắt đầu học lập trình web, bạn tiếp cận kiến thức theo từng mảnh ghép riêng biệt: học cách bọc nội dung trong thẻ HTML, khai báo màu sắc hay font chữ bằng CSS, dàn hàng phần tử với Flexbox và chia ma trận không gian bằng CSS Grid. 

Tuy nhiên, rào cản lớn nhất đối với hầu hết người học chính là khoảng trống khi phải **kết nối các mảnh ghép** này lại với nhau để dựng nên một trang web hoàn chỉnh từ một tệp tin trắng (`index.html`).

Bài viết thực hành tổng hợp này sẽ dẫn dắt bạn qua toàn bộ quy trình chuẩn mực trong thực tế: từ thiết lập tệp nguồn, reset CSS chuẩn Box Model, dựng khung HTML ngữ nghĩa (Semantic HTML), cho đến việc phối hợp nhịp nhàng giữa **Flexbox** (dành cho thanh điều hướng và form) với **CSS Grid** (dành cho lưới tính năng) dưới tư duy **Responsive Mobile-First**.

## Bước 1: Thiết lập tệp tin và Reset CSS với Box Model chuẩn

Mọi dự án web tiêu chuẩn đều bắt đầu bằng việc tạo tệp HTML chính có tên `index.html` cùng tệp kiểu dáng `style.css`.

Trong tệp `style.css`, công việc đầu tiên là viết đoạn mã reset CSS cơ bản. Mặc định, các trình duyệt thường áp dụng khoảng lề `margin` và `padding` riêng biệt cho một số thẻ, đồng thời tính toán kích thước phần tử theo mô hình `content-box`. Để đưa mọi phần tử về một quy chuẩn dự đoán được, chúng ta sử dụng bộ chọn toàn cục `*` để thiết lập `box-sizing: border-box` cùng việc triệt tiêu lề thừa:

```css
/* Reset CSS cơ bản và chuẩn hóa Box Model */
*, *::before, *::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: system-ui, -apple-system, sans-serif;
  line-height: 1.6;
  color: #334155;
  background-color: #ffffff;
}
```

Việc khai báo `box-sizing: border-box` đảm bảo rằng khi bạn đặt chiều rộng cho một hộp là `100%` hay `300px`, các khoảng đệm `padding` và đường viền `border` bổ sung sẽ được gói gọn bên trong kích thước đó mà không làm tràn hay vỡ khung giao diện.

## Bước 2: Dựng khung Semantic HTML có cấu trúc rõ ràng

Chúng ta dựng cấu trúc ngữ nghĩa cho trang Landing Page bên trong thẻ `<body>` với 4 khu vực chính: `<header>` chứa thanh điều hướng, `<main>` chứa nội dung chính (Hero banner, danh sách tính năng `<section>` và form nhận tin), cùng `<footer>` ở cuối trang:

```html
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Landing Page Thực hành - HTML & CSS Basic</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>

  <!-- Thanh đầu trang -->
  <header class="main-header">
    <a href="#" class="logo">WebMaster</a>
    <nav class="main-nav" aria-label="Điều hướng chính">
      <ul>
        <li><a href="#features">Tính năng</a></li>
        <li><a href="#subscribe">Đăng ký</a></li>
      </ul>
    </nav>
  </header>

  <!-- Nội dung chính -->
  <main>
    <!-- Section Hero Banner -->
    <section class="hero">
      <h1>Giải pháp Bố cục Web Hiện đại</h1>
      <p>Làm chủ HTML Ngữ nghĩa, CSS Flexbox và Grid qua dự án thực tế.</p>
    </section>

    <!-- Section Lưới Tính năng -->
    <section id="features" class="features">
      <h2>Tính năng Cốt lõi</h2>
      <div class="feature-grid">
        <article class="feature-card">
          <h3>Semantic HTML</h3>
          <p>Tăng cường khả năng tiếp cận (Accessibility) và chuẩn hóa SEO cho trang web.</p>
        </article>
        <article class="feature-card">
          <h3>CSS Flexbox</h3>
          <p>Căn chỉnh và phân bổ không gian 1 chiều linh hoạt theo hàng hoặc cột.</p>
        </article>
        <article class="feature-card">
          <h3>CSS Grid</h3>
          <p>Quy hoạch không gian ma trận 2 chiều mạnh mẽ cho toàn bộ layout trang.</p>
        </article>
      </div>
    </section>

    <!-- Section Form Đăng ký -->
    <section id="subscribe" class="subscribe">
      <h2>Nhận Bản tin Mới nhất</h2>
      <form class="subscribe-form" action="/subscribe" method="POST">
        <label for="email-input">Địa chỉ Email của bạn:</label>
        <input type="email" id="email-input" name="email" required placeholder="name@example.com">
        <button type="submit">Đăng ký ngay</button>
      </form>
    </section>
  </main>

  <!-- Chân trang -->
  <footer class="main-footer">
    <p>&copy; 2026 Series HTML & CSS Basic. Nền tảng vững chắc cho lập trình viên web.</p>
  </footer>

</body>
</html>
```

## Bước 3: Định kiểu Navigation linh hoạt với CSS Flexbox

Thanh điều hướng (`<header>`) là vị trí hoàn hảo cho Flexbox, vì các phần tử (logo và menu) cần được xếp theo chiều ngang (trục chính - Main Axis) và căn giữa theo trục đứng (trục phụ - Cross Axis).

```css
/* Navigation Bar với Flexbox */
.main-header {
  display: flex;
  justify-content: space-between; /* Đẩy Logo sang trái, Menu sang phải */
  align-items: center;            /* Căn giữa theo chiều dọc */
  padding: 1rem 2rem;
  background-color: #0f172a;
  color: #ffffff;
}

.main-header .logo {
  font-size: 1.5rem;
  font-weight: 700;
  color: #38bdf8;
  text-decoration: none;
}

.main-nav ul {
  display: flex;
  list-style: none;
  gap: 1.5rem; /* Khoảng cách đều giữa các mục menu */
}

.main-nav a {
  color: #f8fafc;
  text-decoration: none;
  font-weight: 500;
}

.main-nav a:hover {
  color: #38bdf8;
}
```

## Bước 4: Xây dựng Hero Banner và Lưới tính năng với CSS Grid

Khu vực Hero được căn giữa trực quan, trong khi danh sách thẻ tính năng (`.feature-grid`) được quản lý bằng CSS Grid với công thức tự động thích ứng màn hình:

```css
/* Hero Banner */
.hero {
  text-align: center;
  padding: 5rem 1.5rem;
  background-color: #f8fafc;
}

.hero h1 {
  font-size: 2.25rem;
  color: #0f172a;
  margin-bottom: 1rem;
}

/* Lưới Tính năng với CSS Grid */
.features {
  padding: 4rem 2rem;
  max-width: 1200px;
  margin: 0 auto;
}

.features h2 {
  text-align: center;
  margin-bottom: 2.5rem;
  font-size: 1.875rem;
}

.feature-grid {
  display: grid;
  /* Tự động tính toán số cột: tối thiểu 260px, tối đa co giãn 1fr */
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 1.5rem;
}

.feature-card {
  padding: 2rem;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  background-color: #ffffff;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.feature-card h3 {
  color: #0284c7;
  margin-bottom: 0.75rem;
}
```

## Bước 5: Thêm Form đăng ký với Validation nguyên bản

Phần tử `<form>` sử dụng `type="email"` và thuộc tính `required` để kích hoạt cơ chế Constraint Validation của trình duyệt mà không cần viết mã JavaScript:

```css
/* Form Đăng ký nhận bản tin */
.subscribe {
  padding: 4rem 1.5rem;
  background-color: #f1f5f9;
  text-align: center;
}

.subscribe-form {
  display: flex;
  flex-direction: column; /* Xếp chồng chiều dọc trên Mobile */
  align-items: center;
  gap: 1rem;
  max-width: 520px;
  margin: 1.5rem auto 0;
}

.subscribe-form label {
  font-weight: 600;
  color: #334155;
}

.subscribe-form input[type="email"] {
  width: 100%;
  padding: 0.75rem 1rem;
  border: 1px solid #cbd5e1;
  border-radius: 6px;
  font-size: 1rem;
}

.subscribe-form button {
  padding: 0.75rem 1.75rem;
  background-color: #0284c7;
  color: #ffffff;
  border: none;
  border-radius: 6px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
}

.subscribe-form button:hover {
  background-color: #0369a1;
}
```

## Bước 6: Tinh chỉnh Responsive theo tư duy Mobile-First

Toàn bộ mã trên đã hoạt động hoàn hảo trên điện thoại. Giờ đây, chúng ta chỉ cần dùng một khối Media Query duy nhất tại mốc 640px để chuyển form sang hàng ngang trên máy tính bảng và màn hình lớn:

```css
/* Tối ưu hóa từ màn hình Tablet trở lên (>= 640px) */
@media (min-width: 640px) {
  .hero h1 {
    font-size: 3rem;
  }

  .subscribe-form {
    flex-direction: row; /* Chuyển thành hàng ngang */
    justify-content: center;
  }

  .subscribe-form input[type="email"] {
    flex: 1; /* Ô email hấp thụ phần lớn chiều rộng */
  }
}

/* Footer */
.main-footer {
  text-align: center;
  padding: 2rem 1rem;
  background-color: #0f172a;
  color: #94a3b8;
  font-size: 0.875rem;
}
```

## Kết luận

Bằng cách hoàn thành trang Landing Page này, bạn đã kết nối thành công toàn bộ chuỗi kiến thức:
1. **Semantic HTML** tạo nên cấu trúc nội dung trong sáng, dễ đọc và thân thiện với SEO / Accessibility.
2. **Box Model chuẩn (`border-box`)** giải quyết triệt để lỗi vỡ layout do cộng dồn padding và border.
3. **Flexbox** xử lý linh hoạt thanh điều hướng và form nhập liệu 1 chiều.
4. **CSS Grid** điều phối lưới tính năng 2 chiều tự động co giãn.
5. **Mobile-First & Media Queries** đảm bảo trải nghiệm người dùng luôn tối ưu trên mọi kích thước màn hình.

Đây là nền tảng vững chắc nhất để bạn tự tin bước tiếp sang việc học JavaScript và các framework frontend hiện đại như Angular!

## References

- [The basics of HTML • W3C Wiki](https://www.w3.org/wiki/The_basics_of_HTML)
- [CSS Flexible Box Layout Module Level 1 • W3C](https://www.w3.org/TR/css-flexbox-1/)
- [CSS Grid Layout Module Level 1 • W3C](https://www.w3.org/TR/css-grid-1/)

## Series

Previous: [Responsive Web Design và Tư duy Mobile-First](../09-responsive-and-mobile-first/index.md)
