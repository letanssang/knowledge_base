---
title: "Enterprise Integration Patterns (EIP) — Phần 1: Routing & Filtering"
description: "Phân tích kỹ thuật chuyên sâu về các mô hình định tuyến thông điệp (Message Routing EIPs) cốt lõi trong Apache Camel: Choice, Filter, Multicast, Recipient List, Dynamic Router và Wire Tap."

date:
updated:

series: "Apache Camel"
series_order: 3

tags:
  - apache-camel
  - eip
  - message-routing
  - integration

status: draft
language: vi
---

# Enterprise Integration Patterns (EIP) — Phần 1: Routing & Filtering

> **Tóm tắt:** Bài viết là ghi chép cá nhân tổng hợp các mô hình định tuyến thông điệp (Message Routing EIPs) cốt lõi trong Apache Camel dựa trên tài liệu chính thức. Nội dung đi sâu phân tích cơ chế hoạt động, sự khác biệt kiến trúc và các cạm bẫy thực tế (như scope trong Java DSL, thread safety, shallow copy vs deep copy) của 6 mẫu định tuyến phổ biến: Choice, Filter, Multicast, Recipient List, Dynamic Router và Wire Tap.

*Thời gian đọc: ~10 phút*

---

## 1. Khái niệm và vị trí của Message Routing EIPs

Trong các hệ thống phân tán và tích hợp ứng dụng, việc kết nối các dịch vụ độc lập mà không làm tăng độ gắn kết (coupling) là một thách thức lớn. Apache Camel giải quyết bài toán này bằng cách hiện thực hóa các mô hình tích hợp doanh nghiệp (Enterprise Integration Patterns - EIP) từ cuốn sách kinh điển của Gregor Hohpe và Bobby Woolf.

Trong số các nhóm EIP, nhóm **Message Routing** đóng vai trò là "bộ điều hướng" luồng dữ liệu. Nhiệm vụ chính của nhóm này là tách biệt các bước xử lý riêng lẻ, tiếp nhận thông điệp từ kênh đầu vào và quyết định chuyển tiếp thông điệp đó đến đâu dựa trên điều kiện, cấu hình hoặc trạng thái runtime. 

Qua việc nghiên cứu tài liệu hệ thống, mình nhận thấy 6 EIP điều hướng cốt lõi được sử dụng nhiều nhất gồm có:
* **Choice EIP (Content-Based Router):** Định tuyến rẽ nhánh theo nội dung thông điệp.
* **Filter EIP (Message Filter):** Lọc bỏ các thông điệp không thỏa mãn điều kiện.
* **Multicast EIP:** Phân tán cùng một thông điệp đến nhiều endpoint cố định.
* **Recipient List EIP:** Phân tán thông điệp đến danh sách endpoint được tính toán động.
* **Dynamic Router EIP:** Định tuyến cuộn (on-the-fly) lặp đi lặp lại tại runtime.
* **Wire Tap EIP:** Trích xuất bản sao thông điệp sang kênh phụ một cách bất đồng bộ.

---

## 2. Phân nhánh điều kiện: Choice EIP và Filter EIP

Hai mô hình cơ bản nhất khi xử lý luồng logic là lọc dữ liệu và rẽ nhánh theo điều kiện.

### Filter EIP (Message Filter)

Filter EIP hoạt động tương tự như câu lệnh `if (predicate) { block }` trong ngôn ngữ lập trình Java. Mô hình này cho phép loại bỏ các thông điệp không mong muốn khỏi kênh truyền dẫn dựa trên một tiêu chí đánh giá (predicate).

