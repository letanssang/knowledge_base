---
title: "Observability & Monitoring: Metrics, Tracing & Hawtio"
description: "Ghi chép chi tiết về 4 trụ cột Observability trong Apache Camel gồm Health Checks, JMX, Micrometer và OpenTelemetry."
date:
updated:
series: "Apache Camel"
series_order: 11
tags:
  - apache-camel
  - observability
  - metrics
  - tracing
status: draft
language: vi
---

> **Tóm tắt:** Bài viết phân tích 4 phương pháp giám sát (Observability) trong Apache Camel: kiểm tra trạng thái hoạt động với Health Checks, quản lý và điều khiển runtime qua JMX, thu thập chỉ số hiệu năng (metrics) bằng Micrometer, và truy vết phân tán (distributed tracing) nhờ OpenTelemetry. Qua đó giúp mình nắm rõ cơ chế vận hành, các tùy chọn cấu hình và những rủi ro về mặt hiệu năng trong môi trường thực tế.

*Thời gian đọc: ~12 phút*

---

## 1. Tổng quan về Observability trong Apache Camel

Khi xây dựng các ứng dụng tích hợp dựa trên Enterprise Integration Patterns (EIP), thông điệp phải di chuyển qua chuỗi phức tạp gồm các route, endpoint, processor và hệ thống bên ngoài. Nếu không có giải pháp giám sát toàn diện, việc xác định vị trí nghẽn mạng hay nguyên nhân gây lỗi route sẽ trở nên vô cùng khó khăn.

Apache Camel cung cấp một bộ 4 công cụ chính giúp mình quan sát hệ thống ở các góc độ khác nhau:

1. **Health Checks**: Kiểm tra sự sống (Liveness) và mức độ sẵn sàng (Readiness) của ứng dụng.
2. **JMX (Java Management Extensions)**: Giám sát và điều khiển runtime của các đối tượng trong CamelContext.
3. **Micrometer**: Đo lường chỉ số định lượng (metrics) như số lượng thông điệp, thời gian xử lý và trạng thái route.
4. **OpenTelemetry**: Truy vết hành trình phân tán (distributed tracing) của thông điệp xuyên suốt các dịch vụ.

Sơ đồ tổng quan về cách 4 trụ cột này kết nối với ứng dụng Camel:

```text
+-------------------------------------------------------------------+
|                        Apache Camel Context                       |
|                                                                   |
|  +--------------+   +--------------+   +-----------------------+  |
|  |    Routes    |   |  Consumers   |   |       Producers       |  |
|  +-------+------+   +-------+------+   +-----------+-----------+  |
+----------|------------------|----------------------|--------------+
           |                  |                      |
           v                  v                      v
+--------------------+-------------------+--------------------------+
|                            OBSERVABILITY                          |
|                                                                   |
|  [Health Checks]   [JMX Management]    [Micrometer]  [OpenTelemetry]|
|  Liveness/Readiness MBeans & Runtime   Metrics/Gauges Distributed |
|    Probes Endpoint    Control          Prometheus     Tracing Spans|
+-------------------------------------------------------------------+
```

---

## 2. Health Checks: Kiểm tra trạng thái hoạt động của ứng dụng

### Cơ chế hoạt động cốt lõi
Camel thiết kế chiến lược Health Check dựa trên các interface chính:
- `HealthCheck`: Định nghĩa contract cho từng bài kiểm tra trạng thái.
- `HealthCheckResponse`: Trả về kết quả sau khi thực thi kiểm tra.
- `HealthCheckConfiguration`: Chứa các cấu hình cơ bản như thời gian hoãn tối thiểu hay số lần thất bại cho phép.
- `HealthCheckRegistry` & `HealthCheckRepository`: Quản lý và thu thập các health check.

Các health check có sẵn mặc định bao gồm `context` (kiểm tra CamelContext đã start chưa), `routes` (kiểm tra trạng thái các route), `consumers` (kiểm tra khả năng poll thông điệp của consumer), `producers` (mặc định bị tắt), và `registry` (tự động phát hiện các custom HealthCheck).

Cú pháp ID của một check thường có dạng `name-health-check` hoặc tên rút gọn như `context`. Đối với consumer check, ID được đặt tiền tố là `consumer:routeId`.

```text
+-----------------------------------------------------------------+
|                      HealthCheckRegistry                        |
+-----------------------------------------------------------------+
   |              |                   |                  |
   v              v                   v                  v
[context]      [routes]          [consumers]        [producers]
(CamelContext) (Route Status)   (Consumer Poll)     (Disabled by default)
```

