---
title: "Bố cục 1 Chiều Hiện đại với CSS Flexbox"
description: "Khám phá bản chất cơ chế hoạt động của CSS Flexbox qua tư duy bố cục 1 chiều, hai trục tọa độ và thuật toán phân bổ không gian co giãn tự nhiên."

date:
updated:

series: "HTML & CSS Basic"
series_order: 7

tags:
  - css
  - flexbox
  - layout
  - beginner

status: draft
language: vi
---

# Bố cục 1 Chiều Hiện đại với CSS Flexbox

Trước khi mô hình Flexbox ra đời, việc dàn trang các thành phần web nằm ngang là một trong những thử thách gây ức chế nhất cho lập trình viên. Để xếp ba chiếc card sản phẩm nằm ngang thẳng hàng, người ta phải lạm dụng `float: left` đi kèm kỹ thuật `clear: both`, hoặc dùng `display: inline-block` nhưng phải tìm cách xóa khoảng trắng ẩn sinh ra từ các ký tự xuống dòng trong HTML.

Bố cục khối (Block) và dòng (Inline) truyền thống vốn được thiết kế cho văn bản tài liệu tĩnh, hoàn toàn thiếu đi cơ chế phân bổ khoảng trống linh hoạt theo màn hình. **CSS Flexible Box Layout (Flexbox)** xuất hiện như một cuộc cách mạng: giải phóng lập trình viên khỏi các mẹo hack rườm rà, cung cấp khả năng co giãn kích thước và căn chỉnh phần tử một cách tự nhiên.

## Tư duy Bố cục 1 Chiều và Cấu trúc Container - Item

Điểm mấu chốt đầu tiên cần khắc ghi: **Flexbox là mô hình bố cục một chiều (1-dimensional layout)**. 

Tại một thời điểm, Flexbox chỉ tính toán và dàn xếp các phần tử dọc theo duy nhất một trục: hoặc theo hàng ngang (`row`), hoặc theo cột dọc (`column`). Ngay cả khi bạn cho phép các phần tử tự động xuống dòng (`flex-wrap: wrap`), mỗi dòng mới vẫn được xử lý như một hàng đơn lẻ độc lập.

Cấu trúc Flexbox bao gồm hai cấp độ:
- **Flex Container**: Phần tử cha được kích hoạt bằng `display: flex` hoặc `display: inline-flex`. Ngay lập tức, nó thiết lập một ngữ cảnh định dạng flex mới (Flex Formatting Context). Các thuộc tính như `float`, `clear` và `vertical-align` trên các con trực tiếp sẽ bị vô hiệu hóa.
- **Flex Items**: Tất cả các phần tử con trực tiếp nằm trong Flex Container.

## Hai trục tọa độ: Trục chính (Main Axis) và Trục phụ (Cross Axis)

Các thuộc tính trong Flexbox không hoạt động theo khái niệm vật lý cố định (trái/phải hay trên/dưới), mà dựa trên hai trục tọa độ vuông góc:

1. **Trục chính (Main Axis)**: Là trục định hướng chính mà các Flex Item được xếp nối tiếp nhau, kéo dài từ `main-start` đến `main-end`. Chiều dài của item trên trục này được gọi là `main size` (chiều rộng khi xếp hàng, chiều cao khi xếp cột).
2. **Trục phụ (Cross Axis)**: Luôn vuông góc với Trục chính, kéo dài từ `cross-start` đến `cross-end`. Kích thước đo theo trục này gọi là `cross size`.

## Các thuộc tính điều khiển trên Flex Container

Toàn bộ việc điều phối không gian được thiết lập thông qua các thuộc tính của thẻ cha:

- **`flex-direction`**: Xác định hướng của Trục chính:
  - `row` (mặc định): Trục chính nằm ngang, từ trái sang phải.
  - `row-reverse`: Nằm ngang, đảo ngược từ phải sang trái.
  - `column`: Trục chính đổi thành chiều dọc, từ trên xuống dưới.
  - `column-reverse`: Chiều dọc, đảo ngược từ dưới lên trên.
