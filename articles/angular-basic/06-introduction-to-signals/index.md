---
title: "Làm quen với Angular Signals: Trạng thái Reactive Đơn giản"
description: "Khám phá cơ chế quản lý trạng thái hiện đại của Angular: cách khai báo signal(), đọc giá trị, cập nhật trạng thái và tạo biến tính toán với computed()."

date:
updated:

series: "Angular Basic"
series_order: 6

tags:
  - angular
  - frontend
  - signals
  - beginner

status: draft
language: vi
---

# Làm quen với Angular Signals: Trạng thái Reactive Đơn giản

Trong các bài học trước, bạn thấy chúng ta khai báo trạng thái của component bằng các biến thông thường như `count = 0` hay `userName = 'Alex'`. Cách viết này trông rất tự nhiên, nhưng ẩn sau nó là một câu hỏi kỹ thuật lớn: Làm thế nào Angular biết được khi nào bạn thay đổi giá trị của một biến để cập nhật lại màn hình?

Trong nhiều năm, Angular phải dựa vào một thư viện có tên `Zone.js` để âm thầm theo dõi mọi sự kiện trình duyệt (click chuột, timer, request mạng) và sau đó chạy một lượt kiểm tra trên toàn bộ cây component để xem có dữ liệu nào bị thay đổi hay không. Cơ chế này hoạt động tốt, nhưng giống như việc bật đèn toàn bộ tòa nhà chỉ để tìm xem có căn phòng nào vừa bật công tắc hay không.

Để giải quyết triệt để vấn đề này, Angular hiện đại giới thiệu một nền tảng quản lý trạng thái mới gọi là **Signals**.

## Signal là gì?

Nói một cách mộc mạc nhất: **Signal là một chiếc hộp bọc lấy một giá trị và có khả năng phát tín hiệu thông báo mỗi khi giá trị bên trong nó thay đổi**.

Khi một template HTML hoặc một đoạn mã đọc dữ liệu từ một Signal, Angular sẽ tự động ghi nhớ rằng phần tử đó đang quan tâm tới Signal này. Đến khi Signal nhận giá trị mới, nó sẽ báo thẳng cho Angular biết chính xác vị trí nào trên màn hình cần được cập nhật.

## 1. Khai báo và Đọc giá trị của Signal

Để tạo một Signal, bạn sử dụng hàm `signal()` từ gói `@angular/core`:

```typescript
import { Component, signal } from '@angular/core';

@Component({
  selector: 'app-counter',
  template: `
    <h3>Số đếm hiện tại: {{ count() }}</h3>
    <button (click)="increment()">Tăng thêm</button>
    <button (click)="reset()">Đặt lại</button>
  `
})
export class CounterComponent {
  // 1. Khai báo Signal với giá trị khởi tạo là 0
  count = signal(0);

  increment() {
    // 2. Cập nhật dựa trên giá trị trước đó
    this.count.update(current => current + 1);
  }

  reset() {
    // 3. Gán đè một giá trị mới
    this.count.set(0);
  }
}
```

Hãy chú ý đến cách chúng ta đọc giá trị của Signal trong template: `{{ count() }}`. Signal thực chất là một hàm getter. Khi bạn gọi `count()`, bạn đang mở chiếc hộp ra để lấy giá trị hiện tại bên trong.

## 2. Hai cách thay đổi giá trị của Signal

Một WritableSignal (Signal có quyền ghi) cung cấp cho bạn hai phương thức để cập nhật dữ liệu:

- **`set(newValue)`:** Dùng khi bạn muốn gán thẳng một giá trị mới mà không cần quan tâm giá trị cũ là gì (chẳng hạn khi đặt lại trạng thái về ban đầu: `this.count.set(0)`).
- **`update(fn)`:** Dùng khi giá trị mới phụ thuộc vào giá trị trước đó. Hàm truyền vào sẽ nhận giá trị hiện tại và trả về giá trị tiếp theo (chẳng hạn: `this.count.update(v => v + 1)`).

## 3. Tạo giá trị phụ thuộc tự động với computed()

Trong thực tế, bạn thường có những giá trị phụ thuộc vào các biến khác—ví dụ tổng tiền giỏ hàng phụ thuộc vào đơn giá và số lượng, hoặc tên đầy đủ phụ thuộc vào họ và tên. Thay vì phải tự viết hàm tính toán lại mỗi khi có biến thay đổi, bạn sử dụng `computed()`:

```typescript
import { Component, signal, computed } from '@angular/core';

@Component({
  selector: 'app-shopping-item',
  template: `
    <p>Đơn giá: {{ price() }} VND</p>
    <p>Số lượng: {{ quantity() }}</p>
    <h4>Tổng tiền: {{ totalPrice() }} VND</h4>
    <button (click)="addMore()">Thêm 1 cái</button>
  `
})
export class ShoppingItemComponent {
  price = signal(100000);
  quantity = signal(1);

  // totalPrice tự động tính lại mỗi khi quantity hoặc price đổi
  totalPrice = computed(() => this.price() * this.quantity());

  addMore() {
    this.quantity.update(q => q + 1);
  }
}
```

Điều kỳ diệu của `computed()` là nó **ghi nhớ kết quả (memoization)**: nếu bạn gọi `totalPrice()` nhiều lần nhưng cả `price` lẫn `quantity` đều không đổi, Angular sẽ trả về ngay kết quả đã tính từ bộ nhớ đệm mà không phải chạy lại phép tính.

Sử dụng Signals giúp mã nguồn của bạn trở nên trong sáng, dễ đọc và mang lại hiệu năng cực kỳ ấn tượng. Ở bài tiếp theo, chúng ta sẽ tìm hiểu cách tách biệt các dữ liệu này ra khỏi component để chia sẻ dùng chung cho toàn bộ ứng dụng thông qua **Services và Dependency Injection**.

## References

- [Signals • Overview • Angular](https://angular.dev/guide/signals)
- [Anatomy of components • Angular](https://angular.dev/guide/components)

## Series

Previous: [Styling trong Component và Cơ chế View Encapsulation](../05-styling-and-view-encapsulation/index.md)

Next: [Tách biệt Logic với Services và Dependency Injection cơ bản](../07-services-and-dependency-injection/index.md)
