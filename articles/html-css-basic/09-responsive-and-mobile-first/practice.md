[Lý thuyết](./index.md)

Trong bài thực hành này, bạn sẽ áp dụng chiến lược **Mobile-First** và các cú pháp tiên tiến từ chuẩn **W3C Media Queries Level 4** để xây dựng giao diện đáp ứng (Responsive Web Design) cho trang **Lịch trình hội thảo công nghệ TechConf 2026**:
1. **Khắc phục lỗi thiếu Viewport Meta Tag**: Kiểm chứng hiện tượng thu nhỏ giả lập 980px trên DevTools Device Mode và kích hoạt chế độ hiển thị 1:1 chuẩn xác.
2. **Xây dựng CSS nền tảng Mobile-First**: Định kiểu mặc định cho điện thoại di động (< 768px) với luồng 1 cột duy nhất, menu dạng cột dễ thao tác cảm ứng với touch target $\ge 44\text{px}$.
3. **Mở rộng lên Tablet Breakpoint (`width >= 768px`)**: Chuyển menu điều hướng sang hàng ngang và dàn danh sách thẻ phiên hội thảo thành 2 cột bằng CSS Grid. So sánh cú pháp truyền thống `min-width` với cú pháp **Range Syntax** mới của Media Queries Level 4.
4. **Mở rộng lên Desktop Breakpoint (`width >= 1024px`)**: Tách bố cục tổng thể thành 2 cột lớn (Main Content & Sidebar) và nâng danh sách thẻ lên 3 cột, giới hạn chiều rộng tối đa `1200px` căn giữa trang.
5. **Đào sâu bản chất Cascade & Specificity**: Phân tích vì sao Mobile-First triệt tiêu hoàn toàn nhu cầu viết mã ghi đè (reset styles), và chứng minh vì sao Media Query không làm tăng Specificity của selector.

---

## Mục tiêu và Tiêu chí hoàn thành

### Mục tiêu học tập
- **Bản chất của Viewport Meta Tag**: Hiểu vì sao thiếu thẻ viewport trình duyệt sẽ giả lập màn hình desktop 980px và thu nhỏ giao diện.
- **Tư duy Mobile-First**: Nắm vững phương pháp thiết kế từ quy mô nhỏ nhất (điện thoại) rồi nâng cấp dần lên màn hình lớn bằng `@media (min-width: ...)` hoặc `@media (width >= ...)`.
- **Cú pháp Range Syntax (W3C Media Queries Level 4)**: Sử dụng thành thạo các toán tử so sánh toán học `>=`, `<=`, `>`, `<` thay cho cú pháp tiền tố `min-`, `max-` truyền thống.
- **Cơ chế Cascade và Specificity**: Nắm rõ quy tắc thứ tự khai báo (source order) trong CSS khi làm việc với Media Queries.

### Tiêu chí hoàn thành
1. Mở file ban đầu trên DevTools Responsive Mode, ghi nhận lỗi co nhỏ giao diện khi chưa có thẻ viewport. Sau đó thêm `<meta name="viewport" content="width=device-width, initial-scale=1.0">` và xác nhận chiều rộng hiển thị khớp chính xác với kích thước màn hình thiết bị (ví dụ 390px).
2. Xây dựng CSS nền tảng Mobile-First nằm ngoài Media Query: danh sách thẻ hiển thị 1 cột, menu điều hướng xếp dọc, các liên kết có chiều cao bấm tối thiểu 44px.
3. Thêm truy vấn Media Query cho Tablet (`width >= 768px`): menu chuyển thành hàng ngang, danh sách thẻ chuyển sang 2 cột (`repeat(2, 1fr)`).
4. Thêm truy vấn Media Query cho Desktop (`width >= 1024px`): toàn trang chia 2 cột (Main và Sidebar) bằng Grid, danh sách thẻ mở rộng thành 3 cột, khung trang giới hạn `max-width: 1200px` căn giữa.
5. Kiểm tra khả năng co giãn liên tục từ 320px đến 1440px trên DevTools mà không xuất hiện bất kỳ thanh cuộn ngang (horizontal scrollbar) ngoài ý muốn nào.

