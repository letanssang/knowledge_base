[Lý thuyết](./index.md)

Trong bài thực hành này, bạn sẽ tiến hành xây dựng **Thanh điều hướng (Navigation Bar)** và **Thanh công cụ lọc/tìm kiếm sự kiện (Event Toolbar)** bằng CSS Flexbox, đồng thời giải quyết các bài toán căn chỉnh và chống tràn hàng phổ biến trên web:
1. **Khởi tạo Flex Formatting Context**: Đưa Logo, menu liên kết và nút kêu gọi hành động (CTA) lên cùng một hàng ngang, căn giữa trục dọc và phân bổ không gian ra hai đầu mép.
2. **Chống tràn hàng (Flex Wrapping)**: Xử lý tình trạng vỡ khung khi tiêu đề menu dài ra hoặc khi màn hình thu hẹp về `450px` bằng `flex-wrap: wrap` và `gap`.
3. **Làm chủ bộ ba co giãn (`flex-grow`, `flex-shrink`, `flex-basis`)**: Cấu hình ô tìm kiếm tự động giãn nở chiếm trọn không gian trống còn lại (`flex: 1`), trong khi các nút lọc giữ nguyên kích thước nội dung (`flex: 0 0 auto`).
4. **Hoán đổi trục trên thiết bị di động**: Đổi trục chính sang chiều dọc với `flex-direction: column` và kiểm chứng sự tráo đổi vai trò giữa `justify-content` và `align-items`.

---

## Mục tiêu và Tiêu chí hoàn thành

### Mục tiêu học tập
- **Bản đồ 2 trục tọa độ (Main Axis & Cross Axis)**: Hiểu rõ cơ chế điều phối không gian của `justify-content` (trục chính) và `align-items` (trục phụ).
- **Bộ ba Flexibility**: Nắm vững nguyên lý phân bổ không gian tự do của `flex-grow`, cơ chế co hẹp chống tràn của `flex-shrink`, và kích thước cơ sở `flex-basis`.
- **Đa hàng (Multi-line Flexbox)**: Phân biệt `flex-wrap: nowrap` và `flex-wrap: wrap`, tận dụng thuộc tính `gap` hiện đại thay cho margin thủ công.

### Tiêu chí hoàn thành
1. Kích hoạt `display: flex` cho `.navbar`, đưa Logo về bên trái và cụm menu/nút bấm về bên phải bằng `justify-content: space-between`.
2. Căn giữa chuẩn xác tất cả phần tử theo chiều cao bằng `align-items: center`, loại bỏ hoàn toàn các lỗi lệch dòng của `inline-block`.
3. Cấu hình ô tìm kiếm với `flex: 1` để tự động lấp đầy phần diện tích còn trống trong thanh công cụ.
4. Kích hoạt `flex-wrap: wrap` và `gap: 12px`, kiểm tra trên khung hẹp `450px` để xác nhận các nút tự động xuống hàng ngay ngắn mà không bị tràn mép ngang.
5. Viết Media Query cho màn hình nhỏ (`max-width: 600px`), chuyển sang `flex-direction: column` và kéo giãn toàn bộ phần tử với `align-items: stretch`.

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
    <title>Thực hành CSS Flexbox (Starter)</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: sans-serif;
            line-height: 1.6;
            padding: 20px;
            background: #f8fafc;
            color: #1e293b;
        }

        /* 1. THANH ĐIỀU HƯỚNG BAN ĐẦU: Chưa kích hoạt Flexbox */
        .navbar {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 12px 20px;
            margin-bottom: 30px;
        }

        .logo {
            font-size: 1.3rem;
            font-weight: bold;
            color: #2563eb;
        }

        .nav-links {
            list-style: none;
        }

        .nav-links li a {
            text-decoration: none;
            color: #475569;
            font-weight: 500;
            padding: 6px 12px;
            border-radius: 4px;
        }

        .nav-links li a:hover {
            background: #eff6ff;
            color: #2563eb;
        }

        .btn-cta {
            background: #2563eb;
            color: #ffffff;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
        }

        /* 2. THANH CÔNG CỤ SỰ KIỆN */
        .toolbar {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 20px;
        }

        .search-input {
            padding: 8px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            font-size: 0.95rem;
        }

        .filter-btn {
            background: #f1f5f9;
            border: 1px solid #cbd5e1;
            padding: 8px 14px;
            border-radius: 6px;
            cursor: pointer;
            white-space: nowrap;
        }

        /* Khung co hẹp mô phỏng màn hình nhỏ */
        .preview-container {
            max-width: 450px;
            border: 2px dashed #94a3b8;
            padding: 15px;
            border-radius: 8px;
            background: #ffffff;
            margin-top: 20px;
        }
    </style>
