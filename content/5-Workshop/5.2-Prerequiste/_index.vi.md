---
title : "Chuẩn bị môi trường"
date : 2024-01-01
weight : 2
chapter : false
pre : " <b> 5.2. </b> "
---

#### Chuẩn bị môi trường

Trước khi bắt đầu workshop, bạn cần chuẩn bị môi trường AWS và các quyền truy cập cần thiết. Phần chuẩn bị này giúp quá trình triển khai kiến trúc AWS CloudSOC diễn ra thuận lợi và hạn chế lỗi cấu hình trong quá trình thực hiện.

---

#### Tài khoản AWS

Bạn cần có một tài khoản AWS đang hoạt động và có quyền tạo, quản lý các tài nguyên AWS.

Workshop này yêu cầu quyền truy cập vào các dịch vụ như:

+ Amazon EC2
+ Amazon VPC
+ AWS IAM
+ Amazon S3
+ Amazon CloudWatch
+ AWS CloudTrail
+ Amazon GuardDuty
+ AWS Security Hub
+ Amazon Detective
+ Amazon EventBridge
+ AWS Step Functions
+ AWS Systems Manager
+ AWS Lambda
+ Amazon DynamoDB
+ Amazon SNS
+ Amazon Cognito
+ Amazon API Gateway
+ AWS Amplify Hosting

> **Lưu ý:** Nên sử dụng tài khoản AWS Academy hoặc tài khoản AWS cá nhân có quyền AdministratorAccess trong quá trình thực hành lab.

---

#### Khu vực triển khai AWS

Để đảm bảo tính nhất quán trong toàn bộ workshop, tất cả tài nguyên AWS nên được triển khai trong cùng một Region.

Region được khuyến nghị sử dụng là:

```text
ap-southeast-1 (Singapore)
```

Việc sử dụng một Region duy nhất giúp đơn giản hóa quá trình quản lý tài nguyên và tránh các lỗi cấu hình liên quan đến cross-region.

![AWS Region](/images/5-Workshop/5.2-Prerequisites/aws-region.png)

---

#### Môi trường phát triển

Chuẩn bị các công cụ sau trước khi bắt đầu triển khai:

+ Trình duyệt web hiện đại như Google Chrome hoặc Microsoft Edge
+ AWS Management Console
+ AWS CLI nếu cần thao tác bằng dòng lệnh
+ Visual Studio Code nếu cần chỉnh sửa mã nguồn
+ Draw.io để vẽ hoặc chỉnh sửa sơ đồ kiến trúc

---

#### Quyền IAM cần thiết

Tài khoản được sử dụng trong workshop cần có quyền tạo và quản lý các tài nguyên sau:

+ VPC
+ EC2
+ IAM Roles
+ Security Groups
+ S3 Buckets
+ CloudTrail
+ CloudWatch
+ GuardDuty
+ Security Hub
+ Detective
+ EventBridge
+ Step Functions
+ Systems Manager
+ Lambda
+ DynamoDB
+ SNS
+ Cognito
+ API Gateway
+ Amplify Hosting

Các quyền này là cần thiết vì workshop sẽ triển khai nhiều dịch vụ AWS và các dịch vụ này cần tương tác với nhau trong cùng một kiến trúc.

---

#### Các dịch vụ AWS được sử dụng

Kiến trúc AWS CloudSOC được xây dựng dựa trên các nhóm dịch vụ chính sau:

| Nhóm dịch vụ | Dịch vụ AWS |
|----------|--------------|
| Network | Amazon VPC, Public Subnet, Internet Gateway, Amazon EC2, Security Groups |
| Logging | AWS CloudTrail, Amazon CloudWatch, Amazon S3, VPC Flow Logs |
| Detection | Amazon GuardDuty, AWS Security Hub, Amazon Detective |
| Response | Amazon EventBridge, AWS Step Functions, AWS Systems Manager, AWS Lambda |
| Evidence | Amazon S3, Amazon EBS Snapshot, Amazon DynamoDB |
| Dashboard | AWS Amplify Hosting, Amazon Cognito, Amazon API Gateway |
| Notification | Amazon SNS, Amazon Q Developer |
| Governance | AWS IAM, AWS Config, AWS KMS |

![AWS Services](/images/5-Workshop/5.2-Prerequisites/aws-services-overview.png)

---

#### Ước tính chi phí

Workshop này được thiết kế theo mô hình Lab / Proof of Concept và hướng đến việc tối ưu chi phí sử dụng AWS.

Tuy nhiên, một số dịch vụ vẫn có thể phát sinh chi phí tùy theo thời gian sử dụng và tài nguyên được tạo, bao gồm:

+ Amazon EC2
+ Amazon EBS Snapshot
+ Amazon S3
+ Amazon CloudWatch Logs
+ Amazon GuardDuty
+ AWS Security Hub
+ Amazon Detective

Để tránh phát sinh chi phí không mong muốn, hãy hoàn thành phần **Resource Cleanup** sau khi kết thúc workshop.

---

#### Kiểm tra trước khi bắt đầu

Trước khi chuyển sang phần triển khai, hãy kiểm tra các mục sau:

- [ ] Tài khoản AWS đã sẵn sàng.
- [ ] Region đã được đặt là **ap-southeast-1**.
- [ ] Tài khoản có đầy đủ quyền IAM cần thiết.
- [ ] Các dịch vụ AWS cần dùng trong workshop có thể truy cập được.
- [ ] Bạn đã hiểu kiến trúc tổng quan của hệ thống AWS CloudSOC.
- [ ] Bạn đã sẵn sàng bắt đầu triển khai.

Môi trường hiện đã sẵn sàng để triển khai kiến trúc AWS CloudSOC.