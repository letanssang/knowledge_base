---
title: "Java Core: Cú pháp cơ bản, Kiểu dữ liệu và Cơ chế hoạt động của JVM"
description: "Mã nguồn Java được cắt thành token rồi kiểm tra kiểu. JVM chạy class file, với stack riêng từng thread và heap dùng chung cho object."

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

> **Tóm tắt:** Mình gõ văn bản. Compiler cắt văn bản đó thành token và kiểm tra kiểu trước khi chạy. JVM không đọc file `.java`. Nó chạy `class` file: mỗi thread có stack riêng, còn object và array nằm trên heap dùng chung.

*Thời gian đọc: ~10 phút*

---

## 1. Văn bản mình gõ và thứ JVM chạy

`a--b` và `a - -b` không phải cùng một chương trình. Thiếu một khoảng trắng, `publicstatic` là một tên, không phải hai keyword. Máy ảo lại không nhìn các chữ đó. Nó nhận một `class` file và làm đúng các thao tác trong file đó.

Vì vậy có hai lớp quy tắc. Một lớp nói văn bản Unicode được cắt thành token thế nào. Lớp kia nói máy ảo trừu tượng giữ dữ liệu ở đâu khi chạy. Cách một JDK sắp xếp byte trong RAM, thuật toán garbage collection, và việc dịch lệnh máy ảo thành mã máy không thuộc các quy tắc đó. Hai JDK có thể bố trí bộ nhớ khác nhau mà vẫn chạy cùng một `class` file.

```text
Dòng chữ Unicode
    |  cắt thành token
    v
class file
    |  máy ảo thực thi
    v
pc, stack của từng thread | heap và method area dùng chung
```

Lệnh trong source thường chạy từ trên xuống. `if-then`, `if-then-else`, `switch`, `for`, `while`, `do-while`, `break`, `continue` và `return` là những chỗ dòng đó bị rẽ, lặp, hoặc nhảy ra.

---

## 2. Compiler cắt chữ trước khi hiểu câu

Một file nguồn là một dòng ký tự Unicode. Compiler đi ba bước, theo đúng thứ tự.

Bước một đổi `\u` cộng bốn chữ số thập lục phân thành một UTF-16 code unit. Nhờ bước này, cả chương trình viết được chỉ bằng ASCII. Ký tự vừa được tạo ra không bị đọc lại như một escape mới. `\u005cu005a` thành sáu ký tự `\ u 0 0 5 a`, không thành `Z`, vì backslash sinh ra từ escape đầu không mở escape thứ hai.

Bước hai nhận các cách xuống dòng khác nhau của hệ điều hành, nhưng số dòng trong chương trình vẫn khớp nhau.

Bước ba bỏ khoảng trắng và comment. Phần còn lại là token: tên, keyword, literal, dấu tách và toán tử.

Ở mỗi bước, compiler lấy cách cắt dài nhất, kể cả khi cách ngắn hơn mới tạo thành chương trình đúng. `a--b` thành `a`, `--`, `b`. Muốn hai dấu trừ đứng riêng, phải có khoảng trắng hoặc comment ở giữa: `a- -b`.

