---
title: "Điều khiển Hiển thị với Built-in Control Flow (@if, @for, @switch)"
description: "Làm chủ cú pháp điều khiển hiển thị thế hệ mới trong template Angular: render có điều kiện với @if, duyệt danh sách tối ưu với @for và rẽ nhánh với @switch."

date:
updated:

series: "Angular Basic"
series_order: 3

tags:
  - angular
  - frontend
  - control-flow
  - beginner

status: draft
language: vi
---

# Điều khiển Hiển thị với Built-in Control Flow (@if, @for, @switch)

Một giao diện thực tế hiếm khi nào là một cấu trúc tĩnh. Bạn sẽ liên tục đối mặt với những yêu cầu quen thuộc: chỉ hiển thị thông tin khi người dùng đã đăng nhập, render một danh sách các bài viết lấy từ máy chủ, hoặc hiển thị trạng thái đơn hàng tùy theo các nấc xử lý khác nhau.

Trong các phiên bản Angular trước đây, bạn phải sử dụng các cú pháp gọi là *structural directives* như `*ngIf` hay `*ngFor` và bắt buộc phải import `CommonModule`. Tuy nhiên, kể từ Angular 17 trở đi, Angular đã giới thiệu cú pháp **Built-in Control Flow** trực quan và mạnh mẽ hơn rất nhiều, sử dụng các khối lệnh bắt đầu bằng ký tự `@` tương tự như cú pháp lập trình thông thường.

## 1. Render có điều kiện với @if, @else if và @else

Cú pháp `@if` giúp bạn thêm hoặc gỡ bỏ các khối HTML trên trang web tùy theo một biểu thức logic:

```typescript
import { Component } from '@angular/core';

@Component({
  selector: 'app-auth-status',
  template: `
    @if (isLoggedIn) {
      <div class="welcome-box">
        <p>Chào mừng bạn quay trở lại, {{ userName }}!</p>
        <button (click)="logout()">Đăng xuất</button>
      </div>
    } @else if (isGuest) {
      <div class="guest-box">
        <p>Bạn đang duyệt web với tư cách khách.</p>
        <button (click)="login()">Đăng nhập ngay</button>
      </div>
    } @else {
      <p>Vui lòng đăng nhập để xem nội dung.</p>
    }
  `
})
export class AuthStatusComponent {
  isLoggedIn = false;
  isGuest = true;
  userName = 'Alex';

  login() { this.isLoggedIn = true; }
  logout() { this.isLoggedIn = false; }
}
```

Điểm ưu việt của `@if` so với việc dùng CSS `display: none` là tính triệt để về tài nguyên: khi điều kiện là `false`, Angular hoàn toàn không render phần tử đó vào cây DOM, giúp tiết kiệm bộ nhớ và giảm tải quá trình xử lý cho trình duyệt.

## 2. Duyệt danh sách với @for và khối @empty

Để hiển thị một mảng dữ liệu—chẳng hạn danh sách các sản phẩm trong giỏ hàng—bạn sử dụng khối `@for`:

```typescript
@Component({
  selector: 'app-todo-list',
  template: `
    <h3>Danh sách công việc hôm nay</h3>
    <ul>
      @for (item of todos; track item.id) {
        <li>
          <span>{{ item.title }}</span>
          @if (item.completed) {
            <strong>(Đã xong)</strong>
          }
        </li>
      } @empty {
        <li class="empty-message">Hiện chưa có công việc nào!</li>
      }
    </ul>
  `
})
export class TodoListComponent {
  todos = [
    { id: 1, title: 'Học cú pháp Angular Control Flow', completed: true },
    { id: 2, title: 'Thực hành tạo component đầu tiên', completed: false },
    { id: 3, title: 'Tìm hiểu về Component Interaction', completed: false }
  ];
}
```

Có hai chi tiết cực kỳ quan trọng cần lưu ý khi dùng `@for`:

- **Bắt buộc phải có `track`:** Biểu thức `track item.id` là bắt buộc. Thuộc tính định danh này giúp Angular nhận biết chính xác phần tử nào được thêm, sửa hoặc xóa khi mảng dữ liệu thay đổi. Nhờ có `track`, Angular chỉ cập nhật đúng phần tử thay đổi trong DOM thay vì phải hủy bỏ và vẽ lại toàn bộ danh sách, mang lại hiệu năng vượt trội.
- **Khối `@empty` tiện lợi:** Nếu mảng `todos` rỗng (`length === 0`), Angular sẽ tự động hiển thị nội dung bên trong khối `@empty`. Bạn không còn phải viết thêm một thẻ `@if (todos.length === 0)` riêng biệt như trước đây.

## 3. Rẽ nhánh nhiều trường hợp với @switch

Khi cần xử lý nhiều điều kiện dựa trên một giá trị cụ thể, khối `@switch` là lựa chọn gọn gàng và dễ đọc nhất:

```typescript
@Component({
  selector: 'app-order-status',
  template: `
    @switch (status) {
      @case ('pending') {
        <span class="badge yellow">Chờ thanh toán</span>
      }
      @case ('shipping') {
        <span class="badge blue">Đang vận chuyển</span>
      }
      @case ('delivered') {
        <span class="badge green">Đã giao thành công</span>
      }
      @default {
        <span class="badge gray">Trạng thái không xác định</span>
      }
    }
  `
})
export class OrderStatusComponent {
  status = 'shipping';
}
```

Cú pháp Built-in Control Flow của Angular giúp mã nguồn template trở nên sạch sẽ, tự nhiên và dễ tiếp cận cho bất kỳ ai đã từng học qua một ngôn ngữ lập trình cơ bản. Ở bài tiếp theo, chúng ta sẽ tìm hiểu cách ghép nối các component lại với nhau thông qua cơ chế giao tiếp Input và Output.

## References

- [Control flow • Angular](https://angular.dev/guide/templates/control-flow)
- [Anatomy of components • Angular](https://angular.dev/guide/components)

## Series

Previous: [Template Syntax và Data Binding: Kết nối Dữ liệu với Giao diện](../02-template-syntax-and-data-binding/index.md)

Next: [Giao tiếp giữa các Component: Input và Output](../04-component-interaction/index.md)
