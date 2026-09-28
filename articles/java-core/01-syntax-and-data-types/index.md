---
title: "Java Core: Cú pháp cơ bản, Kiểu dữ liệu và Cơ chế hoạt động của JVM"
description: "Một phép gán có thể sao chép giá trị hoặc chia sẻ cùng một object. Hiểu kiểu dữ liệu, biến và đường đi từ source code đến JVM giúp đọc Java bớt mơ hồ."

date:
updated:

series: "Java Core"
series_order: 1

tags:
  - java
  - java-core
  - syntax
  - jvm

status: draft
language: vi
---

# Java Core: Cú pháp cơ bản, Kiểu dữ liệu và Cơ chế hoạt động của JVM

```java
class AssignmentExample {
    void copyNumber() {
        int first = 3;
        int second = first;
        second = 4;
    }
}
```

Đến đây, `first` vẫn là `3`. Nhưng nếu hai biến cùng tham chiếu tới một object, thay đổi object qua biến này có thể được nhìn thấy qua biến kia. Cùng là dấu `=`, vậy Java đang sao chép thứ gì? Hiểu câu trả lời sẽ giúp mình đọc code Java rõ hơn nhiều so với việc học thuộc tên kiểu dữ liệu.

## Hai kiểu dữ liệu, hai cách hiểu về biến

Java chia kiểu dữ liệu thành primitive types và reference types. `int` là primitive: biến giữ một giá trị số. Khi gán `second = first`, Java lấy giá trị hiện tại của `first` gán cho `second`; sau đó mỗi biến có thể đổi độc lập.

`String` và các class mình tự viết là reference types. Một biến kiểu này cho phép chương trình truy cập tới một object. Khi hai biến cùng giữ reference tới một object, chúng cùng làm việc với object ấy:

```java
class Note {
    String text;
}

class AssignmentExample {
    void shareObject() {
        Note firstNote = new Note();
        firstNote.text = "Bản nháp";

        Note secondNote = firstNote;
        secondNote.text = "Đã sửa";
    }
}
```

Sau dòng cuối, đọc `firstNote.text` cũng nhận được `"Đã sửa"`, vì hai biến không tạo ra hai `Note` khác nhau. Chúng cùng tham chiếu tới một object. Vì thế, khi một method nhận object và thay đổi state của nó, nơi gọi có thể nhìn thấy thay đổi đó. Đây là nguồn gốc của nhiều “tác dụng phụ” khó lần ra nếu mình tưởng rằng phép gán đã tạo một bản sao độc lập.

Reference cũng có thể là `null`, nghĩa là hiện tại biến chưa tham chiếu tới object nào. Gọi method hoặc đọc field qua một reference đang là `null` sẽ gây lỗi lúc chạy. Ngược lại, compiler có thể chặn sớm những phép gán sai kiểu, như đưa chuỗi vào một biến `int`. Kiểu dữ liệu vì vậy vừa giúp diễn đạt biến dùng để làm gì, vừa giúp phát hiện một số lỗi trước khi chương trình chạy.

## Vì sao field có giá trị mặc định còn biến trong method thì không?

Nhìn vào cùng một class, mình có thể gặp field và local variable:

```java
class Bicycle {
    int gear;

    void shiftUp() {
        int nextGear;
        nextGear = gear + 1;
        gear = nextGear;
    }
}
```

`gear` là field của object. Nếu chưa gán, field kiểu số nhận `0`, `boolean` nhận `false`, còn field reference nhận `null`. `nextGear` là local variable trong method nên phải được gán trước khi đọc. Nếu bỏ dòng gán `nextGear`, compiler báo lỗi thay vì để chương trình chạy với một giá trị không rõ ràng.

Quy tắc này giúp phân biệt state lâu hơn của object với dữ liệu tạm trong một lần gọi method. Khi thấy lỗi “variable might not have been initialized”, mình nên nhìn nơi khai báo biến trước: nếu nó nằm trong method, hãy chắc rằng mọi đường đi tới chỗ đọc đều đã gán giá trị.

## Source code đi tới JVM như thế nào?

File `.java` là thứ mình viết. Compiler kiểm tra source code rồi tạo class file; JVM đọc class file và thực thi chương trình. Tách hai bước này giúp hiểu vì sao một số lỗi xuất hiện trước khi chạy — chẳng hạn phép gán sai kiểu hoặc local variable chưa được gán — còn lỗi khác chỉ xuất hiện khi chương trình đang chạy.

Trong lúc đọc một method, hãy theo dõi các câu lệnh theo thứ tự. `if` chọn nhánh dựa trên điều kiện `boolean`; vòng lặp thực hiện lại một khối lệnh; `return` kết thúc method hiện tại. Những cấu trúc này quyết định đường đi của chương trình, còn kiểu của biến cho biết mỗi nhánh đang xử lý dữ liệu gì.

## Kết luận

Khi một giá trị bất ngờ thay đổi, trước tiên hãy kiểm tra biến đó là primitive hay reference và liệu có biến nào đang cùng tham chiếu tới object ấy không. Khi gặp lỗi biên dịch, kiểm tra kiểu của biến và việc local variable đã được gán trước khi đọc chưa. Còn khi lần theo cách chương trình chạy, bắt đầu từ source code, rồi nhớ rằng JVM thực thi class file do compiler tạo ra.

## References

- [Chapter 4. Types, Values, and Variables](https://docs.oracle.com/javase/specs/jls/se25/html/jls-4.html)
- [Primitive Data Types](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/datatypes.html)
- [Variables](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/variables.html)
- [Control Flow Statements](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/flow.html)
- [Chapter 2. The Structure of the Java Virtual Machine](https://docs.oracle.com/javase/specs/jvms/se25/html/jvms-2.html)

## Series

- Next: [Lập trình hướng đối tượng (OOP) trong Java: 4 Trụ cột và Ứng dụng thực tế](../02-object-oriented-programming/index.md)
