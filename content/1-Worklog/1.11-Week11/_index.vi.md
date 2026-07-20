---
title: "Nhật ký công việc Tuần 11"
date: 2026-07-13
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

### Thời gian thực hiện

* **Tuần 11:** Từ ngày **2026-07-13** đến **2026-07-19**.

### Mục tiêu Tuần 11

* Thực hiện kiểm thử toàn bộ quy trình phản ứng sự cố của hệ thống AWS CloudSOC.
* Xác minh khả năng tích hợp giữa các dịch vụ phát hiện, điều phối, phản ứng, lưu trữ và gửi thông báo.
* Kiểm thử nhiều tình huống Security Finding và các nhánh phản ứng khác nhau.
* Kiểm tra quyền IAM và áp dụng nguyên tắc đặc quyền tối thiểu.
* Xem xét cơ chế giám sát, ghi log, xử lý lỗi và khôi phục hệ thống.
* Đánh giá kiến trúc theo các nguyên tắc của AWS Well-Architected Framework.
* Xem xét các yếu tố bảo mật, độ tin cậy, hiệu suất, vận hành và tối ưu chi phí.
* Hoàn thiện sơ đồ kiến trúc AWS CloudSOC.
* Ghi lại các trường hợp kiểm thử, lỗi phát hiện và phương án khắc phục.
* Chuẩn bị dự án AWS CloudSOC cho giai đoạn báo cáo và thuyết trình cuối kỳ.

### Các công việc thực hiện trong tuần

| Ngày | Công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| --- | --- | --- | --- | --- |
| Thứ Hai | - Xem lại toàn bộ kiến trúc AWS CloudSOC đã xây dựng trong các tuần trước <br> - Kiểm tra kết nối giữa GuardDuty, Security Hub, EventBridge, Step Functions, Lambda, Systems Manager, DynamoDB, S3 và SNS <br> - Xác định các Test Case và kết quả mong đợi cho toàn bộ Workflow | 2026-07-13 | 2026-07-13 | <https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html> |
| Thứ Ba | - Kiểm thử nhánh Alert Only bằng tài nguyên không được hỗ trợ và Finding mức Low hoặc Medium <br> - Xác minh hệ thống không thực hiện hành động cô lập <br> - Kiểm tra thông tin sự cố được lưu và thông báo được gửi thành công <br> - Xem Step Functions Execution History và Lambda Logs | 2026-07-14 | 2026-07-14 | <https://docs.aws.amazon.com/step-functions/latest/dg/concepts-view-execution-details.html> |
| Thứ Tư | - Kiểm thử nhánh Approval Required bằng EC2 Finding mức High <br> - Kiểm tra thông báo yêu cầu phê duyệt và trạng thái chờ của Workflow <br> - Kiểm thử trường hợp phê duyệt và từ chối <br> - Xác nhận Workflow tiếp tục hoặc dừng theo quyết định của SOC Analyst | 2026-07-15 | 2026-07-15 | <https://docs.aws.amazon.com/step-functions/latest/dg/connect-to-resource.html#connect-wait-token> |
| Thứ Năm | - Kiểm thử nhánh Automated Response bằng EC2 Finding mức Critical có Tag `AutoIsolate=true` <br> - Xác minh quá trình kiểm tra EC2, thay thế Security Group, thu thập dữ liệu bằng Systems Manager, cập nhật DynamoDB, lưu bằng chứng trong S3 và gửi thông báo SNS <br> - Kiểm thử quy trình Rollback để khôi phục Security Group ban đầu | 2026-07-16 | 2026-07-16 | <https://docs.aws.amazon.com/whitepapers/latest/aws-security-incident-response-guide/welcome.html> |
| Thứ Sáu | - Kiểm thử các trường hợp lỗi như thiếu Instance ID, sai Resource Type, thiếu Tag, Lambda thất bại, lỗi quyền IAM và Systems Manager không khả dụng <br> - Kiểm tra các nhánh Retry, Catch, Fail và gửi thông báo lỗi <br> - Xem CloudWatch Logs và khắc phục các lỗi được phát hiện | 2026-07-17 | 2026-07-17 | <https://docs.aws.amazon.com/step-functions/latest/dg/concepts-error-handling.html> |
| Thứ Bảy | - Đánh giá kiến trúc theo AWS Well-Architected Framework <br> - Xem xét Operational Excellence, Security, Reliability, Performance Efficiency, Cost Optimization và Sustainability <br> - Kiểm tra IAM Role, Resource Policy, mã hóa, ghi log, tính sẵn sàng và chi phí dịch vụ <br> - Xác định các điểm cần cải tiến trong kiến trúc | 2026-07-18 | 2026-07-18 | <https://docs.aws.amazon.com/wellarchitected/latest/framework/the-pillars-of-the-framework.html> |
| Chủ Nhật | - Hoàn thiện sơ đồ kiến trúc AWS CloudSOC <br> - Bổ sung nhóm dịch vụ AWS, luồng dữ liệu, số thứ tự sự kiện, ranh giới tin cậy và ghi chú giải thích <br> - Ghi lại Test Case, kết quả, lỗi và phương án khắc phục <br> - Kiểm tra các tài nguyên đang hoạt động và chi phí dự kiến <br> - Hoàn thành nhật ký Tuần 11 | 2026-07-19 | 2026-07-19 | <https://aws.amazon.com/architecture/> |

