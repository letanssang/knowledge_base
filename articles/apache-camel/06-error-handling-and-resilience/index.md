---
title: "Error Handling & Resilience: Retry, Dead Letter Channel và Circuit Breaker"
description: "Tổng hợp các cơ chế xử lý lỗi trong Apache Camel: Error Handler, Dead Letter Channel, Exception Clause (onException), doTry/doCatch và mô hình ngắt mạch Circuit Breaker."

date:
updated:

series: "Apache Camel"
series_order: 6

tags:
  - apache-camel
  - error-handling
  - dead-letter-channel
  - resilience4j

status: draft
language: vi
---

# Error Handling & Resilience: Retry, Dead Letter Channel và Circuit Breaker

> **Tóm tắt:** Xử lý lỗi trong Apache Camel là một hệ thống đa tầng linh hoạt, kết hợp giữa Error Handler cấp route/context, chiến lược chuyển tiếp tin nhắn lỗi Dead Letter Channel, cơ chế bắt ngoại lệ chi tiết Exception Clause, các khối doTry/doCatch thủ công và mô hình ngắt mạch Circuit Breaker để xây dựng các tích hợp hệ thống bền bỉ.

*Thời gian đọc: ~8 phút*

---

## 1. Kiến trúc xử lý lỗi tổng quan trong Apache Camel

Trong các hệ thống phân tán, các sự cố như ngắt kết nối mạng, dịch vụ phía sau quá tải hay dữ liệu không hợp lệ là điều khó tránh khỏi. Apache Camel quản lý các lỗi phát sinh trong quá trình truyền dẫn tin nhắn (`Exchange`) giữa các `Endpoint` thông qua các chiến lược `ErrorHandler` có thể cắm (`pluggable`).

Cơ chế xử lý lỗi trong Camel được chia làm hai phạm vi chính (`Scopes`):
- **Phạm vi toàn cục (CamelContext / RouteBuilder):** Áp dụng chung cho toàn bộ các route được định nghĩa trong cùng một `CamelContext` hoặc `RouteBuilder`.
- **Phạm vi riêng lẻ (Route):** Cấu hình trực tiếp trên từng route cụ thể để ghi đè cấu hình toàn cục.

Camel hỗ trợ các loại Error Handler cho hai nhóm tuyến đường chính:
1. **Phi giao dịch (Non-transacted):** Bao gồm `DefaultErrorHandler`, `Dead Letter Channel`, và `NoErrorHandler`.
2. **Giao dịch (Transacted):** Sử dụng `TransactionErrorHandler` tự động cho các route được đánh dấu giao dịch.

```text
+-----------------------------------------------------------------------+
|                            CamelContext                               |
|                                                                       |
|  +-----------------------------------------------------------------+  |
|  |                 Global Error Handler / onException              |  |
|  +-----------------------------------------------------------------+  |
|                                                                       |
|  +--------------------------+     +--------------------------------+  |
|  | Route 1 (Kế thừa Global) |     | Route 2 (Route-level Handler)  |  |
|  |  from(...)               |     |  from(...)                     |  |
|  |  .to(...)                |     |  .errorHandler(...)            |  |
|  +--------------------------+     +--------------------------------+  |
+-----------------------------------------------------------------------+
```

---

## 2. DefaultErrorHandler và Dead Letter Channel

### DefaultErrorHandler
`DefaultErrorHandler` là trình xử lý lỗi mặc định của Camel. Điểm đặc trưng của `DefaultErrorHandler` là không tích hợp hàng đợi tin nhắn chết (`dead letter queue`), mặc định không thực hiện thử lại (`no redelivery`), và không đánh dấu ngoại lệ là đã xử lý. Khi gặp sự cố, ngoại lệ sẽ được truyền ngược trực tiếp về phía người gọi (`caller`) và dừng route ngay lập tức.

### Dead Letter Channel
`Dead Letter Channel` thực thi mô hình Enterprise Integration Pattern (EIP) cùng tên. Khác với `DefaultErrorHandler`, khi tin nhắn xử lý thất bại sau tất cả các đợt thử lại, nó sẽ được di chuyển đến một `Endpoint` chuyên biệt gọi là `dead letter queue` (ví dụ: JMS queue, file, hoặc log).

Một số tính năng chính của Dead Letter Channel:
- **Tự động xóa ngoại lệ:** Sau khi chuyển tin nhắn vào hàng đợi chết thành công, lỗi gốc sẽ được chuyển sang thuộc tính `Exchange.EXCEPTION_CAUGHT` và xóa khỏi `Exchange`, giúp phía người gọi không nhận thấy sự cố.
- **Chính sách thử lại (Redelivery Policy):** Cho phép cấu hình số lần thử lại tối đa (`maximumRedeliveries`), thời gian chờ (`redeliveryDelay`), tăng theo cấp số nhân (`exponential backoff`), hoặc mẫu khoảng dừng (`delayPattern` như `5:1000;10:5000;20:20000`).
- **Giữ nguyên tin nhắn gốc (`useOriginalMessage`):** Đảm bảo tin nhắn chuyển tới hàng đợi chết là dữ liệu ban đầu trước khi bị biến đổi qua các `Processor` hoặc `Bean` trong route.

