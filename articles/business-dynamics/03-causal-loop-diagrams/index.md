---
title: "Causal Loop Diagrams (CLD): quy tắc vẽ sơ đồ nhân quả chuẩn xác"
description: "Làm sao để vẽ sơ đồ vòng lặp nhân quả mà không biến nó thành một mớ bòng bong vô nghĩa? Nắm vững các nguyên tắc gán dấu phân cực và phân biệt tương quan với nhân quả."

date:
updated:

series: "Business Dynamics"
series_order: 3

tags:
  - systems-thinking
  - causal-loop-diagram
  - cld
  - business-dynamics

status: draft
language: vi
---

# Causal Loop Diagrams (CLD): quy tắc vẽ sơ đồ nhân quả chuẩn xác

Khi tiếp xúc với tư duy hệ thống, hầu hết mọi người đều rất hào hứng vẽ các sơ đồ vòng lặp nhân quả (**Causal Loop Diagrams - CLD**). Những mũi tên uốn lượn nối các danh từ với nhau trông rất ấn tượng và mang lại cảm giác chúng ta đang thấu suốt mọi mối liên hệ phức tạp của tổ chức.

Tuy nhiên, trong chương 5 của *Business Dynamics*, John Sterman đã đưa ra một cảnh báo nghiêm khắc: phần lớn các sơ đồ CLD được vẽ trong doanh nghiệp đều mắc lỗi nghiêm trọng. Người ta thường nhầm lẫn giữa tương quan thống kê và quan hệ nhân quả, gán sai dấu cực của các mũi tên, hoặc dùng những nhãn tên mập mờ khiến vòng lặp mất đi ý nghĩa dự báo hành vi. Một sơ đồ CLD bị lỗi không những vô giá trị mà còn dẫn dắt các nhà lãnh đạo đến những quyết định sai lầm chết người.

## Phân cực của mối liên kết: Dấu cộng (+) và Dấu trừ (-) nghĩa là gì?

Nguyên tắc căn bản nhất nhưng cũng dễ hiểu sai nhất của sơ đồ CLD là xác định **phân cực của liên kết (link polarity)**. Khi vẽ một mũi tên từ biến $X$ sang biến $Y$, chúng ta phải gán dấu $+$ hoặc $-$ ở đầu mũi tên.

Ý nghĩa chuẩn mực theo định nghĩa toán học của System Dynamics như sau:
- **Dấu cộng (+):** Mối liên kết cùng chiều. Nếu $X$ tăng, $Y$ sẽ tăng cao hơn mức đáng lẽ của nó (khi các yếu tố khác giữ nguyên). Và ngược lại, nếu $X$ giảm, $Y$ sẽ giảm thấp hơn mức đáng lẽ của nó. Nói cách khác, đạo hàm riêng là dương: $\frac{\partial Y}{\partial X} > 0$.
- **Dấu trừ (-):** Mối liên kết ngược chiều. Nếu $X$ tăng, $Y$ sẽ giảm thấp hơn mức đáng lẽ của nó. Và nếu $X$ giảm, $Y$ sẽ tăng cao hơn mức đáng lẽ của nó ($\frac{\partial Y}{\partial X} < 0$).

**Lỗi phổ biến cần tránh:** Đừng bao giờ nhầm lẫn dấu $+$ với việc "làm tăng giá trị tuyệt đối" hay dấu $-$ là "điều tiêu cực/xấu". Dấu $+$ đơn thuần chỉ là quan hệ biến thiên cùng chiều; nó hoàn toàn có thể là: *Số ca nhiễm bệnh tăng (+) $	o$ Số người tử vong tăng (+)*.

## Phân cực của toàn bộ vòng lặp: Vòng Củng cố hay Cân bằng?

Khi các mũi tên khép lại thành một chu trình kín, chúng ta cần xác định phân cực của cả vòng lặp (**loop polarity**): đó là vòng tự củng cố (**Reinforcing - R**) hay vòng cân bằng (**Balancing - B**)?

