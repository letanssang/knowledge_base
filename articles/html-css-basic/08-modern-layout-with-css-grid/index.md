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

Khi xây dựng các giao diện ứng dụng web hoàn chỉnh như bảng điều khiển (dashboard) hay trang tin tức, lập trình viên thường phải sắp xếp nhiều khối lớn: thanh điều hướng (header), cột bên (sidebar), nội dung chính (main content) và chân trang (footer). 

Trước khi có CSS Grid, việc giải quyết bài toán layout này bằng Flexbox thường đòi hỏi bạn phải lồng ghép rất nhiều tầng thẻ container (ví dụ: bọc sidebar và main trong một hàng, rồi bọc toàn bộ với header và footer trong một cột). Cách tiếp cận này khiến việc đồng bộ độ rộng và chiều cao giữa các cột qua nhiều hàng trở nên phức tạp, khó kiểm soát và dễ bị xô lệch khi kích thước màn hình thay đổi.

**CSS Grid Layout Module** ra đời nhằm giải quyết triệt để thách thức này: cung cấp một hệ thống dàn trang 2 chiều mạnh mẽ, cho phép bạn định hình toàn bộ ma trận hàng và cột của trang web một cách trực quan và mạch lạc.

## Flexbox vs. CSS Grid: Ranh giới giữa 1 chiều và 2 chiều

Mặc dù cả hai đều là những công cụ dàn trang hiện đại, W3C định nghĩa ranh giới ứng dụng rất rõ ràng giữa Flexbox và Grid:

| Tiêu chí | CSS Flexbox | CSS Grid |
|---|---|---|
| **Số chiều (Dimensions)** | **1 chiều** (hoặc theo hàng, hoặc theo cột). | **2 chiều** (đồng thời cả hàng và cột). |
| **Phương pháp tiếp cận** | **Bottom-up** (từ dưới lên): Kích thước và vị trí được định hình chủ yếu dựa trên kích thước của từng phần tử nội dung con. | **Top-down** (từ trên xuống): Khung lưới ma trận được định hình trước trên thẻ cha, sau đó các phần tử con được xếp vào các ô lưới có sẵn. |
| **Trường hợp tối ưu** | Thành phần giao diện nhỏ: navbar, menu, cụm nút bấm, căn giữa phần tử. | Khung layout tổng thể của trang web, bảng dữ liệu, lưới ảnh, dashboard. |

Nguyên tắc vàng: **Dùng CSS Grid để dựng khung layout tổng thể của trang web, và dùng Flexbox để dàn xếp các chi tiết bên trong từng khối.**

## Các khái niệm cấu trúc nền tảng trong CSS Grid

Để làm chủ CSS Grid, bạn cần nắm vững 5 thuật ngữ cốt lõi:

1. **Grid Container**: Phần tử cha được kích hoạt bằng `display: grid` hoặc `display: inline-grid`.
2. **Grid Lines (Đường lưới)**: Các đường kẻ ngang và dọc phân chia khung lưới, được đánh số bắt đầu từ 1 ở mép đầu tiên (hoặc số âm bắt đầu từ -1 ở mép cuối).
3. **Grid Track (Tuyến lưới)**: Khoảng không gian nằm giữa hai đường Grid Lines song song kề nhau. Nói một cách đơn giản, một Grid Track chính là một **hàng (row)** hoặc một **cột (column)**.
4. **Grid Cell (Ô lưới)**: Giao điểm giữa một hàng và một cột, là đơn vị không gian nhỏ nhất trong lưới.
5. **Grid Area (Vùng lưới)**: Vùng không gian hình chữ nhật hợp thành từ một hoặc nhiều ô lưới kề nhau.

## Các thuộc tính cốt lõi và đơn vị phân số `fr`

Để khai báo các hàng và cột trên Grid Container:

- **`grid-template-columns`**: Định nghĩa danh sách các cột.
- **`grid-template-rows`**: Định nghĩa danh sách các hàng.
- **`gap`**: Khoảng cách giữa các hàng và cột (thay thế cho `grid-gap`).

### Sức mạnh của đơn vị `fr` (Fraction Unit)
Đơn vị `fr` đại diện cho một phần tỷ lệ của không gian còn dư bên trong container sau khi đã trừ đi các cột có kích thước cố định (`px`):

```css
.container {
  display: grid;
  grid-template-columns: 200px 1fr 2fr;
  /* Cột 1 cố định 200px. Khoảng trống còn lại chia thành 3 phần: cột 2 lấy 1 phần, cột 3 lấy 2 phần */
}
```

### Hàm tiện ích: `repeat()` và `minmax()`
- **`repeat(3, 1fr)`**: Tương đương với `1fr 1fr 1fr`, giúp cú pháp gọn gàng hơn khi chia nhiều cột bằng nhau.
- **`minmax(200px, 1fr)`**: Đảm bảo cột có độ rộng co giãn linh hoạt (`1fr`), nhưng không bao giờ co nhỏ hơn kích thước sàn (`200px`).

## Thực hành 1: Dựng layout trang web kinh điển với `grid-template-areas`

Một trong những tính năng trực quan nhất của CSS Grid là khả năng vẽ layout trực tiếp bằng chữ trong CSS thông qua `grid-template-areas`:

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
  grid-template-areas:
    "head head"
    "nav  main"
    "foot foot";
  grid-template-columns: 240px 1fr;
  grid-template-rows: auto 1fr auto;
  min-height: 100vh;
  gap: 1rem;
}

.header  { grid-area: head; }
.sidebar { grid-area: nav;  }
.main    { grid-area: main; }
.footer  { grid-area: foot; }
```

Nhìn vào khai báo trên, bạn có thể thấy ngay Header trải dài qua cả 2 cột ở hàng 1, hàng 2 chia thành Sidebar (240px) và Main (1fr), và Footer trải dài qua cả 2 cột ở hàng 3. Cực kỳ trực quan và không cần lồng ghép bất kỳ thẻ trung gian nào!

## Thực hành 2: Danh sách thẻ tự động Responsive không cần Media Query

Một ứng dụng kinh điển khác là tạo lưới sản phẩm tự thích ứng kích thước màn hình mà không cần viết câu lệnh `@media` nào:

```css
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
}
```

### Cơ chế hoạt động:
1. `minmax(280px, 1fr)`: Mỗi thẻ có kích thước tối thiểu là 280px.
2. `auto-fit`: Trình duyệt tự động tính toán màn hình hiện tại chứa được tối đa bao nhiêu cột có kích thước $\ge 280\text{px}$.
3. Khi kích thước màn hình co lại (ví dụ trên điện thoại chỉ rộng 360px), trình duyệt sẽ tự động giảm từ 3 cột xuống 2 cột, rồi xuống 1 cột duy nhất, đồng thời kéo giãn thẻ ra `1fr` để phủ kín màn hình.

## Ứng dụng thực tế

- Dùng **Grid** để tạo bộ khung bố cục trang web hoàn chỉnh (Header - Sidebar - Content - Footer).
- Dùng **`grid-template-areas`** khi muốn tái sắp xếp lại layout nhanh chóng giữa màn hình di động và máy tính.
- Dùng **`repeat(auto-fit, minmax(...))`** cho các danh sách sản phẩm, thư viện ảnh hoặc danh sách tin tức.

## References

- [CSS Grid Layout Module Level 1 • W3C](https://www.w3.org/TR/css-grid-1/)

## Series

Previous: [Bố cục 1 Chiều Hiện đại với CSS Flexbox](../07-modern-layout-with-flexbox/index.md)
Next: [Responsive Web Design và Tư duy Mobile-First](../09-responsive-and-mobile-first/index.md)
