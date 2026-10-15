[Lý thuyết](./index.md)

Trong bài thực hành này, bạn sẽ tiến hành chẩn đoán và khắc phục 3 sự cố thường gặp nhất trong lập trình giao diện CSS:
1. **Lỗi vỡ hàng (Layout Overflow/Wrapping)**: Hai thẻ sự kiện (`.card`) được đặt trong khung chứa rộng `600px`. Dù mỗi thẻ chỉ khai báo `width: 300px`, thẻ thứ hai vẫn bị đẩy rớt xuống dòng dưới do cơ chế tính toán mặc định của Box Model.
2. **Xung đột độ ưu tiên (CSS Specificity Conflict)**: Khai báo màu sắc của class `.card-title` bị một bộ chọn khác có trọng số cao hơn (`#event-section .title`) ghi đè.
3. **Hiện tượng gộp lề (Margin Collapsing)**: Hai khối dọc liền kề có `margin-bottom: 25px` và `margin-top: 25px`, nhưng khoảng cách thực tế đo được chỉ là `25px` thay vì `50px`.

---

## Mục tiêu và Tiêu chí hoàn thành

### Mục tiêu học tập
- **Bản chất Box Model**: Phân biệt tường minh giữa `content-box` (mặc định) và `border-box`, nắm vững công thức tính kích thước thực tế hiển thị trên màn hình.
- **Phân tích Cascade & Specificity**: Sử dụng DevTools để đọc quy tắc bị gạch ngang (strikethrough) và tính điểm trọng số độ ưu tiên.
- **Cơ chế Margin Collapsing**: Nắm vững nguyên tắc gộp lề dọc giữa các phần tử anh em liền kề và giữa phần tử cha với phần tử con.

### Tiêu chí hoàn thành
1. Mở DevTools tab **Computed**, kiểm tra sơ đồ Box Model trực quan và giải thích được vì sao thẻ con có kích thước thực tế `344px` dù khai báo `width: 300px`.
2. Áp dụng chuẩn xác CSS Reset `box-sizing: border-box` để đưa hai thẻ card về nằm song song trên cùng một hàng trong khung `600px`.
3. Tính toán chính xác điểm Specificity giữa 2 bộ chọn xung đột và khắc phục để màu mong muốn được áp dụng mà không dùng `!important`.
4. Thực hiện thí nghiệm gộp lề cha - con và ứng dụng thành công 1 trong 3 kỹ thuật ngăn chặn hiện tượng trồi lề.

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
    <title>Thực hành CSS Box Model & Specificity (Starter)</title>
    <style>
        body { font-family: sans-serif; line-height: 1.6; margin: 20px; background: #f5f5f5; }

        /* Khung chứa cố định 600px */
        .container {
            width: 600px;
            background: #ffffff;
            border: 2px dashed #999;
            padding: 0;
            margin-bottom: 30px;
        }

        /* Thí nghiệm 1: Hai thẻ card cần nằm cạnh nhau nhưng bị rớt hàng do Box Model */
        .card {
            width: 300px;
            padding: 20px;
            border: 2px solid #1890ff;
            background: #e6f7ff;
            display: inline-block;
            vertical-align: top;
        }

        /* Thí nghiệm 2: Xung đột độ ưu tiên CSS (Specificity) */
        .card-title {
            color: #52c41a; /* Mong muốn màu xanh lá */
            font-size: 1.2rem;
            margin-top: 0;
        }

        #event-section .title {
            color: #f5222d; /* Bị đè thành màu đỏ do ID selector có Specificity cao hơn */
        }

        /* Thí nghiệm 3: Margin Collapsing giữa 2 khối liền kề */
        .box-a {
            background: #ffd591;
            padding: 10px;
            margin-bottom: 25px;
        }

        .box-b {
            background: #b7eb8f;
            padding: 10px;
            margin-top: 25px;
        }
    </style>
