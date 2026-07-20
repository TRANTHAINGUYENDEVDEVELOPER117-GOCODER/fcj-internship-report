---
title: "Nhật ký công việc Tuần 10"
date: 2026-07-06
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

### Thời gian thực hiện

* **Tuần 10:** Từ ngày **2026-07-06** đến **2026-07-12**.

### Mục tiêu Tuần 10

* Hiểu quy trình phản ứng sự cố tự động đối với các cảnh báo liên quan đến Amazon EC2.
* Sử dụng AWS Lambda để kiểm tra Finding và thực hiện các hành động phản ứng.
* Sử dụng AWS Systems Manager để thu thập thông tin điều tra và thực thi lệnh phản ứng.
* Tạo Quarantine Security Group để cô lập EC2 Instance đáng ngờ.
* Kiểm tra Tag `AutoIsolate` trước khi thực hiện hành động tự động.
* Xây dựng riêng nhánh yêu cầu phê duyệt và nhánh phản ứng tự động.
* Lưu cấu hình ban đầu của EC2 trước khi cô lập.
* Cập nhật trạng thái sự cố trong Amazon DynamoDB.
* Lưu bằng chứng điều tra trong Amazon S3.
* Xây dựng quy trình hoàn tác và khôi phục EC2 Instance đã bị cô lập.
* Kiểm thử toàn bộ quy trình phản ứng sự cố tự động.

### Các công việc thực hiện trong tuần

| Ngày | Công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| --- | --- | --- | --- | --- |
| Thứ Hai | - Ôn lại Step Functions Workflow đã xây dựng trong Tuần 9 <br> - Xác định các hành động phản ứng tự động cần thiết đối với EC2 Finding <br> - Xác định điều kiện phản ứng dựa trên Severity, Resource Type, Instance ID và Tag `AutoIsolate` <br> - Xem xét các cơ chế an toàn để tránh cô lập nhầm tài nguyên | 2026-07-06 | 2026-07-06 | <https://docs.aws.amazon.com/whitepapers/latest/aws-security-incident-response-guide/welcome.html> |
| Thứ Ba | - Tạo Quarantine Security Group <br> - Cấu hình Inbound Rule và Outbound Rule hạn chế <br> - Tạo IAM Role và IAM Policy cần thiết cho Lambda và Systems Manager <br> - Áp dụng nguyên tắc đặc quyền tối thiểu cho các quyền phản ứng sự cố | 2026-07-07 | 2026-07-07 | <https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html> |
| Thứ Tư | - Tạo Lambda Function để kiểm tra EC2 Instance bị ảnh hưởng <br> - Sử dụng EC2 API để lấy Instance State, Tag, Network Interface và Security Group <br> - Kiểm tra Tag `AutoIsolate=true` <br> - Lưu cấu hình Security Group ban đầu trong DynamoDB trước khi thực hiện cô lập | 2026-07-08 | 2026-07-08 | <https://docs.aws.amazon.com/lambda/latest/dg/with-ec2-example.html> |
| Thứ Năm | - Tìm hiểu cách AWS Systems Manager hỗ trợ phản ứng sự cố <br> - Kiểm tra EC2 Instance đã được quản lý bởi Systems Manager hay chưa <br> - Sử dụng Run Command hoặc Automation để thu thập thông tin hệ thống và mạng <br> - Gửi kết quả điều tra và Command Output đến Amazon S3 hoặc CloudWatch Logs | 2026-07-09 | 2026-07-09 | <https://docs.aws.amazon.com/systems-manager/latest/userguide/run-command.html> |
| Thứ Sáu | - Xây dựng nhánh Approval Required cho Finding mức High <br> - Gửi yêu cầu phê duyệt đến SOC Analyst thông qua Amazon SNS <br> - Tìm hiểu Step Functions Callback Pattern sử dụng Task Token khi phù hợp <br> - Tiếp tục hoặc dừng quy trình phản ứng dựa trên quyết định của SOC Analyst | 2026-07-10 | 2026-07-10 | <https://docs.aws.amazon.com/step-functions/latest/dg/connect-to-resource.html#connect-wait-token> |
| Thứ Bảy | - Xây dựng nhánh Automated Response cho Finding mức Critical <br> - Gọi Lambda để thay thế Security Group ban đầu bằng Quarantine Security Group <br> - Sử dụng Systems Manager để thu thập thông tin điều tra <br> - Cập nhật trạng thái sự cố trong DynamoDB <br> - Lưu bằng chứng phản ứng trong Amazon S3 và gửi thông báo qua Amazon SNS | 2026-07-11 | 2026-07-11 | <https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyNetworkInterfaceAttribute.html> |
| Chủ Nhật | - Tạo Rollback Function để khôi phục Security Group ban đầu <br> - Kiểm thử các trường hợp Alert Only, Approval Required, Automated Response và Rollback <br> - Xem Step Functions Execution History, Lambda Logs, Systems Manager Output, DynamoDB Record và bằng chứng trong Amazon S3 <br> - Kiểm tra chi phí dịch vụ và hoàn thành nhật ký Tuần 10 | 2026-07-12 | 2026-07-12 | <https://docs.aws.amazon.com/step-functions/latest/dg/concepts-view-execution-details.html> |

