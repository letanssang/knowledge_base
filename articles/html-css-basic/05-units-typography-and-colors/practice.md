[Lý thuyết](./index.md)

Trong bài thực hành này, bạn sẽ tiến hành chuẩn hóa hệ thống đơn vị đo lường (Typographic Scale) và bảng màu sắc cho trang thông báo sự kiện, khắc phục 3 hạn chế phổ biến khi sử dụng CSS:
1. **Thiếu khả năng co giãn trợ năng (Accessibility)**: Font chữ dùng đơn vị `px` cố định khiến giao diện không thể tự động phóng to khi người dùng thay đổi kích thước chữ mặc định trong cài đặt trình duyệt.
2. **Hiện tượng phình to cấp số nhân (Compounding Effect)**: Đặt `font-size` bằng đơn vị `em` trên danh sách lồng nhau (nested list) khiến cỡ chữ các cấp con bị phóng đại quá mức.
3. **Mã màu HEX khó bảo trì**: Khó tự tính toán các biến thể màu nhạt làm nền hoặc màu tối hơn khi người dùng di chuột qua nút bấm (`:hover`).

---

## Mục tiêu và Tiêu chí hoàn thành

### Mục tiêu học tập
- **Nắm vững bản chất `rem` vs `em` vs `px`**: Hiểu rõ đối tượng quy chiếu của từng đơn vị theo chuẩn W3C CSS Values and Units Level 4.
- **Xử lý hiện tượng Compounding**: Phân biệt trường hợp nên dùng `rem` (thiết lập font-size toàn trang) và khi nào dùng `em` (padding/margin co giãn theo component).
- **Làm chủ hệ màu HSL**: Xây dựng bảng màu linh hoạt bằng cách giữ nguyên Hue/Saturation và điều chỉnh Lightness.

### Tiêu chí hoàn thành
1. Chuyển đổi toàn bộ thang đo font chữ từ `px` sang `rem`, giữ nguyên tỷ lệ hiển thị ở mức font mặc định `16px`.
2. Khắc phục triệt để lỗi phình to cỡ chữ ở danh sách đa cấp bằng cách đưa `font-size` của các thẻ con về `rem`.
3. Ứng dụng `em` cho `padding` của nút bấm để khoảng đệm tự động co giãn theo cỡ chữ nút.
4. Thay thế mã màu HEX bằng hệ màu HSL có biến thể nền nhạt (Lightness 96%), viền (Lightness 80%) và hover (Lightness 40%).
5. Dùng DevTools tab **Computed** kiểm chứng: Khi tăng font gốc `html` lên `20px`, toàn bộ cỡ chữ `rem` và padding `em` tự động phóng to tỷ lệ tương ứng.

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
    <title>Thực hành CSS Units, Typography & Colors (Starter)</title>
    <style>
        /* 1. Font chữ đặt tĩnh bằng PX */
        body {
            font-family: Arial, sans-serif;
            font-size: 16px;
            line-height: 1.5;
            margin: 20px;
            background: #f8f9fa;
            color: #212529;
        }

        h1 {
            font-size: 32px;
            margin-bottom: 10px;
        }

        h2 {
            font-size: 24px;
            margin-top: 25px;
        }

        /* 2. Hiện tượng Compounding của EM trên danh sách lồng nhau */
        .nested-list {
            background: #ffffff;
            border: 1px solid #dee2e6;
            padding: 20px 40px;
            border-radius: 6px;
        }

        .nested-list li {
            font-size: 1.25em;
            margin: 8px 0;
        }

        /* 3. Nút bấm dùng mã màu HEX cố định, padding bằng PX */
        .btn-register {
            background-color: #1890ff;
            color: #ffffff;
            border: 1px solid #096dd9;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            border-radius: 4px;
        }

        .btn-register:hover {
            background-color: #096dd9;
        }

        .card-event {
            background: #e6f7ff;
            border: 1px solid #91d5ff;
            padding: 15px;
            margin-top: 20px;
            border-radius: 6px;
        }
    </style>