</head>
<body>

    <h1>Thực hành CSS Box Model & Specificity</h1>

    <h2>1. Thí nghiệm Box Model: Tại sao Card bị rớt hàng?</h2>
    <div class="container" id="event-section">
        <div class="card">
            <h3 class="title card-title">Thẻ sự kiện A</h3>
            <p>Nội dung mô tả thẻ A.</p>
        </div><div class="card">
            <h3 class="title card-title">Thẻ sự kiện B</h3>
            <p>Nội dung mô tả thẻ B.</p>
        </div>
    </div>

    <h2>2. Thí nghiệm Margin Collapsing</h2>
    <div class="box-a">Khối Cam (margin-bottom: 25px)</div>
    <div class="box-b">Khối Xanh (margin-top: 25px)</div>

</body>
</html>
```

---

## Nhiệm vụ 1: Đo kích thước thực tế với DevTools và phân tích content-box

1. Mở file `assets/practice/starter.html` trên trình duyệt web.
2. Nhấp chuột phải vào thẻ `.card` đầu tiên, chọn **Inspect** (Kiểm tra) để mở **DevTools**.
3. Tại bảng bên phải, chuyển sang tab **Computed** và cuộn xuống sơ đồ **Box Model** trực quan.
4. Ghi nhận các thông số thành phần:
   - **Content Width**: `300px`
   - **Padding**: `20px` (trái) + `20px` (phải)
   - **Border**: `2px` (trái) + `2px` (phải)

### Phân tích công thức tính toán
Theo chuẩn W3C Box Model, giá trị mặc định của thuộc tính `box-sizing` là `content-box`. Khi đó, thuộc tính `width: 300px` chỉ áp dụng riêng cho vùng nội dung (content area).

Tổng chiều rộng thực tế hiển thị trên màn hình (Rendered Width) được tính bằng:

$$\text{Tổng chiều rộng} = \text{width} + \text{padding-left} + \text{padding-right} + \text{border-left-width} + \text{border-right-width}$$

$$\text{Tổng chiều rộng} = 300\text{px} + 20\text{px} + 20\text{px} + 2\text{px} + 2\text{px} = 344\text{px}$$

**Nguyên nhân rớt hàng**: Khung chứa `.container` rộng `600px`. Hai thẻ con cạnh nhau đòi hỏi $344\text{px} \times 2 = 688\text{px} > 600\text{px}$, buộc thẻ thứ hai phải rớt xuống dòng tiếp theo.

---

## Nhiệm vụ 2: Khắc phục lỗi vỡ hàng bằng `box-sizing: border-box`

Trong mô hình `border-box`, giá trị `width` khai báo sẽ đại diện cho toàn bộ độ rộng tính từ mép ngoài của đường viền (border edge) trở vào.

Khi đặt `box-sizing: border-box`:
- Chiều rộng tổng thể của mỗi thẻ giữ nguyên đúng `300px`.
- Vùng nội dung bên trong sẽ tự động co lại:

$$\text{Content Width} = 300\text{px} - (20\text{px} \times 2) - (2\text{px} \times 2) = 256\text{px}$$

Hai thẻ sẽ có tổng kích thước $300\text{px} \times 2 = 600\text{px}$, vừa khít hoàn hảo với khung chứa.

### Thao tác sửa lỗi bằng CSS Reset chuẩn W3C
Thêm đoạn CSS Reset sau vào đầu thẻ `<style>`:

```css
*,
*::before,
*::after {
    box-sizing: border-box;
}
```

Tải lại trang và quan sát: Hai thẻ card đã nằm song song trên cùng một hàng.

---

## Nhiệm vụ 3: Phân tích xung đột độ ưu tiên CSS (Specificity) trong DevTools

1. Trong DevTools, chọn phần tử `<h3 class="title card-title">Thẻ sự kiện A</h3>`.
2. Quan sát tab **Styles**:
   - Thuộc tính `color: #52c41a` (xanh lá) của `.card-title` bị gạch ngang (**strikethrough**).
   - Thuộc tính `color: #f5222d` (đỏ) của `#event-section .title` được áp dụng thực tế.

### Bảng tính điểm Specificity

