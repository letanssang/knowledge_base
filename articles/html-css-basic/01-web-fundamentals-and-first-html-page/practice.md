[Lý thuyết](./index.md)

Bài thực hành này giúp bạn kiểm chứng trực tiếp cơ chế trình duyệt phân tích cú pháp (parsing) mã nguồn HTML tĩnh thành cấu trúc cây DOM (Document Object Model) động trong bộ nhớ RAM, phân biệt các loại Node, và quan sát hiện tượng trượt chỉ số (index shift) khi thao tác trên Live Collection so với Static Collection.

---

## Mục tiêu và Tiêu chí hoàn thành

### Mục tiêu học tập
- **Cơ chế DOM trong RAM**: Nắm rõ quá trình trình duyệt chuyển đổi chuỗi HTML tĩnh thành cây DOM dạng đối tượng trong bộ nhớ RAM.
- **Phân biệt Node Types**: Nhận diện sự khác nhau giữa `Element Node` và `Text Node` (bao gồm các Text Node tạo ra từ khoảng trắng lùi lề và dấu xuống dòng).
- **Phân biệt RAM và Disk**: Nhận diện tính tức thời của các can thiệp trên RAM qua DevTools Console và sự bất biến của file mã nguồn tĩnh trên ổ đĩa.
- **Hành vi Collection**: Giải thích được hiện tượng trượt chỉ số khi xóa phần tử trên Live Collection (`HTMLCollection` / Live `NodeList`) so với Static `NodeList`.

### Tiêu chí hoàn thành
1. Mở được file mẫu trong trình duyệt, sử dụng DevTools (Elements và Console) để kiểm tra cấu trúc cây DOM.
2. In ra thuộc tính `childNodes` và `children` của phần tử `<ul>`, đếm và giải thích được vì sao `childNodes.length` (9) lớn hơn `children.length` (4).
3. Can thiệp thay đổi `document.body.innerHTML` trên Console, quan sát giao diện cập nhật ngay lập tức; sau đó tải lại trang (`F5`) để kiểm chứng file `.html` tĩnh trên ổ đĩa không thay đổi.
4. Dự đoán và giải thích được kết quả vòng lặp `for` xóa phần tử trên Live Collection (còn sót lại phần tử) so với Static Collection (xóa sạch toàn bộ).

---

## Chuẩn bị môi trường và file mẫu

Bạn có thể tự tạo file hoặc sử dụng file khởi đầu có sẵn tại [assets/practice/starter.html](./assets/practice/starter.html).

Nội dung file `index.html`:

```html
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thực hành HTML & DOM Fundamentals</title>
</head>
<body>
    <h1>Trang web thực hành DOM đầu tiên</h1>
    <p>Dưới đây là danh sách các mục học tập:</p>

    <ul id="item-list">
        <li>Mục 1: HTML Syntax</li>
        <li>Mục 2: DOM Tree</li>
        <li>Mục 3: Element vs Text Node</li>
        <li>Mục 4: Live vs Static NodeList</li>
    </ul>

    <script>
        console.log("Trang HTML đã được nạp xong vào bộ nhớ RAM!");
    </script>
</body>
</html>
```

*Lưu ý: Các khoảng trắng và dấu xuống dòng giữa các thẻ `<ul>` và `<li>` được cố ý giữ lại để phục vụ việc quan sát Text Node.*

---

## Nhiệm vụ 1: Soi cây DOM và phân biệt Element Node với Text Node khoảng trắng

### Bối cảnh kỹ thuật
Theo chuẩn WHATWG DOM Standard, mọi thành phần trong tài liệu khi được parser nạp vào bộ nhớ đều trở thành một **Node**:
- Các thẻ HTML (như `<ul>`, `<li>`, `<h1>`) là **Element Node** (`nodeType = 1`).
- Văn bản bên trong thẻ, cùng các **khoảng trắng lùi dòng** và **ký tự xuống dòng (`\n`)** giữa các thẻ, đều được chuyển thành **Text Node** (`nodeType = 3`).

### Thao tác thực hiện
1. Mở file `index.html` bằng trình duyệt web (Chrome, Edge hoặc Firefox).
2. Nhấn `F12` (hoặc `Cmd + Option + I` trên macOS) để mở DevTools, chuyển sang tab **Console**.
3. Thực thi đoạn mã sau để kiểm tra `childNodes` và `children`:

```javascript
const ul = document.getElementById('item-list');

console.log('--- childNodes (tất cả các Node con) ---');
console.log(ul.childNodes);
console.log('Số lượng childNodes:', ul.childNodes.length);

console.log('--- children (chỉ lọc Element Node) ---');
console.log(ul.children);
console.log('Số lượng children:', ul.children.length);
```

