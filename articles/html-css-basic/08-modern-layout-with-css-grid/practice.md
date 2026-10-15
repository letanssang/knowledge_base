[Lý thuyết](./index.md)

Trong bài thực hành này, bạn sẽ tiến hành xây dựng giao diện dàn trang danh sách các thẻ phiên sự kiện công nghệ (**Event Cards Grid**) bằng mô hình **CSS Grid Layout 2 chiều (two-dimensional grid system)** theo chuẩn W3C, bao gồm các kỹ thuật cốt lõi:
1. **Khởi tạo Grid Formatting Context**: Chia bố cục thành 3 cột đều nhau bằng phân số linh hoạt `1fr` kết hợp hàm `repeat()`.
2. **Điều khiển vị trí và độ rộng ô lưới (Grid Placement & Span)**: Cho phép thẻ phiên khai mạc Keynote trải dài chiếm 2 cột (`grid-column: span 2`) và kiểm chứng thuật toán xếp chỗ tự động (**Auto-placement Algorithm**).
3. **Thiết kế lưới Responsive tự động không cần Media Query**: Ứng dụng công thức kinh điển `repeat(auto-fit, minmax(240px, 1fr))` để danh sách tự động xuống hàng và co giãn vừa vặn trên mọi độ phân giải màn hình.
4. **Phân tích cơ chế W3C**: Đối chiếu trực quan sự khác biệt giữa `auto-fill` và `auto-fit` khi xử lý các rãnh lặp lại bị trống (**empty repeated tracks**), cùng bảng tra cứu toàn diện các thuộc tính của Grid Container và Grid Item.

---

## Mục tiêu và Tiêu chí hoàn thành

### Mục tiêu học tập
- **Tư duy bố cục 2 chiều (2-Dimensional System)**: Phân biệt sự khác biệt cơ bản giữa CSS Grid (kiểm soát đồng thời cả hàng và cột) so với CSS Flexbox (tối ưu trên một trục đơn tuyến).
- **Làm chủ đơn vị `fr` và hàm `minmax()`**: Hiểu rõ công thức tính toán và phân bổ khoảng trống còn dư (**leftover space**) trong Grid Container.
- **Thuật toán tự động sắp xếp (Auto-placement Algorithm)**: Hiểu cách con trỏ auto-placement duyệt qua các ô lưới, cách đặt các item có định nghĩa span và cách đẩy các item tự do vào vị trí khả dụng tiếp theo.
- **Bản chất của `auto-fit` vs `auto-fill`**: Hiểu cơ chế thu gọn rãnh rỗng về `0px` (**collapsed tracks**) của `auto-fit` để giao diện luôn căng tràn đẹp mắt.

### Tiêu chí hoàn thành
1. Chuyển `.events-grid` thành Grid Container với `display: grid`, khoảng cách rãnh `gap: 20px`, chia 3 cột đều nhau bằng `grid-template-columns: repeat(3, 1fr)`.
2. Định cấu hình thẻ `.event-card.featured` trải dài qua 2 cột bằng `grid-column: span 2`, xác nhận trên trình duyệt thẻ này chiếm trọn 2 cột đầu tiên của hàng 1 mà không làm hỏng cấu trúc các thẻ còn lại.
3. Thay thế cấu hình 3 cột cố định bằng mẫu responsive `repeat(auto-fit, minmax(240px, 1fr))`. Kiểm tra trên DevTools Responsive Mode:
   - Khi màn hình rộng (> 800px): hiển thị nhiều cột, thẻ featured chiếm 2 cột.
   - Khi thu hẹp về màn hình điện thoại (< 500px): tất cả các thẻ (kể cả featured) tự động co về 1 cột duy nhất mà không bị tràn khung ngang (overflow-x).
4. Thực hiện thử nghiệm đổi sang `auto-fill`, ghi nhận hiện tượng xuất hiện các cột trống vô hình ở phía bên phải khi container có ít phần tử.

---

## Chuẩn bị môi trường và file mẫu

File mẫu HTML/CSS khởi đầu đã được tạo sẵn tại [assets/practice/starter.html](./assets/practice/starter.html).