---

## Chuẩn bị môi trường và file mẫu

File mẫu HTML khởi đầu đã được tạo sẵn tại [assets/practice/starter.html](./assets/practice/starter.html).

Mã nguồn file `assets/practice/starter.html`:

```html
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <!-- Nhiệm vụ 1: Bạn sẽ thêm Viewport Meta Tag vào đây -->
  <title>Lịch trình TechConf 2026</title>
  <style>
    /* TODO: Viết CSS thực hành theo các nhiệm vụ trong practice.md */
  </style>
</head>
<body>

  <header class="site-header">
    <div class="container header-container">
      <h1 class="logo">TechConf 2026</h1>
      <nav>
        <ul class="nav-menu">
          <li><a href="#about">Giới thiệu</a></li>
          <li><a href="#schedule">Lịch trình</a></li>
          <li><a href="#speakers">Diễn giả</a></li>
          <li><a href="#contact">Liên hệ</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <div class="container page-layout">
    <main class="main-content">
      <h2>Danh sách phiên hội thảo</h2>
      <div class="cards-grid">
        <article class="card">
          <span class="badge">09:00 - 10:00</span>
          <h3>Khai mạc & Keynote: Tương lai AI 2026</h3>
          <p>Diễn giả: Dr. Sarah Chen - Khám phá các xu hướng trí tuệ nhân tạo mới nhất.</p>
        </article>

        <article class="card">
          <span class="badge">10:15 - 11:30</span>
          <h3>CSS Modern Layouts & Web Standards</h3>
          <p>Diễn giả: Alex Rivera - Thiết kế giao diện hiện đại với CSS Grid & Subgrid.</p>
        </article>

        <article class="card">
          <span class="badge">13:00 - 14:15</span>
          <h3>Xây dựng Web Performance tối ưu</h3>
          <p>Diễn giả: Minh Tran - Tối ưu hóa Core Web Vitals cho ứng dụng lớn.</p>
        </article>

        <article class="card">
          <span class="badge">14:30 - 15:45</span>
          <h3>Bảo mật ứng dụng Web hiện đại</h3>
          <p>Diễn giả: Elena Rostova - Phòng chống các lỗ hổng bảo mật phổ biến.</p>
        </article>

        <article class="card">
          <span class="badge">16:00 - 17:00</span>
          <h3>Bàn tròn thảo luận: Web 2027 & Tương lai</h3>
          <p>Hội thảo mở cùng các chuyên gia hàng đầu ngành công nghệ.</p>
        </article>
      </div>
    </main>

    <aside class="sidebar">
      <h3>Thông tin hội thảo</h3>
      <p><strong>Địa điểm:</strong> Trung tâm Hội nghị Quốc tế</p>
      <p><strong>Thời gian:</strong> 20/11/2026</p>
      <div class="widget">
        <h4>Sponsor chính</h4>
        <p>TechCorp, CloudSystem, WebStandard</p>
      </div>
    </aside>
  </div>

</body>
</html>
```

---

## Nhiệm vụ 1: Thử nghiệm và khắc phục lỗi thiếu Viewport Meta Tag

### Các bước thực hiện
1. Mở file `starter.html` trên trình duyệt Chrome/Firefox/Edge.
2. Mở Developer Tools (`F12` hoặc chuột phải $\rightarrow$ **Inspect**).
3. Bật chế độ giả lập thiết bị (**Toggle Device Toolbar** - biểu tượng điện thoại) và chọn một thiết bị di động (ví dụ: **iPhone 14 với độ rộng 390px**).
4. **Quan sát hiện tượng**: Dù cửa sổ giả lập chỉ rộng 390px, trình duyệt vẫn giả định trang web có kích thước máy tính bàn ảo là **980px** và ép nhỏ toàn bộ giao diện lại để vừa khít màn hình. Kết quả là chữ và các nút bấm bị thu nhỏ li ti, người dùng bắt buộc phải dùng 2 ngón tay phóng to mới có thể đọc được.
5. **Khắc phục**: Thêm thẻ Viewport Meta Tag vào bên trong phần tử `<head>` của `starter.html`:

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