### Readiness và Liveness
Readiness cho biết ứng dụng đã sẵn sàng nhận traffic chưa, còn Liveness xác định ứng dụng có còn sống hay không. Mặc định, các check dùng được cho cả hai. Nếu muốn cấu hình một custom health check chỉ dành riêng cho Liveness, mình cần ghi đè phương thức `isReadiness()` và trả về `false`.

Trạng thái ban đầu (Initial State) mặc định là `DOWN` (theo góc nhìn cẩn trọng), chỉ chuyển thành `UP` khi mọi thành phần hoàn tất khởi tạo. Tuy nhiên, mình có thể cấu hình trạng thái ban đầu thành `UP` (lạc quan) hoặc `UNKNOWN`.

### Cấu hình và Tùy biến
Khi có dependency `camel-health` trên classpath, các check cơ bản sẽ tự động bật. Mình có thể điều chỉnh qua file cấu hình `application.properties`:

```properties
# Tắt health check cho routes và consumers
camel.health.routesEnabled=false
camel.health.consumersEnabled=false

# Bật producer health check
camel.health.producersEnabled=true

# Loại trừ các check cụ thể bằng pattern
camel.health.exclude-pattern = myroute,consumer:myroute*,producer:kafka*
```

Để viết một Custom Health Check, mình mở rộng từ `AbstractHealthCheck` và sử dụng annotation `@HealthCheck`:

```java
import org.apache.camel.spi.annotations.HealthCheck;
import org.apache.camel.impl.health.AbstractHealthCheck;
import java.util.Map;

@HealthCheck("my-check")
public final class MyHealthCheck extends AbstractHealthCheck {

    public MyHealthCheck() {
        super("myapp", "my-check");
    }

    @Override
    protected void doCall(HealthCheckResultBuilder builder, Map<String, Object> options) {
        builder.unknown();
        builder.detail("my.detail", camelContext.getName());

        if (unhealthyCondition) {
            builder.down();
        } else {
            builder.up();
        }
    }
}
```

Nếu muốn Camel tự động quét classpath và nạp custom health check, mình cần cấu hình `camel.main.load-health-checks = true` và sử dụng `camel-component-maven-plugin` để tạo file service loader.

### Truy xuất kết quả Health Check
Kết quả kiểm tra có thể được truy xuất qua HTTP endpoint `/observe/health`. Để lấy thông tin chi tiết đầy đủ, mình truyền thêm tham số `?data=true`:

```bash
curl http://localhost:9876/observe/health?data=true
```

Mức độ hiển thị chi tiết có thể được cấu hình qua `camel.health.exposure-level` với 3 mức: `full`, `default`, hoặc `oneline`.

---

## 3. JMX Management: Quản lý và điều khiển runtime

### Cơ chế hoạt động
JMX là giải pháp quản lý tích hợp sẵn trong Java runtime. Trong Camel, JMX được cung cấp thông qua thư viện `camel-management` và `camel-management-api`. Khi thêm `camel-management` vào classpath, agent JMX sẽ tự động đăng ký các MBean vào `MBeanServer`.

Các loại đối tượng MBean chính bao gồm: `CamelContext`, `Component`, `Consumer`, `DataFormat`, `Endpoint`, `Processor`, `Route`, và `Service`.

```text
+-----------------------------------------------------------------+
|                          MBeanServer                            |
|                                                                 |
|  org.apache.camel                                               |
|   +-- context=camel-1 (ManagedCamelContext)                     |
|   +-- routes (ManagedRoute)                                     |
|   +-- processors (ManagedProcessor)                             |
|   +-- endpoints (ManagedEndpoint)                               |
+-----------------------------------------------------------------+
```

### Cấu hình JMX và Bảo mật thông tin
Nếu không muốn sử dụng JMX, mình có thể tắt bằng tham số JVM `-Dorg.apache.camel.jmx.disabled=true`, qua Java `camel.disableJMX()`, hoặc trong `application.properties`:

```properties
camel.main.jmxEnabled = false
```

Các tùy chọn cấu hình quan trọng khác của JMX:
- `mbeansLevel`: Giới hạn cấp độ đăng ký MBean (`Default`, `RoutesOnly`, `ContextOnly`).
- `statisticsLevel`: Mức độ thu thập thống kê hiệu năng (`Default`, `Extended`, `RoutesOnly`, `Off`).
- `mask`: Mặc định là `true`, tự động ẩn các thông tin nhạy cảm (như mật khẩu, passphrase) trong URI MBean và thay thế bằng `xxxxxx`.

