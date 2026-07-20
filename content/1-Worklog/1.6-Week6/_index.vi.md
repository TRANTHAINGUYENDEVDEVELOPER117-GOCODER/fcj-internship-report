---
title: "Nhật ký công việc Tuần 6"
date: 2026-06-08
weight: 6
chapter: false
pre: " <b> 1.6. </b> "
---

### Thời gian thực hiện

* **Tuần 6:** Từ ngày **2026-06-08** đến **2026-06-14**.

### Mục tiêu Tuần 6

* Hiểu tầm quan trọng của việc ghi log bảo mật và phát hiện mối đe dọa trên AWS.
* Tìm hiểu cách AWS CloudTrail ghi lại các hoạt động được thực hiện trong tài khoản AWS.
* Cấu hình CloudTrail Trail để lưu trữ nhật ký hoạt động trong Amazon S3.
* Tìm hiểu cách Amazon GuardDuty phát hiện các hoạt động đáng ngờ và mối đe dọa tiềm ẩn.
* Hiểu mức độ nghiêm trọng, thông tin tài nguyên và hành động đề xuất trong GuardDuty Finding.
* Tìm hiểu cách AWS Security Hub tập trung các Security Finding từ nhiều dịch vụ AWS.
* Ôn lại các nguyên tắc bảo mật IAM, bao gồm đặc quyền tối thiểu và xác thực đa yếu tố.
* Xây dựng nền tảng cho quy trình phản ứng sự cố tự động trong dự án cuối kỳ.

### Các công việc thực hiện trong tuần

| Ngày | Công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| --- | --- | --- | --- | --- |
| Thứ Hai | - Ôn lại kiến thức giám sát và ghi log của Tuần 5 <br> - Tìm hiểu các khái niệm cơ bản về giám sát bảo mật trên cloud <br> - Ôn lại AWS Shared Responsibility Model <br> - Hiểu sự khác nhau giữa giám sát vận hành và giám sát bảo mật | 2026-06-08 | 2026-06-08 | <https://aws.amazon.com/compliance/shared-responsibility-model/> |
| Thứ Ba | - Tìm hiểu AWS CloudTrail <br> - Xem CloudTrail Event History <br> - Hiểu Management Event và Data Event <br> - Xác định các thông tin như danh tính người dùng, thời gian sự kiện, địa chỉ IP nguồn, dịch vụ và hành động API | 2026-06-09 | 2026-06-09 | <https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html> |
| Thứ Tư | - Tạo một CloudTrail Trail <br> - Cấu hình Trail để gửi file log đến Amazon S3 Bucket <br> - Bật tính năng xác thực tính toàn vẹn của file log khi cần thiết <br> - Thực hiện một số thao tác bằng AWS Console hoặc AWS CLI và kiểm tra các sự kiện đã được ghi lại | 2026-06-10 | 2026-06-10 | <https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-create-and-update-a-trail.html> |
| Thứ Năm | - Tìm hiểu Amazon GuardDuty <br> - Bật GuardDuty trong AWS Region đã chọn <br> - Hiểu cách GuardDuty phân tích hoạt động AWS và các nguồn dữ liệu liên quan đến mạng <br> - Tìm hiểu các nhóm Finding và mức độ nghiêm trọng | 2026-06-11 | 2026-06-11 | <https://docs.aws.amazon.com/guardduty/latest/ug/what-is-guardduty.html> |
| Thứ Sáu | - Tạo hoặc xem các GuardDuty Sample Finding <br> - Kiểm tra Finding Type, tài nguyên bị ảnh hưởng, mức độ nghiêm trọng, tài khoản, Region và hành động đề xuất <br> - So sánh các mức Low, Medium, High và Critical <br> - Ghi lại các trường dữ liệu quan trọng để sử dụng trong dự án phản ứng sự cố cuối kỳ | 2026-06-12 | 2026-06-12 | <https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_findings.html> |
| Thứ Bảy | - Tìm hiểu AWS Security Hub <br> - Bật Security Hub trong Region đã chọn <br> - Xem các Security Standard, Control, Insight và Finding <br> - Kiểm tra cách GuardDuty Finding được tập trung trong Security Hub <br> - Tìm hiểu AWS Security Finding Format | 2026-06-13 | 2026-06-13 | <https://docs.aws.amazon.com/securityhub/latest/userguide/what-is-securityhub.html> |
| Chủ Nhật | - Ôn lại các nguyên tắc bảo mật IAM <br> - Kiểm tra MFA của tài khoản root, IAM User, IAM Role và IAM Policy <br> - Ôn lại nguyên tắc đặc quyền tối thiểu <br> - Kiểm tra trạng thái và chi phí có thể phát sinh từ CloudTrail, GuardDuty, Security Hub và Amazon S3 <br> - Hoàn thành nhật ký Tuần 6 | 2026-06-14 | 2026-06-14 | <https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html> |

### Kết quả đạt được trong Tuần 6

* Hiểu được tầm quan trọng của khả năng quan sát bảo mật, ghi nhật ký hoạt động và phát hiện mối đe dọa trong môi trường AWS.

* Ôn lại AWS Shared Responsibility Model và hiểu trách nhiệm bảo mật của AWS và khách hàng.

* Hiểu vai trò của AWS CloudTrail trong việc ghi lại các hoạt động được thực hiện thông qua:

  * AWS Management Console
  * AWS Command Line Interface
  * AWS SDK
  * AWS Service API

* Xem CloudTrail Event History và xác định các thông tin quan trọng của sự kiện, bao gồm:

  * Event Name
  * Event Time
  * AWS Service
  * User Identity
  * Source IP Address
  * AWS Region
  * Resource Information

* Hiểu sự khác nhau giữa Management Event và Data Event.

* Tạo CloudTrail Trail và cấu hình gửi file log đến Amazon S3 Bucket.

* Kiểm tra và xác nhận các hoạt động trong tài khoản AWS đã được CloudTrail ghi lại.

* Hiểu vai trò của Amazon GuardDuty trong việc liên tục phát hiện các hoạt động đáng ngờ và mối đe dọa bảo mật tiềm ẩn.

* Bật Amazon GuardDuty trong AWS Region đã chọn.

* Xem các thông tin quan trọng của GuardDuty Finding, bao gồm:

  * Finding Type
  * Severity
  * Affected Resource
  * AWS Account
  * AWS Region
  * Recommended Response Action

* Xem các GuardDuty Sample Finding và học cách đánh giá mức độ ảnh hưởng của từng cảnh báo.

* Hiểu mục đích của AWS Security Hub trong việc quản lý trạng thái bảo mật và tập trung Security Finding.

* Bật AWS Security Hub và tìm hiểu các thành phần chính, bao gồm:

  * Security Standards
  * Security Controls
  * Findings
  * Insights
  * Security Score

* Kiểm tra cách các GuardDuty Finding được tập trung trong AWS Security Hub.

* Tìm hiểu cấu trúc cơ bản của AWS Security Finding Format.

* Ôn lại các nguyên tắc bảo mật IAM, bao gồm xác thực đa yếu tố, phân quyền theo vai trò và đặc quyền tối thiểu.

* Xác định các trường dữ liệu quan trọng của Security Finding cần sử dụng trong quy trình phản ứng sự cố tự động của dự án AWS CloudSOC.

* Hoàn thành Tuần 6 với kiến thức nền tảng về AWS CloudTrail, Amazon GuardDuty, AWS Security Hub, Security Finding và các nguyên tắc bảo mật IAM.