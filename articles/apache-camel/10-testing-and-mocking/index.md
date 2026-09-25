---
title: "Testing & Mocking in Camel"
description: "Bài viết tổng hợp trải nghiệm và kiến thức kiểm thử trong Apache Camel, tập trung vào cách cô lập route với AdviceWith, kiểm tra dữ liệu qua Mock component và các lưu ý tránh lãng phí tài nguyên khi test."
date:
updated:
series: "Apache Camel"
series_order: 10
tags:
  - apache-camel
  - testing
  - mock
  - advicewith
status: draft
language: vi
---

> **Tóm tắt:** Kiểm thử các tuyến tích hợp (route) trong Apache Camel đòi hỏi chiến lược cô lập hiệu quả khỏi các hạ tầng bên ngoài. Bằng cách kết hợp các module kiểm thử chuyên dụng, kĩ thuật phẫu thuật route linh hoạt với `AdviceWith`, và khả năng thiết lập kì vọng (assertion) mạnh mẽ từ `Mock` component, developer có thể tự động hóa việc kiểm thử từ mức unit test đến integration test một cách chính xác và tin cậy.

*Thời gian đọc: ~9 phút*

---

## 1. Đặt vấn đề: Tại sao kiểm thử trong Apache Camel lại phức tạp?

Trong phát triển ứng dụng tích hợp với Apache Camel, các route thường kết nối rất nhiều công nghệ hạ tầng khác nhau như database, message broker, cloud service hay các 3rd party API. Việc kết hợp nhiều Enterprise Integration Patterns (EIPs), ngôn ngữ biểu thức, bean injection và dependency injection khiến cho các rủi ro phát sinh trong quá trình vận hành là rất lớn.

Khi viết unit test cho một route, việc để route kết nối trực tiếp đến các hệ thống vật lý thực tế mang lại nhiều bất lợi:
- Phụ thuộc vào môi trường bên ngoài dẫn đến việc test chạy chậm và không ổn định.
- Khó giả lập các tình huống biên (edge cases) hoặc lỗi hệ thống từ các dịch vụ bên ngoài.
- Tốn chi phí tài nguyên và phức tạp trong việc dựng môi trường test cô lập.

Để giải quyết vấn đề này, Apache Camel cung cấp một bộ công cụ kiểm thử mạnh mẽ cho phép thay thế (stubbing) các transport vật lý, chỉnh sửa cấu trúc route động trước khi chạy test (`AdviceWith`), và thực hiện các câu khẳng định (assertion) trên dữ liệu đi qua route (`Mock` component).

---

## 2. Các module và chiến lược kiểm thử cốt lõi

Camel là một thư viện Java nên mình hoàn toàn có thể viết test bằng JUnit. Dự án Camel đã xây dựng sẵn các module hỗ trợ kiểm thử phù hợp cho từng mô hình kiến trúc:

| Module | Mô tả |
| ------ | ------ |
| `camel-test-junit5` | Dùng cho unit test Camel ở chế độ standalone (hoặc không dùng Spring). |
| `camel-test-main-junit5` | Dùng cho kiểm thử các ứng dụng chạy ở chế độ Camel Main. |
| `camel-test-spring-junit5` | Hỗ trợ kiểm thử tích hợp với Spring và Spring Boot. |
| `camel-test-infra` | Cung cấp các JUnit 5 extension và trừu tượng hóa hạ tầng test (dựa trên Testcontainers). |
| `camel-jbang-test` | Plugin CLI hỗ trợ viết và chạy test tự động nhanh chóng khi làm prototype với JBang. |

Bên cạnh các module môi trường, Camel phân chia các điểm cuối (endpoint) hỗ trợ test thành hai nhóm chính:

1. **Stubbing transport vật lý**: Thay vì gọi đến JMS hay HTTP thực tế, mình có thể thay bằng `Direct` (gọi đồng bộ trực tiếp trong JVM), `SEDA` (chuyển message bất đồng bộ qua BlockingQueue), hoặc `Stub` (tương tự SEDA nhưng không validate URI options, giúp giả lập nhanh).
2. **Endpoint hỗ trợ kiểm tra và đo đạc**: `Mock` (thêm assertion để kiểm tra dữ liệu), `DataSet` (sinh dữ liệu lớn để test tải/soak test), và `DataSet Test` (so sánh tự động dữ liệu đến với dữ liệu mẫu). Ngoài ra còn có `NotifyBuilder` giúp nhận thông báo khi có điều kiện thỏa mãn trong route.

---

## 3. Cô lập và phẫu thuật route với AdviceWith

`AdviceWith` là một tính năng cực kỳ mạnh mẽ cho phép "mổ xẻ" và thay đổi một route sẵn có trước khi thực thi test.

```text
+---------------------------------------------------------------+
|                      Original Route                           |
|  from("jms:queue:in") -> to("http://api") -> to("file:out")   |
+---------------------------------------------------------------+
                               |
                   [ AdviceWith Manipulation ]
                               v
+---------------------------------------------------------------+
|                      Adviced Route                            |
|  from("direct:start") -> to("mock:api")  -> to("mock:out")    |
+---------------------------------------------------------------+
```

### 3.1. Cơ chế hoạt động và cách kích hoạt

Khi áp dụng `AdviceWith`, Camel cần dừng route cũ, gỡ bỏ nó, chèn cấu trúc route mới đã sửa đổi và khởi động lại. Nếu không báo trước cho Camel, quá trình khởi động và dừng tự động sẽ diễn ra xung đột.

Do đó, mình cần tuân theo quy trình:
1. Tắt tính năng tự động khởi động route của Camel bằng cách ghi đè `isUseAdviceWith() = true` trong `CamelTestSupport` hoặc thêm annotation `@UseAdviceWith` khi dùng Spring.
2. Thực hiện chỉnh sửa route trong phương thức test.
3. Gọi `context.start()` thủ công sau khi đã áp dụng xong các thay đổi.

Ví dụ sử dụng cú pháp Lambda hiện đại:

```java
@Test
public void testMyRoute() throws Exception {
    AdviceWith.adviceWith(context, "myRoute", a -> 
        a.replaceFromWith("direct:start")
    );

    context.start();
    // Gửi message và kiểm tra kết quả
}
```

### 3.2. Thay thế Endpoint và Auto-mocking

- **Thay thế input endpoint**: Phương thức `replaceFromWith("direct:start")` giúp thay thế endpoint tiêu thụ ban đầu (như database hay message broker) bằng một `direct` endpoint, giúp gửi message vào test dễ dàng.
- **Tự động Mock endpoint**: `mockEndpoints()` hoặc `mockEndpoints("log*")` giúp tự động chèn một `Mock` endpoint vào trước các endpoint thực tế để lắng nghe dữ liệu.
- **Mock và bỏ qua endpoint gốc**: `mockEndpointsAndSkip("direct:foo")` sẽ điều hướng message đến `Mock` endpoint và bỏ qua việc gửi tin nhắn đến endpoint gốc.

### 3.3. Phẫu thuật các EIP node bằng `weave`

`AdviceWithRouteBuilder` cung cấp API `weave` để can thiệp vào chính xác các node EIP trong biểu đồ route:

- **Tiêu chí chọn node**:
  - `weaveById("id")`: Chọn node theo ID.
  - `weaveByType(SplitDefinition.class)`: Chọn node theo lớp mô hình EIP.
  - `weaveByToUri("direct:branch*")`: Chọn các node gửi đến URI khớp với pattern (hỗ trợ wildcard `*`).
- **Hành động thao tác**:
  - `.replace()`: Thay thế node được chọn bằng một nhánh route mới.
  - `.remove()`: Xóa bỏ node khỏi route.
  - `.before()` / `.after()`: Chèn thêm các bước xử lý trước hoặc sau node.
  - `.weaveAddFirst()` / `.weaveAddLast()`: Thêm bước xử lý vào ngay đầu hoặc ngay cuối route.