### Kết quả quan sát & Phân tích
- `ul.children.length` trả về **`4`**: Thuộc tính này kế thừa từ `ParentNode`, chỉ lọc ra 4 phần tử thẻ `<li>` (Element Node).
- `ul.childNodes.length` trả về **`9`**: Thuộc tính này kế thừa từ `Node`, trả về toàn bộ 9 Node con trực tiếp:
  - `childNodes[0]`: `Text` node (ký tự xuống dòng `\n` và khoảng trắng giữa `<ul>` và `<li>` đầu tiên).
  - `childNodes[1]`: `HTMLLIElement` (`<li>Mục 1...</li>`).
  - `childNodes[2]`: `Text` node (khoảng trắng giữa Mục 1 và Mục 2).
  - `childNodes[3]`: `HTMLLIElement` (`<li>Mục 2...</li>`).
  - `childNodes[4]`: `Text` node (khoảng trắng giữa Mục 2 và Mục 3).
  - `childNodes[5]`: `HTMLLIElement` (`<li>Mục 3...</li>`).
  - `childNodes[6]`: `Text` node (khoảng trắng giữa Mục 3 và Mục 4).
  - `childNodes[7]`: `HTMLLIElement` (`<li>Mục 4...</li>`).
  - `childNodes[8]`: `Text` node (khoảng trắng giữa Mục 4 và `</ul>`).

Để in rõ tên và kiểu của từng node, chạy lệnh:

```javascript
ul.childNodes.forEach((node, index) => {
    console.log(`Index ${index}: nodeName = "${node.nodeName}", nodeType = ${node.nodeType}`);
});
```

---

## Nhiệm vụ 2: Thay đổi DOM trên RAM và kiểm chứng tính bất biến của file tĩnh

### Bối cảnh kỹ thuật
File `index.html` lưu trên ổ đĩa là văn bản tĩnh. Khi tải trang, trình duyệt đọc mã nguồn và dựng cấu trúc đối tượng DOM trong bộ nhớ RAM. Mọi thao tác JavaScript qua Console can thiệp trực tiếp lên bộ nhớ RAM của tab hiện tại, không ghi đè vào file trên đĩa cứng.

### Thao tác thực hiện
1. Tại tab **Console**, nhập câu lệnh:

```javascript
document.body.innerHTML = `
    <div style="background: #e6f7ff; padding: 20px; border: 2px solid #1890ff; font-family: sans-serif;">
        <h1 style="color: #096dd9;">⚡ Đã can thiệp vào cây DOM trên RAM!</h1>
        <p>Giao diện hiện tại được kết xuất động từ bộ nhớ của trình duyệt.</p>
    </div>
`;
```

2. **Quan sát giao diện**: Giao diện trang lập tức đổi sang khối nội dung màu xanh dương mới.
3. **Kiểm tra file trên đĩa**: Mở file `index.html` bằng trình soạn thảo (VS Code). Toàn bộ mã nguồn gốc vẫn nguyên vẹn.
4. **Nhấn F5 (Reload)**: Trình duyệt hủy bỏ cây DOM cũ trong RAM, đọc lại mã nguồn từ file đĩa và dựng lại cây DOM nguyên bản.

---

## Nhiệm vụ 3: Thí nghiệm hiện tượng trượt chỉ số (Index Shift) trong Live Collection vs Static Collection

### Đề bài
Hãy quan sát hai đoạn mã dưới đây cùng thực hiện nhiệm vụ: **Dùng vòng lặp `for` xóa sạch các thẻ `<li>` trong danh sách `#item-list`**. Dự đoán kết quả trước khi chạy.

#### Thí nghiệm A: Xóa với Live Collection
Sử dụng `getElementsByTagName('li')` (trả về một Live `HTMLCollection`):

```javascript
const liveList = document.getElementById('item-list').getElementsByTagName('li');
console.log('Độ dài ban đầu:', liveList.length); // 4

for (let i = 0; i < liveList.length; i++) {
    liveList[i].remove();
}

console.log('Số lượng còn lại:', liveList.length);
```

#### Thí nghiệm B: Xóa với Static Collection
Tải lại trang (`F5`), sau đó sử dụng `querySelectorAll('#item-list li')` (trả về một Static `NodeList`):

```javascript
const staticList = document.querySelectorAll('#item-list li');
console.log('Độ dài ban đầu:', staticList.length); // 4

for (let i = 0; i < staticList.length; i++) {
    staticList[i].remove();
}

console.log('Số lượng còn lại trong DOM:', document.querySelectorAll('#item-list li').length);
```

---

## Gợi ý và Lời giải tham khảo

### Phân tích hiện tượng Trượt chỉ số (Index Shift)

#### Kết quả Thí nghiệm A:
Sau khi vòng lặp kết thúc, danh sách **vẫn còn lại 2 phần tử**: "Mục 2: DOM Tree" và "Mục 4: Live vs Static NodeList".

