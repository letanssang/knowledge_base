---
title: "Styling trong Component và Cơ chế View Encapsulation"
description: "Khám phá cách Angular cô lập mã CSS để bảo vệ giao diện: tại sao style trong component không bị rò rỉ ra toàn cục và cách sử dụng selector :host."

date:
updated:

series: "Angular Basic"
series_order: 5

tags:
  - angular
  - frontend
  - styling
  - beginner

status: draft
language: vi
---

# Styling trong Component và Cơ chế View Encapsulation

Một trong những "cơn ác mộng" lớn nhất khi xây dựng các trang web truyền thống là quản lý mã CSS. Khi dự án phình to với hàng chục lập trình viên cùng tham gia, việc một ai đó vô tình viết quy tắc `button { background: red; }` trong một tệp style có thể khiến toàn bộ nút bấm trên khắp website bị biến thành màu đỏ ngoài ý muốn. Xung đột tên class và quy tắc CSS ghi đè lẫn nhau (CSS specificity war) luôn là bài toán đau đầu.

Angular giải quyết triệt để nỗi lo này ngay từ cấp độ kiến trúc thông qua cơ chế **View Encapsulation** (đóng gói phạm vi giao diện).

## Cơ chế cô lập CSS mặc định hoạt động ra sao?

Khi bạn khai báo style bên trong một component—dù là inline qua `styles` hay tệp rời qua `styleUrl`—Angular mặc định sẽ giam giữ các quy tắc CSS đó chỉ trong phạm vi template của chính component đó:

```typescript
import { Component } from '@angular/core';

@Component({
  selector: 'app-alert-box',
  template: `
    <div class="box">
      <p>Đây là thông báo quan trọng!</p>
    </div>
  `,
  styles: `
    .box {
      border: 2px solid red;
      padding: 16px;
    }
    p {
      color: red;
      font-weight: bold;
    }
  `
})
export class AlertBoxComponent {}
```

Dù đoạn mã trên có khai báo thẻ `p` có màu đỏ (`color: red`), các thẻ `p` ở các component khác trên trang web hoàn toàn không bị ảnh hưởng.

Điều kỳ diệu này diễn ra như thế nào? Khi biên dịch, Angular sẽ tự động sinh ra các thuộc tính HTML duy nhất (dạng như `_ngcontent-ng-c123456`) và gắn vào các phần tử HTML bên trong template, đồng thời điều chỉnh quy tắc CSS tương ứng thành `p[_ngcontent-ng-c123456] { color: red; }`. Bằng cách giả lập cơ chế đóng gói (Emulated Shadow DOM), Angular đảm bảo style của bạn chỉ áp dụng chính xác cho các phần tử thuộc về component đó.

## Selector đặc biệt: Tạo kiểu cho chính Host Element với :host

Như đã tìm hiểu ở Bài 1, bản thân component được bao bọc bởi một thẻ HTML gọi là **Host Element** (ví dụ thẻ `<app-alert-box>`). Nhưng làm thế nào để bạn tạo kiểu dáng cho chính chiếc khung bao bên ngoài này?

Angular cung cấp selector giả `:host` để làm điều đó:

```typescript
@Component({
  selector: 'app-badge',
  template: `<span>Mới</span>`,
  styles: `
    :host {
      display: inline-block;
      background-color: #ff4081;
      color: white;
      padding: 2px 8px;
      border-radius: 12px;
      font-size: 12px;
    }
  `
})
export class BadgeComponent {}
```

Mọi quy tắc viết bên trong khối `:host` sẽ được áp dụng trực tiếp lên thẻ `<app-badge>`. Bạn có thể dùng `:host` để đặt `display: block`, kích thước `width`/`height`, viền ngoài hoặc hiệu ứng đổ bóng cho toàn bộ khối component.

## Các chế độ View Encapsulation

Trong trường hợp bạn cần tùy chỉnh cách Angular xử lý CSS, bạn có thể truyền thuộc tính `encapsulation` vào metadata của `@Component`:

- **`ViewEncapsulation.Emulated` (Mặc định):** Giả lập đóng gói bằng các thuộc tính định danh duy nhất. Đây là lựa chọn an toàn và tối ưu nhất cho đại đa số trường hợp.
- **`ViewEncapsulation.None`:** Vô hiệu hóa tính năng đóng gói. Mọi quy tắc CSS viết trong component này sẽ trở thành CSS toàn cục (global) và áp dụng lên toàn bộ trang web.
- **`ViewEncapsulation.ShadowDom`:** Sử dụng tính năng Shadow DOM gốc của trình duyệt để cô lập hoàn toàn cả DOM lẫn CSS.

Nhờ có cơ chế đóng gói thông minh này, bạn có thể tự tin đặt các tên class ngắn gọn, tự nhiên như `.title`, `.card`, `.btn` trong mỗi component mà không bao giờ phải lo sợ việc chúng đè bẹp kiểu dáng của nhau. Ở bài học tiếp theo, chúng ta sẽ bước vào một trong những tính năng đột phá nhất của Angular hiện đại: **Angular Signals**.

## References

- [Anatomy of components • Angular](https://angular.dev/guide/components)
- [What is Angular? • Angular](https://angular.dev/overview)

## Series

Previous: [Giao tiếp giữa các Component: Input và Output](../04-component-interaction/index.md)

Next: [Làm quen với Angular Signals: Trạng thái Reactive Đơn giản](../06-introduction-to-signals/index.md)