</head>
<body>

    <h1>Thực hành CSS Flexbox</h1>
    <p style="margin-bottom: 20px;">Dưới đây là giao diện thanh điều hướng và thanh tìm kiếm cần hoàn thiện bằng Flexbox.</p>

    <!-- THANH ĐIỀU HƯỚNG CHÍNH -->
    <header class="navbar">
        <div class="logo">Frontend2026 🌐</div>
        <ul class="nav-links">
            <li><a href="#">Trang chủ</a></li>
            <li><a href="#">Lịch trình hội thảo</a></li>
            <li><a href="#">Diễn giả tiêu biểu</a></li>
            <li><a href="#">Tài liệu hội thảo</a></li>
        </ul>
        <button class="btn-cta">Mua vé ngay</button>
    </header>

    <!-- THANH TÌM KIẾM & BỘ LỌC -->
    <h2>Thanh công cụ (Thử nghiệm flex-grow & flex-shrink)</h2>
    <div class="toolbar">
        <input type="text" class="search-input" placeholder="Tìm kiếm phiên thuyết trình hoặc diễn giả...">
        <button class="filter-btn">Bộ lọc</button>
        <button class="filter-btn">Hôm nay</button>
        <button class="filter-btn">Phổ biến nhất</button>
    </div>

    <!-- KHUNG THỬ NGHIỆM MÀN HÌNH NHỎ (450PX) -->
    <h2>Thử nghiệm chống tràn trên khung hẹp (450px)</h2>
    <div class="preview-container">
        <div class="toolbar" style="margin: 0;">
            <input type="text" class="search-input" placeholder="Tìm nhanh...">
            <button class="filter-btn">Tất cả</button>
            <button class="filter-btn">VIP</button>
        </div>
    </div>

</body>
</html>
```

---

## Nhiệm vụ 1: Khởi tạo Flex Formatting Context và Căn chỉnh Trục cho Navbar

1. Mở file `starter.html` và chỉnh sửa CSS cho `.navbar`:
   - Kích hoạt Flexbox: `display: flex;`
   - Phân bổ không gian trục chính: `justify-content: space-between;` (đẩy logo về đầu mép trái, nút mua vé về mép phải).
   - Căn giữa trục phụ: `align-items: center;` (căn đều chiều cao giữa logo, chữ và nút bấm).
2. Chỉnh sửa nhóm menu `.nav-links`:
   - Kích hoạt Flexbox: `display: flex;`
   - Tạo khoảng cách giữa các mục menu bằng `gap: 15px;` (không dùng margin thủ công).
   - Đảm bảo căn giữa: `align-items: center;`

### Đoạn mã CSS cập nhật
```css
.navbar {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    padding: 12px 20px;
    margin-bottom: 30px;

    display: flex;
    justify-content: space-between;
    align-items: center;
}

.nav-links {
    list-style: none;
    display: flex;
    gap: 15px;
    align-items: center;
}
```

Tải lại trang: Toàn bộ thanh điều hướng đã nằm ngay ngắn trên một hàng ngang duy nhất với khoảng cách hoàn hảo.

---

## Nhiệm vụ 2: Xử lý tràn nội dung và co giãn tự động với `flex-wrap`

Theo chuẩn W3C, thuộc tính mặc định của Flex Container là `flex-wrap: nowrap`. Khi danh sách liên kết kéo dài hoặc khi mở trang trên màn hình hẹp, các phần tử con sẽ bị ép dẹp lại (`flex-shrink`) hoặc tràn ra khỏi mép khung chứa.

### Thao tác xử lý
1. Thêm `flex-wrap: wrap;` và `gap: 12px;` vào `.navbar` và `.nav-links`.
2. Kiểm tra trên khung thử nghiệm `.preview-container` (rộng 450px). Khi không gian không còn đủ cho cả 3 nút bấm, các nút phía sau sẽ tự động rớt xuống dòng thứ 2 một cách mượt mà mà không làm vỡ giao diện.

```css
.navbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;
}

.nav-links {
    list-style: none;
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 10px;
}
```

---

## Nhiệm vụ 3: Làm chủ bộ ba `flex-grow`, `flex-shrink`, `flex-basis` trên Toolbar

Trong thanh công cụ tìm kiếm `.toolbar`, chúng ta muốn:
- Ô nhập liệu `.search-input` tự động giãn rộng ra để chiếm trọn toàn bộ không gian còn trống.
- Các nút bấm `.filter-btn` giữ nguyên kích thước vừa khít với nội dung chữ của chúng.

### Thao tác cấu hình
```css
.toolbar {
    background: #ffffff;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    padding: 16px;
    margin-bottom: 20px;

    display: flex;
    align-items: center;
    gap: 12px;
    flex-wrap: wrap;
}

