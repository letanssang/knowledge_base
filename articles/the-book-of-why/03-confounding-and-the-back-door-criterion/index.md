```yaml
---
title: ""
description: "Tìm hiểu cơ chế hoạt động của biến ngoại lai (confounding) và cách Tiêu chuẩn cửa sau (Back-door Criterion) giúp giải mã mối quan hệ nhân quả từ dữ liệu quan sát."

date:
updated:

series: "The Book of Why"
series_order: 3

tags:
  - causal-inference
  - statistics

status: draft
language: vi
---
```

Giả sử bạn đang phân tích dữ liệu y tế quan sát để đánh giá hiệu quả của một loại thuốc (\\(X\\)) đối với tỉ lệ hồi phục của bệnh nhân (\\(Y\\)). Khi so sánh nhóm tự nguyện dùng thuốc và nhóm không dùng, dữ liệu cho thấy nhóm dùng thuốc lại có tỉ lệ hồi phục thấp hơn. Tuy nhiên, vấn đề nằm ở chỗ những bệnh nhân có mức độ bệnh nặng hơn (\\(Z\\)) lại có xu hướng chủ động tìm đến loại thuốc này nhiều hơn. Mức độ bệnh ban đầu \\(Z\\) vừa ảnh hưởng đến quyết định dùng thuốc \\(X\\), vừa trực tiếp làm giảm khả năng hồi phục \\(Y\\). Đây là một tình huống giả định điển hình của nhiễu hay biến ngoại lai (confounding), nơi một yếu tố tiền đề làm sai lệch hoàn toàn bức tranh nhân quả thực sự mà chúng ta muốn đo lường.

## Khi quan sát đánh lừa thực tế: Bản chất của Confounding

Trong lý thuyết nhân quả của Judea Pearl, biến ngoại lai không đơn thuần là một khái niệm thống kê hay sự chênh lệch tỉ lệ thuần túy giữa các nhóm. Về bản chất, confounding đại diện cho khoảng hẫng giữa điều chúng ta quan sát được qua dữ liệu thụ động — biểu diễn bằng xác suất điều kiện \\(P(Y|X)\\) — và điều thực sự xảy ra khi chúng ta chủ động can thiệp — biểu diễn qua toán tử can thiệp \\(P(Y|do(X))\\). Khi người bệnh tự chọn có dùng thuốc hay không, sự tương quan quan sát được giữa \\(X\\) và \\(Y\\) đã bị trộn lẫn bởi các yếu tố thúc đẩy họ đưa ra lựa chọn đó.

Nếu chúng ta tiến hành một thử nghiệm lâm sàng ngẫu nhiên (RCT), việc phân bổ ngẫu nhiên sẽ cắt đứt mối liên hệ giữa mức độ bệnh \\(Z\\) và việc dùng thuốc \\(X\\), loại bỏ hoàn toàn tác động của biến ngoại lai. Nhưng trong rất nhiều bài toán thực tế, từ nghiên cứu tác hại của hút thuốc đến các chính sách kinh tế hay giáo dục, việc can thiệp ngẫu nhiên là không thể thực hiện do rào cản đạo đức hoặc chi phí. Khi đó, câu hỏi trung tâm đặt ra là: Làm sao chúng ta có thể ước tính được tác động can thiệp \\(P(Y|do(X))\\) chỉ từ dữ liệu quan sát thuần túy \\(P(Y|X)\\)?

## Con đường cửa sau (Back-door Path) và luồng thông tin trong sơ đồ nhân quả

Để giải quyết vấn đề này, Judea Pearl đề xuất cách nhìn sơ đồ nhân quả (causal diagram) như một mạng lưới các đường ống dẫn thông tin. Trong sơ đồ này, các nút biểu diễn biến số và các mũi tên thể hiện mối quan hệ nguyên nhân - kết quả trực tiếp. Thông tin có thể lan truyền qua các con đường nối giữa hai biến \\(X\\) và \\(Y\\) theo cả chiều thuận lẫn chiều ngược.

