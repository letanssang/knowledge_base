---
title: "Enterprise Integration Patterns (EIP) — Phần 2: Splitter, Aggregator & Resequencer"
description: "Phân tích kỹ thuật chuyên sâu về các mô hình phân rã, gom nhóm và sắp xếp lại thông điệp: Splitter, Aggregator và Resequencer trong Apache Camel."

date:
updated:

series: "Apache Camel"
series_order: 4

tags:
  - apache-camel
  - eip
  - aggregator
  - splitter

status: draft
language: vi
---

# Enterprise Integration Patterns (EIP) — Phần 2: Splitter, Aggregator & Resequencer

> **Tóm tắt:** Mẫu thiết kế Enterprise Integration Patterns (EIP) trong Apache Camel cung cấp bộ khung chuẩn hóa giúp kết nối và xử lý luồng dữ liệu giữa các hệ thống phân tán. Bài viết này tập trung phân tích ba mẫu xử lý dữ liệu phức tạp: Splitter (phân rã message), Aggregator (tổng hợp dữ liệu) và Resequencer (sắp xếp lại thứ tự message). Qua đó, mình trình bày chi tiết cơ chế hoạt động, các chế độ lưu trữ, luồng xử lý song song, kỹ thuật kiểm soát bộ nhớ và các rủi ro vận hành cần lưu ý.

*Thời gian đọc: ~10 phút*

---

## 1. Enterprise Integration Patterns (EIP) trong Apache Camel là gì?

Apache Camel là một framework tích hợp mã nguồn mở triển khai danh mục rộng lớn các mẫu thiết kế Enterprise Integration Patterns (EIP) dựa trên cuốn sách kinh điển của Gregor Hohpe và Bobby Woolf. Hệ thống EIP trong Camel được phân chia thành nhiều nhóm chức năng chính như Messaging Systems, Messaging Channels, Message Routing, Splitting and Aggregation, Message Transformation, Flow Control, Error Handling và System Management.

Trong bài viết này, mình đi sâu tìm hiểu nhóm Splitting and Aggregation cùng với mẫu Resequencer. Đây là những thành phần kiểm soát luồng message mang tính trạng thái (stateful) giúp xử lý các cấu trúc dữ liệu phức tạp trong kiến trúc hướng sự kiện (event-driven architecture).

---

## 2. Vì sao nhóm EIP này tồn tại và giải quyết vấn đề gì?

Trong các hệ thống phân tán, dữ liệu truyền nhận giữa các ứng dụng hiếm khi tồn tại ở dạng đơn lẻ hoặc luôn đến đúng thứ tự mong muốn:

- **Xử lý dữ liệu danh hợp (Composite Messages):** Khi một message chứa danh sách nhiều phần tử (ví dụ: tập tin XML hoặc CSV chứa hàng nghìn dòng đơn hàng), ứng dụng tiêu thụ không thể hoặc không nên xử lý toàn bộ tập tin cùng một lúc. Splitter EIP tồn tại để chia nhỏ message lớn này thành các message đơn lẻ để xử lý độc lập.
- **Tổng hợp dữ liệu phân tán:** Ngược lại, khi các tác vụ đơn lẻ hoặc các kết quả phản hồi độc lập cần được gom lại thành một kết quả hoàn chỉnh (ví dụ: gộp các mục hàng thành một hóa đơn tổng), Aggregator EIP đóng vai trò bộ lọc có trạng thái (stateful filter) để tích lũy và xuất ra message tổng hợp.
- **Khôi phục thứ tự luồng dữ liệu:** Do đặc thù truyền tải qua mạng hoặc xử lý bất đồng bộ đa luồng, các message liên quan có thể đến đích sai thứ tự (out-of-sequence). Resequencer EIP giải quyết bài toán này bằng cách thu thập và sắp xếp lại luồng message theo đúng thứ tự chuỗi trước khi đẩy tới kênh đầu ra.

---

## 3. Cơ chế hoạt động của Splitter, Aggregator và Resequencer

### 3.1. Splitter EIP: Phân rã message

Splitter tách một composite message thành các sub-exchange và gửi chúng tới các bước xử lý tiếp theo trong route.

- **Chế độ phân rã (Splitting Modes):**
  - *Default mode:* Tách toàn bộ message trong bộ nhớ, cho phép xác định tổng số sub-exchange (`CamelSplitSize`), nhưng tiêu tốn bộ nhớ nếu dữ liệu lớn.
  - *Streaming mode:* Phân rã theo yêu cầu (on-demand) bằng cách sử dụng `Iterator`, giúp giảm thiểu dung lượng RAM cho các payload lớn nhưng không thể biết trước tổng số lượng phần tử.
