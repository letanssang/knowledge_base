---
title: ""
description: "Bài viết giải thích cơ chế của Causal AI (Trí tuệ nhân tạo nhân quả) thông qua Nấc thang Nhân quả, sơ đồ nhân quả và phép toán do-operator từ góc nhìn của Judea Pearl."

date:
updated:

series: "The Book of Why"
series_order: 8

tags:
  - causal-ai
  - ai
  - Judea-Pearl

status: draft
language: vi
---

Giả sử bạn phát triển một mô hình học máy hỗ trợ y tế dựa trên dữ liệu lịch sử của hàng nghìn bệnh nhân. Khi phân tích, mô hình phát hiện ra một xu hướng rõ rệt: những bệnh nhân được kê một loại thuốc chỉ định D lại có tỷ lệ tử vong cao hơn những người không dùng thuốc. Nếu chỉ thuần túy nhìn vào con số thống kê, thuật toán có thể đưa ra đề xuất nguy hiểm là dừng cấp loại thuốc này. Nhưng thực tế trong y khoa, các bác sĩ chỉ ưu tiên kê thuốc D cho những trường hợp đã chuyển biến rất nặng. Loại thuốc này thực chất đang giúp giảm nguy cơ tử vong, nhưng dữ liệu quan sát thô đã bị che phủ bởi một biến nhiễu ẩn bên dưới: độ nghiêm trọng của bệnh.

Đây chính là ví dụ giả định điển hình cho thấy điểm hạn chế cố hữu của các hệ thống trí tuệ nhân tạo hiện đại. Dù sở hữu mạng thần kinh sâu phức tạp đến đâu, AI ngày nay vẫn chủ yếu vận hành dựa trên việc tìm kiếm sự tương quan thống kê trong dữ liệu. Để xây dựng những cỗ máy thực sự có khả năng tư duy và đưa ra quyết định đáng tin cậy, các nhà khoa học đang hướng tới một hướng đi mới mang tên Trí tuệ nhân tạo nhân quả (Causal AI).

## Ba nấc thang nhận thức và giới hạn của Deep Learning

Trong lý thuyết về suy luận nhân quả, nhà khoa học máy tính Judea Pearl đã mô tả khả năng tư duy thông qua mô hình Nấc thang Nhân quả (Ladder of Causation). Nấc thang này chia khả năng xử lý thông tin thành ba cấp độ riêng biệt:

Nấc thứ nhất là Quan sát (Association), đặt ra câu hỏi: "Tôi thấy điều này thì điều kia có khả năng xảy ra ra sao?". Đây là nơi toàn bộ các mô hình thống kê truyền thống và Deep Learning đang dừng lại. AI thu thập lượng dữ liệu khổng lồ để khớp các hàm số và tìm sự liên kết giữa các biến, tương tự như việc quan sát thấy kim áp kế giảm thì khả năng trời mưa sẽ tăng. Tuy nhiên, việc thụ động quan sát không thể cho cỗ máy biết liệu dùng tay xoay kim áp kế có làm trời đổ mưa hay không.

Nấc thứ hai là Can thiệp (Intervention), đặt ra câu hỏi: "Nếu tôi thực hiện một hành động, điều gì sẽ thay đổi?". Cấp độ này đòi hỏi cỗ máy không chỉ nhìn mà phải chủ động thay đổi trạng thái của môi trường. Sự khác biệt giữa việc quan sát một người tự nguyện uống thuốc và việc bắt buộc người đó uống thuốc là bản chất của sự can thiệp, nơi các biến nhiễu bị loại bỏ.

Nấc thứ ba là Phản thực tế (Counterfactuals), đặt ra câu hỏi: "Nếu tôi đã hành động khác đi trong quá khứ thì kết quả sẽ thế nào?". Đây là đỉnh cao nhận thức giúp con người hình dung ra những thế giới không tồn tại trong dữ liệu thực tế để suy ngẫm, học hỏi từ sai lầm và đưa ra giải thích cho câu hỏi "Tại sao?". Dữ liệu thụ động hoàn toàn mù tịt về cấp độ này vì dữ liệu chỉ ghi nhận những gì đã xảy ra, chứ không ghi nhận những gì có thể đã xảy ra.

