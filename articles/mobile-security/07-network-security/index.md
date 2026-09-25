---
title: "Network Security trên Mobile: TLS, Certificate Pinning và Man-in-the-Middle Attack"
description: "Tổng quan về bảo mật truyền thông mạng di động trên Android và iOS theo chuẩn OWASP MASVS-NETWORK, Android Network Security Configuration và Apple App Transport Security."

date:
updated:

series: "Mobile Security"
series_order: 7

tags:
  - mobile-security
  - network-security
  - owasp-masvs
  - certificate-pinning

status: draft
language: vi
---

# Network Security trên Mobile: TLS, Certificate Pinning và Man-in-the-Middle Attack

> **Tóm tắt:** Bài viết tổng hợp các nguyên tắc cốt lõi về bảo mật truyền thông mạng di động dựa trên tiêu chuẩn OWASP MASVS-NETWORK, cơ chế Android Network Security Configuration và iOS App Transport Security (ATS). Qua đó, mình giải thích cách thiết lập kết nối an toàn, cơ chế identity/certificate pinning, cách chặn cleartext traffic, cũng như cách thiết lập interception proxy để phân tích an toàn mạng trong thực tế.

*Thời gian đọc: ~10 phút*

---

## 1. Tổng quan về bảo mật truyền thông mạng di động

Bảo mật truyền thông mạng (network communication security) là yếu tố sống còn đối với bất kỳ ứng dụng di động nào trao đổi dữ liệu qua môi trường internet. Mục tiêu cốt lõi của lĩnh vực này là bảo vệ tính riêng tư (confidentiality) và tính toàn vẹn (integrity) của dữ liệu trên đường truyền bằng cách mã hóa dữ liệu và xác thực endpoint từ xa thông qua giao thức TLS.

Nguy cơ lớn nhất đối với các kênh truyền thông mạng là tấn công Man-in-the-Middle (MITM). Tấn công MITM xảy ra dưới hai hình thức chính:
1. Kẻ tấn công thu thập được một chứng chỉ kỹ thuật số giả mạo từ một Certificate Authority (CA) bị thỏa hiệp.
2. Kẻ tấn công chèn thành công một CA độc hại vào trust store của thiết bị client.

Để chuẩn hóa công tác thiết lập và kiểm thử an toàn mạng di động, OWASP đưa ra danh mục tiêu chuẩn OWASP MASVS-NETWORK bao gồm hai yêu cầu kiểm soát chính:
- **MASVS-NETWORK-1**: Ứng dụng bảo mật tất cả lưu lượng mạng theo các thực hành tốt nhất hiện tại (current best practices).
- **MASVS-NETWORK-2**: Ứng dụng thực hiện identity pinning cho tất cả các endpoint từ xa nằm dưới quyền kiểm soát của nhà phát triển.

---

## 2. Nền tảng bảo mật mạng trên Android và iOS

### Cơ chế Android Network Security Configuration

Trên nền tảng Android, tính năng Network Security Configuration cho phép nhà phát triển tùy chỉnh thiết lập an toàn mạng thông qua tệp khai báo XML tĩnh (`res/xml/network_security_config.xml`) mà không cần thay đổi source code của ứng dụng. Tệp khai báo này được liên kết trong file `AndroidManifest.xml` thông qua thuộc tính `android:networkSecurityConfig`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application android:networkSecurityConfig="@xml/network_security_config">
        ...
    </application>
</manifest>
```

Tính năng này cung cấp các khả năng bảo mật quan trọng:

- **Tùy chỉnh Trust Anchors**: Cho phép chỉ định danh sách các CA được chấp nhận khi ứng dụng thực hiện kết nối an toàn (như CA hệ thống, CA do người dùng thêm vào, hoặc tệp chứng chỉ tự ký lưu trong `@raw/`). Bắt đầu từ Android 7.0 (API level 24), Android loại bỏ việc tự động tin tưởng các CA do người dùng cài đặt (`user` CA) mặc định, giúp ngăn chặn nguy cơ bị chặn bắt lưu lượng mạng trái phép.
- **Quản lý Cleartext Traffic (`cleartextTrafficPermitted`)**: Bảo vệ ứng dụng khỏi việc vô tình truyền tải dữ liệu không mã hóa (HTTP). Bắt đầu từ Android 9 (API level 28), cleartext traffic bị chặn theo mặc định (`cleartextTrafficPermitted="false"`).
- **Cấu hình ghi đè Debug (`debug-overrides`)**: Cho phép thêm các CA phục vụ kiểm thử / debug riêng khi thuộc tính `android:debuggable="true"`, giúp các pentester đánh giá ứng dụng an toàn mà không làm tăng rủi ro cho bản release.
- **Certificate Transparency & Encrypted Client Hello**: Hỗ trợ xác thực Certificate Transparency (từ API level 36/37) và Encrypted Client Hello (ECH) từ Android 17 (API level 37).

### Cơ chế Apple App Transport Security (ATS) trên iOS

Đối với hệ điều hành iOS, Apple áp dụng cơ chế App Transport Security (ATS) nhằm bắt buộc mọi kết nối mạng do ứng dụng tạo ra phải sử dụng giao thức TLS với các chứng chỉ và thuật toán mã hóa đáng tin cậy.

ATS thiết lập các tiêu chí bảo mật mặc định rất khắt khe:
- Bắt buộc giao thức TLS phiên bản 1.2 trở lên.
- Khóa máy chủ phải là RSA tối thiểu 2048-bit hoặc ECC tối thiểu 256-bit.
- Chữ ký chứng chỉ sử dụng thuật toán SHA-2 với độ dài digest tối thiểu 256-bit (SHA-256).
- Mã hóa đối xứng sử dụng ciphers AES-128 hoặc AES-256.
- Bắt buộc hỗ trợ Perfect Forward Secrecy (PFS) thông qua trao đổi khóa ECDHE.

Nhà phát triển có thể cấu hình ngoại lệ cho ATS thông qua từ khóa `NSAppTransportSecurity` trong tệp `Info.plist` của ứng dụng:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>example.com</key>
        <dict>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSExceptionMinimumTLSVersion</key>
            <string>TLSv1.2</string>
        </dict>
    </dict>
</dict>
```

