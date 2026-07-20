---
title: "Nối luồng xử lý sự cố"
date: 2026-07-17
weight: 4
chapter: false
pre: " <b> 5.3.4. </b> "
---

# Nối luồng xử lý sự cố

### 0. Quy tắc màu và kiểu mũi tên

| Loại luồng | Màu/Style | Ví dụ |
| --- | --- | --- |
| API/Data flow | Đen, nét liền | `Invoke API`, `Read Incident` |
| Detection/Event flow | Cam, nét liền | `Security Finding`, `Start Workflow` |
| Approval/Notification | Tím, nét liền | `Request Approval`, `Approval Callback` |
| Evidence/Logging | Xám, nét đứt | `Store Forensics`, `API Logs` |
| Isolation action | Đỏ, nét liền đậm | `Apply Isolation - Replace Security Group` |
| IAM/Governance | Xám, nét đứt | `Execution Role`, `Workflow Role` |

> Khi vẽ, không dùng cùng một màu cho mọi mũi tên. Màu mũi tên giúp người xem phân biệt đâu là traffic, đâu là log, đâu là approval và đâu là hành động cô lập.

### 1. Luồng truy cập dashboard

Vẽ các mũi tên:

```text
SOC Analyst → AWS Amplify
AWS Amplify → Amazon Cognito
AWS Amplify → Amazon API Gateway
API Gateway → Dashboard API Lambda
Dashboard API Lambda → DynamoDB
Dashboard API Lambda → S3
Dashboard API Lambda → Step Functions
```

Nhãn:

- `HTTPS Access`
- `Sign In`
- `JWT Authorizer`
- `Invoke API`
- `Read / Update Incident`
- `Get Evidence`
- `Approval Callback`

### 2. Luồng phát hiện threat

Vẽ:

```text
CloudTrail / VPC Flow Logs / DNS Logs → GuardDuty
GuardDuty → Security Hub
GuardDuty → Detective
GuardDuty → EventBridge
EventBridge → Step Functions
```

Nhãn:

- `Threat Telemetry`
- `Security Finding`
- `Investigate Finding`
- `Match Event Pattern`
- `Start Workflow`

### 3. Luồng approval

Vẽ:

```text
Step Functions → SNS
SNS → Amazon Q Developer → Slack Channel
SNS → Email/SMS
SOC Analyst → Dashboard
Dashboard API Lambda → Step Functions
```

Nhãn:

- `Request Approval`
- `Forward to Slack`
- `Send Email/SMS`
- `Approve / Reject`
- `Approval Callback Task Token`

### 4. Luồng forensic trước khi cô lập

Thứ tự bắt buộc:

```text
Step Functions → Systems Manager
Systems Manager → EC2
Systems Manager → S3
Systems Manager → EBS Snapshot
```

Nhãn:

- `Collect Evidence`
- `Run Command`
- `Store Forensics`
- `Create Snapshot`

Không được vẽ containment trước forensic collection.

### 5. Luồng cô lập EC2

Vẽ:

```text
Step Functions → Incident Response Lambda
Incident Response Lambda → EC2
Incident Response Lambda → S3
Incident Response Lambda → DynamoDB
Incident Response Lambda → SNS
```

Nhãn:

- `Apply Isolation`
- `Replace Security Group`
- `Store SG Before/After`
- `Store Response`
- `Send Result`

Mũi tên `Apply Isolation – Replace Security Group` nên dùng màu đỏ.

### 6. Luồng governance

Vẽ đường nét đứt:

```text
IAM → Lambda
IAM → Step Functions
IAM → EC2
KMS → S3
AWS Config → EC2 / Security Group
```

Nhãn:

- `Execution Role`
- `Workflow Role`
- `SSM Instance Role`
- `Encrypt Evidence`
- `Configuration Changes`

