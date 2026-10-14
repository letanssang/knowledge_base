---
title: "CSS Syntax, Specificity và Bản chất của Box Model"
description: "Khám phá cơ chế tính toán kích thước phần tử, độ ưu tiên chọn lọc trong CSS và nguyên lý Margin Collapsing theo chuẩn W3C."

date:
updated:

series: "HTML & CSS Basic"
series_order: 4

tags:
  - css
  - box-model
  - specificity
  - beginner

status: draft
language: vi
---

# CSS Syntax, Specificity và Bản chất của Box Model

Trong quá trình phát triển giao diện web, nhiều lập trình viên frontend từng gặp phải hai hiện tượng dường như vô lý nhưng lại xuất hiện thường xuyên:

1. Bạn vừa dựng một khối thẻ `<div>` và thiết lập `width: 300px`, sau đó thêm `padding: 20px` cùng `border: 2px` để tạo khoảng đệm và viền khung. Nhưng khi kiểm tra trên trình duyệt, khối hộp đó lại phình to ra thành **344px**, khiến cả hàng layout bị xô lệch và rớt dòng.
2. Bạn đặt hai đoạn văn `<p>` liên tiếp nhau theo chiều dọc với khai báo `margin: 20px` cho mỗi đoạn. Theo phép cộng thông thường, khoảng cách giữa chúng phải là 40px, nhưng thực tế trình duyệt chỉ hiển thị một khoảng trống **20px**.

Những hiện tượng này không phải là lỗi của trình duyệt, mà là kết quả trực tiếp từ các nguyên lý cốt lõi trong đặc tả W3C: **Độ ưu tiên chọn lọc (Specificity)**, **CSS Box Model**, và **Hiện tượng gộp lề (Margin Collapsing)**.

## Cú pháp CSS và Cơ chế độ ưu tiên chọn lọc (Specificity)

Mã CSS được cấu thành từ các bộ quy tắc (rule sets). Mỗi bộ quy tắc gồm một bộ chọn (selector) và một khối khai báo (declaration block) chứa các cặp thuộc tính - giá trị:

```css
/* selector { property: value; } */
p.intro {
  color: #1a73e8;
  font-size: 1.125rem;
}
```

Khi có nhiều bộ quy tắc cùng nhắm vào một phần tử và thiết lập các thuộc tính trái ngược nhau, trình duyệt không chọn ngẫu nhiên mà tính toán trọng số theo cơ chế **Specificity** theo thứ tự ưu tiên giảm dần:
1. **Inline style**: Khai báo trực tiếp trong thuộc tính `style="..."` của thẻ HTML (trọng số cao nhất).
2. **ID selector**: Ví dụ `#main-nav` (trọng số 1-0-0).
3. **Class, pseudo-class, attribute selector**: Ví dụ `.btn`, `:hover`, `[type="text"]` (trọng số 0-1-0).
4. **Element selector, pseudo-element**: Ví dụ `div`, `p`, `::before` (trọng số 0-0-1).

Nếu hai bộ quy tắc có cùng trọng số Specificity, quy tắc nào được trình duyệt đọc sau trong tập tin CSS sẽ là quy tắc chiến thắng và được áp dụng.

## Bốn lớp cấu tạo của Box Model theo chuẩn W3C

Để hiển thị bất kỳ phần tử nào trên trang, mô hình định dạng thị giác (Visual Formatting Model) của W3C đều coi phần tử đó là một khối hộp chữ nhật được bao bọc bởi bốn lớp không gian lồng nhau từ trong ra ngoài:

1. **Vùng nội dung (Content area)**: Giới hạn bởi đường viền nội dung (`content edge`), là nơi chứa văn bản, hình ảnh hoặc các phần tử con.
2. **Vùng đệm (Padding area)**: Giới hạn bởi `padding edge`, tạo khoảng trống giữa nội dung và viền. Vùng đệm luôn hiển thị màu nền hoặc ảnh nền của chính phần tử đó.
3. **Vùng viền (Border area)**: Giới hạn bởi `border edge`, là đường kẻ bao quanh vùng đệm với các đặc tính về độ dày, kiểu dáng (`solid`, `dashed`...) và màu sắc.
4. **Vùng lề (Margin area)**: Giới hạn bởi `margin edge`, tạo khoảng cách giữa phần tử hiện tại với các phần tử lân cận. **Đặc điểm quan trọng**: Vùng lề luôn luôn trong suốt (transparent), để lộ màu nền của phần tử cha bên dưới.

