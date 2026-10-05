---
title: ""
description: "Khám phá cơ chế của Do-Calculus — hệ thống đại số giúp chuyển đổi các câu hỏi can thiệp thành công thức xác suất quan sát mà không cần thực hiện thí nghiệm thực tế."

date:
updated:

series: "The Book of Why"
series_order: 7

tags:
  - do-calculus
  - causal-inference
  - statistics
  - judea-pearl

status: draft
language: vi
---

Hãy tưởng tượng bạn đang phân tích hiệu quả của một loại thuốc điều trị đối với thời gian sống sót của bệnh nhân dựa trên dữ liệu bệnh viện. Thống kê truyền thống thường tính toán xác suất có điều kiện \\(P(\text{Sống sót} \mid \text{Dùng thuốc})\\), tức là đo lường tỉ lệ sống sót ở những người mà ta *quan sát* thấy họ tự nguyện dùng thuốc. Tuy nhiên, nếu chỉ những bệnh nhân có nguy cơ tử vong cao mới tìm đến loại thuốc này, con số thống kê quan sát được sẽ bị lệch nghiêm trọng do yếu tố nhiễu. Điều mà các bác sĩ và nhà chính sách thực sự cần biết để đưa ra quyết định không phải là việc "nhìn thấy" bệnh nhân uống thuốc, mà là việc *can thiệp*: chuyện gì sẽ xảy ra nếu ta *bắt buộc* một nhóm bệnh nhân dùng thuốc, được biểu diễn bằng xác suất \\(P(\text{Sống sót} \mid do(\text{Dùng thuốc}))\\)? Đây chính là ranh giới giữa việc quan sát và việc hành động trên Nấc thang Nguyên nhân (Ladder of Causation). Câu hỏi trung tâm đặt ra là: làm thế nào để tính toán được xác suất can thiệp này khi chúng ta chỉ có trong tay dữ liệu quan sát thụ động mà không thể thực hiện một cuộc thí nghiệm lâm sàng ngẫu nhiên?

## Toán tử do và phẫu thuật sơ đồ nguyên nhân

Để giải quyết sự khác biệt giữa quan sát và can thiệp, Judea Pearl đã đề xuất toán tử \\(do(X)\\) nhằm đại diện cho một hành động can thiệp chủ động lên biến \\(X\\). Trong một sơ đồ nguyên nhân (causal diagram) gồm các nút biến và mũi tên thể hiện mối quan hệ nguyên nhân - kết quả, việc áp dụng toán tử \\(do(X)\\) tương đương với một phép "phẫu thuật" đồ thị. Phép toán này xóa bỏ hoàn toàn tất cả các mũi tên chỉ vào \\(X\\), giải phóng \\(X\\) khỏi sự ảnh hưởng của các yếu tố tiền đề hay các yếu tố nhiễu ẩn.

Thách thức lớn nhất nằm ở chỗ: biểu thức \\(P(Y \mid do(X))\\) đại diện cho một kịch bản can thiệp thực tế vốn chưa diễn ra hoặc không thể tiến hành vì lý do đạo đức. Trong khi đó, dữ liệu thu thập được từ thực địa chỉ chứa các xác suất quan sát thuần túy không có toán tử \\(do\\), chẳng hạn như \\(P(Y \mid X)\\) hay \\(P(Y \mid X, Z)\\). Cơ chế Do-Calculus ra đời như một ngôn ngữ đại số biến đổi ký hiệu, cho phép chúng ta biến đổi biểu thức chứa \\(do\\) thành một biểu thức "không chứa do" (do-free) chỉ gồm các xác suất quan sát thông thường.

## Ba quy tắc vàng của Do-Calculus

Tương tự như việc Euclide xây dựng hình học dựa trên các công đề cơ bản, Do-Calculus vận hành dựa trên 3 quy tắc biến đổi cốt lõi do Judea Pearl phát triển vào năm 1994. Mỗi quy tắc đưa ra điều kiện hình học trên sơ đồ nguyên nhân để cho phép một thao tác biến đổi ký hiệu hợp lệ:

- **Quy tắc 1 (Thêm hoặc xóa quan sát):** \\(P(Y \mid do(X), Z, W) = P(Y \mid do(X), Z)\\). Quy tắc này cho phép thêm hoặc bớt một biến quan sát \\(W\\) nếu \\(W\\) không còn cung cấp thêm thông tin nào về \\(Y\\), do mọi đường nối giữa \\(W\\) và \\(Y\\) đã bị chặn bởi tập biến \\(Z\\) trong sơ đồ đã xóa các mũi tên chỉ vào \\(X\\).
- **Quy tắc 2 (Tráo đổi can thiệp và quan sát):** \\(P(Y \mid do(X), Z) = P(Y \mid X, Z)\\). Quy tắc này cho phép thay thế một hành động can thiệp \\(do(X)\\) bằng một quan sát \\(X\\) thuần túy nếu tập biến \\(Z\\) thỏa mãn tiêu chuẩn cửa sau (back-door criterion), nghĩa là \\(Z\\) đã chặn sạch tất cả các đường nhiễu phi nguyên nhân giữa \\(X\\) và \\(Y\\).
- **Quy tắc 3 (Thêm hoặc xóa can thiệp):** \\(P(Y \mid do(X)) = P(Y)\\). Quy tắc này cho phép xóa bỏ hoàn toàn toán tử \\(do(X)\\) nếu không tồn tại bất kỳ đường dẫn truyền nguyên nhân xuôi chiều nào từ \\(X\\) đến \\(Y\\).

Thông qua việc phối hợp nhịp nhàng các quy tắc này, nhà nghiên cứu có thể từng bước "triệt tiêu" toán tử \\(do\\). Một ví dụ lịch sử kinh điển là "bài toán khăn ăn" (napkin problem) năm 1993, khi Judea Pearl sử dụng Do-Calculus để chứng minh công thức điều chỉnh cửa trước (front-door adjustment). Nhờ đó, người ta có thể đo lường chính xác tác động nguyên nhân của việc hút thuốc lên bệnh ung thư phổi thông qua biến trung gian là lượng chất tàn tích (tar), ngay cả khi tồn tại yếu tố nhiễu gen ẩn không thể đo lường.

## Tính toàn vẹn và tự động hóa suy luận

Sau khi Do-Calculus ra đời, một câu hỏi quan trọng được đặt ra trong cộng đồng khoa học: liệu 3 quy tắc này đã đủ để giải quyết mọi bài toán can thiệp, hay chúng ta cần thêm các quy tắc thứ tư, thứ năm cho những hệ thống phức tạp hơn? Vào năm 2006, Ilya Shpitser cùng Yiming Huang và Marco Valtorta đã chứng minh được tính toàn vẹn (completeness) của Do-Calculus. Kết quả này khẳng định rằng nếu một tác động nguyên nhân \\(P(Y \mid do(X))\\) có thể ước tính được từ dữ liệu quan sát, thì chuỗi biến đổi dựa trên 3 quy tắc Do-Calculus chắc chắn sẽ tìm ra lời giải. Ngược lại, nếu Do-Calculus không thể triệt tiêu được toán tử \\(do\\), bài toán đó mathematically không thể suy luận từ dữ liệu quan sát và bắt buộc phải thực hiện thí nghiệm thực tế.

Sau phát minh này, các nhà nghiên cứu tiếp tục xây dựng các thuật toán thời gian đa thức (như thuật toán của Shpitser và Jin Tian) nhằm tự động hóa việc tìm kiếm chuỗi biến đổi. Nhờ đó, máy tính và các hệ thống trí tuệ nhân tạo có thể tự động kiểm tra một sơ đồ nguyên nhân phức tạp và đưa ra công thức tính toán tối ưu chỉ trong thời gian ngắn.

## Ứng dụng thực tế trong suy luận nguyên nhân

Do-Calculus đã chuyển hóa bài toán suy luận nguyên nhân từ những cuộc tranh luận định tính cảm tính thành một quy trình đại số chặt chẽ và minh bạch. Trong các lĩnh vực như y tế công cộng, kinh tế học và phát triển trí tuệ nhân tạo, Do-Calculus cung cấp công cụ để đánh giá hiệu quả của chính sách, dự đoán tác động của các quyết định can thiệp mà không cần phải trả giá bằng những thí nghiệm tốn kém hoặc vi phạm đạo đức. Việc nắm vững cơ chế vận hành của toán tử \\(do\\) và 3 quy tắc biến đổi giúp chúng ta hiểu rõ giới hạn của dữ liệu, biết chính xác khi nào một giả định nguyên nhân đủ mạnh để đưa ra kết luận đáng tin cậy.

## References

* *The Book of Why: The New Science of Cause and Effect*, Judea Pearl & Dana Mackenzie, Basic Books, 2018.

## Series