Tuy nhiên, ATS chỉ tự động bảo vệ các kết nối đi qua URL Loading System (`URLSession`). Các kết nối mạng sử dụng low-level API như BSD Sockets hoặc Network framework sẽ không được ATS bảo vệ tự động, do đó nhà phát triển phải tự chịu trách nhiệm xử lý an toàn kết nối.

---

## 3. Cơ chế Identity & Certificate Pinning

Trong mô hình mã hóa TLS thông thường, ứng dụng sẽ tin tưởng bất kỳ chuỗi chứng chỉ nào được ký bởi một trong các Root CA có sẵn trong trust store của hệ điều hành. Identity Pinning (hay Certificate / Public Key Pinning) là kỹ thuật giới hạn ứng dụng chỉ chấp nhận các chứng chỉ hoặc public key cụ thể của máy chủ đích do nhà phát triển kiểm soát.

Quá trình pinning được thực hiện bằng cách tính băm SHA-256 của SubjectPublicKeyInfo (X.509) thuộc chứng chỉ máy chủ và so sánh với giá trị băm đã được khai báo trước trong ứng dụng.

Trên Android, pinning có thể được khai báo trực tiếp trong Network Security Configuration thông qua thẻ `<pin-set>`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config>
        <domain includeSubdomains="true">example.com</domain>
        <pin-set expiration="2026-12-31">
            <pin digest="SHA-256">7HIpactkIAq2Y49orFOOQKurWxmmSFZhBCoQYcRhJ3Y=</pin>
            <!-- backup pin -->
            <pin digest="SHA-256">fwza0LRMXouZHRC8Ei+4PyuldPDcf3UKgO/04cDM1oE=</pin>
        </pin-set>
    </domain-config>