Đối với custom component, mình có thể đánh dấu thuộc tính cần mask bằng `@ManagedAttribute(mask = true)`.

Để tránh xung đột tên MBean khi chạy nhiều CamelContext trong cùng một JVM, Camel hỗ trợ các token đặt tên như `#camelId#`, `#name#`, và `#counter#`. Mình có thể cố định pattern qua cấu hình:

```properties
camel.main.jmxManagementNamePattern = #name#
```

### Tiếp cận JMX từ xa qua Java Agent
Khi không thể kết nối JMX trực tiếp do rào cản firewall, mình có thể đính kèm một Java Agent tương thích JSR 160 (như Jolokia) để phơi bày interface JMX qua giao thức HTTP/REST:

```bash
java -javaagent:jolokia-agent-jvm-2.1.1-javaagent.jar=protocol=http,host=* -jar my-camel-app.jar
```

Khi đó, mình có thể query MBean bằng `curl` và `jq` thông qua HTTP endpoint `http://localhost:8778/jolokia/list/org.apache.camel`.

---

## 4. Micrometer: Thu thập chỉ số hiệu năng định lượng

### Cấu hình và Cú pháp URI
Thư viện `camel-micrometer` cho phép thu thập các chỉ số metrics trực tiếp từ route. Cần lưu ý rằng component `micrometer` chỉ hỗ trợ vai trò producer trong endpoint URI.

Cú pháp URI tổng quát:
```text
micrometer:[ counter | summary | timer ]:metricname[?options]
```

Ba loại metric hỗ trợ chính:
1. **Counter**: Đếm số lượng, hỗ trợ tham số `increment` và `decrement`.
2. **Distribution Summary**: Theo dõi phân phối giá trị (histogram) qua tham số `value`.
3. **Timer**: Đo thời gian qua thao tác `action=start` và `action=stop`.

Tên metric và giá trị tag đều hỗ trợ ngôn ngữ Simple expression. Mình cũng có thể ghi đè tên hoặc tag qua header message như `CamelMetricsName` và `CamelMetricsTags`.

Ví dụ đếm dung lượng body của thông điệp qua Java DSL:

```java
from("direct:in")
    .setHeader("CamelMetricsCounterIncrement", simple("${body.length}"))
    .to("micrometer:counter:body.length")
    .to("direct:out");
```

Ví dụ đo thời gian xử lý một nhánh route:

```java
from("direct:in")
    .to("micrometer:timer:simple.timer?action=start")
    .to("direct:calculate")
    .to("micrometer:timer:simple.timer?action=stop");
```

### Các chỉ số mặc định và Naming Strategy
Camel cung cấp sẵn các chỉ số mặc định như: `camel.routes.running`, `camel.exchanges.inflight`, `camel.exchanges.total`, `camel.exchanges.succeeded`, `camel.exchanges.failed`, và `camel.message.history`.

*Lưu ý:* Từ Camel 3.21 trở đi, tên các metric chuyển sang chuẩn phông chữ Micrometer thay vì dạng `camelCase` như các bản 3.20 trở về trước. Nếu cần giữ lại chuẩn cũ, mình phải cấu hình `LEGACY` naming strategy.

### Tăng cường đo lường tự động
Thay vì thêm endpoint `micrometer:` thủ công vào từng route, Camel hỗ trợ các factory tự động:
- `MicrometerRoutePolicyFactory`: Bổ sung `RoutePolicy` để thu thập thống kê hoạt động của toàn bộ các route.
- `MicrometerMessageHistoryFactory`: Bắt thời gian thực thi tại từng node/processor trong route.
- `MicrometerExchangeEventNotifier` & `MicrometerRouteEventNotifier`: Bắt các sự kiện vòng đời của exchange và route.
- `InstrumentedThreadPoolFactory`: Thu thập thông tin hiệu năng của các Thread Pool trong Camel.

Dữ liệu thống kê có thể được xuất ra dạng JSON bằng cách gọi phương thức `dumpStatisticsAsJson()` trên service tương ứng.

### Xuất dữ liệu sang Prometheus và JMX
Trong môi trường sản xuất, Micrometer thường đẩy dữ liệu về Prometheus. Với Camel Main standalone, mình sử dụng JAR `camel-micrometer-prometheus` và bật cấu hình:

```properties
camel.management.enabled=true
camel.management.metricsEnabled=true
camel.metrics.enabled=true
camel.metrics.enableMessageHistory=true
camel.metrics.binders=processor,jvm-info,file-descriptor
```

Nếu muốn phơi bày các chỉ số Micrometer lên JMX, mình cần thêm dependency `micrometer-registry-jmx` và đăng ký `JmxMeterRegistry` vào `CompositeMeterRegistry`:

```java
@Bean(name = "metricsRegistry")
public MeterRegistry getMeterRegistry() {
    CompositeMeterRegistry meterRegistry = new CompositeMeterRegistry();
    meterRegistry.add(new JmxMeterRegistry(
       CamelJmxConfig.DEFAULT,
       Clock.SYSTEM,
       HierarchicalNameMapper.DEFAULT));
    return meterRegistry;
}
```

---

## 5. OpenTelemetry: Truy vết phân tán (Distributed Tracing)

### Cơ chế hoạt động
Module `camel-opentelemetry` được dùng để tạo các Span ghi lại sự kiện gửi và nhận thông điệp qua các endpoint trong Camel. Quá trình này giúp theo dõi luồng đi của dữ liệu xuyên suốt các dịch vụ phân tán.

*Lưu ý về phiên bản:* Component `camel-opentelemetry` đã bị đánh dấu **deprecated** từ phiên bản 4.19.0. Khuyến nghị từ tài liệu chính thức là chuyển sang sử dụng `camel-opentelemetry2`.

Cấu hình của OpenTelemetry bao gồm các thuộc tính quan trọng:
- `instrumentationName`: Tên định danh phạm vi instrumentation (mặc định là `camel`).
- `excludePatterns`: Pattern loại trừ các message không cần trace.
- `traceProcessors`: Mặc định là `false`. Nếu bật `true`, Camel sẽ tạo Span mới cho từng Processor riêng lẻ.

```text
[Client] ---> (Span: HTTP IN) ---> [Route A] ---> (Span: Kafka OUT) ---> [Kafka]
```

### Các phương thức tích hợp
1. **Khởi tạo bằng Java Code**: Khai báo `OpenTelemetryTracer` và khởi tạo trên `CamelContext`:

```java
OpenTelemetryTracer otelTracer = new OpenTelemetryTracer();
otelTracer.init(camelContext);
```

2. **Standalone Camel Main**: Bật đơn giản qua property:

```properties
camel.opentelemetry.enabled = true
```

Khi kết hợp với thư viện `opentelemetry-sdk-extension-autoconfigure`, ứng dụng có thể tự động cấu hình mà không cần viết thêm code.

3. **Sử dụng OpenTelemetry Java Agent**: Đính kèm `opentelemetry-javaagent.jar` khi khởi chạy JVM. Agent sẽ tự động đẩy Span về OpenTelemetry Collector tại địa chỉ mặc định `http://localhost:4318` qua giao thức OTLP.

```bash
java -javaagent:path/to/opentelemetry-javaagent.jar \
     -Dotel.service.name=my-camel-service \
     -Dotel.traces.exporter=otlp \
     -jar myapp.jar
```

4. **Spring Boot Actuator**: Thêm `spring-boot-starter-actuator` và `micrometer-tracing-bridge-otel`. Mặc định, Actuator chỉ lấy mẫu (sample) 10% số request. Để xem toàn bộ 100% trace, mình phải đặt tỉ lệ sampling về `1.0`:

```properties
management.tracing.sampling.probability = 1.0
```

### Tùy biến Span và MDC Logging
Để đưa thông tin `trace_id` và `span_id` vào log file của ứng dụng, mình bật tính năng OpenTelemetry Logger MDC auto instrumentation.

Trong những trường hợp đặc biệt cần bổ sung dữ liệu vào Span, mình có thể tạo một custom class triển khai interface `SpanCustomizer` và đăng ký vào Camel Registry:

```java
public class MySpanCustomizer implements SpanCustomizer {
    @Override
    public void customize(SpanBuilder spanBuilder, String operationName, Exchange exchange) {
        spanBuilder.setAttribute("custom.key", "value");
    }

    @Override
    public boolean isEnabled(String operationName, Exchange exchange) {
        return operationName.equals("my-message-queue");
    }
}
```

Dữ liệu trace có thể được đẩy tới các backend như Jaeger hay Zipkin bằng cách đăng ký các bean `SpanExporter` (như `OtlpGrpcSpanExporter` hoặc `OtlpJsonLoggingSpanExporter`).

