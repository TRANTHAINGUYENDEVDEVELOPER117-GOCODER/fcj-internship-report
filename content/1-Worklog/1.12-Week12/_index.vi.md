---
title: "Nhật ký công việc Tuần 12"
date: 2026-07-20
weight: 12
chapter: false
pre: " <b> 1.12. </b> "
---

### Thời gian thực hiện

* **Tuần 12:** Từ ngày **2026-07-20** đến **2026-07-30**.

### Mục tiêu Tuần 12

* Hoàn thành báo cáo thực tập cuối kỳ về hệ thống AWS CloudSOC.
* Trình bày yêu cầu, kiến trúc, quá trình triển khai, kiểm thử và kết quả của dự án.
* Hoàn thiện sơ đồ kiến trúc AWS CloudSOC và luồng xử lý sự kiện bảo mật.
* Chuẩn bị hình ảnh minh họa, bằng chứng kiểm thử và phần giải thích kỹ thuật.
* Xem xét dự án theo các nguyên tắc bảo mật và kiến trúc tốt nhất của AWS.
* Chuẩn bị slide thuyết trình và kịch bản demo cuối kỳ.
* Kiểm tra mức sử dụng tài nguyên AWS và chi phí vận hành dự kiến.
* Sao lưu tài liệu, mã nguồn, cấu hình và kết quả kiểm thử của dự án.
* Xóa các tài nguyên AWS không cần thiết nhằm tránh phát sinh chi phí ngoài dự kiến.
* Hoàn tất quá trình kiểm tra và nộp đầy đủ các sản phẩm thực tập.

### Các công việc thực hiện trong tuần

| Ngày | Công việc | Ngày bắt đầu | Ngày hoàn thành | Tài liệu tham khảo |
| --- | --- | --- | --- | --- |
| Thứ Hai | - Xem lại yêu cầu báo cáo thực tập và quy định nộp bài <br> - Sắp xếp cấu trúc báo cáo và mục lục <br> - Kiểm tra mục tiêu, phạm vi và tiến độ triển khai dự án <br> - Tạo danh sách các tài liệu và sản phẩm cần hoàn thành | 2026-07-20 | 2026-07-20 | <https://hcm-rules.awsfcaj.com/3-project/> |
| Thứ Ba | - Hoàn thiện phần tổng quan và vấn đề cần giải quyết của dự án <br> - Mô tả các rủi ro bảo mật mà hệ thống AWS CloudSOC hướng đến xử lý <br> - Trình bày các yêu cầu chức năng và phi chức năng <br> - Giải thích các dịch vụ AWS được lựa chọn và vai trò của từng dịch vụ | 2026-07-21 | 2026-07-21 | <https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html> |
| Thứ Tư | - Hoàn thiện sơ đồ kiến trúc AWS CloudSOC <br> - Kiểm tra AWS Service Icon, nhóm dịch vụ, Trust Boundary và Network Boundary <br> - Bổ sung số thứ tự luồng sự kiện và ghi chú giải thích <br> - Bảo đảm các đường kết nối thể hiện đúng cách các dịch vụ AWS tương tác với nhau | 2026-07-22 | 2026-07-22 | <https://aws.amazon.com/architecture/icons/> |
| Thứ Năm | - Viết tài liệu mô tả luồng phát hiện mối đe dọa chính <br> - Giải thích cách CloudTrail, GuardDuty, Security Hub và Inspector cung cấp thông tin bảo mật <br> - Mô tả cách EventBridge tiếp nhận và định tuyến Security Finding <br> - Giải thích vai trò của CloudWatch trong giám sát và xử lý lỗi | 2026-07-23 | 2026-07-23 | <https://docs.aws.amazon.com/securityhub/latest/userguide/what-is-securityhub.html> |
| Thứ Sáu | - Viết tài liệu mô tả quy trình phản ứng sự cố <br> - Giải thích logic đánh giá Finding trong Step Functions <br> - Mô tả các nhánh Alert Only, Approval Required và Automated Response <br> - Trình bày vai trò của Lambda, Systems Manager, DynamoDB, S3 và SNS | 2026-07-24 | 2026-07-24 | <https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html> |
| Thứ Bảy | - Sắp xếp các Test Case và bằng chứng kiểm thử <br> - Bổ sung ảnh chụp Step Functions Execution, Lambda Logs, DynamoDB Record, S3 Evidence, SNS Notification và kết quả Systems Manager <br> - Ghi lại kết quả mong đợi, kết quả thực tế, lỗi phát hiện và phương án khắc phục | 2026-07-25 | 2026-07-25 | <https://docs.aws.amazon.com/step-functions/latest/dg/concepts-view-execution-details.html> |
| Chủ Nhật | - Đánh giá kiến trúc theo AWS Well-Architected Framework <br> - Trình bày các yếu tố Operational Excellence, Security, Reliability, Performance Efficiency, Cost Optimization và Sustainability <br> - Xác định các hạn chế và hướng cải tiến trong tương lai | 2026-07-26 | 2026-07-26 | <https://docs.aws.amazon.com/wellarchitected/latest/framework/the-pillars-of-the-framework.html> |
| Thứ Hai | - Chuẩn bị slide thuyết trình cuối kỳ <br> - Xây dựng các slide về vấn đề, mục tiêu, kiến trúc, quy trình bảo mật, triển khai, kiểm thử, kết quả, chi phí và kết luận <br> - Đơn giản hóa nội dung kỹ thuật để trình bày dễ hiểu <br> - Thêm sơ đồ kiến trúc và các ảnh minh họa quan trọng | 2026-07-27 | 2026-07-27 | <https://aws.amazon.com/architecture/> |
| Thứ Ba | - Chuẩn bị kịch bản demo cuối kỳ <br> - Tạo Finding mẫu cho các trường hợp Alert Only, Approval Required và Automated Response <br> - Kiểm tra quy trình Rollback <br> - Luyện tập thuyết trình và demo <br> - Chuẩn bị ảnh hoặc video demo dự phòng khi cần thiết | 2026-07-28 | 2026-07-28 | <https://docs.aws.amazon.com/guardduty/latest/ug/sample_findings.html> |
| Thứ Tư | - Kiểm tra các tài nguyên AWS đang hoạt động và chi phí dịch vụ <br> - Kiểm tra AWS Billing, Cost Explorer và AWS Budgets <br> - Xuất hoặc ghi lại các thông tin cấu hình quan trọng <br> - Sao lưu file dự án và kết quả kiểm thử <br> - Xóa hoặc tắt các tài nguyên trả phí không còn cần thiết | 2026-07-29 | 2026-07-29 | <https://docs.aws.amazon.com/cost-management/latest/userguide/what-is-costmanagement.html> |
| Thứ Năm | - Kiểm tra chính tả và nội dung báo cáo cuối kỳ <br> - Kiểm tra ngày tháng, tiêu đề, chú thích hình, tài liệu tham khảo và mục lục <br> - Kiểm tra lần cuối website và slide thuyết trình <br> - Nộp báo cáo, website dự án, slide và các tài liệu thực tập được yêu cầu <br> - Tổng kết bài học kinh nghiệm và hoàn thành nhật ký Tuần 12 | 2026-07-30 | 2026-07-30 | <https://hcm-rules.awsfcaj.com/3-project/> |

