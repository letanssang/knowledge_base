---
title: "CSS Syntax, Specificity và Bản chất của Box Model"
description: "Khám phá cơ chế tính toán kích thước phần tử, độ ưu tiên chọn lọc trong CSS và nguyên lý Margin Collapsing theo chuẩn W3C."

date:
updated:

series: "HTML & CSS Basic"
series_order: 4

tags:
  - css
  - box-model
  - specificity
  - beginner

status: draft
language: vi
---

# CSS Syntax, Specificity và Bản chất của Box Model

Trong quá trình làm việc với CSS, hầu như lập trình viên nào cũng từng gặp phải hai hiện tượng dường như vô lý nhưng lại xuất hiện như cơm bữa:

1. Bạn tạo một chiếc thẻ `<div>`, đặt `width: 300px`, sau đó thêm `padding: 20px` và viền `border: 2px`. Nhưng khi mở trình duyệt lên đo, chiếc hộp đó lại phình to ra thành **344px**, đẩy văng các khối khác và làm vỡ tan nát bố cục giao diện!
2. Bạn đặt hai đoạn văn `<p>` đứng liền nhau, mỗi đoạn đều có `margin: 20px`. Về mặt toán học, $20 + 20$ phải bằng **40px**, nhưng thước đo của trình duyệt lại chỉ hiển thị khoảng cách **20px**.

Đây hoàn toàn không phải lỗi của trình duyệt! Chúng là kết quả trực tiếp từ các nguyên lý nền tảng trong đặc tả W3C: **Độ ưu tiên chọn lọc (Specificity)**, **Mô hình hộp (Box Model)**, và **Hiện tượng gộp lề (Margin Collapsing)**.

---

## 1. Cú pháp CSS và Bảng điểm độ ưu tiên (Specificity)

Một bộ quy tắc CSS (Rule set) gồm có **bộ chọn (Selector)** và **khối khai báo (Declaration)**:

```css
/* selector { property: value; } */
p.intro {
  color: #1a73e8;
  font-size: 1.125rem;
}
```

Khi có nhiều quy tắc cùng nhắm vào một phần tử và đưa ra các màu sắc hay kích thước trái ngược nhau, trình duyệt sẽ giải quyết xung đột bằng cách tính **Bảng điểm Specificity (Trọng số ưu tiên)**:

```text
┌───────────────────────────────────┬───────────────┬────────────────────────┐
│ Bộ chọn (Selector)                │ Điểm tượng trưng│ Ví dụ                  │
├───────────────────────────────────┼───────────────┼────────────────────────┤
│ Inline style (Viết thẳng vào thẻ)  │ 1000 điểm     │ style="color: red"     │
│ ID Selector                       │ 100 điểm      │ #main-nav              │
│ Class, Pseudo-class, Attribute    │ 10 điểm       │ .btn, :hover, [type]   │
│ Element (Tên thẻ), Pseudo-element │ 1 điểm        │ div, p, ::before       │
│ Universal (Bộ chọn toàn cục)      │ 0 điểm        │ *                      │
└───────────────────────────────────┴───────────────┴────────────────────────┘
```

> **Quy tắc tính điểm thi đấu:**
> * `#header .menu a` $\rightarrow$ 1 ID (100) + 1 Class (10) + 1 Tag (1) = **111 điểm**.
> * `.nav-list .item a` $\rightarrow$ 2 Class (20) + 1 Tag (1) = **21 điểm**.
> * **Kết quả:** Quy tắc 111 điểm chiến thắng tuyệt đối, bất chấp thứ tự viết trước hay viết sau.
> * Nếu hai bên hòa điểm nhau, quy tắc nào được trình duyệt **đọc sau** trong file CSS sẽ là người chiến thắng cuối cùng.

*(Cảnh báo: Từ khóa `!important` là "nút bấm hạt nhân" ghi đè mọi điểm số. Tuyệt đối không lạm dụng nó vì sẽ làm mất khả năng kiểm soát CSS trong các dự án lớn).*

---

## 2. Bốn lớp không gian của CSS Box Model

Theo chuẩn W3C, trình duyệt coi **mọi phần tử HTML trên trang web đều là một khối hộp chữ nhật**. Chiếc hộp này được cấu thành từ 4 lớp không gian lồng nhau từ trong ra ngoài:

```text
┌──────────────────────── MARGIN (Khoảng lề ngoài) ────────────────────────┐
│                                                                          │
│  ┌───────────────────── BORDER (Đường viền khung) ────────────────────┐  │
│  │                                                                    │  │
│  │  ┌────────────────── PADDING (Khoảng đệm trong) ────────────────┐  │  │
│  │  │                                                              │  │  │
│  │  │  ┌─────────────── CONTENT (Vùng nội dung) ────────────────┐  │  │  │
│  │  │  │  Chứa văn bản, hình ảnh, video...                      │  │  │  │
│  │  │  │  (width x height)                                      │  │  │  │
│  │  │  └────────────────────────────────────────────────────────┘  │  │  │
│  │  │                                                              │  │  │
│  │  └──────────────────────────────────────────────────────────────┘  │  │
│  │                                                                    │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

Hãy liên tưởng Box Model như một kiện hàng gửi bưu điện:
1. **Content (Nội dung)**: Là món đồ gốm sứ dễ vỡ bạn muốn gửi đi.
2. **Padding (Khoảng đệm)**: Là lớp xốp nổ bọc quanh món đồ để tạo khoảng cách an toàn với thành hộp. Lớp này **luôn mang màu nền (background)** của phần tử.
3. **Border (Đường viền)**: Là chiếc thùng các-tông cứng cáp bao ngoài chiếc hộp.
4. **Margin (Lề ngoài)**: Là khoảng cách an toàn giữa chiếc thùng này với các kiện hàng khác đặt xung quanh trên xe tải. Lớp này **luôn trong suốt** (nhìn xuyên thấu xuống nền của thẻ cha).

---

## 3. Bản chất kích thước: `content-box` vs `border-box`

Bây giờ chúng ta sẽ giải mã câu hỏi: *"Tại sao đặt `width: 300px` nhưng chiếc hộp lại phình ra `344px`?"*

### A. Mô hình mặc định: `box-sizing: content-box` (Chiếc hộp phản bội)
Trong mô hình mặc định của W3C ngày xưa: thuộc tính `width` chỉ áp dụng cho **riêng vùng lõi Content**:

$$\text{Tổng chiều rộng thực tế} = \text{width} + \text{padding-trái} + \text{padding-phải} + \text{border-trái} + \text{border-phải}$$

$$300\text{px} + 20\text{px} + 20\text{px} + 2\text{px} + 2\text{px} = \mathbf{344px}$$

Cơ chế này khiến việc chia layout theo phần trăm trở thành cơn ác mộng: Bạn muốn chia đôi màn hình làm 2 cột $50\%$, nhưng chỉ cần thêm `padding: 10px` vào mỗi bên, tổng chiều rộng sẽ vượt quá $100\%$ và cột thứ hai lập tức bị rớt dòng!

### B. Vị cứu tinh của thế giới Web: `box-sizing: border-box`
Khi sử dụng `border-box`, thuộc tính `width: 300px` sẽ bao trùm từ mép viền bên trái sang mép viền bên phải:

```text
             Tổng kích thước cố định = 300px
├──────────────────────────────────────────────────────┤
[border: 2px][padding: 20px][  Content: 256px  ][padding: 20px][border: 2px]
```

Trình duyệt sẽ **tự động co hẹp ruột Content lại còn 256px**, đảm bảo tổng chiếc hộp bên ngoài luôn chuẩn xác đúng $300\text{px}$ như bạn mong muốn.

> [!TIP]
> ### Khai báo Reset chuẩn mực cho mọi dự án
> Hầu hết mọi thư viện (Bootstrap, Tailwind) và các lập trình viên chuyên nghiệp đều đặt đoạn mã reset này ở ngay dòng đầu tiên của tập tin CSS:
> ```css
> *, *::before, *::after {
>   box-sizing: border-box;
> }
> ```

---

## 4. Hiện tượng gộp lề dọc (Margin Collapsing)

Tại sao hai đoạn văn xếp chồng lên nhau với `margin: 20px` thì khoảng cách thực tế giữa chúng lại là **20px** chứ không phải **40px**?

```text
┌───────────────────────────┐
│        Đoạn văn 1         │
└───────────────────────────┘
          │ margin-bottom: 20px
          ▼
      [ Khoảng trống: 20px ] ◄── Không cộng dồn thành 40px!
          ▲
          │ margin-top: 20px
┌───────────────────────────┐
│        Đoạn văn 2         │
└───────────────────────────┘
```

Theo quy chuẩn W3C, khi các khoảng lề dọc của các khối (Block) đứng kề nhau, chúng không cộng dồn mà **chập lại thành một khoảng lề duy nhất có giá trị bằng số lớn nhất**:

$$\text{Khoảng cách thực tế} = \max(\text{margin-bottom}_1, \text{margin-top}_2)$$

*Ví dụ:* Nếu đoạn trên có `margin-bottom: 30px`, đoạn dưới có `margin-top: 10px`, khoảng cách giữa chúng sẽ là **30px** (vì $\max(30, 10) = 30$).

* **Vì sao W3C lại thiết kế như vậy?** Để đảm bảo tính tự nhiên khi dàn trang tài liệu văn bản. Nếu không có cơ chế này, khoảng cách giữa các đoạn văn sẽ bị nhân đôi một cách bất thường so với khoảng cách của đoạn đầu tiên với mép trang.
* **Khi nào gộp lề KHÔNG xảy ra?**
  * Khoảng lề ngang (`margin-left`, `margin-right`) **không bao giờ gộp**.
  * Các phần tử nằm bên trong vùng chứa **Flexbox** hoặc **CSS Grid** **không bị gộp lề dọc**.

---

## 5. Tổng kết

* **Specificity**: Cuộc đua điểm số (Inline $1000$ > ID $100$ > Class $10$ > Tag $1$) giải quyết xung đột CSS.
* **Box Model**: 4 lớp (Content $\rightarrow$ Padding $\rightarrow$ Border $\rightarrow$ Margin).
* **border-box**: Bí quyết số 1 để kiểm soát kích thước chính xác, tránh phình to layout.
* **Margin Collapsing**: Cơ chế chập lề dọc theo giá trị lớn nhất ($\max$).

---

## References

- [CSS 2.1 Specification: Box model • W3C](https://www.w3.org/TR/CSS2/box.html)
- [CSS Box Model • MDN Web Docs](https://developer.mozilla.org/en-US/docs/Learn/CSS/Building_blocks/The_box_model)

---

## Series

- Previous: [Thu thập Dữ liệu Người dùng với HTML Forms](../03-html-forms-and-validation/index.md)
- [Thực hành](./practice.md)
- Next: [Đơn vị đo, Typography và Màu sắc trong CSS](../05-units-typography-and-colors/index.md)

