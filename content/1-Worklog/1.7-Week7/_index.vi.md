---
title: "Nhật ký công việc Tuần 7"
date: 2026-06-15
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
---

### Thời gian thực hiện

* **Tuần 7:** Từ ngày **2026-06-15** đến **2026-06-21**.

### Mục tiêu Tuần 7

* Hiểu khái niệm bảo mật nhiều lớp trên AWS.
* Tìm hiểu cách AWS WAF bảo vệ ứng dụng web trước các cuộc tấn công phổ biến.
* Hiểu Web ACL, Rule, Managed Rule Group và các hành động lọc request.
* Tìm hiểu vai trò cơ bản của Elastic Load Balancing trong việc phân phối lưu lượng ứng dụng.
* Hiểu cách AWS Network Firewall bảo vệ lưu lượng bên trong VPC.
* Phân biệt AWS WAF, Security Group, Network ACL và AWS Network Firewall.
* Tìm hiểu Amazon Inspector trong việc quản lý lỗ hổng và mức độ phơi nhiễm của tài nguyên.
* Xem xét các Security Finding có thể hỗ trợ cho dự án AWS CloudSOC cuối kỳ.

### Các công việc thực hiện trong tuần

| Ngày | Công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| --- | --- | --- | --- | --- |
| Thứ Hai | - Ôn lại kiến thức giám sát bảo mật của Tuần 6 <br> - Tìm hiểu khái niệm Defense in Depth <br> - Xác định các lớp bảo vệ trong kiến trúc AWS <br> - So sánh các biện pháp bảo mật phòng ngừa, phát hiện và phản ứng | 2026-06-15 | 2026-06-15 | <https://docs.aws.amazon.com/whitepapers/latest/aws-security-incident-response-guide/welcome.html> |
| Thứ Ba | - Tìm hiểu AWS WAF <br> - Hiểu Web ACL, Rule, Rule Group và Rule Priority <br> - Phân biệt các hành động Allow, Block, Count, CAPTCHA và Challenge <br> - Xem các tài nguyên AWS có thể được bảo vệ bằng AWS WAF | 2026-06-16 | 2026-06-16 | <https://docs.aws.amazon.com/waf/latest/developerguide/what-is-aws-waf.html> |
| Thứ Tư | - Tạo AWS WAF Web ACL <br> - Thêm AWS Managed Rules vào Web ACL <br> - Cấu hình Rule Priority và Default Action <br> - Xem Sampled Request và các chỉ số của Rule <br> - Kiểm tra khả năng lọc request khi điều kiện cho phép | 2026-06-17 | 2026-06-17 | <https://docs.aws.amazon.com/waf/latest/developerguide/web-acl-creating.html> |
| Thứ Năm | - Tìm hiểu Elastic Load Balancing và Application Load Balancer <br> - Hiểu Listener, Target Group, Health Check và cơ chế phân phối lưu lượng <br> - Xem cách AWS WAF được liên kết với Application Load Balancer <br> - Tìm hiểu vai trò của Load Balancer trong việc tăng tính sẵn sàng | 2026-06-18 | 2026-06-18 | <https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html> |
| Thứ Sáu | - Tìm hiểu AWS Network Firewall <br> - Hiểu Firewall Policy, Stateless Rule Group và Stateful Rule Group <br> - Xem xét yêu cầu thiết kế Subnet và định tuyến trong VPC <br> - So sánh AWS Network Firewall với Security Group và Network ACL | 2026-06-19 | 2026-06-19 | <https://docs.aws.amazon.com/network-firewall/latest/developerguide/what-is-aws-network-firewall.html> |
| Thứ Bảy | - Tìm hiểu Amazon Inspector <br> - Bật Amazon Inspector cho các tài nguyên được hỗ trợ khi phù hợp <br> - Xem các Finding liên quan đến EC2, ECR Container Image và Lambda <br> - Kiểm tra mức độ nghiêm trọng, lỗ hổng, tài nguyên bị ảnh hưởng và đề xuất khắc phục | 2026-06-20 | 2026-06-20 | <https://docs.aws.amazon.com/inspector/latest/user/what-is-inspector.html> |
| Chủ Nhật | - So sánh AWS WAF, AWS Network Firewall, Security Group và Network ACL <br> - Xem WAF Log, Firewall Log và Inspector Finding <br> - Xác định các nguồn dữ liệu bảo mật có thể tích hợp vào quy trình AWS CloudSOC <br> - Kiểm tra chi phí dịch vụ, xóa tài nguyên không cần thiết và hoàn thành nhật ký Tuần 7 | 2026-06-21 | 2026-06-21 | <https://aws.amazon.com/security/> |

