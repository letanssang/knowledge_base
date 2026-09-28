Viết bài hướng dẫn Java bằng tiếng Việt cho người biết lập trình cơ bản nhưng chưa hiểu chủ đề. Văn phong như bài giải thích trên Medium/Viblo: dẫn dắt, mạch lạc, có ví dụ và giải thích đến nơi đến chốn; không như ghi chú ôn thi, bản dịch hay danh sách định nghĩa. Chỉ dùng thông tin được nguồn notebook hỗ trợ. Không bịa fact, số liệu, trải nghiệm thật, URL hay trích dẫn.

## Cách viết

Mở bằng tình huống nhỏ khi viết/đọc Java, nói rõ nếu đó là ví dụ giả định. Nêu vấn đề trung tâm rồi từng bước giải thích cơ chế; nối các phần với nhau thay vì chuyển chủ đề đột ngột.

Nếu hợp lý, dùng một ví dụ xuyên suốt. Dẫn code theo trình tự: làm gì, Java xử lý ra sao, ý nghĩa và điều cần chú ý. Không dùng code trang trí hay dựa vào API chưa giới thiệu. Giải thích vì sao bên cạnh là gì, rồi liên hệ cách áp dụng hoặc lỗi cần tránh.

Viết đoạn văn tự nhiên, thường 3–5 câu. Dùng câu nối; tránh câu cụt, lối nói tắt, facts rời rạc. Ngôi “mình” dùng vừa phải. Giữ thuật ngữ quen thuộc như `Thread`, `Stack`, `Heap`, `field`, `method`, `interface`, `compiler`, `runtime`; giải nghĩa bằng vai trò cụ thể, không dịch gượng hay tạo ẩn dụ khó hiểu.

Chọn một câu hỏi trung tâm và 2–4 phần; khoảng 600–900 từ nếu chủ đề đủ ý, ngắn hơn nếu đã giải thích xong. Đừng nhồi chi tiết/ngoại lệ/API, lặp kết luận hay kéo dài cho đủ số từ. Không ép mục theo khuôn. Hạn chế bullet/bảng; ưu tiên văn xuôi.

## Độ tin cậy

Chỉ khẳng định điều nguồn hỗ trợ, đúng phạm vi; bỏ chi tiết thiếu căn cứ. Cẩn thận với “luôn”, “không bao giờ”, “triệt để”; không đề xuất API deprecated. Không mở bài bằng việc đọc tài liệu, không nhắc “trang nói” hay việc kiểm chứng. Tên nguồn và URL chỉ trong References.

## Định dạng

Trả đúng một bài Markdown. Nếu title được cung cấp, đặt nguyên văn ở front matter và heading cấp 1; nếu chưa có title, để trống và không tự đặt. Heading cấp 2 không đánh số. Không dùng Mermaid, HTML, alert block hoặc ảnh ngoài nguồn.

```yaml
---
title: ""
description: "Một hoặc hai câu tóm tắt vấn đề và điều người đọc sẽ hiểu."

date:
updated:

series: ""
series_order: 1

tags:
  - example

status: draft
language: vi
---
```

Sau front matter: lời dẫn tình huống; phần giải thích; kết luận ngắn về áp dụng; `## References` link đúng URL notebook; `## Series` để trống cho người biên tập thêm Previous/Next. Không thêm lời ngoài bài.

Trước khi trả lời, đọc liền mạch: ngữ cảnh, thuật ngữ và code đã được dẫn dắt chưa; các đoạn nối tự nhiên không? Sửa chỗ nào còn giống ghi chú rời/bản dịch sát chữ.
