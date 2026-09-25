---
title: "Platform Security trên Mobile: Deep Links, WebView, IPC và Permissions"
description: "Tìm hiểu về cơ chế tương tác nền tảng (Platform Interaction), mô hình sandbox, quyền hạn ứng dụng, WebViews và Deep Links an toàn trên Android và iOS theo chuẩn OWASP MASVS."

date:
updated:

series: "Mobile Security"
series_order: 8

tags:
  - mobile-security
  - owasp-masvs
  - android-security
  - ios-security

status: draft
language: vi
---

# Platform Security trên Mobile: Deep Links, WebView, IPC và Permissions

> **Tóm tắt:** Bài viết tổng hợp góc nhìn kỹ thuật của mình về cơ chế tương tác nền tảng (Platform Interaction) trên hệ điều hành di động. Nội dung tập trung phân tích kiến trúc sandbox, cơ chế quản lý app permissions, các lỗ hổng bảo mật khi sử dụng WebViews và giải pháp liên kết ứng dụng an toàn qua Android App Links và iOS Universal Links dựa trên chuẩn OWASP MASVS/MASTG.

*Thời gian đọc: ~7 phút*

---

## 1. Tổng quan về Platform Interaction và Sandbox trong di động

Khi phát triển ứng dụng di động, việc cho phép ứng dụng giao tiếp với hệ điều hành và các ứng dụng khác là nhu cầu phổ biến. Tuy nhiên, việc mở rộng attack surface này đòi hỏi nhà phát triển phải nắm rõ cơ chế kiểm soát truy cập ở tầng hệ thống.

### Khái niệm và mục đích tồn tại

Platform Interaction bao gồm tất cả các cơ chế mà ứng dụng di động sử dụng để tương tác với tài nguyên hệ thống, dữ liệu người dùng, hoặc trao đổi thông tin với các ứng dụng khác trên cùng thiết bị. 

Mô hình này tồn tại nhằm giải quyết bài toán cân bằng giữa tính năng và bảo mật: ứng dụng cần truy cập phần cứng (camera, định vị) và dữ liệu chung, nhưng hệ điều hành phải ngăn chặn một ứng dụng độc hại can thiệp hoặc đánh cắp dữ liệu của ứng dụng khác.

### Kiến trúc Sandbox trên Android và iOS

Cả Android và iOS đều triển khai cơ chế cách ly ứng dụng (sandbox) ở tầng kernel, nhưng có cách tiếp cận kiến trúc riêng biệt:

- **Android Sandbox:** Mỗi ứng dụng chạy trong tiến trình riêng và không thể tự do truy cập bộ nhớ hoặc tệp tin của ứng dụng khác.
- **iOS Sandbox:** Hệ điều hành iOS dựa trên nhân Darwin (XNU). Mọi ứng dụng bên thứ ba chạy dưới cùng user không đặc quyền `mobile`. Chỉ một số ứng dụng và dịch vụ hệ thống chạy `root`. Mỗi ứng dụng bị giới hạn trong một container directory riêng và bị kiểm soát chặt chẽ khi gọi các API hệ thống. Ngoài ra, iOS áp dụng cơ chế XN (eXecute Never) để ngăn chặn thi hành mã trên vùng nhớ stack và heap.

```text
+-------------------------------------------------------------------+
|                        MOBILE OS KERNEL                           |
|       (Android: Linux Kernel  |  iOS: Darwin/XNU Kernel)          |
+-------------------------------------------------------------------+
             |                                     |
             v                                     v
+-------------------------+           +-------------------------+
|    App A (Sandbox A)    |           |    App B (Sandbox B)    |
|   - UID / GID riêng     |           |   - UID / GID riêng     |
|   - Private Container   |           |   - Private Container   |
+-------------------------+           +-------------------------+
             |                                     |
             +---------> [ Inter-Process ] <-------+
                         [  Communication]
```

---

## 2. Cơ chế App Permissions và Quản lý Quyền truy cập

Để truy cập các tài nguyên nằm ngoài ranh giới sandbox của mình, ứng dụng phải khai báo và yêu cầu các quyền hạn (permissions) tương ứng từ hệ thống.

