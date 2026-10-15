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

Trước khi Flexbox ra đời, việc xếp 3 chiếc hộp nằm ngang thẳng hàng là "cơn ác mộng" của mọi lập trình viên web. Người ta phải dùng `float: left` rồi vất vả dọn dẹp bằng kỹ thuật `clear: both`, hoặc dùng `inline-block` nhưng bị dính những khoảng trắng vô duyên sinh ra từ phím Enter trong HTML.

**CSS Flexbox (Flexible Box Layout)** xuất hiện như một phép màu giải phóng lập trình viên: chỉ với 1 dòng khai báo `display: flex`, các phần tử con lập tức tự động xếp hàng ngay ngắn, co giãn thông minh và căn chỉnh hoàn hảo trên mọi kích thước màn hình.

---

## 1. Tư duy cốt lõi: Bố cục 1 Chiều (1-Dimensional)

Điểm then chốt số 1 cần ghi nhớ: **Flexbox chỉ xử lý các phần tử dọc theo DUY NHẤT MỘT TRỤC tại một thời điểm**:
* Hoặc là xếp theo **Hàng ngang** (`row`).
* Hoặc là xếp theo **Cột dọc** (`column`).

Mô hình Flexbox luôn gồm 2 tầng:
1. **Flex Container (Thẻ cha)**: Được kích hoạt bằng `display: flex`. Đóng vai trò là "người nhạc trưởng" phân chia không gian.
2. **Flex Items (Các thẻ con trực tiếp)**: Những đứa con ngoan ngoãn lắng nghe và co giãn theo sự điều phối của người cha.

---

## 2. Bản đồ 2 Trục tọa độ: Trục chính (Main Axis) & Trục phụ (Cross Axis)

Đây là bí mật quan trọng nhất để làm chủ Flexbox: **Không có khái niệm "trái/phải" hay "trên/dưới" cố định, mọi thứ xoay quanh 2 trục vuông góc**:

```text
Khi flex-direction: row (Mặc định xếp hàng ngang):

         TRỤC CHÍNH (Main Axis) ──────────────────────────►
     ┌────────────────────────────────────────────────────────┐
  T  │  ┌───────────┐      ┌───────────┐      ┌───────────┐   │
  R  │  │  Item 1   │      │  Item 2   │      │  Item 3   │   │
  Ụ  │  └───────────┘      └───────────┘      └───────────┘   │
  C  │                                                        │
     │  justify-content điều khiển TRỤC CHÍNH (Chiều ngang)   │
  P  │  align-items điều khiển TRỤC PHỤ (Chiều dọc)           │
  H  │                                                        │
  Ụ  │                                                        │
  ▼  └────────────────────────────────────────────────────────┘
```

> [!IMPORTANT]
> ### Điểm bừng sáng tư duy: Khi xoay trục với `flex-direction: column`
> Nếu bạn đổi `flex-direction: column` để xếp các phần tử thành hàng dọc:
> * **Trục chính (Main Axis)** biến thành **Chiều DỌC** $\downarrow$. Lúc này `justify-content` sẽ điều khiển khoảng cách theo chiều dọc!
> * **Trục phụ (Cross Axis)** biến thành **Chiều NGANG** $\rightarrow$. Lúc này `align-items` sẽ điều khiển căn chỉnh theo chiều ngang!

---

## 3. Các thuộc tính điều phối không gian của Thẻ cha (Container)

### A. Căn chỉnh trên Trục chính với `justify-content`

```text
flex-start    [A][B][C] . . . . . . . . . . . . (Dồn về đầu trục)
flex-end      . . . . . . . . . . . . [A][B][C] (Dồn về cuối trục)
center        . . . . . . [A][B][C] . . . . . . (Căn chính giữa trục)
space-between [A] . . . . . . [B] . . . . . [C] (Đẩy dạt sang 2 mép biên)
space-around  . . [A] . . . . [B] . . . . [C] . (Khoảng cách đều quanh mỗi item)
space-evenly  . . . [A] . . . [B] . . . [C] . . (Khoảng cách giữa các item bằng nhau chằn chặn)
```

### B. Căn chỉnh trên Trục phụ với `align-items`
* `stretch` (Mặc định): Tự động kéo dài các item cho **bằng nhau về chiều cao** (rất tiện để làm các Card sản phẩm đều tăm tắp).
* `center`: Căn giữa theo trục phụ.
* `flex-start` / `flex-end`: Dồn về đỉnh hoặc đáy.

