---
title: "Mobile Privacy: Permissions, Tracking, PII và Data Minimization"
description: Tóm tắt danh mục MASVS-PRIVACY trong OWASP MASVS v2.1.0, phân tích 4 nhóm kiểm soát quyền riêng tư ứng dụng di động và hướng dẫn áp dụng thực tế cho developer.

date:
updated:

series: "Mobile Security"
series_order: 11

tags:
  - owasp-masvs
  - mobile-privacy
  - app-security
  - masvs-privacy

status: draft
language: vi
---

# Mobile Privacy: Permissions, Tracking, PII và Data Minimization

> **Tóm tắt:** Bài viết tổng hợp quá trình tìm hiểu danh mục MASVS-PRIVACY mới ra mắt trong tiêu chuẩn OWASP MASVS v2.1.0. Nội dung đi sâu vào lý do xuất hiện của khung chuẩn này, phân tích 4 nhóm yêu cầu kiểm soát chính, chỉ ra các lỗ hổng thường gặp như xin thừa quyền hay chính sách riêng tư không minh bạch, đồng thời chia sẻ cách áp dụng các giải pháp thay thế bảo vệ quyền riêng tư khi lập trình.

*Thời gian đọc: ~7 phút*

---

## 1. MASVS-PRIVACY là gì và vì sao nó tồn tại?

Khi phát triển ứng dụng di động, mình thường tập trung vào các nguy cơ bảo mật kỹ thuật quen thuộc như mã hóa dữ liệu (cryptography), xác thực (authentication), hay lưu trữ an toàn (secure storage). Tuy nhiên, khía cạnh bảo vệ quyền riêng tư (privacy) của người dùng thường bị bỏ ngỏ hoặc chỉ được coi là công việc của bộ phận pháp lý với các tài liệu chính sách dài ngoằng.

Sự ra đời của danh mục **MASVS-PRIVACY** trong phiên bản **OWASP MASVS v2.1.0** đã giải quyết trực tiếp khoảng trống này. Đây là baseline về quyền riêng tư dành riêng cho ứng dụng di động.

Khác với các quy định pháp lý diện rộng như GDPR hay ENISA (vốn áp dụng cho toàn bộ tổ chức và hạ tầng server), MASVS-PRIVACY tập trung vào chính bản thân ứng dụng di động:
- Nó kiểm tra những gì có thể đánh giá trực tiếp từ client thông qua phân tích tĩnh (static analysis), phân tích động (dynamic analysis) hoặc các thông tin công khai.
- Chuẩn xem xét hai hành vi **Collect** (thu thập) và **Share** (chia sẻ) dưới một góc nhìn thống nhất: bất kỳ dữ liệu nào rời khỏi thiết bị người dùng (gửi về server backend hoặc chuyển sang ứng dụng khác) đều là dữ liệu nằm ngoài tầm kiểm soát của người dùng.
- Chuẩn không cố gắng kiểm tra xử lý dữ liệu ở phía server vì hạn chế về quyền truy cập.

---

## 2. Bốn trụ cột kiểm soát của MASVS-PRIVACY

Danh mục MASVS-PRIVACY được cấu trúc thành 4 nhóm kiểm soát (controls) chính mà mọi lập trình viên cần nắm vững:

### MASVS-PRIVACY-1: Tối thiểu hóa truy cập dữ liệu và tài nguyên
Ứng dụng chỉ được phép xin quyền truy cập vào đúng những dữ liệu và tài nguyên hệ thống thực sự cần thiết cho tính năng hoạt động (Data Minimization). Khi chia sẻ dữ liệu với bên thứ ba hoặc tích hợp các SDK bên thứ ba, ứng dụng phải đảm bảo các SDK này tôn trọng tín hiệu đồng ý (consent) của người dùng, không được thu thập dữ liệu trước khi có sự xác nhận. Developer cũng phải chịu trách nhiệm về toàn bộ chuỗi cung ứng (supply chain) của SDK.

### MASVS-PRIVACY-2: Ngăn chặn định danh người dùng
Ứng dụng phải áp dụng các kỹ thuật hủy liên kết (unlinkability) như ẩn danh (anonymization) hoặc giả danh (pseudonymization) để tránh việc theo dõi hay định danh người dùng. Nếu ứng dụng thu thập các tín hiệu dạng "fingerprint" (như Device ID, địa chỉ IP, hành vi) cho mục đích chống gian lận (fraud detection), tín hiệu đó phải được cô lập và không được dùng chung cho các mục đích khác như đo lường tệp khách hàng trong SDK phân tích (analytics).

