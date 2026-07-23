---
title: "Workshop"
date: 2026-06-30
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

# AWS CloudSOC: Hệ thống phát hiện mối đe dọa và phản ứng sự cố tự động trên AWS

#### Tổng quan

Trong workshop này, chúng ta sẽ xây dựng hệ thống **AWS CloudSOC** nhằm phát hiện mối đe dọa, điều tra sự cố, phản ứng tự động, thu thập bằng chứng và gửi cảnh báo trên nền tảng Amazon Web Services (AWS).

Hệ thống được thiết kế như một mô hình **Security Operations Center trên AWS**, có khả năng phát hiện hành vi bất thường, xử lý security finding, hỗ trợ SOC Analyst phê duyệt incident, tự động cô lập EC2 nghi ngờ bị ảnh hưởng, thu thập forensic evidence, lưu trữ thông tin incident và gửi thông báo đến người vận hành bảo mật.

Nguồn phát hiện chính trong workshop là **Amazon GuardDuty**. Khi một security finding được tạo, **Amazon EventBridge** sẽ nhận sự kiện và chuyển đến **AWS Step Functions** để điều phối quy trình phản ứng sự cố. Tùy theo mức độ nghiêm trọng và chế độ phản ứng, workflow có thể kích hoạt **AWS Lambda** và **AWS Systems Manager** để thu thập bằng chứng, tạo forensic snapshot, cập nhật trạng thái incident vào **Amazon DynamoDB**, lưu evidence vào **Amazon S3** và gửi cảnh báo thông qua **Amazon SNS** đến Email hoặc Slack.

Workshop cũng triển khai một **SOC Dashboard** đơn giản bằng **AWS Amplify**. Dashboard giúp SOC Analyst theo dõi trạng thái incident, kiểm tra incident đang chờ xử lý và xác thực luồng phản ứng sự cố.

Kiến trúc của hệ thống được xây dựng theo hướng **event-driven** và **serverless-oriented**, giúp giảm độ phức tạp vận hành, tăng khả năng tự động hóa và tối ưu chi phí cho môi trường lab.

---

#### Các dịch vụ AWS chính

Các dịch vụ AWS chính được sử dụng trong workshop bao gồm:

```text
Amazon GuardDuty
AWS Security Hub
Amazon EventBridge
AWS Step Functions
AWS Lambda
AWS Systems Manager
Amazon EC2
Amazon VPC
Amazon S3
Amazon DynamoDB
Amazon SNS
Amazon CloudWatch
Amazon Detective
AWS Config
AWS CloudTrail
AWS IAM
AWS KMS
AWS Amplify
Amazon API Gateway
Amazon Cognito
```

---

#### Mục tiêu workshop

Sau khi hoàn thành workshop này, bạn có thể:

+ Thiết kế kiến trúc CloudSOC trên AWS.
+ Triển khai VPC lab, public subnet, route table, Internet Gateway và EC2 workload.
+ Bật các dịch vụ giám sát bảo mật như GuardDuty, Security Hub, CloudTrail, VPC Flow Logs, AWS Config và Detective.
+ Xây dựng workflow phản ứng sự cố theo mô hình event-driven bằng EventBridge và Step Functions.
+ Triển khai Incident Response Lambda để xử lý security findings.
+ Sử dụng Systems Manager để thu thập forensic evidence từ EC2.
+ Tạo EBS Snapshot phục vụ quá trình điều tra sự cố.
+ Lưu trữ incident evidence vào S3.
+ Lưu metadata và trạng thái xử lý incident vào DynamoDB.
+ Xây dựng SOC Dashboard đơn giản để giám sát và kiểm thử approval workflow.
+ Gửi cảnh báo sự cố thông qua SNS, Email và Slack.
+ Kiểm thử toàn bộ luồng phát hiện và phản ứng sự cố.
+ Dọn dẹp toàn bộ tài nguyên lab để tránh phát sinh chi phí không cần thiết.

---

#### Luồng thực hiện workshop

Luồng tổng quan của workshop:

```text
Thiết kế kiến trúc
→ Chuẩn bị môi trường AWS
→ Triển khai hệ thống CloudSOC
→ Kiểm thử và xác thực phản ứng sự cố
→ Giám sát dashboard và cảnh báo
→ Dọn dẹp tài nguyên
```

Luồng phản ứng sự cố chính:

```text
GuardDuty Finding
→ EventBridge Rule
→ Step Functions Workflow
→ Incident Response Lambda
→ Systems Manager Evidence Collection
→ EBS Forensic Snapshot
→ S3 Evidence Storage
→ DynamoDB Incident Update
→ SNS Notification
→ Email / Slack Alert
```

---

#### Nội dung

1. [Tổng quan workshop](5.1-workshop-overview/)
2. [Điều kiện tiên quyết](5.2-prerequiste/)
3. [Kiến trúc và workflow](5.3-architecture-and-workflow/)
4. [Triển khai hệ thống CloudSOC](5.4-deploy-cloudsoc-system/)
5. [Kiểm thử và xác thực hệ thống](5.5-testing-and-validation/)
6. [Dọn dẹp tài nguyên](5.6-resource-cleanup/)

---

#### Kết quả mong đợi

Sau khi hoàn thành workshop, bạn sẽ có một mô hình lab **AWS CloudSOC** có khả năng:

+ Phát hiện security findings giả lập từ GuardDuty.
+ Tự động chuyển findings thông qua EventBridge.
+ Xử lý incident bằng Step Functions và Lambda.
+ Hỗ trợ SOC Analyst phê duyệt một số incident cần kiểm tra thủ công.
+ Tự động cô lập EC2 bằng `SG-Isolation`.
+ Thu thập forensic evidence bằng Systems Manager.
+ Tạo EBS Snapshot để phục vụ điều tra.
+ Lưu raw event và response summary vào S3.
+ Theo dõi trạng thái incident trong DynamoDB.
+ Hiển thị trạng thái incident trên SOC Dashboard.
+ Gửi cảnh báo đến Email và Slack thông qua SNS.
+ Dọn dẹp toàn bộ tài nguyên sau khi hoàn thành lab.