---
title: "Generics trong Java: Type Safety, Wildcards và Cơ chế Type Erasure"
description: "Generics cho compiler biết collection dự định chứa kiểu gì. Từ lỗi cast đến wildcard, bài viết giải thích cách dùng generic để phát hiện nhầm kiểu sớm hơn."

date:
updated:

series: "Java Core"
series_order: 5

tags:
  - java
  - generics
  - type-safety
  - type-erasure

status: draft
language: vi
---

# Generics trong Java: Type Safety, Wildcards và Cơ chế Type Erasure

Hãy tưởng tượng một danh sách ban đầu chỉ chứa tên, nhưng một đoạn code khác vô tình thêm số vào. Lỗi có thể không xuất hiện lúc thêm dữ liệu; nó chỉ lộ ra sau đó, khi code lấy phần tử ra và ép kiểu nó thành `String`. Generics giúp chuyển kiểu lỗi này về gần nơi nó được tạo ra hơn: compiler có thể báo rằng phần tử sai kiểu ngay lúc biên dịch.

## Khai báo kiểu để compiler cùng kiểm tra

Không có type argument, một collection kiểu raw có thể chứa nhiều loại object. Code lấy dữ liệu ra thường phải cast, và một phần tử không đúng kiểu có thể gây `ClassCastException` lúc chạy.

```java
import java.util.ArrayList;
import java.util.List;

class RawExample {
    void run() {
        List values = new ArrayList();
        values.add("Lan");
        values.add(42);

        String name = (String) values.get(1); // Lỗi khi chạy
    }
}
```

Khai báo `List<String>` làm ý định rõ ngay trên biến:

```java
import java.util.ArrayList;
import java.util.List;

class TypedExample {
    void run() {
        List<String> names = new ArrayList<>();
        names.add("Lan");
        names.add(42); // Compiler báo lỗi

        String name = names.get(0); // Không cần cast
    }
}
```

Type argument `<String>` cho compiler biết kiểu phần tử dự kiến. Bởi vậy lỗi được phát hiện tại chỗ thêm sai dữ liệu, trước khi chương trình chạy. Raw types vẫn tồn tại để tương tác với code cũ chưa dùng generics, nhưng khi chuyển chúng sang kiểu có tham số, compiler chỉ có thể cảnh báo vì không biết dữ liệu cũ có đúng kiểu hay không.

## Wildcard nói collection đang đưa dữ liệu vào hay nhận dữ liệu ra

Generics hữu ích khi method nhận collection của nhiều kiểu liên quan. Ví dụ một method chỉ cần đọc số có thể nhận `List<Integer>` lẫn `List<Double>` qua kiểu `List<? extends Number>`. Method đọc từng phần tử như một `Number`, nhưng không thể thêm một số tùy ý: collection thật bên dưới có thể chỉ nhận `Integer`.

Ngược lại, nếu method cần ghi `Integer` vào collection, `List<? super Integer>` cho phép nhận một list có kiểu phần tử là `Integer` hoặc kiểu cha phù hợp. Từ góc nhìn sử dụng, quy tắc dễ nhớ là: `extends` hợp với nguồn mình đọc, còn `super` hợp với nơi mình ghi. Khi một tham số vừa đọc vừa ghi cùng một kiểu, khai báo type parameter cụ thể thường rõ hơn wildcard.

Điều này không biến wildcard thành một danh sách bất biến. Nó chỉ giới hạn những thao tác compiler có thể chứng minh là an toàn. Hiểu giới hạn đó giúp tránh cố thêm phần tử vào một list có kiểu cụ thể mà method không biết.

## Type erasure giải thích vì sao generic không tạo class runtime riêng

Generics cung cấp kiểm tra kiểu cho compiler, nhưng Java không tạo một class runtime mới cho mỗi tổ hợp như `List<String>` và `List<Integer>`. Khi biên dịch, type erasure xóa thông tin type argument; type parameter được thay bằng bound của nó, hoặc `Object` nếu không có bound. Compiler có thể chèn cast cần thiết ở nơi code lấy dữ liệu ra.

Vì vậy, lợi ích chính của generic là kiểm tra lỗi sớm và giúp API diễn đạt kiểu dữ liệu, chứ không phải tạo một container runtime hoàn toàn khác cho mỗi kiểu. Raw type làm mất phần thông tin mà compiler dùng để bảo vệ code, nên chỉ nên gặp nó khi phải làm việc với API cũ.

## Kết luận

Khai báo type argument ở collection và class generic để compiler biết dữ liệu dự định có kiểu gì. Với wildcard, xác định method đọc từ collection hay ghi vào đó rồi chọn `extends` hoặc `super`. Khi thấy raw type, xem nó là ranh giới tương thích với code cũ và xử lý dữ liệu cẩn thận trước khi đưa vào code generic.

## References

- [Why Use Generics?](https://docs.oracle.com/javase/tutorial/java/generics/why.html)
- [Raw Types](https://docs.oracle.com/javase/tutorial/java/generics/rawTypes.html)
- [Bounded Type Parameters](https://docs.oracle.com/javase/tutorial/java/generics/bounded.html)
- [Guidelines for Wildcard Use](https://docs.oracle.com/javase/tutorial/java/generics/wildcardGuidelines.html)
- [Type Erasure](https://docs.oracle.com/javase/tutorial/java/generics/erasure.html)

## Series

- Previous: [Java Collections Framework: Phân tích kiến trúc List, Set, Map và Queue](../04-collections-framework/index.md)
- Next: [Xử lý ngoại lệ trong Java: Checked vs Unchecked Exception và Best Practices](../06-exception-handling/index.md)
