---
title: "Vẽ các nhóm dịch vụ AWS"
date: 2026-07-17
weight: 3
chapter: false
pre: " <b> 5.3.3. </b> "
---

# Vẽ các nhóm dịch vụ AWS

### 1. SOC Dashboard & Access

Vẽ khung màu teal tên **SOC Dashboard & Access** ở góc trên bên phải.

Thêm các service:

- AWS Amplify Dashboard App.
- Amazon Cognito.
- Amazon API Gateway.
- AWS Lambda Dashboard API.
- Amazon DynamoDB.

Sắp xếp gợi ý:

```text
Amplify → Cognito → API Gateway
             ↓
Dashboard API Lambda → DynamoDB
```

### 2. Logging & Evidence Storage

Vẽ khung màu xanh dương tên **Logging & Evidence Storage** ở giữa bên phải.

Thêm:

- AWS CloudTrail.
- Amazon S3 Evidence Bucket.
- Amazon CloudWatch Logs/Alarm.
- Amazon EBS Snapshot.

Vai trò:

- CloudTrail lưu audit logs.
- CloudWatch nhận API logs, VPC Flow Logs và execution logs.
- S3 lưu forensic, finding, Security Group trước/sau cô lập.
- EBS Snapshot bảo toàn trạng thái ổ đĩa.

### 3. Threat Detection & Response

Vẽ khung màu cam tên **Threat Detection & Response** ở dưới bên phải.

Thêm:

- Amazon GuardDuty.
- AWS Security Hub.
- Amazon Detective.
- Amazon EventBridge.
- AWS Step Functions.
- AWS Systems Manager.
- Incident Response Lambda.
- Amazon SNS.
- Amazon Q Developer.
- Slack Channel.
- Email/SMS.

Đây là vùng quan trọng nhất, cần để rộng hơn các vùng khác.

### 4. Security, Compliance & Governance

Vẽ khung màu đỏ nhạt ở dưới bên trái.

Thêm:

- AWS IAM.
- IAM Policy.
- AWS Config.
- AWS KMS.

Các service này nên nối bằng **đường nét đứt** vì thể hiện quyền, policy, encryption và governance, không phải luồng dữ liệu chính.

### 5. Quy tắc đặt tên service

Tên nên dùng chuẩn AWS:

- **Amazon GuardDuty**, không viết “Guard Duty”.
- **AWS Step Functions**, không viết “Step Function”.
- **Amazon EventBridge**, không viết “CloudWatch Event”.
- **Amazon DynamoDB**, không viết “Dynamo DB”.
- **AWS Systems Manager**, có thể ghi thêm `SSM`.