- **`flex-wrap`**: Điều khiển việc xuống dòng (`nowrap` ép trên 1 dòng duy nhất, `wrap` cho phép xuống dòng khi hết chỗ).
- **`justify-content`**: Căn chỉnh và phân bổ khoảng trống còn thừa dọc theo **Trục chính (Main Axis)**:
  - `flex-start` / `flex-end`: Dồn phần tử về đầu hoặc cuối trục.
  - `center`: Căn giữa dọc theo trục chính.
  - `space-between`: Đẩy phần tử đầu về mép bắt đầu, phần tử cuối về mép kết thúc, chia đều khoảng trống ở giữa.
  - `space-around`: Chia đều khoảng trống xung quanh mỗi phần tử.
- **`align-items`**: Căn chỉnh các phần tử dọc theo **Trục phụ (Cross Axis)**:
  - `stretch` (mặc định): Tự động kéo giãn các phần tử cho bằng nhau và phủ kín chiều cao của dòng.
  - `flex-start` / `flex-end` / `center`.
- **`gap`**: Thiết lập khoảng cách cố định giữa các Flex Item mà không cần dùng đến `margin` thủ công.

## Điều khiển Flex Item: Sức mạnh của `flex: 1`

Điều làm nên tên gọi "Flexible" chính là khả năng tự co giãn của từng phần tử con:
- **`flex-basis`**: Kích thước nền tảng ban đầu của item trước khi khoảng trống còn thừa được phân bổ (mặc định là `auto`).
- **`flex-grow`**: Hệ số tăng trưởng. Mặc định là 0 (không tự phình to). Nếu đặt là 1, item sẽ hấp thụ khoảng trống thừa để mở rộng ra.
- **`flex-shrink`**: Hệ số co hẹp. Mặc định là 1, cho phép item tự co nhỏ lại khi container bị thiếu chỗ để tránh tràn viền.

### Cú pháp viết tắt `flex: 1`
Khi bạn viết `flex: 1`, CSS sẽ tự động gán:

```css
flex: 1 1 0px; /* flex-grow: 1, flex-shrink: 1, flex-basis: 0px */
```

Bằng cách đưa `flex-basis` về `0px`, trình duyệt sẽ triệt tiêu kích thước ban đầu của nội dung chữ bên trong, buộc tất cả các card có khai báo `flex: 1` phải chia đều tuyệt đối toàn bộ chiều rộng của khung chứa.

## Giải quyết bài toán thực tế

### 1. Thanh điều hướng Navbar với kỹ thuật auto-margin
Một bài toán kinh điển: Logo nằm bên trái, cụm menu ở giữa, và nút Đăng nhập dạt hẳn sang góc phải:

```html
<nav class="navbar">
  <div class="logo">MyBrand</div>
  <ul class="nav-links">
    <li><a href="#">Trang chủ</a></li>
    <li><a href="#">Sản phẩm</a></li>
  </ul>
  <button class="login-btn">Đăng nhập</button>
</nav>
```

```css
.navbar {
  display: flex;
  align-items: center;
  gap: 1.5rem;
}

.nav-links {
  display: flex;
  list-style: none;
  gap: 1rem;
}

/* Kỹ thuật dạt sang phải: margin-left: auto sẽ hấp thụ toàn bộ khoảng trống còn dư */
.login-btn {
  margin-left: auto;
}
```

### 2. Giải quyết bài toán căn giữa kinh điển
Để đưa một phần tử vào chính giữa màn hình theo cả 2 chiều, bạn chỉ cần 3 dòng lệnh ngắn gọn:

```css
.hero-banner {
  display: flex;
  justify-content: center; /* Căn giữa theo chiều ngang (Main Axis) */
  align-items: center;     /* Căn giữa theo chiều dọc (Cross Axis) */
  min-height: 80vh;
}
```

## Ứng dụng thực tế

Flexbox là công cụ số một cho các bố cục 1 chiều:
- Thanh điều hướng (navbars), thanh công cụ (toolbars).
- Các cụm nút bấm (button groups).
- Danh sách thẻ ngang co giãn đều nhau.
- Căn giữa nội dung trong banner hoặc popup modal.

Trong bài học tiếp theo, chúng ta sẽ tìm hiểu mảnh ghép còn lại hoàn hảo cho bố cục 2 chiều toàn diện: **CSS Grid**.

## References

- [CSS Flexible Box Layout Module Level 1 • W3C](https://www.w3.org/TR/css-flexbox-1/)

## Series

Previous: [Normal Flow và Điều khiển Vị trí với CSS Positioning](../06-normal-flow-and-positioning/index.md)
Next: [Bố cục 2 Chiều Toàn diện với CSS Grid](../08-modern-layout-with-css-grid/index.md)