Mã nguồn file `assets/practice/starter.html`:

```html
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Event Cards Layout with CSS Grid</title>
  <style>
    /* CSS Cơ bản */
    body {
      font-family: system-ui, -apple-system, sans-serif;
      background-color: #f8fafc;
      color: #0f172a;
      margin: 0;
      padding: 32px;
    }

    .container {
      max-width: 1100px;
      margin: 0 auto;
    }

    h2 {
      margin-bottom: 24px;
      color: #1e293b;
    }

    /* Container danh sách thẻ phiên sự kiện */
    .events-grid {
      /* TODO: Thêm thuộc tính Grid ở các nhiệm vụ tiếp theo */
    }

    /* Thẻ sự kiện */
    .event-card {
      background: #ffffff;
      border-radius: 8px;
      padding: 20px;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
      border-top: 4px solid #3b82f6;
    }

    .event-card.featured {
      border-top-color: #ef4444;
      background-color: #fff1f2;
    }

    .event-card .time {
      font-size: 0.875rem;
      font-weight: 600;
      color: #64748b;
      margin-bottom: 8px;
    }

    .event-card h3 {
      margin: 0 0 10px 0;
      font-size: 1.125rem;
    }

    .event-card p {
      margin: 0;
      font-size: 0.95rem;
      color: #334155;
      line-height: 1.5;
    }
  </style>
</head>
<body>
  <div class="container">
    <h2>Lịch trình Phiên sự kiện Công nghệ</h2>
    
    <div class="events-grid">
      <!-- Thẻ 1: Keynote (Featured) -->
      <div class="event-card featured">
        <div class="time">09:00 - 10:30</div>
        <h3>Keynote: Tương lai của Web Development & AI</h3>
        <p>Phiên toàn thể khai mạc cập nhật xu hướng công nghệ mới nhất và định hướng phát triển ứng dụng web hiện đại.</p>
      </div>

      <!-- Thẻ 2 -->
      <div class="event-card">
        <div class="time">10:45 - 11:30</div>
        <h3>Thực hành CSS Grid & Flexbox</h3>
        <p>Tìm hiểu cách kết hợp hai mô hình dàn trang phổ biến để xây dựng UI phức tạp.</p>
      </div>

      <!-- Thẻ 3 -->
      <div class="event-card">
        <div class="time">11:30 - 12:15</div>
        <h3>Tối ưu hiệu năng Frontend</h3>
        <p>Các phương pháp cải thiện chỉ số Core Web Vitals và trải nghiệm người dùng.</p>
      </div>

      <!-- Thẻ 4 -->
      <div class="event-card">
        <div class="time">13:30 - 14:15</div>
        <h3>Bảo mật Ứng dụng Web</h3>
        <p>Nhận diện và khắc phục các lỗ hổng bảo mật phổ biến theo tiêu chuẩn OWASP.</p>
      </div>

      <!-- Thẻ 5 -->
      <div class="event-card">
        <div class="time">14:30 - 15:15</div>
        <h3>Thảo luận bàn tròn & Q&A</h3>
        <p>Giao lưu trực tiếp cùng các chuyên gia hàng đầu và giải đáp thắc mắc.</p>
      </div>
    </div>
  </div>
</body>
</html>
```

---

## Nhiệm vụ 1: Kích hoạt Grid và thiết lập bố cục 3 cột

### Mục tiêu
Biến phần tử `.events-grid` thành một **Grid Container** độc lập và chia bố cục thành 3 cột đồng đều bằng đơn vị linh hoạt `1fr`.

### Hướng dẫn thực hiện
Thêm quy tắc CSS sau vào bộ chọn `.events-grid`:

```css
.events-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}
```

