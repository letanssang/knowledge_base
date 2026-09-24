---
title: "OWASP MASVS v2.1.0: Khung Tiêu Chuẩn Bảo Mật Cho Ứng Dụng Di Động"
description: "OWASP Mobile Application Security Verification Standard (MASVS) là một tiêu chuẩn bảo mật dành cho ứng dụng di động. MASVS v2.1.0 chia các yêu cầu bảo mật thành 8 nhóm kiểm soát, bao phủ từ lưu trữ dữ liệu, mật mã, xác thực, giao tiếp mạng đến khả năng chống reverse engineering và bảo vệ quyền riêng tư."

date: 2026-09-24
updated: 2026-09-24

series: "Mobile Security"
series_order: 1

tags:
  - owasp
  - masvs
  - mobile-security

status: published
language: vi
---

# OWASP MASVS v2.1.0: Khung Tiêu Chuẩn Bảo Mật Cho Ứng Dụng Di Động

> **Tóm tắt:** OWASP Mobile Application Security Verification Standard (MASVS) là một tiêu chuẩn bảo mật dành cho ứng dụng di động. MASVS v2.1.0 chia các yêu cầu bảo mật thành 8 nhóm kiểm soát, bao phủ từ lưu trữ dữ liệu, mật mã, xác thực, giao tiếp mạng đến khả năng chống reverse engineering và bảo vệ quyền riêng tư.

*Thời gian đọc: ~6 phút*

---

## 1. MASVS là gì và tại sao chúng ta cần nó?

Ứng dụng di động ngày nay có thể lưu trữ và xử lý rất nhiều dữ liệu nhạy cảm: thông tin cá nhân, tài khoản, token xác thực, dữ liệu tài chính hay dữ liệu doanh nghiệp.

Tuy nhiên, mô hình bảo mật trên mobile có nhiều điểm khác so với desktop hay web.

### Application Sandbox

Android và iOS sử dụng **application sandbox** để cô lập dữ liệu và tài nguyên của từng ứng dụng. Trong điều kiện bình thường, một ứng dụng không thể tùy ý truy cập dữ liệu riêng của ứng dụng khác.

Điều này khiến mô hình bảo mật mobile tập trung nhiều hơn vào việc bảo vệ dữ liệu và các điểm giao tiếp của chính ứng dụng.

### Data Protection

Một trong những mục tiêu quan trọng nhất của mobile security là bảo vệ dữ liệu:

- **Data at rest:** dữ liệu được lưu trên thiết bị.
- **Data in transit:** dữ liệu được truyền qua mạng.
- **Data in use:** dữ liệu đang được ứng dụng xử lý hoặc hiển thị.

Dữ liệu nhạy cảm có thể bị lộ thông qua local storage, logs, backups, clipboard, screenshots, network traffic hoặc các API của hệ điều hành.

### Defense in Depth

Các kỹ thuật như:

- Root/Jailbreak detection
- Obfuscation
- Anti-debugging
- Anti-tampering

có thể khiến việc phân tích hoặc chỉnh sửa ứng dụng trở nên khó khăn hơn.

Tuy nhiên, chúng **không thể thay thế các kiểm soát bảo mật cốt lõi** như mã hóa dữ liệu, xác thực đúng cách hay giao tiếp mạng an toàn.

Để chuẩn hóa các yêu cầu này, **OWASP (Open Worldwide Application Security Project)** phát triển **Mobile Application Security Verification Standard — MASVS**.

MASVS trả lời một câu hỏi khá đơn giản:

> **Một ứng dụng mobile an toàn nên đáp ứng những yêu cầu nào?**

---

## 2. 8 nhóm kiểm soát của MASVS

MASVS v2.1.0 chia các yêu cầu bảo mật thành 8 nhóm:

```text
OWASP MASVS

├── STORAGE
├── CRYPTO
├── AUTH
├── NETWORK
├── PLATFORM
├── CODE
├── RESILIENCE
└── PRIVACY
```

Mỗi nhóm tập trung vào một phần khác nhau trong attack surface của ứng dụng.

---

### 2.1 MASVS-STORAGE — Bảo vệ dữ liệu lưu trữ

