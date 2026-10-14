---
title: "Đơn vị đo, Typography và Màu sắc trong CSS"
description: "Hiểu rõ cơ chế của đơn vị tương đối rem, em, các thuộc tính typography cốt lõi và lý do hệ màu HSL tối ưu cho thiết kế giao diện."

date:
updated:

series: "HTML & CSS Basic"
series_order: 5

tags:
  - css
  - typography
  - units
  - beginner

status: draft
language: vi
---

# Đơn vị đo, Typography và Màu sắc trong CSS

Hãy hình dung một tình huống thực tế rất phổ biến: một người dùng lớn tuổi truy cập vào trang web của bạn. Vì mắt kém, họ vào phần Cài đặt của trình duyệt và tăng kích cỡ chữ mặc định từ 16px lên 24px để dễ đọc. Nhưng nếu bạn đã lập trình cố định toàn bộ giao diện bằng đơn vị pixel tuyệt đối (`px`), trang web sẽ "trơ như đá": cỡ chữ vẫn giữ nguyên kích thước nhỏ xíu, phá hỏng hoàn toàn trải nghiệm tiếp cận.

Cùng lúc đó, khi cần tạo hiệu ứng đổi màu tối hơn một chút lúc di chuột qua nút bấm (Hover state), nếu bạn dùng mã màu HEX như `#3b82f6`, bạn sẽ không biết phải tăng giảm bao nhiêu ở từng cặp ký tự số và chữ thập lục phân để màu trông tự nhiên.

Cả hai bài toán này đều được giải quyết gọn gàng nếu bạn nắm vững **Hệ thống đơn vị tương đối** và **Hệ màu sắc HSL** trong CSS.

---

## 1. Hệ thống đơn vị đo lường: Tuyệt đối vs Tương đối

Theo đặc tả W3C, đơn vị đo độ dài trong CSS được chia làm 2 trường phái:

```text
┌───────────────────────────────────────┬───────────────────────────────────────┐
│     ĐƠN VỊ TUYỆT ĐỐI (Absolute)       │      ĐƠN VỊ TƯƠNG ĐỐI (Relative)      │
├───────────────────────────────────────┼───────────────────────────────────────┤
│ • Đại diện: px (pixel hiển thị)       │ • Đại diện: rem, em, %, vh, vw        │
│ • Cố định cứng ngắc, không co giãn    │ • Tự động co giãn theo tham chiếu     │
│ • Không phản hồi theo cài đặt trợ năng│ • Tối ưu hoàn hảo cho Responsive & a11y│
└───────────────────────────────────────┴───────────────────────────────────────┘
```

### A. Sự khác biệt sống còn: `px` vs `rem` vs `em`

* **`px` (Pixel)**: Đại diện cho 1 điểm ảnh trên màn hình ($1\text{px} = 1/96\text{ inch}$). Dù người dùng có phóng to cỡ chữ của trình duyệt, `16px` vẫn vĩnh viễn là `16px`.
* **`rem` (Root em)**: Luôn tham chiếu trực tiếp đến kích thước font chữ của **phần tử gốc (`<html>`)**.
  * Mặc định ở hầu hết mọi trình duyệt: font gốc của thẻ `<html>` là **`16px`**.
  * Do đó: $1\text{rem} = 16\text{px}$, $1.5\text{rem} = 24\text{px}$, $2\text{rem} = 32\text{px}$.
  * Nếu người dùng lớn tuổi tăng font trình duyệt lên **`20px`**, thì $1\text{rem}$ lập tức tự động chuyển thành **`20px`** và toàn bộ giao diện phóng to mượt mà!

```text
Cài đặt trình duyệt: 16px ──► 1rem = 16px ──► font-size: 2rem = 32px
Cài đặt đổi thành:  20px ──► 1rem = 20px ──► font-size: 2rem = 40px (Tự động co giãn!)
```

* **`em` (Element em)**: Tham chiếu đến kích thước font của **chính phần tử đó** hoặc **phần tử cha gần nhất**.

> [!WARNING]
> ### Cạm bẫy "Lồng nhau cấp số nhân" của `em`
> Nếu bạn dùng `em` cho font-size ở các danh sách menu lồng nhau:
> ```html
> <ul>           <!-- font-size: 1.5em (24px) -->
>   <li>
>     <ul>         <!-- font-size: 1.5em của 24px = 36px! -->
>       <li>
>         <ul>     <!-- font-size: 1.5em của 36px = 54px!! Chữ phình to khổng lồ -->
> ```
> Vì hiện tượng nhân dồn này, **quy tắc hiện đại là**:
> * Dùng **`rem`** cho hầu hết mọi kích thước (`font-size`, `margin`, `padding`, `width`).
> * Dùng **`em`** khi muốn một thuộc tính phụ (như `padding` bên trong nút bấm) tự động to nhỏ theo đúng cỡ chữ của nút đó.
> * Dùng **`px`** cho đường viền siêu mỏng (`border: 1px solid ...`) hoặc bóng đổ (`box-shadow`), nơi cần giữ độ sắc nét cố định theo điểm ảnh.

---

## 2. Typography và Bí mật của `line-height`

Typography là nghệ thuật sắp đặt chữ viết để nội dung dễ đọc và truyền tải đúng cảm xúc:

* **`font-family`**: Khai báo danh sách font chữ dự phòng (fallback font):
  ```css
  font-family: "Inter", system-ui, -apple-system, sans-serif;
  ```
  *(Nếu máy người dùng không có font Inter, trình duyệt sẽ tự động lấy font hệ thống của Apple/Windows thay thế).*
