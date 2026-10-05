```yaml
---
title: ""
description: "Khám phá cơ chế vận hành của Phân tích trung gian (Mediation Analysis) giúp bóc tách tác động trực tiếp và gián tiếp trong khoa học suy luận nguyên nhân - kết quả."

date:
updated:

series: "The Book of Why"
series_order: 05

tags:
  - causal-inference
  - mediation-analysis
  - statistics

status: draft
language: vi
---
```

Giả sử một nghiên cứu y khoa phát hiện ra rằng việc sử dụng một loại thuốc mới giúp giảm đáng kể nguy cơ bị đau tim ở bệnh nhân. Tuy nhiên, các nhà nghiên cứu không dừng lại ở câu hỏi liệu thuốc "có tác dụng hay không". Họ muốn đào sâu hơn vào cơ chế: Thuốc làm giảm đau tim bằng cách hạ huyết áp, hay bản thân loại thuốc này tác động trực tiếp lên cơ tim thông qua một phản ứng sinh hóa khác? Câu hỏi về con đường truyền tải tác động này chính là cốt lõi của **Phân tích trung gian (Mediation Analysis)** — một công cụ quan trọng trong khoa học suy luận nguyên nhân - kết quả.

## Biến trung gian và câu hỏi về cơ chế vận hành

Trong ngôn ngữ của sơ đồ nguyên nhân (causal diagrams), khi một can thiệp hay nguyên nhân \\(X\\) (ví dụ: việc dùng thuốc) ảnh hưởng đến một kết quả \\(Y\\) (nguy cơ đau tim), tác động đó thường đi qua một biến nằm ở giữa gọi là biến trung gian \\(M\\) (mức huyết áp). Mối quan hệ này hình thành một chuỗi nguyên nhân \\(X \rightarrow M \rightarrow Y\\). Bên cạnh đó, \\(X\\) cũng có thể ảnh hưởng trực tiếp đến \\(Y\\) qua con đường \\(X \rightarrow Y\\) mà không cần thông qua \\(M\\).

Việc hiểu rõ cơ chế trung gian có ý nghĩa thực tiễn rất lớn chứ không chỉ dừng lại ở lý thuyết. Hãy xét ví dụ về việc hút thuốc lá (\\(X\\)), sự tích tụ nhựa đường trong phổi (\\(M\\)) và ung thư phổi (\\(Y\\)). Nếu việc hút thuốc gây ung thư phổi hoàn toàn thông qua việc tích tụ nhựa đường, chúng ta có thể loại bỏ nguy cơ ung thư bằng cách tạo ra các sản phẩm không chứa nhựa đường như thuốc lá điện tử. Nhưng nếu thuốc lá còn gây ung thư qua các con đường trực tiếp khác (như gây viêm mãn tính), thì thuốc lá điện tử sẽ không thể giải quyết hoàn toàn vấn đề.

Do đó, mục tiêu của phân tích trung gian là bóc tách **tác động tổng thể (total effect)** thành hai phần: **tác động trực tiếp (direct effect)** không đi qua biến trung gian, và **tác động gián tiếp (indirect effect)** được truyền tải thông qua biến trung gian.

## Bẫy "kiểm soát" và giới hạn của thống kê truyền thống

Trong suốt nhiều thập kỷ, các nhà thống kê cổ điển đã cố gắng xử lý bài toán này bằng các mô hình hồi quy tuyến tính, tiêu biểu là phương pháp của Baron và Kenny (1986). Cách làm truyền thống thường dựa trên việc so sánh hệ số khi có và không có biến trung gian trong phương trình hồi quy, hoặc nhân các hệ số đường dẫn với nhau để tính tác động gián tiếp.

Tuy nhiên, cách tiếp cận này gặp phải một hạn chế nghiêm trọng khi hệ thống có sự tương tác phi tuyến (non-linear interactions). Giả sử một loại thuốc thúc đẩy cơ thể tiết ra một enzym đóng vai trò chất xúc tác; enzym này kết hợp với chính loại thuốc đó để chữa lành bệnh. Trong trường hợp này, nếu ta cố định biến trung gian (enzym), thuốc sẽ không hoạt động (tác động trực tiếp bằng 0). Ngược lại, nếu chỉ tiêm enzym mà không có thuốc, enzym cũng không có khả năng chữa bệnh (tác động gián tiếp bằng 0). Nếu dùng công thức cộng tuyến tính đơn thuần (\\(Tác\ động\ tổng\ thể = Tác\ động\ trực\ tiếp + Tác\ động\ gián\ tiếp\\)), ta sẽ thu được kết quả vô lý là tác động tổng thể bằng 0, dù trên thực tế thuốc có hiệu quả rất rõ rệt.

