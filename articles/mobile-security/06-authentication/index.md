---
title: "Authentication trên Mobile: OAuth 2.0, Tokens, Biometrics và Step-up Authentication"
description: "Tổng quan kiến trúc và thực thi bảo mật Authentication và Authorization cho ứng dụng mobile dựa trên chuẩn OWASP MASVS, OAuth 2.0 PKCE và NIST SP 800-63B."

date:
updated:

series: "Mobile Security"
series_order: 6

tags:
  - mobile-security
  - authentication
  - oauth2
  - owasp

status: draft
language: vi
---

# Authentication trên Mobile: OAuth 2.0, Tokens, Biometrics và Step-up Authentication

> **Tóm tắt:** Bài viết tổng hợp tư duy và thực thi bảo mật cho Authentication và Authorization trên ứng dụng mobile từ kinh nghiệm nghiên cứu các tiêu chuẩn OWASP MASVS/MASTG, OAuth 2.0 PKCE và NIST SP 800-63B. Nội dung đi từ bản chất của public client, luồng xác thực PKCE chống can thiệp authorization code, đến kỹ thuật bảo mật sinh trắc học (Biometric Authentication) gắn liền với Android Keystore và quy định thời hạn phiên làm việc theo cấp độ tin cậy.

*Thời gian đọc: ~10 phút*

---

## 1. Tổng quan và bức tranh toàn cảnh về Mobile Auth

Khi bắt đầu thiết kế cơ chế bảo mật cho ứng dụng di động, mình nhận ra một thực tế quan trọng: ứng dụng mobile về bản chất là một **public client**. Khác với các web application truyền thống chạy trên server (confidential client), ứng dụng mobile được cài đặt và thực thi trực tiếp trên thiết bị của người dùng. Điều này đồng nghĩa với việc người dùng hoặc kẻ tấn công có toàn quyền truy cập vào môi trường runtime, có thể decompile ứng dụng, can thiệp bộ nhớ hoặc theo dõi lưu lượng mạng.

Do đặc thù đó, kiến trúc bảo mật ứng dụng di động luôn bao gồm hai tầng xác thực độc lập nhưng phối hợp chặt chẽ với nhau:

1. **Remote Authentication & Authorization (Xác thực và phân quyền từ xa):** Quá trình ứng dụng chứng minh danh tính người dùng với server/Identity Provider (IdP) để nhận access token, refresh token cho việc truy cập API.
2. **Local Authentication (Xác thực cục bộ):** Quá trình ứng dụng xác minh người dùng đang cầm thiết bị (thông qua PIN, Pattern, Vân tay, Khuôn mặt) trước khi mở ứng dụng hoặc thực hiện các giao dịch nhạy cảm.

Để chuẩn hóa các yêu cầu này, các tổ chức an toàn thông tin hàng đầu đã đưa ra các bộ tiêu chuẩn cốt lõi:
- **OWASP MASVS (Mobile Application Security Verification Standard):** Định nghĩa danh mục `MASVS-AUTH` gồm các yêu cầu kiểm soát cho xác thực từ xa, xác thực cục bộ và xác thực bổ sung (Step-Up Authentication).
- **OAuth 2.0 với PKCE (RFC 7636):** Giao thức chuẩn hóa việc ủy quyền cho các public client trên mobile.
- **NIST SP 800-63B-4:** Hướng dẫn của Viện Tiêu chuẩn và Công nghệ Quốc gia Mỹ về quản lý định danh số, loại hình authenticator và các cấp độ tin cậy xác thực (AAL1, AAL2, AAL3).

---

## 2. Luồng xác thực từ xa: OAuth 2.0 với PKCE (RFC 7636)

### Vấn đề của Authorization Code Flow truyền thống trên mobile

