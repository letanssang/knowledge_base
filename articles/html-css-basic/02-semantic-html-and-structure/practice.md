[Lý thuyết](./index.md)

Trong bài thực hành này, bạn sẽ tiến hành nâng cấp và tái cấu trúc (refactor) mã nguồn của trang thông báo sự kiện **"Hội thảo Web Frontend 2026"**. Trang web hiện tại đang gặp tình trạng **"div soup"** (sử dụng tràn lan thẻ `<div>` không mang ý nghĩa ngữ nghĩa), gây cản trở nghiêm trọng đến khả năng tiếp cận (Accessibility - a11y), máy tìm kiếm (SEO) và cấu trúc cây tài liệu.

Bằng cách áp dụng các thẻ Semantic HTML theo chuẩn WHATWG HTML Standard, bạn sẽ chuyển đổi trang web thành một cấu trúc chuẩn mực, tối ưu cho Accessibility Tree và các thiết bị trợ năng.

---

## Mục tiêu và Tiêu chí hoàn thành

### Mục tiêu học tập
- **Bản chất Landmark và Semantic Tags**: Hiểu rõ vai trò của các vùng mốc (`header`, `nav`, `main`, `section`, `article`, `aside`, `footer`) trong việc cung cấp ngữ nghĩa cho trình duyệt và thiết bị trợ năng.
- **Phân cấp Tiêu đề (Heading Hierarchy)**: Nắm vững quy tắc phân cấp tiêu đề `<h1>` đến `<h6>`, không nhảy cóc cấp độ tiêu đề.
- **Phân biệt `section` vs `article` vs `div`**: Biết chính xác khi nào dùng thẻ chuyên biệt và khi nào nên giữ lại `<div>` cho mục đích styling thuần túy.
- **Sử dụng đúng thẻ `<address>`**: Áp dụng đúng quy định của WHATWG cho thông tin liên hệ của tác giả/ban quản trị, tránh lạm dụng cho địa chỉ thông thường.

### Tiêu chí hoàn thành
1. Mở file `starter.html` trong trình duyệt, sử dụng tab **Accessibility** của DevTools để xác nhận tình trạng thiếu vắng các mốc điều hướng (Landmarks).
2. Tái cấu trúc thành công trang web sang Semantic HTML, bao gồm đầy đủ `header`, `nav`, `main`, `section`, `article`, `aside`, `footer` và `address`.
3. Kiểm tra bằng bàn phím (phím `Tab` và `Enter`), xác nhận nhảy tiêu điểm mượt mà qua các liên kết trong `nav` đến đúng điểm neo `id` trong tài liệu.
4. Đảm bảo cấu trúc heading đạt chuẩn tuyến tính (`h1` -> `h2` -> `h3`), không có cảnh báo nhảy cóc cấp độ.

---

## Chuẩn bị môi trường và file mẫu

File khởi đầu đã được chuẩn bị sẵn tại [assets/practice/starter.html](./assets/practice/starter.html).

Mã nguồn file `assets/practice/starter.html`:

