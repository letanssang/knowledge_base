---
title: "Lập trình hướng đối tượng (OOP) trong Java: 4 Trụ cột và Ứng dụng thực tế"
description: "OOP giúp mô hình hóa state và hành vi trong object. Qua ví dụ xe đạp, bài viết nối class, object, đóng gói, trừu tượng, kế thừa và đa hình thành một cách thiết kế dễ hình dung."

date:
updated:

series: "Java Core"
series_order: 2

tags:
  - java
  - oop
  - polymorphism
  - inheritance

status: draft
language: vi
---

# Lập trình hướng đối tượng (OOP) trong Java: 4 Trụ cột và Ứng dụng thực tế

Giả sử một ứng dụng ban đầu chỉ quản lý xe đạp thường. Mỗi chiếc có số đang cài, tốc độ và vài thao tác như tăng tốc hay đổi số. Khi ứng dụng cần thêm xe đạp địa hình, mình có thể sao chép class cũ rồi sửa vài chỗ. Cách đó chạy được lúc đầu, nhưng mỗi lần sửa quy tắc chung lại phải nhớ cập nhật nhiều bản sao.

OOP đưa ra một cách tổ chức khác: gom state và những thao tác liên quan vào object, rồi mô tả các loại object bằng class. Từ ví dụ chiếc xe, ta có thể thấy bốn ý thường được nhắc tới trong OOP — encapsulation, abstraction, inheritance và polymorphism — giải quyết những vấn đề khác nhau.

## Class là mô tả, object là chiếc xe cụ thể

Một class định nghĩa loại dữ liệu và hành vi mà object của nó có. `Bicycle` có thể mô tả những field như `gear` và `speed`, cùng những method như `changeGear` hay `speedUp`. Khi tạo hai object từ class ấy, mỗi object có state riêng: chiếc thứ nhất có thể ở số 2, chiếc thứ hai ở số 5.

Phân biệt class với object quan trọng vì code thường làm việc với từng object cụ thể, còn class cho biết những object cùng loại có gì và làm được gì. Nếu `gear` thay đổi trên chiếc thứ nhất, object thứ hai không tự đổi theo. Chúng cùng được tạo từ một mô tả, nhưng không phải cùng một object.

## Đóng gói và trừu tượng giúp code bên ngoài bớt phụ thuộc

Nếu mọi đoạn code đều được phép sửa `gear` trực tiếp, một nơi có thể đặt số hợp lệ, nơi khác lại vô tình đặt số không hợp lệ. Encapsulation gom dữ liệu với các thao tác quản lý dữ liệu đó, để object kiểm soát cách state của nó thay đổi. Thay vì cho code bên ngoài sửa field tùy ý, class có thể đưa ra method `changeGear` và tự quyết định có chấp nhận giá trị mới hay không.

Abstraction giải quyết một câu hỏi gần đó nhưng khác: người dùng object cần biết điều gì để làm việc với nó? Nơi gọi chỉ cần biết có thể gọi `changeGear`; nó không cần biết class lưu state ra sao hay kiểm tra giá trị bằng những bước nào. Phần giao tiếp công khai là API của object. Khi implementation thay đổi mà API vẫn làm đúng điều đã hứa, code gọi không phải thay đổi theo.

Hai ý này thường đi cùng nhau: encapsulation giữ quyền kiểm soát bên trong object, còn abstraction giúp phần bên ngoài chỉ nhìn thấy những thao tác cần thiết. Chúng đặc biệt hữu ích khi một class bắt đầu được dùng ở nhiều nơi và ta muốn thay cách thực hiện mà không phải sửa mọi caller.

## Kế thừa chỉ có ý nghĩa khi quan hệ cha-con đúng

Xe đạp địa hình vẫn là một loại xe đạp. Vì vậy `MountainBike` có thể kế thừa `Bicycle`, dùng lại phần chung rồi bổ sung state riêng như chiều cao yên. Đây là inheritance: class con nhận thành viên từ superclass và có thể mở rộng hoặc điều chỉnh hành vi.

```java
class Bicycle {
    String description() {
        return "A bicycle";
    }
}

class MountainBike extends Bicycle {
    @Override
    String description() {
        return "A mountain bike";
    }
}
```

Kế thừa giúp chia sẻ code, nhưng không nên dùng chỉ vì hai class có vài dòng giống nhau. Nếu `MountainBike` không thực sự là một loại `Bicycle`, quan hệ cha-con sẽ khiến mô hình khó hiểu và class con phải mang theo hành vi không phù hợp. Trong Java, mỗi class chỉ có một superclass trực tiếp; interface là một cách khác để mô tả khả năng mà nhiều loại class có thể cùng cung cấp.

## Đa hình cho phép gọi cùng một thao tác trên nhiều loại object

Giờ một method khác nhận `Bicycle` và gọi `describe()`. Nó có thể nhận cả `MountainBike`, vì đây là class con của `Bicycle`. Khi instance method được override, Java chọn implementation theo loại object thật đang được tham chiếu:

```java
class Example {
    void run() {
        Bicycle bike = new MountainBike();
        String text = bike.description(); // text nhận "A mountain bike"
    }
}
```

Đây là polymorphism: code gọi làm việc qua một kiểu chung, còn từng loại object cung cấp cách phản hồi phù hợp. Khi thêm loại xe mới, mình có thể bổ sung implementation mà không nhất thiết viết một nhánh `if` cho mọi loại trong code đang gọi.

## Kết luận

Khi thiết kế bằng OOP, bắt đầu từ state và hành vi thuộc về object nào. Đóng gói state sau API rõ ràng, dùng inheritance khi class con thực sự là một dạng của class cha, và dùng polymorphism khi nhiều loại object cần đáp ứng cùng một thao tác theo cách riêng. Bốn ý này giúp code dễ mở rộng khi dùng đúng quan hệ; chúng không phải danh sách kỹ thuật cần thêm vào mọi class.

## References

- [Object-Oriented Programming Concepts](https://docs.oracle.com/javase/tutorial/java/concepts/index.html)
- [What Is a Class?](https://docs.oracle.com/javase/tutorial/java/concepts/class.html)
- [What Is an Object?](https://docs.oracle.com/javase/tutorial/java/concepts/object.html)
- [Inheritance](https://docs.oracle.com/javase/tutorial/java/IandI/subclasses.html)
- [Overriding and Hiding Methods](https://docs.oracle.com/javase/tutorial/java/IandI/override.html)
- [Polymorphism](https://docs.oracle.com/javase/tutorial/java/IandI/polymorphism.html)

## Series

- Previous: [Java Core: Cú pháp cơ bản, Kiểu dữ liệu và Cơ chế hoạt động của JVM](../01-syntax-and-data-types/index.md)
- Next: [Phân biệt Interface và Abstract Class: Bản chất, Khác biệt và Cách thiết kế](../03-interface-and-abstract-class/index.md)
