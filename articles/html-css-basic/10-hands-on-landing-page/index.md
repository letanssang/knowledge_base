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

Khi mới bắt đầu học lập trình web, bạn tiếp cận kiến thức theo từng mảnh ghép riêng biệt: học cách bọc chữ trong thẻ HTML, đổi màu và font chữ bằng CSS, dàn hàng bằng Flexbox và chia ma trận không gian bằng CSS Grid. 

Tuy nhiên, rào cản lớn nhất đối với hầu hết người mới chính là: **Làm sao để kết nối tất cả các mảnh ghép đó lại với nhau để tạo ra một trang web hoàn chỉnh từ con số 0?**

Trong bài thực hành này, chúng ta sẽ cùng nhau "nhúng tay vào code", tự tay dựng nên một trang **Landing Page hiện đại, chuẩn SEO, responsive mượt mà** từ một file trắng tinh (`index.html`) và (`style.css`).

---

## 1. Bản vẽ thiết kế (Wireframe) của trang Landing Page

Trước khi gõ bất kỳ dòng code nào, hãy quan sát bản thiết kế tổng thể để hiểu rõ chiến lược phân chia công cụ:

```text
┌────────────────────────────────────────────────────────────┐
│ [Logo WebMaster]                   [Tính năng] [Đăng ký]   │ ◄── HEADER (Dùng Flexbox)
└────────────────────────────────────────────────────────────┘
┌────────────────────────────────────────────────────────────┐
│                Giải pháp Bố cục Web Hiện đại               │
│      Làm chủ HTML Ngữ nghĩa, CSS Flexbox và Grid...        │ ◄── HERO BANNER (Căn giữa)
└────────────────────────────────────────────────────────────┘
┌────────────────────────────────────────────────────────────┐
│                    TÍNH NĂNG CỐT LÕI                       │
│  ┌────────────────┐   ┌────────────────┐   ┌────────────┐  │
│  │ Semantic HTML  │   │ CSS Flexbox    │   │ CSS Grid   │  │ ◄── FEATURES (Dùng CSS Grid)
│  └────────────────┘   └────────────────┘   └────────────┘  │    Tự co giãn 1 -> 2 -> 3 cột
└────────────────────────────────────────────────────────────┘
┌────────────────────────────────────────────────────────────┐
│                   Nhận Bản tin Mới nhất                    │
│   [  Nhập địa chỉ email của bạn...  ]  [ Đăng ký ngay ]    │ ◄── FORM (Flexbox Mobile-First)
└────────────────────────────────────────────────────────────┘
┌────────────────────────────────────────────────────────────┐
│      © 2026 Series HTML & CSS Basic. Nền tảng vững chắc    │ ◄── FOOTER
└────────────────────────────────────────────────────────────┘
```

> **Chiến lược lựa chọn công cụ:**
> * **Header / Navbar**: Dùng **Flexbox** (bố cục 1 chiều, đẩy logo sang trái, menu sang phải).
> * **Lưới Tính năng (Features)**: Dùng **CSS Grid** (bố cục 2 chiều, tự động co giãn số cột theo màn hình).
> * **Form Đăng ký**: Dùng **Flexbox** (trên điện thoại xếp chồng dọc, trên máy tính xếp hàng ngang).

---

## 2. Bước 1: Khởi tạo dự án & Dựng khung HTML chuẩn mực

Hãy tạo một thư mục mới trên máy tính (ví dụ `landing-page`), bên trong tạo 2 tệp:
1. `index.html`
2. `style.css`

Mở file `index.html` và dán toàn bộ đoạn mã HTML ngữ nghĩa chuẩn W3C sau:

```html
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8">
  <!-- Thẻ Viewport bắt buộc để kích hoạt Responsive -->
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Landing Page Hiện đại - HTML & CSS Basic</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>

  <!-- 1. Thanh điều hướng đầu trang -->
  <header class="main-header">
    <a href="#" class="logo">WebMaster</a>
    <nav class="main-nav" aria-label="Điều hướng chính">
      <ul>
        <li><a href="#features">Tính năng</a></li>
        <li><a href="#subscribe">Đăng ký</a></li>
      </ul>
    </nav>
  </header>

  <!-- 2. Vùng nội dung chính -->
  <main>
    <!-- Hero Banner -->
    <section class="hero">
      <h1>Giải pháp Bố cục Web Hiện đại</h1>
      <p>Làm chủ HTML Ngữ nghĩa, CSS Flexbox và CSS Grid qua dự án thực tế.</p>
    </section>

    <!-- Lưới Tính năng cốt lõi -->
    <section id="features" class="features">
      <h2>Tính năng Cốt lõi</h2>
      <div class="feature-grid">
        <article class="feature-card">
          <h3>Semantic HTML</h3>
          <p>Tăng cường khả năng tiếp cận (Accessibility) và tối ưu hóa chuẩn SEO tự nhiên.</p>
        </article>
        <article class="feature-card">
          <h3>CSS Flexbox</h3>
          <p>Căn chỉnh và phân bổ không gian 1 chiều linh hoạt theo hàng ngang hoặc cột dọc.</p>
        </article>
        <article class="feature-card">
          <h3>CSS Grid</h3>
          <p>Quy hoạch không gian ma trận 2 chiều mạnh mẽ cho toàn bộ bố cục trang web.</p>
        </article>
      </div>
    </section>

    <!-- Form Nhận bản tin -->
    <section id="subscribe" class="subscribe">
      <h2>Nhận Bản tin Mới nhất</h2>
      <form class="subscribe-form" action="/subscribe" method="POST">
        <label for="email-input">Địa chỉ Email của bạn:</label>
        <input 
          type="email" 
          id="email-input" 
          name="email" 
          required 
          placeholder="name@example.com"
        />
        <button type="submit">Đăng ký ngay</button>
      </form>
    </section>
  </main>

  <!-- 3. Chân trang -->
  <footer class="main-footer">
    <p>&copy; 2026 Series HTML & CSS Basic. Nền tảng vững chắc cho lập trình viên web.</p>
  </footer>

</body>
</html>
```

---

## 3. Bước 2: Viết mã kiểu dáng trong `style.css`

Mở file `style.css` và viết mã theo từng lớp chức năng:

### A. Reset CSS & Chuẩn hóa Box Model
```css
/* Triệt tiêu lề mặc định và chuẩn hóa border-box */
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

### B. Header linh hoạt với CSS Flexbox
```css
.main-header {
  display: flex;
  justify-content: space-between; /* Đẩy Logo sang trái, Menu sang phải */
  align-items: center;            /* Căn giữa theo chiều dọc */
  padding: 1rem 2rem;
  background-color: #0f172a;
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
  gap: 1.5rem; /* Khoảng cách đều giữa các link menu */
}

.main-nav a {
  color: #f8fafc;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.2s ease;
}

.main-nav a:hover {
  color: #38bdf8;
}
```

### C. Hero Banner & Lưới tính năng với CSS Grid
```css
/* Hero Banner */
.hero {
  text-align: center;
  padding: 4rem 1.5rem;
  background-color: #f8fafc;
}

.hero h1 {
  font-size: 2.25rem;
  color: #0f172a;
  margin-bottom: 1rem;
}

/* Lưới Tính năng tự động co giãn */
.features {
  padding: 4rem 2rem;
  max-width: 1200px;
  margin: 0 auto; /* Căn giữa toàn bộ khối vào giữa trang */
}

.features h2 {
  text-align: center;
  margin-bottom: 2.5rem;
  font-size: 1.875rem;
}

.feature-grid {
  display: grid;
  /* Cú pháp tự động thích ứng: Tối thiểu 260px, tối đa 1fr */
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 1.5rem;
}

.feature-card {
  padding: 2rem;
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  background-color: #ffffff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.feature-card h3 {
  color: #0284c7;
  margin-bottom: 0.75rem;
}
```

### D. Form Đăng ký và Chân trang (Tư duy Mobile-First)
```css
/* Mặc định cho Mobile: Form xếp theo chiều dọc */
.subscribe {
  padding: 4rem 1.5rem;
  background-color: #f1f5f9;
  text-align: center;
}