### Kết quả đạt được trong Tuần 11

* Hoàn thành việc xem xét toàn bộ kiến trúc AWS CloudSOC.

* Kiểm tra khả năng tích hợp của các dịch vụ AWS chính, bao gồm:

  * Amazon GuardDuty
  * AWS Security Hub
  * Amazon EventBridge
  * AWS Step Functions
  * AWS Lambda
  * AWS Systems Manager
  * Amazon DynamoDB
  * Amazon S3
  * Amazon SNS
  * Amazon CloudWatch
  * AWS CloudTrail

* Xác nhận hoạt động của quy trình phản ứng sự cố chính:

  **GuardDuty hoặc Security Hub → EventBridge → Step Functions → Lambda Evaluation → Response Branch → Systems Manager → DynamoDB/S3 → SNS**

* Xây dựng các Test Case cho nhiều điều kiện Security Finding khác nhau, bao gồm:

  * Resource Type không được hỗ trợ
  * Thiếu EC2 Instance ID
  * Thiếu Tag `AutoIsolate`
  * Finding mức Low
  * Finding mức Medium
  * Finding mức High
  * Finding mức Critical
  * Lambda thực thi thất bại
  * Lỗi quyền IAM
  * Systems Manager không khả dụng
  * Yêu cầu Rollback

* Kiểm thử thành công nhánh Alert Only.

* Xác minh Finding mức Low và Medium chỉ tạo thông báo mà không thay đổi tài nguyên bị ảnh hưởng.

* Xác nhận thông tin sự cố được lưu trong DynamoDB và bằng chứng được lưu trong Amazon S3 khi cần thiết.

* Kiểm thử thành công nhánh Approval Required cho EC2 Finding mức High.

* Xác minh Step Functions Workflow có thể tạm dừng trong khi chờ quyết định của SOC Analyst.

* Kiểm thử cả hai trường hợp phê duyệt và từ chối.

* Xác nhận Workflow chỉ tiếp tục sau khi nhận được quyết định phê duyệt hợp lệ.

* Kiểm thử thành công nhánh Automated Response cho EC2 Finding mức Critical.

* Xác minh các bước phản ứng tự động:

  * Kiểm tra tài nguyên bị ảnh hưởng.
  * Kiểm tra EC2 Instance ID.
  * Kiểm tra Tag `AutoIsolate=true`.
  * Lưu cấu hình Security Group ban đầu.
  * Gắn Quarantine Security Group.
  * Thu thập dữ liệu điều tra bằng Systems Manager.
  * Cập nhật Incident Record trong DynamoDB.
  * Lưu bằng chứng trong Amazon S3.
  * Gửi thông báo phản ứng qua Amazon SNS.