Có hai chỗ không lấy cách cắt dài nhất. Các dấu `\` liền nhau ở bước một được xử lý riêng. Ở bước ba, contextual keyword và dấu `>` trong kiểu cũng vậy. Trong một kiểu, `>` luôn là dấu so sánh, nên `List<List<String>>` không bị nuốt thành phép dịch bit `>>`.

`true` và `false` là boolean literal, không phải keyword. `null` là null literal. Dấu `_` được dùng ở một số khai báo thay cho tên.

`var`, `yield`, `record`, `sealed`, `permits`, `non-sealed`, `when`, và các từ của khai báo module (`module`, `open`, `exports`, `opens`, `provides`, `requires`, `to`, `uses`, `with`, `transitive`) chỉ thành keyword khi đứng đúng chỗ và không dính chữ hoặc số ngay trước hay ngay sau. `var` không phải tên kiểu. `yield` không phải tên kiểu và cũng không phải tên method không kèm qualifier. Viết chúng ở những chỗ đó là lỗi, dù ở một vị trí khác cùng chính tả vẫn có thể là tên.

Số nguyên kết thúc bằng `L` hoặc `l` thì có kiểu `long`. Không có hậu tố thì là `int`. `l` thường trông giống số `1`, nên mình viết `L`. `0x` là thập lục phân. `0b` là nhị phân, có từ Java SE 7. Dấu `_` được đặt giữa các chữ số từ Java SE 7 để dễ đọc, như `1_000_000`. Nó không được đứng đầu, đứng cuối, sát dấu thập phân, trước `F` hoặc `L`, hay chen vào tiền tố như `0_x`.

Một chuỗi trong dấu nháy kép là một object `String`, và giá trị của object đó không đổi sau khi tạo. Text block là một dạng literal nữa cho chuỗi. `String` không phải primitive type.

---

## 3. Hai họ giá trị

Mọi biến và mọi biểu thức có kiểu biết được lúc biên dịch. Kiểu giới hạn giá trị biến được giữ, giới hạn phép toán, và quyết định phép toán đó nghĩa là gì. Nhờ vậy nhiều lỗi hiện trước khi chạy.

Có hai họ. Primitive value là giá trị số hoặc `boolean`. Reference value là pointer tới một object, hoặc `null`.

| Kiểu | Bản chất | Khoảng giá trị |
| --- | --- | --- |
| `byte` | 8 bit, có dấu, bù hai | −128 đến 127 |
| `short` | 16 bit, có dấu, bù hai | −32.768 đến 32.767 |
| `int` | 32 bit, có dấu, bù hai | −2^31 đến 2^31−1 |
| `long` | 64 bit, có dấu, bù hai | −2^63 đến 2^63−1 |
| `char` | 16 bit không dấu, một UTF-16 code unit | 0 đến 65535 |
| `float` | IEEE 754 binary32 | |
| `double` | IEEE 754 binary64 | |
| `boolean` | `true` hoặc `false` | |

`char` là một code unit, không phải lúc nào cũng là một ký tự mình thấy trên màn hình. Một ký tự từ U+010000 đến U+10FFFF cần hai code unit. Từ Java SE 15, `float` và `double` theo IEEE 754 bản 2019. Trước đó là bản 1985.

`int` và `long` vẫn là số có dấu. Muốn so sánh hoặc chia như số không dấu thì dùng method của `Integer` và `Long`, chẳng hạn `compareUnsigned` và `divideUnsigned`. Đó không phải một kiểu primitive mới.

`double` là lựa chọn thông thường khi cần số thập phân. `float` và `double` không dùng cho giá trị phải đúng tuyệt đối, như tiền. Chỗ đó dùng `java.math.BigDecimal`. `byte` và `short` đáng dùng khi một mảng rất lớn và phần bộ nhớ tiết kiệm được thực sự có ích. `float` thay `double` cũng chỉ trong tình huống đó.

`boolean` biểu diễn một bit thông tin, nhưng ngôn ngữ không ấn định nó chiếm bao nhiêu byte. Giá trị primitive không dùng chung trạng thái với giá trị primitive khác, và literal của chúng không viết bằng `new`.

Reference type có bốn họ: class, interface, type variable, và array. `null` là một giá trị riêng. Không khai báo được biến kiểu null, nhưng `null` gán được cho mọi biến reference. Một object là một class instance hoặc một array. Mọi object, kể cả array, có các method của `Object`. Biến kiểu `Object` giữ được `null` hoặc bất kỳ object nào.

`0.0` và `-0.0` so sánh bằng nhau: `0.0 == -0.0` là `true`, còn `0.0 > -0.0` là `false`. Phép chia thì phân biệt được: `1.0/0.0` ra dương vô cực, `1.0/-0.0` ra âm vô cực. NaN không có thứ tự. `==` với NaN cho `false`, `!=` với NaN cho `true`, nên `x != x` đúng khi và chỉ khi `x` là NaN. Các phép `<`, `<=`, `>`, `>=` cũng cho `false` nếu có một vế là NaN. `0.0/0.0` là một cách ra NaN. Hằng số sẵn có là `Float.NaN` và `Double.NaN`.

---

## 4. Field được điền sẵn, biến trong method thì không

Field của class, field của từng object, và ô trong array được gán giá trị mặc định lúc chúng được tạo:

| Kiểu | Giá trị ban đầu |
| --- | --- |
| `byte`, `short`, `int` | `0` |
| `long` | `0L` |
| `float` | `0.0f` |
| `double` | `0.0d` |
| `char` | `'\u0000'` |
| `boolean` | `false` |
| reference | `null` |

Biến khai báo trong method không được điền sẵn. Đọc nó trước khi gán là lỗi biên dịch. Field `static` có một bản cho cả class, tạo khi class được chuẩn bị và mất khi class bị gỡ. Field không `static` được tạo cùng mỗi object mới. Biến trong method chỉ method đó thấy. Tham số, kể cả `args` của `main`, là biến chứ không phải field. Field, method và kiểu lồng nhau của một kiểu được gọi chung là member của kiểu đó.

Một biến effectively final là biến mà thêm `final` vào khai báo vẫn biên dịch được. Bỏ `final` khỏi một biến local hoặc tham số đang hợp lệ thì nó trở thành effectively final.

---

## 5. Khi method chạy, dữ liệu nằm ở đâu

Mỗi thread có một thanh ghi `pc`. Tại một thời điểm thread đang chạy một method. Method đó không phải `native` thì `pc` giữ địa chỉ lệnh đang chạy. Method là `native` thì giá trị `pc` không xác định.

Cùng thread có một stack, tạo lúc thread tạo. Stack chứa frame, giống stack của C: biến local, kết quả dang dở, và việc gọi rồi trả về method. Frame có thể được cấp trên heap, và bộ nhớ của stack không cần nằm liền một khối. Stack có thể cố định kích thước hoặc nở ra và co lại.

Một frame sinh ra mỗi lần gọi method và mất khi lời gọi kết thúc. Kết thúc vì exception mà method không xử lý cũng làm frame mất, và lời gọi đó không trả giá trị về cho bên gọi. Mỗi frame có mảng biến local, một operand stack lúc đầu rỗng, và một reference tới constant pool của class của method hiện tại.

Method `static` nhận tham số từ ô local số 0. Method của instance dùng ô 0 cho `this`. Tham số bắt đầu từ ô 1. `long` và `double` chiếm hai ô liên tiếp `n` và `n+1`. Không đọc được từ `n+1`. Ghi vào `n+1` thì được, nhưng làm hỏng giá trị ở `n`.

Operand stack là nơi các lệnh tính toán. `iadd` lấy hai `int` trên đỉnh, cộng, rồi đẩy tổng trở lại. Hai `int` không được đem dùng như một `long`, và hai `float` không được cộng bằng `iadd`. Việc này được kiểm khi verify `class` file. `iadd`, `ladd`, `fadd` và `dadd` đều là phép cộng, mỗi lệnh cho một kiểu. Hầu hết kiểm tra kiểu đã xong lúc biên dịch, nên lúc chạy giá trị primitive không cần mang thẻ kiểu.

Tên method và field trong `class` file lúc đầu là tên tượng trưng. Lúc chạy chúng được nối thành method cụ thể và offset cụ thể. Nhờ nối muộn, sửa một class khác ít làm gãy method đang gọi nó hơn.

Heap dùng chung cho mọi thread. Mọi class instance và mọi array lấy bộ nhớ từ đây, lúc máy ảo khởi động heap đã có. Object không có lệnh giải phóng. Garbage collector thu hồi, và ngôn ngữ không chọn thuật toán thu hồi nào. Hết chỗ mà bộ thu hồi không cấp thêm được thì máy ảo ném `OutOfMemoryError`.

Method area cũng dùng chung. Nó giữ, theo từng class, constant pool, dữ liệu field và method, cùng mã của method và constructor. Về logic nó là một phần của heap. Một máy ảo đơn giản có thể không thu hồi hoặc không nén vùng này, và không bắt buộc nó nằm ở chỗ nào. Hết bộ nhớ để cấp trong method area, kể cả khi dựng constant pool của một class, cũng là `OutOfMemoryError`.

Constant pool của mỗi class giống bảng ký hiệu, nhưng chứa nhiều loại dữ liệu hơn, và được cấp từ method area.

Stack của thread cần lớn hơn mức được phép thì máy ảo ném `StackOverflowError`. Một chuỗi gọi method dài, kể cả đệ quy, là một cách để tới ngưỡng đó. Không nở thêm được stack, hoặc không tạo được stack cho thread mới, thì lại là `OutOfMemoryError`. Native method stack có cả hai lỗi đó.

---

## Kết luận

Khi một dòng Java trông đúng mà compiler hiểu khác, mình kiểm khoảng trắng và dấu `>` trong generic trước. `publicstatic` là một tên. `List<List<String>>` vẫn là hai dấu đóng kiểu.

Khi một biến "tự nhiên bằng 0", mình nhìn chỗ khai báo. Field và ô array được điền sẵn. Biến trong method thì chưa gán là chưa có giá trị.

Khi chương trình chết vì bộ nhớ, mình tách hai việc. `StackOverflowError` là stack của thread không đủ cho chuỗi gọi method. `OutOfMemoryError` có thể là heap, là stack không nở được, hoặc là method area không chứa thêm class. Object nằm trên heap và không được giải phóng bằng một lệnh trong ngôn ngữ.

## References

- [Chapter 3. Lexical Structure](https://docs.oracle.com/javase/specs/jls/se25/html/jls-3.html)
- [Chapter 4. Types, Values, and Variables](https://docs.oracle.com/javase/specs/jls/se25/html/jls-4.html)
- [Chapter 2. The Structure of the Java Virtual Machine](https://docs.oracle.com/javase/specs/jvms/se25/html/jvms-2.html)
- [Variables (The Java™ Tutorials)](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/variables.html)
- [Primitive Data Types (The Java™ Tutorials)](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/datatypes.html)
- [Control Flow Statements (The Java™ Tutorials)](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/flow.html)

## Series

- Next: [Lập trình hướng đối tượng (OOP) trong Java: 4 Trụ cột và Ứng dụng thực tế](../02-object-oriented-programming/index.md)