Trong mô hình OAuth 2.0 tiêu chuẩn dành cho web server, Client ứng dụng gửi `Client Secret` cùng với Authorization Code để đổi lấy Access Token. Tuy nhiên, trên di động:
- Ứng dụng mobile không thể lưu trữ `Client Secret` một cách an toàn. Việc decompile ứng dụng sẽ dễ dàng làm lộ bí mật này, vì nó giống nhau trên mọi thiết bị cài đặt ứng dụng.
- Nếu không có `Client Secret`, kẻ tấn công chặn được Authorization Code (thông qua theo dõi giao tiếp hoặc đăng ký trùng Custom URI Scheme) có thể tự gửi yêu cầu đổi lấy Token.
- Việc sử dụng Custom URI Scheme (ví dụ `myapp://`) để nhận redirect code chứa nguy cơ bị ứng dụng độc hại trên cùng thiết bị đăng ký đè để đánh chặn Authorization Code. Do đó, các tổ chức như Auth0 khuyến cáo hạn chế dùng Custom URI Scheme, ưu tiên dùng Android App Links hoặc iOS Universal Links.

### Cách PKCE giải quyết vấn đề

PKCE (Proof Key for Code Exchange) bổ sung một bí mật động được tạo ra theo từng phiên đăng nhập bởi chính ứng dụng client, gọi là `code_verifier`. 

Sơ đồ hoạt động chi tiết của luồng PKCE:

```text
+-------------+                               +-------------------+
| Mobile App  |                               | Auth Server (IdP) |
+-------------+                               +-------------------+
       |                                                |
       | 1. Tạo code_verifier & code_challenge          |
       |----------------------------------------------->|
       |    Gửi GET /authorize (kèm code_challenge)     |
       |                                                |
       | 2. Đăng nhập & cấp quyền (Consent)             |
       |<-----------------------------------------------+
       |    Redirect về App kèm Authorization Code      |
       |                                                |
       | 3. Gửi POST /oauth/token                       |
       |----------------------------------------------->|
       |    (kèm Authorization Code + code_verifier)    |
       |                                                |
       | 4. Kiểm tra code_verifier với code_challenge   |
       |<-----------------------------------------------+
       |    Trả về Access Token (& Refresh Token)       |
```

1. **Khởi tạo:** SDK phía client tạo một chuỗi ngẫu nhiên cryptographically-random gọi là `code_verifier`. Từ `code_verifier`, client tính toán ra `code_challenge` (thông thường bằng thuật toán băm SHA-256 rồi mã hóa Base64URL).
2. **Yêu cầu mã ủy quyền:** Client gửi `code_challenge` lên endpoint `/authorize` của Authorization Server qua kết nối HTTPS. Server lưu trữ `code_challenge` này và trả về `Authorization Code` một lần.
3. **Trao đổi Token:** Client gửi `Authorization Code` cùng `code_verifier` ban đầu lên endpoint `/oauth/token`.
4. **Xác minh:** Authorization Server dùng thuật toán băm lại `code_verifier` và so sánh với `code_challenge` đã lưu trước đó. Nếu khớp, Server mới cấp ID Token, Access Token và Refresh Token.

Dù kẻ tấn công có đánh chặn được `Authorization Code`, chúng cũng không thể đổi lấy Token vì không có `code_verifier` vốn chỉ nằm trong bộ nhớ của ứng dụng hợp lệ.

Ngoài ra, khi kích hoạt **Refresh Token Rotation**, mỗi lần client dùng Refresh Token để lấy Access Token mới, Authorization Server sẽ thu hồi Refresh Token cũ và cấp một Refresh Token mới. Nếu Refresh Token cũ bị kẻ tấn công lạm dụng lại, server sẽ nhận biết và hủy toàn bộ chuỗi token liên quan.

---

## 3. Xác thực cục bộ và an toàn sinh trắc học (Local Biometric Auth)

Xác thực sinh trắc học (vân tay, khuôn mặt) giúp nâng cao trải nghiệm người dùng trên thiết bị di động. Tuy nhiên, theo OWASP MASTG, nếu triển khai sai cách, cơ chế này rất dễ bị vượt qua.

### Phân biệt hai mô hình triển khai Biometric trên Android

#### Mô hình 1: Prompt-Based Authentication (Không an toàn)

Trong mô hình này, ứng dụng gọi API hệ thống (`BiometricPrompt`) để hiển thị hộp thoại quét vân tay/khuôn mặt. Kết quả trả về cho ứng dụng đơn thuần là một sự kiện callback dạng boolean (`onAuthenticationSucceeded`).

```text
[Người dùng] -> (BiometricPrompt) -> [Callback Success] -> [Mở màn hình chính / 
Gọi API]
```