| Selector | Thành phần cấu tạo | Điểm Specificity (ID, Class, Element) | Điểm quy đổi |
| :--- | :--- | :--- | :--- |
| `.card-title` | 1 Class | `(0, 0, 1, 0)` | **10** |
| `#event-section .title` | 1 ID (`#event-section`) + 1 Class (`.title`) | `(0, 1, 1, 0)` | **110** |

**Kết luận**: Do chứa 1 ID selector, `#event-section .title` áp đảo hoàn toàn class đơn lẻ `.card-title`.

### Cách khắc phục chuẩn mực
Không lạm dụng `!important`. Hãy nâng trọng số một cách hợp lý:

```css
#event-section .card-title {
    color: #52c41a; /* Điểm: (0, 1, 1, 0) - bằng điểm selector đỏ nhưng đứng sau nên chiến thắng */
}
```

---

## Nhiệm vụ 4 (Tự làm): Thí nghiệm hiện tượng gộp lề (Margin Collapsing) Cha - Con

Tiêu chuẩn W3C quy định: các lề dọc liền kề giữa các khối trong Normal Flow sẽ gộp lại thành một lề duy nhất có kích thước bằng $\max(\text{margin}_1, \text{margin}_2)$. Vì vậy, khoảng cách giữa `box-a` và `box-b` là $\max(25\text{px}, 25\text{px}) = 25\text{px}$.

Bây giờ, hãy thử nghiệm hiện tượng gộp lề giữa thẻ Cha và thẻ Con:

1. Thêm đoạn mã sau vào cuối file HTML:

```html
<div class="parent-box">
    <div class="child-box">Nội dung thẻ con</div>
</div>
```

```css
.parent-box {
    background-color: #ffd591;
}

.child-box {
    margin-top: 40px;
    background-color: #91d5ff;
    padding: 15px;
}
```

2. **Hiện tượng quan sát được**: Toàn bộ khối cha `.parent-box` bị kéo tụt xuống cách mép trên 40px, lề trên của thẻ con bị "trồi" ra ngoài thẻ cha!
3. **Thử áp dụng 1 trong 3 cách ngăn chặn hiện tượng trồi lề**:
   - Thêm `padding-top: 1px;` vào `.parent-box`.
   - Thêm `border-top: 1px solid transparent;` vào `.parent-box`.
   - Thiết lập `overflow: hidden;` để tạo Block Formatting Context (BFC) mới cho `.parent-box`.

---

## Bảng tổng kết lỗi thường gặp

| Hiện tượng | Nguyên nhân bản chất | Giải pháp xử lý chuẩn |
| :--- | :--- | :--- |
| Khối có padding/border bị phình to vỡ layout | Thuộc tính mặc định là `content-box`. | Luôn khai báo `box-sizing: border-box` toàn cục thông qua universal selector `*`. |
| CSS viết sau nhưng không có tác dụng | Bị quy tắc khác có điểm Specificity cao hơn ghi đè (ví dụ chứa ID selector). | Kiểm tra tab Styles trong DevTools, cân bằng lại trọng số selector thay vì dùng `!important`. |
| Khoảng cách giữa 2 khối dọc nhỏ hơn tổng 2 margin | Cơ chế Margin Collapsing tự động lấy giá trị lớn nhất giữa các lề dọc liền kề. | Tính toán trước khoảng cách mong muốn hoặc dùng `gap` trong Flexbox/Grid. |
| Thẻ con có margin-top làm thụt cả thẻ cha | Lề con tiếp xúc trực tiếp với lề cha mà không có border/padding ngăn cách. | Thêm padding nhỏ, border trong suốt, hoặc tạo BFC (`overflow: hidden`). |

---

## References

- [W3C CSS 2.1 Specification — Box Model](https://www.w3.org/TR/CSS2/box.html): Định nghĩa chuẩn về các vùng content, padding, border, margin và thuật toán gộp lề (collapsing margins).
- [W3C CSS Selectors Level 3 — Calculating Specificity](https://www.w3.org/TR/selectors-3/#specificity): Quy chuẩn tính toán điểm trọng số ưu tiên trong CSS.
