---
title: "Xử lý Dữ liệu Người dùng với Template-driven Forms"
description: "Hướng dẫn xây dựng biểu mẫu nhập liệu thân thiện cho người mới bắt đầu trong Angular: liên kết hai chiều với [(ngModel)], kiểm tra tính hợp lệ và xử lý submit form."

date:
updated:

series: "Angular Basic"
series_order: 8

tags:
  - angular
  - frontend
  - forms
  - beginner

status: draft
language: vi
---

# Xử lý Dữ liệu Người dùng với Template-driven Forms

Bất kỳ ứng dụng web nào cũng cần tương tác với người dùng qua các biểu mẫu (forms): từ màn hình đăng nhập, form đăng ký thành viên, cho đến trang điền thông tin thanh toán. Khi làm việc với form, lập trình viên thường phải giải quyết ba bài toán cốt lõi: thu thập dữ liệu người dùng gõ vào, kiểm tra tính hợp lệ (validation) của từng trường, và ngăn chặn việc gửi dữ liệu sai lên máy chủ.

Trong Angular, có hai phương pháp tiếp cận để xử lý biểu mẫu: **Template-driven Forms** (phù hợp cho các form đơn giản và người mới bắt đầu) và **Reactive Forms** (mạnh mẽ cho các form phức tạp, sẽ tìm hiểu ở khóa nâng cao). Trong bài học này, chúng ta sẽ làm chủ Template-driven Forms.

## 1. Liên kết hai chiều (Two-way Binding) với [(ngModel)]

Để sử dụng các tính năng của biểu mẫu template-driven, bạn cần thêm `FormsModule` (từ `@angular/forms`) vào mảng `imports` của component:

```typescript
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-contact-form',
  imports: [FormsModule],
  template: `
    <div class="form-container">
      <h3>Liên hệ với chúng tôi</h3>
      
      <label>Họ và tên:</label>
      <input type="text" [(ngModel)]="fullName" placeholder="Nhập tên của bạn" />

      <p>Tên bạn đang gõ: <strong>{{ fullName }}</strong></p>
    </div>
  `
})
export class ContactFormComponent {
  fullName = '';
}
```

Cú pháp kết hợp `[(ngModel)]` (banana in a box) thiết lập một kênh đồng bộ hai chiều tức thì:
- Khi người dùng gõ ký tự vào ô `<input>`, biến `fullName` trong class TypeScript lập tức nhận giá trị mới.
- Nếu ở class bạn gán lại `this.fullName = 'Alex'`, nội dung hiển thị trong ô `<input>` cũng ngay lập tức cập nhật theo.

## 2. Kiểm tra tính hợp lệ (Validation) và hiển thị thông báo lỗi

Angular tận dụng các thuộc tính kiểm tra chuẩn của HTML như `required`, `minlength`, `maxlength` hay `email`, đồng thời cung cấp thêm các biến trạng thái để bạn biết khi nào người dùng nhập sai:

```typescript
@Component({
  selector: 'app-login-form',
  imports: [FormsModule],
  template: `
    <form (ngSubmit)="onSubmit()" #loginForm="ngForm">
      <div>
        <label>Email:</label>
        <input 
          type="email" 
          name="email" 
          [(ngModel)]="email" 
          required 
          #emailInput="ngModel" 
        />

        @if (emailInput.invalid && emailInput.touched) {
          <p class="error">Vui lòng nhập địa chỉ email hợp lệ!</p>
        }
      </div>

      <button type="submit" [disabled]="loginForm.invalid">
        Đăng nhập
      </button>
    </form>
  `,
  styles: `
    .error { color: red; font-size: 13px; margin-top: 4px; }
  `
})
export class LoginFormComponent {
  email = '';

  onSubmit() {
    alert(`Đăng nhập thành công với email: ${this.email}`);
  }
}
```

Hãy để ý các biến tham chiếu đặc biệt (template reference variables) bắt đầu bằng dấu `#`:

- **`#emailInput="ngModel"`:** Xuất ra đối tượng quản lý trạng thái của ô input này. Thuộc tính `.invalid` sẽ là `true` nếu người dùng chưa điền hoặc điền sai định dạng, còn `.touched` sẽ là `true` khi người dùng đã click vào ô đó rồi click ra ngoài (blur). Sự kết hợp `emailInput.invalid && emailInput.touched` giúp thông báo lỗi chỉ xuất hiện khi người dùng thực sự đã tương tác và nhập sai, tránh việc màn hình vừa mở lên đã đỏ rực cảnh báo.
- **`#loginForm="ngForm"`:** Quản lý tính hợp lệ của toàn bộ form. Biểu thức `[disabled]="loginForm.invalid"` sẽ tự động khóa nút submit nếu bất kỳ ô nhập liệu nào trong form chưa đạt yêu cầu.
- **`(ngSubmit)="onSubmit()"`:** Lắng nghe sự kiện gửi form và tự động ngăn chặn hành vi tải lại trang (reload) mặc định của trình duyệt.

Template-driven Forms cho phép bạn dựng nhanh các chức năng nhập liệu chỉ với vài dòng mã ngắn gọn và quen thuộc. Ở bài tiếp theo, chúng ta sẽ tìm hiểu cách chia ứng dụng thành nhiều trang màn hình khác nhau thông qua **Angular Router**.

## References

- [Anatomy of components • Angular](https://angular.dev/guide/components)
- [What is Angular? • Angular](https://angular.dev/overview)

## Series

Previous: [Tách biệt Logic với Services và Dependency Injection cơ bản](../07-services-and-dependency-injection/index.md)

Next: [Điều hướng Trang cơ bản với Angular Router](../09-routing-basics/index.md)
