---
title: "Secure Storage trong Mobile App: Token, Credentials và Dữ liệu Nhạy cảm Nên Lưu Ở Đâu?"
description: "Tổng hợp toàn bộ kiến thức về Secure Storage trên Android và iOS dựa trên tiêu chuẩn OWASP MASVS và MASTG, giải thích cơ chế mã hóa dữ liệu cục bộ và phòng ngừa các con đường rò rỉ thông tin."

date:
updated:

series: "Mobile Security"
series_order: 4

tags:
  - mobile-security
  - secure-storage
  - owasp-masvs
  - android-ios

status: draft
language: vi
---

# Secure Storage trong Mobile App: Token, Credentials và Dữ liệu Nhạy cảm Nên Lưu Ở Đâu?

> **Tóm tắt:** Khi phát triển ứng dụng di động, việc lưu trữ token, credentials và dữ liệu nhạy cảm cục bộ là yêu cầu phổ biến. Tuy nhiên, nếu lưu trữ không đúng cách trong SharedPreferences hay UserDefaults không mã hóa, dữ liệu rất dễ bị trích xuất. Bài viết này tổng hợp góc nhìn của mình sau khi nghiên cứu tiêu chuẩn OWASP MASVS-STORAGE, phân tích kiến trúc Android KeyStore, iOS Keychain, cũng như các nguy cơ rò rỉ dữ liệu qua backup, logs, và process memory.

*Thời gian đọc: ~8 phút*

---

## 1. Secure Storage là gì và vì sao nó tồn tại trên Mobile?

### Secure Storage là gì?

Secure Storage trên thiết bị di động là tập hợp các cơ chế, API và thành phần phần cứng/phần mềm do hệ điều hành (Android và iOS) cung cấp nhằm mã hóa và bảo vệ dữ liệu nhạy cảm ở trạng thái nghỉ (data-at-rest) lưu trữ cục bộ trên thiết bị.

### Vì sao nó tồn tại?

Khi phát triển ứng dụng mobile, mình nhận thấy ứng dụng vận hành trong một môi trường mà thiết bị nằm hoàn toàn trong tay người dùng hoặc kẻ tấn công. Mặc dù iOS và Android đều áp dụng cơ chế OS sandboxing để cô lập vùng nhớ và file hệ thống của từng ứng dụng, nhưng môi trường di động đối mặt với nhiều rủi ro đặc thù:

- Thiết bị có thể bị chiếm quyền quản trị (root hoặc jailbreak), làm vô hiệu hóa hàng rào bảo vệ mặc định của sandbox.
- Thiết bị có thể bị thất lạc, mất trộm hoặc bị phân tích tĩnh/động bằng các công cụ reverse engineering và runtime instrumentation như Frida.
- Các tác dụng phụ của API hệ thống (như tự động sao lưu, ghi log, chụp ảnh màn hình) có thể vô tình đưa dữ liệu ra khỏi phạm vi cô lập của ứng dụng.

Do đó, cơ chế cô lập sandbox mặc định là chưa đủ đối với các dữ liệu có độ rủi ro cao. Secure Storage tồn tại như một lớp phòng thủ mật mã chuyên sâu (defense-in-depth) bắt buộc.

---

## 2. Vấn đề cốt lõi mà Secure Storage giải quyết

Trong bộ tiêu chuẩn kiểm thử an ninh di động OWASP MASVS (Mobile Application Security Verification Standard), nhóm kiểm soát **MASVS-STORAGE** giải quyết hai nhóm bài toán an toàn thông tin trọng tâm:

```text
┌─────────────────────────────────────────────────────────┐
│                 OWASP MASVS-STORAGE                     │
└────────────────────────────┬────────────────────────────┘
                             │
            ┌────────────────┴────────────────┐
            │                                 │
┌───────────▼───────────┐         ┌───────────▼───────────┐
│   MASVS-STORAGE-1     │         │   MASVS-STORAGE-2     │
│ Secure Local Storage  │         │ Prevent Data Leakage  │
└───────────────────────┘         └───────────────────────┘
```

1. **`MASVS-STORAGE-1` — Bảo vệ dữ liệu chủ động:** Đảm bảo mọi dữ liệu nhạy cảm do ứng dụng chủ động lưu trữ (như session token, mật khẩu, tài liệu mật mã, PII, API key) đều được mã hóa bằng các thuật toán mạnh theo tiêu chuẩn ngành và quản lý khóa an toàn, bất kể dữ liệu nằm trong sandbox riêng tư hay vùng nhớ dùng chung.
2. **`MASVS-STORAGE-2` — Phòng ngừa rò rỉ thụ động:** Ngăn chặn việc dữ liệu nhạy cảm bị vô tình ghi nhận hoặc để lộ ra các vị trí công cộng do tác dụng phụ của hệ điều hành hoặc các API ngoài ý muốn (system logs, automated backups, keyboard cache, screenshots hay process memory).