### Kết quả đạt được trong Tuần 10

* Hiểu được các giai đoạn chính của quy trình phản ứng sự cố EC2 tự động:

  * Kiểm tra Finding
  * Xác minh tài nguyên
  * Đánh giá điều kiện phản ứng
  * Phê duyệt của SOC Analyst
  * Cô lập tài nguyên
  * Thu thập dữ liệu điều tra
  * Gửi thông báo
  * Khôi phục và hoàn tác

* Xác định các điều kiện cần thiết trước khi thực hiện cô lập tự động:

  * Tài nguyên bị ảnh hưởng phải là Amazon EC2 Instance.
  * Finding phải chứa EC2 Instance ID hợp lệ.
  * Severity phải đáp ứng ngưỡng phản ứng đã cấu hình.
  * EC2 Instance phải có Tag `AutoIsolate=true`.
  * Response Mode phải cho phép thực hiện hành động tự động.

* Tạo Quarantine Security Group để cô lập EC2 Instance đáng ngờ.

* Cấu hình các Security Group Rule hạn chế nhằm giảm khả năng giao tiếp mạng của EC2 trong thời gian xảy ra sự cố.

* Tạo IAM Role và IAM Policy cho:

  * AWS Lambda
  * AWS Step Functions
  * AWS Systems Manager
  * Amazon DynamoDB
  * Amazon S3
  * Amazon SNS

* Áp dụng nguyên tắc đặc quyền tối thiểu cho các thành phần phản ứng tự động.

* Tạo Lambda Function để lấy thông tin EC2, bao gồm:

  * Instance ID
  * Instance State
  * Instance Tag
  * VPC ID
  * Subnet ID
  * Network Interface ID
  * Security Group ID hiện tại

* Xây dựng cơ chế kiểm tra Tag `AutoIsolate`.

* Lưu cấu hình Security Group ban đầu của EC2 trong DynamoDB trước khi cô lập.

* Kiểm tra EC2 Instance có được đăng ký là Systems Manager Managed Node hay không.

* Sử dụng AWS Systems Manager Run Command hoặc Automation để thu thập thông tin điều tra, bao gồm:

  * Các Process đang chạy
  * Các kết nối mạng đang hoạt động
  * Người dùng đang đăng nhập
  * Thông tin hệ thống
  * Cấu hình mạng
  * Các sự kiện hệ thống gần đây

* Gửi kết quả thực thi lệnh điều tra đến Amazon S3 hoặc CloudWatch Logs.

* Xây dựng nhánh Approval Required cho Finding mức High.

* Gửi yêu cầu phê duyệt đến SOC Analyst thông qua Amazon SNS.

* Hiểu cách Step Functions Callback Pattern và Task Token được sử dụng để tạm dừng Workflow cho đến khi nhận được quyết định phê duyệt.

* Xây dựng nhánh Automated Response cho Finding mức Critical.

* Tạo Lambda Response Function để thay thế Security Group hiện tại bằng Quarantine Security Group.

* Cập nhật Incident Record trong DynamoDB với các thông tin như:

  * Response Status
  * Approval Status
  * Isolation Time
  * Original Security Groups
  * Quarantine Security Group
  * Systems Manager Command ID
  * Last Updated Time

* Lưu bằng chứng phản ứng sự cố và kết quả điều tra trong Amazon S3.

* Gửi thông báo kết quả phản ứng bảo mật thông qua Amazon SNS.

* Tạo Rollback Function để khôi phục Security Group ban đầu của EC2.

* Kiểm thử các trường hợp phản ứng chính:

  * **Alert Only:** Finding chỉ tạo cảnh báo mà không thay đổi tài nguyên.
  * **Approval Required:** Workflow chờ phê duyệt trước khi cô lập tài nguyên.
  * **Automated Response:** Finding mức Critical tự động kích hoạt quá trình cô lập EC2.
  * **Rollback:** Khôi phục Security Group ban đầu sau khi hoàn tất điều tra.

* Xem Step Functions Execution History để kiểm tra từng State và kết quả phản ứng.

* Xem Lambda Logs và Systems Manager Command Output để kiểm tra và xử lý lỗi.

* Xác nhận hoạt động của luồng phản ứng tự động trong Tuần 10:

  **Security Finding → EventBridge → Step Functions → Lambda Validation → Approval hoặc Automatic Isolation → Systems Manager Investigation → DynamoDB/S3 → SNS Notification**

* Hoàn thành Tuần 10 với kiến thức thực hành về cô lập EC2 tự động, phê duyệt của SOC Analyst, điều tra bằng AWS Systems Manager, theo dõi sự cố, lưu bằng chứng và khôi phục tài nguyên.