### Cách thức hoạt động của Permissions trên Android

Trái ngược với việc gán quyền mặc định, ứng dụng Android phải khai báo các quyền cần thiết trong tệp `AndroidManifest.xml`. Tùy thuộc vào mức độ nhạy cảm của tài nguyên, hệ thống Android sẽ tự động cấp quyền hoặc yêu cầu người dùng xác nhận ở runtime.

OWASP phân loại các permission theo mức độ rủi ro và protection level:
- **Normal:** Cấp tự động khi cài đặt, dùng cho các tính năng rủi ro thấp (ví dụ: `ACCESS_NETWORK_STATE`, `VIBRATE`).
- **Dangerous:** Yêu cầu người dùng xác nhận trực tiếp ở runtime (ví dụ: `READ_CONTACTS`, `ACCESS_FINE_LOCATION`, `CAMERA`).
- **Signature:** Chỉ cấp cho ứng dụng được ký bằng cùng chứng chỉ với ứng dụng đã khai báo permission đó.
- **Internal / SignatureOrSystem:** Quyền dành riêng cho các thành phần hệ thống hoặc ứng dụng nhà sản xuất.

### Kiểm soát quyền trong Broadcast Receivers

Khi truyền thông tin qua `BroadcastReceiver`, ứng dụng có thể áp dụng permission để hạn chế đối tượng gửi hoặc nhận tin nhắn. Quyền áp dụng qua thuộc tính `android:permission` trong thẻ `<receiver>` sẽ kiểm soát ứng dụng nào có quyền gửi broadcast tới receiver đó. Ngược lại, khi gọi `Context.sendBroadcast()`, ứng dụng có thể truyền kèm permission để chỉ cho phép các receiver đáp ứng đủ điều kiện nhận dữ liệu.

---

## 3. WebViews và rủi ro bảo mật khi nhúng nội dung Web

WebView là thành phần giao diện người dùng cho phép ứng dụng di động hiển thị nội dung web trực tiếp bên trong ứng dụng mà không cần chuyển sang trình duyệt ngoài.

### Nguyên lý hoạt động và lý do tồn tại

WebView tồn tại để giúp nhà phát triển dễ dàng tái sử dụng mã nguồn web, hiển thị nội dung động, hoặc xây dựng các ứng dụng lai (hybrid apps). Tuy nhiên, WebView mở ra một kênh giao tiếp trực tiếp giữa môi trường web không tin cậy và mã nguồn native của ứng dụng di động.

### Các cấu hình WebView dễ dẫn đến lỗ hổng

1. **JavaScript Execution:** Cho phép thực thi lệnh JavaScript trong WebView. Nếu WebView tải nội dung từ nguồn không tin cậy, ứng dụng có nguy cơ bị tấn công Cross-Site Scripting (XSS).
2. **Quyền truy cập Tệp cục bộ (Local File Access):**
   - `setAllowFileAccess`: Cho phép WebView tải các tệp tin từ hệ thống tệp cục bộ qua URL dạng `file://` (mặc định là `false` từ Android 11 / API level 30).
   - `setAllowFileAccessFromFileURLs` và `setAllowUniversalAccessFromFileURLs`: Cho phép JavaScript chạy trong ngữ cảnh `file://` truy cập các tệp cục bộ khác hoặc thực hiện truy cập cross-origin. Các API này đã bị đánh dấu deprecated từ API level 30.
3. **Exposing Native Bridge (`addJavascriptInterface`):** Cho phép gắn một đối tượng Java/Kotlin vào WebView để mã JavaScript gọi trực tiếp các phương thức native, dễ dẫn đến rò rỉ chức năng nhạy cảm nếu không kiểm soát nguồn gốc trang web.

```text
+-------------------------------------------------------------------+
|                           APP NATIVE                              |
|                                                                   |
|   +-----------------------------------------------------------+   |
|   |                        WEBVIEW                            |   |
|   |  Unauthenticated JS  ---> Native Bridge (Java Object)     |   |
|   |  file:// Access       ---> Internal Storage / Assets       |   |
|   +-----------------------------------------------------------+   |
+-------------------------------------------------------------------+
```

