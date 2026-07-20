---
title: "Nhật ký công việc Tuần 8"
date: 2026-06-22
weight: 8
chapter: false
pre: " <b> 1.8. </b> "
---

### Thời gian thực hiện

* **Tuần 8:** Từ ngày **2026-06-22** đến **2026-06-28**.

### Mục tiêu Tuần 8

* Hiểu khái niệm kiến trúc hướng sự kiện trên AWS.
* Tìm hiểu cách Amazon EventBridge tiếp nhận và định tuyến các sự kiện bảo mật.
* Tạo EventBridge Rule cho các Finding từ Amazon GuardDuty và AWS Security Hub.
* Tìm hiểu cách Amazon SNS gửi thông báo bảo mật đến quản trị viên.
* Cấu hình SNS Topic và Email Subscription.
* Xây dựng luồng sự kiện và thông báo bảo mật cơ bản.
* Lọc Security Finding dựa trên nguồn sự kiện, loại tài nguyên và mức độ nghiêm trọng.
* Chuẩn bị nền tảng xử lý sự kiện cho quy trình phản ứng sự cố tự động của dự án AWS CloudSOC.

### Các công việc thực hiện trong tuần

| Ngày | Công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| --- | --- | --- | --- | --- |
| Thứ Hai | - Ôn lại các dịch vụ bảo mật nhiều lớp đã học trong Tuần 7 <br> - Tìm hiểu các khái niệm cơ bản về kiến trúc hướng sự kiện <br> - Hiểu Event, Event Source, Event Bus, Rule và Target <br> - Xác định vai trò của Amazon EventBridge trong kiến trúc AWS CloudSOC | 2026-06-22 | 2026-06-22 | <https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html> |
| Thứ Ba | - Tìm hiểu Amazon EventBridge Event Bus <br> - Xem cấu trúc của một AWS Service Event <br> - Xác định các trường Source, Detail Type, Account, Region, Time, Resources và Detail <br> - Xem các sự kiện mẫu từ GuardDuty và Security Hub | 2026-06-23 | 2026-06-23 | <https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-events-structure.html> |
| Thứ Tư | - Tạo Amazon SNS Topic để gửi thông báo bảo mật <br> - Tạo Email Subscription <br> - Xác nhận đăng ký SNS thông qua email <br> - Gửi Test Message và kiểm tra email thông báo đã được nhận | 2026-06-24 | 2026-06-24 | <https://docs.aws.amazon.com/sns/latest/dg/sns-create-topic.html> |
| Thứ Năm | - Tạo EventBridge Rule cho Amazon GuardDuty Finding <br> - Cấu hình Event Pattern sử dụng nguồn sự kiện GuardDuty <br> - Thêm Amazon SNS làm Target <br> - Kiểm tra Rule bằng Sample Finding hoặc Test Event | 2026-06-25 | 2026-06-25 | <https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_findings_eventbridge.html> |
| Thứ Sáu | - Tạo EventBridge Rule cho AWS Security Hub Finding <br> - Lọc Finding dựa trên Workflow Status, Severity hoặc Resource Type <br> - Thêm Amazon SNS làm Target gửi thông báo <br> - Kiểm tra nội dung thông báo nhận được qua email | 2026-06-26 | 2026-06-26 | <https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cwe-integration.html> |
| Thứ Bảy | - Xem lại EventBridge Event Pattern <br> - Tạo các Rule riêng cho Finding mức Low, Medium, High và Critical khi cần thiết <br> - Kiểm tra khả năng lọc theo loại tài nguyên EC2 và mức độ nghiêm trọng <br> - Xác nhận chỉ các Security Finding phù hợp mới được gửi đến SNS Topic | 2026-06-27 | 2026-06-27 | <https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-event-patterns.html> |
| Chủ Nhật | - Kiểm tra quyền IAM cho EventBridge và Amazon SNS <br> - Xem Metrics và kết quả Invocation của EventBridge Rule <br> - Tìm hiểu cơ chế Retry và xử lý sự kiện thất bại <br> - Kiểm tra chi phí dịch vụ và xóa các tài nguyên thử nghiệm không cần thiết <br> - Hoàn thành nhật ký Tuần 8 | 2026-06-28 | 2026-06-28 | <https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-rule-dlq.html> |

### Kết quả đạt được trong Tuần 8

* Hiểu được khái niệm kiến trúc hướng sự kiện và vai trò của mô hình này trong việc tự động hóa hoạt động bảo mật cloud.

* Nắm được các thành phần chính của Amazon EventBridge, bao gồm:

  * Event
  * Event Source
  * Event Bus
  * Event Pattern
  * Rule
  * Target

* Hiểu cách các dịch vụ AWS gửi sự kiện đến Default Event Bus của Amazon EventBridge.

* Xem cấu trúc cơ bản của một AWS Event và xác định các trường dữ liệu quan trọng, bao gồm:

  * Source
  * Detail Type
  * AWS Account
  * AWS Region
  * Event Time
  * Resources
  * Event Detail

* Hiểu cách Amazon GuardDuty Finding được gửi đến Amazon EventBridge.

* Hiểu cách AWS Security Hub Finding được định tuyến thông qua Amazon EventBridge.

* Tạo Amazon SNS Topic để gửi thông báo bảo mật.

* Tạo và xác nhận Email Subscription cho SNS Topic.

* Gửi Test Message qua Amazon SNS và xác nhận email thông báo đã được nhận.

* Tạo EventBridge Rule cho Amazon GuardDuty Finding.

* Cấu hình Amazon SNS làm Target của EventBridge Rule.

* Tạo EventBridge Rule cho AWS Security Hub Finding.

* Thực hành lọc Security Finding dựa trên các trường trong Event Pattern, bao gồm:

  * Nguồn dịch vụ bảo mật
  * Mức độ nghiêm trọng của Finding
  * Loại tài nguyên
  * AWS Account
  * AWS Region
  * Workflow Status

* Hiểu sự khác nhau giữa các mức độ nghiêm trọng:

  * Low
  * Medium
  * High
  * Critical

* Kiểm tra luồng thông báo bằng Sample Security Finding hoặc Test Event.

* Xác nhận hoạt động của luồng thông báo bảo mật cơ bản:

  **GuardDuty hoặc Security Hub → Amazon EventBridge → Amazon SNS → Email Notification**

* Kiểm tra các quyền IAM cần thiết để EventBridge có thể gửi thông báo đến SNS Topic.

* Tìm hiểu cơ chế Retry và Dead-Letter Queue trong trường hợp EventBridge không thể chuyển sự kiện đến Target.

* Xem EventBridge Metrics để kiểm tra các Invocation thành công hoặc thất bại.

* Xác định Amazon EventBridge là dịch vụ định tuyến sự kiện trung tâm trong dự án AWS CloudSOC cuối kỳ.

* Chuẩn bị nền tảng xử lý sự kiện cần thiết để tích hợp AWS Step Functions và AWS Lambda trong các tuần tiếp theo.

* Hoàn thành Tuần 8 với kiến thức nền tảng về Amazon EventBridge, Amazon SNS, lọc sự kiện bảo mật và gửi thông báo tự động.