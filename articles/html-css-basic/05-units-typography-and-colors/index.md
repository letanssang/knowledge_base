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

Hãy hình dung một tình huống phổ biến trong thực tế: một người dùng lớn tuổi truy cập vào trang web của bạn. Để dễ đọc hơn, họ vào phần cài đặt của trình duyệt và tăng kích thước chữ mặc định từ 16px lên 24px. Nhưng nếu bạn đã cố định toàn bộ kích thước bằng đơn vị tuyệt đối `px`, trang web sẽ không hề phản hồi: cỡ chữ vẫn giữ nguyên kích thước nhỏ, gây khó khăn cho người đọc.

Cùng lúc đó, khi cần tạo hiệu ứng đổi màu tối hơn một chút lúc di chuột qua nút bấm (hover state), nếu đang dùng mã HEX như `#3b82f6`, bạn sẽ rất khó tính toán thủ công xem cần giảm bao nhiêu giá trị ở từng cặp ký tự đại diện cho kênh màu đỏ, xanh lá hay xanh dương.

Cả hai vấn đề này đều bắt nguồn từ việc lựa chọn chưa phù hợp giữa **Hệ thống đơn vị đo lường** và **Hệ màu sắc** trong CSS.

## Hệ thống đơn vị đo lường: Tuyệt đối vs Tương đối

Theo quy chuẩn W3C, các đơn vị đo độ dài trong CSS được chia thành hai nhóm:

### 1. Đơn vị tuyệt đối (Absolute Lengths)
Bao gồm `px`, `cm`, `mm`, `in`, `pt`, `pc`. Trong đó, `px` (pixel hiển thị) là đơn vị chuẩn (canonical unit) được neo cố định theo tỷ lệ:

$$1\text{px} = \frac{1}{96}\text{ inch}$$

Đơn vị tuyệt đối có ưu điểm là cố định và dễ hình dung. Tuy nhiên, nhược điểm lớn nhất là nó không thể tự động co giãn theo thiết lập trợ năng (accessibility preferences) của người dùng hoặc các môi trường hiển thị khác nhau.

### 2. Đơn vị tương đối (Relative Lengths)
Các đơn vị tương đối được tính toán dựa trên một giá trị tham chiếu động:
- **`%`**: Tỷ lệ phần trăm tính theo kích thước phần tử cha hoặc kích thước hộp chứa.
- **`vw` / `vh`**: 1% chiều rộng (`viewport width`) và 1% chiều cao (`viewport height`) của cửa sổ trình duyệt. Hiện nay CSS hiện đại còn bổ sung các biến thể như `dvh` (Dynamic Viewport Height) để xử lý mượt mà khi thanh địa chỉ trên trình duyệt di động ẩn hiện.
- **`em`**: Bằng kích thước font chữ (`font-size`) được tính toán của **chính phần tử đó** (hoặc phần tử cha gần nhất).
- **`rem` (root em)**: Luôn tham chiếu trực tiếp đến kích thước font chữ của **phần tử gốc (`<html>`)**.

Theo mặc định của hầu hết trình duyệt, kích thước font ở thẻ gốc là 16px. Do đó, $1\text{rem} = 16\text{px}$.

### Tại sao nên ưu tiên `rem`?
Khi người dùng tăng kích thước font mặc định của trình duyệt lên 24px, giá trị tại phần tử gốc sẽ chuyển thành 24px. Toàn bộ các phần tử sử dụng `rem` (ví dụ `font-size: 1.5rem`, `padding: 1rem`) sẽ tự động phóng to tương ứng mà không làm vỡ tỷ lệ bố cục, giúp trang web đạt chuẩn tiếp cận cao nhất.

## Typography cốt lõi và Bí mật của `line-height`

Typography trong CSS xoay quanh các thuộc tính định hình văn bản:
- **`font-family`**: Khai báo danh sách font chữ ưu tiên theo thứ tự fallback, kết thúc bằng một họ font chung (`"Inter", system-ui, -apple-system, sans-serif`).
- **`font-size`**: Kích thước chữ (nên dùng `rem`).
- **`font-weight`**: Độ đậm của nét chữ (từ 100 đến 900, phổ biến là 400 cho Normal và 700 cho Bold).
- **`line-height`**: Chiều cao của dòng văn bản.

