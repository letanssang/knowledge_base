---
title: "Tách biệt Logic với Services và Dependency Injection cơ bản"
description: "Tìm hiểu cách tổ chức mã nguồn sạch sẽ với Services và cơ chế Dependency Injection (DI): chia sẻ dữ liệu giữa các component và sử dụng hàm inject() hiện đại."

date:
updated:

series: "Angular Basic"
series_order: 7

tags:
  - angular
  - frontend
  - dependency-injection
  - services
  - beginner

status: draft
language: vi
---

# Tách biệt Logic với Services và Dependency Injection cơ bản

Khi mới học Angular, một thói quen rất phổ biến là nhồi nhét mọi thứ vào bên trong một Component: từ việc gọi API, tính toán logic giỏ hàng, cho đến lưu trữ trạng thái người dùng. Nhưng rất nhanh sau đó, bạn sẽ gặp bế tắc: Nếu người dùng nhấn nút "Thêm vào giỏ" ở trang Sản phẩm (`ProductListComponent`), làm thế nào để biểu tượng giỏ hàng trên thanh điều hướng (`HeaderComponent`) biết để cập nhật số lượng?

Component chỉ nên tập trung vào nhiệm vụ duy nhất của nó: **hiển thị giao diện và đón nhận tương tác người dùng**. Toàn bộ logic nghiệp vụ, tính toán dữ liệu hoặc các trạng thái cần chia sẻ xuyên suốt ứng dụng nên được chuyển sang một nơi riêng biệt gọi là **Service**.

## 1. Service là gì?

Trong Angular, Service thực chất chỉ là một lớp TypeScript thông thường phụ trách một mảng nghiệp vụ cụ thể. Điểm khác biệt duy nhất là nó được đính kèm decorator `@Injectable()`:

```typescript
import { Injectable, signal } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class CartService {
  // Trạng thái danh sách món hàng trong giỏ
  items = signal<string[]>([]);

  addItem(productName: string) {
    this.items.update(current => [...current, productName]);
  }

  clearCart() {
    this.items.set([]);
  }
}
```

Hãy chú ý đến dòng cấu hình `providedIn: 'root'`. Dòng này báo cho Angular biết rằng service này sẽ được cung cấp ở cấp độ cao nhất của ứng dụng. Nhờ vậy, `CartService` sẽ trở thành một **Singleton**—nghĩa là chỉ có đúng một bản thể (instance) duy nhất được tạo ra và chia sẻ chung cho tất cả các component.

## 2. Dependency Injection (DI) là gì?

Thông thường trong lập trình hướng đối tượng, nếu muốn sử dụng một lớp, bạn sẽ tự khởi tạo nó bằng từ khóa `new`: `const cart = new CartService()`.

Thế nhưng, nếu mọi component đều tự gọi `new CartService()`, mỗi component sẽ sở hữu một chiếc giỏ hàng riêng biệt và chúng không thể nhìn thấy dữ liệu của nhau.

**Dependency Injection (DI)** là cơ chế mà trong đó bạn không tự tay khởi tạo đối tượng phụ thuộc. Thay vào đó, bạn chỉ cần "đăng ký nhu cầu" với Angular, và hệ thống Dependency Injection của Angular sẽ tự động tạo ra bản thể service (nếu chưa có) và "tiêm" (inject) bản thể đó vào cho bạn.

## 3. Cách tiêm Service vào Component với hàm inject()

Trong Angular hiện đại, cách thanh lịch và ngắn gọn nhất để nhận một service là sử dụng hàm `inject()` từ `@angular/core`:

```typescript
import { Component, inject } from '@angular/core';
import { CartService } from './cart.service';

@Component({
  selector: 'app-header',
  template: `
    <header>
      <h1>Cửa hàng của tôi</h1>
      <div class="cart-badge">
        Giỏ hàng: {{ cartService.items().length }} món
      </div>
    </header>
  `
})
export class HeaderComponent {
  // Yêu cầu Angular cung cấp bản thể CartService dùng chung
  cartService = inject(CartService);
}
```

Bây giờ, tại một component khác—chẳng hạn danh sách sản phẩm—bạn cũng tiêm chính `CartService` đó:

```typescript
@Component({
  selector: 'app-product-list',
  template: `
    <button (click)="addProduct('Tai nghe Bluetooth')">
      Thêm tai nghe vào giỏ
    </button>
  `
})
export class ProductListComponent {
  private cartService = inject(CartService);

  addProduct(name: string) {
    this.cartService.addItem(name);
  }
}
```

Khi người dùng nhấn nút thêm tai nghe ở `ProductListComponent`, hàm `addItem` được gọi trên `CartService`. Vì `HeaderComponent` cũng dùng chung bản thể `CartService` này và đang đọc Signal `items()`, biểu tượng giỏ hàng trên thanh header sẽ ngay lập tức nhảy số mà không cần bất kỳ đường dây truyền sự kiện phức tạp nào giữa hai component!

Tách biệt logic thành Service và tận dụng hệ thống Dependency Injection là bước đệm then chốt giúp bạn xây dựng những ứng dụng Angular quy mô lớn, ngăn nắp và cực kỳ dễ kiểm thử. Ở bài học tiếp theo, chúng ta sẽ tìm hiểu cách thu thập và kiểm tra dữ liệu nhập liệu từ người dùng thông qua **Template-driven Forms**.

## References

- [Dependency Injection • Overview • Angular](https://angular.dev/guide/di)
- [Anatomy of components • Angular](https://angular.dev/guide/components)

## Series

Previous: [Làm quen với Angular Signals: Trạng thái Reactive Đơn giản](../06-introduction-to-signals/index.md)

Next: [Xử lý Dữ liệu Người dùng với Template-driven Forms](../08-template-driven-forms/index.md)