```html
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Hội thảo Web Frontend 2026</title>
</head>
<body>
  <!-- Cấu trúc Div Soup chưa có thẻ Semantic -->
  <div class="header">
    <div class="title">Hội thảo Web Frontend 2026</div>
    <div class="nav">
      <a href="#intro">Giới thiệu</a>
      <a href="#schedule">Lịch trình</a>
      <a href="#side-info">Thông tin bổ sung</a>
      <a href="#contact">Liên hệ</a>
    </div>
  </div>

  <div class="content">
    <div class="main-section">
      <div id="intro" class="block">
        <div class="heading">Về hội thảo</div>
        <p>Sự kiện thường niên dành cho cộng đồng lập trình viên Web nhằm chia sẻ xu hướng công nghệ mới nhất.</p>
      </div>

      <div id="schedule" class="block">
        <div class="heading">Lịch trình chi tiết</div>
        
        <div class="session">
          <div class="subheading">Khai mạc & Keynote: Xu hướng Frontend 2026</div>
          <p>Trình bày bởi Diễn giả Nguyễn Văn A - Chuyên gia Web Architecture.</p>
        </div>

        <div class="session">
          <div class="subheading">Tối ưu Accessibility với Semantic HTML</div>
          <p>Trình bày bởi Diễn giả Trần Thị B - Accessibility Specialist.</p>
        </div>
      </div>
    </div>

    <div class="sidebar">
      <div class="heading">Thông tin bên lề</div>
      <p>Địa điểm: Trung tâm Hội nghị Quốc gia, Hà Nội.</p>
      <p>Wifi miễn phí: FrontendConf2026 (Mật khẩu: semantic2026)</p>
    </div>
  </div>

  <div class="footer">
    <p>&copy; 2026 Ban tổ chức Hội thảo Web Frontend.</p>
    <div class="contact">
      Mọi thắc mắc xin liên hệ tác giả: contact@webfrontend2026.vn
    </div>
  </div>
</body>
</html>
```

---

## Nhiệm vụ 1: Dùng DevTools kiểm tra cấu trúc Div Soup

1. Mở file `assets/practice/starter.html` trên trình duyệt web (Chrome, Edge hoặc Firefox).
2. Nhấn `F12` (hoặc `Cmd + Option + I` trên macOS) để mở DevTools.
3. Chuyển sang tab **Elements** và quan sát sơ đồ DOM:
   - Tất cả các khối đều được bao bọc bởi thẻ `<div>`.
   - Trình duyệt và trình đọc màn hình (Screen Reader) chỉ nhận diện đây là các thẻ khối vô danh (`generic`), hoàn toàn không có vai trò đặc biệt.
4. Chuyển sang tab **Accessibility** (hoặc kích hoạt chế độ xem **Full-page accessibility tree** trong phần cài đặt DevTools):
   - **Hiện tượng**: Cây truy cập hoàn toàn trống rỗng các vùng mốc định vị (**Landmarks**).
   - **Hậu quả thực tế**: Người khiếm thị sử dụng Screen Reader không thể dùng phím tắt để nhảy nhanh đến vùng điều hướng (`navigation`), vùng nội dung chính (`main`) hay chân trang (`contentinfo`).

---

## Nhiệm vụ 2: Tái cấu trúc trang web theo chuẩn Semantic HTML

Áp dụng tiêu chuẩn **WHATWG HTML Standard** để chuyển đổi mã nguồn:
- Thẻ `<header>`: Nhóm các thành phần giới thiệu và đầu trang.
- Thẻ `<h1>`: Tiêu đề cấp cao nhất và quan trọng nhất của toàn trang.
- Thẻ `<nav>`: Bọc danh sách các liên kết điều hướng chính của trang.
- Thẻ `<main>`: Đại diện cho khối nội dung chính duy nhất của tài liệu.
- Thẻ `<section>`: Phân chia các khối nội dung theo chủ đề có tiêu đề `<h2>` tương ứng.
- Thẻ `<article>`: Bọc các phiên thuyết trình độc lập, tự hoàn chỉnh về mặt nội dung.
- Thẻ `<aside>`: Chứa thông tin bên lề, phụ thuộc gián tiếp vào nội dung sự kiện.
- Thẻ `<footer>`: Chân trang cho tài liệu.
- Thẻ `<address>`: Chứa thông tin liên hệ của tác giả/ban tổ chức.

### Mã nguồn hoàn chỉnh sau khi refactor

