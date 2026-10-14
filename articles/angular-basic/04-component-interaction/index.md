---
title: "Giao tiếp giữa các Component: Input và Output"
description: "Khám phá cách các component chia sẻ dữ liệu và lắng nghe sự kiện lẫn nhau: truyền dữ liệu từ cha xuống con với Input và gửi sự kiện từ con lên cha với Output."

date:
updated:

series: "Angular Basic"
series_order: 4

tags:
  - angular
  - frontend
  - component-interaction
  - beginner

status: draft
language: vi
---

# Giao tiếp giữa các Component: Input và Output

Khi chia nhỏ một giao diện thành nhiều component độc lập—chẳng hạn như một trang danh bạ chứa danh sách nhiều thẻ người dùng con—bạn sẽ gặp ngay câu hỏi: Làm thế nào component cha có thể truyền thông tin của từng người dùng vào component con? Và khi người dùng nhấn nút "Xóa" bên trong component con, làm sao component cha biết để cập nhật lại danh sách?

Trong Angular, luồng giao tiếp chuẩn mực nhất giữa các component tuân theo nguyên lý: **Dữ liệu đi xuống bằng Input, Sự kiện đi lên bằng Output**.

## 1. Truyền dữ liệu từ cha xuống con với @Input

Hãy xem xét một component con có nhiệm vụ hiển thị thẻ thông tin sản phẩm (`ProductCardComponent`):

```typescript
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-product-card',
  template: `
    <div class="card">
      <h4>{{ productName }}</h4>
      <p>Giá: {{ price.toLocaleString() }} VND</p>
    </div>
  `,
  styles: `
    .card { border: 1px solid #ddd; padding: 12px; margin-bottom: 8px; }
  `
})
export class ProductCardComponent {
  @Input() productName: string = '';
  @Input() price: number = 0;
}
```

Bằng cách đính kèm decorator `@Input()` trước một thuộc tính trong class TypeScript, bạn đang mở một "cổng đón nhận dữ liệu" từ bên ngoài.

Bây giờ, tại component cha, bạn có thể truyền giá trị vào cổng này thông qua cú pháp Property Binding `[property]="value"` quen thuộc:

```typescript
import { Component } from '@angular/core';
import { ProductCardComponent } from './product-card.component';

@Component({
  selector: 'app-store',
  imports: [ProductCardComponent],
  template: `
    <h2>Cửa hàng trực tuyến</h2>
    <app-product-card 
      [productName]="featuredProduct.name" 
      [price]="featuredProduct.price" 
    />
  `
})
export class StoreComponent {
  featuredProduct = {
    name: 'Bàn phím cơ không dây',
    price: 1500000
  };
}
```

Mỗi khi dữ liệu `featuredProduct` ở component cha thay đổi, component con sẽ tự động nhận được giá trị mới nhất và cập nhật lại giao diện tương ứng.

## 2. Gửi tín hiệu từ con lên cha với @Output và EventEmitter

Ngược lại, component con thường không nên tự ý thay đổi dữ liệu gốc của component cha. Thay vào đó, khi có hành động xảy ra (ví dụ người dùng bấm nút mua hàng), component con sẽ phát ra một sự kiện (event) để thông báo cho component cha biết.

Để làm việc này, component con sử dụng decorator `@Output()` kết hợp với đối tượng `EventEmitter`:

```typescript
import { Component, Input, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-product-card',
  template: `
    <div class="card">
      <h4>{{ productName }}</h4>
      <p>Giá: {{ price.toLocaleString() }} VND</p>
      <button (click)="onBuyClick()">Chọn mua</button>
    </div>
  `
})
export class ProductCardComponent {
  @Input() productName: string = '';
  @Input() price: number = 0;

  @Output() addToCart = new EventEmitter<string>();

  onBuyClick() {
    this.addToCart.emit(this.productName);
  }
}
```

Khi phương thức `this.addToCart.emit(...)` được gọi, sự kiện sẽ bắn ra bên ngoài mang theo tên sản phẩm.

Tại component cha, bạn lắng nghe sự kiện tùy chỉnh này bằng cú pháp Event Binding `(event)="handler()"` giống hệt như lắng nghe sự kiện click thông thường:

```typescript
@Component({
  selector: 'app-store',
  imports: [ProductCardComponent],
  template: `
    <h2>Cửa hàng (Đã chọn: {{ cartItems.length }} món)</h2>
    <app-product-card 
      [productName]="featuredProduct.name" 
      [price]="featuredProduct.price"
      (addToCart)="handleAddToCart($event)"
    />
  `
})
export class StoreComponent {
  featuredProduct = { name: 'Bàn phím cơ', price: 1500000 };
  cartItems: string[] = [];

  handleAddToCart(productName: string) {
    this.cartItems.push(productName);
    alert(`Đã thêm ${productName} vào giỏ hàng!`);
  }
}
```

Biến `$event` ở đây chính là dữ liệu mà hàm `.emit(...)` của component con đã gửi lên (trong ví dụ này là chuỗi `productName`).

## Luồng dữ liệu một chiều (Unidirectional Data Flow)

Cơ chế phân định rõ ràng giữa `@Input()` và `@Output()` tạo ra một luồng dữ liệu một chiều rõ ràng và dễ dự đoán:

- **Component cha:** Nắm giữ dữ liệu gốc và quyền quyết định thay đổi trạng thái.
- **Component con:** Nhận dữ liệu để hiển thị và phát tín hiệu khi có tương tác.

Mô hình này giúp ứng dụng dễ gỡ lỗi hơn rất nhiều: bạn luôn biết dữ liệu đến từ đâu và khi có lỗi phát sinh, bạn không phải lần mò xem component nào đã vô tình chỉnh sửa dữ liệu của component khác.

## References

- [Anatomy of components • Angular](https://angular.dev/guide/components)
- [What is Angular? • Angular](https://angular.dev/overview)

## Series

Previous: [Điều khiển Hiển thị với Built-in Control Flow (@if, @for, @switch)](../03-built-in-control-flow/index.md)

Next: [Styling trong Component và Cơ chế View Encapsulation](../05-styling-and-view-encapsulation/index.md)
