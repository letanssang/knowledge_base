---
title: "Bố cục 2 Chiều Toàn diện với CSS Grid"
description: "Khám phá cơ chế hoạt động 2 chiều của CSS Grid Layout, ranh giới ứng dụng với Flexbox và cách dựng các bố cục web phức tạp một cách mạch lạc."

date:
updated:

series: "HTML & CSS Basic"
series_order: 8

tags:
  - css
  - grid
  - layout
  - beginner

status: draft
language: vi
---

# Bố cục 2 Chiều Toàn diện với CSS Grid

Nếu Flexbox là "ông hoàng" của bố cục 1 chiều (hoặc một hàng ngang, hoặc một cột dọc), thì **CSS Grid Layout** chính là "vị thần tối cao" điều khiển không gian **2 chiều (đồng thời cả Hàng và Cột)**.

Trước khi CSS Grid xuất hiện, để dựng một giao diện Dashboard phức tạp (gồm Header, Sidebar bên trái, nội dung ở giữa và Footer bên dưới), lập trình viên phải lồng ghép hàng chục tầng thẻ `<div>` Flexbox vào nhau. CSS Grid ra đời giải quyết triệt để bài toán này: bạn có thể định hình toàn bộ ma trận bố cục của trang web chỉ trong vài dòng CSS ngắn gọn, trực quan và dễ hiểu như vẽ tranh!

---

## 1. Flexbox vs CSS Grid: Khi nào dùng cái nào?

Rất nhiều người học bị hoang mang: *"Đã có Flexbox rồi thì tại sao phải học Grid? Chúng có triệt tiêu lẫn nhau không?"*.

Câu trả lời là: **Không! Chúng là một cặp đôi hoàn hảo bổ trợ cho nhau.**

```text
┌───────────────────────────────────────┬───────────────────────────────────────┐
│              CSS FLEXBOX              │               CSS GRID                │
├───────────────────────────────────────┼───────────────────────────────────────┤
│ • Bố cục 1 Chiều (1-Dimensional)      │ • Bố cục 2 Chiều (2-Dimensional)      │
│ • Hoặc hàng ngang, hoặc cột dọc       │ • Quản lý đồng thời cả Hàng & Cột     │
│ • Phù hợp: Menu, Cụm nút, Danh sách   │ • Phù hợp: Khung layout cả trang web, │
│   thẻ co giãn, căn giữa nút bấm       │   Lưới ảnh, Bảng dữ liệu, Dashboard   │
└───────────────────────────────────────┴───────────────────────────────────────┘
```

> **Quy tắc vàng của Senior:** 
> * **Dùng CSS Grid** để dựng **"bộ khung xương tổng thể"** của trang web (Header, Sidebar, Main, Footer).
> * **Dùng Flexbox** để dàn xếp **"các chi tiết nội thất nhỏ bên trong từng khối"** (như căn giữa icon trong nút, xếp các link menu).

---

## 2. Giải mã thuật ngữ hình học của CSS Grid

Để không bị bối rối khi đọc tài liệu, bạn chỉ cần nắm chắc 4 khái niệm hình học sau:

```text
       Cột 1 (Track)       Cột 2 (Track)
       Line 1             Line 2             Line 3
         │                  │                  │
         ▼                  ▼                  ▼
Line 1 ──┌──────────────────┬──────────────────┐
         │                  │                  │
Hàng 1   │  Grid Cell       │                  │
(Track)  │  (Một ô đơn lẻ)  │                  │
         │                  │                  │
Line 2 ──┼──────────────────┼──────────────────┤
         │                  │                  │
Hàng 2   │                  │  Grid Area       │
(Track)  │                  │  (Vùng nhiều ô)  │
         │                  │                  │
Line 3 ──┴──────────────────┴──────────────────┘
```

1. **Grid Lines (Đường kẻ lưới)**: Các đường kẻ vô hình chia cột và hàng, được đánh số từ `1` ở mép ngoài cùng sang phải và từ trên xuống dưới.
2. **Grid Track (Tuyến lưới)**: Khoảng không gian giữa 2 đường kẻ song song kề nhau $\rightarrow$ Chính là một **Hàng (Row)** hoặc một **Cột (Column)**.
3. **Grid Cell (Ô lưới)**: Giao điểm của 1 hàng và 1 cột (như 1 ô trong bảng Excel).
4. **Grid Area (Vùng lưới)**: Một diện tích hình chữ nhật gồm nhiều ô lưới gộp lại.

---

## 3. Các thuộc tính cốt lõi và Đơn vị phân số thần thánh `fr`

Để kích hoạt Grid trên thẻ cha:
```css
.container {
  display: grid;
  grid-template-columns: 200px 1fr 2fr; /* Định nghĩa 3 cột */
  grid-template-rows: auto 1fr auto;    /* Định nghĩa 3 hàng */
  gap: 20px;                            /* Khoảng cách giữa các ô */
}
```

