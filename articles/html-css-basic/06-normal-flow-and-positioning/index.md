---
title: "Normal Flow và Điều khiển Vị trí với CSS Positioning"
description: "Tìm hiểu bản chất cơ chế Normal Flow, các giá trị thuộc tính position, quy tắc Containing Block và Stacking Context để kiểm soát hoàn toàn bố cục trang web."

date:
updated:

series: "HTML & CSS Basic"
series_order: 6

tags:
  - css
  - positioning
  - normal-flow
  - beginner

status: draft
language: vi
---

# Normal Flow và Điều khiển Vị trí với CSS Positioning

Chắc hẳn nhiều người khi phát triển giao diện web từng trải qua cảm giác bối rối khi một chiếc tooltip bay lộn xộn ra góc màn hình, hay thanh điều hướng (navbar) bị đè lấp mất nội dung phía dưới dù đã cố gắng đặt `z-index: 9999`. Bạn thử khắc phục bằng cách tăng `margin` âm hoặc tiếp tục nâng `z-index` lên 99999, nhưng giao diện vẫn không hiển thị đúng như mong đợi.

Nguyên nhân cốt lõi không phải do trình duyệt hoạt động sai lệch, mà vì chúng ta chưa hiểu rõ mô hình định vị trực quan (**Visual Formatting Model**) cùng các quy tắc nền tảng của CSS: **Normal Flow**, **Containing Block**, và **Stacking Context**.

## Luồng thông thường (Normal Flow) và các Formatting Context

Mọi phần tử trong cây tài liệu HTML khi hiển thị trên màn hình đều được trình duyệt chuyển đổi thành các hộp chữ nhật theo mô hình hộp. Cơ chế sắp xếp mặc định ban đầu được gọi là **Luồng thông thường (Normal Flow)**, vận hành dựa trên hai ngữ cảnh định dạng chính:

### 1. Block Formatting Context (BFC)
Quản lý các phần tử cấp khối như `<div>`, `<p>`, `<section>` (`display: block`):
- Các hộp khối được xếp chồng lên nhau lần lượt theo chiều dọc từ trên xuống dưới.
- Mép ngoài bên trái của mỗi hộp khối luôn chạm vào mép bên trái của khối chứa nó (`containing block`).
- Khoảng cách dọc giữa hai hộp anh em kề nhau được tính bằng `margin`, và các khoảng lề dọc này sẽ tự động gộp lại (Margin Collapsing).

### 2. Inline Formatting Context (IFC)
Quản lý các phần tử cấp dòng như `<span>`, `<a>`, `<em>` (`display: inline`):
- Các hộp dòng được sắp xếp nối tiếp nhau theo chiều ngang từ trái sang phải bên trong các khung dòng (line boxes).
- Khi các phần tử vượt quá chiều rộng của khung dòng, trình duyệt sẽ tự động ngắt xuống dòng tiếp theo.
- Các thuộc tính `margin-top` và `margin-bottom` không có tác dụng đẩy các dòng văn bản xung quanh ra xa.

## Cơ chế điều khiển vị trí với thuộc tính position

Khi Luồng thông thường không đáp ứng đủ nhu cầu thiết kế giao diện phức tạp, CSS cung cấp thuộc tính `position` để thay đổi thuật toán định vị phần tử. Một phần tử được coi là "đã định vị" (positioned) khi thuộc tính `position` của nó mang giá trị khác `static`.

Các giá trị cốt lõi của `position` bao gồm:

### 1. `position: static` (Mặc định)
Phần tử nằm hoàn toàn trong Luồng thông thường. Các thuộc tính tọa độ `top`, `right`, `bottom`, `left` và `z-index` hoàn toàn **không có tác dụng**.

### 2. `position: relative`
Phần tử vẫn nằm trong Luồng thông thường và giữ nguyên khoảng trống ban đầu của nó trên trang. Sau đó, nó được dịch chuyển tương đối so với chính vị trí ban đầu đó dựa vào tọa độ `top`, `left`... Các phần tử anh em xung quanh không hề bị ảnh hưởng bởi sự dịch chuyển này, dẫn đến khả năng phần tử `relative` sẽ đè lên các phần tử khác.

### 3. `position: absolute`
Phần tử bị **nhấc hoàn toàn ra khỏi Luồng thông thường (out-of-flow)**. Nó không chiếm bất kỳ khoảng trống nào trong dòng chảy tài liệu và không ảnh hưởng đến vị trí của các phần tử anh em. Vị trí của nó được tính toán dựa trên khoảng cách tới các mép của khối chứa gần nhất (**Containing Block**).

### 4. `position: fixed`
Tương tự như `absolute`, nhưng khối chứa (`containing block`) của nó luôn luôn là **khung nhìn màn hình (viewport)**. Phần tử `fixed` sẽ giữ nguyên vị trí cố định trên màn hình ngay cả khi người dùng cuộn trang web (thường dùng cho nút chat hỗ trợ, nút quay lại đầu trang).