Quy tắc xác định rất đơn giản và chuẩn xác:
1. **Đếm số lượng dấu trừ (-) trong toàn bộ vòng lặp.**
2. Nếu số lượng dấu trừ là **chẵn** (0, 2, 4,...): Vòng lặp đó là **Reinforcing (R)** — tự củng cố, khuếch đại theo cấp số nhân.
3. Nếu số lượng dấu trừ là **lẻ** (1, 3, 5,...): Vòng lặp đó là **Balancing (B)** — cân bằng, tìm kiếm mục tiêu và tự điều chỉnh sai lệch.

Hãy thử kiểm tra vòng lặp sau: *Giá sản phẩm tăng (+) $	o$ Doanh số bán ra giảm (-) $	o$ Lượng hàng tồn kho tăng (+) $	o$ Áp lực giảm giá tăng (+) $	o$ Giá sản phẩm giảm (-)*. Có đúng 2 dấu trừ (chẵn) $	o$ Đây là một vòng lặp củng cố hay cân bằng? Hãy đếm kỹ từng mắt xích để thấy bản chất điều chỉnh của thị trường!

## 4 nguyên tắc vàng để vẽ CLD sáng rõ và có giá trị

Để sơ đồ CLD của bạn trở thành công cụ phân tích sắc bén thay vì một mớ tranh vẽ trang trí, Sterman đề ra 4 nguyên tắc vàng:

1. **Nhân quả (Causation) chứ không phải Tương quan (Correlation):** Hai sự kiện cùng xảy ra không có nghĩa cái này sinh ra cái kia. Ví dụ: doanh số bán kem và số vụ chết đuối đều tăng vào mùa hè (tương quan), nhưng bạn không thể vẽ mũi tên *Bán kem (+) $	o$ Chết đuối*. Liên kết chỉ hợp lệ khi tồn tại một cơ chế vật lý hoặc dòng thông tin trực tiếp truyền động lực từ biến này sang biến kia.
2. **Đặt tên biến số trung tính (Direction-free labels):** Luôn đặt tên biến bằng danh từ mô tả trạng thái, không dùng tính từ chỉ chiều hướng. Hãy viết *"Chi phí tiếp thị"* thay vì *"Tăng chi phí tiếp thị"*; viết *"Chất lượng dịch vụ"* thay vì *"Dịch vụ kém"*. Nếu bạn cho sẵn chiều hướng vào tên biến, bạn sẽ không thể đảo chiều phân tích khi hệ thống biến động.
3. **Đánh dấu rõ ràng độ trễ (Delays):** Mọi mối liên kết có độ trễ thời gian đáng kể phải được đánh dấu bằng hai gạch ngang ngắn qua mũi tên ($//$). Độ trễ chính là nguồn gốc gây ra dao động và hành vi phản kháng của hệ thống; giấu đi độ trễ là tự che mắt mình trước hiểm họa.
4. **Không biến CLD thành mạng nhện:** Một sơ đồ hiệu quả chỉ nên chứa từ 3 đến 6 vòng lặp cốt lõi giải thích một vấn đề cụ thể. Nếu bạn thấy sơ đồ của mình chằng chịt hàng chục mũi tên đan chéo, hãy tách nó thành các lát cắt nhỏ hơn hoặc chuyển sang sơ đồ Stock and Flow để định lượng rõ ràng.

## References

- John D. Sterman, *Business Dynamics: Systems Thinking and Modeling for a Complex World*, Irwin/McGraw-Hill, 2000. (Chapter 5: Causal Loop Diagrams, pp. 137–190).

## Series

- Previous: [Mô hình hóa hệ thống: từ hiện tượng thực tế đến Dynamic Hypothesis](../02-modeling-process-and-dynamic-hypothesis/index.md)
- Next: [Bản chất của Stock và Flow: cấu trúc tích tụ trong doanh nghiệp](../04-stocks-and-flows-in-business/index.md)