Lỗi sai của thống kê truyền thống nằm ở chỗ họ nhầm lẫn giữa quy trình đại số và ý nghĩa nguyên nhân. Họ cố gắng "kiểm soát" (control) biến trung gian bằng cách giữ nó cố định cho tất cả mọi người, nhưng hành động này có thể vô tình làm biến đổi cơ chế tự nhiên hoặc mở ra các đường cản trở (back-door paths) không mong muốn.

## Khái niệm thế giới đối chứng và Lời giải từ Sơ đồ Nguyên nhân

Bước ngoặt của phân tích trung gian xuất hiện khi Judea Pearl và các đồng sự đưa khái niệm **thế giới đối chứng (counterfactuals)** vào sơ đồ nguyên nhân, tạo nên **Công thức Trung gian (Mediation Formula)**. Để định nghĩa đúng tác động gián tiếp tự nhiên (Natural Indirect Effect - NIE) hay tác động trực tiếp tự nhiên (Natural Direct Effect - NDE), chúng ta phải đặt ra câu hỏi ở cấp độ đối chứng.

Tác động gián tiếp tự nhiên đặt ra câu hỏi: Chuyện gì sẽ xảy ra với kết quả \\(Y\\) nếu chúng ta giữ nguyên trạng thái không can thiệp của nguyên nhân (\\(X = 0\\)), nhưng lại cho phép biến trung gian \\(M\\) thay đổi đến đúng giá trị mà nó sẽ đạt được nếu nguyên nhân được kích hoạt (\\(X = 1\\))? Bằng cách tư duy trên hai thế giới song song (cho nguyên nhân bằng 0 nhưng cho biến trung gian nhận giá trị của trạng thái nguyên nhân bằng 1), các nhà khoa học đã định nghĩa được chính xác bản chất của tác động gián tiếp mà không cần ép biến trung gian nhận một giá trị cố định khiên cưỡng cho toàn bộ quần thể.

Thông qua ngôn ngữ sơ đồ nguyên nhân và đại số đối chứng, Công thức Trung gian cho phép chúng ta ước tính chính xác các tác động trực tiếp và gián tiếp ngay cả từ dữ liệu quan sát thực tế, miễn là các giả định không có biến nhiễu ẩn (unobserved confounders) giữa nguyên nhân, biến trung gian và kết quả được thỏa mãn.

## Ứng dụng thực tiễn của phân tích trung gian

Nhờ sự phát triển của phân tích trung gian hiện đại, các nhà nghiên cứu trong nhiều lĩnh vực đã giải mã được những câu hỏi hóc húa kéo dài hàng thập kỷ. Trong giáo dục, phân tích trung gian giúp giải thích vì sao chương trình cải cách "Đại số cho mọi người" (Algebra for All) ban đầu không mang lại hiệu quả như kỳ vọng: tác động tích cực trực tiếp của việc học đại số đã bị triệt tiêu bởi tác động gián tiếp tiêu cực từ môi trường lớp học khi học sinh yếu kém bị xếp chung với học sinh giỏi mà không nhận được sự hỗ trợ phù hợp.

Trong y học và pháp lý, phân tích trung gian giúp xác định liệu một quyết định tuyển dụng có cấu thành sự phân biệt đối xử giới tính hay không (bằng cách kiểm tra tác động trực tiếp của giới tính lên kết quả tuyển dụng khi cho phép lựa chọn ngành học thay đổi tự nhiên), hoặc xác định cơ chế tác động của gen di truyền lên nguy cơ bệnh tật thông qua hành vi lối sống.

Việc chuyển từ quan sát mối tương quan sang bóc tách cơ chế trung gian đã nâng tầm suy luận nguyên nhân - kết quả, biến nó thành công cụ đắc lực để thiết kế các chính sách can thiệp chính xác và hiệu quả hơn trong thế giới thực.

## References

Pearl, J., & Mackenzie, D. (2018). *The Book of Why: The New Science of Cause and Effect*. Basic Books.

Baron, R. M., & Kenny, D. A. (1986). The moderator-mediator variable distinction in social psychological research: Conceptual, strategic, and statistical considerations. *Journal of Personality and Social Psychology*, 51(6), 1173–1182.

Robins, J. M., & Greenland, S. (1992). Identifiability and exchangeability for direct and indirect effects. *Epidemiology*, 3(2), 143–155.

Pearl, J. (2001). Direct and indirect effects. *Proceedings of the Seventeenth Conference on Uncertainty in Artificial Intelligence*, 411–420.

## Series