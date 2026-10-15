[Lý thuyết](./index.md)

Trong bài thực hành này, bạn sẽ đóng vai trò một lập trình viên Web Frontend chịu trách nhiệm xây dựng và sửa lỗi biểu mẫu đăng ký tham dự sự kiện **"Hội thảo Web Frontend 2026"**.

Biểu mẫu sẽ sử dụng phương thức **HTTP GET** (`method="get"`). Nhờ đó, dữ liệu sau khi gửi thành công sẽ được trình duyệt mã hóa và hiển thị trực tiếp trên thanh địa chỉ URL dưới dạng **URL Query String** (hoặc quan sát qua thẻ **Network** trong DevTools). Cơ chế này giúp bạn kiểm chứng chính xác thuật toán xử lý dữ liệu biểu mẫu của trình duyệt mà không cần cài đặt máy chủ backend hay dịch vụ bên ngoài.

---

## Mục tiêu và Tiêu chí hoàn thành

### Mục tiêu học tập
- **Cơ chế thu thập dữ liệu (Entry List)**: Hiểu rõ vai trò của thuộc tính `name` trong quá trình trình duyệt đóng gói các cặp dữ liệu gửi đi.
- **Liên kết nhãn `<label>` chuẩn mực**: Nắm vững 2 cách kết nối nhãn với ô nhập liệu (`for`/`id` và bọc lồng) để mở rộng vùng tương tác chạm (Touch Target) và hỗ trợ công cụ trợ năng.
- **Native Constraint Validation**: Sử dụng các thuộc tính kiểm tra dữ liệu tích hợp sẵn của HTML5 (`required`, `type="email"`, `min`, `max`, `maxlength`) để ngăn chặn việc gửi dữ liệu không hợp lệ.
- **Hành vi Nút bấm**: Phân biệt rõ sự khác nhau giữa `<button type="submit">` và `<button type="button">` đối với luồng gửi biểu mẫu và kích hoạt phím `Enter`.

