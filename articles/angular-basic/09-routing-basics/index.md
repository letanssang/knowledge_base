---
title: "Điều hướng Trang cơ bản với Angular Router"
description: "Xây dựng trải nghiệm ứng dụng đơn trang (SPA) mượt mà với Angular Router: định nghĩa routes, hiển thị component với <router-outlet> và chuyển trang không tải lại với routerLink."

date:
updated:

series: "Angular Basic"
series_order: 9

tags:
  - angular
  - frontend
  - routing
  - beginner

status: draft
language: vi
---

# Điều hướng Trang cơ bản với Angular Router

Trong một trang web truyền thống nhiều trang (Multi-Page Application - MPA), mỗi khi người dùng nhấn vào một liên kết, trình duyệt sẽ gửi yêu cầu lên máy chủ, nhận về một tệp HTML mới và tải lại toàn bộ trang từ đầu. Màn hình sẽ nhấp nháy trắng trong tích tắc, các trạng thái trước đó bị xóa sạch, và trải nghiệm người dùng bị ngắt quãng.

Angular mang lại trải nghiệm **Single Page Application (SPA)** hoàn toàn khác biệt: ứng dụng chỉ tải một bộ khung ban đầu, và khi người dùng chuyển trang, **Angular Router** sẽ chặn đường dẫn URL trên thanh địa chỉ của trình duyệt, tự động tráo đổi component tương ứng trên màn hình mà hoàn toàn không làm tải lại trang.

## 1. Định nghĩa danh sách các tuyến đường (Routes)

Mỗi tuyến đường trong Angular là một quy tắc ánh xạ giữa một đường dẫn URL (`path`) và một Component sẽ hiển thị:

```typescript
import { Routes } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { ProductsComponent } from './products/products.component';
import { NotFoundComponent } from './not-found/not-found.component';

export const routes: Routes = [
  // 1. Tuyến đường trang chủ (URL rỗng: /)
  { path: '', component: HomeComponent },

  // 2. Tuyến đường trang sản phẩm: /products
  { path: 'products', component: ProductsComponent },

  // 3. Tuyến đường bắt lỗi 404 khi người dùng gõ sai URL
  { path: '**', component: NotFoundComponent }
];
```

Hãy chú ý đến quy tắc `{ path: '**', ... }`: đây là ký hiệu đại diện (wildcard route). Angular sẽ duyệt danh sách routes từ trên xuống dưới, và nếu không có đường dẫn nào phía trên khớp với URL hiện tại, nó sẽ rơi vào tuyến đường này để hiển thị trang báo lỗi 404.

## 2. Điểm cắm giao diện với <router-outlet />

Làm sao Angular biết cần vẽ component của trang tương ứng vào vị trí nào trên màn hình?

Angular cung cấp một thẻ đặc biệt có tên là `<router-outlet />`. Bạn có thể hình dung đây như một chiếc "khung cắm rỗng" trên giao diện chính:

```typescript
import { Component } from '@angular/core';
import { RouterOutlet, RouterLink, RouterLinkActive } from '@angular/router';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, RouterLink, RouterLinkActive],
  template: `
    <nav class="navbar">
      <a routerLink="/" routerLinkActive="active" [routerLinkActiveOptions]="{ exact: true }">
        Trang chủ
      </a>
      <a routerLink="/products" routerLinkActive="active">
        Sản phẩm
      </a>
    </nav>

    <!-- Component của trang hiện tại sẽ được render ngay tại đây -->
    <main class="content">
      <router-outlet />
    </main>
  `,
  styles: `
    .navbar a { margin-right: 16px; text-decoration: none; color: #333; }
    .navbar a.active { color: #1976d2; font-weight: bold; }
  `
})
export class AppComponent {}
```

Bất cứ khi nào URL thay đổi, Angular sẽ tháo component cũ ra khỏi `<router-outlet />` và gắn component mới vào đúng vị trí đó, trong khi thanh điều hướng `<nav>` phía trên vẫn được giữ nguyên vẹn.

## 3. Chuyển trang mượt mà với routerLink

Để người dùng chuyển trang mà không làm trình duyệt tải lại, bạn thay thế thuộc tính `href` thông thường bằng chỉ thị `routerLink`:

- **Không dùng:** `<a href="/products">` (lệnh này sẽ buộc trình duyệt gửi request tải lại cả trang).
- **Hãy dùng:** `<a routerLink="/products">` (Angular Router sẽ bắt sự kiện click, đổi URL và tráo component ngay lập tức).

Thuộc tính bổ trợ `routerLinkActive="active"` sẽ tự động gắn class CSS `active` vào thẻ `<a>` mỗi khi URL của trình duyệt trùng khớp với đường dẫn của liên kết đó, giúp bạn làm nổi bật mục menu đang được chọn vô cùng dễ dàng.

## 4. Chuyển trang bằng mã TypeScript với Router Service

Đôi khi bạn muốn chuyển trang sau khi một hành động logic kết thúc (chẳng hạn người dùng đăng nhập thành công thì chuyển về trang chủ), bạn có thể tiêm service `Router` và gọi hàm `navigate`:

```typescript
import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  template: `<button (click)="onLoginSuccess()">Đăng nhập</button>`
})
export class LoginComponent {
  private router = inject(Router);

  onLoginSuccess() {
    // Thực thi chuyển trang tới /products
    this.router.navigate(['/products']);
  }
}
```

Với Angular Router, việc xây dựng một trang web đa màn hình với tốc độ phản hồi tức thì trở nên đơn giản hơn bao giờ hết. Ở bài học cuối cùng của series cơ bản này, chúng ta sẽ kết nối ứng dụng với thế giới bên ngoài thông qua **HttpClient** để tải dữ liệu thật từ máy chủ.

## References

- [What is Angular? • Angular](https://angular.dev/overview)
- [Anatomy of components • Angular](https://angular.dev/guide/components)

## Series

Previous: [Xử lý Dữ liệu Người dùng với Template-driven Forms](../08-template-driven-forms/index.md)

Next: [Gọi API và Hiển thị Dữ liệu với HttpClient](../10-http-client-and-apis/index.md)
