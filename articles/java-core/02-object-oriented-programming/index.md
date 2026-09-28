---
title: "Lập trình hướng đối tượng (OOP) trong Java: 4 Trụ cột và Ứng dụng thực tế"
description: "Object, class, data encapsulation, kế thừa đơn và virtual method invocation trong Java, theo The Java Tutorials."

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

> **Tóm tắt:** Tutorial của Oracle không đặt tên "bốn trụ cột". Các trang mình dùng mô tả object bằng state và behavior, class là blueprint, data encapsulation, kế thừa đơn từ một superclass, và polymorphism qua virtual method invocation.

*Thời gian đọc: ~10 phút*

---

## 1. Object giữ state, class là blueprint

Một object phần mềm gồm state và behavior đi cùng nhau. State nằm trong field. Behavior nằm trong method. Method thao tác trên state bên trong và là cơ chế chính để object nói chuyện với object khác. Che state bên trong và buộc mọi tương tác đi qua method được tutorial gọi là *data encapsulation*.

Ví dụ trên trang: nếu một chiếc xe chỉ có 6 số, method đổi số có thể từ chối giá trị nhỏ hơn 1 hoặc lớn hơn 6. Object giữ quyền quyết định thế giới bên ngoài được dùng nó thế nào.

Tutorial liệt kê bốn lợi ích của việc bó code vào từng object:

1. Modularity: source của một object viết và bảo trì độc lập với object khác. Object tạo xong thì đưa đi trong hệ thống được.
2. Information-hiding: chỉ nói chuyện qua method thì chi tiết hiện thực bên trong không lộ ra ngoài.
3. Code re-use: object đã có, kể cả do người khác viết, dùng lại được. Người chuyên một việc implement, test và debug object đó. Mình tin nó chạy trong code của mình.
4. Pluggability: object nào có vấn đề thì gỡ khỏi ứng dụng và cắm object khác vào chỗ đó. Trang ví với một con bu-lông gãy: thay con bu-lông, không thay cả cái máy.

Class là blueprint hay prototype để tạo từng object. Nhiều chiếc xe cùng loại được dựng từ cùng một bộ bản vẽ. Trong code, chiếc xe của mình là một instance của class những chiếc xe. Class `Bicycle` trên tutorial giữ `cadence`, `speed`, `gear` và các method đổi những field đó. Class này không có `main` vì nó chưa phải một ứng dụng. Việc tạo và dùng object `Bicycle` thuộc về class khác. `BicycleDemo` tạo hai object, gọi method riêng trên từng object, và in ra hai trạng thái khác nhau:

```text
cadence:50 speed:10 gear:2
cadence:40 speed:20 gear:3
```

Hai biến không chia sẻ state. Đó là điểm tutorial muốn chỉ bằng output này.

---

## 2. Kế thừa một superclass, không kế thừa constructor

Trong Java, class được *derived* từ class khác và nhờ đó *inherit* field cùng method. Class được dẫn ra gọi là subclass, cũng gọi là derived class, extended class, hoặc child class. Class gốc gọi là superclass, cũng gọi là base class hoặc parent class.

Trừ `Object`, class không có superclass, mọi class có đúng một direct superclass. Đây là single inheritance trên trang Inheritance. Không khai báo superclass khác thì class là subclass ngầm của `Object`. Một class có thể được dẫn từ class được dẫn từ class khác, và cuối chuỗi là `Object`. Class đó *descended* từ mọi class trên chuỗi. `java.lang.Object` định nghĩa và hiện thực behavior chung cho mọi class, kể cả class mình viết. Class càng gần đáy của hierarchy thì behavior càng chuyên biệt.

Khi class mới cần một phần code đã có, mình derive từ class đó và dùng lại field cùng method, khỏi viết và debug lại. Subclass inherit mọi member, tức field, method và nested class, từ superclass. Constructor không phải member, nên không được inherit. Subclass vẫn gọi được constructor của superclass.

Quy tắc truy cập trên cùng trang hẹp hơn câu "mọi member":

- Subclass inherit mọi member `public` và `protected` của parent, dù khác package.
- Cùng package thì inherit thêm member package-private.
- Không inherit member `private` của parent. Nếu superclass có method `public` hoặc `protected` để đọc field `private`, subclass dùng được các method đó.
- Nested class truy cập được mọi private member, field lẫn method, của enclosing class. Vì vậy một nested class `public` hoặc `protected` mà subclass inherit sẽ có quyền truy cập gián tiếp tới mọi private member của superclass.