### Kết quả đạt được trong Tuần 7

* Hiểu được khái niệm Defense in Depth và tầm quan trọng của việc sử dụng nhiều lớp bảo mật trong kiến trúc AWS.

* Xác định được ba nhóm biện pháp kiểm soát bảo mật chính:

  * Biện pháp phòng ngừa
  * Biện pháp phát hiện
  * Biện pháp phản ứng

* Hiểu vai trò của AWS WAF trong việc bảo vệ ứng dụng web trước các cuộc tấn công phổ biến và request không mong muốn.

* Nắm được các thành phần chính của AWS WAF, bao gồm:

  * Web ACL
  * Rule
  * Rule Group
  * Managed Rule Group
  * Rule Priority
  * Default Action

* Tìm hiểu các hành động xử lý request chính của AWS WAF:

  * Allow
  * Block
  * Count
  * CAPTCHA
  * Challenge

* Tạo Web ACL và thêm AWS Managed Rules.

* Hiểu cách Rule Priority ảnh hưởng đến thứ tự AWS WAF đánh giá các request gửi đến.

* Xem Sampled Request và Metrics để hiểu cách WAF Rule xử lý lưu lượng web.

* Hiểu vai trò cơ bản của Application Load Balancer trong việc phân phối lưu lượng đến nhiều Target.

* Nắm được các thành phần chính của Application Load Balancer, bao gồm:

  * Listener
  * Listener Rule
  * Target Group
  * Health Check
  * Registered Target

* Hiểu cách AWS WAF được liên kết với Application Load Balancer để bảo vệ ứng dụng web.

* Tìm hiểu kiến trúc cơ bản và mục đích sử dụng của AWS Network Firewall.

* Nắm được các thành phần chính của AWS Network Firewall, bao gồm:

  * Firewall
  * Firewall Policy
  * Stateless Rule Group
  * Stateful Rule Group
  * Firewall Endpoint
  * Logging Configuration

* Hiểu rằng AWS Network Firewall yêu cầu thiết kế Subnet và Route Table phù hợp để kiểm tra lưu lượng trong VPC.

* Phân biệt vai trò của các biện pháp bảo mật AWS:

  * AWS WAF bảo vệ ở tầng ứng dụng web.
  * AWS Network Firewall kiểm tra lưu lượng mạng bên trong VPC.
  * Security Group kiểm soát lưu lượng tại mức tài nguyên hoặc Network Interface.
  * Network ACL kiểm soát lưu lượng tại mức Subnet.

* Hiểu vai trò của Amazon Inspector trong việc liên tục phát hiện lỗ hổng phần mềm và mức độ phơi nhiễm mạng ngoài ý muốn.

* Xem các Amazon Inspector Finding và kiểm tra các thông tin như:

  * Finding Severity
  * Vulnerability Identifier
  * Affected Resource
  * Package Information
  * Network Exposure
  * Recommended Remediation

* Xác định AWS WAF Log, Network Firewall Log và Amazon Inspector Finding là các nguồn dữ liệu bảo mật hữu ích cho dự án AWS CloudSOC cuối kỳ.

* Kiểm tra chi phí dịch vụ và xóa các tài nguyên không cần thiết nhằm hạn chế phát sinh chi phí ngoài dự kiến.

* Hoàn thành Tuần 7 với kiến thức nền tảng về AWS WAF, Elastic Load Balancing, AWS Network Firewall, Amazon Inspector và mô hình bảo mật nhiều lớp trên AWS.