---

## 3. Secure Storage hoạt động như thế nào trên Android và iOS?

### Kiến trúc trên nền tảng Android

Trên Android, hệ điều hành cung cấp nhiều API lưu trữ dữ liệu cục bộ với mức độ an toàn khác nhau:

- **Lưu trữ thông thường (Unencrypted):** `SharedPreferences`, `Android DataStore`, `SQLite Database`, `Room Database`. Các file này được lưu dưới dạng văn bản rõ hoặc database chưa mã hóa trong thư mục riêng tư của ứng dụng (`/data/data/<package_name>/`). Khi thiết bị bị root, kẻ tấn công có thể truy cập trực tiếp bằng lệnh `adb shell` và đọc dữ liệu.
- **Giải pháp Secure Storage:** Sử dụng `EncryptedSharedPreferences` hoặc `SQLCipher Database` kết hợp với **Android KeyStore**.

Dự án OWASP MAS (tài liệu `MASTG-KNOW-0047`) phân loại thứ tự an toàn khi lưu trữ khóa mật mã (Cryptographic Key Storage) trên Android từ cao xuống thấp như sau:

1. Khóa được lưu trong hardware-backed Android KeyStore (như TEE hoặc StrongBox).
2. Toàn bộ khóa được lưu trên máy chủ từ xa và chỉ truy cập sau khi xác thực mạnh.
3. Master key lưu trên server dùng để mã hóa các khóa khác lưu trong `SharedPreferences`.
4. Khóa được sinh ra mỗi lần từ passphrase mạnh của người dùng kết hợp với salt đủ độ dài (PBKDF2).
5. Khóa được lưu trong software implementation của Android KeyStore.
6. Master key lưu trong software Keystore dùng để mã hóa các khóa trong `SharedPreferences`.
7. *(Không khuyến nghị)* Khóa lưu trực tiếp không mã hóa trong `SharedPreferences`.
8. *(Không khuyến nghị)* Hardcode khóa mã hóa trong mã nguồn ứng dụng.
9. *(Không khuyến nghị)* Dùng hàm xáo trộn (obfuscation) hoặc KDF dựa trên các thuộc tính cố định của thiết bị.
10. *(Không khuyến nghị)* Lưu khóa đã sinh ra ở các vùng lưu trữ công cộng (như `/sdcard/`).

### Kiến trúc trên nền tảng iOS

Trên iOS, việc lưu trữ an toàn được thiết kế xoay quanh các thành phần sau:

- **Keychain Services:** Cơ chế chính của iOS để lưu trữ các chuỗi dữ liệu nhỏ nhạy cảm (như mẩu mật khẩu, token, cryptographic keys). Dữ liệu trong Keychain được mã hóa và bảo vệ bởi phần cứng Secure Enclave.
- **Keychain Access Groups:** Cho phép chia sẻ an toàn các mục trong Keychain giữa các ứng dụng được ký bởi cùng một tài khoản nhà phát triển.
- **UserDefaults:** Lưu trữ cấu hình dưới dạng file `.plist` không mã hóa trong sandbox. OWASP khuyến cáo tuyệt đối không dùng `UserDefaults` để lưu thông tin nhạy cảm.
- **Cấp độ tuân thủ theo OWASP MASVS (`MASTG-TEST-0052`):**
  - Mức **MASVS L1**: Dữ liệu lưu chưa mã hóa trong thư mục riêng tư (app sandbox) được chấp nhận do cơ chế cô lập của iOS.
  - Mức **MASVS L2**: Bắt buộc phải mã hóa bổ sung cho dữ liệu trong sandbox bằng kỹ thuật mã hóa phong bì (envelope encryption - DEK + KEK) với khóa mã hóa được quản lý an toàn trong iOS Keychain.

---

## 4. Những điều có thể sai và con đường rò rỉ dữ liệu

Trong quá trình đánh giá an ninh, OWASP đã tổng hợp các con đường rò rỉ dữ liệu nhạy cảm phổ biến (định danh qua danh mục điểm yếu **MASWE**):

### Lưu dữ liệu không mã hóa trong Sandbox (`MASWE-0001`)

Lập trình viên thường lầm tưởng rằng dữ liệu nằm trong sandbox riêng tư là an toàn. Tuy nhiên, nếu ứng dụng lưu token hay thông tin cá nhân dạng cleartext vào `SharedPreferences` hay `UserDefaults`, dữ liệu sẽ bị trích xuất ngay khi thiết bị bị root/jailbreak hoặc qua các công cụ backup.