* **Cách hoạt động:** Khi một Exchange đi qua Filter EIP, biểu thức predicate sẽ được đánh giá. Nếu predicate trả về `true`, thông điệp sẽ được chuyển tiếp vào bên trong khối xử lý của Filter. Nếu trả về `false`, thông điệp bị loại bỏ khỏi khối xử lý con.
* **Đặc điểm quan trọng:** Mặc định, Filter EIP chỉ áp dụng đối với các bước xử lý con nằm bên trong nó. Một thông điệp có predicate là `false` sẽ không chạy qua các bước trong Filter, nhưng nó vẫn tiếp tục di chuyển đến các bước xử lý tiếp theo phía sau khối Filter. Để dừng hoàn toàn luồng routing khi thông điệp bị lọc, mình phải sử dụng kết hợp với `Stop` EIP.
* **Lưu trạng thái lọc:** Filter EIP cung cấp tùy chọn `statusPropertyName`. Tùy chọn này cho phép lưu kết quả đánh giá predicate (dưới dạng giá trị `boolean`) vào một Exchange property để các bước phía sau có thể kiểm tra.

### Choice EIP (Content-Based Router)

Choice EIP thực hiện mô hình Content-Based Router, cho phép chuyển hướng thông điệp đến các điểm đích khác nhau dựa trên nội dung của Exchange (như header hay body).

Cấu trúc dòng chảy của Choice EIP bao gồm một hoặc nhiều nhánh `.when(predicate)` và một nhánh mặc định `.otherwise()`:

```text
                  +---> [when: condition A] ---> Endpoint A
                  |
Input Exchange ---+---> [when: condition B] ---> Endpoint B
                  |
                  +---> [otherwise] ----------> Endpoint C
```

Khi một thông điệp đi vào Choice EIP, Camel sẽ đánh giá lần lượt từng câu lệnh `when`. Nhánh `when` đầu tiên có predicate đạt giá trị `true` sẽ được chọn để xử lý. Nếu không có nhánh `when` nào khớp, thông điệp sẽ đi vào nhánh `otherwise` (nếu có).

#### Precondition Mode trong Choice EIP

Một tính năng tối ưu rất hay của Choice EIP là **Precondition Mode** (`precondition = true`). 

Khác với chế độ thông thường đánh giá từng thông điệp tại runtime, Precondition Mode đánh giá các predicate ngay tại thời điểm ứng dụng khởi tạo route (startup time). Do đánh giá ở thời điểm startup, các predicate trong Precondition Mode không thể dựa trên nội dung thông điệp mà thường dựa vào property placeholders, JVM system properties, hoặc biến môi trường OS. Sau khi chọn được nhánh phù hợp khi khởi động, Camel sẽ cố định nhánh đó cho toàn bộ thông điệp đi qua route, giúp triệt tiêu chi phí đánh giá predicate lặp đi lặp lại cho từng thông điệp.

---

## 3. Phân tán thông điệp: Multicast EIP và Recipient List EIP

Khi cần gửi thông điệp đến nhiều nơi cùng một lúc, Apache Camel cung cấp hai mô hình phân tán chính là Multicast EIP và Recipient List EIP.

### Multicast EIP

Multicast EIP cho phép gửi **cùng một thông điệp** đến danh sách các endpoint cố định được định nghĩa trước và xử lý chúng theo những cách khác nhau. Multicast đóng vai trò là nền tảng cốt lõi cho cả Recipient List EIP và Splitter EIP.

* **Chế độ xử lý:** Mặc định, Multicast chạy đơn luồng (single-threaded), nghĩa là việc gửi thông điệp đến endpoint tiếp theo chỉ bắt đầu khi endpoint trước đó đã hoàn thành.
* **Xử lý song song (Parallel Processing):** Khi kích hoạt `parallelProcessing()`, Camel sẽ sử dụng một thread pool để gửi thông điệp đến các endpoint một cách đồng thời.
* **Tổng hợp phản hồi (Aggregation):** Sau khi các nhánh multicasted hoàn thành, Camel có thể thu gom và tổng hợp các thông điệp phản hồi thành một Exchange duy nhất thông qua `AggregationStrategy`.
* **Các Exchange Property được cung cấp:** Trong quá trình multicasting, Camel tự động gán các property lên Exchange như `CamelMulticastIndex` (chỉ số đếm bắt đầu từ 0), `CamelMulticastComplete` (xác định Exchange cuối cùng) và `CamelToEndpoint` (URI điểm đích).