### Cơ chế kỹ thuật
* **`width=device-width`**: Hướng dẫn trình duyệt di động đặt chiều rộng khung nhìn (viewport) bằng đúng số điểm ảnh CSS thực tế của màn hình thiết bị (ở ví dụ trên là 390px), chấm dứt hoàn toàn cơ chế giả lập 980px.
* **`initial-scale=1.0`**: Thiết lập tỷ lệ hiển thị ban đầu là 1:1, ngăn không cho trình duyệt tự ý thu nhỏ hay phóng to nội dung khi tải trang.

---

## Nhiệm vụ 2: Xây dựng CSS nền tảng Mobile-First cho Điện thoại (< 768px)

### Mục tiêu
Xây dựng toàn bộ kiểu dáng mặc định cho màn hình nhỏ nhất. Tất cả các quy tắc này nằm **ngoài** mọi câu lệnh `@media`.

### Hướng dẫn thực hiện
Thêm đoạn CSS sau vào thẻ `<style>` của trang:

```css
/* ==========================================
   1. BASE & MOBILE-FIRST STYLES (< 768px)
   ========================================== */
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  line-height: 1.5;
  color: #1e293b;
  background-color: #f8fafc;
  padding-bottom: 2rem;
}

.container {
  width: 100%;
  padding-left: 1rem;
  padding-right: 1rem;
}

/* Header & Mobile Navigation */
.site-header {
  background-color: #0f172a;
  color: #fff;
  padding: 1rem 0;
  margin-bottom: 1.5rem;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.logo {
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 1rem;
  text-align: center;
  color: #38bdf8;
}

/* Menu xếp dạng cột đứng trên Mobile, Touch Target >= 44px */
.nav-menu {
  list-style: none;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.nav-menu a {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 44px; /* Chuẩn Touch Target tối thiểu 44px theo WCAG */
  padding: 0.5rem 1rem;
  color: #f1f5f9;
  text-decoration: none;
  background-color: #1e293b;
  border-radius: 6px;
  font-weight: 500;
  transition: background-color 0.2s ease;
}

.nav-menu a:hover {
  background-color: #0284c7;
  color: #fff;
}

/* Page Layout trên Mobile (1 cột đứng) */
.page-layout {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.main-content h2 {
  font-size: 1.25rem;
  margin-bottom: 1rem;
  color: #0f172a;
}

/* Cards Grid trên Mobile (1 cột duy nhất) */
.cards-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1rem;
}

.card {
  background: #ffffff;
  padding: 1.25rem;
  border-radius: 8px;
  border: 1px solid #e2e8f0;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.badge {
  display: inline-block;
  background-color: #e0f2fe;
  color: #0369a1;
  font-size: 0.8rem;
  font-weight: 700;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  margin-bottom: 0.5rem;
}

.card h3 {
  font-size: 1.1rem;
  margin-bottom: 0.5rem;
  color: #0f172a;
}

.card p {
  font-size: 0.925rem;
  color: #475569;
}

/* Sidebar styling */
.sidebar {
  background-color: #ffffff;
  padding: 1.25rem;
  border-radius: 8px;
  border: 1px solid #e2e8f0;
}

.sidebar h3 {
  font-size: 1.1rem;
  margin-bottom: 0.75rem;
  color: #0f172a;
}

.sidebar p {
  font-size: 0.9rem;
  color: #334155;
  margin-bottom: 0.5rem;
}

.widget {
  margin-top: 1rem;
  padding-top: 1rem;
  border-top: 1px solid #e2e8f0;
}

.widget h4 {
  font-size: 0.95rem;
  color: #0f172a;
  margin-bottom: 0.25rem;
}
```