### MASVS-PRIVACY-3: Minh bạch trong thu thập và sử dụng dữ liệu
Người dùng có quyền biết dữ liệu của họ được xử lý ra sao. Ứng dụng phải cung cấp thông tin rõ ràng về các hành vi thu thập, lưu trữ và chia sẻ dữ liệu (đặc biệt là các tác vụ chạy ngầm). Các khai báo trên App Store hay Google Play Store (privacy labels) phải khớp với dữ liệu mà mã nguồn thực sự thu thập.

### MASVS-PRIVACY-4: Trao quyền kiểm soát dữ liệu cho người dùng
Ứng dụng phải cung cấp cơ chế cho phép người dùng quản lý, chỉnh sửa, xóa dữ liệu và thay đổi thiết lập riêng tư (ví dụ: rút lại sự đồng ý - revoke consent). Khi ứng dụng cần thu thập thêm dữ liệu ngoài phạm vi ban đầu, nó phải xin lại sự đồng ý từ người dùng.

---

## 3. Cơ chế hoạt động và mô hình kiểm tra

Để đánh giá mức độ tuân thủ MASVS-PRIVACY, quá trình kiểm thử kết hợp giữa tự động hóa và kiểm tra thủ công.

```text
+-------------------------------------------------------------------+
|                        Mobile Application                         |
|                                                                   |
|   +-------------------+        Consent Signal Check               |
|   |   App Features    | ----------------------------------+       |
|   +-------------------+                                   |       |
|             |                                             v       |
|             | Uses Intent                          +--------------+|
|             v                                      | 3rd-Party    ||
|   +-------------------+                            | SDKs         ||
|   | OS System Action  |                            +--------------+|
|   | (e.g. Camera App) |                                   |       |
|   +-------------------+                                   | Data  |
+-----------------------------------------------------------|-------+
              |                                             |
              v (No direct permission)                      v (External)
   +---------------------+                        +-----------------+
   | Device Resources    |                        | Remote Servers  |
   +---------------------+                        +-----------------+
```

Quá trình kiểm tra tuân thủ bao gồm:
1. **Static Analysis (Phân tích tĩnh):**
   - Đọc tập tin cấu hình manifest (ví dụ `AndroidManifest.xml`) để trích xuất danh sách các quyền `<uses-permission>`.
   - Kiểm tra mã nguồn xem các API nhạy cảm có kèm theo mục đích rõ ràng (purpose strings / rationale) hay không.
2. **Dynamic Analysis (Phân tích động):**
   - Bắt gói tin mạng (network traffic capture) để phát hiện dữ liệu định danh cá nhân (PII) hoặc domain theo dõi bị gửi đi mà không khai báo.
   - Kiểm tra hành vi của SDK bên thứ ba ngay khi ứng dụng khởi chạy xem có tự ý thu thập dữ liệu trước khi người dùng bấm "Đồng ý" trên màn hình Consent hay không.

---

## 4. Điều gì có thể sai? Các lỗ hổng MASWE thường gặp

Trong tài liệu của OWASP, các yếu tố làm giảm tính an toàn riêng tư được hệ thống hóa thành danh mục lỗ hổng **MASWE** (Mobile Application Security Weakness Enumeration):

### MASWE-0066: Inadequate Permission Management
Lỗi quản lý quyền không đầy đủ xảy ra khi ứng dụng:
- Xin nhiều quyền hơn mức cần thiết (ví dụ: ứng dụng đọc sách nhưng lại đòi quyền vị trí chính xác hay danh bạ).
- Giữ lại các quyền không còn sử dụng sau các bản cập nhật.
- Không giải thích lý do (rationale) khi yêu cầu quyền nhạy cảm ở runtime.

Trong mã kiểm thử `MASTG-TEST-0254`, tester sẽ rà soát các thẻ `<uses-permission>` trong `AndroidManifest.xml` để phát hiện các quyền nguy hiểm (dangerous permissions).

### MASWE-0072: Inadequate Privacy Policy
Chính sách riêng tư không đạt yêu cầu khi:
- Thiếu tài liệu chính sách riêng tư hoặc tài liệu khó truy cập.
- Nội dung mơ hồ, không tuân thủ các nguyên tắc viết rõ ràng.
- Có sự bất bất hợp lý (mismatch) giữa những gì ghi trong Privacy Policy / App Store Privacy Labels và hành vi truyền dữ liệu thực tế của mã nguồn.

---

## 5. Áp dụng trong thực tế cho developer