### Cơ chế kỹ thuật W3C
* **`display: grid`**: Thiết lập một **Grid Formatting Context** độc lập cho container. Các phần tử con trực tiếp bên trong lập tức trở thành các **Grid Item**. Margin của grid container không bị sụp đổ (margin collapse) với nội dung bên trong, và các phần tử con không bị ảnh hưởng bởi `float`.
* **`grid-template-columns: repeat(3, 1fr)`**:
  * Hàm `repeat(3, ...)` là cú pháp rút gọn lặp lại mẫu rãnh (track) 3 lần.
  * Đơn vị `fr` (**flexible length / flex factor**) đại diện cho một phần phân số của khoảng trống còn dư (**leftover space**) trong container sau khi đã trừ đi kích thước cố định và các rãnh khoảng cách `gap`.
  * Vì cả 3 cột đều nhận `1fr`, khoảng không gian khả dụng được chia đều làm 3 phần chính xác (mỗi cột nhận 33.333% không gian còn lại).
* **`gap: 20px`**: Thiết lập khoảng cách rãnh giữa các hàng (`row-gap`) và các cột (`column-gap`). Theo W3C CSS Grid 1, rãnh gutter này được xử lý như một đường rãnh rỗng có kích thước cố định, loại bỏ hoàn toàn nhu cầu dùng margin âm (negative margin) như các hệ thống grid kiểu cũ.

---

## Nhiệm vụ 2: Mở rộng thẻ phiên Keynote chiếm 2 cột

### Mục tiêu
Làm nổi bật phiên khai mạc Keynote (`.event-card.featured`) bằng cách cho phép thẻ này mở rộng bề ngang trải qua 2 rãnh cột liền kề.

### Hướng dẫn thực hiện
Bổ sung khai báo vị trí cho thẻ `.event-card.featured`:

```css
.event-card.featured {
  grid-column: span 2;
}
```

### Cơ chế kỹ thuật W3C & Thuật toán Auto-placement
* **`grid-column: span 2`**: Đây là cú pháp viết tắt của cặp thuộc tính `grid-column-start` và `grid-column-end`. Giá trị `span 2` quy định rằng Grid Item này sẽ trải dài qua 2 rãnh cột (**grid span = 2**).
* **Thuật toán tự động sắp xếp (Auto-placement Algorithm)**:
  1. Theo mặc định, container hoạt động với `grid-auto-flow: row`. Con trỏ vị trí tự động (**auto-placement cursor**) xuất phát từ ô `[hàng 1, cột 1]`.
  2. Phần tử đầu tiên (thẻ Keynote) yêu cầu độ rộng `span 2`. Con trỏ kiểm tra ô 1 và ô 2 của hàng 1 còn trống, nên đặt thẻ Keynote chiếm trọn cột 1 và cột 2.
  3. Con trỏ tự động di chuyển đến cột tiếp theo khả dụng là cột 3 của hàng 1. Thẻ sự kiện thứ 2 không có span cụ thể (mặc định nhận `span 1`), nên được đặt vừa vặn vào cột 3.
  4. Hàng 1 đã đầy (đủ 3 cột). Con trỏ chuyển xuống đầu hàng 2 (`[hàng 2, cột 1]`) và lần lượt đặt các thẻ 3, 4, 5 vào cột 1, cột 2 và cột 3 theo đúng thứ tự DOM.

---

## Nhiệm vụ 3: Cấu hình lưới Responsive tự động không cần Media Query

### Mục tiêu
Xóa bỏ số lượng cột cố định để danh sách thẻ tự động dàn số cột tối ưu theo bề rộng container mà không cần viết bất kỳ truy vấn `@media` nào.

### Hướng dẫn thực hiện
Cập nhật thuộc tính `grid-template-columns` của `.events-grid`:

```css
.events-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 20px;
}
```

### Cơ chế kỹ thuật W3C
* **`minmax(240px, 1fr)`**: Định nghĩa dải kích thước cho mỗi rãnh cột. Giá trị tối thiểu là `240px` (ngăn không cho thẻ bị co ép quá nhỏ làm gãy chữ), và giá trị tối đa là `1fr` (cho phép thẻ tự do giãn rộng để chiếm hết không gian khả dụng).
* **`repeat(auto-fit, ...)`**:
  * Trình duyệt tự động chia chiều rộng của container cho `240px` (có tính cả `gap`) để tính số lượng rãnh cột tối đa có thể vừa vặn mà không gây tràn khung ngang.
  * Nếu màn hình rộng `1000px`, trình duyệt tính được có thể chứa khoảng 3 - 4 cột.
  * Khi người dùng thu nhỏ cửa sổ trình duyệt, nếu bề rộng không còn đủ chứa một cột `240px`, số cột sẽ tự động giảm từ 3 xuống 2, rồi từ 2 xuống 1. Các thẻ sẽ tự động rớt xuống hàng tiếp theo một cách mượt mà.