```html
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Hội thảo Web Frontend 2026</title>
</head>
<body>
  <!-- Header: Đầu trang chứa tiêu đề và thanh điều hướng chính -->
  <header>
    <h1>Hội thảo Web Frontend 2026</h1>
    <nav aria-label="Điều hướng chính">
      <ul>
        <li><a href="#intro">Giới thiệu</a></li>
        <li><a href="#schedule">Lịch trình</a></li>
        <li><a href="#side-info">Thông tin bổ sung</a></li>
        <li><a href="#contact">Liên hệ</a></li>
      </ul>
    </nav>
  </header>

  <!-- Main: Khối nội dung chính của tài liệu -->
  <main>
    <!-- Section: Chủ đề Giới thiệu -->
    <section id="intro">
      <h2>Về hội thảo</h2>
      <p>Sự kiện thường niên dành cho cộng đồng lập trình viên Web nhằm chia sẻ xu hướng công nghệ mới nhất.</p>
    </section>

    <!-- Section: Chủ đề Lịch trình -->
    <section id="schedule">
      <h2>Lịch trình chi tiết</h2>
      
      <!-- Article: Các phiên thảo luận độc lập -->
      <article>
        <h3>Khai mạc & Keynote: Xu hướng Frontend 2026</h3>
        <p>Trình bày bởi Diễn giả Nguyễn Văn A - Chuyên gia Web Architecture.</p>
      </article>

      <article>
        <h3>Tối ưu Accessibility với Semantic HTML</h3>
        <p>Trình bày bởi Diễn giả Trần Thị B - Accessibility Specialist.</p>
      </article>
    </section>

    <!-- Aside: Thông tin phụ/bên lề -->
    <aside id="side-info">
      <h2>Thông tin bên lề</h2>
      <p>Địa điểm: Trung tâm Hội nghị Quốc gia, Hà Nội.</p>
      <p>Wifi miễn phí: FrontendConf2026 (Mật khẩu: semantic2026)</p>
    </aside>
  </main>

  <!-- Footer: Chân trang -->
  <footer>
    <p>&copy; 2026 Ban tổ chức Hội thảo Web Frontend.</p>
    <!-- Address: Thông tin liên hệ tác giả/ban tổ chức -->
    <address id="contact">
      Mọi thắc mắc xin liên hệ tác giả: <a href="mailto:contact@webfrontend2026.vn">contact@webfrontend2026.vn</a>
    </address>
  </footer>
</body>
</html>
```

---

## Nhiệm vụ 3: Kiểm tra phím Tab và Heading Outline

1. **Kiểm tra di chuyển bàn phím (Keyboard Navigation)**:
   - Mở file HTML đã refactor trên trình duyệt.
   - Nhấn phím `Tab` liên tục để di chuyển tiêu điểm (focus) qua các liên kết `<a>` trong `<nav>`.
   - Nhấn `Enter` khi tiêu điểm dừng ở một liên kết (ví dụ: `#schedule`) để kiểm tra xem trình duyệt có tự động cuộn màn hình tới đúng phần tử mang `id` tương ứng trong `<main>` hay không.
2. **Kiểm tra phân cấp Tiêu đề (Heading Hierarchy)**:
   - Mở DevTools, kiểm tra cây tiêu đề để đảm bảo tính liên tục theo quy định WHATWG: `<h1>` -> `<h2>` -> `<h3>`.
   - Xác minh không có tình trạng nhảy cóc cấp độ tiêu đề (như từ `<h1>` nhảy trực tiếp xuống `<h3>`).

---

## Bảng đối chiếu các thẻ trước và sau khi Refactor

| Vùng / Chức năng | Trước refactor (Div Soup) | Sau refactor (Semantic HTML) | Ý nghĩa Semantic theo chuẩn WHATWG |
| --- | --- | --- | --- |
| **Đầu trang & Tiêu đề** | `<div class="header">`, `<div class="title">` | `<header>`, `<h1>` | Nhóm các thành phần giới thiệu/điều hướng và tiêu đề cấp cao nhất của trang. |
| **Thanh điều hướng** | `<div class="nav">` | `<nav>` | Định nghĩa vùng chứa các liên kết điều hướng quan trọng. |
| **Nội dung chính** | `<div class="content">`, `<div class="main-section">` | `<main>` | Chứa nội dung trọng tâm, không lặp lại của tài liệu. |
| **Khối chủ đề** | `<div class="block">`, `<div class="heading">` | `<section>`, `<h2>` | Nhóm nội dung theo chủ đề có tiêu đề đi kèm. |
| **Phiên họp/Bài viết** | `<div class="session">`, `<div class="subheading">` | `<article>`, `<h3>` | Khối nội dung tự hoàn chỉnh, có thể trích xuất/tái sử dụng độc lập. |
| **Thông tin phụ** | `<div class="sidebar">` | `<aside>` | Nội dung liên quan gián tiếp hoặc phụ thuộc vào phần xung quanh. |
| **Chân trang** | `<div class="footer">` | `<footer>` | Chân trang chứa thông tin bản quyền hoặc liên kết phụ. |
| **Thông tin liên hệ** | `<div class="contact">` | `<address>` | Chứa thông tin liên lạc của tác giả hoặc ban quản trị tài liệu. |

