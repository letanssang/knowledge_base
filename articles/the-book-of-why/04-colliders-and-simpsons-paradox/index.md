---
title: ""
description: "Giải thích cơ chế hoạt động của biến rẽ nhánh (collider) và cách sơ đồ nguyên nhân - kết quả giải mã nghịch lý Simpson trong cuốn sách The Book of Why."

date:
updated:

series: "The Book of Why"
series_order: 04

tags:
  - causality
  - statistics
  - book-of-why

status: draft
language: vi
---

Hãy tưởng tượng một thử nghiệm lâm sàng giả định về thuốc điều trị tim mạch (gọi là Thuốc D) được đề cập trong cuốn sách *The Book of Why*. Khi các nhà nghiên cứu phân tích dữ liệu ở bệnh nhân nam, Thuốc D làm tăng nguy cơ lên cơn đau tim. Khi chuyển sang nhóm bệnh nhân nữ, kết quả vẫn không đổi: Thuốc D tiếp tục làm tăng nguy cơ đau tim. Tuy nhiên, khi gộp chung toàn bộ dữ liệu của cả nam và nữ, con số thống kê lại cho thấy điều ngược lại: tỷ lệ đau tim ở nhóm dùng Thuốc D lại thấp hơn nhóm không dùng thuốc.

Làm sao một loại thuốc có thể gây hại cho nam giới, gây hại cho nữ giới, nhưng lại có vẻ có lợi cho tổng thể con người? Hiện tượng kỳ lạ này được biết đến với tên gọi Nghịch lý Simpson (Simpson's Paradox). Trong hơn nửa thế kỷ, nền thống kê cổ điển đã loay hoay tìm đáp án chỉ bằng cách nhìn vào các con số xác suất thuần túy. Bài viết này sẽ cùng bạn đi sâu vào cơ chế vận hành của biến rẽ nhánh (collider) và lý do tại sao sơ đồ nguyên nhân - kết quả lại là chìa khóa tháo gỡ nghịch lý này.

## Nghịch lý Simpson và sự bất lực của xác suất thuần túy

Sự đảo ngược xu hướng thống kê khi gộp hoặc tách dữ liệu—thường gọi là hiện tượng đảo ngược Simpson (Simpson's reversal)—về bản chất toán học chỉ là sự thay đổi tỷ lệ giữa các phân nhóm. Khi nhà thống kê Edward Simpson nêu ra hiện tượng này vào năm 1951, ông nhận thấy việc gộp hay tách dữ liệu sẽ cho ra hai kết luận hoàn toàn trái ngược nhau. Điều gây bối rối là bản thân các bảng số liệu thống kê không thể tự lên tiếng để cho biết đâu mới là câu trả lời đúng với thực tế.

Nguyên nhân khiến các nhà khoa học bế tắc suốt nhiều thập kỷ nằm ở chỗ họ cố gắng giải quyết một vấn đề nguyên nhân - kết quả bằng ngôn ngữ của xác suất quan sát. Trên Thang bậc Nguyên nhân (Ladder of Causation) do Judea Pearl đề xuất, dữ liệu quan sát thuần túy chỉ nằm ở Nấc 1 (Mối liên tưởng / Tương quan). Dữ liệu thô không thể phân biệt được liệu một biến số là nhân tố gây nhiễu (confounder), biến trung gian (mediator) hay biến rẽ nhánh (collider), bởi vì các con số hoàn toàn "mù" trước cấu trúc nguyên nhân ẩn đằng sau.

## Biến rẽ nhánh (Collider): Cánh cửa đóng tự nhiên và cái bẫy "kiểm soát"

Để hiểu tại sao dữ liệu bị bóp méo, chúng ta cần xem xét ba cấu trúc liên kết cơ bản trong sơ đồ nguyên nhân - kết quả: Chuỗi (\\(A \rightarrow B \rightarrow C\\)), Nhánh phân kỳ hay biến nhiễu (\\(A \leftarrow B \rightarrow C\\)), và Biến rẽ nhánh (\\(A \rightarrow B \leftarrow C\\)). Biến rẽ nhánh (collider) xuất hiện khi hai mũi tên từ hai biến độc lập cùng trỏ trực tiếp vào một biến ở giữa.

Cơ chế của biến rẽ nhánh hoạt động hoàn toàn trái ngược với biến nhiễu. Trong một cấu trúc biến nhiễu (\\(A \leftarrow B \rightarrow C\\)), biến \\(B\\) là nguyên nhân chung tạo ra mối tương quan giả giữa \\(A\\) và \\(C\\); việc kiểm soát hay cố định biến \\(B\\) sẽ chặn con đường "cửa sau" này và loại bỏ tương quan giả. Trái lại, ở dạng rẽ nhánh (\\(A \rightarrow B \leftarrow C\\)), con đường nối giữa \\(A\\) và \\(C\\) tự bản thân nó đã bị chặn đứng một cách tự nhiên bởi biến rẽ nhánh \\(B\\).

Sai lầm nghiêm trọng thường xảy ra khi các nhà phân tích dữ liệu cố gắng "kiểm soát" hoặc phân tầng theo biến rẽ nhánh. Khi mình cố định biến rẽ nhánh, cánh cửa vốn đang đóng tự nhiên sẽ đột ngột bị mở ra, tạo ra một mối tương quan giả tạo giữa hai biến nguyên nhân ban đầu. Hiện tượng này được gọi là thiên lệch biến rẽ nhánh (collider bias) hay hiệu ứng triệt tiêu giải thích (explain-away effect). Một ví dụ điển hình trong sách là mối quan hệ giữa Tài năng (\\(A\\)), Vẻ đẹp (\\(C\\)) và Sự nổi tiếng (\\(B\\)) của diễn viên. Mặc dù tài năng và vẻ đẹp hoàn toàn không liên quan trong dân số chung, nhưng nếu mình chỉ quan sát nhóm diễn viên nổi tiếng (cố định biến rẽ nhánh sự nổi tiếng), việc biết một diễn viên không đẹp sẽ khiến ta suy ra họ phải rất tài năng mới nổi tiếng được, từ đó tạo ra mối tương quan âm giả giữa tài năng và vẻ đẹp.

## Giải mã Simpson: Khi nào nên gộp, khi nào nên tách?

Nhờ hiểu rõ cơ chế của biến nhiễu và biến rẽ nhánh, Judea Pearl đã chứng minh rằng Nghịch lý Simpson không phải là một bài toán xác suất huyền bí, mà là một cảnh báo về sự xuất hiện của các con đường sai lệch trong sơ đồ nguyên nhân. Việc quyết định gộp hay tách dữ liệu không phụ thuộc vào giá trị của các con số, mà phụ thuộc hoàn toàn vào cấu trúc nguyên nhân tạo ra dữ liệu đó.

Trong ví dụ về Thuốc D, biến Giới tính đóng vai trò là một biến nhiễu (confounder) ảnh hưởng đến cả khả năng chọn dùng thuốc và nguy cơ đau tim. Vì vậy, ta bắt buộc phải phân tầng theo Giới tính để đóng con đường cửa sau, và kết luận đúng là Thuốc D có hại. Tuy nhiên, trong một trường hợp khác nếu biến ở giữa là Huyết áp (Thuốc D làm giảm huyết áp, và huyết áp thấp giúp giảm đau tim), thì Huyết áp lại đóng vai trò là biến trung gian. Nếu nhà nghiên cứu cố tình kiểm soát Huyết áp, họ sẽ vô tình triệt tiêu chính tác động thực sự của thuốc hoặc kích hoạt thiên lệch rẽ nhánh nếu có nhân tố nhiễu ẩn, dẫn đến kết luận sai lệch hoàn toàn.

## Bài học cho phân tích dữ liệu thực tế

Thói quen "đưa tất cả các biến quan sát được vào mô hình regression để kiểm soát" của thống kê truyền thống có thể trở thành một cái bẫy nguy hiểm. Nếu biến được đưa vào mô hình vô tình là một biến rẽ nhánh, việc kiểm soát nó sẽ biến một con đường vốn đang an toàn thành một nguồn gây thiên lệch nghiêm trọng cho toàn bộ phân tích.

Dữ liệu thô không sở hữu trí thông minh về nguyên nhân và kết quả; chính tư duy và mô hình nguyên nhân của con người mới cung cấp ngữ cảnh đúng đắn cho dữ liệu. Việc phác thảo một sơ đồ nguyên nhân - kết quả trước khi xử lý số liệu sẽ giúp mình nhận biết chính xác đâu là biến nhiễu cần phải kiểm soát, và đâu là biến rẽ nhánh cần phải giữ nguyên không đụng tới.

## References

- Judea Pearl, Dana Mackenzie (2018). *The Book of Why: The New Science of Cause and Effect*. Basic Books.

## Series