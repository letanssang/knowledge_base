```yaml
---
title: ""
description: "Khám phá cơ chế vận hành của suy luận phản thực tế (counterfactuals) qua Mô hình Nhân quả Cấu trúc và lý do vì sao dữ liệu thuần túy không thể trả lời câu hỏi 'Giá như'."

date:
updated:

series: "The Book of Why"
series_order: 06

tags:
  - causal-inference
  - counterfactuals

status: draft
language: vi
---
```

Hãy tưởng tượng một tình huống giả định trong buổi thi hành án của một đội bắn súng: lệnh hành hình được tuyên, thuyền trưởng ra tín hiệu, hai người lính A và B cùng nổ súng, và tù nhân gục xuống. Giả sử sau đó người ta đặt câu hỏi: "Nếu lính A quyết định không nổ súng, tù nhân có còn sống hay không?"

Câu hỏi này nghe qua có vẻ đơn giản với tư duy tự nhiên của con người, nhưng lại khiến các hệ thống máy tính phân tích thống kê truyền thống hoàn toàn bế tắc. Lý do là vì trong dữ liệu quan sát thực tế, lệnh hành hình, tín hiệu của thuyền trưởng, phát bắn của hai người lính và cái chết của tù nhân đều đã xảy ra. Câu hỏi "nếu lính A không bắn" đòi hỏi chúng ta phải hình dung một thế giới giả định trái ngược hẳn với sự thật đã ghi nhận. Đây chính là bản chất của **suy luận phản thực tế (counterfactual reasoning)** — năng lực cốt lõi đưa con người lên đỉnh cao của trí tuệ nhân quả.

## Nấc thang thứ ba và giới hạn của dữ liệu thực quan

Trong mô hình **Nấc thang Nhân quả (Ladder of Causation)** do Judea Pearl đề xuất, suy luận phản thực tế nằm ở nấc thang cao nhất — Rung 3. Hai nấc thang bên dưới lần lượt là **Quan sát (Association)** với câu hỏi "Ta nhìn thấy gì?" và **Can thiệp (Intervention)** với câu hỏi "Điều gì xảy ra nếu ta hành động?".

Các mô hình học sâu hay thống kê cổ điển dù xử lý hàng tỷ dòng dữ liệu (Big Data) cũng chỉ vận hành ở nấc thang thứ nhất. Dữ liệu thực chất chỉ ghi lại các sự thật đã diễn ra trong quá khứ. Chúng có thể cho biết những người uống một loại thuốc hồi phục nhanh hơn những người không uống, nhưng không thể khẳng định liệu một bệnh nhân cụ thể — người đã uống thuốc và tử vong sau đó — có thể sống sót hay không nếu lúc đó anh ấy đổi ý không dùng thuốc.

Để trả lời câu hỏi ở Rung 3, chúng ta không thể chỉ dựa vào việc thu thập thêm dữ liệu hay thực hiện thử nghiệm mới. Một khi sự kiện đã xảy ra, ta không thể quay ngược thời gian để vừa cho một người uống thuốc vừa không cho uống thuốc tại cùng một thời điểm. Do đó, suy luận phản thực tế bắt buộc phải kết hợp dữ liệu thực tế với một **Mô hình Nhân quả Cấu trúc (Structural Causal Model - SCM)** để tái tạo thế giới giả định theo đúng logic vận hành của tự nhiên.

## Cơ chế ba bước giải mã thế giới phản thực tế

Làm thế nào một thuật toán toán học có thể tính toán được một điều chưa từng tồn tại trong thực tế? Câu trả lời nằm ở **Định luật đầu tiên của suy luận nhân quả (First Law of Causal Inference)**, cho phép chuyển đổi một câu hỏi phản thực tế thành một quy trình ba bước mạch lạc.

