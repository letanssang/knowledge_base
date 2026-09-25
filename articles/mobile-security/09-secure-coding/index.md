---
title: "Secure Coding trên Mobile: Input Validation, Dependencies và Supply Chain Security"
description: "Bài viết tổng hợp về chất lượng mã nguồn và quản lý phụ thuộc bên thứ ba trong ứng dụng di động dựa trên các tiêu chuẩn OWASP MASVS, MASWE và MASTG."

date:
updated:

series: "Mobile Security"
series_order: 9

tags:
  - mobile-security
  - code-quality
  - owasp-masvs
  - dependency-management

status: draft
language: vi
---

# Secure Coding trên Mobile: Input Validation, Dependencies và Supply Chain Security

> **Tóm tắt:** Trong phát triển ứng dụng di động, chất lượng mã nguồn và quản lý các thư viện bên thứ ba (third-party libraries) đóng vai trò sống còn đối với an toàn thông tin. Bài viết này tổng hợp những kiến thức cốt lõi từ các chuẩn OWASP MASVS, MASWE và MASTG về kiểm soát đầu vào, xử lý lỗ hổng trong dependency, công cụ kiểm tra tự động như OWASP Dependency-Check, lập danh mục SBOM và chiến lược bảo mật cho di động.

*Thời gian đọc: ~7 phút*

---

## 1. Chất lượng mã nguồn di động và các chuẩn kiểm soát OWASP

Khi xây dựng ứng dụng di động, mã nguồn ứng dụng phải đối mặt với rất nhiều điểm tiếp nhận dữ liệu (data entry points) từ bên ngoài như giao diện người dùng (UI), cơ chế giao tiếp giữa các tiến trình (IPC), mạng (network) hay hệ thống tệp (file system). Bất kỳ dữ liệu nào đi qua các cổng này đều có thể bị kẻ tấn công can thiệp hoặc sửa đổi nhằm vượt qua các cơ chế kiểm tra bảo mật, gây ra các cuộc tấn công tiêm mã (injection attacks) nguy hiểm như SQL injection, XSS hay insecure deserialization.

Để hệ thống hóa công tác bảo mật mã nguồn, bộ tiêu chuẩn OWASP Mobile Application Security Verification Standard (MASVS) trong nhóm kiểm soát MASVS-CODE đưa ra 4 yêu cầu chính:
- **MASVS-CODE-1:** Ứng dụng yêu cầu phiên bản nền tảng (platform version) cập nhật.
- **MASVS-CODE-2:** Ứng dụng có cơ chế bắt buộc cập nhật (enforced updates).
- **MASVS-CODE-3:** Ứng dụng chỉ sử dụng các thành phần phần mềm không chứa lỗ hổng đã biết.
- **MASVS-CODE-4:** Ứng dụng phải xác thực (validate) và làm sạch (sanitize) toàn bộ dữ liệu đầu vào không tin cậy (untrusted inputs).

---

## 2. Rủi ro an ninh từ phụ thuộc bên thứ ba (MASWE-0044)

### Vì sao lỗ hổng dependency lại tồn tại?
Hầu hết các ứng dụng di động hiện đại đều tích hợp nhiều thư viện mã nguồn mở hoặc SDK thương mại để rút ngắn thời gian phát triển. Điểm yếu MASWE-0044 xảy ra khi ứng dụng tích hợp các thư viện, SDK hoặc framework chứa các lỗ hổng bảo mật đã công khai. Khác với mã nguồn tự viết (first-party code), các lỗ hổng trong dependency thường đã được ghi nhận chi tiết trong các cơ sở dữ liệu công khai như danh sách CVE hay thông báo an ninh, khiến kẻ tấn công dễ dàng khai thác hơn.