### Phương án thay thế an toàn

Để giảm thiểu rủi ro từ WebView, OWASP khuyến nghị sử dụng các giải pháp hiển thị web an toàn do hệ thống quản lý như **Custom Tabs** hoặc **Trusted Web Activities** trên Android. Các phương án này chạy JavaScript trong môi trường trình duyệt tiêu chuẩn, tuân thủ mô hình bảo mật và chu kỳ cập nhật độc lập của trình duyệt.

---

## 4. Deep Links, App Links và Universal Links

Deep Links là các URI cho phép điều hướng người dùng trực tiếp đến một nội dung cụ thể bên trong ứng dụng di động.

### Khác biệt giữa Custom Schemes và Verified Links

- **Custom URL Schemes (ví dụ: `myapp://`):** Ứng dụng đăng ký xử lý một scheme tùy chỉnh. Bất kỳ ứng dụng nào trên thiết bị cũng có thể đăng ký cùng scheme hoặc gửi Intent/URI tới handler này, do Android không cung cấp cơ chế mặc định để xác minh danh tính ứng dụng gọi (trái ngược với iOS có thuộc tính `sourceApplication`).
- **Verified Links (Android App Links & iOS Universal Links):** Sử dụng các đường dẫn HTTP/HTTPS chuẩn (`https://example.com/path`) và bắt buộc phải xác minh quyền sở hữu tên miền với ứng dụng.

```text
[Custom URL Scheme]
User Taps "myapp://pay" ---> OS Routing ---> Any App Registered Scheme (High Hijack Risk)

[Verified Link (App Link / Universal Link)]
User Taps "https://example.com/pay" 
       ---> OS Verifies Domain (assetlinks.json / apple-app-site-association)
       ---> Exact Match Native App ONLY (Fallback to Web Browser)
```

### Cơ chế xác thực liên kết (Domain Verification)

1. **Android App Links:**
   - Khai báo `<intent-filter>` với thuộc tính `android:autoVerify="true"` trong `AndroidManifest.xml`.
   - Hệ thống Android tự động tải tệp Digital Asset Links tại địa chỉ `https://<host>/.well-known/assetlinks.json` khi ứng dụng được cài đặt. Tệp này chứa thông tin package name và SHA-256 fingerprint của chứng chỉ ký ứng dụng.
2. **iOS Universal Links:**
   - Khai báo domain trong entitlement `com.apple.developer.associated-domains` dưới dạng `applinks:example.com`.
   - Máy chủ web phải phục vụ tệp `apple-app-site-association` (AASA) qua HTTPS (không qua đường dẫn chuyển hướng / redirect) tại `https://<domain>/.well-known/apple-app-site-association`.
   - Khi người dùng nhấp vào liên kết, iOS nhận đối tượng `NSUserActivity` với `activityType` là `NSUserActivityTypeBrowsingWeb` và truy xuất URL từ thuộc tính `webpageURL`.

### Lỗ hổng Insecure Deep Links (MASWE-0029)

Theo OWASP MASWE-0029, các sai sót trong triển khai Deep Links gây ra những tác động nghiêm trọng:
- **Rò rỉ dữ liệu nhạy cảm:** Kẻ tấn công đánh chặn các token xác thực hoặc thông tin cá nhân truyền qua tham số URI.
- **Bypass Authentication/Authorization:** Chiếm đoạt tài khoản khi các liên kết đăng nhập hoặc đặt lại mật khẩu bị đánh chặn.
- **Thực thi mã không an toàn:** Chèn các tham số độc hại vào URI để điều khiển luồng xử lý hoặc thực thi lệnh trong WebView.

**Biện pháp khắc phục:** Bắt buộc xác thực và làm sạch (validate/sanitize) mọi dữ liệu đầu vào từ deep link như dữ liệu không tin cậy, sử dụng App Links/Universal Links thay cho Custom Schemes, và tuyệt đối không truyền thông tin bí mật (như session token) qua URL.

---

## 5. An toàn truyền thông liên tiến trình (IPC) và chuẩn MASVS-PLATFORM-1

