---
title: "Java Core: Cú pháp cơ bản, Kiểu dữ liệu và Cơ chế hoạt động của JVM"
description: "Cú pháp từ vựng, hệ thống kiểu và biến của Java SE 25 theo JLS, cùng các vùng nhớ runtime của JVM theo JVMS."

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

> **Tóm tắt:** Mã nguồn Java được dịch từ một dòng ký tự Unicode thành token, rồi bị ràng buộc bởi hệ thống kiểu tĩnh. JVM không chạy văn bản đó trực tiếp. Nó thực thi `class` file trên một máy ảo trừu tượng, với stack riêng cho từng thread và heap dùng chung cho object cùng array.

*Thời gian đọc: ~11 phút*

---

## 1. Ngôn ngữ và máy ảo là hai đặc tả

Khi mình đọc Java Core, mình tách hai tài liệu ra ngay từ đầu. *The Java Language Specification, Java SE 25* mô tả chương trình viết bằng Unicode được dịch từ vựng thành token. *The Java Virtual Machine Specification, Java SE 25* mô tả một máy ảo trừu tượng. Muốn hiện thực đúng JVM, chỉ cần đọc được định dạng `class` file và thực hiện đúng các thao tác trong đặc tả.

JVMS nói thẳng những gì không thuộc đặc tả: cách bố trí bộ nhớ của các vùng runtime, thuật toán garbage collection, và việc dịch lệnh của máy ảo thành mã máy. Những phần đó để người hiện thực chọn. Vì vậy mình không lấy layout bộ nhớ của một JDK cụ thể làm quy tắc của ngôn ngữ.

Trang *The Java Tutorials* dùng ở bài này được Oracle viết cho JDK 8. Banner trên trang nói các ví dụ chưa tính đến cải tiến của bản sau và có thể dùng công nghệ không còn tồn tại. Mình lấy tutorial cho cách giải thích và ví dụ, còn khẳng định về kiểu và bộ nhớ thì lấy JLS cùng JVMS SE 25.

```text
Dòng ký tự Unicode
    |  (1) Unicode escape  (2) line terminator  (3) token
    v
Token: identifier, keyword, literal, separator, operator
    |
    v
class file
    |
    v
JVM: pc, JVM stack, native method stack | heap, method area
```

---

## 2. Từ một dòng ký tự thành token

JLS §3.2 áp dụng ba bước lexical translation theo đúng thứ tự.

Bước một dịch Unicode escape trong dòng thô. Escape dạng `\u` cộng bốn chữ số thập lục phân biểu diễn một UTF-16 code unit. Bước này cho phép viết cả chương trình chỉ bằng ký tự ASCII. Ký tự do một Unicode escape tạo ra không tham gia thêm Unicode escape khác. Ví dụ trong đặc tả, `\u005cu005a` thành sáu ký tự `\ u 0 0 5 a`, không thành `Z`, vì backslash vừa được tạo ra không bị đọc lại như đầu của một escape mới.

Bước hai nhận diện line terminator. JLS định nghĩa chúng để chịu được các quy ước xuống dòng khác nhau của hệ thống chủ, đồng thời giữ line number nhất quán.

Bước ba biến dòng ký tự thành input element. Sau khi bỏ white space và comment, phần còn lại là token của ngữ pháp: identifier, keyword, literal, separator và operator.

Ở mỗi bước, bản dịch dài nhất được chọn, kể cả khi kết quả không phải một chương trình đúng còn một cách cắt khác thì đúng. `a--b` thành `a`, `--`, `b`. Cách cắt `a`, `-`, `-`, `b` có thể nằm trong một chương trình đúng, nhưng lexical translation không chọn cách đó. Muốn hai dấu trừ tách nhau, phải có white space hoặc comment giữa chúng, như `a- -b`.

