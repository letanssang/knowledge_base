---
title: "Mô hình khuếch tán Bass: động lực tăng trưởng và bão hòa sản phẩm mới"
description: "Làm sao một sản phẩm mới từ chỗ vô danh có thể bùng nổ thành cơn sốt rồi đạt đỉnh bão hòa? Giải mã mô hình Bass kinh điển với sự kết hợp giữa quảng cáo và truyền miệng."

date:
updated:

series: "Business Dynamics"
series_order: 6

tags:
  - systems-thinking
  - bass-diffusion
  - marketing
  - business-dynamics

status: draft
language: vi
---

# Mô hình khuếch tán Bass: động lực tăng trưởng và bão hòa sản phẩm mới

Khi tung ra một sản phẩm hoặc công nghệ đột phá — từ TV màu, lò vi sóng, phần mềm SaaS cho đến xe điện — câu hỏi sinh tử của mọi nhà sáng lập và giám đốc marketing là: *Đường cong tăng trưởng khách hàng sẽ diễn ra như thế nào? Khi nào thì sản phẩm đạt đỉnh và doanh số bắt đầu chững lại?*

Trong chương 9 của *Business Dynamics*, John Sterman dành trọn sự chú ý cho **Mô hình khuếch tán Bass (Bass Diffusion Model)** — công trình được phát triển bởi Frank Bass vào năm 1969 và trở thành một trong những mô hình ứng dụng vĩ đại nhất của System Dynamics trong kinh doanh. Mô hình Bass không chỉ giải thích trọn vẹn đường cong hình chữ S của các đợt bùng nổ công nghệ mà còn cung cấp cơ sở định lượng để dự báo chính xác nhu cầu thị trường.

## Cấu trúc Stock & Flow của sự khuếch tán

Mô hình Bass chia toàn bộ thị trường tiềm năng thành hai kho chứa (*stocks*) cơ bản:
1. **Khách hàng tiềm năng (Potential Adopters):** Những người chưa mua sản phẩm nhưng có khả năng sẽ mua.
2. **Người đã áp dụng (Adopters):** Những người đã mua và đang sử dụng sản phẩm.

Dòng chảy duy nhất kết nối hai kho này là **Tốc độ chấp nhận sản phẩm (Adoption Rate)** — tức số lượng người chuyển từ trạng thái "tiềm năng" sang "đã mua" trong mỗi đơn vị thời gian. 

Điểm thiên tài của Frank Bass là nhận ra rằng dòng chảy chấp nhận này được thúc đẩy bởi hai cơ chế phản hồi hoàn toàn khác nhau: **Ảnh hưởng từ bên ngoài (Quảng cáo)** và **Ảnh hưởng từ bên trong (Truyền miệng)**.

## Hai động cơ thúc đẩy: Innovators vs. Imitators

Sterman phân rã tốc độ chấp nhận sản phẩm thành hai nguồn động lực:

$$\text{Adoption Rate} = \text{Adoption from Advertising} + \text{Adoption from Word of Mouth}$$

1. **Hiệu ứng Quảng cáo (Vòng lặp Cân bằng mở đường):**
   - Đại diện cho những người tiên phong (*Innovators*). Họ là những người mua sản phẩm vì nhìn thấy quảng cáo trên truyền hình, báo chí hay mạng xã hội. 
   - Số người mua do quảng cáo tỷ lệ thuận với số lượng khách hàng tiềm năng còn lại: $\text{Adoption}_{\text{ad}} = p \times \text{Potential Adopters}$ (với $p$ là hệ số đổi mới / quảng cáo).
   - Cơ chế này đóng vai trò "mồi lửa" ban đầu: khi chưa có ai sử dụng sản phẩm, quảng cáo là cách duy nhất đưa những khách hàng đầu tiên vào hệ thống.
2. **Hiệu ứng Truyền miệng (Vòng lặp Tự củng cố bùng nổ):**
   - Đại diện cho số đông bắt chước (*Imitators*). Những người này không tin vào quảng cáo; họ chỉ mua khi nhìn thấy bạn bè, đồng nghiệp xung quanh đã dùng và khen ngợi.
   - Tốc độ truyền miệng phụ thuộc vào sự tiếp xúc giữa người đã dùng và người chưa dùng: $\text{Adoption}_{\text{wom}} = q \times \text{Potential Adopters} \times \left(\frac{\text{Adopters}}{\text{Total Market}}\right)$ (với $q$ là hệ số bắt chước / truyền miệng).
   - Đây chính là **vòng tự củng cố (Reinforcing Loop)**: Càng có nhiều người dùng $	o$ Càng có nhiều cuộc trò chuyện truyền miệng $	o$ Càng thuyết phục được nhiều người mới mua $	o$ Số người dùng lại càng tăng vọt.

## Điểm uốn và bài học xương máu về việc bão hòa

Khi sản phẩm mới bắt đầu cất cánh, vòng truyền miệng hoạt động như một cơn lốc, đẩy doanh số tăng trưởng theo cấp số nhân. Các nhà quản lý thường ngộ nhận rằng thành công này là vĩnh cửu và vội vã vay vốn, mở rộng nhà máy, tuyển dụng ồ ạt để đón đầu làn sóng tăng trưởng tiếp theo.

Thế nhưng, mô hình Bass cảnh báo một quy luật nghiệt ngã: **mỗi khách hàng mới gia nhập nhóm Adopters cũng đồng nghĩa với việc kho Potential Adopters bị rút bớt đi một người.**

Đến một thời điểm (thường là khi khoảng 50% thị trường tiềm năng đã được khai phá), số lượng người chưa mua bắt đầu cạn kiệt. Cơ hội gặp gỡ giữa người đã dùng và người chưa mua giảm dần. Lúc này, vòng cân bằng do cạn kiệt thị trường giành lại quyền kiểm soát. Doanh số bán mới đạt đỉnh và bắt đầu sụt giảm mạnh mẽ!

Nếu doanh nghiệp không chuẩn bị cho giai đoạn này, họ sẽ rơi vào cái bẫy dư thừa công suất nghiêm trọng. Sau khi thị trường đạt bão hòa, dòng doanh thu mới sẽ chỉ còn trông chờ vào **nhu cầu thay thế (replacement purchases)** từ khách hàng cũ, một con số thường nhỏ hơn rất nhiều so với thời kỳ bùng nổ đỉnh cao.

Hiểu mô hình Bass giúp các chiến lược gia biết khi nào nên đầu tư mạnh vào marketing để mồi lửa, khi nào nên tối ưu hóa trải nghiệm sản phẩm để kích hoạt vòng truyền miệng, và quan trọng nhất: khi nào nên chuẩn bị tâm thế cho sự bão hòa tất yếu của thị trường.

## References

- John D. Sterman, *Business Dynamics: Systems Thinking and Modeling for a Complex World*, Irwin/McGraw-Hill, 2000. (Chapter 9: S-Shaped Growth: Epidemics, Innovation Diffusion, and the Growth of New Products, pp. 295–348).

## Series

- Previous: [Các dạng hành vi động cơ bản: từ tăng trưởng cấp số nhân đến sụp đổ](../05-fundamental-modes-of-dynamic-behavior/index.md)
- Next: [Phụ thuộc đường mòn (Path Dependence) và hiệu ứng khóa mạng (Lock-in)](../07-path-dependence-and-lock-in/index.md)
