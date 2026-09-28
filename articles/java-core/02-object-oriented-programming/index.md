---
title: "Lập trình hướng đối tượng (OOP) trong Java: 4 Trụ cột và Ứng dụng thực tế"
description: "Object giữ state và behavior. Class là bản vẽ. Java chỉ kế thừa một superclass, còn instance method override chạy theo object thật."

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

> **Tóm tắt:** Mình nhét state vào field và behavior vào method, rồi chỉ cho bên ngoài gọi method. Class là bản vẽ để tạo nhiều object. Một class chỉ có một superclass trực tiếp. Instance method bị override chạy theo object đang nằm trong biến, không theo kiểu khai báo của biến.

*Thời gian đọc: ~10 phút*

---

## 1. Che state, để method quyết định

Một chiếc xe có số đang cài, tốc độ, và việc mình được phép đổi số. Trong code, state nằm ở field, behavior nằm ở method. Method sửa state bên trong và là cách object nói chuyện với object khác. Data encapsulation là việc giấu state và bắt mọi tương tác đi qua method.

Nếu xe chỉ có 6 số, method đổi số từ chối giá trị nhỏ hơn 1 hoặc lớn hơn 6. Object giữ quyền quyết định bên ngoài được dùng nó thế nào. Field `public` thì bất kỳ chỗ nào cũng gán `gear = 9` được, và chỗ kiểm tra 6 số không còn cơ hội chạy.

Bó code vào từng object cho mình bốn việc. Source của object này sửa được mà không đụng object kia, và object tạo xong thì đưa đi trong hệ thống. Bên ngoài chỉ gọi method nên không phụ thuộc cách mình cất field. Object người khác đã viết, đã test, mình dùng lại được. Object nào hỏng thì gỡ ra và cắm object khác vào chỗ đó, như thay một con bu-lông chứ không thay cả cái máy.

Interface là hợp đồng với bên ngoài. Class implement interface thì hứa cung cấp behavior mà interface đã công bố. Phần "abstraction" mình dùng ở đây là hợp đồng đó: bên gọi biết được gọi method nào, không cần biết class nào đang làm.

---

## 2. Class là bản vẽ, object là từng chiếc xe

Nhiều xe cùng loại dựng từ một bộ bản vẽ. Class là bản vẽ đó. Chiếc xe trong chương trình là một instance.

`Bicycle` giữ `cadence`, `speed`, `gear` và các method đổi chúng. Class này không có `main`. Nó chưa phải một ứng dụng. Class khác tạo xe và gọi method. Hai lần `new Bicycle()` là hai object. Đổi cadence của xe thứ hai không đổi xe thứ nhất:

```text
cadence:50 speed:10 gear:2
cadence:40 speed:20 gear:3
```

Field không `static` là của từng instance. Field `static` có một bản cho cả class, dù mình tạo bao nhiêu instance.

---

## 3. Một superclass, và không phải thứ gì cũng được kế thừa

`MountainBike` cần cadence, speed và gear của `Bicycle`, rồi thêm chiều cao yên. Mình cho nó `extends Bicycle` thay vì chép lại các field và method. Class được dẫn ra là subclass. Class gốc là superclass.

Trừ `Object`, class không có superclass, mọi class có đúng một superclass trực tiếp. Không khai báo superclass thì class là subclass ngầm của `Object`. Một class có thể được dẫn từ class được dẫn từ class khác, và cuối chuỗi là `Object`. Class càng gần đáy thì behavior càng hẹp. `MountainBike` là một `Bicycle` và cũng là một `Object`, nên dùng được ở chỗ đang cần hai kiểu đó. Chiều ngược lại không chắc: một `Bicycle` có thể là `MountainBike`, nhưng không phải lúc nào cũng vậy.

Subclass nhận field, method và nested class của superclass. Constructor không phải member, nên không đi theo kế thừa. Subclass vẫn gọi được constructor của superclass bằng `super(...)`.

Quyền truy cập hẹp hơn câu "nhận mọi thứ":

- Member `public` và `protected` được nhận dù khác package.
- Cùng package thì nhận thêm member không ghi modifier.
- Member `private` không được nhận. Subclass vẫn gọi được method `public` hoặc `protected` của superclass nếu method đó đọc field `private`.
- Nested class thấy mọi member `private` của class bao nó. Nested class `public` hoặc `protected` mà subclass nhận được sẽ thấy gián tiếp các member `private` của superclass.

Field trùng tên ở subclass che field của superclass. Cách này không nên dùng. Constructor của subclass gọi constructor superclass ngầm, hoặc gọi tường minh bằng `super` trước khi gán phần của riêng nó. `MountainBike` gọi `super(startCadence, startSpeed, startGear)` rồi mới gán `seatHeight`.