## Cơ chế kích thước: Từ content-box đến border-box

Tại sao khai báo `width: 300px` lại tạo ra chiếc hộp rộng 344px?

Theo mô hình mặc định của W3C (`box-sizing: content-box`), thuộc tính `width` chỉ đại diện cho chiều rộng của **riêng vùng nội dung**:

$$\text{Tổng chiều rộng} = \text{width} + \text{padding-left} + \text{padding-right} + \text{border-left} + \text{border-right}$$

Trong ví dụ ban đầu: $300\text{px} + 20\text{px} + 20\text{px} + 2\text{px} + 2\text{px} = 344\text{px}$.

Cách tính này khiến việc chia cột giao diện theo phần trăm trở nên rất phức tạp (ví dụ: hai cột 50% nhưng có thêm padding sẽ vượt quá 100% và bị rớt dòng).

Để giải quyết triệt để vấn đề này, CSS cung cấp giá trị `box-sizing: border-box`. Khi áp dụng `border-box`, thuộc tính `width: 300px` sẽ bao trùm toàn bộ từ viền trái sang viền phải. Trình duyệt sẽ tự động co hẹp vùng nội dung lại còn 256px để tổng kích thước bên ngoài giữ nguyên đúng 300px.

Đó là lý do hầu hết các dự án web chuyên nghiệp đều bắt đầu bằng quy tắc reset chuẩn:

```css
*, *::before, *::after {
  box-sizing: border-box;
}
```

## Hiện tượng gộp lề dọc (Margin Collapsing)

Một cơ chế đặc biệt khác của Box Model trong luồng hiển thị thông thường (Normal Flow) là **Margin Collapsing**.

Theo quy chuẩn W3C, khi các khoảng lề dọc của hai khối block nằm kề nhau (adjoining margins), chúng không cộng dồn lại với nhau mà sẽ kết hợp thành một khoảng lề duy nhất có độ lớn bằng giá trị lề lớn nhất:

$$\text{Khoảng cách thực tế} = \max(\text{margin-bottom}_1, \text{margin-top}_2)$$

Trong ví dụ hai thẻ `<p>` xếp chồng lên nhau với `margin: 20px`, khoảng cách thực tế là $\max(20\text{px}, 20\text{px}) = 20\text{px}$. Nếu đoạn văn trên có `margin-bottom: 30px` và đoạn văn dưới có `margin-top: 15px`, khoảng cách thực tế giữa chúng sẽ là 30px.

### Khi nào gộp lề KHÔNG xảy ra?
- **Khoảng lề ngang (Horizontal margins)**: Không bao giờ gộp lề.
- **Phần tử trôi (Floats)** và **Định vị tuyệt đối (`position: absolute/fixed`)**: Không bao giờ gộp lề với phần tử khác.
- **Phần tử thiết lập Context mới (Flex item, Grid item, BFC)**: Khoảng lề bên trong vùng chứa Flexbox hoặc CSS Grid không bị gộp lề dọc.

## Ứng dụng thực tế

Hiểu rõ Box Model giúp bạn kiểm soát hoàn toàn kích thước và khoảng cách trong giao diện:
- Luôn sử dụng `box-sizing: border-box` trên toàn bộ trang để việc tính toán kích thước trực quan và không bị phình to bất ngờ.
- Chủ động nắm bắt hiện tượng gộp lề dọc để không lạm dụng việc chỉnh sửa margin một cách tùy tiện khi thấy khoảng cách không tăng như kỳ vọng.
- Tận dụng Specificity một cách khoa học: ưu tiên sử dụng Class selector đồng nhất thay vì lạm dụng ID selector hay từ khóa `!important`.

## References

- [CSS 2.1 Specification: Box model • W3C](https://www.w3.org/TR/CSS2/box.html)
- [CSS 2.1 Specification: Visual formatting model • W3C](https://www.w3.org/TR/CSS2/visuren.html)

## Series

Previous: [Thu thập Dữ liệu Người dùng với HTML Forms](../03-html-forms-and-validation/index.md)
Next: [Đơn vị đo, Typography và Màu sắc trong CSS](../05-units-typography-and-colors/index.md)
