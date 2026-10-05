---
title: "The Ladder of Causation (Thang bậc nhân quả)"
description: "Khám phá cơ chế ba nấc thang tư duy nhân quả của Judea Pearl, lý giải vì sao dữ liệu thô không đủ để trả lời câu hỏi 'Tại sao' và cách con người vượt trội nhờ tư duy phản thực."

date: 2026-10-05
updated: 2026-10-05

series: "The Book of Why"
series_order: 1

tags:
  - causal-inference
  - the-book-of-why

status: draft
language: vi
---

# The Ladder of Causation (Thang bậc nhân quả)

Giả sử bạn bị đau đầu dữ dội và quyết định uống một viên aspirin. Khoảng ba mươi phút sau, cơn đau hoàn toàn biến mất. Một câu hỏi tưởng chừng đơn giản xuất hiện: "Có phải viên aspirin đã chữa khỏi cơn đau đầu cho bạn?" 

Trong thống kê truyền thống và học máy (machine learning) hiện đại, câu trả lời thường chỉ dừng lại ở việc tính toán xác suất xảy ra đồng thời giữa việc uống thuốc và sự biến mất của cơn đau. Tuy nhiên, nhà khoa học máy tính Judea Pearl chỉ ra rằng tư duy nhân quả không phải là một khối đơn độc. Trong cuốn sách *The Book of Why*, ông đề xuất **Thang bậc nhân quả** (The Ladder of Causation) gồm ba nấc thang tư duy tách biệt về mặt toán học và khả năng biểu đạt: Quan sát (Association), Can thiệp (Intervention), và Phản thực (Counterfactuals).

## Nấc thang thứ nhất: Quan sát và giới hạn của dữ liệu thô

Nấc thang đầu tiên đại diện cho hoạt động thụ động nhất của trí tuệ: quan sát thế giới xung quanh để tìm kiếm các quy luật lặp đi lặp lại. Câu hỏi đặc trưng cho nấc thang này là "Nếu tôi nhìn thấy X, điều đó thay đổi niềm tin của tôi về Y như thế nào?".

Cơ chế vận hành của nấc thang quan sát dựa trên xác suất điều kiện \\(P(Y \mid X)\\), tức là tính toán khả năng xảy ra của sự kiện \\(Y\\) khi đã biết sự kiện \\(X\\) xuất hiện. Ví dụ, việc quan sát thấy chú gà trống gáy vào buổi sáng liên quan chặt chẽ đến việc mặt trời mọc, hay chỉ số áp kế giảm liên quan đến sự xuất hiện của một cơn bão. Các thuật toán học sâu (Deep Learning) và hệ thống Big Data hiện nay hầu hết đều vận hành ở nấc thang này. Chúng xử lý khối lượng dữ liệu khổng lồ để khớp các đường hàm phức tạp, tìm ra sự liên tưởng giữa các biến.

Tuy nhiên, điểm hạn chế cốt lõi của Nấc 1 nằm ở chỗ dữ liệu thô hoàn toàn "mù" trước nguyên nhân và kết quả. Việc nhìn thấy chiếc áp kế giảm làm tăng khả năng bão tới, nhưng bản thân chiếc áp kế không gây ra cơn bão. Nếu một mô hình trí tuệ nhân tạo chỉ dựa vào dữ liệu quan sát thụ động, nó không thể phân biệt được đâu là mối quan hệ nhân quả thực sự và đâu là sự tương quan ngẫu nhiên hoặc do yếu tố nhiễu tạo ra.

## Nấc thang thứ hai: Can thiệp và phép toán do-operator

Khi chúng ta bước lên nấc thang thứ hai, hoạt động tư duy chuyển từ "quan sát" sang "hành động". Câu hỏi trung tâm ở đây không còn là "Tôi thấy gì?" mà là "Điều gì sẽ xảy ra nếu chúng ta chủ động thay đổi môi trường?".

Sự khác biệt giữa quan sát và can thiệp được thể hiện rõ qua hành động: nếu bạn dùng tay ép kim áp kế giảm xuống, hành động can thiệp này không hề làm bão xuất hiện. Để mô tả toán học cho hành động can thiệp chủ động, Judea Pearl giới thiệu toán tử `do-operator`, ký hiệu là \\(P(Y \mid do(X))\\). Trong một sơ đồ nhân quả (causal diagram) gồm các nút và mũi tên chỉ hướng, phép toán \\(do(X)\\) tương ứng với một cuộc "phẫu thuật" trên đồ thị: người ta xóa bỏ tất cả các mũi tên hướng vào biến \\(X\\), cắt đứt sự ảnh hưởng của các yếu tố nhiễu ban đầu và cố định \\(X\\) ở một giá trị cụ thể.