### Tiêu chí hoàn thành
1. Mở file `assets/practice/starter.html` trên trình duyệt, thử submit và phát hiện dữ liệu ô Họ và tên bị mất trên URL do thiếu thuộc tính `name`.
2. Sửa lỗi thẻ `<label>` của trường Email, kiểm chứng bấm chuột vào chữ nhãn làm con trỏ tự động nhảy vào ô nhập liệu.
3. Thay thế nút bấm thành `<button type="submit">`, kích hoạt được submit bằng cả nút bấm chuột lẫn phím `Enter` khi đang ở trong ô nhập liệu.
4. Cấu hình kiểm tra tính hợp lệ tự động; kiểm chứng trình duyệt chặn submit khi để trống hoặc nhập email sai cấu trúc.
5. Mở rộng form với trường chọn loại vé (`<select>`) và ghi chú (`<textarea>`), kiểm tra thấy toàn bộ tham số xuất hiện đầy đủ trên Query String của URL.

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
    <title>Đăng ký sự kiện (Starter có lỗi)</title>
    <style>
        body { font-family: sans-serif; line-height: 1.6; margin: 20px; max-width: 500px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input, select, textarea { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
        .btn { background: #1890ff; color: white; border: none; padding: 10px 15px; cursor: pointer; border-radius: 4px; font-size: 1rem; }
        .btn:hover { background: #40a9ff; }
        .hint { font-size: 0.85rem; color: #666; margin-top: 3px; }
    </style>
</head>
<body>

    <h1>Đăng ký tham dự Hội thảo Web 2026</h1>
    <p><em>Lưu ý: Form này sử dụng phương thức GET. Sau khi submit, bạn có thể quan sát trực tiếp các tham số gửi đi ngay trên thanh địa chỉ URL của trình duyệt.</em></p>

    <!-- FORM BAN ĐẦU CỐ Ý CHỨA CÁC LỖI CẦN SỬA -->
    <form action="" method="GET">
        
        <!-- Lỗi 1: Ô Họ và tên thiếu thuộc tính name -->
        <div class="form-group">
            <label for="fullname">Họ và tên:</label>
            <input type="text" id="fullname" placeholder="Nhập họ và tên...">
            <div class="hint">Thử gõ họ tên rồi submit để quan sát xem tên có xuất hiện trên URL không!</div>
        </div>

        <!-- Lỗi 2: Thẻ label thiếu thuộc tính for và ô input thiếu id, type="text" thay vì type="email" -->
        <div class="form-group">
            <label>Email đăng ký:</label>
            <input type="text" name="email" placeholder="name@example.com">
            <div class="hint">Thử nhấp chuột vào chữ "Email đăng ký" xem ô nhập liệu có được focus không.</div>
        </div>

        <!-- Lỗi 3: Số lượng vé không giới hạn, thiếu ràng buộc -->
        <div class="form-group">
            <label for="ticket-count">Số lượng vé:</label>
            <input type="text" id="ticket-count" name="quantity" value="1">
        </div>

        <!-- Lỗi 4: Thẻ button có type="button" thay vì type="submit", khiến không thể submit bằng chuột hoặc phím Enter -->
        <div class="form-group">
            <button type="button" class="btn">Gửi đăng ký</button>
        </div>

    </form>

</body>
</html>
```

---

## Nhiệm vụ 1: Phát hiện và sửa lỗi mất dữ liệu do thiếu thuộc tính `name`

### Mô tả vấn đề
Mở file `starter.html` trong trình duyệt, sửa tạm nút gửi thành `type="submit"`, nhập họ tên và nhấn gửi. Bạn sẽ thấy trên thanh địa chỉ URL hoàn toàn không có tham số nào của họ tên.

### Nguyên nhân kỹ thuật
Theo tiêu chuẩn WHATWG HTML Standard, trong thuật toán gửi biểu mẫu, trình duyệt chỉ duyệt qua các phần tử điều khiển (submittable elements) có khai báo thuộc tính `name`. Nếu một ô `<input>` bị thiếu thuộc tính `name`, toàn bộ giá trị người dùng nhập vào sẽ bị trình duyệt bỏ qua không đóng gói vào danh sách gửi.

### Thao tác sửa lỗi
Bổ sung `name="fullname"` vào ô nhập Họ và tên:

```html
<input type="text" id="fullname" name="fullname" placeholder="Nhập họ và tên..." required>
```

Sau khi sửa, nhập `"Nguyen Van A"` và gửi form. Quan sát thanh địa chỉ sẽ thấy xuất hiện:
`?fullname=Nguyen+Van+A`

---

## Nhiệm vụ 2: Liên kết nhãn `<label>` và tối ưu khả năng tiếp cận

### Mô tả vấn đề
Ở ô **Email đăng ký**, khi bạn nhấp chuột vào dòng chữ tiêu đề *"Email đăng ký:"*, con trỏ soạn thảo không tự động kích hoạt vào ô nhập liệu bên dưới. Điều này làm giảm diện tích bấm trên màn hình cảm ứng điện thoại và gây cản trở cho trình đọc màn hình.

### Nguyên nhân kỹ thuật
Thẻ `<label>` chỉ có thể điều khiển phần tử nhập liệu khi được liên kết qua một trong hai cách chuẩn hóa:
1. **Dùng cặp thuộc tính `for` và `id` (Khuyên dùng)**: Giá trị của thuộc tính `for` trên `<label>` phải trùng khớp chính xác với thuộc tính `id` trên `<input>`.
2. **Bọc lồng (Implicit Label)**: Đặt trực tiếp thẻ `<input>` nằm bên trong cặp thẻ `<label>...</label>`.

### Thao tác sửa lỗi
Cập nhật ô Email bằng liên kết tường minh và đổi `type` sang `email`:

```html
<label for="user-email">Email đăng ký:</label>
<input type="email" id="user-email" name="email" placeholder="name@example.com" required>
```

**Kiểm chứng**: Nhấp chuột vào dòng chữ nhãn. Con trỏ soạn thảo lập tức xuất hiện bên trong ô nhập email. Nhấn phím `Tab` để di chuyển tuần tự qua các trường.

---

## Nhiệm vụ 3: Thiết lập Native Constraint Validation và chuẩn hóa nút Submit

### Thao tác sửa lỗi
1. Thay đổi thuộc tính `type="button"` của nút gửi thành `type="submit"`.
2. Cập nhật trường số lượng vé: Chuyển `type="text"` thành `type="number"`, đặt giới hạn mua tối thiểu `min="1"` và tối đa `max="5"`.
3. Bổ sung thuộc tính `required` cho các trường bắt buộc phải điền.

Đoạn mã hoàn chỉnh của biểu mẫu sau khi chuẩn hóa:

```html
<form action="" method="GET">
    <div class="form-group">
        <label for="fullname">Họ và tên:</label>
        <input type="text" id="fullname" name="fullname" placeholder="Nhập họ và tên..." required>
    </div>

    <div class="form-group">
        <label for="user-email">Email đăng ký:</label>
        <input type="email" id="user-email" name="email" placeholder="name@example.com" required>
    </div>

    <div class="form-group">
        <label for="ticket-count">Số lượng vé (1 - 5 vé):</label>
        <input type="number" id="ticket-count" name="quantity" min="1" max="5" value="1" required>
    </div>

    <div class="form-group">
        <button type="submit" class="btn">Gửi đăng ký</button>
    </div>
</form>
```

### Kiểm chứng cơ chế chặn submit tự động
1. **Thử bỏ trống Họ tên**: Nhấn nút gửi. Trình duyệt tự động chặn lệnh gửi và hiển thị bong bóng cảnh báo *"Please fill out this field"* (hoặc *"Vui lòng điền vào trường này"*).
2. **Thử nhập email sai định dạng**: Nhập `"nguyenvana"` (không có `@` và tên miền). Trình duyệt cảnh báo yêu cầu định dạng email hợp lệ.
3. **Thử số lượng vượt giới hạn**: Nhập số `10` vào số lượng vé rồi gửi. Trình duyệt chặn lại vì vượt quá `max="5"`.
4. **Kiểm tra phím Enter**: Đặt con trỏ vào ô họ tên và nhấn phím `Enter`. Trình duyệt sẽ tự động kích hoạt tiến trình kiểm tra và gửi form mà không cần rê chuột bấm nút.

---

## Nhiệm vụ 4 (Tự làm): Mở rộng trường Loại vé và Ghi chú

Hãy nâng cấp form bằng cách bổ sung thêm 2 trường dữ liệu sau vào trước nút gửi:

1. **Trường chọn Loại vé (`<select>`)**:
   - `name="ticket_type"` và liên kết với nhãn `<label for="ticket-type">Loại vé tham dự:</label>`.
   - Có 3 tùy chọn:
     - `<option value="standard">Vé Tiêu chuẩn</option>`
     - `<option value="vip">Vé VIP (Có tiệc trà)</option>`
     - `<option value="student">Vé Sinh viên</option>`
2. **Trường Ghi chú yêu cầu đặc biệt (`<textarea>`)**:
   - `name="notes"`, `rows="3"`, giới hạn tối đa 200 ký tự bằng `maxlength="200"`.

### Kết quả mong đợi trên URL
Sau khi điền đầy đủ thông tin hợp lệ và nhấn **Gửi đăng ký**, hãy quan sát thanh địa chỉ của trình duyệt. Chuỗi truy vấn Query String gửi đi sẽ có cấu trúc đầy đủ dạng:

```text
?fullname=Nguyen+Van+A&email=a%40example.com&quantity=2&ticket_type=vip&notes=Cho+toi+ngoi+gan+san+khau
```

---

## Lỗi thường gặp

| Lỗi | Nguyên nhân | Cách khắc phục |
| :--- | :--- | :--- |
| **Dữ liệu không được gửi lên URL / Server** | Ô nhập liệu bị thiếu thuộc tính `name`. | Luôn khai báo `name="..."` cho mọi thẻ `<input>`, `<select>`, `<textarea>` cần gửi dữ liệu. |
| **Bấm nút gửi hoặc bấm phím Enter không có phản ứng** | Thẻ `<button>` mang `type="button"` (loại chỉ dùng cho sự kiện JS thủ công). | Đổi thành `<button type="submit">` hoặc để mặc định bên trong `<form>`. |
| **Bấm vào chữ nhãn không kích hoạt con trỏ nhập liệu** | `<label>` thiếu thuộc tính `for` khớp với `id` của input. | Đảm bảo `for="abc"` trên label trùng khớp 100% với `id="abc"` trên input. |
| **Dùng `placeholder` thay thế hoàn toàn cho `<label>`** | Cho rằng placeholder đã đủ rõ ràng nên bỏ qua thẻ `<label>`. | Placeholder biến mất ngay khi gõ ký tự đầu tiên và không được Screen Reader nhận diện đầy đủ. Bắt buộc phải có `<label>`. |

---

## References

- [WHATWG HTML Standard — Forms](https://html.spec.whatwg.org/multipage/forms.html#forms): Toàn bộ tiêu chuẩn về phần tử `<form>`, thuật toán đóng gói dữ liệu và gửi biểu mẫu.
- [WHATWG HTML Standard — The label element](https://html.spec.whatwg.org/multipage/forms.html#the-label-element): Quy chuẩn gắn kết nhãn điều khiển người dùng.
- [WHATWG HTML Standard — Constraint Validation](https://html.spec.whatwg.org/multipage/forms.html#client-side-form-validation): Cơ chế kiểm tra tính hợp lệ dữ liệu tự động ở phía client.
