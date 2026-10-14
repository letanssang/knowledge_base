---
title: "Angular là gì? Tư duy Component và Ứng dụng đầu tiên"
description: "Nhập môn Angular dành cho lập trình viên web: chuyển đổi từ tư duy DOM truyền thống sang kiến trúc Component, hiểu cách Component đóng gói logic và giao diện, và cách tạo component đầu tiên."

date:
updated:

series: "Angular Basic"
series_order: 1

tags:
  - angular
  - frontend
  - components
  - beginner

status: draft
language: vi
---

# Angular là gì? Tư duy Component và Ứng dụng đầu tiên

Nếu từng xây dựng một trang web bằng HTML, CSS và JavaScript thuần, bạn hẳn quen thuộc với chu trình làm việc kinh điển: viết mã HTML để dựng khung, thêm CSS để tạo kiểu, rồi dùng JavaScript để tìm phần tử DOM, lắng nghe sự kiện click và cập nhật lại giao diện. Hãy hình dung một chức năng đơn giản như nút bấm đếm số lần click:

```javascript
const button = document.querySelector('#btn-count');
let count = 0;

button.addEventListener('click', () => {
  count++;
  button.textContent = `Đã bấm ${count} lần`;
});
```

Cách làm này rất trực quan khi trang web chỉ có một vài nút bấm. Thế nhưng khi ứng dụng phát triển lớn hơn—với giỏ hàng, bảng dữ liệu, hộp thoại và nhiều màn hình tương tác phức tạp—việc tự tay tìm kiếm từng phần tử DOM (`getElementById`, `querySelector`) và gán lại `textContent` hay `innerHTML` trở thành một gánh nặng khổng lồ. Dữ liệu thực tế và giao diện hiển thị rất dễ lệch pha nhau nếu bạn lỡ quên cập nhật một thẻ HTML nào đó. Đó chính là lý do Angular ra đời.

## Angular giải quyết vấn đề gì?

Angular là một nền tảng và web framework mã nguồn mở do Google phát triển, được thiết kế để xây dựng các ứng dụng web hiện đại (Single Page Applications - SPA) từ quy mô nhỏ đến các hệ thống doanh nghiệp lớn.

Thay vì bắt lập trình viên phải trực tiếp can thiệp vào từng nút DOM trên trang, Angular thay đổi hoàn toàn cách tiếp cận thông qua hai nguyên lý cốt lõi:

1. **Kiến trúc hướng thành phần (Component-based Architecture):** Toàn bộ giao diện người dùng được chia nhỏ thành các khối độc lập, có thể tái sử dụng, gọi là các **Component**. Một trang web không còn là một tệp HTML khổng lồ hỗn độn, mà là sự lắp ghép của nhiều component như thanh điều hướng (`Navbar`), thẻ sản phẩm (`ProductCard`), hay khung bình luận (`CommentBox`).
2. **Tự động đồng bộ Dữ liệu và Giao diện (Declarative Rendering):** Bạn chỉ cần khai báo dữ liệu trong mã nguồn và mô tả cách hiển thị dữ liệu đó trong template HTML. Mỗi khi dữ liệu thay đổi, Angular sẽ tự động tính toán và cập nhật chính xác phần DOM tương ứng trên màn hình mà bạn không cần viết bất kỳ dòng lệnh thao tác DOM thủ công nào.

## Giải phẫu một Component đầu tiên

Hãy xem chức năng nút bấm đếm số lần click ở trên được viết bằng Angular hiện đại như thế nào:

```typescript
import { Component } from '@angular/core';

@Component({
  selector: 'app-counter',
  template: `
    <button (click)="increment()">Đã bấm {{ count }} lần</button>
  `,
  styles: `
    button {
      padding: 8px 16px;
      border: 1px solid #ccc;
      border-radius: 4px;
      cursor: pointer;
    }
  `
})
export class CounterComponent {
  count = 0;

  increment() {
    this.count++;
  }
}
```

Nhìn vào đoạn mã trên, một Angular Component luôn được cấu thành từ ba phần chính:

- **Lớp TypeScript (`CounterComponent`):** Nơi chứa trạng thái dữ liệu (`count = 0`) và các hàm xử lý logic (`increment()`). Đây chính là bộ não điều khiển hành vi của component.
- **Template HTML (`template`):** Bản thiết kế giao diện. Cú pháp `{{ count }}` (interpolation) cho phép hiển thị giá trị của biến `count` ra màn hình, còn `(click)="increment()"` (event binding) báo cho Angular biết cần gọi hàm `increment()` khi người dùng nhấn nút.
- **CSS Selector (`selector: 'app-counter'`):** Tên định danh do bạn tự đặt để biến component thành một thẻ HTML tùy chỉnh. Bất cứ khi nào bạn đặt thẻ `<app-counter />` vào giao diện, Angular sẽ khởi tạo và hiển thị component này tại đó.

Để kết nối lớp TypeScript với template và selector, Angular sử dụng decorator `@Component`. Dữ liệu cấu hình truyền vào decorator này được gọi là **metadata**. Metadata chính là bảng chỉ dẫn để Angular biết cách lắp ráp và vận hành component.

Bạn có thể viết trực tiếp template và styles bên trong decorator (inline), hoặc tách chúng ra các tệp riêng biệt bằng cách dùng `templateUrl` và `styleUrl` trỏ tới đường dẫn tương đối trong cùng thư mục. Ngoài ra, các quy tắc CSS định nghĩa bên trong một component mặc định chỉ có hiệu lực với các phần tử thuộc template của chính component đó, giúp bạn thoải mái tạo kiểu mà không lo ảnh hưởng đến các phần khác của trang web.

## Selector, Host Element và View vận hành ra sao?

Khi ứng dụng chạy trên trình duyệt, Angular quét qua mã HTML để tìm các phần tử khớp với CSS selector của component.

Phần tử HTML thực tế khớp với selector được gọi là **Host Element**. Trong ví dụ trên, chính thẻ `<app-counter>` xuất hiện trên cây DOM là Host Element. Nội dung do template sinh ra nằm bên trong Host Element được gọi là **View** của component.

Có thể hình dung Host Element như chiếc khung tranh bên ngoài tiếp giáp với phần còn lại của căn phòng, còn View là bức tranh hiển thị chi tiết bên trong khung. Cứ mỗi lần phát hiện một thẻ `<app-counter>` trên trang, Angular sẽ tạo ra một bản thể (instance) component riêng biệt với dữ liệu và vòng đời độc lập.

## Kiến trúc Standalone: Đơn giản hóa cho người mới bắt đầu

Nếu từng tìm hiểu các tài liệu Angular cũ, bạn có thể đã nghe nói về `NgModule`—một cơ chế cấu hình mô-đun trung gian từng khiến rất nhiều lập trình viên mới cảm thấy phức tạp và nặng nề.

Trong Angular hiện đại, rào cản này đã được gỡ bỏ hoàn toàn với kiến trúc **Standalone Components**. Kể từ Angular 19, mọi component mặc định đều ở dạng độc lập (`standalone: true`). Điều này có nghĩa là một component có thể tự đứng vững và sử dụng trực tiếp: nếu component A muốn dùng component B, bạn chỉ cần khai báo tên của component B vào mảng `imports` trong decorator `@Component` của A. 

Bằng cách nhúng các component con vào component cha, các mảnh ghép bắt đầu liên kết chặt chẽ với nhau để tạo thành **Cây thành phần (Component Tree)**. Cấu trúc cây phân cấp này phản ánh chính xác giao diện người dùng và là nền tảng để Angular điều phối luồng dữ liệu, bắt sự kiện và xử lý cập nhật trạng thái trong các bài học tiếp theo.

## References

- [What is Angular? • Angular](https://angular.dev/overview)
- [Anatomy of components • Angular](https://angular.dev/guide/components)

## Series

Next: [Template Syntax và Data Binding: Kết nối Dữ liệu với Giao diện](../02-template-syntax-and-data-binding/index.md)
