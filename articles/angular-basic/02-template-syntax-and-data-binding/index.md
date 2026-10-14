---
title: "Template Syntax và Data Binding: Kết nối Dữ liệu với Giao diện"
description: "Tìm hiểu cơ chế đồng bộ giữa mã TypeScript và template HTML trong Angular: từ Interpolation, Property Binding đến Event Binding."

date:
updated:

series: "Angular Basic"
series_order: 2

tags:
  - angular
  - frontend
  - data-binding
  - beginner

status: draft
language: vi
---

# Template Syntax và Data Binding: Kết nối Dữ liệu với Giao diện

Khi xây dựng giao diện web, công việc lặp đi lặp lại nhiều nhất của lập trình viên là đưa dữ liệu từ mã nguồn lên màn hình và đón nhận hành động của người dùng để cập nhật lại dữ liệu đó. Trong JavaScript thuần, bạn phải tự nhớ tên ID của từng thẻ HTML, chủ động gán `element.value` hay `element.disabled = true`, rồi lại viết hàm bắt sự kiện để lấy dữ liệu ngược lại. 

Angular giải phóng bạn khỏi chu trình thủ công này bằng cơ chế **Data Binding** (ràng buộc dữ liệu). Thay vì đóng vai người vận chuyển dữ liệu qua lại giữa JavaScript và DOM, bạn chỉ cần thiết lập các quy tắc kết nối ngay trong template HTML, Angular sẽ tự động thực hiện việc đồng bộ.

## 1. Interpolation: Đưa dữ liệu ra màn hình với dấu ngoặc nhọn kép

Cách đơn giản nhất để hiển thị một giá trị từ class TypeScript lên giao diện là dùng cú pháp **Interpolation** `{{ expression }}`:

```typescript
import { Component } from '@angular/core';

@Component({
  selector: 'app-user-greeting',
  template: `
    <h2>Xin chào, {{ userName }}!</h2>
    <p>Số thông báo chưa đọc: {{ unreadCount * 2 }}</p>
  `
})
export class UserGreetingComponent {
  userName = 'Alex';
  unreadCount = 3;
}
```

Bên trong cặp dấu ngoặc nhọn kép `{{ }}`, bạn có thể đặt tên biến, gọi một thuộc tính của đối tượng, hoặc thậm chí là một biểu thức toán học đơn giản. Angular sẽ đánh giá biểu thức đó, chuyển kết quả thành chuỗi văn bản và chèn vào vị trí tương ứng trên DOM. Bất cứ khi nào giá trị `userName` trong class thay đổi, đoạn văn bản trên màn hình sẽ tự động cập nhật theo.

## 2. Property Binding: Kiểm soát thuộc tính của thẻ HTML với dấu ngoặc vuông

Đôi khi bạn không chỉ muốn hiển thị văn bản, mà muốn điều khiển các thuộc tính (properties) của phần tử HTML, chẳng hạn như bật/tắt nút bấm (`disabled`), đổi đường dẫn ảnh (`src`), hay đổi class CSS. Đó là lúc bạn sử dụng **Property Binding** với cú pháp dấu ngoặc vuông `[property]="expression"`:

```typescript
@Component({
  selector: 'app-submit-button',
  template: `
    <img [src]="avatarUrl" [alt]="userName" />
    <button [disabled]="isSubmitting">
      {{ isSubmitting ? 'Đang gửi...' : 'Gửi thông tin' }}
    </button>
  `
})
export class SubmitButtonComponent {
  avatarUrl = 'https://example.com/avatar.png';
  userName = 'Alex';
  isSubmitting = true;
}
```

Hãy chú ý sự khác biệt: nếu bạn viết `disabled="isSubmitting"`, trình duyệt sẽ hiểu chuỗi `"isSubmitting"` là một giá trị tĩnh (nút bấm sẽ luôn bị disable). Nhưng khi bọc trong dấu ngoặc vuông `[disabled]="isSubmitting"`, Angular sẽ hiểu rằng giá trị này là biến số trong class TypeScript. Khi `isSubmitting` là `false`, thuộc tính `disabled` của nút bấm sẽ bị gỡ bỏ.

## 3. Event Binding: Lắng nghe hành vi người dùng với dấu ngoặc tròn

Khi người dùng tương tác với trang web—như click chuột, gõ phím, hay di chuột—bạn cần bắt lấy sự kiện đó để thực thi logic. Cú pháp **Event Binding** sử dụng dấu ngoặc tròn `(event)="handler()"`:

```typescript
@Component({
  selector: 'app-search-box',
  template: `
    <input (input)="onSearchInput($event)" placeholder="Tìm kiếm..." />
    <button (click)="resetSearch()">Xóa tìm kiếm</button>
  `
})
export class SearchBoxComponent {
  keyword = '';

  onSearchInput(event: Event) {
    const target = event.target as HTMLInputElement;
    this.keyword = target.value;
  }

  resetSearch() {
    this.keyword = '';
  }
}
```

Cặp ngoặc tròn `(click)` báo cho Angular biết hãy lắng nghe sự kiện click của nút bấm và gọi hàm `resetSearch()`. Biến đặc biệt `$event` đại diện cho đối tượng sự kiện chuẩn của trình duyệt (DOM Event), cho phép bạn truy xuất chi tiết thông tin như phím bấm hay giá trị ô nhập liệu.

## Quy tắc ghi nhớ nhanh

Để không bị nhầm lẫn giữa các loại binding trong Angular, bạn chỉ cần nhớ quy tắc đơn giản về chiều di chuyển của dữ liệu:

- **Từ Class ra Template (Một chiều):** Dùng `{{ }}` cho text hoặc `[ ]` cho thuộc tính DOM. Dữ liệu chảy từ component ra giao diện.
- **Từ Template vào Class (Một chiều):** Dùng `( )` cho sự kiện. Hành động của người dùng kích hoạt hàm trong component.
- **Hai chiều (Two-way Binding):** Kết hợp cả hai cú pháp thành `[(ngModel)]` (thường được gọi vui là "chuối trong hộp" - *banana in a box* `[()]`), giúp dữ liệu trong ô input và biến trong class luôn đồng bộ tức thì với nhau.

Nắm vững Data Binding chính là chìa khóa để bạn làm chủ sự tương tác trong Angular. Ở bài tiếp theo, chúng ta sẽ khám phá cách điều khiển việc ẩn/hiện hoặc lặp lại các phần tử trên giao diện với cú pháp Control Flow hoàn toàn mới của Angular.

## References

- [Anatomy of components • Angular](https://angular.dev/guide/components)
- [What is Angular? • Angular](https://angular.dev/overview)

## Series

Previous: [Angular là gì? Tư duy Component và Ứng dụng đầu tiên](../01-introduction-and-first-component/index.md)

Next: [Điều khiển Hiển thị với Built-in Control Flow (@if, @for, @switch)](../03-built-in-control-flow/index.md)