---

## Nhiệm vụ 3: Mở rộng Bố cục cho Tablet với Cú pháp Media Queries Level 4

### Mục tiêu
Khi độ rộng màn hình đạt kích thước máy tính bảng (`>= 768px`), chuyển menu sang hàng ngang và chia danh sách thẻ thành 2 cột đều nhau.

### So sánh cú pháp Level 3 vs Level 4
* **Cú pháp truyền thống (Level 3)**: `@media (min-width: 768px) { ... }`
* **Cú pháp Range Syntax (Media Queries Level 4)**: `@media (width >= 768px) { ... }`

Theo đặc tả W3C Media Queries Level 4 §2.4, tính năng **Range Context** cho phép dùng trực tiếp các toán tử so sánh toán học (`>`, `>=`, `<`, `<=`). Cú pháp `(width >= 768px)` hoàn toàn tương đương với `(min-width: 768px)` nhưng trực quan hơn, loại bỏ sự nhầm lẫn giữa giá trị bao gồm và không bao gồm của tiền tố `min-`.

### Hướng dẫn thực hiện
Thêm khối truy vấn sau vào cuối tệp CSS:

```css
/* ============================================================
   2. TABLET BREAKPOINT (width >= 768px) - Level 4 Range Syntax
   ============================================================ */
@media (width >= 768px) {
  .header-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .logo {
    margin-bottom: 0;
    text-align: left;
  }

  /* Chuyển Menu điều hướng sang hàng ngang */
  .nav-menu {
    flex-direction: row;
    gap: 0.75rem;
  }

  .nav-menu a {
    background-color: transparent;
    padding: 0.5rem 0.85rem;
  }

  .nav-menu a:hover {
    background-color: #1e293b;
  }

  /* Bố cục danh sách thẻ chuyển sang 2 cột bằng CSS Grid */
  .cards-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}
```

---

## Nhiệm vụ 4: Mở rộng Bố cục cho Desktop (width >= 1024px)

### Mục tiêu
Khi độ rộng màn hình đạt chuẩn máy tính (`>= 1024px`), tách toàn bộ trang thành 2 cột (Main và Sidebar) và mở rộng danh sách thẻ lên 3 cột.

### Hướng dẫn thực hiện
Thêm tiếp khối CSS sau vào cuối file:

```css
/* =============================================================
   3. DESKTOP BREAKPOINT (width >= 1024px) - Level 4 Range Syntax
   ============================================================= */
@media (width >= 1024px) {
  .container {
    max-width: 1200px;
    margin: 0 auto;
  }

  /* Phân chia Layout toàn trang thành 2 cột chính */
  .page-layout {
    display: grid;
    grid-template-columns: 2.8fr 1fr;
    gap: 2rem;
    align-items: start;
  }

  /* Danh sách thẻ mở rộng lên 3 cột */
  .cards-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}
```

---

## Nhiệm vụ 5 (Thử nghiệm & Đào sâu): Phân tích Tư duy Mobile-First và Specificity trong Media Queries

### 1. Vì sao tư duy Mobile-First (`min-width` / `>=`) vượt trội hơn Desktop-First (`max-width` / `<=`)?
* **Loại bỏ hoàn toàn quy tắc Reset (CSS Overrides)**:
  * Trong chiến lược **Mobile-First**, bạn viết các thuộc tính đơn giản nhất cho điện thoại. Khi màn hình mở rộng lên tablet hay desktop, bạn chỉ cần **bổ sung thêm** số cột (`grid-template-columns: repeat(3, 1fr)`).
  * Ngược lại, nếu làm theo kiểu **Desktop-First**, bạn phải viết CSS phức tạp cho desktop trước, sau đó ở màn hình điện thoại phải viết hàng loạt lệnh để **xóa bỏ hoặc gỡ lại kiểu dáng** (ví dụ: chuyển `display: grid` về `block`, hủy `float`, reset lại `width: 100%`, đè lại margin âm,...), khiến file CSS phình to gấp đôi và rất khó bảo trì.