- **Điểm yếu:** Logic kiểm tra hoàn toàn phụ thuộc vào mã ứng dụng ở lớp phần mềm. Kẻ tấn công có thể sử dụng các công cụ đụng độ runtime như Frida hoặc Xposed để hook vào phương thức callback, ép trả về `true` mà không cần quét sinh trắc học thực sự.

#### Mô hình 2: Keystore-Backed Authentication (Chuẩn an toàn)

Mô hình này liên kết việc quét sinh trắc học với việc giải phóng một khóa mật mã (Cryptographic Key) lưu trong **Android Keystore** (được bảo vệ bởi phần cứng an toàn TEE hoặc Secure Element).

```text
[Android Keystore (TEE)]
       | (Khóa bị khóa)
       v
[BiometricPrompt + CryptoObject] -> Quét thành công -> Giải phóng khóa -> 
[Ký/Giải mã Data/Token]
```

1. Ứng dụng tạo cặp khóa bất đối xứng trong Android Keystore, yêu cầu quyền xác thực người dùng để sử dụng khóa.
2. Khi xác thực, ứng dụng truyền một đối tượng `BiometricPrompt.CryptoObject` (bọc `Cipher`, `Signature`, hoặc `Mac`) vào `BiometricPrompt`.
3. Chỉ khi phần cứng TEE xác nhận quét sinh trắc học hợp lệ, khóa mật mã mới được mở để thực hiện thao tác ký hoặc giải mã dữ liệu (ví dụ: giải mã Access Token được lưu mã hóa dưới bộ nhớ local).
4. Kẻ tấn công nếu dùng Frida để bypass giao diện prompt thì vẫn không thể có được dữ liệu đã giải mã vì phần cứng TEE chưa hề giải phóng khóa mật mã.

### Các tham số cấu hình quan trọng trong Keystore

Khi cấu hình khóa bằng `KeyGenParameterSpec.Builder`, developer cần chú ý hai thiết lập bảo mật cốt lõi:

- **`setUserAuthenticationParameters(int timeout, int type)`:** Quy định khoảng thời gian khóa có hiệu lực sau khi xác thực. Nếu đặt `timeout = 0`, hệ thống bắt buộc người dùng phải quét sinh trắc học cho *mỗi* thao tác mật mã riêng biệt.
- **`setInvalidatedByBiometricEnrollment(true)`:** Khóa mật mã sẽ tự động bị hủy (invalidate) nếu người dùng đăng ký thêm một dấu vân tay hoặc khuôn mặt mới vào hệ thống OS. Điều này ngăn chặn kịch bản kẻ tấn công nhặt được máy đang mở khóa, tự thêm vân tay của mình vào cài đặt máy rồi mở ứng dụng.

---

## 4. Các yêu cầu kiểm soát theo OWASP MASVS-AUTH & NIST SP 800-63B

### OWASP MASVS-AUTH (V2) Checklist

Bộ tiêu chuẩn OWASP MASVS phân chia yêu cầu xác thực và phân quyền thành 3 nhóm kiểm soát chính:

| Yêu cầu MASVS | Nội dung kiểm soát | Trọng tâm kỹ thuật |
| :--- | :--- | :--- |
| **MASVS-AUTH-1** | App sử dụng giao thức xác thực & phân quyền an toàn theo best practices. | Triển khai OAuth 2.0 với PKCE, không hardcode client secret, xác thực phân quyền thực thi trên server. |
| **MASVS-AUTH-2** | App thực hiện local authentication an toàn theo khuyến nghị nền tảng. | Sử dụng Android Keystore / iOS Keychain có ràng buộc CryptoObject, xử lý vô hiệu hóa khi thay đổi sinh trắc học. |
| **MASVS-AUTH-3** | App bảo vệ các thao tác nhạy cảm bằng xác thực bổ sung (Step-Up Auth). | Yêu cầu nhập lại PIN/biometric khi thực hiện chuyển tiền, đổi thông tin tài khoản, hoặc ký giao dịch critical. |

### Cấp độ tin cậy theo NIST SP 800-63B-4

NIST SP 800-63B định nghĩa ba Cấp độ Tin cậy Xác thực (Authentication Assurance Levels - AAL):