.subscribe-form {
  display: flex;
  flex-direction: column; /* Xếp dọc trên điện thoại */
  gap: 1rem;
  max-width: 500px;
  margin: 1.5rem auto 0;
}

.subscribe-form input[type="email"] {
  padding: 0.75rem 1rem;
  border: 1px solid #cbd5e1;
  border-radius: 6px;
  font-size: 1rem;
}

.subscribe-form button {
  padding: 0.75rem 1.5rem;
  background-color: #0284c7;
  color: #ffffff;
  border: none;
  border-radius: 6px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.subscribe-form button:hover {
  background-color: #0369a1;
}

/* Footer */
.main-footer {
  text-align: center;
  padding: 2rem 1rem;
  background-color: #0f172a;
  color: #94a3b8;
  font-size: 0.875rem;
}

/* NÂNG CẤP LÊN MÁY TÍNH BẢNG & DESKTOP (>= 640px) */
@media (min-width: 640px) {
  .hero h1 {
    font-size: 3rem;
  }

  .subscribe-form {
    flex-direction: row; /* Chuyển form thành hàng ngang */
    align-items: center;
  }

  .subscribe-form input[type="email"] {
    flex: 1; /* Ô input tự động hút trọn khoảng trống còn lại */
  }
}
```

---

## 4. Tự kiểm tra thành quả trên máy tính của bạn

1. Hãy nhấp đúp vào tệp `index.html` để mở trên trình duyệt.
2. Nhấn phím `F12` (hoặc chuột phải $\rightarrow$ **Inspect**) để mở Developer Tools.
3. Nhấp vào biểu tượng điện thoại (**Toggle Device Toolbar**) và thử đổi qua lại giữa màn hình **iPhone 14 (390px)**, **iPad (768px)** và **Desktop**:
   * Bạn sẽ thấy thanh điều hướng, lưới 3 card và form đăng ký co giãn, nhảy hàng một cách mượt mà và tự nhiên!

---

## 5. Tổng kết toàn bộ Series HTML & CSS Basic

Chúc mừng bạn đã hoàn thành trọn vẹn series **HTML & CSS Basic**! Nhìn lại hành trình, bạn đã trang bị được những nền tảng vững chắc nhất:

1. **Bản chất của Web & DOM**: Hiểu rõ HTML trên đĩa chuyển thành cây đối tượng DOM trong RAM ra sao.
2. **Semantic HTML**: Biết cách xây dựng trang web có cấu trúc chuẩn mực cho SEO và người khiếm thị.
3. **HTML Forms**: Làm chủ quy trình đóng gói dữ liệu và cơ chế kiểm tra hợp lệ nguyên bản.
4. **CSS Box Model & Specificity**: Chấm dứt hoàn toàn nỗi lo vỡ layout bằng `border-box` và hiểu sâu về Margin Collapsing.
5. **CSS Typography & HSL**: Sử dụng đơn vị tương đối `rem` và hệ màu sắc khoa học.
6. **CSS Positioning**: Kiểm soát không gian tuyệt đối và ngữ cảnh xếp chồng `z-index`.
7. **CSS Flexbox & CSS Grid**: Phối hợp linh hoạt giữa bố cục 1 chiều và 2 chiều.
8. **Responsive & Mobile-First**: Tư duy xây dựng giao diện tương thích mọi kích thước màn hình.

Với nền tảng tư duy vững vàng này, bạn đã hoàn toàn sẵn sàng và tự tin để bước sang giai đoạn tiếp theo: **Chinh phục JavaScript và các Frontend Framework hiện đại như Angular!**

---

## References

- [HTML Standard — Living Standard • WHATWG](https://html.spec.whatwg.org/)
- [CSS Flexible Box Layout Module Level 1 • W3C](https://www.w3.org/TR/css-flexbox-1/)
- [CSS Grid Layout Module Level 1 • W3C](https://www.w3.org/TR/css-grid-1/)

---

## Series

Previous: [Responsive Web Design và Tư duy Mobile-First](../09-responsive-and-mobile-first/index.md)