### 5. `position: sticky`
Là sự kết hợp thông minh giữa `relative` và `fixed`. Khi cuộn trang, phần tử hoạt động như `relative` trong luồng thông thường cho đến khi chạm vào ngưỡng tọa độ (ví dụ `top: 0`), lúc đó nó sẽ tự động dính chặt vào mép màn hình cho đến khi đi hết phạm vi của phần tử cha.

```css
/* Thanh điều hướng ghim đầu trang khi cuộn */
.navbar {
  position: sticky;
  top: 0;
  width: 100%;
  background-color: #ffffff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}
```

## Mối quan hệ sống còn: Absolute Positioning và Containing Block

Một lỗi kinh điển của người mới học là đặt `position: absolute` cho thẻ con nhưng lại thấy nó bay ra tận mép ngoài màn hình.

**Quy tắc chuẩn của W3C**: Đối với một phần tử `position: absolute`, khung chứa (`containing block`) của nó được xác định bởi **phần tử tổ tiên gần nhất có `position` khác `static`**. Nếu không tìm thấy bất kỳ thẻ cha nào thỏa mãn, nó sẽ mặc định lấy khung chứa ban đầu (initial containing block - gắn với viewport).

Ví dụ tạo huy hiệu thông báo (notification badge) gắn ở góc nút bấm:

```html
<button class="btn">
  Thông báo
  <span class="badge">5</span>
</button>
```

```css
/* 1. Thẻ cha PHẢI có position khác static để làm mốc tọa độ */
.btn {
  position: relative;
  padding: 0.75rem 1.5rem;
  background-color: #1a73e8;
  color: #ffffff;
  border: none;
  border-radius: 4px;
}

/* 2. Thẻ con định vị tuyệt đối theo mốc của .btn */
.badge {
  position: absolute;
  top: -6px;
  right: -6px;
  background-color: #ea4335;
  color: #ffffff;
  font-size: 0.75rem;
  padding: 2px 6px;
  border-radius: 9999px;
}
```

Nếu thiếu `position: relative` trên `.btn`, chiếc badge sẽ bay thẳng lên góc trên cùng của trình duyệt!

## Cơ chế xếp chồng lớp hiển thị: z-index và Stacking Context

Khi các phần tử đè lên nhau, trình duyệt quản lý thứ tự vẽ theo trục Z vuông góc với màn hình thông qua thuộc tính `z-index` và ngữ cảnh xếp chồng (**Stacking Context**).

### Stacking Context là gì?
Stacking Context là một phân vùng xếp chồng độc lập. Một phần tử cha có `position` khác `static` kèm theo `z-index` là một số nguyên sẽ tự tạo ra một Stacking Context mới.

**Đặc tính đóng gói (Atomic)**: Các phần tử nằm trong các Stacking Context khác nhau không thể xen kẽ vào nhau. Nếu phần tử cha A có `z-index: 1` và phần tử cha B có `z-index: 2`, thì dù phần tử con bên trong A có đặt `z-index: 999999` cũng không bao giờ có thể đè lên phần tử B được!

### Thứ tự vẽ chuẩn trong một Stacking Context (từ sau ra trước):
1. Nền (background) và viền (border) của phần tử tạo ngữ cảnh.
2. Các Stacking Context con có `z-index` âm.
3. Các phần tử cấp khối (block-level) không định vị trong luồng thông thường.
4. Các phần tử trôi (`float`).
5. Các phần tử cấp dòng (inline-level) không định vị trong luồng thông thường.
6. Các phần tử định vị có `z-index: 0` (hoặc `auto`).
7. Các phần tử định vị có `z-index` dương (giá trị lớn hơn sẽ nằm đè lên trên).

## Ứng dụng thực tế

- Hãy tận dụng Luồng thông thường (Normal Flow) làm nền tảng chính cho trang web; chỉ sử dụng `position` khi thực sự cần đặt phần tử ra ngoài luồng tự nhiên (như modals, tooltips, dropdowns, sticky header).
- Khi sử dụng `position: absolute`, luôn kiểm tra xem thẻ cha mong muốn đã được đặt `position: relative` hay chưa.
- Khi gặp lỗi đè lớp hiển thị, hãy kiểm tra cây Stacking Context của các phần tử cha thay vì mù quáng tăng `z-index` lên các con số khổng lồ.

## References

- [CSS 2.1 Specification: Visual formatting model • W3C](https://www.w3.org/TR/CSS2/visuren.html)

## Series

Previous: [Đơn vị đo, Typography và Màu sắc trong CSS](../05-units-typography-and-colors/index.md)
Next: [Bố cục 1 Chiều Hiện đại với CSS Flexbox](../07-modern-layout-with-flexbox/index.md)
