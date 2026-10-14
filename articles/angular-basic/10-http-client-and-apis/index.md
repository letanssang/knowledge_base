---
title: "Gọi API và Hiển thị Dữ liệu với HttpClient"
description: "Kết nối ứng dụng Angular với máy chủ backend: cấu hình provideHttpClient(), gửi HTTP GET request, lưu dữ liệu vào Signals và hiển thị lên giao diện."

date:
updated:

series: "Angular Basic"
series_order: 10

tags:
  - angular
  - frontend
  - http-client
  - api
  - beginner

status: draft
language: vi
---

# Gọi API và Hiển thị Dữ liệu với HttpClient

Dữ liệu của một trang web thực tế hiếm khi nào được viết sẵn (hardcoded) bên trong mã nguồn TypeScript. Dữ liệu thực sự sống trên cơ sở dữ liệu ở phía máy chủ (backend) và được cung cấp thông qua các cổng RESTful API. Nếu từng dùng JavaScript thuần, bạn chắc chắn đã quen thuộc với hàm `fetch()` hoặc thư viện `axios` để gửi yêu cầu mạng.

Trong hệ sinh thái Angular, framework cung cấp sẵn một công cụ chuyên biệt, mạnh mẽ và an toàn về kiểu dữ liệu mang tên **HttpClient**.

## 1. Kích hoạt HttpClient trong ứng dụng

Để sử dụng HttpClient trong ứng dụng Angular hiện đại, bước đầu tiên là đăng ký nhà cung cấp (provider) `provideHttpClient()` trong tệp cấu hình khởi động của ứng dụng (`app.config.ts`):

```typescript
import { ApplicationConfig } from '@angular/core';
import { provideHttpClient } from '@angular/common/http';
import { provideRouter } from '@angular/router';
import { routes } from './app.routes';

export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes),
    provideHttpClient() // Kích hoạt HttpClient cho toàn bộ ứng dụng
  ]
};
```

Chỉ cần một dòng khai báo này, mọi component và service trong dự án của bạn đều có thể tiêm và sử dụng dịch vụ HTTP.

## 2. Tạo Service đảm nhiệm việc gọi API

Như đã nhấn mạnh ở Bài 7, các tác vụ giao tiếp mạng và gọi API luôn nên được đặt trong một Service riêng biệt thay vì viết trực tiếp trong Component:

```typescript
import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

// Định nghĩa kiểu dữ liệu của bài viết từ API
export interface Post {
  id: number;
  title: string;
  body: string;
}

@Injectable({
  providedIn: 'root'
})
export class PostService {
  private http = inject(HttpClient);
  private apiUrl = 'https://jsonplaceholder.typicode.com/posts';

  // Lấy danh sách bài viết từ server
  getPosts(): Observable<Post[]> {
    return this.http.get<Post[]>(this.apiUrl);
  }
}
```

Hãy chú ý đến kiểu dữ liệu trả về `Observable<Post[]>`. Trong Angular, `http.get` trả về một **Observable**—một khái niệm của thư viện RxJS đại diện cho luồng dữ liệu bất đồng bộ. Bạn có thể hình dung Observable tương tự như một Promise nâng cao, nơi dữ liệu sẽ được phát ra khi máy chủ phản hồi yêu cầu.

## 3. Tiêm Service vào Component và hiển thị dữ liệu với Signals

Tại component hiển thị, bạn gọi service, lắng nghe dữ liệu trả về thông qua phương thức `.subscribe()`, và lưu kết quả vào một Signal để template tự động cập nhật:

```typescript
import { Component, inject, signal, OnInit } from '@angular/core';
import { PostService, Post } from './post.service';

@Component({
  selector: 'app-post-list',
  template: `
    <h2>Danh sách bài viết mới nhất</h2>

    @if (isLoading()) {
      <p class="loading">Đang tải dữ liệu từ máy chủ...</p>
    } @else if (errorMessage()) {
      <p class="error">{{ errorMessage() }}</p>
    } @else {
      <div class="posts-grid">
        @for (post of posts(); track post.id) {
          <article class="post-card">
            <h3>{{ post.title }}</h3>
            <p>{{ post.body }}</p>
          </article>
        } @empty {
          <p>Không có bài viết nào.</p>
        }
      </div>
    }
  `,
  styles: `
    .loading { color: #666; font-style: italic; }
    .error { color: red; font-weight: bold; }
    .post-card { border: 1px solid #eee; padding: 16px; margin-bottom: 12px; border-radius: 6px; }
  `
})
export class PostListComponent implements OnInit {
  private postService = inject(PostService);

  // Quản lý trạng thái bằng Signals
  posts = signal<Post[]>([]);
  isLoading = signal<boolean>(true);
  errorMessage = signal<string>('');

  ngOnInit() {
    this.fetchData();
  }

  fetchData() {
    this.isLoading.set(true);

    this.postService.getPosts().subscribe({
      next: (data) => {
        this.posts.set(data);
        this.isLoading.set(false);
      },
      error: (err) => {
        console.error('Lỗi tải bài viết:', err);
        this.errorMessage.set('Không thể tải bài viết. Vui lòng thử lại sau!');
        this.isLoading.set(false);
      }
    });
  }
}
```

Nhìn vào đoạn mã trên, bạn thấy tất cả các mảnh ghép mà chúng ta đã tích lũy từ đầu khóa học được hội tụ hoàn hảo:
1. **Dependency Injection & Service:** `inject(PostService)` để tách biệt logic gọi API.
2. **Signals:** `signal<Post[]>([])` để quản lý danh sách bài viết và cờ `isLoading()`.
3. **Built-in Control Flow:** `@if (isLoading())` điều khiển trạng thái chờ và `@for (post of posts(); track post.id)` để lặp mảng bài viết với hiệu năng cao nhất.

## Tổng kết khóa học Angular Basic

Chúc mừng bạn đã hoàn thành trọn vẹn 10 bài học của khóa **Angular Basic**! Bạn đã đi từ những bước bỡ ngỡ đầu tiên của một lập trình viên chưa từng biết gì về Angular cho đến khi nắm vững các viên gạch nền tảng:

- Hiểu rõ sự khác biệt giữa thao tác DOM thủ công và tư duy kiến trúc **Component-based**.
- Làm chủ cú pháp **Data Binding** để đồng bộ dữ liệu hai chiều giữa mã TypeScript và HTML.
- Điều khiển hiển thị mượt mà với cú pháp **Built-in Control Flow** mới (`@if`, `@for`, `@switch`).
- Tổ chức giao tiếp mạch lạc giữa các component bằng **Input** và **Output**.
- Hiểu cơ chế bảo vệ giao diện nhờ **View Encapsulation** và selector `:host`.
- Quản lý trạng thái hiện đại, tinh gọn với **Angular Signals** và `computed()`.
- Tách rời mã nguồn nghiệp vụ với **Services** và cơ chế **Dependency Injection** (`inject()`).
- Thu thập và kiểm tra dữ liệu người dùng với **Template-driven Forms**.
- Xây dựng trải nghiệm ứng dụng đơn trang (SPA) không tải lại trang với **Angular Router**.
- Kết nối với thế giới bên ngoài thông qua **HttpClient**.

Giờ đây, bạn đã hoàn toàn tự tin để bắt tay vào tự xây dựng những dự án web đầu tiên của mình với Angular. Ở các khóa học nâng cao tiếp theo, chúng ta sẽ đào sâu hơn vào các chủ đề chuyên nghiệp như *Signals Reactivity chuyên sâu, RxJS & Signals Interop, Reactive Forms, Kiến trúc Change Detection Zoneless, và Thiết kế hệ thống Enterprise*.

## References

- [What is Angular? • Angular](https://angular.dev/overview)
- [Anatomy of components • Angular](https://angular.dev/guide/components)

## Series

Previous: [Điều hướng Trang cơ bản với Angular Router](../09-routing-basics/index.md)
