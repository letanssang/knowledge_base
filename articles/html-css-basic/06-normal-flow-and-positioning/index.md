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

Chắc hẳn nhiều lập trình viên khi mới học CSS từng trải qua những cảm giác bất lực đến phát khóc: 
* Một chiếc chấm đỏ thông báo (Badge) hay menu xổ xuống (Dropdown) bay tít ra tít góc màn hình thay vì nằm gọn ở góc nút bấm.
* Bạn đặt `z-index: 999999` cho chiếc Modal popup nhưng nó vẫn ngoan cố nằm bẹp lép dưới một thanh banner chết tiệt nào đó!

Nguyên nhân không phải do trình duyệt bị lỗi. Mà là vì bạn chưa nắm được 3 định luật vật lý cốt lõi của không gian web: **Dòng chảy tự nhiên (Normal Flow)**, **Điểm tựa tọa độ (Containing Block)**, và **Tầng bậc gia tộc (Stacking Context)**.

---

## 1. Dòng chảy tự nhiên (Normal Flow): Định luật hấp dẫn của Web

Trước khi bạn gõ bất kỳ dòng lệnh định vị vị trí nào, trình duyệt đã có sẵn một quy tắc sắp xếp mặc định gọi là **Normal Flow**:

```text
┌────────────────────────────────────────────────────────┐
│ Block 1: <div>, <p>, <h1>                              │
│ Chiếm trọn 100% bề ngang, xếp chồng lần lượt từ TRÊN   │
│ xuống DƯỚI như các toa tàu xe lửa.                     │
└────────────────────────────────────────────────────────┘
┌────────────────────────────────────────────────────────┐
│ Block 2: <section>                                     │
│  [Inline 1: <span>] [Inline 2: <a>] [Inline 3: <strong>]│
│  Các phần tử Inline xếp nối đuôi nhau từ TRÁI sang     │
│  PHẢI, khi hết dòng thì tự động rớt xuống dòng kế tiếp.│
└────────────────────────────────────────────────────────┘
```

Mọi trang web đều bắt đầu từ trật tự tự nhiên này. Nhưng khi bạn muốn một phần tử "bất tuân quy luật" (như ghim menu trên đầu trang hay đặt nút chat góc dưới), bạn cần dùng đến thuộc tính **`position`**.

---

## 2. Giải mã 5 giá trị của thuộc tính `position`

Hãy hình dung các giá trị của `position` giống như trạng thái chuyển động của một người:

```text
┌───────────────┬───────────────────────┬────────────────────────────────────────────────────────┐
│ Giá trị       │ Trạng thái trong Flow │ Cách thức hoạt động                                    │
├───────────────┼───────────────────────┼────────────────────────────────────────────────────────┤
│ static        │ Trong dòng chảy       │ Mặc định. Đi bộ bình thường. top/left/z-index vô tác dụng.│
│ relative      │ Trong dòng chảy       │ Bước lệch sang bên cạnh, nhưng "cái bóng" vẫn giữ chỗ cũ. │
│ absolute      │ BAY KHỎI DÒNG CHẢY    │ Nhấc bổng lên không trung, bay theo mốc của Cha gần nhất.│
│ fixed         │ BAY KHỎI DÒNG CHẢY    │ Dính chặt vào màn hình (Viewport), cuộn trang không đổi. │
│ sticky        │ Lai giữa relative & fixed│ Đi bộ bình thường, khi chạm mép màn hình thì dính lại. │
└───────────────┴───────────────────────┴────────────────────────────────────────────────────────┘
```

### 1. `position: static` (Mặc định)
Phần tử đứng ngoan ngoãn theo dòng chảy tự nhiên. Lúc này, các thuộc tính tọa độ `top`, `right`, `bottom`, `left` và `z-index` **hoàn toàn vô tác dụng**.

### 2. `position: relative` (Dịch chuyển tương đối)
Phần tử vẫn giữ nguyên một khoảng trống của nó trong trang (các phần tử xung quanh không bị xô lệch). Sau đó, nó tự dịch chuyển vị trí của mình một đoạn dựa trên tọa độ:
```css
.box {
  position: relative;
  top: 10px;  /* Nhích xuống dưới 10px so với vị trí gốc của nó */
  left: 20px; /* Nhích sang phải 20px */
}
```

### 3. `position: absolute` (Bay khỏi dòng chảy)
Phần tử bị **nhấc bổng hoàn toàn ra khỏi mặt đất (Out of flow)**:
* Nó **không còn chiếm chỗ**: Các phần tử đứng sau sẽ lập tức tràn lên lấp vào khoảng trống mà nó vừa bỏ lại như thể nó chưa từng tồn tại!
* Tọa độ `top: 0`, `left: 0` của nó sẽ được tính theo **Điểm tựa (Containing Block)** gần nhất.

### 4. `position: fixed` (Ghim cố định)
Giống như `absolute`, nó cũng bay khỏi dòng chảy, nhưng điểm tựa của nó luôn luôn là **khung nhìn màn hình (Viewport)**. Dù bạn có cuộn chuột xuống 10.000 pixel, phần tử này vẫn nằm nguyên tại vị trí đó (rất hay dùng cho: Nút chat Zalo, Nút cuộn lên đầu trang).