* Kiểm thử thành công quy trình Rollback.

* Khôi phục Security Group ban đầu của EC2 Instance sau khi hoàn tất điều tra.

* Kiểm thử cơ chế xử lý lỗi đối với các trường hợp thiếu dữ liệu và lỗi khi gọi dịch vụ.

* Xác minh hoạt động của các cấu hình Step Functions, bao gồm:

  * Retry
  * Catch
  * Fail State
  * Timeout
  * Error Notification

* Xem Step Functions Execution History để kiểm tra từng State, Input, Output, lỗi và kết quả thực thi.

* Xem CloudWatch Logs để kiểm tra và xử lý lỗi của Lambda và Systems Manager.

* Xác minh các hành động quan trọng được AWS CloudTrail ghi lại.

* Xem lại IAM Role và IAM Policy được sử dụng trong hệ thống AWS CloudSOC.

* Loại bỏ các quyền không cần thiết và cải thiện việc áp dụng nguyên tắc đặc quyền tối thiểu.

* Xem xét các biện pháp bảo mật, bao gồm:

  * IAM Permission
  * Multi-Factor Authentication
  * S3 Block Public Access
  * Server-side Encryption
  * Resource Policy
  * Security Group
  * Logging và Monitoring
  * Bảo vệ bằng chứng sự cố

* Đánh giá kiến trúc theo sáu trụ cột của AWS Well-Architected Framework:

  * Operational Excellence
  * Security
  * Reliability
  * Performance Efficiency
  * Cost Optimization
  * Sustainability

* Xác định một số điểm cần cải tiến trong kiến trúc, bao gồm:

  * Thu hẹp phạm vi quyền IAM.
  * Bổ sung CloudWatch Metrics và Alarm chi tiết hơn.
  * Cải thiện cơ chế gửi thông báo khi Workflow thất bại.
  * Bổ sung Dead-Letter Queue tại các vị trí phù hợp.
  * Xác định chính sách lưu giữ Incident Record.
  * Cải thiện mã hóa và Lifecycle Policy cho bằng chứng.
  * Hạn chế sử dụng các tài nguyên trả phí không cần thiết.

* Kiểm tra mức sử dụng tài nguyên và chi phí có thể phát sinh từ:

  * Amazon EC2
  * NAT Gateway
  * AWS Site-to-Site VPN
  * AWS Network Firewall
  * Amazon GuardDuty
  * AWS Security Hub
  * AWS Step Functions
  * AWS Lambda
  * Amazon DynamoDB
  * Amazon S3
  * Amazon CloudWatch

* Hoàn thiện sơ đồ kiến trúc AWS CloudSOC.

* Sắp xếp sơ đồ kiến trúc thành các tầng chức năng rõ ràng:

  * Bảo vệ biên và mạng
  * Giám sát và phát hiện bảo mật
  * Định tuyến sự kiện bảo mật
  * Điều phối phản ứng sự cố
  * Cô lập và điều tra tự động
  * Lưu trữ bằng chứng và thông tin sự cố
  * Gửi thông báo và giám sát

* Bổ sung số thứ tự luồng sự kiện và ghi chú giải thích để sơ đồ dễ hiểu hơn.

* Ghi lại các Test Case, kết quả mong đợi, kết quả thực tế, lỗi phát hiện và phương án khắc phục.

* Chuẩn bị hệ thống AWS CloudSOC cho báo cáo cuối kỳ, bài thuyết trình, phần demo, kiểm tra chi phí và nộp sản phẩm trong Tuần 12.

* Hoàn thành Tuần 11 với kiến thức thực hành về kiểm thử toàn bộ quy trình bảo mật, đánh giá AWS Well-Architected, xử lý lỗi, xác minh kiến trúc và lập tài liệu dự án.