---
title: "Kiểm định mô hình: ranh giới phù hợp và thử thách điều kiện cực đoan"
description: "Làm sao biết một mô hình tư duy hay mô phỏng có đáng tin cậy để đưa ra quyết định triệu đô? Nắm vững các bài kiểm định khắt khe từ kiểm tra ranh giới đến thử thách cực đoan."

date:
updated:

series: "Business Dynamics"
series_order: 12

tags:
  - systems-thinking
  - model-validation
  - testing
  - business-dynamics

status: draft
language: vi
---

# Kiểm định mô hình: ranh giới phù hợp và thử thách điều kiện cực đoan

Nhà thống kê học nổi tiếng George Box từng để lại một câu nói kinh điển: **"All models are wrong, but some are useful" (Mọi mô hình đều sai, nhưng một số mô hình hữu ích)**. 

Bất kỳ mô hình nào — dù là một bản kế hoạch kinh doanh trên Excel, một sơ đồ tư duy trong đầu vị CEO, hay một hệ thống mô phỏng phức tạp gồm hàng ngàn phương trình — đều chỉ là sự đơn giản hóa của thế giới thực. Vì vậy, không một mô hình nào có thể đại diện cho chân lý tuyệt đối. Câu hỏi đặt ra cho người làm quản trị không phải là *"Mô hình này có đúng tuyệt đối không?"*, mà là: **"Mô hình này có đủ vững chắc và hữu ích để định hướng cho những quyết định chiến lược của chúng ta hay không?"**

Trong chương 21 của *Business Dynamics*, John Sterman đã đúc kết bộ tiêu chuẩn kiểm định mô hình khắt khe nhất của MIT Sloan. Ông cảnh báo rằng việc một mô hình khớp hoàn hảo với dữ liệu quá khứ (*historical fit*) hoàn toàn không chứng minh được rằng nó sẽ dự báo đúng tương lai. Muốn biết một mô hình có đáng tin cậy hay không, ta phải đưa nó qua những bài kiểm tra cấu trúc và những thử thách điều kiện cực đoan.

## Cạm bẫy của việc "Khớp dữ liệu quá khứ" (Historical Fit)

Trong giới tài chính và kinh doanh, người ta thường mắc một hội chứng gọi là "ám ảnh đường cong" (*curve-fitting*). Người ta liên tục thêm thắt các biến số và tinh chỉnh các hệ số tự do cho đến khi đường chạy của mô hình vẽ đè khít khao lên biểu đồ lịch sử 5 năm qua, rồi tự tin tuyên bố mô hình đã được "chứng thực" (*validated*).

Sterman vạch trần rằng đây là một sự tự lừa dối nguy hiểm. Với đủ số lượng thông số tự do, bạn có thể làm cho một mô hình khớp với bất kỳ chuỗi dữ liệu nào, giống như nhà toán học John von Neumann từng mỉa mai: *"Với bốn thông số tôi có thể vẽ một con voi, và với thông số thứ năm tôi có thể khiến nó ngoáy vòi"*.

Một mô hình khớp dữ liệu quá khứ nhưng có cấu trúc nhân quả sai lầm sẽ lập tức sụp đổ ngay khi môi trường kinh doanh xuất hiện một biến cố mới chưa từng có trong lịch sử. Sự kiểm định thực sự không nằm ở vẻ đẹp bề ngoài của những con số, mà nằm ở tính đúng đắn của các vòng phản hồi bên trong.

## Bộ 3 bài kiểm định cấu trúc then chốt của MIT Sloan

Để kiểm tra độ tin cậy của một mô hình tư duy hoặc mô hình kinh doanh, Sterman đề xuất hàng loạt bài test cấu trúc, trong đó nổi bật nhất là 3 bài kiểm tra:

### 1. Kiểm tra sự phù hợp của ranh giới (Boundary Adequacy Test)
Bài test này đặt câu hỏi: *Những khái niệm và phản hồi quan trọng nhất đối với vấn đề nghiên cứu đã được đưa vào bên trong mô hình (nội sinh) chưa?*
- Nếu bạn lập mô hình tài chính để cắt giảm chi phí nhưng loại trừ yếu tố "sự mệt mỏi của nhân viên" và "suy giảm chất lượng dịch vụ" ra ngoài ranh giới, mô hình của bạn đã trượt bài test ranh giới. 
- Nó sẽ đưa ra kết luận ngây thơ rằng cắt giảm 50% nhân sự sẽ tiết kiệm được 50% chi phí mà không gây ra bất kỳ tác dụng phụ nào.

### 2. Kiểm tra tính nhất quán về thứ nguyên (Dimensional Consistency Test)
Mỗi phương trình và mối liên kết trong mô hình phải chuẩn xác về mặt đơn vị đo lường ($/tháng, người, chiếc xe, ngày) mà không được dùng các "hệ số ma" (*fudge factors*) để ép cho hai vế bằng nhau. Nếu bạn cộng "tiền mặt" với "tốc độ bán hàng", mô hình của bạn là một mớ rác rưởi về mặt toán học.

### 3. Thử thách điều kiện cực đoan (Extreme Condition Test)
Đây là bài test quyền lực và tàn nhẫn nhất để vạch trần các mô hình rởm: **Hệ thống sẽ phản ứng ra sao nếu đưa các biến số về các giá trị cực đoan nhất (bằng 0 hoặc vô cực)?**
- Nếu lượng hàng tồn kho rơi về 0, tốc độ giao hàng có tự động giảm về 0 không, hay công thức vẫn cho phép giao hàng âm?
- Nếu giá sản phẩm tăng lên vô cực, nhu cầu có rơi về 0 không?
- Nếu doanh nghiệp hoàn toàn không có kỹ sư, tốc độ phát triển tính năng mới có bằng 0 không?

Một mô hình phản ánh đúng bản chất cấu trúc vật lý sẽ luôn duy trì hành vi hợp lý ngay cả trong những kịch bản tận thế cực đoan nhất, mà không bao giờ sinh ra những kết quả vô lý như giá trị âm của những thực thể không thể âm.

## Xây dựng "Ý chí nghi ngờ" lành mạnh

Kết thúc cuốn sách *Business Dynamics*, John Sterman trích dẫn triết gia Bertrand Russell để kêu gọi các nhà lãnh đạo xây dựng một "ý chí nghi ngờ" (*the will to doubt*) lành mạnh thay vì nhẹ dạ cả tin vào những bản kế hoạch hào nhoáng.

Mục đích cuối cùng của việc mô hình hóa hệ thống không phải là để tạo ra một cỗ máy tiên tri có thể đoán trước tương lai từng ly từng tí. Mục đích của nó là **thách thức và phơi bày những điểm mù trong mô hình tư duy của chính chúng ta**. 

Khi bạn dũng cảm đưa những giả định của mình ra ánh sáng, thử thách chúng qua các bài kiểm định cực đoan, và lắng nghe những phản hồi từ thế giới thực, bạn sẽ đưa ra những quyết định sáng suốt hơn, kiên cường hơn trước những biến động khôn lường của thời cuộc.

## References

- John D. Sterman, *Business Dynamics: Systems Thinking and Modeling for a Complex World*, Irwin/McGraw-Hill, 2000. (Chapter 21: Truth and Beauty: Validation and Model Testing, pp. 845–892).

## Series

- Previous: [Mô hình hóa quyết định con người: Tính duy lý giới hạn trong quản trị](../11-bounded-rationality-in-management/index.md)