### 5. `position: sticky` (Thanh dính thông minh)
Rất hay dùng cho thanh Menu (Header): Khi bạn ở đầu trang, nó nằm ngoan ngoãn như bình thường. Nhưng khi bạn cuộn trang xuống chạm đến mép màn hình (`top: 0`), nó sẽ **tự động biến thành fixed** và bám chặt vào mép trên màn hình!

```css
.navbar {
  position: sticky;
  top: 0; /* Khi mép trên chạm vào đỉnh màn hình thì dính lại */
  background: white;
}
```

---

## 3. Cặp đôi huyền thoại: Cha `relative` - Con `absolute`

Đây là bí kíp mà 100% lập trình viên frontend đều dùng hàng ngày để làm các huy hiệu (Badge) hoặc Tooltip:

```text
┌────────────────────────────────────┐
│ .button (position: relative)   ◄───┼── Chiếc hộp làm CỘT MỐC TỌA ĐỘ (0,0)
│                                    │
│       [ Nút Thông Báo ]     ┌─────┐│
│                             │  5  │├─► .badge (position: absolute; top: -8px; right: -8px)
│                             └─────┘│   Bay tự do nhưng NEO CHẶT VÀO GÓC của nút!
└────────────────────────────────────┘
```

```html
<button class="btn">
  Thông báo
  <span class="badge">5</span>
</button>
```

```css
/* BƯỚC 1: Đặt cha làm Mốc tọa độ */
.btn {
  position: relative; 
  padding: 10px 20px;
}

/* BƯỚC 2: Cho con bay theo mốc của cha */
.badge {
  position: absolute;
  top: -8px;
  right: -8px;
  background: red;
  color: white;
  border-radius: 50%;
}
```

> [!CAUTION]
> ### Nếu quên `position: relative` ở thẻ cha thì sao?
> Trình duyệt sẽ đi tìm ngược lên ông bà, tổ tiên xem ai có `position`. Nếu không thấy ai có, thẻ con sẽ coi **toàn bộ màn hình trình duyệt** là mốc tọa độ và bay thẳng lên góc trên cùng của website!

---

## 4. Bí ẩn `z-index: 9999` không đè được: Cuộc chiến gia tộc (Stacking Context)

Tại sao bạn đặt `z-index: 999999` cho chiếc Modal con nhưng nó vẫn bị thẻ khác đè lên?

Hãy nhớ câu chuyện **"Phân cấp gia tộc"**:
* Gia tộc B có quyền lực cấp 2 (`z-index: 2`).
* Gia tộc A có quyền lực cấp 1 (`z-index: 1`).
* Dù đứa con trong gia tộc A có xưng bá xưng vương, tự nhận mình có quyền lực `z-index: 999999`, thì khi bước ra xã hội, **nó vẫn phải đứng sau gia tộc B!**

```text
         TRÌNH DUYỆT XẾP LỚP (Từ dưới lên trên)
▲
│  ┌──────────────────────────────┐
│  │ Gia tộc B (z-index: 2)       │  ◄── NẰM TRÊN CÙNG
│  └──────────────────────────────┘
│  ┌──────────────────────────────┐
│  │ Gia tộc A (z-index: 1)       │  ◄── BỊ ĐÈ BÊN DƯỚI
│  │   └── Đứa con (z-index: 9999)│  ◄── Bị giam lỏng bên trong A, không thoát ra được!
│  └──────────────────────────────┘
```

Trong CSS, hiện tượng này gọi là **Stacking Context (Ngữ cảnh xếp chồng)**:
* Khi một phần tử cha có `position` khác `static` kèm theo `z-index`, nó tạo thành một "Gia tộc độc lập".
* Toàn bộ các thẻ con bên trong chỉ so kè độ cao với nhau trong nội bộ gia tộc đó. Khi so sánh với phần tử bên ngoài, trình duyệt chỉ so sánh chỉ số `z-index` của hai phần tử cha!

> [!TIP]
> ### Cách sửa lỗi z-index bị đè
> Đừng cố tăng `z-index` của thẻ con lên 99999. Hãy mở DevTools kiểm tra xem **phần tử cha bao bọc nó** đang có `z-index` là bao nhiêu so với phần tử đang đè lên nó!

---

## 5. Tổng kết

* **Normal Flow**: Trật tự mặc định (Block từ trên xuống, Inline từ trái sang).
* **position: relative**: Tự dịch chuyển nhưng vẫn giữ chỗ cũ.
* **position: absolute**: Bay khỏi dòng chảy, cần tìm thẻ cha có `position: relative` để làm mốc tọa độ.
* **position: fixed**: Ghim chặt vào cửa sổ màn hình (Viewport).
* **z-index & Stacking Context**: Muốn đè lên nhau, hãy so sánh quyền lực từ cấp phần tử cha!

---

## References

- [CSS 2.1 Specification: Visual formatting model • W3C](https://www.w3.org/TR/CSS2/visuren.html)
- [The Stacking Context • MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_positioned_layout/Understanding_z-index/Stacking_context)

---

## Series

- Previous: [Đơn vị đo, Typography và Màu sắc trong CSS](../05-units-typography-and-colors/index.md)
- [Thực hành](./practice.md)
- Next: [Bố cục 1 Chiều Hiện đại với CSS Flexbox](../07-modern-layout-with-flexbox/index.md)

