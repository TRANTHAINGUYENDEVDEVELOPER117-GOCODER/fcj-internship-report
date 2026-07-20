---
title: "Nhật ký công việc Tuần 9"
date: 2026-06-29
weight: 9
chapter: false
pre: " <b> 1.9. </b> "
---

### Thời gian thực hiện

* **Tuần 9:** Từ ngày **2026-06-29** đến **2026-07-05**.

### Mục tiêu Tuần 9

* Hiểu vai trò của AWS Step Functions trong việc điều phối quy trình phản ứng sự cố bảo mật.
* Tìm hiểu các thành phần cơ bản của một Step Functions State Machine.
* Sử dụng AWS Lambda để tiếp nhận, chuẩn hóa và đánh giá Security Finding.
* Phân loại Finding dựa trên loại tài nguyên, mức độ nghiêm trọng, mã định danh tài nguyên và điều kiện phản ứng.
* Thiết kế các nhánh xử lý riêng cho trường hợp chỉ cảnh báo, yêu cầu phê duyệt và phản ứng tự động.
* Sử dụng Amazon DynamoDB để lưu thông tin sự cố và trạng thái của quy trình.
* Sử dụng Amazon S3 để lưu bằng chứng bảo mật, thông tin Finding và dữ liệu điều tra.
* Cấu hình cơ chế xử lý lỗi, thử lại và gửi thông báo khi quy trình thất bại.
* Xây dựng quy trình phản ứng sự cố chính cho dự án AWS CloudSOC.

### Các công việc thực hiện trong tuần

| Ngày | Công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| --- | --- | --- | --- | --- |
| Thứ Hai | - Ôn lại luồng EventBridge và SNS đã xây dựng trong Tuần 8 <br> - Tìm hiểu các khái niệm cơ bản của AWS Step Functions <br> - Hiểu State Machine, State, Execution, Input, Output và Amazon States Language <br> - Xác định vai trò của Step Functions trong kiến trúc AWS CloudSOC | 2026-06-29 | 2026-06-29 | <https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html> |
| Thứ Ba | - Tìm hiểu các loại State chính trong Step Functions <br> - Xem Task, Choice, Pass, Wait, Succeed, Fail, Parallel và Map State <br> - Sử dụng Workflow Studio để tạo một State Machine cơ bản <br> - Kiểm tra hoạt động của một Workflow đơn giản | 2026-06-30 | 2026-06-30 | <https://docs.aws.amazon.com/step-functions/latest/dg/concepts-states.html> |
| Thứ Tư | - Tạo AWS Lambda Function để xử lý Security Finding <br> - Tiếp nhận một sự kiện mẫu từ GuardDuty hoặc Security Hub <br> - Trích xuất Finding ID, Severity, Resource Type, Resource ID, Account, Region và Title <br> - Trả dữ liệu đã chuẩn hóa về cho quy trình Step Functions | 2026-07-01 | 2026-07-01 | <https://docs.aws.amazon.com/lambda/latest/dg/getting-started.html> |
| Thứ Năm | - Thiết kế logic đánh giá Security Finding <br> - Thêm Choice State để phân loại Finding theo loại tài nguyên và mức độ nghiêm trọng <br> - Kiểm tra Finding có chứa EC2 Instance ID hợp lệ hay không <br> - Kiểm tra điều kiện phản ứng AutoIsolate <br> - Tạo các nhánh Alert Only, Approval Required và Automated Response | 2026-07-02 | 2026-07-02 | <https://docs.aws.amazon.com/step-functions/latest/dg/state-choice.html> |
| Thứ Sáu | - Tạo Amazon DynamoDB Table để lưu thông tin sự cố <br> - Xác định các thuộc tính Incident ID, Finding ID, Severity, Resource ID, Status, Response Mode và Timestamp <br> - Cấu hình Workflow để tạo hoặc cập nhật Incident Record <br> - Kiểm tra dữ liệu được lưu bằng DynamoDB Console | 2026-07-03 | 2026-07-03 | <https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GettingStartedDynamoDB.html> |
| Thứ Bảy | - Tạo Amazon S3 Bucket để lưu bằng chứng bảo mật <br> - Cấu hình mã hóa, Block Public Access và quyền truy cập phù hợp <br> - Lưu dữ liệu Finding gốc hoặc các file điều tra vào Bucket <br> - Tổ chức bằng chứng bằng Folder hoặc Object Prefix dựa trên Incident ID và ngày tạo | 2026-07-04 | 2026-07-04 | <https://docs.aws.amazon.com/AmazonS3/latest/userguide/GetStartedWithS3.html> |
| Chủ Nhật | - Thêm cấu hình Retry và Catch vào Step Functions Workflow <br> - Cấu hình xử lý lỗi và gửi thông báo qua Amazon SNS <br> - Kiểm tra Workflow bằng các Finding mẫu có mức Low, Medium, High và Critical <br> - Xem Execution History, Lambda Log, DynamoDB Record và bằng chứng trong Amazon S3 <br> - Kiểm tra chi phí dịch vụ và hoàn thành nhật ký Tuần 9 | 2026-07-05 | 2026-07-05 | <https://docs.aws.amazon.com/step-functions/latest/dg/concepts-error-handling.html> |

