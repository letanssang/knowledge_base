---
title: "Java Stream API: Xử lý dữ liệu tuần tự, Song song và Cơ chế Lazy Evaluation"
description: "Stream không lưu phần tử. Intermediate operation luôn lazy. Terminal operation tiêu thụ pipeline. Song song không đổi kết quả, trừ thao tác nondeterministic như findAny."

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

> **Tóm tắt:** Stream chuyển phần tử từ một nguồn qua pipeline, không phải cấu trúc dữ liệu cất phần tử. `filter` và `map` trả stream mới và không chạy cho đến terminal operation. Sau terminal operation, pipeline đã bị tiêu thụ.

*Thời gian đọc: ~9 phút*

---

## 1. Stream không phải một collection thứ hai

Package `java.util.stream` có từ Java SE 1.8. Abstraction chính là stream. `Stream`, `IntStream`, `LongStream` và `DoubleStream` là stream trên object và trên `int`, `long`, `double`.

Stream khác collection ở năm điểm tài liệu package nêu:

- Không lưu trữ. Stream không phải cấu trúc dữ liệu cất phần tử. Nó chuyển phần tử từ một nguồn, như một cấu trúc dữ liệu, một array, một hàm sinh, hoặc một kênh I/O, qua một pipeline các thao tác tính toán.
- Mang tính hàm. Thao tác trên stream tạo kết quả nhưng không sửa nguồn. Lọc một `Stream` lấy từ collection tạo stream mới không chứa phần tử bị lọc, chứ không xóa phần tử khỏi collection nguồn.
- Hướng tới lười. Nhiều thao tác, như lọc, ánh xạ, hoặc bỏ trùng, có thể hiện thực lười. Ví dụ tìm chuỗi đầu có ba nguyên âm liên tiếp thì không cần xét mọi chuỗi đầu vào. Thao tác chia thành intermediate, tức thao tác sinh stream, và terminal, tức thao tác sinh giá trị hoặc side-effect. Intermediate operation luôn lazy.
- Có thể không bị chặn. Collection có kích thước hữu hạn. Stream thì không bắt buộc. Thao tác short-circuit như `limit(n)` hoặc `findFirst()` cho phép tính trên stream vô hạn kết thúc trong thời gian hữu hạn.
- Tiêu thụ được. Phần tử của một stream chỉ được thăm một lần trong đời stream. Giống `Iterator`, muốn thăm lại thì phải tạo stream mới.

Nguồn stream gồm `Collection.stream()` và `Collection.parallelStream()`, `Arrays.stream`, factory như `Stream.of`, `IntStream.range`, `Stream.iterate`, `BufferedReader.lines()`, method trong `Files`, `Random.ints()`, và nhiều method khác trong JDK như `BitSet.stream()`, `Pattern.splitAsStream` và `JarFile.stream()`.

Tutorial lambda gọi `filter`, `map` và `forEach` là aggregate operation. Chúng xử lý phần tử từ stream, không xử lý trực tiếp từ collection. Vì vậy ví dụ trên trang bắt đầu bằng `roster.stream()`. Một pipeline trong ví dụ đó là `filter`, rồi `map`, rồi `forEach`.

---

## 2. Intermediate luôn lazy, terminal thì tiêu thụ pipeline

Một pipeline gồm một nguồn, không hoặc nhiều intermediate operation như `Stream.filter` hay `Stream.map`, và một terminal operation như `Stream.forEach` hay `Stream.reduce`.

Intermediate operation trả một stream mới. Chúng luôn *lazy*. Gọi `filter()` không lọc ngay. Nó tạo stream mới mà khi được duyệt sẽ chứa phần tử của stream ban đầu khớp predicate. Việc duyệt nguồn của pipeline không bắt đầu cho đến khi terminal operation của pipeline được thực thi.