</head>
<body>

    <h1>Hội thảo Web Frontend 2026</h1>
    <p>Trang thông báo sự kiện sử dụng đơn vị tĩnh px và màu HEX ban đầu.</p>

    <h2>1. Thí nghiệm: Hiện tượng phình to cỡ chữ (Compounding EM)</h2>
    <ul class="nested-list">
        <li>Cấp 1: Chủ đề Frontend
            <ul>
                <li>Cấp 2: Kiến trúc Web hiện đại
                    <ul>
                        <li>Cấp 3: Tối ưu hiệu năng rendering</li>
                    </ul>
                </li>
            </ul>
        </li>
    </ul>

    <h2>2. Thí nghiệm: Nút bấm và Thẻ sự kiện</h2>
    <div class="card-event">
        <h3>Đăng ký giữ chỗ sớm</h3>
        <p>Tham gia để nhận vé mời VIP cùng tài liệu chuyên sâu từ các chuyên gia.</p>
        <button class="btn-register">Đăng ký tham dự</button>
    </div>

</body>
</html>
```

---

## Nhiệm vụ 1: Chuẩn hóa Typographic Scale bằng `rem`

Theo chuẩn W3C, `rem` tham chiếu trực tiếp đến `font-size` của phần tử gốc `<html>` (`:root`). Mặc định trên mọi trình duyệt, giá trị này là `16px`.

Quy đổi các kích thước `px` sang `rem` theo tỷ lệ $\text{rem} = \text{px} / 16$:
- `body`: `16px` $\rightarrow$ `1rem`
- `h1`: `32px` $\rightarrow$ `2rem`
- `h2`: `24px` $\rightarrow$ `1.5rem`
- `h3`: `18.72px` $\rightarrow$ `1.17rem`

### Thao tác cập nhật CSS
```css
body {
    font-size: 1rem; /* 16px */
}

h1 {
    font-size: 2rem; /* 32px */
}

h2 {
    font-size: 1.5rem; /* 24px */
}
```

---

## Nhiệm vụ 2: Phân tích hiện tượng Compounding của `em` và ứng dụng đúng chỗ

### 1. Phân tích hiện tượng phình to cấp số nhân
Khi đặt `font-size` bằng đơn vị `em`, giá trị sẽ nhân với `font-size` kế thừa từ phần tử cha:
- **Cấp 1 (`ul > li`)**: $16\text{px} \times 1.25 = 20\text{px}$
- **Cấp 2 (`ul > li > ul > li`)**: $20\text{px} \times 1.25 = 25\text{px}$
- **Cấp 3 (`... > li`)**: $25\text{px} \times 1.25 = 31.25\text{px}$ (chữ cấp con to gần bằng thẻ `h1`!)

**Giải pháp**: Đưa `font-size` của `li` về dùng `rem` để giữ kích thước chữ ổn định:

```css
.nested-list li {
    font-size: 1rem;
    margin: 8px 0;
}
```

### 2. Ứng dụng `em` đúng mục đích cho Padding nút bấm
Khi áp dụng cho khoảng đệm (`padding`) hoặc khoảng lề (`margin`), đơn vị `em` tham chiếu đến `font-size` của chính phần tử đó. Điều này giúp nút bấm tự động co giãn tỷ lệ khi ta tăng giảm kích thước chữ của nút:

```css
.btn-register {
    font-size: 1rem; /* 16px */
    /* Padding tự động co giãn theo cỡ chữ: dọc 10px, ngang 20px */
    padding: 0.625em 1.25em;
}
```

---

## Nhiệm vụ 3: Thay thế màu HEX bằng hệ màu HSL linh hoạt

Hệ màu HSL (Hue, Saturation, Lightness) cho phép bạn giữ nguyên Sắc màu (Hue) và Độ bão hòa (Saturation), chỉ cần thay đổi Độ sáng (Lightness) để tạo ra các sắc thái khác nhau:
- **Hue**: `210` (Màu xanh dương)
- **Saturation**: `100%`
- **Màu chính**: `hsl(210, 100%, 50%)`
- **Nền nhạt**: `hsl(210, 100%, 96%)`
- **Đường viền**: `hsl(210, 100%, 80%)`
- **Hover nút**: Chỉ cần giảm Lightness xuống 40%: `hsl(210, 100%, 40%)`

### Cập nhật mã nguồn bằng biến CSS (CSS Custom Properties)
```css
:root {
    --brand-hue: 210;
    --brand-sat: 100%;
    
    --color-primary: hsl(var(--brand-hue), var(--brand-sat), 50%);
    --color-primary-hover: hsl(var(--brand-hue), var(--brand-sat), 40%);
    --color-bg-light: hsl(var(--brand-hue), var(--brand-sat), 96%);
    --color-border: hsl(var(--brand-hue), var(--brand-sat), 80%);
}