### Rò rỉ qua Logs hệ thống (`MASWE-0005`)

Sử dụng các hàm ghi log sản xuất như `Log.d()`, `Log.e()` trên Android hoặc `NSLog()` trên iOS để in thông tin request/response, token hoặc thông báo lỗi. Các ứng dụng khác hoặc kẻ tấn công kết nối thiết bị qua máy tính có thể đọc được toàn bộ log cat/syslog.

### Rò rỉ qua Backups hệ thống (`MASWE-0006`)

- **Trên Android:** Nếu file `AndroidManifest.xml` đặt thuộc tính `android:allowBackup="true"` mà không cấu hình loại trừ file nhạy cảm trong `backup_rules.xml`, kẻ tấn công có thể dùng lệnh `adb backup` để trích xuất toàn bộ dữ liệu sandbox ra máy tính.
- **Trên iOS:** Nếu các file chứa dữ liệu nhạy cảm không được đánh dấu loại trừ backup bằng thuộc tính `NSURLIsExcludedFromBackupKey`, dữ liệu sẽ bị đưa vào các bản sao lưu iTunes/iCloud không mã hóa.

```xml
<!-- Dễ bị trích xuất dữ liệu qua adb backup nếu thiếu cấu hình loại trừ -->
<application
    android:allowBackup="true"
    android:fullBackupContent="@xml/backup_rules">
</application>
```

### Lưu dữ liệu ở bộ nhớ ngoài (`MASWE-0002`)

Lưu trữ thông tin nhạy cảm vào SD card hoặc các thư mục bộ nhớ ngoài (External Storage). Bất kỳ ứng dụng nào có quyền đọc bộ nhớ lưu trữ đều có thể truy cập được dữ liệu này.

### Hardcode Secrets trong ứng dụng (`MASWE-0004`)

Nhúng trực tiếp API key, Private key hay Mật khẩu mã hóa vào mã nguồn Java/Kotlin/Swift hoặc các file tài nguyên. Kẻ tấn công dễ dàng thu lại các chuỗi này bằng các công cụ decompile như `jadx` hoặc `apktool`.

### Chụp ảnh màn hình tự động và Keyboard Cache

- **Auto Screenshots:** Hệ điều hành tự động Chụp ảnh màn hình ứng dụng khi chuyển sang trạng thái background để hiển thị trên trình chuyển đổi ứng dụng (Recents screen). Nếu màn hình đang chứa thông tin tài khoản, ảnh chụp sẽ được lưu lại trong bộ nhớ tạm. Trên Android, cần thiết lập cờ `FLAG_SECURE` để ngăn chặn.
- **Keyboard Cache:** Bàn phím mặc định của hệ điều hành tự động ghi nhớ các từ ngữ người dùng nhập vào các trường văn bản để phục vụ tính năng gợi ý từ, trừ khi trường nhập liệu được đánh dấu là dữ liệu mật khẩu/nhạy cảm.

---

## 5. Áp dụng Secure Storage trong thực tế kiểm thử và phát triển

### Chuỗi truy vết OWASP MAS (Traceability Chain)

Dự án OWASP MAS cung cấp chuỗi truy vết 4 cấp độ giúp kết nối từ yêu cầu lý thuyết đến kịch bản kiểm thử và code thực tế:

```text
MASVS Control
      ↓
MASWE Weakness
      ↓
MASTG Test
      ↓
MASTG Demo
```

Ví dụ thực tế:

- **MASVS Control:** `MASVS-STORAGE-1` (Ứng dụng lưu trữ dữ liệu nhạy cảm an toàn).
- **MASWE Weakness:** `MASWE-0001` (Sensitive Data Stored Unencrypted in Private Storage).
- **MASTG Test:** `MASTG-TEST-0287` (Runtime Storage of Unencrypted Data via the SharedPreferences API).
- **MASTG Demo:** `MASTG-DEMO-0060` (App Writing Sensitive Data to Sandbox using EncryptedSharedPreferences).

### Quy trình kiểm thử thủ công cho Developer / Pentester

Khi rà soát ứng dụng Android trong môi trường kiểm thử (lab), mình thường dùng các câu lệnh shell trực tiếp để kiểm tra việc lưu trữ:

```bash
# Truy cập vào sandbox của ứng dụng trên thiết bị lab
adb shell
run-as com.example.demo

# Danh sách các file lưu trữ cục bộ
find . -type f

# Quét tìm các chuỗi nhạy cảm trong shared_prefs, files, databases
grep -RniE "token|password|secret|api[_-]?key" shared_prefs/ files/ databases/ 2>/dev/null
```