- **AAL1:** Cung cấp mức độ tin cậy cơ bản. Cho phép xác thực đơn tố (single-factor) hoặc đa tố.
- **AAL2:** Yêu cầu xác thực đa tố (MFA) dựa trên các thuật toán mật mã đã phê chuẩn. Bắt buộc phải có ít nhất một yếu tố vật lý ("something you have").
  - *Thời gian phiên làm việc:* NIST SP 800-63B quy định thời gian giới hạn phiên tổng thể (overall timeout) nên **<= 24 giờ**, và thời gian tự động đăng xuất khi không hoạt động (inactivity timeout) nên **<= 1 giờ**.
- **AAL3:** Cung cấp mức độ tin cậy rất cao. Yêu cầu xác thực mật mã đa tố dựa trên phần cứng (hardware-backed) chống lại tấn công giả mạo (phishing-resistant). Khóa mật mã không được phép xuất ra ngoài (non-exportable keys).

> **Lưu ý cốt lõi từ NIST SP 800-63B-4:** Đặc điểm sinh trắc học (biometric characteristic) **không được coi là một authenticator độc lập**. Sinh trắc học đóng vai trò là yếu tố kích hoạt (activation factor - "something you are") cho một thiết bị vật lý chứa khóa mật mã ("something you have"). Đồng thời, NIST khuyến nghị ưu tiên xác thực sinh trắc học cục bộ (local verification) thay vì gửi dữ liệu sinh trắc học về so sánh tập trung tại server.

---

## 5. Những rủi ro và sai lầm phổ biến khi triển khai

Trong quá trình xem xét mã nguồn và kiểm thử bảo mật, mình nhận thấy một số lỗ hổng thường gặp (MASWE - Mobile Application Security Weakness Enumeration):

1. **Triển khai Biometric chỉ ở lớp UI (`MASWE-0020`):** Chỉ dựa vào kết quả callback của `BiometricPrompt` mà không dùng `CryptoObject` gắn với Keystore, khiến ứng dụng dễ dàng bị bypass bằng Frida script.
2. **Khóa mật mã không bị hủy khi đăng ký sinh trắc học mới (`MASWE-0022`):** Không cấu hình `setInvalidatedByBiometricEnrollment(true)`, tạo điều kiện cho kẻ tấn công thêm vân tay mới vào OS để truy cập ứng dụng.
3. **Cho phép Fallback về PIN/Password thiết bị không kiểm soát (`MASWE-0021`):** Đối với các giao dịch nhạy cảm tài chính đòi hỏi tính chống chối bỏ (non-repudiation), việc cho phép fallback về PIN màn hình khóa của thiết bị có thể làm giảm mức độ an toàn nếu kẻ gian đã biết PIN máy.
4. **Thiếu Step-Up Authentication (`MASWE-0023`):** Người dùng chỉ cần đăng nhập một lần ở đầu phiên, sau đó có thể thực hiện mọi thao tác nguy hiểm (chuyển tiền, thay đổi mật khẩu, xóa tài khoản) mà không bị yêu cầu xác thực lại.
5. **Nhầm lẫn giữa Access Token và sự hiện diện của người dùng (`MASWE-0024`):** Coi sự tồn tại của Access Token hoặc Cookie là bằng chứng cho thấy người dùng đang ngồi trước màn hình di động, dẫn đến không kiểm soát inactivity timeout.

---

## 6. Hướng dẫn áp dụng thực tế cho Mobile Developer

Dựa trên các nguồn chuẩn mực, đây là luồng triển khai đề xuất khi xây dựng tính năng Auth cho ứng dụng mobile:

### Bước 1: Triển khai luồng đăng nhập từ xa
- Sử dụng SDK OAuth 2.0 / OpenID Connect chuẩn hỗ trợ PKCE.
- Khi gọi `/authorize`, tạo `code_verifier` ngẫu nhiên có độ dài đủ lớn và gửi `code_challenge = Base64URL(SHA256(code_verifier))`.
- Sử dụng App Links (Android) hoặc Universal Links (iOS) để xử lý redirect URI thay vì Custom URI Scheme.
- Lưu trữ Access Token và Refresh Token vào bộ nhớ mã hóa an toàn (EncryptedSharedPreferences trên Android hoặc Keychain Services trên iOS).

