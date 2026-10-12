---
title: "Hồi quy về giá trị trung bình"
description: "Giải thích cơ chế hồi quy về giá trị trung bình, ảo tưởng nhân quả của các huấn luyện viên bay và mối quan hệ giữa may mắn và kỹ năng trong Thinking, Fast and Slow."

date:
updated:

series: "Thinking, Fast and Slow"
series_order: 5

tags:
  - psychology
  - cognitive-science
  - thinking-fast-and-slow
  - statistics
  - regression-to-the-mean

status: draft
language: vi
---

# Hồi quy về giá trị trung bình

Trong một buổi giảng cho các huấn luyện viên phi công thuộc Không quân Israel, Daniel Kahneman đã trình bày một nguyên lý tâm lý học căn bản: khen ngợi khi học viên tiến bộ sẽ mang lại hiệu quả cao hơn hẳn so với trừng phạt khi họ phạm lỗi. Ngay lập tức, một huấn luyện viên kỳ cựu đứng dậy phản bác. Ông chia sẻ rằng mỗi khi ông khen một học viên vì cú nhào lộn xuất sắc, ở lần bay tiếp theo anh ta thường thể hiện kém đi. Ngược lại, khi ông quát mắng xối xả vào tai nghe sau một pha xử lý tồi tệ, học viên đó gần như luôn bay tốt hơn ở lượt kế tiếp. Vị huấn luyện viên kết luận: lời khen làm học viên chủ quan, còn sự trừng phạt mới thực sự tạo ra tiến bộ.

Quan sát của vị huấn luyện viên hoàn toàn chính xác, nhưng kết luận của ông lại hoàn toàn sai lầm. Cả sự tiến bộ sau khi bị mắng lẫn sự sụt giảm sau khi được khen thực chất không phải do tác động của thái độ huấn luyện, mà chỉ là biểu hiện của một quy luật thống kê tự nhiên: hiện tượng hồi quy về giá trị trung bình (*regression to the mean*).

## Bẫy nhận thức từ những biến động ngẫu nhiên

Mỗi kết quả hay thành tích trong đời thực hiếm khi phản ánh thuần túy 100% năng lực cố định, mà luôn là sự kết hợp giữa tài năng và may mắn. Trong ví dụ về các phi công tập sự, kỹ năng bay của họ có một mức trung bình nhất định, nhưng chất lượng của từng cú hạ cánh hay thao tác nhào lộn cụ thể vẫn bị ảnh hưởng bởi những yếu tố ngẫu nhiên như hướng gió, sự tập trung tức thời hay chút may mắn.

Một học viên chỉ nhận được lời khen khi anh ta vừa thực hiện một cú bay xuất sắc đột biến — thời điểm mà may mắn đang ở mức cao nhất. Ở lần thử tiếp theo, khả năng cao là yếu tố may mắn ngẫu nhiên này sẽ không lặp lại, khiến thể hiện của anh ta tự động trở về gần mức trung bình cá nhân. Tương tự, huấn luyện viên chỉ quát mắng khi học viên có một cú bay tệ hại bất thường — lúc xui xẻo chạm đỉnh. Lượt bay kế tiếp, sự xui xẻo qua đi, phong độ của học viên tự khắc nhích lên mức bình thường mà không cần bất kỳ sự tác động nào từ tiếng la mắng.

Sự trớ trêu của tự nhiên nằm ở chỗ: vì con người có xu hướng khen khi người khác làm tốt và phạt khi người khác làm tồi, chúng ta vô tình bị "thống kê đánh lừa". Hệ thống trừng phạt dường như luôn mang lại kết quả tích cực, còn sự khuyến khích lại bị gán cho việc làm giảm phong độ.

## Francis Galton và sự phát hiện quy luật tương quan

Nguồn gốc lý thuyết của hiện tượng này bắt nguồn từ Sir Francis Galton vào cuối thế kỷ 19. Khi nghiên cứu sự di truyền chiều cao giữa các thế hệ bố mẹ và con cái, Galton nhận thấy một hiện tượng kỳ lạ: những người bố mẹ rất cao thường sinh ra những người con thấp hơn bố mẹ (dù vẫn cao hơn trung bình xã hội), còn những người bố mẹ rất thấp lại sinh ra con cái cao hơn họ. Ông gọi đây là "sự hồi quy về mức trung bình" (*regression towards mediocrity*).