Các con đường đưa lỗ hổng vào ứng dụng bao gồm:
- **Transitive Dependencies:** Các phụ thuộc gián tiếp được kéo vào thông qua các thư viện khác.
- **Dynamically Loaded Dependencies:** Việc tải thư viện động tại runtime làm khó theo dõi phiên bản.
- **Outdated Platform Security Components:** Sử dụng các thành phần an ninh nền tảng đã cũ; ví dụ trên Android, nhà phát triển cần chủ động cập nhật security provider khi khởi chạy ứng dụng.
- **Third-Party Frameworks:** Các khung ứng dụng như Flutter hay React Native cùng các liên kết nền tảng của chúng có thể chứa lỗ hổng.

### Tác hại thực tế
Khai thác một dependency bị lỗi có thể dẫn đến các hậu quả nghiêm trọng:
- **Lộ vét dữ liệu nhạy cảm:** Bị vượt qua rào cản truy cập, làm rò rỉ token phiên làm việc, thông tin xác thực hoặc dữ liệu PII của người dùng.
- **Thực thi mã trái phép (Unauthorized Code Execution):** Kẻ tấn công có thể chèn mã, leo thang quyền hạn hoặc điều khiển hành vi ứng dụng.
- **Vi phạm pháp lý và quy định:** Ship ứng dụng chứa CVE đã biết có thể vi phạm các quy định như GDPR, HIPAA, PCI-DSS hoặc chính sách của Google Play / App Store.

---

## 3. Quy trình phát hiện và kiểm thử thư viện bên thứ ba (MASTG-TEST-0042)

Để phát hiện các điểm yếu trong dependency, quy trình kiểm thử di động sử dụng kết hợp phân tích tĩnh, phân tích động và phân tích ngược.

MASTG-TEST-0042 đã bị đánh dấu deprecated. Trang test nói dùng các test v2 thay thế: MASTG-TEST-0272 và MASTG-TEST-0274. Đoạn Gradle bên dưới là ví dụ của test cũ, không phải quy trình hiện hành.

### Phân tích tĩnh (Static Analysis)
Trong phân tích tĩnh, công cụ OWASP Dependency-Check thường được tích hợp vào công cụ đóng gói qua plugin Gradle (`dependency-check-gradle`). Một cấu hình ví dụ trong `build.gradle`:

```groovy
buildscript {
    repositories {
        mavenCentral()
    }
    dependencies {
        classpath 'org.owasp:dependency-check-gradle:3.2.0'
    }
}

apply plugin: 'org.owasp.dependencycheck'
```

Sau khi tích hợp, nhà phát triển có thể chạy lệnh sau để xuất báo cáo phân tích:

```bash
gradle assemble
gradle dependencyCheckAnalyze --info
```

Đối với các ứng dụng lai (hybrid apps), các phụ thuộc JavaScript cần được kiểm tra bằng RetireJS.

### Đánh giá khi bị che mã hoặc không có mã nguồn
Khi không có mã nguồn, kỹ sư có thể giải nén file APK/IPA để kiểm tra các file JAR. Trường hợp ứng dụng sử dụng DexGuard hoặc ProGuard, thông tin phiên bản có thể bị xáo trộn (obfuscated), nhưng đôi khi vẫn tìm thấy trong ghi chú code hoặc dùng công cụ như MobSF để hỗ trợ truy vết phiên bản và tra cứu CVE thủ công.

### Phân tích động (Dynamic Analysis)
Phân tích động ở khía cạnh thư viện bên thứ ba tập trung kiểm tra việc tuân thủ bản quyền phần mềm (license compliance), đảm bảo ứng dụng có mục "About" hoặc EULA hiển thị đầy đủ thông tin bản quyền theo yêu cầu của thư viện mã nguồn mở.

---

## 4. Những giới hạn và sai sót thường gặp trong thực tế

Trong quá trình bảo mật mã nguồn di động, các nhà phát triển và kiểm thử viên thường gặp phải một số sai sót hoặc giới hạn:

1. **Phụ thuộc gián tiếp bị bỏ sót:** Chỉ kiểm tra các thư viện khai báo trực tiếp mà bỏ qua cây phụ thuộc bắc cầu (transitive dependencies).
2. **Sai lầm trong xử lý kết quả quét:** Không phân biệt thư viện được đóng gói cùng ứng dụng (packaged) hay chỉ dùng trong build-pipeline, dẫn đến việc bỏ qua các lỗi có thể làm suy yếu đường ống CI/CD.
3. **Ảo tưởng về công cụ quét tự động:** Mặc dù kiểm tra lỗ hổng thư viện là một "low-hanging fruit" có thể tự động hóa, công cụ quét có thể bị vô hiệu hóa khi mã bị obfuscate bởi DexGuard/ProGuard.
4. **Giới hạn của tài liệu:** Các tài liệu hiện có trong nguồn chưa đi sâu vào việc khắc phục chi tiết cho từng loại framework cụ thể ngoài nguyên lý chung.

---

## 5. Áp dụng thực tế và chiến lược phòng ngừa

Để tuân thủ yêu cầu MASVS-CODE-3 và giải quyết điểm yếu MASWE-0044, mình rút ra các bước thực hành tốt nhất sau đây:

- **Xây dựng và quản lý danh mục SBOM (Software Bill of Materials):** Tạo và duy trì SBOM theo hướng dẫn NIST SSDF (NIST SP 800-218) PS.3.2, NTIA và CISA để kiểm soát toàn bộ thư viện trực tiếp lẫn bắc cầu.
- **Cập nhật dependency có trách nhiệm và ghim phiên bản (Version Pinning):** Sử dụng các công cụ Software Composition Analysis (SCA) trong pipeline CI/CD để tự động phát hiện CVE, đồng thời thực hiện version pinning để tránh việc kéo tự động các bản cập nhật chưa qua kiểm duyệt.
- **Loại bỏ các thư viện thừa:** Định kỳ rà soát và loại bỏ các SDK hay thư viện không còn sử dụng nhằm giảm attack surface.
- **Chỉ sử dụng nguồn tin cậy:** Chỉ tải và tích hợp thư viện từ các kho lưu trữ chính thức hoặc các dự án mã nguồn mở uy tín.

---

## Kết luận

Bài học lớn nhất mà mình rút ra khi nghiên cứu nhóm kiểm soát MASVS-CODE là bảo mật mã nguồn không dừng lại ở việc viết code sạch hay tránh lỗi cú pháp đơn thuần. Việc kiểm soát chặt chẽ toàn bộ dữ liệu đầu vào không tin cậy (MASVS-CODE-4) kết hợp với việc quản lý nghiêm ngặt chuỗi cung ứng phần mềm (MASVS-CODE-3) thông qua công cụ SCA và danh mục SBOM là yếu tố quyết định để giữ cho ứng dụng di động an toàn trước các cuộc tấn công hiện đại.

---

## References

- [MASVS-CODE: Code Quality - OWASP Mobile Application Security](https://mas.owasp.org/MASVS/10-MASVS-CODE/)
- [MASVS-CODE-3 - OWASP Mobile Application Security](https://mas.owasp.org/MASVS/controls/MASVS-CODE-3/)
- [MASVS-CODE-4 - OWASP Mobile Application Security](https://mas.owasp.org/MASVS/controls/MASVS-CODE-4/)
- [MASWE-0044: Dependencies with Known Vulnerabilities - OWASP Mobile Application Security](https://mas.owasp.org/MASWE/MASVS-CODE/MASWE-0044/)
- [MASTG-TEST-0042: Checking for Weaknesses in Third Party Libraries - OWASP Mobile Application Security](https://mas.owasp.org/MASTG/tests/android/MASVS-CODE/MASTG-TEST-0042/)
- [Mobile App Code Quality - OWASP Mobile Application Security](https://mas.owasp.org/MASTG/0x04h-Testing-Code-Quality/)

## Series

- Previous: [Platform Security trên Mobile: Deep Links, WebView, IPC và Permissions](../08-platform-security/index.md)
- Next: [Reverse Engineering & App Resilience: Obfuscation, Root/Jailbreak và Anti-Tampering](../10-reverse-engineering/index.md)
