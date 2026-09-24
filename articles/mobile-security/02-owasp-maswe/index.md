---
title: "OWASP MASWE Là Gì? Cầu Nối Giữa MASVS Và MASTG Trong Mobile Security"
description: "Nếu MASVS cho chúng ta biết một ứng dụng mobile cần đảm bảo điều gì, còn MASTG hướng dẫn cách kiểm thử, thì MASWE nằm ở giữa: mô tả cụ thể những điểm yếu nào có thể khiến ứng dụng vi phạm các yêu cầu đó. Trong bài viết này, chúng ta sẽ tìm hiểu Mobile Application Security Weakness Enumeration (MASWE), sự khác nhau giữa weakness và vulnerability, cũng như cách MASWE kết nối MASVS với MASTG trong thực tế."

date: 2026-09-24
updated: 2026-09-24

series: "Mobile Security"
series_order: 2

tags:
  - owasp
  - maswe
  - mobile-security

status: published
language: vi
---

# OWASP MASWE Là Gì? Cầu Nối Giữa MASVS Và MASTG Trong Mobile Security

> **Tóm tắt:** Nếu MASVS cho chúng ta biết một ứng dụng mobile **cần đảm bảo điều gì**, còn MASTG hướng dẫn **cách kiểm thử**, thì MASWE nằm ở giữa: mô tả cụ thể **những điểm yếu nào có thể khiến ứng dụng vi phạm các yêu cầu đó**.
>
> Trong bài viết này, chúng ta sẽ tìm hiểu **Mobile Application Security Weakness Enumeration (MASWE)**, sự khác nhau giữa *weakness* và *vulnerability*, cũng như cách MASWE kết nối MASVS với MASTG trong thực tế.

*Thời gian đọc: ~6 phút*

---

## 1. Từ MASVS đến một câu hỏi thực tế hơn

Ở [bài trước về OWASP MASVS](../01-owasp-masvs/index.md), chúng ta đã tìm hiểu 8 nhóm kiểm soát bảo mật dành cho mobile application:

```text
STORAGE
CRYPTO
AUTH
NETWORK
PLATFORM
CODE
RESILIENCE
PRIVACY
```

MASVS rất hữu ích khi chúng ta muốn trả lời:

> **Một ứng dụng mobile an toàn cần đáp ứng những yêu cầu nào?**

Ví dụ, `MASVS-CRYPTO-1` yêu cầu ứng dụng sử dụng cryptography hiện đại và tuân theo các industry best practices.

Nhưng với developer, một câu hỏi khác ngay lập tức xuất hiện:

> **"Vậy code như thế nào thì bị coi là vi phạm yêu cầu này?"**

Chúng ta có thể gặp hàng loạt trường hợp:

```text
Weak random number generator
Hard-coded encryption key
Broken encryption algorithm
Reused initialization vector
Incorrect certificate validation
Sensitive data written to logs
Unsafe deep link handling
```

MASVS cố tình không đi sâu đến mức này. Nó là **verification standard**, không phải catalogue của từng lỗi implementation.

Đó chính là khoảng trống mà **MASWE** giải quyết.

---

## 2. MASWE là gì?

**MASWE — Mobile Application Security Weakness Enumeration** là catalogue chuẩn hóa các security và privacy weaknesses dành riêng cho mobile application.

Có thể hình dung ba thành phần như sau:

```text
MASVS
  │
  │ What should be secure?
  ▼
MASWE
  │
  │ What can go wrong?
  ▼
MASTG
  │
  │ How do we test it?
  ▼
Actual Application
```

Ví dụ:

```text
MASVS-CRYPTO-1
Ứng dụng phải sử dụng cryptography an toàn
        │
        ▼
MASWE-0012
Improper Random Number Generation
        │
        ▼
MASTG Tests
Kiểm tra ứng dụng có sử dụng
insecure random APIs hay không
```

MASWE vì vậy không thay thế MASVS hay MASTG.

Nó **kết nối hai thứ đó lại với nhau**.

---

## 3. Weakness khác Vulnerability như thế nào?

Đây là một distinction khá quan trọng khi học application security.

Hai từ **weakness** và **vulnerability** thường được sử dụng thay thế nhau trong giao tiếp hàng ngày, nhưng về mặt security chúng không hoàn toàn giống nhau.

### Weakness

Weakness là một lỗi hoặc điều kiện không an toàn tồn tại trong:

```text
Design
Architecture
Implementation
Configuration
```

Nó **có khả năng** dẫn đến một vấn đề bảo mật.

Ví dụ:

```java
Random random = new Random();
int token = random.nextInt();
```