### Lưu ý quan trọng với `line-height`: Hãy dùng số không đơn vị!
Thuộc tính `line-height` có thể nhận giá trị có đơn vị (`line-height: 24px`, `1.5em`) hoặc một hệ số tỷ lệ không đơn vị (`line-height: 1.5`):

```css
/* NÊN DÙNG: Số không đơn vị */
body {
  font-size: 1rem;
  line-height: 1.5;
}
```

Khi dùng hệ số không đơn vị (`1.5`), mỗi phần tử con bên trong sẽ lấy chính kích thước font chữ của nó nhân với 1.5. Nếu bạn dùng đơn vị cố định hoặc `em` trên thẻ cha, giá trị chiều cao dòng tuyệt đối đã tính từ cha sẽ truyền xuống con, khiến các tiêu đề `<h1>` có cỡ chữ lớn bị dính chữ hoặc đè chữ lên nhau.

## Hệ màu sắc trong CSS: Sức mạnh của HSL

CSS hỗ trợ nhiều cách khai báo màu sắc:
1. **Từ khóa màu**: `red`, `blue`, `transparent` (thường chỉ dùng khi test nhanh).
2. **Mã HEX**: `#1a73e8` (kết hợp các giá trị Hexadecimal của 3 kênh Red, Green, Blue).
3. **RGB / RGBA**: `rgb(26, 115, 232)` hoặc `rgba(26, 115, 232, 0.8)` (bổ sung kênh Alpha điều chỉnh độ trong suốt từ 0 đến 1).
4. **HSL / HSLA**: `hsl(hue, saturation%, lightness%)`.

Trong thiết kế giao diện, **HSL** là định dạng trực quan và linh hoạt nhất:
- **Hue (Sắc độ)**: Là một góc từ $0^\circ$ đến $360^\circ$ trên vòng tròn màu (0 là Đỏ, 120 là Xanh lá, 240 là Xanh dương).
- **Saturation (Độ bão hòa)**: Từ 0% (xám xịt) đến 100% (màu rực rỡ).
- **Lightness (Độ sáng)**: Từ 0% (đen hoàn toàn), 50% (màu chuẩn), đến 100% (trắng hoàn toàn).

Nhờ tách riêng tham số Lightness thành một tỷ lệ phần trăm độc lập, việc tạo các biến thể màu trở nên vô cùng đơn giản:

```css
.button {
  background-color: hsl(215, 90%, 50%); /* Màu xanh chuẩn */
}

.button:hover {
  background-color: hsl(215, 90%, 40%); /* Giảm độ sáng để màu tối hơn khi hover */
}
```

## Ứng dụng thực tế

- Dùng **`rem`** cho `font-size`, `margin`, `padding` để toàn bộ giao diện tự động co giãn theo thiết lập font của trình duyệt.
- Dùng **`px`** cho các đường viền mỏng (`border: 1px solid ...`) hoặc bóng đổ nhỏ (`box-shadow`), nơi mà kích thước cần giữ độ sắc nét cố định ở cấp độ điểm ảnh.
- Luôn đặt **`line-height`** dưới dạng số không đơn vị (ví dụ 1.5 đến 1.6 cho văn bản đọc).
- Tận dụng hệ màu **HSL** kết hợp với CSS Variables để xây dựng bảng màu giao diện và chế độ sáng/tối (Dark Mode) dễ dàng hơn.

## References

- [CSS Values and Units Module Level 4 • W3C](https://www.w3.org/TR/css-values-4/)

## Series

Previous: [CSS Syntax, Specificity và Bản chất của Box Model](../04-css-syntax-and-box-model/index.md)
Next: [Normal Flow và Điều khiển Vị trí với CSS Positioning](../06-normal-flow-and-positioning/index.md)
