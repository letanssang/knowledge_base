```yaml
---
title: ""
description: "Biểu đồ nhân quả (Causal Diagrams / DAGs) giúp minh họa và giải mã luồng thông tin nhân quả giữa các biến số, khắc phục các thiên kiến thống kê phức tạp."

date: 2026-10-05
updated: 2026-10-05

series: "The Book of Why"
series_order: 2

tags:
  - causal-inference
  - dags
  - statistics

status: draft
language: vi
---
```

Tưởng tượng một đội bắn súng thi hành án phạt. Khi lệnh từ tòa án được ban hành, vị đội trưởng sẽ phát tín hiệu, và hai xạ thủ A và B đồng thời nổ súng khiến phạm nhân thiệt mạng. Nếu chúng ta quan sát thấy xạ thủ A nổ súng, ta có thể suy ra xạ thủ B cũng đã nổ súng, dù phát bắn của A hoàn toàn không gây ra hành động của B. Thế nhưng, nếu một người can thiệp trực tiếp bằng cách ép xạ thủ A nổ súng mà không chờ lệnh của đội trưởng, xạ thủ B lại sẽ không nổ súng.

Tình huống giả định này xuất hiện ngay trong những chương đầu của cuốn *The Book of Why*, minh họa cho sự khác biệt căn bản giữa việc quan sát thụ động và can thiệp chủ động. Thống kê cổ điển dựa trên sự tương quan thường bất lực trong việc phân biệt hai trạng thái này. Để giải quyết vấn đề đó, Judea Pearl và các đồng nghiệp đã phát triển biểu đồ nhân quả (Causal Diagrams) — cụ thể là đồ thị có hướng không chu trình (Directed Acyclic Graph, hay DAG). Đây được coi là "ngôn ngữ tri thức" giúp biến trực giác nhân quả của con người thành công cụ toán học minh bạch.

## Causal Diagrams là gì và cấu trúc DAG vận hành ra sao?

Một biểu đồ nhân quả DAG về bản chất là một sơ đồ gồm các nút (dots/nodes) đại diện cho các biến số và các mũi tên (arrows) nối giữa chúng. Mũi tên chỉ từ biến \\(X\\) sang biến \\(Y\\) (\\(X \rightarrow Y\\)) biểu thị rằng \\(Y\\) "lắng nghe" \\(X\\) để xác định giá trị của chính mình. Khi giá trị của \\(X\\) thay đổi do can thiệp, giá trị của \\(Y\\) cũng sẽ thay đổi theo phản ứng với \\(X\\).

Tên gọi "Đồ thị có hướng không chu trình" (Directed Acyclic Graph) chứa đựng hai đặc tính cấu trúc cốt lõi. Tính chất "có hướng" (Directed) thể hiện rằng quan hệ nhân quả vận hành theo một chiều nhất định từ nguyên nhân đến kết quả. Tính chất "không chu trình" (Acyclic) quy định rằng một chuỗi nhân quả không thể quay ngược lại để tự gây ra chính nó trong cùng một mô hình, nghĩa là không tồn tại vòng lặp dạng \\(A \rightarrow B \rightarrow C \rightarrow A\\).

Điểm mạnh của DAG nằm ở tính minh bạch khi thể hiện các giả định khoa học. Khi chúng ta vẽ một mũi tên giữa hai nút, ta tuyên bố rằng có thể tồn tại một tác động nhân quả trực tiếp. Nhưng quan trọng hơn, khi chúng ta bỏ qua một mũi tên giữa hai nút, chúng ta đang đưa ra một giả định rất mạnh mẽ: giữa hai biến đó không có tác động nhân quả trực tiếp nào. Những giả định định tính này chính là nền tảng để máy tính hoặc nhà nghiên cứu phân tích dữ liệu một cách chính xác.

## Ba "mối nối" cơ bản điều phối luồng thông tin nhân quả

Để hiểu cách thông tin và sự phụ thuộc thống kê di chuyển trong một DAG, Pearl đã phân loại ba dạng cấu trúc nền tảng (gọi là các mối nối - junctions) kết nối ba biến số.

Cấu trúc đầu tiên là **Chuỗi (Chain: \\(A \rightarrow B \rightarrow C\\))**. Trong mô hình này, \\(B\\) đóng vai trò là biến trung gian (mediator). Thông tin nhân quả chảy từ \\(A\\) qua \\(B\\) rồi đến \\(C\\). Khi quan sát thụ động, \\(A\\) và \\(C\\) sẽ có tương quan với nhau. Tuy nhiên, nếu chúng ta kiểm soát hay cố định giá trị của \\(B\\), luồng thông tin giữa \\(A\\) và \\(C\\) sẽ bị chặn hoàn toàn, làm cho \\(A\\) và \\(C\\) trở nên độc lập với nhau. Hiện tượng này được gọi là sự chặn thông tin ("screening off").

