---
title: "Java Stream API: Xử lý dữ liệu tuần tự, Song song và Cơ chế Lazy Evaluation"
description: "filter và map chưa chạy khi mình gọi chúng. Pipeline chỉ chạy lúc có terminal operation, rồi không dùng lại được. Song song không được đổi kết quả, trừ thao tác như findAny."

date:
updated:

series: "Java Core"
series_order: 8

tags:
  - java
  - stream-api
  - functional-programming
  - collections

status: draft
language: vi
---

# Java Stream API: Xử lý dữ liệu tuần tự, Song song và Cơ chế Lazy Evaluation

> **Tóm tắt:** Stream không cất phần tử. Nó kéo phần tử từ một nguồn qua các bước. `filter` và `map` chỉ tạo bước mới. Nguồn bắt đầu được đọc khi có `forEach`, `reduce`, `sum` hoặc một terminal operation khác. Xong một lần thì pipeline hết dùng.

*Thời gian đọc: ~9 phút*

---

## 1. Danh sách vẫn nằm yên khi mình mới viết filter

`roster.stream().filter(...).map(...).forEach(...)` trông như ba việc chạy ngay. `filter` và `map` chưa đụng tới người nào trong roster. Chúng trả một stream mới. `forEach` mới làm pipeline chạy.

Stream khác collection ở năm điểm. Nó không phải chỗ cất dữ liệu. Nó chuyển phần tử từ một nguồn, như collection, array, hàm sinh, hoặc kênh đọc, qua các bước tính. Lọc một stream lấy từ collection tạo stream mới thiếu các phần tử bị loại. Collection gốc không mất phần tử. Nhiều bước có thể làm lười: tìm chuỗi đầu tiên có ba nguyên âm liên tiếp thì không cần đọc hết nguồn. Stream không bắt buộc hữu hạn. `limit(n)` hoặc `findFirst()` cho phép một nguồn vô hạn dừng trong thời gian hữu hạn. Mỗi phần tử chỉ được thăm một lần. Muốn đi lại thì lấy stream mới từ nguồn, giống phải tạo `Iterator` mới.

Package `java.util.stream` có từ Java SE 8. `Stream` là stream object. `IntStream`, `LongStream` và `DoubleStream` là stream số primitive, đỡ phải đóng hộp từng số. Nguồn thường gặp là `collection.stream()`, `collection.parallelStream()`, `Arrays.stream`, `Stream.of`, `IntStream.range`, `Stream.iterate`, `BufferedReader.lines()`, và các method đọc file hoặc số ngẫu nhiên.

---

## 2. Lazy đến khi có bước cuối

Một pipeline là nguồn, rồi không hoặc nhiều bước intermediate như `filter` và `map`, rồi một bước terminal như `forEach` hoặc `reduce`.

Gọi `filter` không lọc. Nó tạo stream mà lúc được duyệt sẽ chỉ còn phần tử khớp predicate. Không có bước terminal thì nguồn chưa được đọc.

Bước terminal duyệt nguồn để ra một giá trị hoặc một side-effect. Sau đó pipeline đã bị tiêu thụ. Gọi thêm một terminal operation trên cùng stream là dùng lại thứ đã xong. Hầu hết bước terminal chạy cho xong rồi mới trả về. `iterator()` và `spliterator()` không vậy. Chúng để mình tự kéo pipeline khi các bước có sẵn không đủ.

Vì chưa chạy sớm, lọc, đổi dạng và cộng dồn có thể nhập thành một lần đi qua dữ liệu. Tìm chuỗi dài hơn 1000 ký tự thì chỉ đọc đến khi thấy một chuỗi, không đọc hết. Nguồn vô hạn thì điều này quyết định pipeline có dừng hay không.

`filter` và `map` không nhớ phần tử trước. Mỗi phần tử xử lý riêng. `distinct` và `sorted` thì nhớ. Sắp xếp không đưa ra được phần tử nào cho đến khi đã thấy tất cả. Bước có nhớ, khi chạy song song, có thể phải đi qua dữ liệu nhiều lần hoặc phải giữ một lượng lớn trong bộ đệm. Pipeline toàn bước không nhớ thì một lần đi là đủ, tuần tự hay song song.

Một bước intermediate short-circuit là bước có thể biến nguồn vô hạn thành stream hữu hạn. Một bước terminal short-circuit là bước có thể dừng trong thời gian hữu hạn dù nguồn vô hạn. Có một bước như vậy là điều kiện cần để pipeline vô hạn dừng bình thường. Chưa đủ để chắc nó sẽ dừng.

