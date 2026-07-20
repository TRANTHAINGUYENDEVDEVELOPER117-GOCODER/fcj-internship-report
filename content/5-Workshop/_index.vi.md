---
title: "Workshop"
date: 2026-07-11
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

# Báo cáo dự án & Workshop: AWS CloudSOC

### Tổng quan

Đề tài workshop của nhóm là **“Thiết kế và triển khai hệ thống AWS CloudSOC – Phát hiện, điều tra và phản ứng sự cố có kiểm soát trên AWS”**. Dự án mô phỏng quy trình hoạt động của một trung tâm điều hành an ninh mạng (**Security Operations Center – SOC**) trên môi trường AWS.

Hệ thống được thiết kế theo mô hình **event-driven**, kết hợp các dịch vụ managed/serverless của AWS với một máy chủ **Amazon EC2** dùng làm workload thử nghiệm. Mục tiêu chính là minh họa đầy đủ quy trình:

**Detect → Investigate → Decide → Collect Evidence → Contain → Notify → Recover**

Đây là mô hình **Lab / Proof of Concept**, ưu tiên khả năng trình bày quy trình SOC, tối ưu chi phí và dễ mở rộng thành bản production trong tương lai.

### Thông tin dự án

| Hạng mục | Nội dung |
| --- | --- |
| Tên dự án | AWS CloudSOC |
| Nhóm thực hiện | Trần Thái Nguyên, Dương Bá Đạt |
| Trường/Lớp | HUTECH – 22DTHB1 |
| Chuyên ngành | An ninh mạng |
| Chương trình | AWS Vietnam FCJ Workforce Bootcamp 2026 |
| Thời gian | Tháng 7/2026 |
| Region chính | `ap-southeast-1` |
| Mô hình | Lab / Proof of Concept |

### Thành viên & vai trò

| Thành viên | Vai trò chính |
| --- | --- |
| Trần Thái Nguyên | Phân tích yêu cầu SOC, thiết kế kiến trúc CloudSOC, viết báo cáo và chuẩn hóa nội dung workshop |
| Dương Bá Đạt | Hỗ trợ nghiên cứu luồng dịch vụ AWS, review sơ đồ kiến trúc, kiểm tra logic phản ứng sự cố và checklist nộp |

### Nhóm dịch vụ AWS sử dụng

| Nhóm chức năng | Dịch vụ |
| --- | --- |
| Dashboard & Access | AWS Amplify, Amazon Cognito, Amazon API Gateway, AWS Lambda |
| Incident Data | Amazon DynamoDB |
| Logging & Evidence | AWS CloudTrail, Amazon CloudWatch, Amazon S3, Amazon EBS Snapshot |
| Threat Detection | Amazon GuardDuty, AWS Security Hub, Amazon Detective |
| Response Orchestration | Amazon EventBridge, AWS Step Functions |
| Forensic Collection | AWS Systems Manager |
| Containment | Incident Response Lambda, Security Group Isolation |
| Alerting | Amazon SNS, Amazon Q Developer, Slack/Email/SMS |
| Governance | AWS IAM, AWS Config, AWS KMS |

### Nội dung workshop

1. [Báo cáo chi tiết dự án AWS CloudSOC](5.1-Workshop-overview/)
2. [Kiến trúc hệ thống & luồng xử lý SOC](5.2-Prerequisite/)
3. [Workshop vẽ sơ đồ kiến trúc CloudSOC](5.3-S3-vpc/)  
   Gồm 6 module con: chuẩn bị công cụ, dựng layout, vẽ nhóm dịch vụ, nối luồng xử lý sự cố, export/review và bản đặc tả vẽ chi tiết.
4. [Checklist review sơ đồ & yêu cầu nộp](5.4-S3-onprem/)
5. [Hướng phát triển Production](5.5-Policy/)
6. [Tài liệu tham khảo & cleanup lab](5.6-Cleanup/)

### Sản phẩm bàn giao

- Báo cáo dự án AWS CloudSOC bằng website Hugo.
- Tài liệu workshop hướng dẫn vẽ sơ đồ kiến trúc CloudSOC.
- Sơ đồ CloudSOC minh họa trực tiếp trên website bằng SVG.
- Checklist kiểm tra trước khi nộp cho công ty.
- Định hướng nâng cấp từ Lab/PoC lên Production.
- Danh sách tài liệu tham khảo và cleanup checklist để tránh phát sinh chi phí AWS.

### Lưu ý quan trọng

- Kiến trúc hiện tại **không hoàn toàn serverless** vì workload thử nghiệm vẫn chạy trên **Amazon EC2**.
- Các thành phần như dashboard, API, workflow phản ứng sự cố, cảnh báo và điều phối chủ yếu dùng dịch vụ managed/serverless.
- Trong môi trường production nên chuyển workload vào **Private Subnet**, bổ sung **ALB**, **NAT Gateway**, **Multi-AZ**, lifecycle policy cho evidence/snapshot và triển khai bằng **IaC** như CDK/Terraform.