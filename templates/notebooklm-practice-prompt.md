Viết bài thực hành tiếng Việt đi cùng bài lý thuyết được chỉ định trong brief cuối prompt. Dùng nguồn được chọn để kiểm chứng cơ chế; tạo tình huống và dữ liệu giả định cho bài tập, nói rõ đó là ví dụ. Không bịa fact, URL, kết quả đã chạy, trải nghiệm hoặc thời gian hoàn thành.

Mục tiêu là người đọc tự làm được và giải thích vì sao kết quả xảy ra. Không viết lại bài lý thuyết. Viết văn xuôi dẫn dắt tự nhiên, nối thao tác với cơ chế, giải thích thuật ngữ lần đầu bằng vai trò trong ví dụ. Giữ thuật ngữ English đã phổ biến; tránh giọng ghi chú ôn thi hoặc dịch sát tài liệu. Dùng bước đánh số, checklist, code và cấu trúc dài hơn khi cần tái hiện đầy đủ; không kéo dài cho đủ số từ.

## Nội dung cần có

- Mở bằng vấn đề cụ thể và sản phẩm hoặc kết quả sẽ tạo. Liên hệ bài lý thuyết trong brief; nêu kiến thức cần có và điều kiện làm bài.
- Nêu mục tiêu bằng thao tác quan sát được, cùng tiêu chí hoàn thành. Tránh mục tiêu chung chung như “hiểu sâu” hoặc “chuẩn SEO”.
- Cho biết môi trường tối thiểu, thư mục làm việc, tên file và nội dung khởi đầu đủ để tái hiện. Nếu cần cài công cụ, chỉ dùng lệnh được nguồn hỗ trợ. Không dẫn tới file hay ảnh chưa được cung cấp.
- Với code, khi phù hợp: yêu cầu dự đoán trước khi chạy, quan sát kết quả, giải thích, sửa một lỗi có chủ đích, rồi tự làm một biến thể. Không bắt buộc đủ các bước cho mọi chủ đề. Với chủ đề không phải code, dùng tình huống, phép tính hoặc mô hình có tiêu chí đánh giá phù hợp.
- Mỗi nhiệm vụ nêu rõ đầu vào, việc cần làm, cách kiểm tra và kết quả mong đợi có căn cứ. Nói rõ phần nào cố ý sai. Phân biệt kết quả dự kiến với kết quả đã được người biên tập chạy xác nhận.
- Giữ mức hỗ trợ vừa đủ, giảm dần trước phần tự làm. Đặt gợi ý rồi lời giải tham khảo sau toàn bộ đề bài; giải thích cơ chế và chấp nhận phương án khác thỏa tiêu chí. Starter không chứa sẵn lời giải của nhiệm vụ tự làm.
- Đưa lỗi thường gặp đúng với nhiệm vụ, cách nhận ra và cách quay lại trạng thái ban đầu. Kết thúc bằng một câu hỏi yêu cầu giải thích hoặc vận dụng vào biến thể mới.

Không dùng kiến thức chưa học làm điều kiện ngầm. Demo tĩnh hoặc dữ liệu giả không phải backend thật. Không thêm dịch vụ bên ngoài, framework hoặc công cụ build chỉ để làm ví dụ trông hoàn chỉnh.

## Độ tin cậy

Chỉ khẳng định cơ chế mà nguồn hỗ trợ. Không khuyến nghị API/công cụ đã deprecated hoặc đặc tả đã bị thay thế. Không dùng một kết quả kiểm tra để tuyên bố an toàn, accessible, SEO tốt hoặc đúng trên mọi thiết bị. Không kể việc tra cứu hay kiểm chứng trong bài. Tên trang và URL nguồn chỉ đặt ở References; liên kết nội bộ tới lý thuyết và file bài tập được dùng ngay tại chỗ cần.

## Định dạng theo brief

Trả đúng Markdown, không thêm lời ngoài bài. Dùng CommonMark/GFM, code fence có language, không Mermaid, HTML embed hoặc alert block. Mã HTML để người học sửa được đặt trong code fence.

Nếu là companion `practice.md`: không front matter, mở bằng liên kết `Lý thuyết` về `./index.md`; chỉ thêm heading cấp 1 khi brief có title người dùng cung cấp và giữ nguyên title đó. Đây là tài liệu bổ trợ, được theo dõi trạng thái Draft riêng trong bảng thực hành của series, không có series_order riêng.

Nếu là bài project độc lập `index.md`: dùng front matter dưới đây, điền series/order theo brief và tối đa bốn tag lowercase kebab-case. Title và heading cấp 1 giữ nguyên khi được cung cấp, nếu chưa có thì `title: ""` và không tự đặt heading cấp 1. Thêm `## Series` để biên tập điền điều hướng.

```yaml
---
title: ""
description: ""
date:
updated:
series: ""
series_order: 1
slug: ""
canonical_url: ""
tags:
  - practice
status: draft
language: vi
---
```

Trong cả hai trường hợp, dùng heading cấp 2 phù hợp với nhiệm vụ, không ép số mục cố định. Có `## References` với những nguồn thực sự dùng. Chỉ liên kết file được brief xác nhận sẽ có; các file người học phải tạo cần có nội dung hoặc chỉ dẫn rõ.

## Brief của lần viết này

Người biên tập nối brief cụ thể vào sau dòng này trước khi gửi cho NotebookLM.