### Recipient List EIP

Recipient List EIP giải quyết bài toán: Làm sao để định tuyến thông điệp đến một danh sách các điểm đích được xác định linh hoạt tại runtime?

Mô hình này kiểm tra thông điệp đầu vào, tính toán danh sách các recipient mong muốn, và chuyển tiếp thông điệp đến tất cả các kênh tương ứng.

* **Đánh giá điểm đích động:** Danh sách điểm đích có thể được tính toán qua một biểu thức (Expression) hoặc lấy trực tiếp từ header. Kết quả tính toán có thể là một chuỗi phân tách bằng dấu phẩy, một `java.util.Collection`, `java.util.Iterator`, mảng, hoặc `NodeList`.
* **Tùy chỉnh Delimiter:** Mặc định Camel sử dụng dấu phẩy `,` để phân tách các URI trong chuỗi. Mình có thể cấu hình lại ký tự phân tách (ví dụ dấu chấm phẩy `;`) bằng tùy chọn `delimiter`.
* **Bỏ qua endpoint không hợp lệ:** Thông qua tuỳ chọn `ignoreInvalidEndpoints`, Camel sẽ bỏ qua và ghi log các endpoint URI không hợp lệ thay vì ném ra ngoại lệ dừng toàn bộ luồng.
* **Thay đổi Exchange Pattern:** Mặc định Recipient List giữ nguyên Exchange Pattern ban đầu. Tuy nhiên, mình có thể chỉ định cấu hình `exchangePattern=InOut` ngay trên URI của recipient (ví dụ `activemq:queue:inbox?exchangePattern=InOut`) để chuyển hướng nhận phản hồi từ JMS rồi lưu vào file mà không làm thay đổi pattern chung của luồng gốc.

---

## 4. Định tuyến linh hoạt ở Runtime: Dynamic Router EIP

Một mô hình định tuyến nâng cao khác là **Dynamic Router EIP**. Mô hình này giúp loại bỏ sự phụ thuộc cố định của router vào tất cả các điểm đích có thể có, đồng thời duy trì hiệu năng xử lý.

### Khác biệt giữa Dynamic Router và Routing Slip

Tài liệu chỉ rõ sự khác biệt quan trọng giữa Dynamic Router EIP và Routing Slip EIP:
* **Routing Slip EIP:** Đánh giá danh sách hành trình (slip) **một lần duy nhất** ngay từ đầu.
* **Dynamic Router EIP:** Đánh giá hành trình **cuộn (on-the-fly) lặp đi lặp lại** sau mỗi bước xử lý.

Dynamic Router sẽ gọi một biểu thức hoặc một phương thức Java Bean nhiều lần. Sau mỗi lần gọi, phương thức trả về URI của endpoint tiếp theo. Quá trình này tiếp tục lặp lại cho đến khi phương thức trả về `null` để báo hiệu kết thúc luồng định tuyến.

Trong suốt quá trình này, Camel thiết lập Exchange property `Exchange.SLIP_ENDPOINT` chứa thông tin endpoint hiện tại, giúp lập trình viên theo dõi luồng đã đi được bao xa.

Cũng có thể dùng annotation `@DynamicRouter` trực tiếp trên phương thức của Java Bean kết hợp với Bean Parameter Binding để tự động ràng buộc dữ liệu từ Exchange (như Header, Body, XPath) vào tham số hàm.

---

## 5. Trích xuất thông điệp bất đồng bộ: Wire Tap EIP

Wire Tap EIP cho phép trích xuất và gửi một bản sao của thông điệp đến một địa điểm phụ (ví dụ: hệ thống logging, audit trail, hoặc queue sao lưu) trong khi thông điệp chính vẫn tiếp tục hành trình đến điểm đích ban đầu mà không bị gián đoạn.