**Mục tiêu:** bảo vệ dữ liệu nhạy cảm được lưu trên thiết bị và tránh việc dữ liệu bị rò rỉ ngoài ý muốn.

#### MASVS-STORAGE-1

Dữ liệu nhạy cảm được ứng dụng lưu trữ phải được bảo vệ phù hợp.

Ví dụ:

```text
Access Token
Refresh Token
User Credentials
Personal Information
Encryption Keys
```

Không nên lưu những dữ liệu này dưới dạng plaintext trong các vị trí không được bảo vệ.

Tùy nền tảng, ứng dụng có thể sử dụng các cơ chế như:

```text
Android Keystore
iOS Keychain
Encrypted Storage
```

#### MASVS-STORAGE-2

Ứng dụng cũng cần tránh **rò rỉ dữ liệu ngoài ý muốn** thông qua các cơ chế của hệ thống.

Ví dụ:

```text
Application Logs
System Backups
Clipboard
Temporary Files
Platform APIs
```

Một lỗi khá phổ biến là ghi toàn bộ API response hoặc access token vào log trong quá trình debug rồi vô tình để lại trong production.

---

### 2.2 MASVS-CRYPTO — Sử dụng mật mã an toàn

**Mục tiêu:** đảm bảo các thuật toán và khóa mật mã được sử dụng đúng cách.

#### MASVS-CRYPTO-1

Ứng dụng phải sử dụng các thuật toán mật mã hiện đại và phù hợp với tiêu chuẩn ngành.

Một nguyên tắc quan trọng:

> **Don't invent your own cryptography.**

Thay vì tự xây dựng thuật toán mã hóa, nên sử dụng các thư viện và API mật mã đã được kiểm chứng.

#### MASVS-CRYPTO-2

Khóa mật mã phải được quản lý an toàn trong toàn bộ vòng đời của nó.

Bao gồm:

```text
Key Generation
Key Storage
Key Usage
Key Rotation
Key Destruction
```

Trên mobile, khóa thường được bảo vệ bằng các cơ chế như **Android Keystore** hoặc **iOS Keychain**.

---

### 2.3 MASVS-AUTH — Authentication & Authorization

**Mục tiêu:** đảm bảo người dùng được xác thực và phân quyền đúng cách.

#### MASVS-AUTH-1

Ứng dụng phải triển khai đúng các giao thức authentication và authorization được sử dụng với backend.

Ví dụ:

```text
OAuth 2.0
OpenID Connect
Session-based Authentication
```

#### MASVS-AUTH-2

Các cơ chế xác thực cục bộ phải được triển khai an toàn.

Ví dụ:

```text
PIN
Fingerprint
Face ID
Biometric Authentication
```

Điều quan trọng là hiểu rằng biometric authentication thường chỉ là một phần của cơ chế bảo vệ local credentials hoặc cryptographic keys, không phải sự thay thế cho authentication phía server.

#### MASVS-AUTH-3

Các thao tác đặc biệt nhạy cảm có thể yêu cầu **additional authentication**.

Ví dụ:

```text
Transfer Money
Change Password
Change Security Settings
Access Sensitive Information
```

Đây thường được gọi là **step-up authentication**.

---

### 2.4 MASVS-NETWORK — Bảo vệ dữ liệu truyền qua mạng

**Mục tiêu:** đảm bảo dữ liệu giữa ứng dụng và server không bị đọc hoặc chỉnh sửa bởi bên thứ ba.

#### MASVS-NETWORK-1

Network traffic phải được bảo vệ bằng các giao thức và cấu hình bảo mật phù hợp, phổ biến nhất là **TLS**.

Mục tiêu là bảo vệ:

```text
Confidentiality
Integrity
Server Authenticity
```

#### MASVS-NETWORK-2

Đối với các endpoint thuộc quyền kiểm soát của tổ chức, ứng dụng có thể yêu cầu cơ chế xác minh danh tính endpoint bổ sung như **certificate/public-key pinning**, tùy threat model và yêu cầu bảo mật.

Điều này giúp tăng khả năng chống lại một số tình huống **Man-in-the-Middle (MITM)**.

---

### 2.5 MASVS-PLATFORM — Tương tác an toàn với hệ điều hành

