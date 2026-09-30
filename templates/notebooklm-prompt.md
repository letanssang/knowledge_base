Viết một bài bằng tiếng Việt cho người đã tiếp xúc chủ đề nhưng chưa hiểu cơ chế. Văn phong như bài giải thích trên Medium/Viblo: dẫn dắt, mạch lạc, có ví dụ và giải thích đến nơi đến chốn; không như ghi chú ôn thi, bản dịch hay danh sách định nghĩa. Chỉ dùng thông tin được nguồn notebook hỗ trợ. Không bịa fact, số liệu, trải nghiệm thật, URL hay trích dẫn.

Nhận lĩnh vực từ nguồn và chủ đề — kỹ thuật, sách, lịch sử, hệ thống, hay lĩnh vực khác. Đừng mặc định bài phải về lập trình hay công nghệ.

## Cách viết

Mở bằng một tình huống nhỏ đúng với lĩnh vực: đoạn code khi chủ đề là phần mềm; một cảnh, quyết định hoặc mô hình trong sách khi đọc sách; một sự kiện cụ thể khi viết sử. Nói rõ nếu đó là ví dụ giả định. Nêu vấn đề trung tâm rồi từng bước giải thích cơ chế; nối các phần với nhau thay vì chuyển chủ đề đột ngột.

Nếu hợp lý, dùng một ví dụ xuyên suốt. Khi chủ đề có thao tác cụ thể (code, công thức, sơ đồ stock-and-flow, mốc sự kiện), dẫn theo trình tự: đang xảy ra gì, cơ chế vận hành ra sao, ý nghĩa và điều cần chú ý. Không dùng ví dụ trang trí hay dựa vào khái niệm chưa giới thiệu. Giải thích vì sao bên cạnh là gì, rồi liên hệ cách áp dụng hoặc chỗ dễ sai.

Viết đoạn văn tự nhiên, thường 3–5 câu. Dùng câu nối; tránh câu cụt, lối nói tắt, facts rời rạc. Ngôi “mình” dùng vừa phải. Giữ thuật ngữ đã thành chuẩn trong lĩnh vực; lần đầu xuất hiện thì giải nghĩa bằng vai trò cụ thể trong ví dụ đang dùng, không dịch gượng hay tạo ẩn dụ khó hiểu.

Chọn một câu hỏi trung tâm và 2–4 phần; khoảng 600–900 từ nếu chủ đề đủ ý, ngắn hơn nếu đã giải thích xong. Đừng nhồi chi tiết hay ngoại lệ, lặp kết luận hay kéo dài cho đủ số từ. Không ép mục theo khuôn. Hạn chế bullet/bảng; ưu tiên văn xuôi.

## Độ tin cậy

Chỉ khẳng định điều nguồn hỗ trợ, đúng phạm vi; bỏ chi tiết thiếu căn cứ. Cẩn thận với “luôn”, “không bao giờ”, “triệt để”. Nếu nguồn đánh dấu một công cụ, API, lý thuyết hay cách làm là lỗi thời hoặc đã bị thay, đừng đề xuất. Không mở bài bằng việc đọc tài liệu, không nhắc “trang nói” hay việc kiểm chứng. Tên nguồn và URL chỉ trong References. Nguồn là sách hoặc tệp không có URL công khai thì ghi tên sách, tác giả, năm; không bịa link.

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

Sau front matter: lời dẫn tình huống; phần giải thích; kết luận ngắn về áp dụng; `## References` với nguồn thật; `## Series` để trống cho người biên tập thêm Previous/Next. Không thêm lời ngoài bài.

Trước khi trả lời, đọc liền mạch: ngữ cảnh, thuật ngữ và ví dụ đã được dẫn dắt chưa; các đoạn nối tự nhiên không? Sửa chỗ nào còn giống ghi chú rời hay bản dịch sát chữ.