Một con đường cửa sau (back-door path) được định nghĩa là bất kỳ con đường nào nối từ \\(X\\) đến \\(Y\\) mà bắt đầu bằng một mũi tên chĩa thẳng vào \\(X\\) (ví dụ: \\(X \leftarrow Z \rightarrow Y\\)). Tên gọi "cửa sau" phản ánh việc thông tin rò rỉ ngược từ đầu vào của \\(X\\), đi qua biến ngoại lai \\(Z\\) rồi đến \\(Y\\). Chính những con đường cửa sau này tạo ra sự tương quan ảo (spurious correlation) giữa \\(X\\) và \\(Y\\), khiến chúng ta nhầm tưởng rằng \\(X\\) đang gây ra \\(Y\\) hoặc làm sai lệch cường độ tác động thực sự của \\(X\\) lên \\(Y\\). Muốn đo lường chính xác tác động nhân quả thuần túy của \\(X\\) lên \\(Y\\), nhiệm vụ của chúng ta là phải tìm cách chặn toàn bộ các con đường cửa sau này.

## Tiêu chuẩn cửa sau (Back-door Criterion) và quy tắc chặn đường ống

Tiêu chuẩn cửa sau (Back-door Criterion) cung cấp một quy tắc hình học rõ ràng và nhất quán để xác định tập hợp các biến cần kiểm soát (điều chỉnh) nhằm loại bỏ hoàn toàn nhiễu confounding. Một tập hợp các biến \\(Z\\) được gọi là thỏa mãn Tiêu chuẩn cửa sau đối với cặp biến \\((X, Y)\\) nếu đáp ứng hai điều kiện khắt khe:

Thứ nhất, tập \\(Z\\) phải chặn được tất cả các con đường cửa sau nối giữa \\(X\\) và \\(Y\\). Một con đường bị chặn khi chúng ta kiểm soát (condition on) một biến nằm trên con đường đó, chẳng hạn như biến ở đỉnh ngã ba nguyên nhân chung (fork: \\(X \leftarrow Z \rightarrow Y\\)).

Thứ hai, không có biến nào trong tập \\(Z\\) là con cháu (descendant) của \\(X\\). Điều kiện này cực kỳ quan trọng để đảm bảo mình không vô tình chặn mất một phần tác động nhân quả thực sự mà \\(X\\) đang truyền sang \\(Y\\).

Một sai lầm phổ biến trong phân tích thống kê truyền thống là thói quen kiểm soát tất cả các biến đo được trước thực nghiệm. Sơ đồ nhân quả chứng minh rằng cách làm mù quáng này có thể dẫn đến thảm họa. Nếu mình kiểm soát một biến đụng độ (collider, có dạng \\(A \rightarrow B \leftarrow C\\)), hành động kiểm soát \\(B\\) sẽ vô tình mở ra con đường thông tin vốn đang bị đóng, tự tạo ra nhiễu mới (collider bias hay M-bias). Tương tự, nếu kiểm soát một biến trung gian (mediator, \\(X \rightarrow M \rightarrow Y\\)), mình sẽ vô tình triệt tiêu mất chính cơ chế mà \\(X\\) dùng để tác động lên \\(Y\\).

## Ý nghĩa thực tiễn: Chuyển từ quan sát sang can thiệp

Nhờ Tiêu chuẩn cửa sau, bài toán khử nhiễu phức tạp vốn làm đau đầu các nhà thống kê qua nhiều thế hệ đã trở thành một quy trình đồ họa rõ ràng trên sơ đồ nhân quả. Khi tìm được tập hợp biến \\(Z\\) thỏa mãn tiêu chuẩn này, mình có thể áp dụng công thức điều chỉnh cửa sau (back-door adjustment formula) để tính toán \\(P(Y|do(X))\\) bằng cách lấy trung bình có trọng số của \\(P(Y|X, Z)\\) trên các nhóm của \\(Z\\).

Điều kỳ diệu ở đây là Tiêu chuẩn cửa sau cho phép chúng ta dự đoán chính xác kết quả của một can thiệp chưa từng xảy ra trong thực tế, chỉ bằng cách xử lý dữ liệu quan sát có sẵn. Nó đưa việc phân tích dữ liệu thoát khỏi cái bẫy của tương quan thuần túy để bước lên nấc thang can thiệp của tư duy nhân quả.

## References

- Pearl, J., & Mackenzie, D. (2018). *The Book of Why: The New Science of Cause and Effect*. Basic Books.
- Pearl, J. (1993). Comment: Graphical models, causality, and intervention. *Statistical Science*, 8(3), 266–269.
- Greenland, S., Pearl, J., & Robins, J. M. (1999). Causal diagrams for epidemiologic research. *Epidemiology*, 10(1), 37–48.

## Series