Ứng dụng mobile không hoạt động độc lập mà liên tục tương tác với Android/iOS.

#### MASVS-PLATFORM-1

Các cơ chế giao tiếp giữa ứng dụng và hệ điều hành hoặc giữa các ứng dụng cần được kiểm soát.

Ví dụ trên Android:

```text
Intents
Activities
Services
Broadcast Receivers
Content Providers
```

Việc export component không cần thiết có thể mở ra attack surface cho ứng dụng khác.

#### MASVS-PLATFORM-2

Các thành phần như **WebView** phải được cấu hình an toàn.

Đặc biệt cần cẩn thận với:

```text
JavaScript
JavaScript Bridge
File Access
Untrusted URLs
```

#### MASVS-PLATFORM-3

Dữ liệu nhạy cảm hiển thị trên UI cũng cần được bảo vệ.

Ví dụ:

```text
Screenshots
App Switcher Preview
Screen Recording
Shoulder Surfing
```

---

### 2.6 MASVS-CODE — Chất lượng code và dependency

Nhóm này tập trung vào những rủi ro xuất phát từ chính codebase và software supply chain.

Các vấn đề cần quan tâm bao gồm:

```text
Supported Platform Versions
Application Updates
Third-party Dependencies
Input Validation
```

Ví dụ, một ứng dụng sử dụng SDK có lỗ hổng bảo mật đã biết vẫn có thể bị ảnh hưởng dù code của ứng dụng không trực tiếp chứa lỗi đó.

Tương tự, dữ liệu đi vào ứng dụng từ API, deep link, intent, WebView hoặc các external input khác đều cần được coi là **untrusted input** và được xử lý phù hợp.

---

### 2.7 MASVS-RESILIENCE — Chống reverse engineering và tampering

Không giống các nhóm trước, RESILIENCE tập trung vào việc tăng độ khó khi attacker cố gắng phân tích hoặc chỉnh sửa ứng dụng.

Các kỹ thuật phổ biến gồm:

```text
Root / Jailbreak Detection
Anti-Tampering
Obfuscation
Anti-Debugging
Anti-Instrumentation
```

Ví dụ, obfuscation có thể biến code dễ đọc thành code khó phân tích hơn.

Tuy nhiên cần nhớ:

> **Resilience increases the cost of an attack; it does not make an application impossible to reverse engineer.**

Nếu một secret được hard-code trực tiếp trong ứng dụng, obfuscation chỉ khiến việc tìm secret đó khó hơn — không biến nó thành một secret thực sự an toàn.

---

### 2.8 MASVS-PRIVACY — Bảo vệ quyền riêng tư

Security và privacy có liên quan nhưng không hoàn toàn giống nhau.

Một hệ thống có thể lưu dữ liệu rất an toàn nhưng vẫn thu thập nhiều dữ liệu hơn mức cần thiết.

MASVS-PRIVACY tập trung vào các nguyên tắc như:

#### Data Minimization

Chỉ thu thập dữ liệu thực sự cần thiết.

#### User Identification

Hạn chế khả năng liên kết dữ liệu với danh tính người dùng khi không cần thiết.

Các kỹ thuật có thể bao gồm:

```text
Anonymization
Pseudonymization
Data Isolation
```

#### Transparency

Người dùng cần biết:

```text
What data is collected?
Why is it collected?
Who receives it?
How long is it stored?
```

#### User Control

Ứng dụng cần cung cấp các cơ chế phù hợp để người dùng quản lý dữ liệu và quyền riêng tư của mình.

---

## 3. MASVS áp dụng cho những ứng dụng nào?

MASVS không phụ thuộc vào framework hay ngôn ngữ lập trình cụ thể.

Nó có thể áp dụng cho:

```text
Android Native
    Kotlin
    Java

iOS Native
    Swift
    Objective-C

Cross-platform
    Flutter
    React Native
    Xamarin

Hybrid
    Ionic
    Cordova
```

Các SDK và third-party components được tích hợp vào ứng dụng cũng là một phần của attack surface và cần được xem xét trong quá trình đánh giá bảo mật.

---

## 4. MASVS không phải chứng nhận

Một điểm dễ gây hiểu nhầm là khái niệm **"MASVS Certified"**.