Sau nhiều năm nghiên cứu, Galton nhận ra một nguyên lý thống kê chung: bất kể khi nào mối tương quan giữa hai biến số là không hoàn hảo (nhỏ hơn 1,0), hiện tượng hồi quy về giá trị trung bình chắc chắn sẽ xuất hiện. Ví dụ, nếu chúng ta quan sát câu nói: "Những người phụ nữ rất thông minh có xu hướng kết hôn với những người đàn ông kém thông minh hơn họ", Hệ thống 1 của chúng ta ngay lập tức muốn tìm kiếm một giải thích nhân quả — như phụ nữ giỏi giang muốn tránh sự cạnh tranh, hay nam giới ngại ngùng trước phụ nữ thông minh. Nhưng về mặt đại số, câu nói đó hoàn toàn tương đương với một sự thật thống kê đơn giản: "Tương quan về độ thông minh giữa vợ và chồng là không hoàn hảo". Khi tương quan không đạt mức tuyệt đối, sự hồi quy về mức trung bình là điều tất yếu về mặt toán học.

## May mắn, kỹ năng và ảo tưởng nhân quả của Hệ thống 1

Kahneman đã tóm tắt mối quan hệ giữa kết quả và các yếu tố cấu thành bằng một công thức đơn giản: *Thành công = Tài năng + May mắn*. Một thành công rực rỡ đồng nghĩa với *Một chút tài năng nhiều hơn + Rất nhiều may mắn*. Trong một giải đấu golf hai ngày, tay golf đạt điểm số kỷ lục ở Ngày 1 chắc chắn có tài năng trên mức trung bình, nhưng đồng thời cũng đã gặp may mắn lớn ở ngày thi đấu đó. Sang Ngày 2, tài năng của anh ta giữ nguyên, nhưng yếu tố may mắn ngẫu nhiên khó có thể duy trì ở mức cực hạn. Do đó, dự đoán tối ưu nhất cho Ngày 2 là thành tích của anh ta vẫn giỏi, nhưng sẽ bớt xuất sắc hơn Ngày 1.

Bộ não người, cụ thể là Hệ thống 1 (System 1), vận hành như một "cỗ máy tự động gán nguyên nhân". Hệ thống 1 liên tục tìm kiếm các câu chuyện nhân quả hợp logic để giải thích cho mọi sự kiện xảy ra xung quanh. Nó rất nhạy bén trong việc kết nối nguyên nhân - kết quả, nhưng lại cực kỳ vụng về trước các sự thật thuần túy mang tính thống kê. 

Khi thấy một vận động viên thi đấu sụt giảm sau khi xuất hiện trên bìa tạp chí *Sports Illustrated*, báo chí lập tức đưa ra "lời nguyền bìa báo" do áp lực tâm lý. Khi thấy một vận động viên nhảy xa thất bại ở lượt nhảy thứ hai sau lượt đầu xuất sắc, bình luận viên nhanh chóng giải thích rằng anh ta bị căng thẳng. Chúng ta tạo ra vô số câu chuyện thêu dệt để xoa dịu cơn khát nguyên nhân của bộ não, trong khi thực tế đó chỉ là sự biến động ngẫu nhiên quanh giá trị trung bình.

## Bài học nhận thức và ứng dụng thực tế

Hồi quy về giá trị trung bình là một trong những khái niệm khó tiếp thu nhất đối với tâm trí con người vì nó đòi hỏi sự can thiệp của Hệ thống 2 nhằm đè nén tư duy nhân quả tự nhiên của Hệ thống 1. Nhận diện được hiện tượng này giúp chúng ta tránh được những ảo tưởng nguy hại trong quản lý, đầu tư và cuộc sống hàng ngày.

Trong quản trị nhân sự hay giáo dục, hiểu được quy luật hồi quy giúp chúng ta đánh giá đúng hiệu quả của các chính sách khen thưởng và trừng phạt, tránh đổ lỗi hoặc tung hô sai chỗ dựa trên những biến động phong độ tạm thời. Trong dự báo và đánh giá hiệu suất, việc tính đến sự hồi quy giúp chúng ta đưa ra những kỳ vọng thực tế hơn, không bị ngợp bởi những thành tích đột biến ngắn hạn hay quá thất vọng trước những thất bại mang tính ngẫu nhiên.

## References

- Kahneman, D. (2011). *Thinking, Fast and Slow*. Farrar, Straus and Giroux.

## Series

- Previous: [04. Bỏ quên tỷ lệ nền và Nghịch lý Linda](../04-bo-quen-ty-le-nen-va-nghich-ly-linda/)
- Next: [06. Ảo tưởng về sự thấu hiểu và Phán đoán của chuyên gia](../06-ao-tuong-ve-su-thau-hieu-va-phan-doan-chuyen-gia/)