`java.util.Random` không phải cryptographically secure PRNG.

Nếu giá trị này được sử dụng trong security-sensitive context, chẳng hạn để tạo authentication token, đây là:

```text
MASWE-0012
Improper Random Number Generation
```

---

### Vulnerability

Một weakness trở thành vấn đề nghiêm trọng hơn khi tồn tại các điều kiện khiến attacker có thể khai thác nó và gây ra security impact.

Ví dụ:

```text
Weak PRNG
   │
   ▼
Predictable token
   │
   ▼
Attacker predicts a valid token
   │
   ▼
Unauthorized access
```

Có thể hiểu đơn giản:

```text
Weakness
   +
Exploitable Conditions
   ↓
Potential Vulnerability
   ↓
Security Impact
```

Điểm quan trọng ở đây là **MASWE tập trung vào nguyên nhân kỹ thuật của vấn đề**, thay vì chỉ mô tả kết quả cuối cùng của một cuộc tấn công.

Điều này đặc biệt hữu ích với developer, bởi thứ chúng ta cần sửa thường chính là **root cause trong implementation**.

---

## 4. MASWE v1.0.0 có gì?

MASWE v1.0.0 là phiên bản stable đầu tiên của catalogue.

Nó bao gồm **78 weaknesses**, được đánh số liên tục:

```text
MASWE-0001
...
MASWE-0078
```

và được tổ chức theo chính 8 categories của MASVS:

| MASVS Category | MASWE IDs | Số lượng |
| --- | --- | ---: |
| STORAGE | `0001–0006` | 6 |
| CRYPTO | `0007–0017` | 11 |
| AUTH | `0018–0025` | 8 |
| NETWORK | `0026–0028` | 3 |
| PLATFORM | `0029–0040` | 12 |
| CODE | `0041–0050` | 10 |
| RESILIENCE | `0051–0065` | 15 |
| PRIVACY | `0066–0078` | 13 |

Điều này khiến việc navigate khá trực quan.

Nhìn vào:

```text
MASWE-0012
```

chúng ta có thể biết weakness này thuộc nhóm **CRYPTO**.

Còn:

```text
MASWE-0044
```

thuộc nhóm **CODE**.

---

## 5. Một MASWE entry chứa những gì?

MASWE không đơn giản chỉ là danh sách tên lỗi.

Một weakness thường cung cấp context giúp chúng ta hiểu:

```text
What is the weakness?
        ↓
How is it introduced?
        ↓
What can happen?
        ↓
How can we prevent it?
        ↓
How can we test it?
```

Các phần quan trọng gồm:

### Overview

Giải thích bản chất của weakness.

Ví dụ với:

```text
MASWE-0012
Improper Random Number Generation
```

vấn đề xảy ra khi ứng dụng sử dụng một non-cryptographic PRNG hoặc predictable seed để tạo các giá trị được sử dụng trong security context.

---

### Modes of Introduction

Đây là phần đặc biệt hữu ích cho developer.

Nó trả lời:

> **Weakness này thường được đưa vào codebase bằng cách nào?**

Ví dụ có thể là:

```text
Using insecure APIs
Incorrect configuration
Missing validation
Improper key management
Unsafe platform usage
```

Thay vì chỉ biết rằng *"ứng dụng có lỗi security"*, developer có thể xác định **coding practice nào tạo ra lỗi đó**.

---

### Impact

Nếu weakness bị khai thác, chuyện gì có thể xảy ra?

Ví dụ:

```text
Sensitive Data Exposure
Authentication Bypass
Unauthorized Actions
Code Execution
Privacy Violation
```

Điều này giúp team hiểu tại sao một vấn đề cần được ưu tiên.

---

### Mitigations

Cuối cùng là cách ngăn chặn hoặc sửa weakness.

Ví dụ:

```text
Use secure platform APIs
Validate untrusted input
Use cryptographically secure PRNG
Minimize exposed components
Update vulnerable dependencies
```

Vì vậy MASWE không chỉ hữu ích cho pentester.

Nó cũng có thể được sử dụng như một **secure coding reference dành cho developer**.

---

## 6. Ví dụ thực tế: Improper Random Number Generation

Hãy xem lại `MASWE-0012`.

Giả sử developer cần tạo một security-sensitive random value.

Implementation:

```java
Random random = new Random();
long value = random.nextLong();
```

Vấn đề là `java.util.Random` được thiết kế cho general-purpose randomness, không phải cryptography.

Nếu output được dùng cho:

```text
Session Token
Reset Token
Cryptographic Nonce
Security Challenge
```

attacker có thể có khả năng dự đoán output trong một số điều kiện.