### Kết quả đạt được trong Tuần 12

* Hoàn thành báo cáo thực tập cuối kỳ về hệ thống AWS CloudSOC.

* Trình bày đầy đủ các nội dung chính của dự án, bao gồm:

  * Bối cảnh dự án
  * Vấn đề cần giải quyết
  * Mục tiêu dự án
  * Phạm vi và yêu cầu
  * Kiến trúc đề xuất
  * Các dịch vụ AWS được sử dụng
  * Quá trình triển khai
  * Luồng sự kiện bảo mật
  * Quy trình phản ứng sự cố
  * Kiểm thử và đánh giá
  * Phân tích chi phí
  * Hạn chế của dự án
  * Hướng phát triển trong tương lai
  * Kết luận

* Hoàn thiện sơ đồ kiến trúc AWS CloudSOC.

* Sắp xếp kiến trúc thành các tầng chức năng rõ ràng:

  * Bảo vệ biên và bảo vệ mạng
  * Quản lý danh tính và quyền truy cập
  * Giám sát bảo mật và phát hiện mối đe dọa
  * Tổng hợp Security Finding
  * Định tuyến sự kiện
  * Điều phối phản ứng sự cố
  * Cô lập và điều tra tự động
  * Lưu trữ sự cố và bằng chứng
  * Gửi thông báo
  * Ghi log và giám sát vận hành

* Kiểm tra vai trò và mối liên hệ giữa các dịch vụ AWS chính:

  * AWS CloudTrail
  * Amazon GuardDuty
  * AWS Security Hub
  * Amazon Inspector
  * AWS WAF
  * AWS Network Firewall
  * Amazon EventBridge
  * AWS Step Functions
  * AWS Lambda
  * AWS Systems Manager
  * Amazon DynamoDB
  * Amazon S3
  * Amazon SNS
  * Amazon CloudWatch
  * AWS Identity and Access Management

* Hoàn thành phần mô tả luồng phát hiện bảo mật chính:

  **AWS Resources and Logs → CloudTrail/GuardDuty/Inspector → Security Hub → EventBridge**

* Hoàn thành phần mô tả luồng phản ứng sự cố chính:

  **Security Finding → EventBridge → Step Functions → Lambda Evaluation → Response Branch → Systems Manager → DynamoDB/S3 → SNS**