Trong subclass, member inherit dùng được ngay. Field trùng tên với superclass thì *hide* field đó. Trang ghi cách này là không nên. Method instance mới, cùng signature với method instance của superclass, thì *override*. Method static mới, cùng signature với method static của superclass, thì *hide*. Constructor của subclass gọi constructor superclass ngầm hoặc bằng `super`.

`MountainBike extends Bicycle` thêm field `seatHeight` và method `setHeight`, rồi gọi `super(startCadence, startSpeed, startGear)` trước khi gán `seatHeight`. Ngoài constructor, nó như một class viết mới với các field và method của `Bicycle` cộng phần thêm. Phần việc không phải làm lại chính là lý do trang đưa ví dụ này.

`MountainBike` descended từ `Bicycle` và `Object`, nên một `MountainBike` là một `Bicycle` và cũng là một `Object`. Nó dùng được ở chỗ đang cần `Bicycle` hoặc `Object`. Chiều ngược lại không hiển nhiên: một `Bicycle` *có thể* là `MountainBike`, nhưng không chắc.

---

## 3. Override, hide, và default method

Instance method ở subclass cùng signature, nghĩa là tên cộng số lượng và kiểu parameter, và cùng return type với instance method ở superclass thì override method đó. Overriding method cũng được trả về một subtype của kiểu mà method bị override trả về. Subtype đó gọi là covariant return type.

`@Override` báo compiler rằng mình định override một method ở superclass. Nếu compiler thấy method đó không có ở superclass nào, nó báo lỗi. Trang nói mình có thể muốn dùng annotation này, không nói mọi method đều phải gắn.

Static method cùng signature ở subclass thì hide static method của superclass, không override. Hệ quả trên trang:

- Bản instance method bị override được gọi là bản ở subclass.
- Bản static method bị hide được gọi phụ thuộc vào việc lời gọi xuất phát từ superclass hay subclass.

`Cat extends Animal`. Cả hai có `testClassMethod` static và `testInstanceMethod` instance. `main` làm `Animal myAnimal = new Cat()`, rồi gọi `Animal.testClassMethod()` và `myAnimal.testInstanceMethod()`. Output trên trang là:

```text
The static method in Animal
The instance method in Cat
```

Static đi theo class dùng trong lời gọi. Instance đi theo object. Đổi instance method ở superclass thành static ở subclass, hoặc ngược lại, là lỗi biên dịch.

Access specifier của overriding method được phép rộng hơn, không được hẹp hơn, method bị override. Method `protected` ở superclass có thể thành `public` ở subclass, không thành `private`.

Trong subclass mình có thể overload method inherit từ superclass. Method overload không hide và không override instance method của superclass. Chúng là method mới, chỉ của subclass.

Default method và abstract method trong interface được inherit như instance method. Khi nhiều supertype cùng cung cấp default method trùng signature, compiler giải theo hai nguyên tắc trên trang.

Instance method được ưu tiên hơn interface default method. `Pegasus extends Horse implements Flyer, Mythical`. Cả `Horse`, `Flyer` và `Mythical` đều có `identifyMyself`. `Pegasus.identifyMyself` trả về `"I am a horse."`.

Method đã bị candidate khác override thì bị bỏ qua. `EggLayer` override default `identifyMyself` của `Animal`. `FireBreather` chỉ extend `Animal` và không khai báo lại method. `Dragon implements EggLayer, FireBreather` nên `identifyMyself` trả về `"I am able to lay eggs."`.

Hai hay nhiều default method định nghĩa độc lập mà xung đột, hoặc một default method xung đột với một abstract method, thì compiler báo lỗi. Mình phải override tường minh method của supertype. Class implement cả `OperateCar` và `FlyCar`, hai interface có default `startEngine` cùng signature, phải tự viết `startEngine`. Bản default gọi được bằng `FlyCar.super.startEngine(key)` hoặc `OperateCar.super.startEngine(key)`. Tên đứng trước `super` phải là direct superinterface có định nghĩa hoặc inherit default của method được gọi. Dạng gọi này không chỉ dành cho lúc hai interface đụng nhau. `super` cũng gọi được default method từ class và từ interface.

Instance method inherit từ class override được abstract method của interface. `Mustang extends Horse implements Mammal`. `Mammal` khai báo abstract `identifyMyself`. `Horse` có instance method cùng tên. `Mustang` không viết lại method, và lời gọi trả về `"I am a horse."`.

Static method trong interface không bao giờ được inherit. Câu này là note trên chính trang Overriding and Hiding Methods.

