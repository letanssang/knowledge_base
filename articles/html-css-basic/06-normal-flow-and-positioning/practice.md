[Lý thuyết](./index.md)

Trong bài thực hành này, bạn sẽ tiến hành thực nghiệm các quy luật định vị trong CSS nhằm kiểm soát hoàn toàn vị trí phần tử trên giao diện, bao gồm:
1. **Sửa lỗi điểm tựa tọa độ (Containing Block)**: Huy hiệu trạng thái (`.badge`) mang `position: absolute; top: -10px; right: -10px;` bị bay ra tận góc trên bên phải của cửa sổ trình duyệt thay vì nằm ở góc thẻ sự kiện (`.event-card`).
2. **Quan sát hành vi trong Normal Flow**: Thấy rõ sự khác biệt giữa `position: relative` (vẫn chiếm chỗ trong luồng, chỉ dời vị trí hiển thị) và `position: absolute` (bị rút hoàn toàn khỏi luồng văn bản).
3. **Thanh điều hướng dính (`position: sticky`)**: Cấu hình thanh menu ghim lại trên đầu màn hình khi cuộn trang và phân tích các điều kiện bắt buộc để thuộc tính này hoạt động.
4. **Xung đột Stacking Context & z-index**: Khám phá lý do vì sao một phần tử con mang `z-index: 9999` vẫn bị đè bẹp dưới phần tử khác khi thẻ cha của nó bị tách vào một Stacking Context riêng biệt.

---

## Mục tiêu và Tiêu chí hoàn thành

### Mục tiêu học tập
- **Bản chất Containing Block**: Nắm vững nguyên tắc xác định điểm tựa tọa độ của `position: absolute` theo chuẩn W3C Visual Formatting Model.
- **Phân biệt 5 giá trị `position`**: Hiểu rõ khi nào phần tử ở trong luồng (`static`, `relative`, `sticky`) và khi nào bị bóc tách khỏi luồng (`absolute`, `fixed`).
- **Làm chủ Stacking Context**: Giải thích được trật tự xếp lớp theo trục Z và mối quan hệ thứ bậc giữa các ngữ cảnh xếp tầng.

### Tiêu chí hoàn thành
1. Sử dụng DevTools để nhận diện Containing Block của `.badge` trước và sau khi thêm `position: relative` cho `.event-card`.
2. Tạo thành công thanh điều hướng ghim (`position: sticky; top: 0;`), cuộn trang kiểm chứng độ bám dính ở mép trên Viewport.
3. Làm thí nghiệm đối chiếu trên 3 khối inline-block: chứng minh `relative` giữ nguyên khoảng trống trong dòng chảy còn `absolute` làm các khối phía sau tràn vào chiếm chỗ.
4. Tạo Stacking Context bằng `opacity: 0.99` trên thẻ cha và giải thích được tại sao `z-index: 9999` của thẻ con mất tác dụng đè lớp bên ngoài.

---

## Chuẩn bị môi trường và file mẫu

File khởi đầu đã được chuẩn bị sẵn tại [assets/practice/starter.html](./assets/practice/starter.html).

Mã nguồn file `assets/practice/starter.html`:

```html
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thực hành CSS Positioning & Normal Flow (Starter)</title>
    <style>
        body {
            font-family: sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 20px;
            background: #f0f2f5;
            min-height: 200vh; /* Tạo chiều dài để kiểm tra cuộn trang */
        }

        /* 1. Thanh điều hướng cần ghim (Sticky Navigation) */
        .sticky-nav {
            background: #001529;
            color: #ffffff;
            padding: 12px 20px;
            border-radius: 6px;
            margin-bottom: 30px;
            /* CỐ Ý ĐỂ STATIC: Cần chuyển sang position: sticky */
        }

        .container {
            max-width: 600px;
            margin: 0 auto;
        }

        /* 2. Thẻ sự kiện: CỐ Ý THIẾU position: relative */
        .event-card {
            background: #ffffff;
            border: 1px solid #d9d9d9;
            padding: 20px;
            border-radius: 8px;
            margin-top: 50px;
        }

        /* Huy hiệu trạng thái bị bay ra góc màn hình */
        .badge {
            position: absolute;
            top: -10px;
            right: -10px;
            background: #f5222d;
            color: #ffffff;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: bold;
        }

        /* 3. Thí nghiệm Normal Flow: Relative vs Absolute */
        .flow-box {
            display: inline-block;
            width: 120px;
            height: 80px;
            margin-right: 15px;
            color: white;
            text-align: center;
            line-height: 80px;
            font-weight: bold;
            border-radius: 6px;
        }

        .box-1 { background: #1890ff; }
        .box-2 { background: #52c41a; }
        .box-3 { background: #722ed1; }
    </style>
</head>
<body>

    <div class="sticky-nav">
        <strong>⚡ Menu Sự Kiện</strong> (Cần ghim cố định khi cuộn trang)
    </div>

    <div class="container">
        <h1>Thực hành CSS Positioning</h1>
        <p>Quan sát hiện tượng huy hiệu màu đỏ "HOT" bị bay ra tít góc trên bên phải của cửa sổ trình duyệt thay vì nằm ở góc thẻ sự kiện.</p>

        <div class="event-card">
            <span class="badge">HOT 🔥</span>
            <h2>Vé Early Bird - Hội thảo Frontend 2026</h2>
            <p>Khám phá công nghệ web mới nhất với các diễn giả hàng đầu. Đăng ký trước 30/10 để nhận ưu đãi 30%.</p>
        </div>

        <h2 style="margin-top: 50px;">Thí nghiệm: Relative vs Absolute trong Normal Flow</h2>
        <div class="flow-box box-1">Khối 1</div>
        <div class="flow-box box-2">Khối 2</div>
        <div class="flow-box box-3">Khối 3</div>
    </div>

</body>
</html>
```

---

## Nhiệm vụ 1: Sửa lỗi Containing Block cho huy hiệu `.badge`

### Mô tả vấn đề
Khi mở file `starter.html`, huy hiệu màu đỏ **HOT 🔥** bị bay ra góc trên bên phải của toàn bộ cửa sổ trình duyệt thay vì nằm ở góc thẻ sự kiện.

### Nguyên nhân kỹ thuật
Theo chuẩn W3C, một phần tử mang `position: absolute` sẽ tìm kiếm tổ tiên gần nhất có thuộc tính `position` khác `static` để làm điểm tựa tọa độ (Containing Block). Vì thẻ cha `.event-card` đang mang `position: static` mặc định, trình duyệt tiếp tục dò ngược lên trên cho đến khi chạm **Initial Containing Block** (chính là Viewport hiển thị của trình duyệt).

### Thao tác sửa lỗi
Thêm `position: relative;` vào thẻ cha `.event-card`:

```css
.event-card {
    position: relative; /* Thiết lập Containing Block cho phần tử con */
    background: #ffffff;
    border: 1px solid #d9d9d9;
    padding: 20px;
    border-radius: 8px;
    margin-top: 50px;
}
```

Tải lại trang: Huy hiệu `.badge` lập tức bám dính chính xác vào góc trên bên phải của thẻ `.event-card`.

---

## Nhiệm vụ 2: Phân tích sự khác biệt giữa `relative` và `absolute` trong Normal Flow

### Thao tác thực nghiệm
1. Mở DevTools (`F12`), nhấp chọn phần tử `<div class="flow-box box-2">Khối 2</div>`.
2. **Thí nghiệm A (`position: relative`)**:
   - Thêm vào tab Styles: `position: relative; top: 30px; left: 30px;`
   - **Quan sát**: Khối 2 dịch chuyển chéo xuống dưới và sang phải. Nhưng khoảng trống ban đầu của Khối 2 vẫn được bảo lưu 100%, Khối 3 đứng sau không hề bị xê dịch.
3. **Thí nghiệm B (`position: absolute`)**:
   - Đổi style thành: `position: absolute; top: 30px; left: 30px;`
   - **Quan sát**: Khối 2 bị bóc tách hoàn toàn khỏi luồng Normal Flow. Khối 3 lập tức dịch chuyển sang trái lấp đầy chỗ trống mà Khối 2 để lại, còn Khối 2 đè lên vị trí mới.

---

## Nhiệm vụ 3: Cấu hình `position: sticky` cho thanh điều hướng

1. Mở file CSS, cập nhật cho `.sticky-nav`:

```css
.sticky-nav {
    background: #001529;
    color: #ffffff;
    padding: 12px 20px;
    border-radius: 6px;
    margin-bottom: 30px;

    position: sticky;
    top: 0; /* Ngưỡng bắt đầu ghim (Threshold) */
    z-index: 100; /* Đảm bảo nổi lên trên các nội dung bên dưới khi cuộn */
}
```

2. Cuộn trang xuống dưới: Quan sát thanh `.sticky-nav` tự động chuyển trạng thái dính chặt vào mép trên màn hình khi chạm ngưỡng `top: 0`.

### 2 điều kiện bắt buộc để `sticky` hoạt động
- **Phải có ít nhất một giá trị ngưỡng offset**: Nếu chỉ khai báo `position: sticky` mà không có `top`, `bottom`, `left` hoặc `right`, phần tử sẽ hoạt động như `static`.
- **Không có thẻ cha nào mang `overflow: hidden`**: Nếu bất kỳ thẻ cha nào bọc ngoài có `overflow: hidden`, `auto`, hoặc `scroll`, phạm vi cuộn của sticky sẽ bị giam hãm bên trong thẻ cha đó thay vì cuộn theo toàn trang.

---

## Nhiệm vụ 4 (Tự làm): Thử nghiệm xung đột z-index và Stacking Context

1. Thêm một khối Modal đè ngoài vào cuối thẻ `<body>`:

```html
<div style="position: fixed; top: 100px; right: 20px; background: #faad14; padding: 15px; z-index: 10; border-radius: 4px;">
    Khung Thông Báo (z-index: 10)
</div>
```

2. Tạo một khung cha chứa một nút bấm có `z-index: 9999`:

```html
<div class="box-stack" style="position: relative; background: white; padding: 20px; margin-top: 30px;">
    <button style="position: absolute; top: 10px; right: 20px; z-index: 9999; background: #1890ff; color: white; padding: 8px 16px;">
        Nút Con (z-index: 9999)
    </button>
</div>
```

3. Thêm thuộc tính `opacity: 0.99;` vào thẻ cha `.box-stack`.
4. **Hiện tượng quan sát**: Nút con mang `z-index: 9999` vẫn bị Khung Thông Báo mang `z-index: 10` che khuất!
5. **Giải thích**: Khi thẻ cha có `opacity < 1`, trình duyệt tự động tạo một **Stacking Context (Ngữ cảnh xếp tầng)** mới. `z-index: 9999` của nút con chỉ có giá trị cạnh tranh nội bộ bên trong thẻ cha, không thể vượt cấp để đè lên các phần tử ở ngữ cảnh xếp tầng bên ngoài.

---

## Bảng đối chiếu 5 giá trị `position` chuẩn W3C

| Giá trị | Nằm trong Normal Flow? | Điểm tựa tọa độ (Containing Block) | Ứng dụng phổ biến |
| :--- | :--- | :--- | :--- |
| **`static`** | Có | Phần tử cha trực tiếp | Bố cục mặc định của trình duyệt. |
| **`relative`** | Có (giữ nguyên chỗ) | Vị trí gốc của chính nó trong Flow | Làm điểm tựa tọa độ cho con, hoặc dịch chuyển vị trí nhẹ. |
| **`absolute`** | Không (rút khỏi Flow) | Phần tử tổ tiên gần nhất có `position != static` | Huy hiệu (badge), dropdown menu, tooltip. |
| **`fixed`** | Không (rút khỏi Flow) | Viewport trình duyệt | Nút chat góc màn hình, nút cuộn lên đầu trang, modal backdrop. |
| **`sticky`** | Cơ chế lai | Khung cuộn gần nhất (Scroll Container) | Thanh menu điều hướng (Navbar), thanh tiêu đề danh mục. |

---

## References

- [W3C CSS 2.1 — Visual formatting model (Positioning schemes)](https://www.w3.org/TR/CSS2/visuren.html#positioning-scheme): Đặc tả chính thức về Normal Flow, Relative, Absolute, Fixed positioning.
- [W3C CSS 2.1 — Layered presentation (z-index & Stacking Context)](https://www.w3.org/TR/CSS2/visuren.html#z-index): Quy chuẩn tính toán thứ tự hiển thị trục Z.