* Trình bày ba trường hợp phản ứng chính:

  * **Alert Only:** Gửi cảnh báo nhưng không thay đổi tài nguyên bị ảnh hưởng.
  * **Approval Required:** Chờ SOC Analyst phê duyệt trước khi thực hiện cô lập.
  * **Automated Response:** Tự động cô lập EC2 Instance có Finding mức Critical khi đáp ứng đầy đủ các điều kiện phản ứng.

* Trình bày các điều kiện cần thiết để thực hiện phản ứng tự động:

  * Loại tài nguyên được hỗ trợ
  * EC2 Instance ID hợp lệ
  * Mức độ nghiêm trọng phù hợp
  * Tag `AutoIsolate=true`
  * Response Mode hợp lệ
  * Quyền IAM đầy đủ

* Bổ sung các Test Case cho:

  * Finding mức Low
  * Finding mức Medium
  * Finding mức High
  * Finding mức Critical
  * Tài nguyên không được hỗ trợ
  * Thiếu Instance ID
  * Thiếu Tag `AutoIsolate`
  * Lambda thực thi thất bại
  * Lỗi quyền IAM
  * Systems Manager thất bại
  * SOC Analyst phê duyệt hoặc từ chối
  * Tự động cô lập EC2
  * Rollback và khôi phục EC2

* Sắp xếp hình ảnh và bằng chứng từ:

  * AWS Step Functions Execution History
  * Amazon CloudWatch Logs
  * AWS Lambda
  * AWS Systems Manager
  * Amazon DynamoDB
  * Amazon S3
  * Amazon SNS
  * Amazon GuardDuty
  * AWS Security Hub

* Ghi lại kết quả mong đợi và kết quả thực tế của từng Test Case.

* Trình bày các lỗi đã phát hiện, quá trình xử lý lỗi và phương án khắc phục.

* Đánh giá kiến trúc theo sáu trụ cột của AWS Well-Architected Framework:

  * Operational Excellence
  * Security
  * Reliability
  * Performance Efficiency
  * Cost Optimization
  * Sustainability

* Xác định các hạn chế của dự án, bao gồm:

  * Phần demo được triển khai trong tài khoản AWS và Region giới hạn.
  * Một số dịch vụ bảo mật trả phí chỉ được thử nghiệm trong thời gian ngắn.
  * Quy trình phê duyệt được đơn giản hóa nhằm phục vụ mục đích demo.
  * Dự án chủ yếu tập trung vào phản ứng sự cố liên quan đến Amazon EC2.
  * Mô hình Multi-Account và Multi-Region chưa được triển khai đầy đủ.

* Đề xuất các hướng cải tiến trong tương lai, bao gồm:

  * Sử dụng AWS Organizations và mô hình bảo mật Multi-Account
  * Phản ứng sự cố Cross-Region
  * AWS Security Hub Delegated Administration
  * Lưu trữ log tập trung
  * Sử dụng AWS KMS Customer Managed Key
  * Sử dụng Amazon OpenSearch Service để phân tích dữ liệu bảo mật
  * Sử dụng Amazon Athena để truy vấn dữ liệu điều tra
  * Tích hợp hệ thống quản lý Ticket hoặc nền tảng Chat
  * Bổ sung thêm các Automated Response Playbook
  * Triển khai hệ thống bằng Infrastructure as Code

* Hoàn thành slide thuyết trình cuối kỳ.

* Chuẩn bị và luyện tập phần demo dự án.

* Xây dựng các kịch bản demo cho Alert Only, Approval Required, Automated Response và Rollback.

* Kiểm tra mức sử dụng dịch vụ AWS và chi phí dự kiến của dự án.

* Kiểm tra AWS Billing, AWS Budgets và các tài nguyên đang hoạt động.

* Sao lưu các tài liệu quan trọng của dự án, bao gồm:

  * Báo cáo thực tập
  * Website Hugo
  * Sơ đồ kiến trúc
  * Slide thuyết trình
  * Mã nguồn Lambda
  * Step Functions Definition
  * IAM Policy
  * Test Event
  * Ảnh chụp màn hình
  * Kết quả kiểm thử

* Xóa hoặc tắt các tài nguyên AWS không cần thiết nhằm hạn chế phát sinh chi phí ngoài dự kiến.

* Kiểm tra lần cuối báo cáo, nhật ký công việc, website, sơ đồ kiến trúc, slide và nội dung demo.

* Hoàn thành việc nộp các sản phẩm thực tập cuối kỳ.

* Kết thúc quá trình thực tập với kiến thức thực hành về hạ tầng AWS Cloud, mạng, giám sát, phát hiện mối đe dọa, kiến trúc hướng sự kiện, phản ứng sự cố tự động, kiểm thử, quản lý chi phí và viết tài liệu kỹ thuật.