---

## Nhiệm vụ 4 (Thử nghiệm & Đào sâu): Phân biệt `auto-fill` vs `auto-fit` và cơ chế co giãn `1fr`

### Thử nghiệm thực hành
Hãy tạm thời đổi `auto-fit` thành `auto-fill` trong đoạn mã ở Nhiệm vụ 3:

```css
/* Thử nghiệm */
.events-grid {
  grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
}
```

Mở DevTools, bật tính năng Grid Overlay (nhấp vào nhãn `grid` trên thẻ `.events-grid` trong tab Elements) và quan sát trên màn hình rộng khi container chỉ có 5 thẻ sự kiện.

### Giải đáp cơ chế chuẩn W3C

#### 1. Sự khác biệt bản chất giữa `auto-fill` và `auto-fit`
* **`auto-fill` (Điền đầy rãnh)**:
  * Trình duyệt tính toán số lượng rãnh tối đa có thể nhét vừa vào container.
  * Ngay cả khi một rãnh cột **không có bất kỳ Grid Item nào nằm vào (empty repeated track)**, `auto-fill` vẫn **duy trì sự tồn tại của rãnh trống đó** trên lưới với kích thước tính toán ban đầu.
  * Kết quả: Các thẻ sự kiện thực tế sẽ bị ép dừng lại ở độ rộng tối thiểu, chừa lại một khoảng rãnh trống vô hình ở phía bên phải.
* **`auto-fit` (Vừa vặn nội dung)**:
  * Trình duyệt cũng thực hiện bước tính toán số lượng rãnh ban đầu giống như `auto-fill`.
  * Tuy nhiên, ngay sau khi các Grid Item đã được đặt vào vị trí, mọi rãnh lặp lại bị trống (**empty repeated tracks**) sẽ bị **thu gọn hoàn toàn về kích thước 0px (`collapsed track`)**, đồng thời các khoảng cách rãnh (gutter) quanh rãnh trống đó cũng biến mất.
  * Nhờ các rãnh rỗng bị thu về 0px, toàn bộ khoảng trống còn dư được dồn hết cho các rãnh đang chứa phần tử thực tế. Các cột này sử dụng `1fr` sẽ tự do nở rộng ra để phủ kín 100% chiều ngang container.

#### 2. Thuật toán phân bổ khoảng trống của đơn vị `1fr`
Theo đặc tả W3C CSS Grid 1 §11.7 (Expand Flexible Tracks), việc phân bổ không gian dư thừa được thực hiện theo quy tắc:

$$\text{Không gian của mỗi cột } 1fr = \frac{\text{Khoảng trống khả dụng (Leftover Space)}}{\text{Tổng các hệ số flex trong hàng}}$$

Trong đó:
$$\text{Khoảng trống khả dụng} = \text{Bề rộng container} - \sum(\text{Kích thước rãnh không linh hoạt}) - \sum(\text{Các khoảng gap})$$

Khi toàn bộ các cột hiển thị đều sử dụng `1fr`, mỗi cột sẽ nhận một phần bằng nhau tuyệt đối, đảm bảo layout luôn cân đối và không xuất hiện khe hở thừa ngoài ý muốn.

---

## Bảng đối chiếu các thuộc tính Grid Container vs Grid Item theo chuẩn W3C

Dưới đây là bảng tra cứu phân loại các thuộc tính CSS Grid Layout Level 1, phân tách chính xác giữa thuộc tính của khung chứa (**Container**) và phần tử con (**Item**):