## Cơ chế do-operator và phẫu thuật đồ thị

Làm thế nào để một hệ thống Causal AI có thể trả lời các câu hỏi về can thiệp ở nấc thang thứ hai mà không nhất thiết phải tiến hành các thử nghiệm thực tế tốn kém hoặc nguy hiểm? Chìa khóa nằm ở việc kết hợp Sơ đồ nhân quả (Causal Diagrams) và phép toán do-operator.

Sơ đồ nhân quả là một đồ thị có hướng, trong đó các nút đại diện cho các biến và các mũi tên biểu thị mối quan hệ nguyên nhân - kết quả trực tiếp. Khi muốn đánh giá tác động của một hành động can thiệp, ký hiệu toán học \\(do(X)\\) được áp dụng. Về mặt cơ chế, cỗ máy sẽ thực hiện một thao tác gọi là "phẫu thuật đồ thị" (graph surgery): xóa bỏ tất cả các mũi tên đi vào biến \\(X\\).

Thao tác xóa mũi tên này mang ý nghĩa rất cụ thể. Việc chủ động can thiệp vào \\(X\\) đã giải phóng \\(X\\) khỏi mọi yếu tố tác động trước đó trong quá khứ, biến \\(X\\) thành một hành động độc lập. Bằng cách ngắt đường truyền thông tin từ các biến nhiễu đi vào \\(X\\), cỗ máy có thể tính toán chính xác xác suất \\(P(Y|do(X))\\) dựa trên dữ liệu quan sát sẵn có mà không bị bóp méo bởi các mối tương quan ảo.

## Tư duy phản thực tế và con đường tới AI mạnh

Ở cấp độ cao nhất của Nấc thang Nhân quả, Causal AI cho phép máy tính xử lý các truy vấn phản thực tế bằng Mô hình nhân quả cấu trúc (Structural Causal Model). Hãy hình dung một robot gia đình vô tình bật máy hút bụi làm gia chủ thức giấc. Nếu gia chủ phàn nàn "Đáng lẽ ra cậu không nên làm thế", một mô hình Deep Learning thông thường chỉ có thể ghi nhận câu nói đó như một tín hiệu phạt để điều chỉnh trọng số.

Ngược lại, một cỗ máy sở hữu mô hình nhân quả sẽ so sánh hai thế giới cùng lúc: thế giới thực tế nơi nó đã bật máy và gia chủ tỉnh giấc, và thế giới giả định nơi nó không bật máy. Bằng cách giữ nguyên các điều kiện nền của thế giới thực và chỉ thay đổi quyết định bật máy trong mô hình cấu trúc, AI có thể tính toán xem liệu gia chủ có tiếp tục ngủ hay không. Khả năng tư duy phản thực tế này chính là nền tảng để cỗ máy hiểu được khái niệm về trách nhiệm, sự hối hận và lý do đằng sau các hành động của chính mình.

Causal AI không thay thế hay phủ nhận sức mạnh của Big Data và Deep Learning. Thay vào đó, nó đóng vai trò là khung tư duy giúp AI đi từ việc nhận diện các mẫu biểu hiện bề ngoài sang việc hiểu rõ cơ chế vận hành bên dưới của thế giới. Việc trang bị mô hình nhân quả giúp cỗ máy có khả năng thích ứng linh hoạt khi môi trường thay đổi, đưa ra các dự đoán chính xác cho các chính sách chưa từng được thử nghiệm và giao tiếp với con người bằng ngôn ngữ tự nhiên của nguyên nhân và kết quả.

## References

- Pearl, J., & Mackenzie, D. (2018). *The Book of Why: The New Science of Cause and Effect*. Basic Books.

## Series