/* Ô tìm kiếm nhận toàn bộ không gian trống còn dư */
.search-input {
    padding: 8px 14px;
    border: 1px solid #cbd5e1;
    border-radius: 6px;
    font-size: 0.95rem;

    flex: 1 1 200px; /* flex-grow: 1, flex-shrink: 1, flex-basis: 200px */
}

/* Các nút lọc giữ kích thước cố định theo nội dung */
.filter-btn {
    background: #f1f5f9;
    border: 1px solid #cbd5e1;
    padding: 8px 14px;
    border-radius: 6px;
    cursor: pointer;
    white-space: nowrap;

    flex: 0 0 auto; /* Không co, không giãn, kích thước tự động theo nội dung */
}
```

**Nguyên lý W3C**:
- `flex: 1 1 200px`: Ô tìm kiếm có kích thước cơ sở ban đầu là `200px`. Bất kỳ khoảng trống nào còn dư trong hàng sẽ được thuật toán Flex Layout ưu tiên phân bổ thêm cho ô tìm kiếm (`flex-grow: 1`).
- `flex: 0 0 auto`: Các nút lọc từ chối nhận thêm khoảng trống (`flex-grow: 0`) và từ chối bị ép nhỏ lại (`flex-shrink: 0`), giúp chữ trong nút không bao giờ bị cắt cụt.

---

## Nhiệm vụ 4 (Tự làm): Tối ưu Mobile với `flex-direction: column`

Hãy viết thêm đoạn mã Media Query cho màn hình nhỏ dưới `600px`:

```css
@media (max-width: 600px) {
    .navbar {
        flex-direction: column; /* Đổi trục chính sang chiều dọc */
        align-items: stretch;   /* Kéo giãn các thành phần phủ kín chiều ngang */
    }

    .nav-links {
        flex-direction: column;
        width: 100%;
        gap: 8px;
    }

    .nav-links li,
    .nav-links a {
        display: block;
        text-align: center;
        width: 100%;
    }

    .btn-cta {
        width: 100%;
    }

    .toolbar {
        flex-direction: column;
        align-items: stretch;
    }

    .search-input,
    .filter-btn {
        width: 100%;
    }
}
```

### Hiện tượng quan sát và Giải thích
- Khi `flex-direction: column`, **Trục chính (Main Axis)** trở thành trục dọc (từ trên xuống), và **Trục phụ (Cross Axis)** trở thành trục ngang (từ trái sang phải).
- Lúc này, `align-items: stretch` sẽ kéo giãn tất cả các nút bấm và ô tìm kiếm phủ kín 100% chiều ngang màn hình, tạo nên giao diện di động hoàn hảo.

---

## Bảng đối chiếu thuộc tính Flex Container vs Flex Item (W3C)

| Đối tượng tác động | Thuộc tính | Giá trị phổ biến | Ý nghĩa kỹ thuật |
| :--- | :--- | :--- | :--- |
| **Flex Container (Thẻ cha)** | `display` | `flex`, `inline-flex` | Kích hoạt ngữ cảnh Flex Formatting Context cho các con trực tiếp. |
| | `flex-direction` | `row`, `column`, `row-reverse` | Thiết lập hướng của Trục chính (Main Axis). |
| | `justify-content` | `flex-start`, `center`, `space-between` | Phân bổ khoảng trống thừa dọc theo Trục chính. |
| | `align-items` | `stretch`, `center`, `flex-start` | Căn chỉnh các phần tử con dọc theo Trục phụ (Cross Axis). |
| | `flex-wrap` | `nowrap`, `wrap` | Cho phép các phần tử tự động ngắt dòng khi thiếu không gian. |
| | `gap` | `<length>` (ví dụ `12px`) | Khoảng cách tự nhiên giữa các phần tử con. |
| **Flex Item (Thẻ con)** | `flex-grow` | Số nguyên không âm (`0`, `1`) | Tỷ lệ nhận thêm không gian tự do thừa. |
| | `flex-shrink` | Số nguyên không âm (`0`, `1`) | Tỷ lệ co hẹp kích thước khi không gian bị thiếu. |
| | `flex-basis` | `auto`, `<length>` | Kích thước cơ sở ban đầu trước khi tính co giãn. |
| | `flex` | `1`, `0 0 auto`, `initial` | Cú pháp viết tắt gom `grow`, `shrink`, `basis`. |
| | `align-self` | `auto`, `center`, `flex-end` | Tự căn chỉnh riêng cho bản thân, ghi đè `align-items` của cha. |

---

## References

- [W3C CSS Flexible Box Layout Module Level 1](https://www.w3.org/TR/css-flexbox-1/): Đặc tả quy chuẩn chính thức của CSS Flexbox.
- [W3C CSS Box Alignment Module Level 3](https://www.w3.org/TR/css-align-3/): Tiêu chuẩn căn chỉnh `justify-content`, `align-items`, và `gap`.