MASWE phân loại vấn đề này thành:

```text
MASWE-0012
Improper Random Number Generation
```

và ánh xạ nó tới:

```text
MASVS-CRYPTO-1
```

Một implementation phù hợp hơn cho security-sensitive randomness trên Java/Android thường sử dụng:

```java
SecureRandom secureRandom = new SecureRandom();

byte[] token = new byte[32];
secureRandom.nextBytes(token);
```

Điều thú vị ở đây là MASVS không cần nói:

> "Không được sử dụng `java.util.Random`."

MASVS chỉ định nghĩa **security requirement**.

MASWE mô tả **weakness**.

MASTG sau đó có thể cung cấp **test methodology** để phát hiện implementation không an toàn.

---

## 7. Traceability Chain: Phần quan trọng nhất của MASWE

Đây có lẽ là lý do lớn nhất MASWE tồn tại.

OWASP MAS hiện xây dựng một traceability chain:

```text
MASVS Control
      ↓
MASWE Weakness
      ↓
MASTG Test
      ↓
MASTG Demo
```

Hãy hiểu từng layer.

### Layer 1 — MASVS

```text
What should be secure?
```

Định nghĩa security requirement.

### Layer 2 — MASWE

```text
What can go wrong?
```

Định nghĩa weakness có thể khiến requirement bị vi phạm.

### Layer 3 — MASTG Test

```text
How do we detect it?
```

Định nghĩa test methodology.

### Layer 4 — MASTG Demo

```text
What does this look like in practice?
```

Cung cấp code và demonstration có thể tái hiện.

---

### Một ví dụ

```text
MASVS-CRYPTO-1
      │
      ▼
MASWE-0012
Improper Random Number Generation
      │
      ▼
MASTG Test
Detect insecure random API usage
      │
      ▼
MASTG Demo
Vulnerable code + testing technique
```

Đây là một improvement khá lớn so với việc có ba bộ tài liệu tồn tại độc lập.

Chúng ta có thể đi **từ requirement xuống code**, hoặc theo chiều ngược lại:

```text
Found insecure code
        ↓
Which MASWE?
        ↓
Which MASVS requirement?
        ↓
What security requirement is violated?
```

---

## 8. Không phải MASWE nào cũng đã có MASTG Test

Một chi tiết quan trọng cần hiểu là:

> **Có MASWE không đồng nghĩa đã có automated/manual MASTG Test tương ứng.**

MASWE định nghĩa **weakness**.

MASTG phải định nghĩa một phương pháp **reliable và reproducible** để kiểm tra weakness đó.

Hai công việc này không giống nhau.

Ví dụ, có những weakness khá dễ kiểm tra bằng static analysis:

```text
Insecure API usage
Hard-coded configuration
Exported component
```

Nhưng những vấn đề liên quan đến:

```text
Privacy
Business Logic
Complex Authentication Flow
Architecture
```

có thể cần nhiều context hơn.

Vì vậy, nếu chưa tồn tại MASTG Test, tester vẫn có thể:

```text
Read MASWE
    ↓
Understand Modes of Introduction
    ↓
Check related MASTG techniques
    ↓
Design an appropriate manual test
```

MASWE vẫn cung cấp điểm xuất phát cho quá trình security review.

---

## 9. MASWE hữu ích với Developer như thế nào?

Ban đầu mình nghĩ MASWE chủ yếu dành cho security tester.

Nhưng khi nhìn vào cấu trúc của nó, mình thấy nó khá hữu ích với developer.

Thay vì học security theo kiểu:

```text
"Don't do this."
```

MASWE cho chúng ta context:

```text
What is wrong?
        ↓
Why is it wrong?
        ↓
How was it introduced?
        ↓
What could happen?
        ↓
How should we prevent it?
```

Điều này phù hợp với tư duy **Shift-Left Security**.

Thay vì:

```text
Write Code
   ↓
Release Candidate
   ↓
Security Test
   ↓
Find 30 Issues
   ↓
Fix Everything
```

chúng ta muốn:

```text
Understand Weaknesses
        ↓
Design Securely
        ↓
Write Secure Code
        ↓
Automated Checks
        ↓
Security Testing
        ↓
Release
```

Security không còn là một bước kiểm tra ở cuối development lifecycle.

---

## 10. MASWE hữu ích với Security Tester như thế nào?

Với pentester hoặc security reviewer, MASWE tạo ra một **common vocabulary** để mô tả findings.

Thay vì viết:

```text
Finding:
The application uses insecure randomness.
```

report có thể tham chiếu:

```text
MASWE-0012
Improper Random Number Generation

Mapped Control:
MASVS-CRYPTO-1
```