---

## Lỗi thường gặp và cách khắc phục khi dùng thẻ Semantic

1. **Nhảy cóc cấp độ Tiêu đề (Skipping Heading Levels)**:
   - *Lỗi*: Sử dụng `<h1>` rồi nhảy ngay xuống `<h3>` vì muốn cỡ chữ hiển thị nhỏ hơn.
   - *Khắc phục*: Cấu trúc heading phải tăng dần không quá 1 cấp (`<h1>` -> `<h2>` -> `<h3>`). Nếu muốn chỉnh kích thước hiển thị chữ, sử dụng thuộc tính `font-size` trong CSS.
2. **Lạm dụng thẻ `<address>` cho địa chỉ bưu chính/địa điểm thông thường**:
   - *Lỗi*: Đặt địa chỉ tòa nhà hoặc địa điểm tổ chức sự kiện vào thẻ `<address>`.
   - *Khắc phục*: Theo chuẩn WHATWG, `<address>` chỉ dùng cho **thông tin liên lạc của tác giả/ban quản trị** tài liệu hoặc bài viết. Địa chỉ địa lý thông thường nên đặt trong thẻ `<p>`.
3. **Thay thế toàn bộ `<div>` bằng `<section>` một cách cảm tính**:
   - *Lỗi*: Đổi tất cả thẻ `<div>` thành `<section>` dù khối đó chỉ dùng để bọc CSS layout.
   - *Khắc phục*: Thẻ `<section>` chỉ dùng khi nhóm nội dung đó có chung một chủ đề và có tiêu đề đi kèm. Nếu chỉ dùng để bọc bố cục hoặc trang trí CSS, giữ nguyên thẻ `<div>`.
4. **Bọc tất cả các nhóm liên kết vào thẻ `<nav>`**:
   - *Lỗi*: Đặt cả danh sách liên kết điều khoản dịch vụ nhỏ ở chân trang vào thẻ `<nav>`.
   - *Khắc phục*: Thẻ `<nav>` chỉ dành cho các khối điều hướng chính của trang web. Danh sách vài liên kết nhỏ ở chân trang chỉ cần nằm trong `<footer>`.
5. **Nhầm lẫn giữa `<article>` và `<section>`**:
   - *Lỗi*: Không phân biệt được khi nào dùng `<article>` hay `<section>`.
   - *Khắc phục*: Sử dụng `<article>` khi nội dung có thể đứng độc lập và có ý nghĩa khi tách rời khỏi trang (bài viết, bình luận, phiên thuyết trình độc lập). Sử dụng `<section>` khi nội dung là một phần cấu thành của một tổng thể lớn hơn.

---

## References

- [WHATWG HTML Standard - Sections](https://html.spec.whatwg.org/multipage/sections.html#sections): Đặc tả quy chuẩn cho các phần tử sectioning, headings và landmarks.
- [WHATWG HTML Standard - Headings and outlines](https://html.spec.whatwg.org/multipage/sections.html#headings-and-outlines-2): Quy định về cấp bậc tiêu đề và cấu trúc outline tài liệu.
- [WHATWG HTML Standard - The address element](https://html.spec.whatwg.org/multipage/sections.html#the-address-element): Phạm vi sử dụng chính xác cho thẻ thông tin liên hệ tác giả.