---

## 6. Điều gì có thể sai? (Rủi ro và cạm bẫy thực tế)

Trong quá trình thiết lập Observability cho Apache Camel, mình nhận thấy một số cạm bẫy kỹ thuật có thể gây ảnh hưởng xấu đến hệ thống:

1. **Trạng thái Flaky Health Check tại Consumer**:
   Khi các consumer (như JMS hay Kafka) mới khởi tạo, chúng chưa thực hiện xong đợt poll đầu tiên. Nếu báo trạng thái `UP` ngay từ đầu rồi lại chuyển sang `DOWN` do lỗi kết nối mạng ở đợt poll đầu, health check sẽ bị chập chờn (flaky). Camel khắc phục bằng cách giữ consumer ở trạng thái `DOWN` cho đến khi đợt poll đầu tiên thực thi xong.

2. **Rò rỉ bộ nhớ do bùng nổ MBean khi dùng JMX**:
   Bật tùy chọn `registerAlways = true` trong JMX kết hợp với các dynamic EIP (như Recipient List) tạo ra liên tục các endpoint URI mới sẽ khiến số lượng MBean tăng đột biến. MBean không phải đối tượng nhẹ (non-lightweight) và tiêu tốn nhiều memory, dễ dẫn đến nguy cơ OOM hoặc suy giảm hiệu năng nghiêm trọng.

3. **Overhead khi bật tracing và history quá chi tiết**:
   Việc thiết lập `traceProcessors = true` trong OpenTelemetry hoặc dùng `MicrometerMessageHistoryFactory` trên các route có lưu lượng cực lớn sẽ tạo ra hàng triệu Span/Timer cho từng processor nhỏ lẻ. Việc này tiêu tốn CPU và memory đáng kể, làm tăng độ trễ (latency) của chính ứng dụng.

4. **Lộ thông tin mật trên URI qua JMX**:
   Nếu tùy chọn `mask` bị tắt (`mask = false`) hoặc custom component không đánh dấu `@ManagedAttribute(mask = true)`, các tham số nhạy cảm như password, secret key, passphrase trên URI endpoint sẽ bị hiển thị nguyên bản dưới dạng plain text trên console JMX.

5. **Sử dụng module OpenTelemetry cũ đã deprecated**:
   Việc tiếp tục tích hợp `camel-opentelemetry` thay vì nâng cấp lên `camel-opentelemetry2` có thể dẫn đến rủi ro không tương thích khi nâng cấp Camel lên các phiên bản tương lai.

---

## Kết luận

Qua việc tìm hiểu 4 công cụ Observability trong Apache Camel, bài học lớn nhất mà mình rút ra là: **Không có một công cụ đơn lẻ nào giải quyết được toàn bộ bài toán giám sát**. Mỗi trụ cột đóng một vai trò riêng biệt và cần được phối hợp hài hòa:

- **Health Checks**: Dùng để làm Liveness/Readiness probes cho Kubernetes hoặc load balancer nhằm quản lý vòng đời pod/node.
- **Micrometer**: Dùng để xuất metrics sang Prometheus/Grafana, phục vụ việc theo dõi SLO/SLA, đo đếm lưu lượng và đặt cảnh báo (alerting).
- **OpenTelemetry**: Dùng để phân tích độ trễ và truy vết đường đi của thông điệp xuyên suốt các microservices.
- **JMX**: Giữ lại làm kênh quản trị tại chỗ, cho phép kiểm tra chi tiết runtime và can thiệp nhanh khi debug nội bộ.

Việc áp dụng Observability trong thực tế đòi hỏi mình phải luôn cân đối giữa mức độ chi tiết của dữ liệu thu thập và chi phí tài nguyên (CPU/Memory/Network overhead) mà nó gây ra cho ứng dụng.

---

## References

- [Health Checks :: Apache Camel](https://camel.apache.org/manual/health-check.html)
- [JMX :: Apache Camel](https://camel.apache.org/manual/jmx.html)
- [Micrometer :: Apache Camel](https://camel.apache.org/components/latest/micrometer-component.html)
- [OpenTelemetry :: Apache Camel](https://camel.apache.org/components/latest/others/opentelemetry.html)

## Series

- Previous: [Testing & Mocking in Camel](../10-testing-and-mocking/index.md)
- Next: [Real-World Integration Architecture — Putting Everything Together](../12-real-world-integration-architecture/index.md)