Có hai ngoại lệ cho quy tắc dài nhất. Bước một xử lý các ký tự `\` đứng liền nhau theo §3.3. Bước ba xử lý contextual keyword và các ký tự `>` đứng cạnh nhau theo §3.5. Trong type context, `>` luôn bị giảm thành toán tử so sánh số, kể cả khi nó có thể ghép với `>` bên cạnh thành toán tử khác. Nhờ vậy `List<List<String>>` không bị nuốt `>>` như một phép dịch bit.

Quên khoảng trắng cũng bị quy tắc này bắt. Mười hai ký tự `publicstatic` luôn là một identifier, không phải keyword `public` rồi `static`. Hai token muốn tách nhau thì phải có white space hoặc comment ở giữa.

### Keyword nào thật sự bị giữ chỗ

`true` và `false` không phải keyword. Chúng là boolean literal. `null` là null literal. Keyword `_` có thể đứng ở một số khai báo thay cho identifier.

Contextual keyword chỉ bị nhận khi đứng đúng chỗ trong ngữ pháp và không bị `JavaLetterOrDigit` dính ngay trước hoặc ngay sau. JLS §3.9 liệt kê ngữ cảnh, trong đó có `var` ở kiểu biến cục bộ hoặc kiểu tham số lambda, `yield` ở yield statement, `record` ở record declaration, `non-sealed`, `permits` và `sealed` ở khai báo class hoặc interface thường, `when` ở guard. `module`, `open`, `exports`, `opens`, `provides`, `requires`, `to`, `uses`, `with`, `transitive` gắn với khai báo module.

Mình đã từng nhớ nhầm rằng các từ này luôn dùng được như identifier ở mọi chỗ khác. Đặc tả hẹp hơn. `var` không phải `TypeIdentifier`, nên dùng `var` như tên kiểu ở ngữ cảnh khác sẽ lỗi. `yield` không phải `TypeIdentifier` và cũng không phải `UnqualifiedMethodIdentifier`. Identifier vẫn có thể trùng chính tả với một contextual keyword, vì việc cắt token phụ thuộc vị trí trong chương trình.

---

## 3. Hai họ kiểu và giá trị mà biến được giữ

JLS mở chương 4 bằng hai tính chất. Java là ngôn ngữ *statically typed*: mọi biến và mọi biểu thức có kiểu biết được lúc biên dịch. Java cũng là ngôn ngữ *strongly typed*: kiểu giới hạn giá trị mà biến giữ hoặc biểu thức tạo ra, giới hạn phép toán trên các giá trị đó, và quyết định ý nghĩa của phép toán. Kiểm tra kiểu tĩnh giúp bắt lỗi lúc biên dịch.

Có hai họ kiểu: primitive type và reference type. Tương ứng có hai họ giá trị được cất trong biến, truyền làm đối số, trả về từ method, và đem ra tính: primitive value và reference value.

Primitive type do ngôn ngữ định nghĩa sẵn và được đặt tên bằng reserved keyword. Họ số gồm các integral type `byte`, `short`, `int`, `long`, `char`, và các floating-point type `float`, `double`. `boolean` đứng riêng.

| Kiểu | Đặc tả JLS SE 25 | Khoảng giá trị mà nguồn nêu |
| --- | --- | --- |
| `byte` | 8-bit signed two's-complement | −128 đến 127 |
| `short` | 16-bit signed two's-complement | −32.768 đến 32.767 |
| `int` | 32-bit signed two's-complement | −2^31 đến 2^31−1 |
| `long` | 64-bit signed two's-complement | −2^63 đến 2^63−1 |
| `char` | 16-bit unsigned, biểu diễn UTF-16 code unit | `'\u0000'` đến `'\uffff'`, tức 0 đến 65535 |
| `float` | IEEE 754 binary32 | JLS §4.2.3 |
| `double` | IEEE 754 binary64 | JLS §4.2.3 |
| `boolean` | đúng hai giá trị `true` và `false` | không có khoảng số |

Tutorial gọi `char` là "a single 16-bit Unicode character". JLS SE 25 hẹp và khác câu đó: giá trị `char` là số nguyên không dấu 16 bit biểu diễn UTF-16 code unit. Mình dùng câu của JLS. Một code unit không phải lúc nào cũng là một code point. JLS §3.1 nói platform có method để chuyển giữa biểu diễn 16 bit và 32 bit, và một ký tự bổ sung từ U+010000 đến U+10FFFF cần hai Unicode escape liên tiếp.

Tutorial còn nói từ Java SE 8 có thể dùng `int` và `long` như số không dấu thông qua class `Integer` và `Long`, với các method như `compareUnsigned` và `divideUnsigned`. Đó là API của class bọc, không phải một primitive type mới. `int` trong JLS vẫn là số có dấu 32 bit.

`float` là IEEE 754 32 bit, `double` là 64 bit. Từ Java SE 15, ngôn ngữ dùng IEEE 754 bản 2019. Trước đó là bản 1985. Tutorial nói `double` thường là lựa chọn mặc định cho giá trị thập phân, và cả `float` lẫn `double` không nên dùng cho giá trị cần chính xác như tiền. Trang đó chỉ `java.math.BigDecimal` cho việc này. Cùng trang nói `byte` và `short` có ích khi cần tiết kiệm bộ nhớ trong mảng lớn, ở chỗ phần tiết kiệm thực sự đáng kể. `float` thay `double` cũng chỉ trong tình huống đó.

`boolean` trên tutorial biểu diễn một bit thông tin, nhưng kích thước của nó không được định nghĩa chính xác. Primitive value không chia sẻ trạng thái với primitive value khác. Chúng không phải object tạo từ một class, nên literal primitive không dùng `new`.

### Reference không phải "object nằm trong biến"

§4.3 kể bốn họ reference type: class type, interface type, type variable, và array type. Ngoài ra có null type. Null type không có tên, nên không khai báo được biến kiểu null và không cast được sang null type. Giá trị duy nhất của nó là null reference. Null reference gán hoặc cast được sang mọi reference type. Trên thực tế mình coi `null` là một literal đặc biệt của mọi reference type, đúng như câu JLS cho phép.

Một object là một class instance hoặc một array. Reference value là pointer tới các object đó, cộng với null reference không trỏ tới object nào. Mọi object, kể cả array, hỗ trợ method của class `Object`. Biến kiểu interface giữ được null hoặc reference tới instance của class nào implement interface đó. Biến kiểu `Object` giữ được null hoặc reference tới bất kỳ object nào, dù đó là class instance hay array.

`String` là một class, không phải primitive. JLS §4.3.3: một `String` object có giá trị không đổi. String literal và text block là reference tới instance của class `String`. Tutorial nói thêm: đặt chuỗi trong dấu nháy kép sẽ tạo một `String` object, và vì giá trị không đổi nên sau khi tạo thì không sửa được giá trị đó. Text block là một dạng literal riêng trong JLS §3.10.6. Mình không gắn nó với một số hiệu JDK, vì chương từ vựng của đặc tả SE 25 mô tả dạng này như một phần của ngôn ngữ, không ghi mốc phát hành ở đoạn mình đối chiếu.

Integer literal trên tutorial là kiểu `long` nếu kết thúc bằng `L` hoặc `l`, không thì là `int`. Trang khuyên dùng `L` hoa vì `l` thường dễ lẫn với số `1`. Hệ đếm mà trang liệt kê là thập phân, thập lục phân với tiền tố `0x`, và nhị phân với tiền tố `0b` từ Java SE 7. Dấu `_` được phép giữa các chữ số từ Java SE 7, và bị cấm ở đầu hoặc cuối số, sát dấu thập phân, trước hậu tố `F` hoặc `L`, và trong tiền tố như `0_x`.

### Giá trị ban đầu không áp dụng cho biến cục bộ

JLS §4.12.5: mọi biến phải có giá trị trước khi giá trị đó bị dùng. Class variable, instance variable và thành phần của array được gán default value lúc chúng được tạo:

| Kiểu | Default value |
| --- | --- |
| `byte`, `short`, `int` | `0` |
| `long` | `0L` |
| `float` | `0.0f` (positive zero) |
| `double` | `0.0d` (positive zero) |
| `char` | `'\u0000'` |
| `boolean` | `false` |
| mọi reference type | `null` |

Tutorial nói compiler không gán default value cho local variable chưa khởi tạo. Đọc một local variable chưa được gán sẽ là lỗi biên dịch. Class variable được tạo khi class hoặc interface được chuẩn bị, và hết hiệu lực khi class hoặc interface đó bị unload. Instance variable được tạo và gán default value như một phần của mỗi object mới của class đó hoặc của subclass.

Tutorial phân biệt bốn cách nói mà mình dùng hàng ngày. Instance variable là field không có `static`, giá trị riêng của từng instance. Class variable có `static`, đúng một bản sao dù class được khởi tạo bao nhiêu lần. Local variable nằm giữa cặp ngoặc của method và chỉ method đó thấy. Parameter, kể cả `args` của `main`, được tính là variable chứ không phải field. Field, method và nested type của một type được gọi chung là member.

Nếu một biến là effectively final, thêm modifier `final` vào khai báo sẽ không tạo lỗi biên dịch. Ngược lại, local variable hoặc parameter đang khai báo `final` trong một chương trình hợp lệ sẽ trở thành effectively final nếu bỏ modifier đó đi.

---

## 4. JVM giữ gì khi chương trình chạy

JVMS §2.5: một số vùng dữ liệu được tạo lúc máy ảo khởi động và chỉ mất khi máy ảo dừng. Vùng khác thuộc từng thread, tạo khi thread tạo và hủy khi thread kết thúc.

Mỗi thread có một `pc` (program counter) register riêng. Tại một thời điểm, thread đang thực thi code của một method, gọi là current method của thread đó. Nếu method này không phải `native`, `pc` chứa địa chỉ lệnh JVM đang được thực thi. Nếu method đang chạy là `native`, giá trị `pc` là undefined. `pc` đủ rộng để giữ một `returnAddress` hoặc một native pointer của nền tảng đó. Stack đó được tạo cùng thread và chứa các frame. JVMS ví nó với stack của một ngôn ngữ như C: nó giữ local variable và kết quả trung gian, và tham gia gọi cùng trả về method. Stack không bị sửa trực tiếp ngoài việc đẩy và lấy frame, nên frame có thể được cấp phát trên heap. Bộ nhớ của stack không cần liền mạch. Stack có thể cố định kích thước hoặc nở và co. Nếu tính toán của thread cần stack lớn hơn mức được phép, JVM ném `StackOverflowError`. Nếu stack nở động mà không xin thêm được bộ nhớ, hoặc không đủ bộ nhớ để tạo stack ban đầu cho thread mới, JVM ném `OutOfMemoryError`. Native method stack có cùng hai điều kiện lỗi đó.

Heap dùng chung cho mọi thread. Đây là vùng cấp phát bộ nhớ cho mọi class instance và mọi array. Heap được tạo lúc máy ảo khởi động. Bộ nhớ object được thu hồi bởi automatic storage management system, gọi là garbage collector. Object không bị giải phóng tường minh. Đặc tả không chọn một kiểu garbage collector. Heap có thể cố định hoặc nở và co, và bộ nhớ của heap không cần liền mạch. Nếu một phép tính cần nhiều heap hơn mức hệ thống quản lý bộ nhớ tự động cung cấp được, JVM ném `OutOfMemoryError`.

Method area cũng dùng chung. Nó analogous với vùng mã đã biên dịch của một ngôn ngữ thông thường, hoặc với text segment của một process. Nó giữ cấu trúc theo từng class: run-time constant pool, dữ liệu field và method, cùng mã của method và constructor, kể cả special method dùng khi khởi tạo class, interface và instance. Method area được tạo lúc khởi động. Về mặt logic nó là một phần của heap, nhưng hiện thực đơn giản có thể không garbage-collect hoặc không compact nó. Đặc tả không bắt buộc vị trí của method area. Hết bộ nhớ để đáp ứng một yêu cầu cấp phát trong method area thì JVM ném `OutOfMemoryError`.

Run-time constant pool là theo từng class hoặc từng interface, allocated từ method area. Nó giống symbol table nhưng chứa dải dữ liệu rộng hơn. Nếu việc dựng pool lúc tạo class hoặc interface cần nhiều bộ nhớ hơn method area cung cấp được, JVM ném `OutOfMemoryError`.

### Frame, local variable và operand stack

Một frame được tạo mỗi lần một method được gọi, và bị hủy khi lời gọi kết thúc, dù kết thúc bình thường hay đột ngột vì exception không được method đó xử lý. Frame lấy từ JVM stack của thread tạo ra nó. Mỗi frame có mảng local variable riêng, operand stack riêng, và một reference tới run-time constant pool của class của method hiện tại.

JVM dùng local variable để truyền parameter. Method của class truyền parameter vào các local variable liên tiếp bắt đầu từ chỉ số 0. Method của instance luôn dùng local variable 0 để truyền reference tới object mà method đang được gọi trên đó, tức `this` trong ngôn ngữ Java. Parameter theo sau, bắt đầu từ local variable 1.

Giá trị `long` hoặc `double` ở chỉ số `n` chiếm local variable `n` và `n+1`. Không load được từ `n+1`. Store vào `n+1` thì được, nhưng làm hỏng nội dung của `n`. JVM không đòi `n` chẵn.

Operand stack rỗng khi frame chứa nó được tạo. Lệnh `iadd` cộng hai giá trị `int`. Hai giá trị đó phải đang nằm trên đỉnh operand stack. Cả hai bị pop, được cộng, và tổng được push trở lại. Không được push hai `int` rồi đem xử lý như một `long`, cũng không được push hai `float` rồi cộng bằng `iadd`. Ràng buộc này được kiểm tra khi verify `class` file.

JVM kỳ vọng gần như mọi kiểm tra kiểu đã xong trước runtime, thường là do compiler, nên bản thân máy ảo không phải làm lại. Giá trị primitive không cần gắn tag để phân biệt kiểu lúc chạy. Tập lệnh phân biệt kiểu bằng lệnh chuyên cho từng kiểu. `iadd`, `ladd`, `fadd` và `dadd` đều cộng hai số, nhưng lần lượt cho `int`, `long`, `float` và `double`.

Lời gọi method kết thúc bình thường nếu không làm JVM ném exception, dù exception đến từ chính máy ảo hay từ lệnh `throw`. Khi đó một giá trị có thể được trả về cho method gọi, bằng một lệnh return phù hợp kiểu. Frame hiện tại được dùng để khôi phục local variable và operand stack của bên gọi, và program counter của bên gọi được tăng để nhảy qua lệnh gọi method. Lời gọi kết thúc đột ngột nếu một lệnh làm JVM ném exception mà method hiện tại không xử lý. `athrow` cũng ném exception tường minh. Lời gọi kết thúc đột ngột không trả giá trị về cho bên gọi.

Liên kết muộn của method và biến làm cho thay đổi ở class khác mà method đang dùng ít có khả năng làm hỏng mã này hơn.

---

## 5. Những chỗ mình hay kết luận quá tay

`StackOverflowError` trong JVMS không được định nghĩa là "đệ quy sâu". Điều kiện là tính toán của thread cần JVM stack lớn hơn mức được phép. Đệ quy chỉ là một cách để chuỗi gọi method làm stack tăng. Native method stack có một `StackOverflowError` riêng, với điều kiện tương tự trên native method stack.

`OutOfMemoryError` cũng không phải một lỗi heap duy nhất. Nguồn gắn nó với bốn tình huống khác nhau: không tạo hoặc không nở được JVM stack, không tạo hoặc không nở được native method stack, heap không được automatic storage management system đáp ứng đủ, và method area không đáp ứng được yêu cầu cấp phát, kể cả khi dựng run-time constant pool. Mình không viết thêm rằng garbage collector "đã chạy xong mà vẫn hết", vì câu của đặc tả chỉ nói hệ thống quản lý bộ nhớ tự động không cung cấp đủ.

`float` và `double` có positive zero và negative zero. `0.0==-0.0` là `true`, `0.0>-0.0` là `false`, nhưng `1.0/0.0` là positive infinity và `1.0/-0.0` là negative infinity. NaN không có thứ tự. Toán tử `==` trả về `false` nếu một trong hai vế là NaN. Toán tử `!=` trả về `true` nếu một trong hai vế là NaN. Hệ quả trong đặc tả: `x!=x` đúng khi và chỉ khi `x` là NaN. So sánh `<`, `<=`, `>`, `>=` cũng trả về `false` nếu một hoặc cả hai vế là NaN. NaN được dùng cho kết quả của một số phép không hợp lệ, như chia không cho không. Hằng số có sẵn là `Float.NaN` và `Double.NaN`.

Heap pollution là tình huống một biến của parameterized type lại trỏ tới object không phải parameterized type đó. JLS nói nó chỉ xảy ra nếu chương trình làm một thao tác có raw type mà lẽ ra phát unchecked warning lúc biên dịch, hoặc nếu chương trình alias một array có element type không reifiable thông qua một array supertype raw hoặc non-generic. Ví dụ đặc tả:

```java
List l = new ArrayList<Number>();
List<String> ls = l;  // unchecked warning
```

Nếu đoạn này chạy, `ls` được khai báo là `List<String>` nhưng không trỏ tới một `List<String>`. Lỗi không bị nhận ra lúc chạy vì type variable không được reify, nên instance không mang thông tin type argument đã dùng để tạo ra chúng. Raw type tồn tại để nói chuyện với legacy code không generic. Cái giá của migration compatibility, theo JLS, là không thể reify đầy đủ và đúng hệ thống generic, ít nhất trong lúc quá trình chuyển đó còn diễn ra. Đặc tả gọi kiểu gán ở trên là very bad style. Mình không nâng thành câu "luôn cấm raw type": đặc tả cho phép raw type như một nhượng bộ cho legacy code, và cảnh báo bằng unchecked warning.

Tutorial *Control Flow Statements* chỉ nói các lệnh trong source thường chạy từ trên xuống, và control flow statement phá dòng đó bằng decision making, looping và branching. Trang liệt kê `if-then`, `if-then-else`, `switch`, `for`, `while`, `do-while`, `break`, `continue` và `return`. Trang này là mục lục của JDK 8. Mình không suy ra cú pháp `switch` expression hay pattern matching từ nó.

---

## Kết luận

Mình giữ ba giới hạn khi đọc code Java. Token được cắt theo bản dịch dài nhất, trừ đúng các ngoại lệ về `>` trong type context và contextual keyword, nên thiếu một khoảng trắng đổi nghĩa của chương trình. Biến field và phần tử array có default value, local variable thì không. Object và array được cấp phát trên heap dùng chung và không được giải phóng bằng một lệnh của ngôn ngữ. Stack, method area và constant pool có các đường `OutOfMemoryError` riêng, còn `StackOverflowError` gắn với stack của thread chứ không gắn với heap.

Khi tutorial JDK 8 và JLS SE 25 không cùng một câu, mình lấy JLS. Chỗ rõ nhất trong bài này là `char`: đó là UTF-16 code unit 16 bit không dấu, không phải "một ký tự Unicode" theo cách trang tutorial diễn đạt.

## References

- [Chapter 3. Lexical Structure](https://docs.oracle.com/javase/specs/jls/se25/html/jls-3.html)
- [Chapter 4. Types, Values, and Variables](https://docs.oracle.com/javase/specs/jls/se25/html/jls-4.html)
- [Chapter 2. The Structure of the Java Virtual Machine](https://docs.oracle.com/javase/specs/jvms/se25/html/jvms-2.html)
- [Variables (The Java™ Tutorials)](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/variables.html)
- [Primitive Data Types (The Java™ Tutorials)](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/datatypes.html)
- [Control Flow Statements (The Java™ Tutorials)](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/flow.html)

## Series

- Next: [Lập trình hướng đối tượng (OOP) trong Java: 4 Trụ cột và Ứng dụng thực tế](../02-object-oriented-programming/index.md)