Chuẩn bảo mật **MASVS-PLATFORM-1** yêu cầu ứng dụng phải sử dụng các cơ chế IPC (Inter-Process Communication) một cách an toàn.

### Các thành phần IPC trên Android

Ứng dụng Android thực hiện IPC qua 4 thành phần chính:
- **Activities:** Màn hình giao diện, có thể được gọi từ ứng dụng khác nếu xuất ra ngoài (exported).
- **Services:** Tiến trình chạy ngầm xử lý tác vụ.
- **Broadcast Receivers:** Thành phần lắng nghe các thông điệp từ hệ thống hoặc ứng dụng khác.
- **Content Providers:** Thành phần quản lý và chia sẻ dữ liệu ứng dụng.

### Rủi ro liên quan đến IPC không an toàn

- **Exported Component Unprotected (MASWE-0018):** Các Activity, Service hoặc Broadcast Receiver đặt `android:exported="true"` mà không có permission bảo vệ, cho phép ứng dụng khác gửi dữ liệu giả mạo hoặc kích hoạt các chức năng nhạy cảm.
- **Content Provider Data Leakage:** Content Provider export ra ngoài có thể để ứng dụng khác đọc hoặc ghi dữ liệu của app.
- **Insecure Intents (MASWE-0032):** MASVS-PLATFORM-1 liệt kê weakness này cạnh IPC. Trang control không mô tả chi tiết từng kiểu Intent.

---

## Kết luận

Qua việc tìm hiểu kiến trúc tương tác nền tảng theo chuẩn OWASP MASVS, mình rút ra một số nguyên tắc cốt lõi khi thiết kế và phát triển ứng dụng di động:

1. **Tối thiểu hóa Attack Surface:** Chỉ xuất (export) các thành phần IPC thực sự cần thiết và luôn áp dụng permission bảo vệ cho các kênh giao tiếp liên tiến trình.
2. **Thắt chặt cấu hình WebView:** Mặc định tắt JavaScript và quyền truy cập file cục bộ nếu không sử dụng; ưu tiên chuyển sang Custom Tabs / TWA đối với các luồng duyệt web bên ngoài.
3. **Chuẩn hóa Deep Links:** Chuyển đổi từ Custom Schemes sang Android App Links và iOS Universal Links có xác thực domain, đồng thời coi mọi dữ liệu nhận được từ URL là dữ liệu không tin cậy.

---

## References

- [MASTG-KNOW-0017: App Permissions - OWASP Mobile Application Security](https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0017/)
- [MASTG-KNOW-0018: WebViews - OWASP Mobile Application Security](https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0018/)
- [MASTG-KNOW-0019: Deep Links - OWASP Mobile Application Security](https://mas.owasp.org/MASTG/knowledge/android/MASVS-PLATFORM/MASTG-KNOW-0019/)
- [MASTG-TEST-0007: Determining Whether Sensitive Stored Data Has Been Exposed via IPC Mechanisms - OWASP Mobile Application Security](https://mas.owasp.org/MASTG/tests/android/MASVS-PLATFORM/MASTG-TEST-0007/)
- [MASTG-TEST-0070: Testing Universal Links - OWASP Mobile Application Security](https://mas.owasp.org/MASTG/tests/ios/MASVS-PLATFORM/MASTG-TEST-0070/)
- [MASWE-0029: Insecure Deep Links - OWASP Mobile Application Security](https://mas.owasp.org/MASWE/MASVS-PLATFORM/MASWE-0029/)
- [MASVS-PLATFORM-1 - OWASP Mobile Application Security](https://mas.owasp.org/MASVS/controls/MASVS-PLATFORM-1/)
- [iOS Platform Overview - OWASP Mobile Application Security](https://mas.owasp.org/MASTG/0x06a-Platform-Overview/)

## Series

- Previous: [Network Security trên Mobile: TLS, Certificate Pinning và Man-in-the-Middle Attack](../07-network-security/index.md)
- Next: [Secure Coding trên Mobile: Input Validation, Dependencies và Supply Chain Security](../09-secure-coding/index.md)