---

## 4. Virtual method invocation

Polymorphism trên trang này là việc subclass định nghĩa behavior riêng mà vẫn chia sẻ một phần chức năng của parent. `Bicycle`, `MountainBike` và `RoadBike` cùng có `printDescription`. Hai subclass override method đó. `MountainBike` in thêm loại suspension. `RoadBike` in thêm bề rộng lốp, tính bằng mm.

`TestBikes` khai báo ba biến kiểu `Bicycle`, rồi gán lần lượt `new Bicycle(20, 10, 1)`, `new MountainBike(20, 10, 5, "Dual")` và `new RoadBike(40, 20, 8, 23)`. Output mà trang in ra là mô tả của xe thường, rồi xe núi có suspension `Dual`, rồi xe đường có lốp `23` mm.

JVM gọi method phù hợp với object mà biến đang trỏ tới. Nó không gọi method được định nghĩa bởi kiểu của biến. Trang gọi behavior này là *virtual method invocation*.

---

## 5. Cast và những lỗi trang nói rõ

`Object obj = new MountainBike()` là implicit casting. `obj` vừa là `Object` vừa là `MountainBike`, cho đến khi bị gán một object khác không phải `MountainBike`.

`MountainBike myBike = obj` không biên dịch, vì compiler không biết `obj` là `MountainBike`. Explicit cast `(MountainBike) obj` nói với compiler rằng mình hứa gán một `MountainBike`. Cast này chèn một kiểm tra lúc chạy để compiler được coi `obj` là `MountainBike`. Nếu lúc chạy `obj` không phải `MountainBike`, một exception bị ném. Trang không đặt tên exception đó. Mình không gắn thêm tên.

`instanceof` kiểm tra kiểu trước khi cast. Trang nói toán tử này xác nhận `obj` trỏ tới một `MountainBike`, nên mình cast mà biết sẽ không có runtime exception từ cast sai:

```java
if (obj instanceof MountainBike) {
    MountainBike myBike = (MountainBike) obj;
}
```

Ba lỗi khác trang nói bằng điều kiện biên dịch hoặc bằng ví dụ chạy:

- Override mà thu hẹp access, hoặc đổi instance method thành static và ngược lại, là lỗi biên dịch.
- Gọi static method qua tên superclass thì chạy bản của superclass, dù biến đang giữ instance của subclass. Ví dụ `Animal.testClassMethod()` ở trên in dòng của `Animal`.
- Hai default method độc lập trùng signature, hoặc default method đụng abstract method, mà class không override, thì compiler báo lỗi.

Field trùng tên ở subclass hide field của superclass. Trang Inheritance ghi cách này là không nên. Đó là hide, không phải override.

---

## Kết luận

Mình dùng các trang này như ba quy tắc khi đọc một class Java. State đổi qua method thì object còn kiểm soát được giá trị hợp lệ, đúng ví dụ 6 số của tutorial. Một class chỉ có một direct superclass, constructor không đi theo inheritance, và member `private` không được inherit dù member `public` và `protected` thì có. Khi biến có kiểu superclass mà object là subclass, instance method override chạy theo object. Static method cùng signature thì hide, và lời gọi chọn bản theo kiểu dùng ở chỗ gọi.

`instanceof` trên trang là cách tránh runtime exception của một cast sai. Nó không phải một lệnh bắt buộc trước mọi cast. `@Override` là cách nhờ compiler báo khi method mình tưởng đang override thực ra không có ở superclass.

## References

- [Lesson: Object-Oriented Programming Concepts](https://docs.oracle.com/javase/tutorial/java/concepts/index.html)
- [What Is an Object?](https://docs.oracle.com/javase/tutorial/java/concepts/object.html)
- [What Is a Class?](https://docs.oracle.com/javase/tutorial/java/concepts/class.html)
- [Inheritance](https://docs.oracle.com/javase/tutorial/java/IandI/subclasses.html)
- [Overriding and Hiding Methods](https://docs.oracle.com/javase/tutorial/java/IandI/override.html)
- [Polymorphism](https://docs.oracle.com/javase/tutorial/java/IandI/polymorphism.html)

## Series

- Previous: [Java Core: Cú pháp cơ bản, Kiểu dữ liệu và Cơ chế hoạt động của JVM](../01-syntax-and-data-types/index.md)
- Next: [Phân biệt Interface và Abstract Class: Bản chất, Khác biệt và Cách thiết kế](../03-interface-and-abstract-class/index.md)