### C. Khoảng cách hiện đại với `gap`
Thay vì phải viết `margin-right: 16px` cho từng thẻ con rồi loay hoay dùng `:last-child` để xóa lề của thẻ cuối, bạn chỉ cần gõ đúng 1 dòng trên thẻ cha:
```css
.container {
  display: flex;
  gap: 16px; /* Tự động tạo khoảng cách 16px ở giữa các item */
}
```

---

## 4. Điều khiển thẻ con: Sức mạnh của `flex: 1`

Mỗi phần tử con có khả năng tự co giãn thông minh:
* **`flex-grow` (Độ phình to)**: Mặc định là `0`. Nếu đặt là `1`, nó sẽ tự hút lấy khoảng trống còn thừa để mở rộng ra.
* **`flex-shrink` (Độ co hẹp)**: Mặc định là `1`. Khi màn hình bị bóp nhỏ, item được phép tự co lại để không làm tràn khung.
* **`flex-basis`**: Kích thước ban đầu trước khi tính toán co giãn.

```text
┌──────────────────────────────────────────────────────────────┐
│  ┌──────────────────┐  ┌──────────────────┐  ┌─────────────┐ │
│  │ flex: 1          │  │ flex: 1          │  │ flex: 1     │ │
│  │ (Chiếm 1 phần)   │  │ (Chiếm 1 phần)   │  │ (1 phần)    │ │
│  └──────────────────┘  └──────────────────┘  └─────────────┘ │
└──────────────────────────────────────────────────────────────┘
```

> **Tuyệt chiêu `flex: 1`:** Khi bạn muốn 3 chiếc cột chia đều tăm tắp màn hình $33.33\%$, bất chấp nội dung chữ bên trong dài ngắn khác nhau, chỉ cần gắn `flex: 1` cho cả 3 thẻ con. Trình duyệt sẽ tự chia bánh ngọt thành 3 phần bằng nhau tuyệt đối!

---

## 5. Hai bài toán kinh điển trong thực tế

### Bài toán 1: Căn giữa hoàn hảo (The Holy Grail of Centering)
Để đưa một khối nội dung vào **chính giữa màn hình cả về chiều ngang lẫn chiều dọc**, bạn chỉ cần đúng 3 dòng thần thánh:

```css
.hero-box {
  display: flex;
  justify-content: center; /* Căn giữa trục chính */
  align-items: center;     /* Căn giữa trục phụ */
  min-height: 100vh;
}
```

### Bài toán 2: Navbar với chiêu thức `margin-left: auto`
Làm sao để Logo bên trái, Menu ở giữa, còn nút Đăng nhập dạt hẳn sang góc phải cùng?

```text
┌──────────────────────────────────────────────────────────────┐
│ [Logo]   [Trang chủ] [Sản phẩm]             [Nút Đăng nhập] │
│                                  ▲                           │
│                                  └─ margin-left: auto hút hết│
│                                     toàn bộ khoảng trống thừa│
└──────────────────────────────────────────────────────────────┘
```

```css
.navbar {
  display: flex;
  align-items: center;
  gap: 20px;
}

/* Chỉ cần thêm 1 dòng này vào nút Đăng nhập: */
.login-btn {
  margin-left: auto; /* Tự động dạt hết cỡ sang phải */
}
```

---

## 6. Tổng kết

* **Flexbox** là công cụ số 1 cho bố cục **1 chiều** (hàng ngang hoặc cột dọc).
* Nắm chắc **Trục chính** (`justify-content`) và **Trục phụ** (`align-items`).
* Dùng **`gap`** để tạo khoảng cách sạch sẽ, dùng **`flex: 1`** để chia đều cột, và dùng **`margin-left: auto`** để dạt phần tử sang góc phải.

---

## References

- [CSS Flexible Box Layout Module Level 1 • W3C](https://www.w3.org/TR/css-flexbox-1/)
- [A Complete Guide to Flexbox • CSS-Tricks](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)

---

## Series

- Previous: [Normal Flow và Điều khiển Vị trí với CSS Positioning](../06-normal-flow-and-positioning/index.md)
- [Thực hành](./practice.md)
- Next: [Bố cục 2 Chiều Toàn diện với CSS Grid](../08-modern-layout-with-css-grid/index.md)

