---
title: "Mô hình hóa quyết định con người: Tính duy lý giới hạn trong quản trị"
description: "Tại sao những nhà quản lý thông minh và có bằng cấp cao lại liên tục đưa ra những quyết định làm tổn hại công ty? Khám phá lý thuyết Bounded Rationality và cách xây dựng hàm quyết định thực tế."

date:
updated:

series: "Business Dynamics"
series_order: 11

tags:
  - systems-thinking
  - bounded-rationality
  - decision-making
  - business-dynamics

status: draft
language: vi
---

# Mô hình hóa quyết định con người: Tính duy lý giới hạn trong quản trị

Trong các giáo trình kinh tế học và tài chính tiêu chuẩn, người ta thường xây dựng các mô hình dựa trên một sinh vật giả định mang tên *Homo Economicus* (con người kinh tế hoàn hảo): luôn sở hữu thông tin toàn diện, có năng lực tính toán siêu phàm, và luôn đưa ra các quyết định tối ưu hóa lợi ích tuyệt đối.

Thế nhưng, nếu các nhà quản trị thực sự duy lý và hoàn hảo như vậy, tại sao các vụ phá sản kinh hoàng như Enron, Lehman Brothers hay những đợt khủng hoảng thừa mứa trong chuỗi cung ứng vẫn liên tục nổ ra? 

Trong chương 13 và 15 của *Business Dynamics*, John Sterman khẳng định: muốn mô hình hóa chính xác thế giới kinh doanh, chúng ta phải từ bỏ ảo tưởng về con người tối ưu hoàn hảo, và bắt đầu đối diện với thực tế về **tính duy lý giới hạn (bounded rationality)** — khái niệm mang về giải Nobel Kinh tế cho Herbert Simon. Con người không phải là những cỗ máy tối ưu hóa; chúng ta chỉ là những sinh vật hành động dựa trên thông tin cục bộ, nhận thức méo mó và những quy tắc kinh nghiệm (*heuristics*) đơn giản.

## Bản chất của Bounded Rationality: Ý định tốt nhưng tầm nhìn hẹp

Tính duy lý giới hạn không có nghĩa là con người ngu ngốc hay hành động tùy tiện. Trái lại, **mọi người luôn nỗ lực đưa ra quyết định hợp lý và có chủ đích nhất có thể, nhưng sự hợp lý đó bị giam cầm trong những ranh giới nhận thức ngặt nghèo**:

1. **Thông tin không hoàn hảo và bất đối xứng:** Không ai có thể nắm bắt được toàn bộ dữ liệu của thị trường. Chúng ta chỉ nhìn thấy những gì được báo cáo về bàn làm việc của mình, và những dữ liệu đó thường bị trễ hoặc bị bóp méo qua các tầng nấc trung gian.
2. **Năng lực xử lý tinh thần có hạn:** Não bộ con người không thể giải đồng thời hàng chục phương trình vi phân phi tuyến. Đối diện với sự phức tạp, chúng ta buộc phải dùng các lối tắt tư duy (*heuristics*) như: "năm nay tăng trưởng 10% thì cứ đặt hàng thêm 10%", hay "giá đang tăng thì sẽ còn tăng tiếp".
3. **Mù lòa trước các vòng phản hồi (Misperceptions of Feedback):** Các nghiên cứu thực nghiệm của Sterman tại MIT chỉ ra rằng con người rất kém trong việc liên kết hành động hiện tại với hậu quả phản hồi sau các độ trễ dài. Chúng ta thường đánh giá vấn đề dựa trên triệu chứng bề mặt thay vì cơ chế cấu trúc.

## Cách mô hình hóa quyết định của con người trong thực tế

Khi xây dựng các mô hình mô phỏng doanh nghiệp, làm thế nào để viết ra các phương trình quyết định phản ánh đúng hành vi thực tế của các nhà quản lý thay vì hành vi lý tưởng trên sách vở?

Sterman đưa ra 4 nguyên tắc cốt lõi để xây dựng hàm quyết định (*decision rules*):

- **Nguyên tắc thông tin khả dụng:** Phương trình quyết định của một tác nhân chỉ được phép sử dụng những thông tin mà tác nhân đó thực sự có được tại thời điểm ra quyết định. Không được đưa những thông tin của tương lai hay thông tin bí mật của đối thủ vào mô hình.
- **Sử dụng các quy tắc ngón tay cái (Heuristics):** Trong thực tế, các nhà quản lý không tính toán tối ưu đạo hàm bậc hai; họ dùng các quy tắc đơn giản như mức tồn kho mục tiêu bằng 3 tuần doanh số, hay ngân sách quảng cáo bằng 5% doanh thu. Mô hình phải phản ánh đúng các quy tắc vận hành thực tế này.
- **Tính phi tuyến và điều kiện biên cực đoan:** Quyết định của con người thay đổi rất mạnh khi bị dồn vào chân tường. Khi áp lực deadline tăng nhẹ, nhân viên có thể làm thêm giờ để bù đắp; nhưng khi áp lực tăng gấp đôi, họ sẽ bắt đầu kiệt sức, sai sót tăng vọt và năng suất thực tế sụt giảm nghiêm trọng. Các hàm quyết định phải mô tả được những mối quan hệ phi tuyến tính này.
- **Tính vững chắc về mặt vật lý (Physical Realism):** Phương trình không bao giờ được phép cho ra kết quả phi thực tế, chẳng hạn như xuất kho một lượng hàng lớn hơn số hàng đang có trong kho, hay công nhân làm việc 30 giờ một ngày.

## Từ nhận thức điểm mù đến thiết kế hệ thống vững chắc

Hiểu được tính duy lý giới hạn giúp thay đổi hoàn toàn cách tiếp cận quản trị trong doanh nghiệp:

Thay vì tiếp tục kỳ vọng tìm kiếm những "vị cứu tinh", những nhà lãnh đạo thiên tài có khả năng dự báo hoàn hảo mọi biến cố, mục tiêu của tư duy hệ thống là **thiết kế những cấu trúc tổ chức vững chắc trước sự sai sót của con người**.

Nếu bạn biết rằng con người luôn phản ứng quá đà trước độ trễ, hãy rút ngắn độ trễ luồng thông tin và tự động hóa quy trình đặt hàng. Nếu bạn biết rằng nhân viên sẽ tối ưu hóa cục bộ theo chỉ số KPI bề nổi, hãy thiết kế lại luật chơi sao cho việc hợp tác phụng sự mục tiêu toàn thể mang lại lợi ích cao nhất cho họ. Khi cấu trúc hệ thống được thiết kế đúng đắn, ngay cả những con người bình thường với tính duy lý giới hạn cũng sẽ cùng nhau tạo nên những kết quả phi thường và bền vững.

## References

- John D. Sterman, *Business Dynamics: Systems Thinking and Modeling for a Complex World*, Irwin/McGraw-Hill, 2000. (Chapter 13: Modeling Decision Making & Chapter 15: Modeling Human Behavior: Bounded Rationality or Chumping at the Bit?, pp. 513–550, 597–630).

## Series

- Previous: [Chu kỳ hàng hóa: tại sao thị trường luôn trồi sụt thừa - thiếu?](../10-commodity-cycles/index.md)
- Next: [Kiểm định mô hình: ranh giới phù hợp và thử thách điều kiện cực đoan](../12-model-testing-and-validation/index.md)