```text
                     +---> [ Tapped Exchange (InOnly, Async) ] ---> Tap Endpoint
                     |
Input Exchange ------+
                     |
                     +---> [ Original Exchange ] -----------------> Next Destination
```

* **Chế độ gửi bất đồng bộ (Fire-and-Forget):** Wire Tap sao chép Exchange ban đầu và tự động chuyển Exchange Pattern của bản sao sang **InOnly**. Bản sao này sau đó được gửi đi trên một luồng (thread) riêng biệt để chạy song song với luồng chính.
* **Dynamic URI với Simple Language:** Wire Tap hỗ trợ tính toán URI điểm đích một cách linh hoạt bằng ngôn ngữ Simple. Ví dụ, mình có thể gửi bản sao đến danh mục queue tương ứng với ID trong header: `wireTap("jms:queue:backup-${header.id}")`.

---

## 6. Những cạm bẫy kỹ thuật và bài học kinh nghiệm

Đọc tài liệu thôi là chưa đủ, điểm giá trị nhất khi đào sâu vào các EIP này là nhận diện các cạm bẫy kỹ thuật (gotchas) có thể gây ra lỗi dừng ứng dụng hoặc tràn bộ nhớ trong môi trường production.

### Cạm bẫy 1: Lỗi biên dịch Java DSL với Choice EIP (`endChoice()`)

Khi viết route bằng Java DSL, có những trường hợp trình biên dịch Java sẽ từ chối các câu lệnh `.when()` hoặc `.otherwise()` tiếp theo.

Nguyên nhân xuất hiện khi mình sử dụng các EIP có chứa luồng con (sub-route) bên trong nhánh `when` của Choice EIP (ví dụ như `loadBalance()`, `split()`). Vì giới hạn kiểu dữ liệu Generics của Java DSL, lệnh `.end()` thông thường chỉ đóng scope của EIP con chứ không thể tự động trả scope về cho Choice EIP.

* **Cách khắc phục:** Phải dùng lệnh `.endChoice()` để báo cho Camel "pop the stack" và quay lại scope của Choice EIP:

```java
from("direct:start")
    .choice()
        .when(body().contains("Camel"))
            .loadBalance().roundRobin().to("mock:foo").to("mock:bar").endChoice()
        .otherwise()
            .to("mock:result");
```

Nếu cấu hình phức tạp gây lỗi cú pháp DSL, giải pháp tốt nhất là tách các nhánh thành những route riêng biệt và nối chúng qua component `direct:`.

### Cạm bẫy 2: Vòng lặp vô tận và Thread Safety trong Dynamic Router EIP

* **Vòng lặp vô hạn (Infinite Loop):** Biểu thức hoặc phương thức Bean dùng cho Dynamic Router **bắt buộc phải trả về `null`** ở bước cuối cùng. Nếu quên trả về `null`, Dynamic Router sẽ tiếp tục gọi phương thức mãi mãi không bao giờ dừng.
* **Rủi ro an toàn đa luồng (Thread Safety):** Không được lưu trạng thái đếm số lần gọi (invoked count) trên các trường thuộc tính (instance fields) của Bean vì Bean có thể được chia sẻ giữa nhiều luồng. Thay vào đó, trạng thái phải được lưu vào **Exchange Properties** (`properties.get("invoked")`) vì Exchange Property được duy trì an toàn theo từng luồng xử lý suốt quá trình định tuyến.

### Cạm bẫy 3: Nông bản sao (Shallow Copy) vs Đậm bản sao (Deep Copy)

Cả Multicast EIP lẫn Wire Tap EIP mặc định chỉ tạo một **shallow copy** (bản sao nông) của Exchange.

Nếu phần thân thông điệp (message body) là một đối tượng có thể biến đổi (mutable object), việc các luồng xử lý song song cùng đọc/ghi lên đối tượng này sẽ gây ra xung đột dữ liệu (data corruption).