* **`font-size`**: Cỡ chữ (ưu tiên dùng đơn vị `rem`).
* **`font-weight`**: Độ đậm nét của chữ (từ `100` đến `900`, phổ biến là `400` cho chữ thường và `700` cho chữ đậm).
* **`line-height`**: Khoảng cách chiều cao giữa các dòng chữ trong một đoạn văn.

```text
┌──────────────────────────────────────────────┐
│ Dòng chữ thứ nhất trên trang web...          │ ─┐
│                                              │  ├─ line-height (chiều cao dòng)
│ Dòng chữ thứ hai tiếp nối ngay sau đó...     │ ─┘
└──────────────────────────────────────────────┘
```

> [!TIP]
> ### Luôn dùng số KHÔNG ĐƠN VỊ cho `line-height`
> Tuyệt đối tránh viết `line-height: 24px` hay `line-height: 1.5em` trên thẻ cha (`<body>`).
> * **Hãy luôn viết**: `line-height: 1.5;` hoặc `line-height: 1.6;` (số thực không kèm đơn vị).
> * **Vì sao?** Khi không có đơn vị, mỗi phần tử con sẽ lấy chính `font-size` của nó nhân với `1.5`. Nếu bạn dùng đơn vị cố định trên `<body>`, thẻ tiêu đề `<h1>` với cỡ chữ to đùng sẽ bị kế thừa khoảng cách dòng nhỏ của thẻ con, dẫn đến các dòng chữ bị **đè dính lên nhau như bánh kẹp**!

---

## 3. Hệ màu sắc trong CSS: Vì sao HSL là vũ khí tối thượng?

CSS hỗ trợ 4 cách định nghĩa màu sắc phổ biến:

1. **Từ khóa màu**: `red`, `blue`, `papayawhip` (chỉ dùng test nhanh).
2. **Mã HEX**: `#3b82f6` (mã màu thập lục phân 6 ký tự kết hợp 3 kênh Red, Green, Blue).
3. **RGB / RGBA**: `rgb(59, 130, 246)` hoặc `rgba(59, 130, 246, 0.8)` (có thêm kênh Alpha chỉnh độ trong suốt từ 0 đến 1).
4. **HSL**: `hsl(hue, saturation%, lightness%)`.

### Sức mạnh của HSL đối với Lập trình viên & Designer

Mã HEX hay RGB được máy tính đọc rất nhanh, nhưng con người nhìn vào chuỗi `#3b82f6` thì không thể đoán được làm sao để tạo ra một màu xanh nhạt hơn hoặc đậm hơn. 

**HSL** mô phỏng chính xác cách mắt người cảm nhận màu sắc thông qua 3 thông số:

```text
         90° (Vàng chanh)
   120° (Xanh lá)      60° (Vàng)
           \        /
180° (Cyan) ── ● ── 0° / 360° (Đỏ)
           /        \
  240° (Xanh dương)   300° (Tím hồng)
```

1. **Hue (Sắc độ màu)**: Là một góc quay từ $0^\circ$ đến $360^\circ$ trên vòng tròn màu.
   * `0` = Đỏ, `120` = Xanh lá, `240` = Xanh dương.
2. **Saturation (Độ bão hòa/Đậm đà)**: Từ $0\%$ (màu xám xịt) đến $100\%$ (màu rực rỡ nhất).
3. **Lightness (Độ sáng)**:
   * $0\%$ = Đen hoàn toàn.
   * $50\%$ = Màu chuẩn nguyên bản.
   * $100\%$ = Trắng hoàn toàn.

### Ứng dụng đỉnh cao: Tạo bảng màu chỉ bằng 1 con số

Khi làm nút bấm, bạn chỉ cần giữ nguyên góc màu **Hue (215)** và độ đậm **Saturation (90%)**, sau đó **chỉ cần thay đổi tham số Lightness**:

```css
.button {
  background-color: hsl(215, 90%, 50%); /* Màu chuẩn (50% Lightness) */
}

.button:hover {
  background-color: hsl(215, 90%, 40%); /* Tối hơn 10% khi di chuột vào */
}

.button:active {
  background-color: hsl(215, 90%, 30%); /* Tối hơn 20% khi nhấn chuột xuống */
}

.button-disabled {
  background-color: hsl(215, 20%, 80%); /* Giảm Saturation để màu nhạt đi */
}
```

Đây chính là nguyên lý mà các Design System hiện đại (như Tailwind CSS hay Material Design) dùng để tự động sinh ra các dải màu từ 100 đến 900!

---

## 4. Tổng kết

* **Đơn vị**: Ưu tiên dùng **`rem`** cho bố cục và cỡ chữ để hỗ trợ co giãn trợ năng. Chỉ dùng **`px`** cho đường viền mỏng.
* **Typography**: Luôn khai báo **`line-height` bằng số không đơn vị** (ví dụ: `1.5`) để tránh lỗi đè chữ.
* **Màu sắc**: Nắm vững **HSL** để tự tay biến hóa các biến thể màu sáng/tối một cách khoa học mà không cần dùng đến Photoshop hay Figma.

---

## References

- [CSS Values and Units Module Level 4 • W3C](https://www.w3.org/TR/css-values-4/)
- [CSS Color Module Level 4 • W3C](https://www.w3.org/TR/css-color-4/)

---

## Series

Previous: [CSS Syntax, Specificity và Bản chất của Box Model](../04-css-syntax-and-box-model/index.md)
Next: [Normal Flow và Điều khiển Vị trí với CSS Positioning](../06-normal-flow-and-positioning/index.md)