Ý nghĩa của nấc thang can thiệp là giúp nhà nghiên cứu dự đoán hậu quả của những chính sách hoặc quyết định chưa từng được thực thi. Chẳng hạn, một doanh nghiệp muốn biết "Nếu chúng ta tăng gấp đôi giá kem đánh răng, doanh số chỉ nha khoa sẽ thay đổi ra sao?". Câu trả lời không thể lấy trực tiếp từ dữ liệu quá khứ vì giá kem đánh răng trong quá khứ có thể đã tăng do thiếu hụt nguồn cung toàn thị trường. Bằng cách kết hợp dữ liệu quan sát với một sơ đồ nhân quả đúng đắn, phép toán `do-calculus` cho phép tính toán tác động của can thiệp mà không nhất thiết phải tiến hành thử nghiệm thực tế tốn kém.

## Nấc thang thứ ba: Tư duy phản thực và khả năng quay ngược thời gian

Nấc thang cao nhất của Thang bậc nhân quả là tư duy phản thực (counterfactuals), nơi con người sử dụng trí tưởng tượng để truy vấn về những kịch bản trái ngược với thực tế đã xảy ra. Câu hỏi ở nấc thang này có dạng: "Nếu tôi đã không làm X, thì Y sẽ ra sao?" hoặc "Tại sao Y lại xảy ra?".

Trở lại ví dụ về bệnh nhân uống aspirin. Giả sử người bệnh đã uống thuốc và cơn đau đầu biến mất. Ở Nấc 3, chúng ta quay ngược thời gian trong tâm trí và đặt câu hỏi: "Liệu cơn đau đầu có biến mất không nếu người đó ĐÃ KHÔNG uống viên aspirin?". Để trả lời, mô hình nhân quả cấu trúc (Structural Causal Model - SCM) phải trải qua ba bước tính toán: Suy luận ngược (Abduction) để xác định các đặc tính ẩn của cá nhân từ dữ liệu thực tế, Can thiệp (Action) gán giá trị phản thực cho biến nguyên nhân, và Dự đoán (Prediction) kết quả trong thế giới giả định đó.

Tư duy phản thực chính là nền tảng tạo nên bước nhảy vọt trong quá trình tiến hóa nhận thức của con người từ khoảng 40.000 năm trước. Khả năng so sánh thế giới thực tại với một thế giới không tồn tại giúp con người gán trách nhiệm, cảm thấy hối hận, rút kinh nghiệm từ sai lầm và xây dựng ý thức đạo đức. Đây cũng là điều kiện tiên quyết để tạo ra Trí tuệ nhân tạo mạnh (Strong AI) — những cỗ máy không chỉ xử lý con số mà còn có thể giải thích lý do cho hành động của mình.

## Góc nhìn áp dụng và điểm dễ nhầm lẫn

Trong phân tích dữ liệu và ra quyết định, sai lầm phổ biến nhất là cố gắng giải quyết các câu hỏi ở nấc thang cao hơn bằng công cụ của nấc thang thấp hơn. Nhiều người tin rằng chỉ cần thu thập thêm thật nhiều dữ liệu quan sát (Nấc 1), mô hình sẽ tự động hiểu được tác động của chính sách (Nấc 2) hay giải thích được nguyên nhân sâu xa (Nấc 3). 

Thực tế toán học chứng minh rằng dữ liệu ở nấc thang thấp hơn không thể tự thân cung cấp câu trả lời cho nấc thang cao hơn nếu thiếu một mô hình nhân quả bổ sung. Để đưa ra quyết định chính xác, người phân tích cần xác định rõ câu hỏi của mình nằm ở nấc thang nào: dừng lại ở dự báo xu hướng (Quan sát), đánh giá hiệu quả hành động (Can thiệp), hay giải thích cơ chế và trách nhiệm (Phản thực).

## References

- Pearl, J., & Mackenzie, D. (2018). *The Book of Why: The New Science of Cause and Effect*. Basic Books.

## Series