### Tự động hóa và Runtime Instrumentation

- **Tích hợp SAST vào CI/CD:** Sử dụng các công cụ quét mã tĩnh như MobSF hoặc các rule Semgrep (`MASTG-DEMO-0064`, `MASTG-DEMO-0068`) để tự động phát hiện các đoạn code ghi file unencrypted hoặc quên tắt cờ backup.
- **Runtime Instrumentation với Frida:** Sử dụng Frida (`MASTG-TOOL-0031`) hoặc Frida CodeShare (`MASTG-TOOL-0032`) để hook vào các API lưu trữ thời gian chạy, theo dõi các giá trị ghi vào `SharedPreferences` hoặc `Keychain` nhằm phát hiện dữ liệu nhạy cảm dạng rõ.

---

## Kết luận

Qua việc nghiên cứu tiêu chuẩn OWASP MASVS-STORAGE, mình rút ra rằng **Secure Storage** trên ứng dụng di động không chỉ đơn thuần là việc chọn một thư viện mã hóa, mà là tư duy quản lý toàn bộ vòng đời của dữ liệu trên thiết bị.

Bài học thực tế để áp dụng vào dự án:

1. **Tối thiểu hóa:** Luôn đặt câu hỏi liệu dữ liệu đó có bắt buộc phải lưu cục bộ hay không. Dữ liệu không lưu trữ là dữ liệu an toàn nhất.
2. **Sử dụng API chuẩn của nền tảng:** Sử dụng `EncryptedSharedPreferences` / `Android KeyStore` trên Android và `Keychain Services` trên iOS thay vì tự viết thuật toán mã hóa riêng.
3. **Phòng ngừa rò rỉ thụ động:** Bắt buộc tắt cờ backup đối với các file chứa session token, loại bỏ hoàn toàn việc in log nhạy cảm ở bản Release, và bật `FLAG_SECURE` cho các màn hình chứa thông tin tài chính/định danh.

## References

- [Introducing the new Mobile App Security Weakness Enumeration (MASWE)](https://mas.owasp.org/news/2024/07/30/new-maswe/)
- [MASTG v2.0.0 is Here](https://mas.owasp.org/news/2026/07/04/mastg-v200-release/)
- [MASTG-KNOW-0047: Cryptographic Key Storage](https://mas.owasp.org/MASTG/knowledge/android/MASVS-STORAGE/MASTG-KNOW-0047/)
- [MASTG-KNOW-0057: Keychain Services](https://mas.owasp.org/MASTG/knowledge/ios/MASVS-AUTH/MASTG-KNOW-0057/)
- [MASTG-TEST-0001: Testing Local Storage for Sensitive Data](https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0001/)
- [MASTG-TEST-0009: Testing Backups for Sensitive Data](https://mas.owasp.org/MASTG/tests/android/MASVS-STORAGE/MASTG-TEST-0009/)
- [MASTG-TEST-0052: Testing Local Data Storage](https://mas.owasp.org/MASTG/tests/ios/MASVS-STORAGE/MASTG-TEST-0052/)
- [MASTG-TOOL-0031: Frida](https://mas.owasp.org/MASTG/tools/generic/MASTG-TOOL-0031/)
- [MASTG-TOOL-0032: Frida CodeShare](https://mas.owasp.org/MASTG/tools/generic/MASTG-TOOL-0032/)
- [MASWE-0050: Unsafe Handling of Untrusted Data](https://mas.owasp.org/MASWE/MASVS-CODE/MASWE-0050/)
- [OWASP MASVS & MASTG: Mobile Security Guide (2026)](https://appsecsanta.com/mobile-security-tools/owasp-masvs-guide)
- [iOS Application Penetration Testing Report — Sample](https://tmgsecurity.com/reports/ios-sample-report)
- [OWASP MAS: The Standard for Auditing Mobile Application Security](https://sixhack.academy/owasp-mas/)
- MAS Reference App — Implementing Vulnerabilities and Defenses on Android
- OWASP MAS mới nhất có gì ??? — Viblo
- The OWASP MASVS checklist is a key mobile app security guide — Approov
- What is mobile app penetration testing? — SecureLayer7
- OWASP_MASVS.pdf
- Your Role, Your Journey — OWASP Mobile Application Security — NowSecure

## Series

- Previous: [OWASP MASTG Là Gì? Từ Security Requirement Đến Thực Tế Kiểm Thử Mobile](../03-owasp-mastg/index.md)