* **Tối ưu tốc độ tải và xử lý cho thiết bị di động**:
  * Trình duyệt điện thoại chỉ cần nạp và áp dụng ngay các dòng CSS đầu tiên ngoài media query mà không phải tốn chu kỳ CPU để parse và ghi đè các khối desktop phức tạp.

### 2. Sự thật về Specificity (Độ ưu tiên) của Media Queries
Một hiểu lầm rất tai hại của người mới học là cho rằng các quy tắc CSS viết trong `@media` có độ ưu tiên cao hơn mã nằm ngoài `@media`.

**Quy tắc chuẩn W3C**:
* Khối `@media` **KHÔNG** làm tăng Specificity của bất kỳ selector nào bên trong nó.
* Độ ưu tiên của một khai báo phụ thuộc hoàn toàn vào cấu trúc selector (Class, ID, Element,...).
* Do đó, **thứ tự xuất hiện trong file CSS (Source Order / Cascade Order)** là yếu tố quyết định khi hai selector có Specificity bằng nhau. Nếu bạn đặt khối Mobile-First ở dưới cùng sau các khối `@media (width >= 768px)`, các quy tắc cơ bản của Mobile sẽ ghi đè và làm vô hiệu hóa toàn bộ kiểu dáng của Tablet/Desktop. Đây là lý do vì sao trong quy trình chuẩn, các câu lệnh `@media` mở rộng kích thước **luôn phải đặt ở cuối tệp CSS**.

---

## Bảng tổng hợp Cú pháp Media Query chuẩn W3C Media Queries Level 4

Dưới đây là bảng đối chiếu giữa cú pháp truyền thống (Level 3) và cú pháp **Range Syntax** mới từ W3C Media Queries Level 4:

| Mục tiêu truy vấn | Cú pháp Truyền thống (Level 3) | Cú pháp Level 4 (Range Syntax) | Ý nghĩa kỹ thuật theo chuẩn W3C |
| :--- | :--- | :--- | :--- |
| Màn hình từ `768px` trở lên | `@media (min-width: 768px)` | `@media (width >= 768px)` | Tiền tố `min-` tương đương với toán tử `>=`. |
| Màn hình từ `480px` trở xuống | `@media (max-width: 480px)` | `@media (width <= 480px)` | Tiền tố `max-` tương đương với toán tử `<=`. |
| Màn hình trong khoảng `768px` đến `1024px` | `@media (min-width: 768px) and (max-width: 1024px)` | `@media (768px <= width <= 1024px)` | Cú pháp kẹp khoảng (range syntax) trực quan, gọn hơn 50%. |
| Màn hình lớn hơn hẳn `400px` và nhỏ hơn `700px` | Khó biểu diễn chính xác (thường phải dùng số lẻ `400.01px`) | `@media (400px < width < 700px)` | Sử dụng toán tử nghiêm ngặt `<` và `>`, loại bỏ lỗi trùng ranh giới trên màn hình độ phân giải cao. |
| Kết hợp điều kiện logic | `@media (min-width: 768px) and (orientation: landscape)` | `@media (width >= 768px) and (orientation: landscape)` | Hỗ trợ đầy đủ các toán tử Boole `and`, `or`, `not`. |

---

## References

* [W3C Media Queries Level 4 Specification](https://www.w3.org/TR/mediaqueries-4/)
* [WHATWG HTML Living Standard - Document Metadata and Viewport](https://html.spec.whatwg.org/multipage/semantics.html)