```java
// Khai báo Dead Letter Channel trong Java DSL
errorHandler(deadLetterChannel("jms:queue:dead")
    .useOriginalMessage()
    .maximumRedeliveries(3)
    .redeliveryDelay(2000));
```

Các điểm can thiệp bằng `Processor` trong Dead Letter Channel:
- `onRedelivery`: Thực thi ngay trước mỗi lần thử lại tin nhắn.
- `onPrepareFailure`: Thực thi ngay trước khi gửi tin nhắn vào hàng đợi chết để bổ sung header hoặc thông tin ghi vết.
- `onExceptionOccurred`: Thực thi ngay khi ngoại lệ vừa bắn ra để tiến hành ghi log tức thì.

---

## 3. Khai báo quy tắc ngoại lệ với Exception Clause

Trong Java DSL, phương thức `onException()` được sử dụng để thiết lập các quy tắc xử lý lỗi chi tiết cho từng loại loại ngoại lệ cụ thể.

```java
onException(ValidationException.class)
    .handled(true)
    .transform(constant("INVALID ORDER"))
    .to("activemq:validationFailed");
```

### Thuật toán chọn lựa quy tắc (`DefaultExceptionPolicyStrategy`)
Khi ngoại lệ xảy ra, Camel sử dụng `DefaultExceptionPolicyStrategy` để xác định khối `onException` phù hợp theo các nguyên tắc:
1. Thử nghiệm theo thứ tự định nghĩa từ trên xuống dưới.
2. Duyệt từ ngoại lệ nguyên nhân sâu nhất (`nested caused by`) ngược lên cây phân cấp.
3. Kiểm tra tính tương thích `instanceof`: Ưu tiên khớp chính xác loại ngoại lệ (`exact match`); nếu không có, Camel chọn lớp cha gần nhất (`closest superclass`).

### Luồng xử lý dữ liệu: `handled` và `continued`
- `handled(true)`: Đánh dấu ngoại lệ đã được giải quyết, xóa lỗi khỏi `Exchange`, ngắt luồng xử lý chính của route và trả về phản hồi đã được biến đổi cho phía gọi.
- `continued(true)`: Bỏ qua ngoại lệ và tiếp tục thực thi các bước kế tiếp trong route.

---

## 4. Bắt lỗi thủ công dạng khối với doTry, doCatch và doFinally

Camel cung cấp cơ chế xử lý lỗi dạng khối tương tự `try-catch-finally` trong Java thông qua các từ khóa DSL: `doTry()`, `doCatch()`, `doFinally()`, và kết thúc bằng `end()` hoặc `endDoTry()`.

```java
from("direct:start")
    .doTry()
        .process(new OrderProcessor())
        .to("mock:result")
    .doCatch(IOException.class)
        .onWhen(exceptionMessage().contains("Connection reset"))
        .to("mock:networkError")
    .doFinally()
        .to("mock:cleanUp")
    .end();
```

### Đặc điểm quan trọng của `doTry`
- **Vô hiệu hóa Error Handler tiêu chuẩn:** Khi tin nhắn được xử lý bên trong khối `doTry`, Error Handler tiêu chuẩn của route và các khai báo `onException` sẽ không được kích hoạt. Khối `doTry` đóng vai trò là một trình xử lý lỗi độc lập.
- **Điều kiện bổ sung (`onWhen`):** Cho phép kết hợp `Predicate` với `doCatch` để chỉ bắt các ngoại lệ thỏa mãn điều kiện thời gian chạy.
- **Bẫy lồng khối trong Java DSL:** Do ngôn ngữ Java không nhận biết thụt lề, khi lồng nhiều khối `doTry`, bắt buộc phải sử dụng `endDoTry()` để đóng chính xác phạm vi của khối `doCatch` bên trong, tránh việc `doCatch` bị gộp sai vào khối bên ngoài.

---

## 5. Cắt tải và bảo vệ dịch vụ với Circuit Breaker

Pattern `Circuit Breaker` giúp ngăn chặn sự cố dây chuyền bằng cách theo dõi các lỗi gọi dịch vụ và chủ động ngắt mạch (fail-fast) khi dịch vụ phía sau gặp sự cố.

### Ba trạng thái hoạt động
1. **Closed (Đóng):** Hệ thống hoạt động bình thường, các yêu cầu được chuyển tới dịch vụ đích.
2. **Open (Mở):** Khi tỷ lệ lỗi vượt ngưỡng, mạch mở ra để từ chối ngay lập tức các yêu cầu tiếp theo mà không gọi dịch vụ đích, tránh làm quá tải hệ thống.
3. **Half-Open (Nửa mở):** Sau một khoảng thời gian chờ ở trạng thái Open, mạch cho phép một số lượng giới hạn yêu cầu đi qua để kiểm tra xem dịch vụ đã khôi phục chưa.

```text
    +---------------------------------------------------+
    |                                                   |
    v                                                   |
+---------+  Lỗi vượt ngưỡng   +------+  Hết thời gian  |  Thất bại
| CLOSED  | -----------------> | OPEN | ---------------> |
+---------+                    +------+                 |
    ^                             |                     |
    |                             v                     |
    |  Thành công          +-----------+                |
    +--------------------- | HALF-OPEN | ---------------+
                           +-----------+
```