Đầu tiên là bước **Suy luận yếu tố ẩn (Abduction)**. Ở bước này, chúng ta sử dụng dữ liệu quan sát được ở thế giới thực về một cá thể cụ thể để trích xuất các thông tin nền hoặc đặc tính riêng biệt không quan sát trực tiếp được. Trong tình huống đội bắn súng, việc quan sát thấy tù nhân đã chết giúp ta suy ra rằng ở thế giới thực, thuyền trưởng đã ra lệnh và cả hai lính A lẫn B đều đã nổ súng.

Tiếp theo là bước **Hành động giả định (Action)**. Chúng ta can thiệp vào mô hình nhân quả bằng toán tử \\(do\\). Để giả định điều kiện "lính A không bắn", ta tiến hành xóa bỏ mũi tên tác động từ thuyền trưởng đến lính A (giải phóng lính A khỏi việc nghe lệnh) và cưỡng chế gán cho hành động của lính A giá trị không nổ súng.

Cuối cùng là bước **Dự đoán (Prediction)**. Chúng ta chạy lại mô hình đã điều chỉnh với các thông tin nền thu được từ bước đầu tiên. Dù lính A không bắn, nhưng lệnh của thuyền trưởng vẫn tồn tại, đồng nghĩa với việc lính B vẫn nổ súng theo đúng mệnh lệnh. Kết quả là tù nhân vẫn sẽ tử vong. Thuật toán kết luận: sự thay đổi ý định của lính A không cứu được mạng sống của tù nhân trong tình huống này.

Cơ chế ba bước này cũng giải thích vì sao khi xét một bài toán thực tế như mức lương của một nhân viên dựa trên trình độ học vấn và số năm kinh nghiệm, ta có thể tính chính xác mức lương phản thực tế của nhân viên đó nếu họ có bằng cấp cao hơn. Nhờ bước Abduction, mô hình giữ lại nguyên vẹn những phẩm chất cá nhân đặc thù của nhân viên, sau đó điều chỉnh biến học vấn ở bước Action và tính toán lại kinh nghiệm cùng mức lương tương ứng ở bước Prediction.

## Ý nghĩa thực tiễn và những điểm dễ nhầm lẫn

Suy luận phản thực tế không phải là trò chơi tư duy viển vông, mà là cơ sở cho các quyết định pháp lý và y học quan trọng. Trong luật pháp, nguyên tắc "nếu không có" (but-for causation) chính là một câu hỏi phản thực tế: hành vi của bị cáo có phải là yếu tố bắt buộc dẫn đến thiệt hại của nạn nhân hay không? Toán học hóa phản thực tế giúp chúng ta phân định rõ giữa **Xác suất Cần thiết (Probability of Necessity - PN)** và **Xác suất Đủ (Probability of Sufficiency - PS)**, tránh việc quy kết trách nhiệm nhầm lẫn trong các vụ án phức tạp.

Một sai lầm phổ biến khi tiếp cận chủ đề này là coi suy luận phản thực tế như một bài toán "khuyết dữ liệu" (missing data) thông thường và cố gắng dùng các phương pháp hồi quy dữ liệu thuần túy để điền vào khoảng trống. Các phương pháp dựa hoàn toàn vào dữ liệu mà thiếu mô hình nhân quả cấu trúc sẽ dễ dàng bị đánh lừa bởi các tương quan giả hoặc yếu tố nhiễu ẩn.

Khả năng so sánh thế giới thực tại với một thế giới giả định chính là chìa khóa giúp con người biết rút kinh nghiệm từ lỗi lầm, phân tích trách nhiệm và thấu hiểu cơ chế vận hành của thế giới. Đây cũng chính là rào cản lớn nhất mà các hệ thống Trí tuệ Nhân tạo thế hệ mới cần vượt qua nếu muốn đạt tới trí tuệ dạng người (Strong AI).

## References

Pearl, J., & Mackenzie, D. (2018). *The Book of Why: The New Science of Cause and Effect*. Basic Books.

## Series