### Bước 2: Triển khai Local Biometric Auth gắn Keystore
- Khi người dùng bật tính năng "Đăng nhập bằng vân tay":
  1. Tạo khóa AES-256 trong Android Keystore với cấu hình:
     - `setUserAuthenticationRequired(true)`
     - `setUserAuthenticationParameters(0, KeyProperties.AUTH_BIOMETRIC_STRONG)`
     - `setInvalidatedByBiometricEnrollment(true)`
  2. Dùng khóa này để mã hóa Token phiên làm việc.
- Khi người dùng thực hiện đăng nhập lại bằng vân tay:
  1. Khởi tạo đối tượng `Cipher` ở chế độ giải mã (`Cipher.DECRYPT_MODE`).
  2. Tạo `BiometricPrompt.CryptoObject(cipher)`.
  3. Truyền `CryptoObject` vào `biometricPrompt.authenticate(promptInfo, cryptoObject)`.
  4. Trong callback `onAuthenticationSucceeded`, lấy `cipher` từ `result.cryptoObject` để giải mã Token.

### Bước 3: Quản lý phiên làm việc & Step-Up Authentication
- Cài đặt Inactivity Timer trong ứng dụng: Nếu người dùng không tương tác trong vòng 15-30 phút (hoặc ứng dụng xuống background quá thời gian quy định), xóa session tạm thời trong RAM và yêu cầu xác thực lại local auth.
- Yêu cầu Step-Up Authentication (`MASVS-AUTH-3`) bằng việc hiển thị lại `BiometricPrompt` hoặc gửi OTP/PIN khi người dùng thực hiện các hành động nhạy cảm.

---

## Kết luận

Bảo mật Authentication và Authorization trên ứng dụng di động không chỉ đơn thuần là việc thiết kế giao diện đăng nhập hay gọi vài câu lệnh SDK hệ thống. Điều cốt lõi mình rút ra được là: **không bao giờ tin tưởng hoàn toàn vào môi trường phần mềm của thiết bị di động**.

Một giải pháp bảo mật di động vững chắc phải kết hợp được tính đúng đắn của giao thức mạng (sử dụng OAuth 2.0 với PKCE để bảo vệ luồng xác thực từ xa) với khả năng bảo vệ phần cứng của thiết bị (sử dụng Android Keystore/iOS Keychain bọc `CryptoObject` cho xác thực cục bộ). Việc tuân thủ đầy đủ các checklist từ OWASP MASVS và khung thời gian session theo NIST SP 800-63B sẽ giúp ứng dụng giảm thiểu tối đa các rủi ro can thiệp runtime và bảo vệ an toàn cho tài sản của người dùng.

---

## References

- [Authorization Code Flow with Proof Key for Code Exchange (PKCE) - Auth0 Docs](https://auth0.com/docs/get-started/authentication-and-authorization-flow/authorization-code-flow-with-pkce)
- [NIST SP 800-63B-4: Digital Identity Guidelines - Authentication and Authenticator Management](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-63B-4.pdf)
- [MASVS-AUTH: Authentication and Authorization - OWASP Mobile Application Security](https://mas.owasp.org/MASVS/07-MASVS-AUTH/)
- [MASVS-AUTH-1 - OWASP Mobile Application Security](https://mas.owasp.org/MASVS/controls/MASVS-AUTH-1/)
- [MASVS-AUTH-2 - OWASP Mobile Application Security](https://mas.owasp.org/MASVS/controls/MASVS-AUTH-2/)
- [MASVS-AUTH-3 - OWASP Mobile Application Security](https://mas.owasp.org/MASVS/controls/MASVS-AUTH-3/)
- [MASTG-KNOW-0001: Biometric Authentication - OWASP Mobile Application Security](https://mas.owasp.org/MASTG/knowledge/android/MASVS-AUTH/MASTG-KNOW-0001/)
- [MASTG-TEST-0064: Testing Biometric Authentication - OWASP Mobile Application Security](https://mas.owasp.org/MASTG/tests/ios/MASVS-AUTH/MASTG-TEST-0064/)

## Series

- Previous: [Mobile Cryptography: Hiểu Đúng Về Encryption, Cryptographic Keys và Key Management](../05-mobile-cryptography/index.md)
- Next: [Network Security trên Mobile: TLS, Certificate Pinning và Man-in-the-Middle Attack](../07-network-security/index.md)