OWASP cung cấp tiêu chuẩn, tài liệu và phương pháp đánh giá nhưng **không vận hành một chương trình chứng nhận MASVS chính thức cho ứng dụng**.

Vì vậy, nếu một công ty cung cấp dịch vụ "MASVS Certification", đó là đánh giá hoặc chứng nhận do chính đơn vị đó cung cấp, không phải chứng nhận trực tiếp từ OWASP.

---

## 5. MASVS và MASTG khác nhau như thế nào?

Hai tài liệu này thường được sử dụng cùng nhau:

```text
MASVS
  ↓
What security requirements should the app satisfy?

MASTG
  ↓
How can we test those requirements?
```

Có thể hiểu đơn giản:

**MASVS = Standard**

**MASTG = Testing Guide**

Ví dụ, MASVS có thể yêu cầu ứng dụng phải bảo vệ sensitive data trong local storage.

MASTG sẽ cung cấp các kỹ thuật và test case giúp kiểm tra xem ứng dụng thực tế có đáp ứng yêu cầu đó hay không.

---

## 6. Automated tools có đủ để kiểm tra MASVS không?

Không.

Các công cụ như:

```text
SAST
DAST
Dependency Scanner
Secret Scanner
Mobile Security Scanner
```

rất hữu ích trong việc tự động phát hiện một số nhóm vấn đề.

Nhưng chúng khó có thể hiểu đầy đủ:

```text
Business Logic
Authentication Flow
Authorization Rules
Threat Model
Architecture
Application Context
```

Vì vậy, automated scanning nên được xem là **một phần của quá trình security testing**, thay vì thay thế hoàn toàn manual review.

Trong nhiều trường hợp, việc đánh giá hiệu quả hơn khi tester có quyền truy cập source code, kiến trúc hệ thống và có thể trao đổi trực tiếp với development team.

---

## 7. MASVS chỉ tập trung vào Mobile Client

Một giới hạn quan trọng cần hiểu:

```text
Mobile Application
       │
       │  API
       ▼
Backend Server
```

MASVS chủ yếu tập trung vào **mobile client**.

Backend API vẫn cần được đánh giá bằng các tiêu chuẩn phù hợp khác, chẳng hạn:

```text
Mobile App → OWASP MASVS
Backend / Web App → OWASP ASVS
```

Một mobile app tuân thủ MASVS không đồng nghĩa toàn bộ hệ thống đã an toàn nếu backend vẫn tồn tại các lỗ hổng nghiêm trọng.

---

## Kết luận

OWASP MASVS cung cấp một cách có hệ thống để suy nghĩ về mobile application security thông qua 8 nhóm:

```text
STORAGE     → How do we protect stored data?
CRYPTO      → Are we using cryptography correctly?
AUTH        → Who is the user and what can they do?
NETWORK     → Is data protected in transit?
PLATFORM    → Are OS/platform features used safely?
CODE        → Is the codebase and supply chain secure?
RESILIENCE  → How resistant is the app to tampering?
PRIVACY     → Are we respecting user privacy?
```

Điểm quan trọng nhất mình rút ra từ MASVS là **mobile security không phải một tính năng riêng lẻ được thêm vào cuối dự án**.

Nó là tập hợp các quyết định được đưa ra xuyên suốt vòng đời của ứng dụng — từ cách lưu token, thiết kế authentication flow, gọi API, sử dụng SDK bên thứ ba cho đến cách build và phát hành ứng dụng.

MASVS cho chúng ta biết **cần bảo vệ những gì**.

MASTG giúp chúng ta trả lời câu hỏi tiếp theo:

> **Làm thế nào để kiểm tra rằng ứng dụng thực sự đáp ứng những yêu cầu đó?**

## References

- [OWASP MASVS](https://mas.owasp.org/MASVS/)
- [MASVS v2.1.0 release notes](https://github.com/OWASP/masvs/releases/tag/v2.1.0)
- [OWASP MASTG](https://mas.owasp.org/MASTG/)
- [OWASP ASVS](https://owasp.org/projects/asvs)

## Series

- Next: [OWASP MASWE Là Gì? Cầu Nối Giữa MASVS Và MASTG Trong Mobile Security](../02-owasp-maswe/index.md)