Terminal operation, như `Stream.forEach` hoặc `IntStream.sum`, có thể duyệt stream để tạo kết quả hoặc side-effect. Sau terminal operation, pipeline được coi là đã tiêu thụ và không dùng lại được. Muốn duyệt cùng nguồn lần nữa thì phải lấy stream mới từ nguồn. Hầu hết terminal operation là *eager*: chúng duyệt nguồn và xử lý pipeline xong rồi mới trả về. Chỉ `iterator()` và `spliterator()` không eager. Hai method đó là lối thoát để client tự điều khiển việc duyệt khi các thao tác có sẵn không đủ.

Xử lý lười cho phép gộp. Trong một pipeline lọc, ánh xạ rồi cộng, filtering, mapping và summing có thể nhập thành một lần đi qua dữ liệu, với ít trạng thái trung gian. Lười cũng tránh xét hết dữ liệu khi không cần. Tìm chuỗi đầu dài hơn 1000 ký tự thì chỉ cần xét đủ chuỗi để tìm một chuỗi đạt, không cần xét mọi chuỗi của nguồn. Điều này càng quan trọng khi stream đầu vào là vô hạn, không chỉ là lớn.

Intermediate operation chia thêm thành stateless và stateful. `filter` và `map` là stateless: không giữ trạng thái từ phần tử đã thấy khi xử lý phần tử mới. Mỗi phần tử xử lý độc lập với thao tác trên phần tử khác. `distinct` và `sorted` là stateful: có thể mang trạng thái từ phần tử đã thấy. Stateful có thể phải xử lý toàn bộ đầu vào trước khi có kết quả. Sắp xếp thì không tạo được kết quả nào cho đến khi đã thấy mọi phần tử. Dưới tính toán song song, một số pipeline có intermediate stateful có thể cần nhiều lần đi qua dữ liệu hoặc phải đệm một lượng dữ liệu đáng kể. Pipeline chỉ gồm intermediate stateless xử lý được trong một lần đi, dù tuần tự hay song song, với ít đệm.

Một intermediate operation là short-circuiting nếu với đầu vào vô hạn nó có thể tạo ra một stream hữu hạn. Một terminal operation là short-circuiting nếu với đầu vào vô hạn nó có thể kết thúc trong thời gian hữu hạn. Có một thao tác short-circuiting trong pipeline là điều kiện cần, nhưng không đủ, để xử lý một stream vô hạn kết thúc bình thường trong thời gian hữu hạn.

---

## 3. Song song không phải một cờ gắn vào từng thao tác

Vòng `for` tường minh vốn là tuần tự. Stream tạo điều kiện chạy song song bằng cách đặt lại phép tính thành pipeline các aggregate operation, thay vì lệnh trên từng phần tử. Mọi thao tác stream chạy được tuần tự hoặc song song. Implementation stream trong JDK tạo stream tuần tự trừ khi song song được yêu cầu rõ. `Collection.stream()` cho stream tuần tự. `Collection.parallelStream()` cho stream song song. `IntStream.range` tạo stream tuần tự, rồi `BaseStream.parallel()` song song hóa nó.

Chế độ tuần tự hay song song của stream lúc terminal operation được gọi sẽ quyết định cả pipeline chạy thế nào. `BaseStream.isParallel()` cho biết chế độ. `sequential()` và `parallel()` đổi chế độ. Lần đặt chế độ tuần tự hoặc song song gần nhất áp dụng cho việc thực thi toàn bộ pipeline.

Trừ thao tác được nêu là nondeterministic một cách tường minh, như `findAny()`, việc stream chạy tuần tự hay song song không nên đổi kết quả của phép tính.

---

## 4. Tham số hành vi, side-effect, và `ArrayList`

Hầu hết thao tác stream nhận tham số mô tả hành vi do người dùng chỉ định, thường là lambda. Để giữ hành vi đúng, các *behavioral parameter* này phải *non-interfering*, và trong hầu hết trường hợp phải *stateless*. Chúng luôn là instance của một functional interface, như `Function`, và thường là lambda hoặc method reference.

Stream cho phép aggregate operation có thể song song trên nhiều nguồn, kể cả collection không an toàn đa luồng như `ArrayList`. Tài liệu nói điều đó chỉ có thể nếu ngăn được interference.