.btn-register {
    background-color: var(--color-primary);
    color: #ffffff;
    border: none;
    border-radius: 4px;
    padding: 0.625em 1.25em;
    cursor: pointer;
}

.btn-register:hover {
    background-color: var(--color-primary-hover);
}

.card-event {
    background: var(--color-bg-light);
    border: 1px solid var(--color-border);
    padding: 1.25rem;
    border-radius: 6px;
}
```

---

## Nhiệm vụ 4 (Tự làm): Thử nghiệm trợ năng trong DevTools

1. Mở file HTML đã hoàn thiện trong trình duyệt Chrome/Edge.
2. Mở DevTools (`F12`), chọn thẻ `<html>`.
3. Trong tab **Styles**, thử ghi đè tạm thời:
   ```css
   html {
       font-size: 20px;
   }
   ```
4. Chuyển sang tab **Computed** và ghi nhận các thông số đo được thực tế:

| Thẻ / Phần tử | Giá trị khai báo CSS | Giá trị ban đầu (Root = 16px) | Giá trị sau khi phóng to (Root = 20px) | Kết luận |
| :--- | :--- | :--- | :--- | :--- |
| `body` | `1rem` | `16px` | `20px` | Tự động tăng cỡ chữ |
| `h1` | `2rem` | `32px` | `40px` | Tiêu đề phóng to mượt mà |
| `h2` | `1.5rem` | `24px` | `30px` | Duy trì đúng thang tỷ lệ |
| `.btn-register` (padding) | `0.625em 1.25em` | `10px 20px` | `12.5px 25px` | Vùng bấm tự động mở rộng theo chữ |

---

## Bảng đối chiếu đơn vị chuẩn W3C

| Đơn vị | Phân loại | Tham chiếu đối tượng | Trường hợp sử dụng tối ưu |
| :--- | :--- | :--- | :--- |
| **`px`** | Tuyệt đối ($1\text{px} = 1/96\text{in}$) | Màn hình hiển thị cố định | Viền siêu mảnh (`border: 1px`), hiệu ứng bóng đổ (`box-shadow`). |
| **`rem`** | Tương đối (Root EM) | `font-size` của thẻ `<html>` | Cỡ chữ văn bản (`font-size`), khoảng cách bố cục lớn (`margin`, `padding` khung). |
| **`em`** | Tương đối (Element EM) | `font-size` của chính phần tử hoặc cha | Padding/margin nút bấm, khoảng cách icon gắn liền với chữ. |

---

## References

- [W3C CSS Values and Units Module Level 4](https://www.w3.org/TR/css-values-4/): Đặc tả chính thức về đơn vị độ dài tuyệt đối và tương đối.
- [W3C CSS Color Module Level 4](https://www.w3.org/TR/css-color-4/): Tiêu chuẩn về các hàm biểu diễn màu sắc RGB, HSL và HWB.