### Đơn vị `fr` (Fraction Unit) là gì?
`fr` đại diện cho **1 phần tỷ lệ của khoảng trống còn thừa** sau khi đã trừ đi các cột cố định bằng `px`:

```text
               Tổng chiều rộng màn hình: 1100px
├─────────────────────────────────────────────────────────────────┤
[ Cột 1: cố định 200px ][ Cột 2 (1fr): 300px ][ Cột 3 (2fr): 600px ]
                          ▲                    ▲
                          └─ Còn dư 900px, chia thành 3 phần (1fr + 2fr)
                             1fr = 300px, 2fr = 600px
```

### Hai hàm tiện ích cực mạnh: `repeat()` và `minmax()`
* **`repeat(3, 1fr)`**: Viết tắt của `1fr 1fr 1fr` (chia đều 3 cột).
* **`minmax(200px, 1fr)`**: Đặt kích thước co giãn thông minh: bình thường co giãn linh hoạt (`1fr`), nhưng khi màn hình co nhỏ thì không bao giờ được phép nhỏ hơn `200px`.

---

## 4. Tuyệt chiêu 1: Vẽ bố cục trang web bằng chữ với `grid-template-areas`

Đây là tính năng độc nhất vô nhị chỉ có ở CSS Grid: bạn có thể nhìn thấy cả giao diện trang web hiện ra ngay trong đoạn code CSS của mình!

```html
<div class="site-layout">
  <header class="header">Header</header>
  <aside class="sidebar">Sidebar</aside>
  <main class="main">Nội dung chính</main>
  <footer class="footer">Footer</footer>
</div>
```

```css
.site-layout {
  display: grid;
  /* VẼ BỐ CỤC TRỰC QUAN BẰNG CHỮ: */
  grid-template-areas:
    "head head"   /* Hàng 1: Header chiếm trọn cả 2 cột */
    "side main"   /* Hàng 2: Cột trái là Sidebar, cột phải là Main */
    "foot foot";  /* Hàng 3: Footer chiếm trọn cả 2 cột */
  grid-template-columns: 240px 1fr;
  grid-template-rows: auto 1fr auto;
  min-height: 100vh;
  gap: 16px;
}

/* Đặt tên khu vực cho từng thẻ con: */
.header  { grid-area: head; }
.sidebar { grid-area: side; }
.main    { grid-area: main; }
.footer  { grid-area: foot; }
```

Nhìn vào đoạn mã trên, một người chưa biết lập trình cũng có thể hình dung ngay cấu trúc của trang web. Bạn không cần phải lồng ghép bất kỳ chiếc thẻ `<div>` bọc ngoài nào!

---

## 5. Tuyệt chiêu 2: Lưới Card tự động Responsive không cần viết Media Query

Đây là dòng code "thần thánh" được copy nhiều nhất trong thế giới CSS hiện đại để làm danh sách sản phẩm hay thư viện ảnh:

```css
.product-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 20px;
}
```

```text
Màn hình máy tính to  (1200px):  Tự động chia thành 4 cột đều nhau [A][B][C][D]
Màn hình máy tính bảng (768px):  Tự động co về thành 2 cột đều nhau [A][B]
                                                                     [C][D]
Màn hình điện thoại     (360px):  Tự động co về thành 1 cột duy nhất [A]
                                                                     [B]
```

### Cơ chế hoạt động:
* `minmax(280px, 1fr)`: Mỗi chiếc Card sản phẩm rộng tối thiểu `280px`.
* `auto-fit`: Trình duyệt tự đếm xem bề ngang màn hình hiện tại nhét vừa tối đa bao nhiêu cột. Khi màn hình bị bóp hẹp không còn đủ chỗ cho thẻ mới, thẻ đó tự động rớt xuống hàng dưới và các thẻ còn lại tự kéo giãn (`1fr`) để phủ kín màn hình mà không để lại khoảng trống thừa!

---

## 6. Tổng kết

* **CSS Grid** là công cụ tối thượng cho bố cục **2 chiều**.
* Nhớ công thức phân chia không gian với đơn vị **`fr`** và hàm **`repeat()`**.
* Dùng **`grid-template-areas`** để vẽ bố cục tổng thể trang web bằng chữ.
* Dùng cụm cú pháp ma thuật **`repeat(auto-fit, minmax(...))`** để làm lưới responsive tự động.

---

## References

- [CSS Grid Layout Module Level 1 • W3C](https://www.w3.org/TR/css-grid-1/)
- [A Complete Guide to CSS Grid • CSS-Tricks](https://css-tricks.com/snippets/css/complete-guide-grid/)

---

## Series

Previous: [Bố cục 1 Chiều Hiện đại với CSS Flexbox](../07-modern-layout-with-flexbox/index.md)
Next: [Responsive Web Design và Tư duy Mobile-First](../09-responsive-and-mobile-first/index.md)
Thực hành: [Thực hành](./practice.md)