</network-security-config>
```

Một quy tắc quan trọng khi triển khai certificate pinning là luôn luôn phải bao gồm ít nhất một **backup pin**. Nếu không có backup key, khi máy chủ thay đổi chứng chỉ hoặc xoay CA, ứng dụng sẽ mất hoàn toàn khả năng kết nối cho đến khi nhà phát triển đẩy một bản cập nhật ứng dụng mới lên store. Tài liệu Android cũng cảnh báo đây là lý do pinning không nên bật cho mọi app: đổi CA mà client chưa có pin mới thì app mất kết nối.

Bảng so sánh giữa kiểm soát TLS mặc định và Certificate Pinning:

| Tiêu chí | TLS mặc định (MASVS-NETWORK-1) | Identity Pinning (MASVS-NETWORK-2) |
| :--- | :--- | :--- |
| **Trust Anchor** | Tự động tin tưởng mọi Root CA có sẵn trong hệ thống | Chỉ tin tưởng các public key / CA được khai báo cụ thể |
| **Mức độ chống MITM** | Có nguy cơ nếu một CA bị thỏa hiệp hoặc bị chèn CA người dùng | Từ chối chứng chỉ không nằm trong pin set, kể cả chứng chỉ của một CA mà hệ điều hành tin. Không chặn được app đã bị sửa hoặc thiết bị đã root |
| **Phương thức cấu hình** | Dựa trên cấu hình mặc định của hệ điều hành (`system` CAs) | Khai báo `<pin-set>` XML hoặc dùng thư viện như OkHttp `CertificatePinner` |
| **Chi phí quản lý** | Không cần quản lý khóa trên ứng dụng client | Bắt buộc quản lý Backup Pin và có kế hoạch xoay khóa |

---

## 4. Kỹ thuật Interception Proxy và kiểm thử an toàn mạng

Để kiểm thử và phân tích lưu lượng mạng của ứng dụng di động, các chuyên gia kiểm thử an toàn thông tin sử dụng Interception Proxy như OWASP ZAP hoặc Burp Suite. Công cụ này đặt người kiểm thử vào vị trí Machine-in-the-Middle (MITM) để đọc, phân tích và chỉnh sửa toàn bộ các request và response HTTP(S).

### Những sai sót và rủi ro thường gặp trong thực tế

Khi đánh giá hoặc triển khai an toàn mạng, các nhà phát triển và pentester thường gặp phải các vấn đề sau:

1. **Lỡ bật Cleartext Traffic không kiểm soát**: Việc thiết lập `cleartextTrafficPermitted="true"` trên toàn bộ ứng dụng (`base-config`) hoặc bật `NSAllowsArbitraryLoads` trên iOS làm lộ dữ liệu nhạy cảm dưới dạng unencrypted HTTP.
2. **Tự viết code kiểm tra SSL/TLS sai quy cách**: Việc tự viết logic xác thực SSL/TLS thay vì dùng framework tiêu chuẩn dễ dẫn đến lỗi bảo mật nghiêm trọng. Ví dụ như việc viết custom `TrustManager` không kiểm tra chuỗi chứng chỉ hoặc `HostnameVerifier` chấp nhận mọi hostname.
3. **Thiếu Backup Pin khi Pinning**: Triển khai pinning nhưng quên cấu hình backup pin làm ứng dụng bị brick kết nối khi phía máy chủ xoay chứng chỉ.
4. **Vấn đề Bypass Network Security Config khi Pentest**: Do Android 7.0+ chặn `user` CA mặc định, để intercept được lưu lượng mạng khi kiểm thử, mình giải nén APK bằng `apktool`, thêm `<certificates src="user" />` vào Network Security Configuration, rồi build và ký lại. Trên thiết bị đã root, có thể cài chứng chỉ proxy vào `/system/etc/security/cacerts/`.

---

## 5. Mô hình hoạt động của Interception Proxy

```text
+-----------------+          +----------------------+          +-----------------+
|   Mobile App    |  HTTP(S) |  Interception Proxy  |  HTTP(S) | Backend Server  |
|  (Android/iOS)  | -------->|  (Burp Suite / ZAP)  | -------->|  (example.com)  |
|                 | <--------|                      | <--------|                 |
+-----------------+          +----------------------+          +-----------------+
        |                               ^
        +--- Trust Proxy CA Certificate -+
```

---

## Kết luận

Qua việc nghiên cứu các tiêu chuẩn và tài liệu kỹ thuật, mình rút ra một số bài học quan trọng để áp dụng khi phát triển ứng dụng di động:

1. **Tuân thủ mặc định an toàn của nền tảng**: Tận dụng triệt để Android Network Security Configuration và iOS ATS để tự động chặn cleartext traffic và áp dụng TLS tiêu chuẩn.
2. **Triển khai Identity Pinning cho các endpoint quan trọng**: Áp dụng `<pin-set>` hoặc OkHttp `CertificatePinner` cho các domain nhạy cảm do mình kiểm soát, và luôn luôn khai báo backup pin.
3. **Tách biệt cấu hình Debug và Release**: Sử dụng thẻ `<debug-overrides>` trên Android để hỗ trợ kiểm thử bảo mật trong môi trường dev mà không làm ảnh hưởng đến bản phát hành thương mại.

---

## References

- [MASVS-NETWORK-1 - OWASP Mobile Application Security](https://mas.owasp.org/MASVS/controls/MASVS-NETWORK-1/)
- [MASVS-NETWORK-2 - OWASP Mobile Application Security](https://mas.owasp.org/MASVS/controls/MASVS-NETWORK-2/)
- [MASVS-NETWORK: Network Communication - OWASP Mobile Application Security](https://mas.owasp.org/MASVS/08-MASVS-NETWORK/)
- [MASTG-TECH-0011: Setting Up an Interception Proxy - OWASP Mobile Application Security](https://mas.owasp.org/MASTG/techniques/android/MASTG-TECH-0011/)
- [Network security configuration | Security | Android Developers](https://developer.android.com/privacy-and-security/security-config)
- [Pinning - OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/cheatsheets/Pinning_Cheat_Sheet.html)
- [Preventing Insecure Network Connections | Apple Developer Documentation](https://developer.apple.com/documentation/security/preventing-insecure-network-connections)

## Series

- Previous: [Authentication trên Mobile: OAuth 2.0, Tokens, Biometrics và Step-up Authentication](../06-authentication/index.md)
- Next: [Platform Security trên Mobile: Deep Links, WebView, IPC và Permissions](../08-platform-security/index.md)