---

## 4. Override chạy theo object, static thì chạy theo chỗ gọi

Instance method ở subclass, cùng tên, cùng số lượng và kiểu tham số, cùng kiểu trả về hoặc một kiểu con của kiểu trả về, thì override method của superclass. Kiểu trả về là kiểu con được gọi là covariant return type.

`@Override` báo compiler rằng mình định override. Method không có ở superclass nào thì compiler báo lỗi. Annotation này không bắt buộc, nhưng nó bắt giúp chỗ mình tưởng đang override mà thực ra là method mới.

Static method cùng chữ ký ở subclass thì che static method của superclass, không override.

```java
public class Animal {
    public static void testClassMethod() {
        System.out.println("The static method in Animal");
    }
    public void testInstanceMethod() {
        System.out.println("The instance method in Animal");
    }
}

public class Cat extends Animal {
    public static void testClassMethod() {
        System.out.println("The static method in Cat");
    }
    public void testInstanceMethod() {
        System.out.println("The instance method in Cat");
    }

    public static void main(String[] args) {
        Cat myCat = new Cat();
        Animal myAnimal = myCat;
        Animal.testClassMethod();
        myAnimal.testInstanceMethod();
    }
}
```

`Animal.testClassMethod()` in dòng của `Animal` vì lời gọi static đi theo tên class. `myAnimal.testInstanceMethod()` in dòng của `Cat` vì object thật là `Cat`. Đổi instance method ở superclass thành static ở subclass, hoặc ngược lại, không biên dịch.

Method override được mở quyền hơn, không được thu hẹp. `protected` ở superclass có thể thành `public` ở subclass, không thành `private`.

Overload một method đã kế thừa thì method mới thuộc riêng subclass. Nó không che và không override method cũ.

Default method và abstract method của interface được kế thừa như instance method. Khi nhiều interface có default method trùng chữ ký, class thắng interface: `Pegasus` vừa kế thừa `Horse` vừa implement `Flyer` và `Mythical` thì `identifyMyself()` trả về `"I am a horse."`. Method đã bị ứng viên khác override thì bị bỏ qua: `Dragon` implement `EggLayer` và `FireBreather` dùng bản của `EggLayer`, `"I am able to lay eggs."`. Hai default method định nghĩa độc lập mà trùng chữ ký, hoặc một default method đụng một abstract method, thì compiler báo lỗi cho đến khi class tự viết method đó. Bản default gọi được bằng `FlyCar.super.startEngine(key)`. Tên đứng trước `super` phải là interface cha trực tiếp. Static method trong interface không bao giờ được kế thừa.

---

## 5. Cùng một biến Bicycle, ba kiểu xe in ba câu

`Bicycle`, `MountainBike` và `RoadBike` đều có `printDescription`. Hai class con override method đó. Ba biến đều khai báo kiểu `Bicycle`, nhưng lần lượt giữ `new Bicycle(...)`, `new MountainBike(...)` và `new RoadBike(...)`. JVM gọi method của object trong biến, không gọi method của kiểu khai báo. Đó là virtual method invocation. Xe núi in thêm loại suspension. Xe đường in thêm bề rộng lốp.

`Object obj = new MountainBike()` là cast ngầm. `obj` vừa là `Object` vừa là `MountainBike`, cho đến khi bị gán object khác. `MountainBike myBike = obj` không biên dịch, vì compiler không biết `obj` là `MountainBike`. `(MountainBike) obj` là lời hứa của mình. Compiler chèn một lần kiểm lúc chạy. Nếu lúc đó object không phải `MountainBike`, một exception bị ném. `instanceof` kiểm trước khi cast, nên mình cast mà biết lần kiểm đó sẽ qua:

```java
if (obj instanceof MountainBike) {
    MountainBike myBike = (MountainBike) obj;
}
```

---

## Kết luận

State mà bên ngoài không được phá thì để field không `public` và sửa qua method. Method đó là chỗ từ chối số 7 trên chiếc xe chỉ có 6 số.

Một class chỉ có một superclass trực tiếp. Constructor và member `private` không đi theo kế thừa. Cần nhiều hợp đồng cùng lúc thì implement nhiều interface. Bài sau tách interface và abstract class.

Khi biến có kiểu superclass mà object là subclass, instance method override chạy theo object. Static method cùng chữ ký thì chạy theo class viết ở chỗ gọi. Cast xuống subclass chỉ an toàn sau khi `instanceof` đã đúng, hoặc khi mình chắc chỗ tạo ra object.

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