---

## 3. Song song là chế độ của cả pipeline

Vòng `for` viết tay chạy từng phần tử một. Stream đổi cách nghĩ: cả nhóm phần tử đi qua các bước, nên cùng các bước đó chạy tuần tự hoặc song song được. JDK tạo stream tuần tự, trừ khi mình xin song song. `stream()` là tuần tự. `parallelStream()` là song song. `IntStream.range(...).parallel()` cũng vậy.

Chế độ tính tại lúc bước terminal được gọi, và lần đặt `sequential()` hoặc `parallel()` gần nhất áp cho cả pipeline. `isParallel()` cho biết đang ở chế độ nào.

Kết quả không được đổi chỉ vì mình bật song song. Ngoại lệ là bước được ghi là nondeterministic, như `findAny()`.

---

## 4. Đừng nhét kết quả vào ArrayList bằng forEach

Lambda đưa vào `map` hoặc `filter` phải không đụng nguồn của stream trong lúc pipeline chạy, và trong hầu hết trường hợp không được phụ thuộc trạng thái đang đổi. Stream song song chạy được cả trên `ArrayList`, vốn không an toàn đa luồng, chỉ khi lambda không phá nguồn.

Lambda này phụ thuộc trạng thái:

```java
Set<Integer> seen = Collections.synchronizedSet(new HashSet<>());
stream.parallel().map(e -> {
    if (seen.add(e)) return 0;
    else return e;
});
```

Cùng một đầu vào, hai lần chạy song song có thể ra khác nhau vì lịch thread. Lambda không đụng `seen` thì cùng đầu vào ra cùng kết quả. Khóa `seen` thì hết data race nhưng các thread chờ nhau, phần lợi của song song mất. Cách ổn là viết lại pipeline để không cần trạng thái đó.

Side-effect trong lambda còn dễ làm kết quả biến mất. Trừ khi method nói rõ, không có gì đảm bảo side-effect được thread khác nhìn thấy, rằng các bước trên cùng một phần tử chạy cùng một thread, hay rằng lambda được gọi. Implementation được bỏ một bước nếu chứng minh được kết quả không đổi. `count` là một chỗ việc bỏ đó xảy ra.

`IntStream.range(0, 5).parallel().map(x -> x * 2).toArray()` phải ra `[0, 2, 4, 6, 8]`. Đó là kết quả đúng thứ tự gặp của nguồn. Thứ tự gọi `map` trên từng số, và thread nào gọi, thì không được đảm bảo.

`forEach` và `forEachOrdered` là hai terminal operation mà side-effect được thực thi. Các bước khác có thể bị bỏ qua phần side-effect. `println` để xem dữ liệu thường vô hại. `peek` chỉ tồn tại nhờ side-effect, nên mình dùng khi thực sự cần nhìn giữa pipeline.

Gom chuỗi khớp regex vào một `ArrayList` bằng `forEach` là side-effect không cần. Chạy song song thì `ArrayList` cho kết quả sai. Thêm khóa thì các thread nghẽn. Đổi thành `toList()`:

```java
List<String> results = stream
    .filter(s -> pattern.matcher(s).matches())
    .toList();
```

Cộng một stream số cũng vậy. `reduce(0, (x, y) -> x + y)` cộng trên cả stream. Hàm đưa vào `reduce` cần kết hợp được và không giữ trạng thái thì phép cộng này song song hóa được. Tích lũy bằng cách sửa một biến bên ngoài thì không.

---

## Kết luận

Mình đọc một pipeline từ bước cuối ngược lên. Không có `forEach`, `reduce`, `count`, `toList` hoặc một terminal operation khác thì các `filter` và `map` phía trước chưa chạy. Chạy xong thì stream đó hết. Lần nữa thì `stream()` lại từ nguồn.

Bật song song ở nguồn, bằng `parallelStream()` hoặc `parallel()`, rồi giữ lambda không sửa nguồn và không nhớ trạng thái đổi giữa chừng. Gom kết quả bằng `toList` hoặc `reduce`. `forEach` vào một `ArrayList` vừa thừa vừa sai khi pipeline song song.

## References

- [java.util.stream (Java SE 25)](https://docs.oracle.com/en/java/javase/25/docs/api/java.base/java/util/stream/package-summary.html)
- [Lambda Expressions](https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html)

## Series

- Previous: [Lambda Expressions và Functional Interfaces trong Java 8+](../07-lambda-and-functional-interfaces/index.md)