- **Lọc node nâng cao**: Khi có nhiều node khớp tiêu chí, mình có thể dùng `selectFirst()`, `selectLast()`, `selectIndex(index)`, `selectRange(from, to)`, hoặc `maxDeep(level)` để chỉ định chính xác vị trí cần can thiệp.

---

## 4. Xác minh dữ liệu và hành vi với Mock Component

`Mock` component (`mock:someName`) là công cụ chính để đưa ra các câu khẳng định (assertion) khai báo trong unit test. Nó chỉ hỗ trợ vai trò Producer (chỉ nhận tin nhắn gửi tới).

### 4.1. Thiết lập kì vọng (Declarative Expectations)

Mình thiết lập các điều kiện kiểm thử trên `MockEndpoint` trước khi cho luồng dữ liệu chạy qua, sau đó gọi `assertIsSatisfied()` để kiểm tra.

Một số phương thức assertion phổ biến:
- `expectedMessageCount(int)` / `expectedMinimumMessageCount(int)`: Số lượng message kì vọng.
- `expectedBodiesReceived(...)`: Kiểm tra danh sách body tin nhắn nhận được theo đúng thứ tự.
- `expectedHeaderReceived(key, value)`: Kiểm tra header của tin nhắn.
- `expectsAscending(Expression)` / `expectsDescending(Expression)`: Kiểm tra thứ tự tăng/giảm của tin nhắn dựa trên biểu thức.
- `expectsNoDuplicates(Expression)`: Khẳng định không có tin nhắn trùng lặp (dựa trên ID như JMSMessageID).

Ví dụ minh họa:

```java
MockEndpoint mock = getMockEndpoint("mock:result", MockEndpoint.class);
mock.expectedMessageCount(2);
mock.expectedBodiesReceived("Hello", "World");

// Gửi tin nhắn vào route...

mock.assertIsSatisfied();
```

### 4.2. Kiểm tra chi tiết từng Message và thời gian đến

- **Khẳng định trên từng message**: Thông qua `mock.message(index)`, mình có thể kiểm tra cụ thể header, body, dùng Regex, XPath, hoặc viết hàm Java `Function` tùy biến:
  ```java
  mock.message(0).header("code").regex("VAL-+");
  mock.message(0).header("num").expression(o -> (int) o * 2).isLessThan(10);
  ```
- **Kiểm tra thời gian đến (Arrival Time)**: Camel tự động ghi lại thời điểm tin nhắn đến vào thuộc tính Exchange `Exchange.RECEIVED_TIMESTAMP`. Từ đó cho phép thiết lập kì vọng về khoảng thời gian giữa các message:
  ```java
  // Message thứ 2 phải đến trong khoảng từ 1 đến 4 giây sau message trước
  mock.message(1).arrives().between(1, 4).seconds().afterPrevious();
  ```

---

## 5. Những rủi ro và cạm bẫy cần tránh

Trong quá trình sử dụng bộ công cụ testing của Camel, có một số điểm kỹ thuật cần lưu ý kỹ để tránh gặp lỗi nghiêm trọng:

1. **Rò rỉ bộ nhớ (Memory Leak) với Mock Endpoint**:
   - `MockEndpoint` giữ toàn bộ các đối tượng `Exchange` đã nhận trong RAM vô thời hạn để phục vụ kiểm tra.
   - Nếu test với lượng dữ liệu lớn (high volume / big data), bộ nhớ sẽ bị tràn nhanh chóng.
   - **Giải pháp**: Cấu hình `retainFirst(n)` và `retainLast(n)` trên `MockEndpoint` để chỉ giữ lại \\(n\\) tin nhắn đầu và \\(n\\) tin nhắn cuối trong bộ nhớ.
   - *Lưu ý giới hạn*: Khi dùng `retainFirst`/`retainLast`, phương thức `getReceivedCounter()` vẫn trả về đúng tổng số lượng tin nhắn thực tế, nhưng danh sách `getExchanges()` và các kiểm tra nội dung body/header chỉ hoạt động trên tập tin nhắn được giữ lại.