* **Cách khắc phục:** Trong trường hợp này, bắt buộc phải khai báo một processor tùy chỉnh thông qua tùy chọn `onPrepare` để chủ động nhân bản sâu (deep clone) đối tượng trước khi phân tán thông điệp.

### Cạm bẫy 4: Cạn kiệt Thread Pool trong Wire Tap EIP

Wire Tap sử dụng một thread pool để gửi các thông điệp tapped. Khi thread pool bị quá tải hoặc cạn kiệt luồng xử lý, mặc định các tác vụ Wire Tap tiếp theo sẽ bị đẩy về thực thi **đồng bộ (synchronously)** ngay trên luồng gọi chính (calling thread).

Điều này làm mất đi tính chất bất đồng bộ ban đầu và có thể kéo chậm luồng xử lý chính. Giải pháp là phải chủ động cấu hình một thread pool riêng (`executorService`) với kích thước queue và chính sách từ chối (rejection policy) phù hợp.

### Cạm bẫy 5: Xử lý ngoại lệ với `stopOnException`

Mặc định, Multicast EIP và Recipient List EIP vẫn sẽ tiếp tục gửi thông điệp đến các endpoint còn lại ngay cả khi một endpoint trước đó gặp sự cố văng ra ngoại lệ.

Nếu muốn dừng ngay lập tức luồng xử lý khi gặp lỗi và đẩy ngoại lệ về cho Camel Error Handler xử lý, mình cần phải bật cờ `stopOnException()`.

---

## Kết luận

Việc nắm vững các mô hình Message Routing EIPs giúp lập trình viên xây dựng kiến trúc tích hợp hệ thống vừa linh hoạt vừa dễ bảo trì. Rút ra các quy tắc áp dụng thực tế:

1. **Dùng Choice EIP / Filter EIP** khi cần phân nhánh logic điều kiện. Luôn cân nhắc `precondition = true` cho Choice EIP nếu điều kiện cố định từ thời điểm startup để tối ưu hiệu năng execution.
2. **Dùng Multicast EIP / Recipient List EIP** khi cần phân tán dữ liệu đến nhiều điểm đích song song, kết hợp `AggregationStrategy` để thu gom kết quả.
3. **Dùng Dynamic Router EIP** khi hành trình của thông điệp cần tính toán linh hoạt từng bước tại runtime dựa trên trạng thái xử lý.
4. **Dùng Wire Tap EIP** khi cần thực hiện các tác vụ phụ (audit, log, backup) bất đồng bộ theo mô hình fire-and-forget.
5. **Cảnh giác với các cạm bẫy kỹ thuật:** Sử dụng `.endChoice()` khi lồng EIP trong Java DSL; lưu trạng thái luồng trong Exchange Properties thay vì instance bean; áp dụng `onPrepare` để deep-clone message body khi chạy đa luồng; và kích hoạt `stopOnException` nếu cần ngắt luồng ngay khi gặp sự cố.

---

## References

- [Choice :: Apache Camel](https://camel.apache.org/components/latest/eips/choice-eip.html)
- [Dynamic Router :: Apache Camel](https://camel.apache.org/components/latest/eips/dynamicRouter-eip.html)
- [EIPs :: Apache Camel](https://camel.apache.org/components/latest/eips/enterprise-integration-patterns.html)
- [Filter :: Apache Camel](https://camel.apache.org/components/latest/eips/filter-eip.html)
- [Multicast :: Apache Camel](https://camel.apache.org/components/latest/eips/multicast-eip.html)
- [Recipient List :: Apache Camel](https://camel.apache.org/components/latest/eips/recipientList-eip.html)
- [Wire Tap :: Apache Camel](https://camel.apache.org/components/latest/eips/wireTap-eip.html)

## Series

- Previous: [Route Design & Camel DSL: Java Fluent DSL, XML, YAML và Camel JBang](../02-dsl-and-route-design/index.md)
- Next: [Enterprise Integration Patterns (EIP) — Phần 2: Splitter, Aggregator & Resequencer](../04-enterprise-integration-patterns-2/index.md)