- **Mặc định theo kiểu dữ liệu:** Khi dùng biểu thức `body()`, Splitter tự động phân tách theo các kiểu như `Collection`, `Map`, `Object[]`, `Iterator`, `Iterable`, `NodeList`, hoặc chuỗi phân cách bằng dấu phẩy.
- **Xử lý song song và nhóm dữ liệu:** Splitter hỗ trợ `parallelProcessing` để xử lý các sub-exchange trên các thread khác nhau, và hỗ trợ thuộc tính `group` để gom \\(N\\) phần tử thành một danh sách `java.util.List` nhằm xử lý theo lô (batch/chunk).
- **Cơ chế Watermark Tracking:** Sử dụng `ResumeStrategy` SPI để ghi nhận vị trí index (`Index-based`) hoặc giá trị trích xuất từ `watermarkExpression` (`Value-based`), cho phép bỏ qua các phần tử đã xử lý trong các lần chạy sau.

### 3.2. Aggregator EIP: Gom nhóm và tổng hợp message

Aggregator sử dụng khóa tương quan (correlation key) để gom các message có cùng khóa vào chung một nhóm.

- **Thành phần cốt lõi:**
  - *Correlation Expression:* Biểu thức trích xuất khóa tương quan từ incoming exchange.
  - *AggregationStrategy:* Lớp xử lý bắt buộc quy định cách gộp `oldExchange` (dữ liệu đã tích lũy) và `newExchange` (message mới đến).
  - *AggregationRepository:* Nơi lưu trữ trạng thái tạm thời, mặc định là `MemoryAggregationRepository`, hoặc các kho lưu trữ phân tán/bền vững như SQL, Redis, LevelDB, Infinispan, Caffeine.
- **Điều kiện hoàn thành (Completion Conditions):** Nhóm được coi là hoàn thành và phát đi khi đạt một trong các điều kiện: `completionSize` (số lượng message), `completionTimeout` (thời gian không có message mới), `completionInterval` (chu kỳ cố định), `completionPredicate` (điều kiện logic), hoặc `completionFromBatchConsumer`.
- **Chế độ Pre-completion:** Khi `AggregationStrategy` ghi đè phương thức `canPreComplete` và `preComplete` trả về `true`, nhóm hiện tại sẽ lập tức hoàn thành và `newExchange` sẽ bắt đầu một nhóm mới.
- **Chỉ thị hoàn thành từ Exchange:** Lập trình viên có thể điều khiển hoàn thành bằng cách thiết lập thuộc tính Exchange như `CamelAggregationCompleteCurrentGroup` hoặc `CamelAggregationCompleteAllGroups`.

### 3.3. Resequencer EIP: Sắp xếp lại thứ tự message

Resequencer sử dụng biểu thức so sánh (Comparator Expression) trích xuất từ header hoặc body để sắp xếp luồng message.

- **Batch Resequencing (Mặc định):** Thu thập message vào một lô (mặc định tối đa 100 message hoặc timeout 1000 ms), sau đó sắp xếp toàn bộ lô và gửi ra kênh đầu ra. Hỗ trợ các cấu hình `allowDuplicates()` (cho phép giữ message trùng khóa) và `reverse()` (đảo ngược thứ tự sắp xếp).
- **Stream Resequencing:** Dựa trên thuật toán phát hiện khoảng trống (gap detection) trên chuỗi số liên tục (1, 2, 3... N) thay vì cố định kích thước lô. Resequencer giữ message trong bộ đệm (mặc định capacity là 1000) cho đến khi nhận được message kế tiếp trong chuỗi hoặc khi hết thời gian `timeout`. Có thể bật `rejectOld()` để loại bỏ và ném `MessageRejectedException` đối với các message đến muộn hơn message vừa phát đi.

---

## 4. Điều gì có thể sai? (Sự cố và rủi ro vận hành)

Khi làm việc với các EIP mang trạng thái này, nếu không nắm rõ cơ chế vận hành, hệ thống rất dễ gặp các sự cố nghiêm trọng:

- **Tràn bộ nhớ (OutOfMemoryError) và cạn tài nguyên:**
  - Trong Splitter, sử dụng *default mode* với các tệp tin khổng lồ sẽ tải toàn bộ danh sách sub-exchange vào RAM.
  - Trong Resequencer ở chế độ *stream mode*, nếu khoảng trống dữ liệu xuất hiện và `timeout` đặt quá lớn trong khi `capacity` không đủ khống chế, số lượng message đệm trong bộ nhớ sẽ tăng cao gây nguy cơ tràn bộ nhớ.