Một lambda stateful là lambda có kết quả phụ thuộc trạng thái có thể đổi trong lúc pipeline chạy. Ví dụ trên trang:

```java
Set<Integer> seen = Collections.synchronizedSet(new HashSet<>());
stream.parallel().map(e -> { if (seen.add(e)) return 0; else return e; })
```

Nếu `map` chạy song song, kết quả của cùng một đầu vào có thể khác nhau giữa các lần chạy vì lịch thread. Lambda stateless thì kết quả luôn giống nhau. Truy cập trạng thái mutable từ behavioral parameter là một lựa chọn xấu: không synchronized thì có data race và code hỏng. Có synchronized thì tranh chấp làm hỏng phần lợi của song song. Hướng trang nêu là tránh hẳn behavioral parameter có trạng thái.

Side-effect trong behavioral parameter nói chung bị khuyến cáo không dùng. Chúng dễ phá yêu cầu stateless và tạo nguy cơ an toàn luồng khác. Nếu vẫn có side-effect, trừ khi được nêu rõ, không có đảm bảo về:

- visibility của side-effect đó với thread khác
- các thao tác khác nhau trên "cùng" một phần tử trong cùng pipeline có chạy trên cùng một thread hay không
- behavioral parameter có luôn được gọi hay không, vì implementation được phép bỏ một thao tác hoặc cả một stage nếu chứng minh được việc đó không đổi kết quả

Thứ tự side-effect có thể bất ngờ. `IntStream.range(0, 5).parallel().map(x -> x * 2).toArray()` phải ra `[0, 2, 4, 6, 8]`, tức kết quả khớp encounter order. Không có đảm bảo về thứ tự hàm map được áp vào từng phần tử, cũng không có đảm bảo thread nào chạy behavioral parameter của một phần tử.

Trừ terminal operation `forEach` và `forEachOrdered`, side-effect của behavioral parameter có thể không được thực thi khi implementation tối ưu bỏ chúng mà không đổi kết quả. Trang chỉ API note của `count` như một ví dụ cụ thể. `println` để gỡ lỗi thường vô hại. `forEach()` và `peek()` chỉ hoạt động nhờ side-effect, nên dùng cẩn thận.

Đẩy phần tử vào một `ArrayList` bằng `forEach` là side-effect không cần thiết. Chạy song song thì `ArrayList` không an toàn đa luồng sẽ cho kết quả sai. Thêm synchronized thì gây tranh chấp. Trang thay bằng `toList()`:

```java
List<String> results =
    stream.filter(s -> pattern.matcher(s).matches())
          .toList();
```

`reduce` được trang ưu tiên hơn tích lũy bằng cách sửa một cấu trúc. Một reduce dựng đúng thì song song hóa được, miễn các hàm xử lý phần tử là associative và stateless. Ví dụ `numbers.stream().reduce(0, (x, y) -> x + y)`.

---

## Kết luận

Mình không coi một chuỗi `filter` và `map` là đã chạy. Chúng tạo stream mới. Nguồn chỉ bị duyệt khi có terminal operation. Gọi terminal operation lần hai trên cùng pipeline thì không được. Phải lấy stream mới từ nguồn.

Song song mình bật ở nguồn, bằng `parallelStream()` hoặc `parallel()`, không phải bằng cách đổi từng `filter`. Kết quả không nên đổi chỉ vì chế độ song song, trừ thao tác như `findAny()`. Lambda đưa vào stream thì không sửa nguồn và không giữ trạng thái đổi trong lúc pipeline chạy. Gom kết quả thì mình dùng `toList` hoặc `reduce`, không `forEach` vào một `ArrayList`.

## References

- [java.util.stream (Java SE 25)](https://docs.oracle.com/en/java/javase/25/docs/api/java.base/java/util/stream/package-summary.html)
- [Lambda Expressions](https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html)

## Series

- Previous: [Lambda Expressions và Functional Interfaces trong Java 8+](../07-lambda-and-functional-interfaces/index.md)