Cấu trúc thứ hai là **Cái nĩa (Fork: \\(A \leftarrow B \rightarrow C\\))**. Ở đây, \\(B\\) là nguyên nhân chung (common cause) của cả \\(A\\) và \\(C\\), hay còn gọi là yếu tố gây nhiễu (confounder). Sự xuất hiện của \\(B\\) tạo ra một mối tương quan ảo giữa \\(A\\) và \\(C\\), dù giữa chúng không có liên hệ nhân quả trực tiếp. Ví dụ, độ tuổi (\\(B\\)) có thể ảnh hưởng đến cả thói quen đi bộ (\\(A\\)) và tỷ lệ tử vong (\\(C\\)). Để loại bỏ nhiễu và tìm ra hiệu ứng thực sự, ta phải chặn con đường gián tiếp này bằng cách kiểm soát biến \\(B\\).

Cấu trúc thứ ba là **Mối nối hội tụ (Collider: \\(A \rightarrow B \leftarrow C\\))**. Trong mô hình này, \\(A\\) và \\(C\\) là hai nguyên nhân độc lập cùng dẫn đến kết quả \\(B\\). Ban đầu, \\(A\\) và \\(C\\) không hề có liên quan hay tương quan với nhau — con đường giữa chúng tự động bị chặn tại \\(B\\). Tuy nhiên, nếu chúng ta can thiệp hoặc lọc dữ liệu dựa trên \\(B\\) (conditioning on a collider), con đường này sẽ vô tình bị mở ra, tạo ra một mối tương quan ảo giữa \\(A\\) và \\(C\\). Đây chính là nguồn gốc của thiên kiến collider (collider bias) hay hiệu ứng "explain-away", từng gây bối rối cho nhiều thế hệ nhà thống kê.

## Mở khóa dữ liệu quan sát bằng tiêu chuẩn cửa sau

Trước khi có sự xuất hiện của DAG, thói quen phổ biến trong thống kê truyền thống là kiểm soát tất cả các biến số thu thập được với hy vọng loại bỏ nhiễu. Tuy nhiên, việc kiểm soát vô tình một biến collider có thể mở ra những con đường nhiễu mới và làm sai lệch hoàn toàn kết quả nghiên cứu.

DAG giải quyết thách thức này bằng **Tiêu chuẩn cửa sau (Back-door Criterion)**. Một "con đường cửa sau" là bất kỳ con đường nào nối từ biến can thiệp \\(X\\) đến biến kết quả \\(Y\\) mà bắt đầu bằng một mũi tên chĩa vào \\(X\\). Những con đường này chính là nguồn gốc tạo ra tương quan ảo do yếu tố nhiễu gây ra. Tiêu chuẩn cửa sau cung cấp một quy tắc hình học đơn giản: để tính toán hiệu ứng can thiệp thực sự \\(P(Y | do(X))\\) từ dữ liệu quan sát thông thường, chúng ta chỉ cần kiểm soát một tập hợp các biến sao cho chặn đứng mọi con đường cửa sau, đồng thời không chặn bất kỳ con đường nhân quả trực tiếp nào và không kiểm soát bất kỳ biến con cháu nào của \\(X\\).

Bằng cách áp dụng tiêu chuẩn cửa sau cùng toán tử \\(do\\)-operator, biểu đồ nhân quả cho phép các nhà khoa học "mô phỏng" một thử nghiệm lâm sàng ngẫu nhiên ngay trên dữ liệu quan sát có sẵn mà không cần thực hiện can thiệp thực tế.

## Kết luận

Biểu đồ nhân quả DAG không đơn thuần là những hình vẽ minh họa trực quan, mà là một công cụ toán học chặt chẽ đưa khoa học suy luận nhân quả bước lên nấc thang mới. Việc minh bạch hóa các giả định dưới dạng các nút và mũi tên giúp chúng ta dễ dàng nhận diện yếu tố gây nhiễu, tránh bẫy thiên kiến collider và trích xuất chính xác tri thức nhân quả từ dữ liệu.

## References

- Pearl, J., & Mackenzie, D. (2018). *The Book of Why: The New Science of Cause and Effect*. Basic Books.

## Series