Từ các nguyên tắc của OWASP, mình rút ra một số kỹ thuật lập trình thực tế giúp nâng cao quyền riêng tư cho app:

### Thay thế quyền nhạy cảm bằng cơ chế của Platform
Thay vì xin quyền trực tiếp để làm rộng attack surface, hãy tận dụng các tính năng sẵn có của hệ điều hành. 
Ví dụ: Thay vì khai báo quyền `CAMERA` trực tiếp trong manifest, ứng dụng có thể gọi System Intent như `ACTION_IMAGE_CAPTURE` hoặc `ACTION_VIDEO_CAPTURE` để mở ứng dụng camera mặc định của máy. Khi người dùng chụp ảnh xong, kết quả trả về cho app mà app không cần nắm quyền truy cập trực tiếp vào phần cứng camera.

### Quản lý SDK bên thứ ba và SBOM
- **Tích hợp CycloneDX:** MASVS v2.1.0 cung cấp định dạng CycloneDX (`OWASP_MASVS.cdx.json`). Việc tích hợp định dạng này giúp tự động hóa việc theo dõi danh mục phần mềm (SBOM) trong pipeline DevOps/CI-CD, giúp quản lý các phụ thuộc (dependencies) và chuỗi cung ứng SDK tốt hơn.
- **Chặn SDK thu thập ngầm:** Đảm bảo các SDK analytics hay ads chỉ được khởi tạo (initialize) sau khi hàm kiểm tra consent trả về trạng thái chấp thuận từ người dùng.

### Đảm bảo tính nhất quán giữa Code và Tuyên bố
Mỗi khi thêm một thư viện mới hoặc gửi API request mới chứa thông tin thiết bị, developer cần cập nhật lại Privacy Label trên cửa hàng ứng dụng và tài liệu chính sách riêng tư.

---

## Kết luận

Qua việc nghiên cứu MASVS-PRIVACY, mình nhận ra rằng bảo vệ quyền riêng tư không chỉ là câu chuyện tuân thủ pháp lý của phòng pháp chế, mà là một trách nhiệm kỹ thuật bắt buộc của developer (Privacy-by-Design & Least Privilege). Bằng cách tối thiểu hóa quyền truy cập, sử dụng các cơ chế Intent thay thế, và minh bạch trong việc thu thập dữ liệu, chúng ta không chỉ giảm thiểu rủi ro bảo mật mà còn xây dựng được sự tin tưởng bền vững từ phía người dùng.

---

## References

- [MASVS v2.1.0 Release & MASVS-PRIVACY - OWASP Mobile Application Security](https://mas.owasp.org/news/2024/01/18/masvs-v210-release--masvs-privacy/)
- [MASVS-PRIVACY: Privacy - OWASP Mobile Application Security](https://mas.owasp.org/MASVS/12-MASVS-PRIVACY/)
- [MASVS-PRIVACY-1 - OWASP Mobile Application Security](https://mas.owasp.org/MASVS/controls/MASVS-PRIVACY-1/)
- [MASVS-PRIVACY-2 - OWASP Mobile Application Security](https://mas.owasp.org/MASVS/controls/MASVS-PRIVACY-2/)
- [MASVS-PRIVACY-3 - OWASP Mobile Application Security](https://mas.owasp.org/MASVS/controls/MASVS-PRIVACY-3/)
- [MASVS-PRIVACY-4 - OWASP Mobile Application Security](https://mas.owasp.org/MASVS/controls/MASVS-PRIVACY-4/)
- [MASWE-0066: Inadequate Permission Management - OWASP Mobile Application Security](https://mas.owasp.org/MASWE/MASVS-PRIVACY/MASWE-0066/)
- [MASWE-0072: Inadequate Privacy Policy - OWASP Mobile Application Security](https://mas.owasp.org/MASWE/MASVS-PRIVACY/MASWE-0072/)
- [MASTG-TEST-0254: Dangerous App Permissions - OWASP Mobile Application Security](https://mas.owasp.org/MASTG/tests/android/MASVS-PRIVACY/MASTG-TEST-0254/)
- [Mobile App User Privacy Protection - OWASP Mobile Application Security](https://mas.owasp.org/MASTG/0x04i-Testing-User-Privacy-Protection/)

## Series

- Previous: [Reverse Engineering & App Resilience: Obfuscation, Root/Jailbreak và Anti-Tampering](../10-reverse-engineering/index.md)
- Next: [Mobile Security Review: Kiểm Thử Bảo Mật Một Ứng Dụng Mobile Từ Đầu Đến Cuối](../12-mobile-security-review/index.md)