- **Lỗi tràn ngăn xếp (StackOverflowException) khi kết hợp Splitter và Aggregator:** Khi chạy Splitter dung lượng lớn ngay trước Aggregator trên cùng một thread với điều kiện hoàn thành dạng `completionSize(1)`, luồng xử lý sẽ vừa làm nhiệm vụ tách, vừa thực hiện gộp và chuyển tiếp liên tục, tạo ra thread-stack cực sâu gây ném `StackOverflowException`. Khắc phục bằng cách bật `parallelProcessing(true)` trên Aggregator hoặc Splitter để tách luồng.
- **Sai lệch kết quả do tính bất định của luồng song song:** Khi bật `parallelProcessing` kết hợp với cấu hình ngưỡng lỗi `errorThreshold` trong Splitter, tỷ lệ lỗi có thể biến động không đồng nhất giữa các lần chạy do thứ tự hoàn thành của các luồng là không định trước. Trong trường hợp này, `maxFailedRecords` (số lượng lỗi tuyệt đối) là lựa chọn an toàn hơn.
- **Mất mát dữ liệu do cấu hình hủy bỏ (Discard):** Trong Aggregator, nếu bật `discardOnCompletionTimeout` hoặc `discardOnAggregationFailure`, các message chưa tích lũy xong khi gặp timeout hoặc lỗi từ `AggregationStrategy` sẽ bị loại bỏ hoàn toàn thay vì được phát ra kênh đầu ra.

---

## 5. Áp dụng trong thực tế ra sao?

Một sơ đồ ASCII tổng quát minh họa luồng kết hợp Splitter, Resequencer và Aggregator trong thực tế:

```text
+-----------------------+
|  Composite Message    |  (Ví dụ: File XML / Batch Job)
+-----------+-----------+
            |
            v
   [ Splitter EIP ]        --> Chia nhỏ thành các sub-messages (Streaming mode)
            |
            v
  [ Dynamic Routing / Proc ]--> Xử lý bất đồng bộ / Đa luồng (có thể sai thứ tự)
            |
            v
  [ Resequencer EIP ]      --> Sắp xếp lại theo sequence number / priority
            |
            v
   [ Aggregator EIP ]      --> Gom nhóm theo correlation key & tổng hợp kết quả
            |
            v
+-----------+-----------+
|  Aggregated Message   |  (Phát đi kết quả cuối cùng)
+-----------------------+
```

Dưới đây là các tình huống áp dụng điển hình:

1. **Xử lý tệp tin XML/CSV dung lượng lớn:** Sử dụng Splitter với `tokenizeXML` hoặc `xtokenize` ở chế độ `streaming()` để đọc từng thẻ XML/dòng dữ liệu mà không nạp toàn bộ tập tin vào RAM. Kết hợp thuộc tính `group` để xử lý theo từng nhóm \\(N\\) phần tử nhằm tối ưu hóa các thao tác ghi vào cơ sở dữ liệu.
2. **Sắp xếp ưu tiên xử lý hàng chờ JMS:** Sử dụng Resequencer ở chế độ batch mode kết hợp biểu thức `header("JMSPriority")`, bật `allowDuplicates()` và `reverse()` để đảm bảo các message có độ ưu tiên cao hơn (ví dụ ưu tiên 9 so với 0) được phát ra xử lý trước.
3. **Mô hình Scatter-Gather thu thập thông tin:** Gửi yêu cầu đến nhiều dịch vụ bên ngoài, sau đó sử dụng Aggregator với `correlationExpression` dựa trên ID giao dịch và thiết lập `completionTimeout` để gom các phản hồi thành một báo cáo tổng hợp.

---

## Kết luận

Qua việc tìm hiểu và tổng hợp thông tin về ba EIP cốt lõi này trong Apache Camel, bài học lớn nhất mà mình rút ra là tư duy thiết kế luồng dữ liệu hướng trạng thái (stateful data routing) trong hệ thống phân tán:

- **Kiểm soát bộ nhớ là ưu tiên hàng đầu:** Khi xử lý dữ liệu lớn, việc lựa chọn giữa batch mode và streaming mode trên Splitter cũng như thiết lập `capacity`/`timeout` phù hợp trên Resequencer quyết định sự ổn định của JVM runtime.
- **Độc lập luồng để tránh nghẽn:** Việc bật `parallelProcessing` không chỉ tăng hiệu năng mà còn giải quyết vấn đề thread-stack quá sâu khi kết hợp các EIP lại với nhau.
- **Xử lý lỗi chủ động:** Thay vì để lỗi ngắt toàn bộ quy trình, việc sử dụng các tùy chọn kiểm soát lỗi như `maxFailedRecords`, `errorThreshold`, hoặc `shareUnitOfWork` giúp hệ thống hoạt động linh hoạt, có thể khôi phục trạng thái thông qua các cơ chế Dead Letter Channel.

---

## References

- [Aggregate :: Apache Camel](https://camel.apache.org/components/latest/eips/aggregate-eip.html)
- [EIPs :: Apache Camel](https://camel.apache.org/components/latest/eips/enterprise-integration-patterns.html)
- [Resequence :: Apache Camel](https://camel.apache.org/components/latest/eips/resequence-eip.html)
- [Split :: Apache Camel](https://camel.apache.org/components/latest/eips/split-eip.html)

## Series

- Previous: [Enterprise Integration Patterns (EIP) — Phần 1: Routing & Filtering](../03-enterprise-integration-patterns-1/index.md)
- Next: [Data Transformation & Type Conversion](../05-data-transformation/index.md)
