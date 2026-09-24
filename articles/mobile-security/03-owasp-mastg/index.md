---
title: "OWASP MASTG Là Gì? Từ Security Requirement Đến Thực Tế Kiểm Thử Mobile"
description: "Sau khi MASVS cho chúng ta biết cần bảo vệ điều gì và MASWE mô tả những gì có thể sai, câu hỏi tiếp theo là: làm thế nào để thực sự kiểm tra một ứng dụng? OWASP Mobile Application Security Testing Guide (MASTG) trả lời câu hỏi đó bằng một hệ thống gồm Tests, Techniques, Tools, Demos, Knowledge và Best Practices dành cho Android và iOS. Trong bài này, chúng ta sẽ tìm hiểu MASTG v2.0.0, khái niệm Atomic Tests, cách MASTG kết nối với MASVS/MASWE và cách sử dụng framework này trong một security review thực tế."

date: 2026-09-24
updated: 2026-09-24

series: "Mobile Security"
series_order: 3

tags:
  - owasp
  - mastg
  - mobile-security

status: published
language: vi
---

# OWASP MASTG Là Gì? Từ Security Requirement Đến Thực Tế Kiểm Thử Mobile

> **Tóm tắt:** Sau khi MASVS cho chúng ta biết **cần bảo vệ điều gì** và MASWE mô tả **những gì có thể sai**, câu hỏi tiếp theo là: làm thế nào để thực sự kiểm tra một ứng dụng?
>
> **OWASP Mobile Application Security Testing Guide (MASTG)** trả lời câu hỏi đó bằng một hệ thống gồm Tests, Techniques, Tools, Demos, Knowledge và Best Practices dành cho Android và iOS.
>
> Trong bài này, chúng ta sẽ tìm hiểu MASTG v2.0.0, khái niệm **Atomic Tests**, cách MASTG kết nối với MASVS/MASWE và cách sử dụng framework này trong một security review thực tế.

*Thời gian đọc: ~7 phút*

---

## 1. Từ "What can go wrong?" đến "How do we test it?"

Ở hai bài trước trong series, chúng ta đã tìm hiểu:

**[Bài #1 — OWASP MASVS](../01-owasp-masvs/index.md)**

```text
What should be secure?
```

và:

**[Bài #2 — OWASP MASWE](../02-owasp-maswe/index.md)**

```text
What can go wrong?
```

Nhưng biết requirement và weakness vẫn chưa đủ.

Giả sử MASWE nói rằng ứng dụng có thể gặp vấn đề:

```text
MASWE-0012
Improper Random Number Generation
```

Developer hoặc security tester vẫn cần trả lời:

```text
Làm sao tìm được weakness này?

Phân tích source code hay runtime?

Cần tìm API nào?

Kết quả như thế nào được coi là FAIL?

Làm thế nào để reproduce?
```

Đây là nhiệm vụ của:

**MASTG — Mobile Application Security Testing Guide.**

Có thể hình dung ba thành phần chính như sau:

```text
MASVS
"What should be secure?"
        │
        ▼
MASWE
"What can go wrong?"
        │
        ▼
MASTG
"How do we test it?"
```

---

## 2. MASTG là gì?

MASTG là bộ tài liệu kỹ thuật của OWASP dành cho việc **testing và verification security/privacy của mobile application**.

Nó không chỉ dành cho pentester.

MASTG có thể hữu ích với:

```text
Mobile Developers
Security Engineers
Pentesters
Security Reviewers
DevSecOps Engineers
```

Ví dụ, developer có thể sử dụng MASTG để hiểu:

> Security team thực sự sẽ kiểm tra implementation của mình như thế nào?

Trong khi pentester có thể sử dụng nó để:

> Xây dựng một test methodology có cấu trúc thay vì chạy hàng loạt security tools rồi xem chúng báo gì.

---

## 3. MASTG v2.0.0 thay đổi điều gì?

MASTG v2.0.0 được OWASP phát hành vào **tháng 7/2026**.

Đây không đơn thuần là một lần update nội dung.

OWASP đã thay đổi đáng kể **cách toàn bộ MASTG được tổ chức**.

### MASTG v1 — Narrative Guide

MASTG trước đây gần giống một cuốn sách.

Một chapter có thể chứa cùng lúc:

```text
Background Knowledge
        +
Static Analysis
        +
Dynamic Analysis
        +
Tools
        +
Code Examples
        +
Testing Instructions
```

Điều này rất thuận tiện nếu muốn đọc từ đầu đến cuối.

Nhưng nó tạo ra vấn đề khi muốn:

```text
Reference một test cụ thể
Automate testing
Maintain từng phần độc lập
Map test với weakness
Integrate vào tooling
```

Một số test cũ thậm chí có thể dài hàng trăm dòng.

---

## 4. MASTG v2 — từ "Book" thành "Knowledge Graph"

MASTG v2 chuyển sang một kiến trúc modular.

Thay vì:

```text
One Big Security Guide
```

MASTG được chia thành các component nhỏ có:

```text
Stable ID
Structured Metadata
Defined Relationships
Cross References
```

Các component chính gồm:

| Component | ID | Vai trò |
| --- | --- | --- |
| **Tests** | `MASTG-TEST-****` | Kiểm tra một security issue cụ thể |
| **Demos** | `MASTG-DEMO-****` | Ví dụ có thể reproduce |
| **Techniques** | `MASTG-TECH-****` | Kỹ thuật security testing |
| **Tools** | `MASTG-TOOL-****` | Công cụ hỗ trợ testing |
| **Knowledge** | `MASTG-KNOW-****` | Kiến thức nền Android/iOS |
| **Best Practices** | `MASTG-BEST-****` | Cách phòng tránh hoặc khắc phục |
| **Apps** | `MASTG-APP-****` | Reference/test applications |

Ở thời điểm MASTG v2.0.0 được phát hành, OWASP công bố:

```text
285 Tests
152 Demos
167 Techniques
135 Tools
140 Knowledge Articles
72 Best Practices
28 Apps
```

Thay vì một cuốn sách tuyến tính, giờ chúng ta có thể đi theo relationship:

```text
                ┌── Knowledge
                │
MASWE ── Test ──┼── Technique
                │
                ├── Tool
                │
                ├── Demo
                │
                └── Best Practice
```

Đó là lý do OWASP gọi cấu trúc mới này là một **knowledge graph**.

---

## 5. Atomic Test — Ý tưởng quan trọng nhất của MASTG v2

Một trong những thay đổi quan trọng nhất của MASTG v2 là:

> **One test = one thing to verify.**

OWASP gọi chúng là **Atomic Tests**.

Thay vì có một test lớn kiểu:

```text
Test Local Storage Security
```

bao gồm hàng loạt storage mechanisms, MASTG v2 chia chúng thành các test nhỏ hơn.

Ví dụ:

```text
MASTG-TEST-0200
Files Written to External Storage

MASTG-TEST-0203
Sensitive Data in Logs

MASTG-TEST-0207
Unencrypted Files in Internal Storage
```

Mỗi test chỉ tập trung vào **một security condition cụ thể**.

Điều này đem lại một lợi ích rất lớn:

```text
Small
Focused
Referenceable
Reproducible
Automatable
```

---

## 6. Một MASTG Test được cấu trúc như thế nào?

Một Atomic Test có cấu trúc khá rõ ràng.

Ví dụ:

```text
MASTG-TEST-0204
Insecure Random API Usage
```

Test này kiểm tra việc Android application sử dụng insecure PRNG trong security-sensitive context.

Một MASTG Test thường có các phần:

### Metadata

Metadata mô tả context của test:

```text
Platform
Test Type
MASWE Weakness
Security Profile
Knowledge
Best Practices
Relevant APIs
```

Ví dụ:

```text
Platform: Android
Weakness: MASWE-0012
```

---

### Overview

Giải thích:

> **Chúng ta đang kiểm tra điều gì và tại sao?**

Trong trường hợp insecure randomness, vấn đề nằm ở những API như:

```java
java.util.Random
Math.random()
```

Chúng không được thiết kế để tạo cryptographically secure randomness.

---

### Steps

Đây là phần:

> **Làm thế nào để kiểm tra?**

Thay vì viết lại toàn bộ kỹ thuật reverse engineering trong mỗi test, MASTG có thể reference đến:

```text
MASTG-TECH-****
```

Ví dụ:

```text
Reverse Engineering
        ↓
Static Analysis
        ↓
Search relevant APIs
```

---

### Observation

Observation chỉ ghi nhận **raw result**.

Ví dụ:

```text
Found java.util.Random usage:

AuthTokenGenerator.kt:42
SessionManager.kt:87
AnalyticsUtils.kt:21
```

Ở bước này chúng ta chưa kết luận rằng application vulnerable.

---

### Evaluation

Đây mới là bước interpretation.

Ví dụ:

```text
AnalyticsUtils.kt
Random UI animation
→ Not security relevant

AuthTokenGenerator.kt
Random authentication token
→ Security relevant
→ FAIL
```

Sự tách biệt giữa:

```text
Observation
      ↓
Evaluation
```

khá quan trọng.

Tool tìm thấy `Random()` không có nghĩa application tự động có security vulnerability.

**Context vẫn quan trọng.**

---

## 7. Một ví dụ hoàn chỉnh: Insecure Random Number Generation

Hãy nối những thứ chúng ta đã học từ hai bài trước.

Requirement:

```text
MASVS-CRYPTO-1

The app employs current strong cryptography
and uses it according to industry best practices.
```

Một implementation có thể vi phạm requirement này:

```java
Random random = new Random();
int token = random.nextInt();
```

MASWE định nghĩa weakness:

```text
MASWE-0012

Improper Random Number Generation
```

MASTG sau đó cung cấp test:

```text
MASTG-TEST-0204

Insecure Random API Usage
```

Test yêu cầu phân tích application để tìm những API như:

```java
java.util.Random
Math.random()
```

Nhưng test **không fail chỉ vì tìm thấy API này**.

Tester phải tiếp tục xác định chúng có được sử dụng trong security-sensitive context hay không:

```text
Cryptographic Keys
Initialization Vectors
Nonces
Authentication Tokens
Session IDs
Passwords
PINs
```

Nếu có:

```text
FAIL
```

---

## 8. Từ Test đến Demo

Biết methodology vẫn chưa chắc chúng ta biết cách thực hiện nó ngoài đời.

Vì vậy MASTG còn có:

```text
MASTG-DEMO
```

Ví dụ test vừa rồi liên kết tới:

```text
MASTG-DEMO-0007

Common Uses of Insecure Random APIs
```

Demo cung cấp vulnerable sample application để chúng ta có thể quan sát vấn đề thực tế.

Có thể hình dung:

```text
MASTG-TEST-0204
"What should I test?"
        │
        ▼
MASTG-DEMO-0007
"Show me a working example."
```

Các demo có thể bao gồm:

```text
Sample Code
Test Application
Analysis Scripts
Instrumentation
Expected Output
```

Những demo có thể automate còn có script để chạy analysis/instrumentation và sinh output tương ứng.

Điều này khiến MASTG không chỉ là:

```text
"Here's how security testing works."
```

mà tiến gần hơn đến:

```text
"Here's a reproducible example.
Run it yourself."
```

---

## 9. Từ Test đến Best Practice

Sau khi tìm được weakness, developer cần câu trả lời cho một câu hỏi khác:

> **Fix như thế nào?**

MASTG tách phần này thành:

```text
MASTG-BEST
```

Quay lại ví dụ trước:

```text
MASWE-0012
Improper Random Number Generation
        │
        ▼
MASTG-TEST-0204
Insecure Random API Usage
        │
        ├── MASTG-DEMO-0007
        │
        └── MASTG-BEST-0001
```

`MASTG-BEST-0001` là:

```text
Use Secure Random Number Generator APIs
```

Ví dụ trên Android/Java, security-sensitive randomness nên sử dụng API phù hợp như:

```java
SecureRandom secureRandom = new SecureRandom();

byte[] token = new byte[32];
secureRandom.nextBytes(token);
```

Đây là một distinction rất hay trong MASTG v2:

```text
Knowledge
"What is this?"

Test
"What can go wrong and how do I detect it?"

Best Practice
"How should I prevent/fix it?"
```

Mỗi component có một responsibility riêng.

---

## 10. Traceability Chain hoàn chỉnh

Đến đây chúng ta có thể nối toàn bộ hệ sinh thái lại.

```text
MASVS
Security Requirement
        │
        ▼
MASWE
Weakness
        │
        ▼
MASTG Test
Detection
        │
        ├─────────────┐
        ▼             ▼
MASTG Demo       MASTG Best Practice
Example          Mitigation
```

Với ví dụ vừa rồi:

```text
MASVS-CRYPTO-1
        │
        ▼
MASWE-0012
Improper Random Number Generation
        │
        ▼
MASTG-TEST-0204
Insecure Random API Usage
        │
        ├───────────────┐
        ▼               ▼
MASTG-DEMO-0007    MASTG-BEST-0001
Example            Secure Random APIs
```

Đây chính là thứ khiến ba project:

```text
MASVS
MASWE
MASTG
```

không còn là ba bộ documentation rời rạc.

---

## 11. Tools nằm ở đâu trong MASTG?

MASTG không ép chúng ta sử dụng một bộ công cụ duy nhất.

Thay vào đó, nó cung cấp **Tools catalogue** và **Techniques** để hỗ trợ quá trình testing.

Tùy loại test, chúng ta có thể gặp các công cụ quen thuộc như:

```text
Frida
MobSF
jadx
apktool
Ghidra
Burp Suite
mitmproxy
```

Nhưng có một distinction quan trọng:

```text
Tool ≠ Test
```

Ví dụ:

```text
Frida
```

chỉ là một công cụ dynamic instrumentation.

Việc chạy Frida không có nghĩa chúng ta đã thực hiện security testing đầy đủ.

Tương tự:

```text
Run MobSF
      ↓
Get 50 findings
```

không đồng nghĩa:

```text
Application Security Assessment Complete
```

Tool chỉ giúp thực hiện một **Technique**.

Technique giúp thực hiện một **Test**.

Test cuối cùng phải được đánh giá trong context của application.

Có thể hình dung:

```text
Security Question
       ↓
MASTG Test
       ↓
Technique
       ↓
Tool
       ↓
Observation
       ↓
Human Evaluation
```

---

## 12. Static Analysis và Dynamic Analysis

Mobile security testing thường kết hợp nhiều cách tiếp cận.

### Static Analysis

Phân tích application mà không cần quan sát runtime behavior.

Ví dụ:

```text
APK / IPA
    ↓
Reverse Engineering
    ↓
Manifest / Configuration
    ↓
Source / Decompiled Code
    ↓
API Usage
```

Static analysis có thể giúp phát hiện:

```text
Hard-coded Secrets
Insecure APIs
Exported Components
Unsafe Configuration
Vulnerable Dependencies
```

---

### Dynamic Analysis

Quan sát application khi nó đang chạy.

Ví dụ:

```text
Application
     ↓
Runtime
     ↓
Instrumentation
     ↓
Observe API Calls / Data Flow
```

Dynamic analysis hữu ích khi cần hiểu những behavior chỉ xuất hiện ở runtime.

---

### Manual Analysis

Một số vấn đề cần application context mà scanner khó hiểu được.

Ví dụ:

```text
Authentication Flow
Authorization Logic
Business Logic
Sensitive Operations
Privacy Behavior
```

Đây cũng là lý do security testing không thể đơn giản trở thành:

```text
Run Scanner → Fix Warnings → Secure App
```

---

## 13. Một workflow thực tế với MASTG

Thay vì bắt đầu bằng câu hỏi:

> **"Hôm nay chạy tool nào?"**

một security review có thể bắt đầu từ requirement.

```text
1. Define Scope
       ↓
2. Select MASVS Controls
       ↓
3. Identify Relevant MASWE
       ↓
4. Select MASTG Tests
       ↓
5. Execute Techniques / Tools
       ↓
6. Record Observations
       ↓
7. Evaluate Results
       ↓
8. Report Findings
       ↓
9. Apply Best Practices
       ↓
10. Retest
```

Ví dụ một feature:

```text
Login
  +
OAuth
  +
Token Storage
```

có thể dẫn chúng ta đến các nhóm:

```text
MASVS-AUTH
MASVS-STORAGE
MASVS-CRYPTO
MASVS-NETWORK
```

Từ đó mới xác định:

```text
Relevant MASWE
        ↓
Relevant MASTG Tests
        ↓
Required Techniques
        ↓
Required Tools
```

Cách tiếp cận này khác khá nhiều với việc chạy một scanner rồi xem nó tìm được gì.

---

## 14. MASTG trong DevSecOps

Atomic Tests cũng khiến MASTG phù hợp hơn với automation.

Một pipeline có thể dần tích hợp:

```text
Code
 │
 ▼
Static Analysis
 │
 ▼
Dependency Scanning
 │
 ▼
Build APK / IPA
 │
 ▼
Security Tests
 │
 ▼
Manual Review
 │
 ▼
Release
```

Không phải mọi MASTG Test đều có thể hoặc nên automate.

Những vấn đề cần:

```text
Business Context
Threat Model
Manual Interaction
Runtime Context
Human Judgment
```

vẫn cần security reviewer.

Nhưng những test có deterministic detection logic có thể trở thành một phần của CI/CD.

Đây cũng là một lợi thế của Atomic Tests:

```text
Small
+
Structured
+
Reproducible
+
Machine-readable Metadata

        ↓

Automation-friendly
```

---

## 15. Điều mình thích nhất ở MASTG v2

Trước khi tìm hiểu hệ sinh thái OWASP MAS, mình thường hình dung mobile security testing như một tập hợp các tools:

```text
MobSF
Frida
Burp Suite
jadx
Ghidra
...
```

Nhưng MASTG cho thấy cách nhìn đó đang bị ngược.

Chúng ta không nên bắt đầu bằng:

> **"Tool này làm được gì?"**

Mà nên bắt đầu bằng:

> **"Security property nào mình muốn verify?"**

Sau đó mới đi xuống:

```text
Requirement
     ↓
Weakness
     ↓
Test
     ↓
Technique
     ↓
Tool
```

Tool nằm ở **cuối reasoning chain**, không phải đầu tiên.

---

## Kết luận

Sau ba bài đầu tiên, chúng ta đã có bức tranh tương đối hoàn chỉnh về OWASP Mobile Application Security:

```text
MASVS
"What should be secure?"

        ↓

MASWE
"What can go wrong?"

        ↓

MASTG
"How do we test it?"
```

Và MASTG v2 đưa chúng ta đi sâu hơn:

```text
Security Requirement
        ↓
Weakness
        ↓
Atomic Test
        ↓
Technique
        ↓
Tool
        ↓
Observation
        ↓
Evaluation
        ↓
Best Practice
        ↓
Retest
```

Điểm mình rút ra quan trọng nhất là:

> **Security testing không bắt đầu bằng việc chọn một tool. Nó bắt đầu bằng việc xác định điều gì chúng ta muốn chứng minh là an toàn.**

Một scanner có thể tìm thấy rất nhiều suspicious patterns.

Một runtime instrumentation tool có thể cho chúng ta quan sát rất nhiều thứ.

Nhưng cuối cùng chúng ta vẫn cần biết:

```text
What are we testing?

Why does it matter?

What does failure mean?

How should it be fixed?
```

Đó chính là context mà **MASVS + MASWE + MASTG** cung cấp.

Và từ bài tiếp theo, chúng ta có thể rời khỏi phần framework để bắt đầu đi vào từng attack surface cụ thể của mobile application:

**Storage → Crypto → Authentication → Network → Platform → Code → Resilience → Privacy.**

## References

Các tài liệu chính thức từ **OWASP Mobile Application Security Project** được sử dụng trong bài viết:

1. [OWASP Mobile Application Security Testing Guide (MASTG)](https://mas.owasp.org/MASTG/)
2. [OWASP MASTG v2.0.0 Release — A New Era of Mobile Security Testing](https://mas.owasp.org/news/2026/07/04/mastg-v200-release/)
3. [OWASP MASTG Tests](https://mas.owasp.org/MASTG/tests/). Danh sách các Atomic Tests dành cho Android và iOS.
4. [MASTG-TEST-0204 — Insecure Random API Usage](https://mas.owasp.org/MASTG/tests/android/MASVS-CRYPTO/MASTG-TEST-0204/). Atomic Test được sử dụng làm ví dụ trong bài.
5. [MASTG-DEMO-0007 — Common Uses of Insecure Random APIs](https://mas.owasp.org/MASTG/demos/android/MASVS-CRYPTO/MASTG-DEMO-0007/MASTG-DEMO-0007/). Demo minh họa cho `MASTG-TEST-0204`.
6. [MASTG-BEST-0001 — Use Secure Random Number Generator APIs](https://mas.owasp.org/MASTG/best-practices/MASTG-BEST-0001/). Best Practice tương ứng với vấn đề insecure random number generation.
7. [OWASP Mobile Application Security Verification Standard (MASVS)](https://mas.owasp.org/MASVS/)
8. [OWASP Mobile Application Security Weakness Enumeration (MASWE)](https://mas.owasp.org/MASWE/)
9. [MASWE-0012 — Improper Random Number Generation](https://mas.owasp.org/MASWE/MASVS-CRYPTO/MASWE-0012/). Weakness được sử dụng xuyên suốt ví dụ trong bài.

## Series

- Previous: [OWASP MASWE Là Gì? Cầu Nối Giữa MASVS Và MASTG Trong Mobile Security](../02-owasp-maswe/index.md)
- Next: [Secure Storage trong Mobile App: Token, Credentials và Dữ liệu Nhạy cảm Nên Lưu Ở Đâu?](../04-secure-storage/index.md)