### Kết quả đạt được trong Tuần 9

* Hiểu vai trò của AWS Step Functions trong việc phối hợp nhiều dịch vụ trong một quy trình phản ứng sự cố tự động.

* Nắm được các khái niệm chính của AWS Step Functions, bao gồm:

  * State Machine
  * State
  * Execution
  * Input
  * Output
  * Amazon States Language
  * Execution History

* Tìm hiểu các loại State chính được sử dụng trong Step Functions:

  * Task
  * Choice
  * Pass
  * Wait
  * Succeed
  * Fail
  * Parallel
  * Map

* Tạo một Step Functions State Machine cơ bản bằng Workflow Studio.

* Tạo AWS Lambda Function để tiếp nhận và xử lý dữ liệu Security Finding.

* Trích xuất các thông tin quan trọng từ GuardDuty Finding hoặc Security Hub Finding, bao gồm:

  * Finding ID
  * Finding Type
  * Severity
  * Resource Type
  * Resource ID
  * EC2 Instance ID
  * AWS Account
  * AWS Region
  * Finding Title
  * Finding Description

* Chuẩn hóa dữ liệu Finding trước khi chuyển đến State tiếp theo trong Workflow.

* Thiết kế logic đánh giá Finding bằng Step Functions Choice State.

* Xây dựng ba nhánh phản ứng sự cố chính:

  * **Alert Only:** Dùng cho tài nguyên không được hỗ trợ, Finding mức Low hoặc Medium, thiếu Instance ID hoặc tài nguyên không đáp ứng điều kiện phản ứng.
  * **Approval Required:** Dùng cho EC2 Finding mức High và cần SOC Analyst phê duyệt trước khi xử lý.
  * **Automated Response:** Dùng cho EC2 Finding mức Critical và đáp ứng đầy đủ điều kiện phản ứng tự động.

* Thêm các điều kiện kiểm tra:

  * Resource Type
  * EC2 Instance ID
  * Finding Severity
  * AutoIsolate Condition
  * Response Mode

* Tạo Amazon DynamoDB Table để lưu thông tin sự cố.

* Xác định các thuộc tính quan trọng của Incident Record, bao gồm:

  * Incident ID
  * Finding ID
  * Severity
  * Resource Type
  * Resource ID
  * Response Mode
  * Incident Status
  * Created Time
  * Updated Time

* Cấu hình Workflow để tạo mới và cập nhật Incident Record trong DynamoDB.

* Tạo Amazon S3 Bucket để lưu bằng chứng bảo mật và dữ liệu điều tra.

* Cấu hình các thiết lập bảo mật cho Evidence Bucket, bao gồm:

  * Block Public Access
  * Server-side Encryption
  * IAM Access Permission
  * Tổ chức Object bằng Prefix

* Lưu dữ liệu Finding gốc và bằng chứng bảo mật trong Amazon S3.

* Thêm cấu hình Retry và Catch nhằm tăng độ tin cậy của Workflow.

* Tạo nhánh xử lý lỗi để ghi nhận lỗi và gửi thông báo qua Amazon SNS.

* Kiểm tra Workflow bằng các Finding có mức độ nghiêm trọng khác nhau.

* Xem Step Functions Execution History để kiểm tra Input, Output, nhánh được lựa chọn và kết quả thực thi.

* Xác nhận hoạt động của luồng xử lý chính trong Tuần 9:

  **Security Finding → EventBridge → Step Functions → Lambda Evaluation → Choice Branch → DynamoDB/S3 → SNS Notification**

* Chuẩn bị nhánh phản ứng tự động để tích hợp với AWS Systems Manager trong Tuần 10.

* Hoàn thành Tuần 9 với kiến thức nền tảng về AWS Step Functions, xử lý Finding bằng Lambda, lưu thông tin sự cố bằng DynamoDB, lưu bằng chứng bằng Amazon S3 và điều phối quy trình phản ứng sự cố bảo mật.