Điều này giúp finding dễ:

```text
Classify
Track
Communicate
Remediate
```

hơn giữa security team và development team.

---

## 11. MASWE hữu ích với DevSecOps như thế nào?

Traceability cũng mở ra khả năng tích hợp security findings vào development workflow.

Ví dụ:

```text
SAST / Dependency Scanner / Security Review
                    │
                    ▼
               Finding
                    │
                    ▼
              MASWE Mapping
                    │
                    ▼
             MASVS Control
                    │
                    ▼
              Jira / Backlog
                    │
                    ▼
              Remediation
```

Ví dụ dependency scanner phát hiện một thư viện có known vulnerability.

Finding có thể được map tới:

```text
MASWE-0044
Dependencies with Known Vulnerabilities
```

và tiếp tục map tới:

```text
MASVS-CODE-3
```

Khi cùng một loại weakness liên tục xuất hiện qua nhiều release, team cũng có thể nhận ra rằng đây không còn là một bug đơn lẻ mà có thể là vấn đề trong:

```text
Coding Guidelines
Architecture
Code Review
Developer Training
CI/CD Controls
```

---

## 12. MASWE và CWE có giống nhau không?

Nếu từng làm application security, có thể bạn đã gặp:

**CWE — Common Weakness Enumeration.**

CWE là catalogue weakness rất rộng cho software nói chung.

MASWE tập trung vào **mobile application security**.

Hai hệ thống không cạnh tranh với nhau.

MASWE có mapping tới CWE để kết nối mobile-specific security knowledge với hệ sinh thái software security rộng hơn.

Ví dụ:

```text
MASWE-0012
Improper Random Number Generation

        ↓ maps to

CWE-332
Insufficient Entropy in PRNG

CWE-337
Predictable Seed in PRNG

CWE-338
Use of Cryptographically Weak PRNG
```

Có thể hình dung:

```text
CWE
│
│ General software weaknesses
│
└───────────────┐
                │
              MASWE
                │
                │ Mobile-specific context
                ▼
         Android / iOS Apps
```

MASWE giúp đưa các khái niệm security tổng quát xuống context cụ thể của mobile development.

---

## Kết luận

Sau khi tìm hiểu MASVS ở bài trước, mình từng hình dung hệ sinh thái OWASP Mobile Security đơn giản là:

```text
MASVS
"What should we secure?"

        ↓

MASTG
"How do we test it?"
```

MASWE bổ sung layer quan trọng ở giữa:

```text
MASVS
Security Requirements
        ↓
MASWE
Security Weaknesses
        ↓
MASTG
Testing Methodology
        ↓
MASTG Demos
Reproducible Examples
```

Với mình, cách dễ nhớ nhất là:

```text
MASVS → What should be secure?

MASWE → What can go wrong?

MASTG → How do we test it?
```

Và đây cũng là lý do MASWE hữu ích với developer.

Thay vì chỉ biết rằng **"code này không secure"**, chúng ta có thể lần ngược lại:

```text
Code
 ↓
Weakness
 ↓
Security Impact
 ↓
MASVS Requirement
 ↓
Mitigation
```

Khi security được nhìn theo cách này, nó không còn chỉ là một checklist mà security team đưa cho developer trước ngày release.

Nó trở thành một phần của cách chúng ta **design và write software ngay từ đầu**.

## References

- [OWASP MASWE](https://mas.owasp.org/MASWE/)
- [MASWE v1.0.0 release announcement](https://mas.owasp.org/news/2026/08/17/maswe-v100-release/)
- [MASWE v1.0.0 on GitHub](https://github.com/OWASP/maswe/releases/tag/v1.0.0)
- [OWASP MASVS](https://mas.owasp.org/MASVS/)
- [OWASP MASTG](https://mas.owasp.org/MASTG/)
- [CWE-332: Insufficient Entropy in PRNG](https://cwe.mitre.org/data/definitions/332.html)
- [CWE-337: Predictable Seed in Pseudo-Random Number Generator (PRNG)](https://cwe.mitre.org/data/definitions/337.html)
- [CWE-338: Use of Cryptographically Weak Pseudo-Random Number Generator (PRNG)](https://cwe.mitre.org/data/definitions/338.html)

## Series

- Previous: [OWASP MASVS v2.1.0: Khung Tiêu Chuẩn Bảo Mật Cho Ứng Dụng Di Động](../01-owasp-masvs/index.md)
- Next: [OWASP MASTG Là Gì? Từ Security Requirement Đến Thực Tế Kiểm Thử Mobile](../03-owasp-mastg/index.md)