**Bảng diễn biến từng bước lặp (Dry Run):**

| Bước lặp (`i`) | `liveList.length` | Phần tử truy xuất `liveList[i]` | Hành động | Trạng thái sau bước lặp |
| :--- | :--- | :--- | :--- | :--- |
| **`i = 0`** | `4` | `liveList[0]` ("Mục 1") | Xóa "Mục 1" | "Mục 2" bị dồn về **chỉ số 0**. Chiều dài giảm còn `3`. |
| **`i = 1`** | `3` | `liveList[1]` ("Mục 3") | Xóa "Mục 3" | "Mục 2" (đang ở chỉ số 0) bị **bỏ qua**. "Mục 4" dồn về chỉ số 1. Chiều dài giảm còn `2`. |
| **`i = 2`** | `2` | *(Dừng lặp vì điều kiện `i < liveList.length` tức `2 < 2` là `false`)* | Không thao tác | Còn lại 2 phần tử trong DOM: Mục 2 và Mục 4. |

*Cơ chế*: Live Collection tự động cập nhật ngay khi cấu trúc DOM thay đổi. Khi xóa phần tử tại vị trí `0`, các phần tử phía sau bị trượt chỉ số lùi về trước. Việc bước lặp kế tiếp tăng biến đếm `i` lên `1` khiến vòng lặp bỏ sót phần tử vừa trượt vào vị trí cũ.

#### Kết quả Thí nghiệm B:
Toàn bộ **4 phần tử bị xóa sạch**.

*Cơ chế*: `querySelectorAll` trả về một `Static NodeList` — một ảnh chụp trạng thái (snapshot) tại thời điểm gọi hàm. Dù các phần tử bị gỡ khỏi DOM trên RAM, mảng tham chiếu `staticList` vẫn giữ nguyên 4 phần tử ở các vị trí từ `0` đến `3`, giúp vòng lặp duyệt qua đủ từng phần tử mà không bị trượt chỉ số.

---

### Các cách khắc phục lỗi trượt chỉ số ở Live Collection

#### Cách 1: Duyệt ngược từ cuối danh sách về đầu
```javascript
const list = document.getElementById('item-list').getElementsByTagName('li');
for (let i = list.length - 1; i >= 0; i--) {
    list[i].remove();
}
```
*Giải thích*: Khi xóa từ cuối danh sách, chỉ số của các phần tử đứng phía trước không bị thay đổi.

#### Cách 2: Vòng lặp `while` liên tục xóa phần tử ở đầu
```javascript
const list = document.getElementById('item-list').getElementsByTagName('li');
while (list.length > 0) {
    list[0].remove();
}
```
*Giải thích*: Luôn xóa phần tử tại vị trí `0` cho đến khi độ dài của `HTMLCollection` về `0`.

#### Cách 3: Chuyển Live Collection thành Mảng tĩnh
```javascript
const liveList = document.getElementById('item-list').getElementsByTagName('li');
const staticArray = Array.from(liveList);

staticArray.forEach(el => el.remove());
```

---

## Lỗi thường gặp

| Hiện tượng | Nguyên nhân | Cách xử lý |
| :--- | :--- | :--- |
| Gặp lỗi `Cannot read properties of undefined` khi duyệt `childNodes` | Thao tác nhầm vào `Text Node` khoảng trắng thay vì `Element Node` (Text Node không có các thuộc tính thẻ HTML). | Dùng thuộc tính `children` nếu chỉ muốn làm việc với thẻ HTML, hoặc kiểm tra `node.nodeType === 1` trước khi xử lý. |
| Xóa hoặc cập nhật hàng loạt bị sót một nửa số phần tử | Dùng vòng lặp tiến (`for i = 0...`) trên Live Collection (`getElementsByTagName`, `getElementsByClassName`). | Sử dụng `querySelectorAll` để có Static NodeList, chuyển thành mảng tĩnh qua `Array.from()`, hoặc duyệt ngược chiều. |
| Console báo lỗi `Cannot read properties of null (reading '...')` | Thẻ `<script>` đặt ở thẻ `<head>` thực thi trước khi parser kịp tạo các phần tử trong body. | Đặt thẻ `<script>` ở cuối `<body>` hoặc thêm thuộc tính `defer` vào thẻ `<script>` trong `<head>`. |

---

## References

- [WHATWG DOM Living Standard](https://dom.spec.whatwg.org/): Quy chuẩn chính thức về giao diện `Node`, phân loại `nodeType`, `ParentNode.children`, và cơ chế bộ sưu tập `NodeList`, `HTMLCollection`.
- [MDN Web Docs — Basic HTML syntax](https://developer.mozilla.org/en-US/docs/Learn/HTML/Introduction_to_HTML/Getting_started): Cú pháp HTML cơ bản, cấu trúc thẻ, lồng thẻ và phần tử rỗng (void elements).