### Triển khai trong Camel
Camel hỗ trợ hai thư viện ngắt mạch chính là `Resilience4j` và `MicroProfile Fault Tolerance`. Ngoài ra, từ khóa `onFallback()` định nghĩa luồng xử lý dự phòng khi mạch mở hoặc bị hết thời gian chờ (`timeout`).

```java
from("direct:start")
    .circuitBreaker()
        .to("http://fooservice.com/slow")
    .onFallback()
        .transform().constant("Dịch vụ tạm thời không khả dụng")
    .end()
    .to("mock:result");
```

Khi route bị dừng và khởi động lại (`stop/start`), trạng thái của Circuit Breaker sẽ được đặt lại về `CLOSED` và các chỉ số thống kê bị xóa.

---

## 6. Những bẫy kỹ thuật và kinh nghiệm thực tế

### 1. Thử lại toàn bộ route thay vì thử lại tại điểm lỗi
Mặc định, Camel thực hiện thử lại tin nhắn ngay tại vị trí `Processor` hoặc `Endpoint` bị lỗi. Để thử lại toàn bộ route từ đầu, cần tách route thành các sub-route và tắt Error Handler ở sub-route bằng `noErrorHandler()`.

```java
onException(IOException.class)
    .maximumRedeliveries(2);

from("direct:start")
    .to("direct:sub");

from("direct:sub")
    .errorHandler(noErrorHandler())
    .to("http://external-service")
    .process(new DataProcessor());
```

### 2. Kiểm soát redelivery khi dừng ứng dụng
Tùy chọn `allowRedeliveryWhileStopping` (mặc định `true`) quy định việc có cho phép tiếp tục thử lại tin nhắn khi ứng dụng đang trong quá trình dừng (`shutdown`) hay không. Nếu đặt là `false`, các đợt thử lại mới sẽ ném `RejectedExecutionException`.

### 3. Xử lý sự cố khi gửi vào Dead Letter Queue
Nếu quá trình gửi tin nhắn tới `dead letter queue` gặp lỗi, mặc định Camel sẽ ghi log ở mức `WARN` và dừng xử lý tin nhắn. Nếu muốn ngoại lệ mới này lan truyền ngược lại khiến quá trình thất bại hoàn toàn, cần thiết lập `deadLetterHandleNewException=false`.

### 4. Truy vết thông tin lỗi trên Exchange
Camel cung cấp các thuộc tính gán trên `Exchange` khi xảy ra lỗi để hỗ trợ ghi vết:
- `Exchange.FAILURE_ENDPOINT` (`CamelFailureEndpoint`): URI của Endpoint cuối cùng gặp lỗi.
- `Exchange.FAILURE_ROUTE_ID` (`CamelFailureRouteId`): ID của route xảy ra sự cố.
- `Exchange.FAILURE_NODE_ID` (`CamelFailureNodeId`): ID của nút EIP xảy ra lỗi.

---

## Kết luận

Xử lý lỗi trong Apache Camel không chỉ đơn thuần là bắt ngoại lệ mà là sự kết hợp của nhiều chiến lược tùy theo bản chất của sự cố:

- Dùng **DefaultErrorHandler** cho các luồng xử lý đồng bộ đơn giản khi muốn đẩy trực tiếp lỗi về phía người gọi.
- Dùng **Dead Letter Channel** và **Redelivery Policy** cho các sự cố mang tính tạm thời (transient errors) và cần lưu trữ tin nhắn hỏng để xử lý sau.
- Dùng **Exception Clause (`onException`)** để phân loại và điều hướng linh hoạt theo từng nhóm ngoại lệ cụ thể.
- Dùng **doTry / doCatch** khi cần khoanh vùng và xử lý lỗi thủ công cục bộ mà không muốn kích hoạt Error Handler tiêu chuẩn.
- Dùng **Circuit Breaker** để chủ động cắt tải và bảo vệ hệ thống trước các dịch vụ tích hợp bên ngoài bị chậm hoặc sụp đổ.

---

## References

- [Circuit Breaker :: Apache Camel](https://camel.apache.org/components/latest/eips/circuitBreaker-eip.html)
- [Dead Letter Channel :: Apache Camel](https://camel.apache.org/components/latest/eips/dead-letter-channel.html)
- [DefaultErrorHandler :: Apache Camel](https://camel.apache.org/manual/defaulterrorhandler.html)
- [Error Handler :: Apache Camel](https://camel.apache.org/manual/error-handler.html)
- [Exception Clause :: Apache Camel](https://camel.apache.org/manual/exception-clause.html)
- [Try, Catch and Finally :: Apache Camel](https://camel.apache.org/manual/try-catch-finally.html)

## Series

- Previous: [Data Transformation & Type Conversion: Jackson, JAXB và Simple Language](../05-data-transformation/index.md)
- Next: [Idempotent Consumer & Quản lý Transaction trong Messaging](../07-idempotency-and-transactions/index.md)