2. **Xung đột vòng đời khi quên bật AdviceWith**:
   - Nếu dùng `AdviceWith` mà không báo cho Camel (không trả về `true` ở `isUseAdviceWith()` hoặc thiếu `@UseAdviceWith`), Camel sẽ tự động chạy route ngay từ đầu.
   - Việc `AdviceWith` buộc phải dỡ bỏ và khởi động lại route trong lúc test đang chạy có thể gây ra hiện tượng race condition hoặc lãng phí tài nguyên.

3. **Sai lệch khớp Pattern do tham số URI**:
   - Khi thực hiện matching URI endpoint đầy đủ (như `activemq:queue:foo?option=bar`), thứ tự các query option có thể làm sai lệch kết quả so khớp pattern.
   - **Giải pháp**: Nguồn tài liệu khuyến nghị nên dùng kèm ký tự wildcard ở cuối URI pattern, ví dụ `mockEndpointsAndSkip("activemq:queue:foo?*")` để đảm bảo bỏ qua sự thay đổi của các option.

4. **Kiểm tra kì vọng số lượng 0 message**:
   - Khi đặt `expectedMessageCount(0)`, điều kiện này sẽ thỏa mãn ngay lập tức lúc test vừa bắt đầu vì chưa có message nào tới.
   - **Giải pháp**: Cần cấu hình `assertPeriod` (ví dụ `setAssertPeriod(5000)`) hoặc `sleepForEmptyTest` để yêu cầu `MockEndpoint` chờ thêm một khoảng thời gian trước khi kết luận không có message nào đến muộn.

---

## 6. Thực hành áp dụng trong dự án

Dưới đây là mô hình áp dụng thực tế kết hợp `CamelTestSupport`, `AdviceWith` và `MockEndpoint` để viết một unit test hoàn chỉnh cho một route chuyển đổi dữ liệu:

```java
public class OrderRoutingTest extends CamelTestSupport {

    @Override
    public boolean isUseAdviceWith() {
        return true; // Khai báo bắt buộc khi dùng AdviceWith
    }

    @Test
    public void testOrderProcessing() throws Exception {
        // 1. Phẫu thuật route trước khi start
        AdviceWith.adviceWith(context, "orderRoute", a -> {
            a.replaceFromWith("direct:orders-in");
            a.mockEndpointsAndSkip("kafka:processed-orders*");
        });

        // 2. Khởi động Context
        context.start();

        // 3. Thiết lập kì vọng trên Mock endpoint
        MockEndpoint mockKafka = getMockEndpoint("mock:kafka:processed-orders", MockEndpoint.class);
        mockKafka.expectedMessageCount(1);
        mockKafka.message(0).body().contains("PROCESSED");

        // 4. Gửi dữ liệu giả lập
        template.sendBody("direct:orders-in", "ORDER-1001");

        // 5. Kiểm tra kết quả
        MockEndpoint.assertIsSatisfied(context);
    }
}
```

---

## Kết luận

Qua việc đọc và tổng hợp tài liệu về Testing trong Apache Camel, bài học lớn nhất mà mình rút ra là: **Đừng bao giờ cố gắng đưa hạ tầng thực tế vào unit test của route**.

Bằng cách tư duy theo hướng "phẫu thuật" route với `AdviceWith` và đặt các "máy đo" với `MockEndpoint`, mình có thể:
- Cô lập hoàn toàn business logic và các quy tắc điều hướng (routing rules).
- Đẩy nhanh tốc độ thực thi của bộ test suite trong CI/CD.
- Giảm thiểu rò rỉ bộ nhớ nhờ việc giới hạn lượng message giữ lại với `retainFirst`/`retainLast`.

---

## References

- [AdviceWith :: Apache Camel](https://camel.apache.org/manual/advice-with.html)
- [Mock :: Apache Camel](https://camel.apache.org/components/latest/mock-component.html)
- [Testing :: Apache Camel](https://camel.apache.org/manual/testing.html)

## Series

- Previous: [Camel Runtimes: Spring Boot, Quarkus & Camel K](../09-runtimes-and-cloud-native/index.md)
- Next: [Observability & Monitoring: Metrics, Tracing & Hawtio](../11-observability-and-monitoring/index.md)
