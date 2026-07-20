---
title: "Nhật ký công việc Tuần 4"
date: 2026-05-25
weight: 4
chapter: false
pre: " <b> 1.4. </b> "
---

### Thời gian thực hiện

* **Tuần 4:** Từ ngày **2026-05-25** đến **2026-05-31**.

### Mục tiêu Tuần 4

* Hiểu mô hình kết nối mạng hybrid giữa hệ thống nội bộ và AWS.
* Tìm hiểu nguyên lý hoạt động của AWS Site-to-Site VPN.
* Hiểu vai trò của Customer Gateway, Virtual Private Gateway và VPN Connection.
* Thực hành tạo các thành phần cần thiết cho kết nối VPN.
* Cấu hình Route Table để định tuyến lưu lượng qua VPN.
* Kiểm tra trạng thái VPN Tunnel và khả năng kết nối mạng.
* Tìm hiểu các yêu cầu bảo mật, tính sẵn sàng và chi phí của Site-to-Site VPN.

### Các công việc thực hiện trong tuần

| Ngày | Công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| --- | --- | --- | --- | --- |
| Thứ Hai | - Ôn lại kiến thức Amazon VPC của Tuần 3 <br> - Tìm hiểu khái niệm Hybrid Cloud và kết nối giữa mạng nội bộ với AWS <br> - Tìm hiểu các trường hợp sử dụng AWS Site-to-Site VPN | 2026-05-25 | 2026-05-25 | <https://cloudjourney.awsstudygroup.com/> |
| Thứ Ba | - Tìm hiểu kiến trúc AWS Site-to-Site VPN <br> - Hiểu vai trò của Customer Gateway, Virtual Private Gateway và VPN Connection <br> - Tìm hiểu địa chỉ IP công cộng, ASN và giao thức BGP | 2026-05-26 | 2026-05-26 | <https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html> |
| Thứ Tư | - Tạo Virtual Private Gateway <br> - Gắn Virtual Private Gateway vào VPC <br> - Tạo Customer Gateway đại diện cho thiết bị mạng phía on-premises <br> - Kiểm tra thông tin cấu hình của các Gateway | 2026-05-27 | 2026-05-27 | <https://docs.aws.amazon.com/vpn/latest/s2svpn/SetUpVPNConnections.html> |
| Thứ Năm | - Tạo AWS Site-to-Site VPN Connection <br> - Chọn phương thức định tuyến tĩnh hoặc động <br> - Tải file cấu hình VPN dành cho thiết bị Customer Gateway <br> - Tìm hiểu thông tin của hai VPN Tunnel | 2026-05-28 | 2026-05-28 | <https://docs.aws.amazon.com/vpn/latest/s2svpn/SetUpVPNConnections.html> |
| Thứ Sáu | - Cấu hình Route Table để định tuyến lưu lượng đến mạng nội bộ qua Virtual Private Gateway <br> - Kiểm tra CIDR của VPC và mạng on-premises để tránh trùng lặp <br> - Kiểm tra Security Group và Network ACL cho lưu lượng qua VPN | 2026-05-29 | 2026-05-29 | <https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html> |
| Thứ Bảy | - Kiểm tra trạng thái của hai VPN Tunnel <br> - Thực hiện kiểm tra kết nối giữa mạng mô phỏng on-premises và EC2 trong VPC khi điều kiện cho phép <br> - Xem thông tin Tunnel, Route và log liên quan <br> - Khắc phục một số lỗi cấu hình thường gặp | 2026-05-30 | 2026-05-30 | <https://docs.aws.amazon.com/vpn/latest/s2svpn/monitoring-cloudwatch-vpn.html> |
| Chủ Nhật | - Tìm hiểu tính sẵn sàng cao với hai VPN Tunnel <br> - Tìm hiểu phương pháp giám sát VPN bằng Amazon CloudWatch <br> - Kiểm tra chi phí của AWS Site-to-Site VPN <br> - Xóa tài nguyên không còn sử dụng và hoàn thành nhật ký Tuần 4 | 2026-05-31 | 2026-05-31 | <https://aws.amazon.com/vpn/pricing/> |

### Kết quả đạt được trong Tuần 4

* Hiểu được khái niệm Hybrid Cloud và nhu cầu kết nối hệ thống nội bộ với AWS.

* Nắm được các thành phần chính của AWS Site-to-Site VPN, bao gồm:

  * Customer Gateway
  * Virtual Private Gateway
  * VPN Connection
  * VPN Tunnel
  * Route Table
  * Static Routing
  * Dynamic Routing
  * Border Gateway Protocol

* Hiểu vai trò của Customer Gateway trong việc đại diện cho thiết bị mạng phía on-premises.

* Hiểu vai trò của Virtual Private Gateway trong việc kết nối VPC với hệ thống bên ngoài.

* Tạo và gắn Virtual Private Gateway vào Amazon VPC.

* Tạo Customer Gateway với thông tin mạng phù hợp.

* Tạo AWS Site-to-Site VPN Connection.

* Tìm hiểu cấu hình của hai VPN Tunnel do AWS cung cấp.

* Cấu hình Route Table để định tuyến lưu lượng giữa VPC và mạng on-premises.

* Hiểu tầm quan trọng của việc không sử dụng các dải CIDR bị trùng lặp.

* Kiểm tra trạng thái VPN Tunnel và các thông tin liên quan đến kết nối.

* Hiểu sự khác nhau cơ bản giữa định tuyến tĩnh và định tuyến động bằng BGP.

* Tìm hiểu vai trò của Security Group và Network ACL đối với lưu lượng đi qua VPN.

* Hiểu cách hai VPN Tunnel hỗ trợ tính sẵn sàng cao cho kết nối.

* Tìm hiểu cách giám sát trạng thái Site-to-Site VPN bằng Amazon CloudWatch.

* Kiểm tra và dọn dẹp các tài nguyên VPN không còn sử dụng để hạn chế phát sinh chi phí.

* Hoàn thành Tuần 4 với kiến thức cơ bản về kết nối hybrid, AWS Site-to-Site VPN, định tuyến và giám sát VPN.