| Thuộc tính (Property) | Đối tượng áp dụng | Ý nghĩa và hành vi theo chuẩn W3C |
| :--- | :--- | :--- |
| **`display: grid \| inline-grid`** | Grid Container | Thiết lập một Grid Formatting Context độc lập ở cấp độ block-level hoặc inline-level. |
| **`grid-template-columns`** / **`grid-template-rows`** | Grid Container | Định nghĩa danh sách các rãnh cột/hàng tường minh (explicit tracks) bằng kích thước cố định, linh hoạt (`fr`), hàm `minmax()` hoặc `repeat()`. |
| **`grid-template-areas`** | Grid Container | Định nghĩa bản đồ bố cục lưới bằng các chuỗi tên vùng trực quan (ví dụ: `"header header" "main sidebar"`). |
| **`grid-template`** | Grid Container | Cú pháp viết tắt (shorthand) cho đồng thời `grid-template-rows`, `grid-template-columns` và `grid-template-areas`. |
| **`grid-auto-columns`** / **`grid-auto-rows`** | Grid Container | Quy định kích thước mặc định cho các rãnh ngầm định (implicit tracks) tự động sinh ra khi phần tử vượt ra ngoài lưới tường minh. |
| **`grid-auto-flow`** | Grid Container | Điều khiển thuật toán tự động xếp chỗ: theo hàng (`row`), theo cột (`column`), hoặc kích hoạt thuật toán lấp lỗ trống dày đặc (`dense`). |
| **`grid`** | Grid Container | Cú pháp viết tắt tổng quát cấu hình toàn bộ lưới explicit và implicit cùng một lúc. |
| **`gap`** (`row-gap`, `column-gap`) | Grid Container | Quy định khoảng cách rãnh giữa các hàng và các cột trong lưới. |
| **`justify-items`** / **`align-items`** | Grid Container | Thiết lập cách căn chỉnh mặc định cho tất cả các item trong ô lưới của chúng theo trục inline (ngang) và trục block (dọc). |
| **`justify-content`** / **`align-content`** | Grid Container | Căn chỉnh toàn bộ khối lưới (tất cả các track) bên trong container khi tổng kích thước các track nhỏ hơn kích thước container. |
| **`grid-column-start`** / **`grid-column-end`** | Grid Item | Xác định đường lưới bắt đầu và kết thúc của phần tử theo trục cột, hoặc số rãnh trải dài (`span`). |
| **`grid-row-start`** / **`grid-row-end`** | Grid Item | Xác định đường lưới bắt đầu và kết thúc của phần tử theo trục hàng, hoặc số rãnh trải dài (`span`). |
| **`grid-column`** / **`grid-row`** | Grid Item | Cú pháp viết tắt thiết lập đồng thời vị trí bắt đầu và kết thúc theo cột hoặc hàng (`start / end`). |
| **`grid-area`** | Grid Item | Gán phần tử vào một vùng tên xác định trong `grid-template-areas`, hoặc viết tắt cho cả 4 đường `row-start / col-start / row-end / col-end`. |
| **`justify-self`** / **`align-self`** | Grid Item | Ghi đè căn chỉnh riêng cho từng item cụ thể theo trục inline hoặc trục block, tách biệt với quy tắc chung của container. |
| **`order`** | Grid Item | Tái sắp xếp thứ tự hiển thị trực quan của item mà không làm thay đổi cấu trúc cây tài liệu DOM. |
| **`z-index`** | Grid Item | Xác định thứ tự lớp hiển thị theo trục Z khi các Grid Item xếp chồng lên nhau. |

---

## Mã giải pháp hoàn chỉnh (`solution.css`)

Dưới đây là phần mã CSS hoàn chỉnh cho giao diện sau khi hoàn thành tất cả nhiệm vụ:

```css
/* 1. Kích hoạt Grid và thiết lập bố cục Responsive tự động */
.events-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 20px;
}

/* 2. Cho phép thẻ Keynote mở rộng 2 cột trên màn hình đủ rộng */
.event-card.featured {
  grid-column: span 2;
}

/* 3. Đảm bảo trên màn hình cực hẹp thẻ featured không vượt quá 1 cột */
@media (max-width: 520px) {
  .event-card.featured {
    grid-column: span 1;
  }
}
```

---

## References

* [W3C CSS Grid Layout Module Level 1 Specification](https://www.w3.org/TR/css-grid-1/)
* [W3C CSS Box Alignment Module Level 3](https://www.w3.org/TR/css-align-3/)
