---
title: "Bản đặc tả vẽ sơ đồ chi tiết"
date: 2026-07-17
weight: 6
chapter: false
pre: " <b> 5.3.6. </b> "
---

# Bản đặc tả vẽ sơ đồ chi tiết

Trang này là checklist kỹ thuật chi tiết nhất để vẽ lại sơ đồ **AWS CloudSOC Architecture** sát với ảnh mẫu. Khi vẽ trong draw.io, nhóm có thể làm theo đúng thứ tự dưới đây.

### 1. Kích thước canvas và layer

Khuyến nghị tạo canvas ngang, tỷ lệ rộng:

| Thành phần | Thiết lập |
| --- | --- |
| Canvas | A3 Landscape hoặc Custom Wide |
| Grid | Bật grid |
| Connector | Orthogonal / Elbow connector |
| Font | Arial hoặc Inter |
| Group title | 18–22 px, bold |
| Service label | 11–13 px |
| Arrow label | 9–11 px |
| Export | PNG 2x/3x + SVG + file `.drawio` |

Thứ tự layer từ dưới lên:

1. AWS Cloud boundary.
2. AWS Region boundary.
3. VPC / AZ / Subnet.
4. Group boxes.
5. AWS service icons.
6. Connectors / arrows.
7. Arrow labels.
8. Legend / footer.

### 2. Bảng vị trí các vùng chính

Dùng bảng này để đặt layout gần giống ảnh mẫu. Tọa độ là tương đối theo canvas, không cần chính xác tuyệt đối.

| Vùng | Vị trí trên canvas | Kích thước gợi ý | Màu/Style |
| --- | --- | --- | --- |
| AWS Cloud | Bao toàn bộ sơ đồ | 95% rộng, 90% cao | Nền trắng/xám rất nhạt, viền đen |
| AWS Region `ap-southeast-1` | Bên trong AWS Cloud | Gần bằng AWS Cloud, nhỏ hơn 5–8% | Không fill, nét đứt teal |
| Threat Actor + Internet | Ngoài cùng bên trái | Nhỏ | User icon + cloud icon |
| VPC | Nửa trái, hơi cao hơn giữa | 25–30% rộng | Viền tím |
| Availability Zone | Bên trong VPC | 70% VPC | Nền xanh/xám nhạt |
| Public Subnet | Bên trong AZ | 60% AZ | Nền vàng nhạt |
| SOC Dashboard & Access | Góc trên bên phải | Rộng vừa | Nền teal nhạt |
| Logging & Evidence Storage | Giữa bên phải | Rộng vừa | Nền xanh dương nhạt |
| Threat Detection & Response | Dưới Logging | Rộng nhất trong các group bên phải | Nền cam nhạt |
| Security, Compliance & Governance | Dưới bên trái | Ngang dưới VPC | Nền đỏ nhạt |
| SOC Analyst | Ngoài cùng bên phải | Nhỏ | User icon |
| Slack/Email/SMS | Dưới bên phải | Nhỏ | App/channel icons |

### 3. Bảng đặt service trong từng vùng

#### VPC / Workload

| Service/Box | Vị trí | Ghi chú |
| --- | --- | --- |
| Internet Gateway | Mép trái VPC | Nối Internet vào VPC |
| Amazon EC2 | Giữa Public Subnet | Workload thử nghiệm |
| `SG-Workload` | Trên hoặc cạnh EC2 | Security Group hiện tại |
| `SG-Isolation` | Bên phải EC2 | Box đỏ/trắng, ghi No inbound/outbound rules |

#### SOC Dashboard & Access

| Service | Vị trí gợi ý | Nối với |
| --- | --- | --- |
| AWS Amplify | Trái trong group | SOC Analyst, Cognito, API Gateway |
| Amazon Cognito | Giữa/trên | Amplify, API Gateway |
| API Gateway | Phải/trên | Amplify, Dashboard API Lambda |
| Dashboard API Lambda | Dưới/giữa | DynamoDB, S3, CloudWatch, Step Functions |
| DynamoDB | Dưới/trái | Dashboard API Lambda |

#### Logging & Evidence Storage

| Service | Vị trí gợi ý | Vai trò |
| --- | --- | --- |
| CloudTrail | Trái | Audit logs |
| S3 Evidence Bucket | Giữa | Lưu finding, evidence, forensic |
| CloudWatch Logs/Alarm | Phải | Logs và error alarm |
| EBS Snapshot | Dưới S3 | Snapshot phục vụ forensic |

#### Threat Detection & Response

| Service | Vị trí gợi ý | Vai trò |
| --- | --- | --- |
| GuardDuty | Trái/dưới | Detection chính |
| Security Hub | Trên giữa | Tổng hợp finding |
| Detective | Trên phải | Điều tra thủ công |
| EventBridge | Giữa/trái | Match event pattern |
| Step Functions | Trung tâm group | Điều phối workflow |
| Systems Manager | Dưới Step Functions | Thu thập forensic |
| Incident Response Lambda | Phải | Cô lập EC2 |
| SNS | Dưới/phải | Alert/approval/result |
| Amazon Q Developer | Ngoài group, gần Slack | Forward Slack |
| Slack Channel / Email-SMS | Ngoài cùng phải | Kênh nhận thông báo |

#### Security, Compliance & Governance

| Service | Vị trí gợi ý | Kiểu line |
| --- | --- | --- |
| IAM | Trái | Nét đứt đến Lambda/Step Functions/EC2 |
| IAM Policy | Gần IAM | Nét đứt |
| AWS Config | Giữa/phải | Nét đứt từ EC2/Security Group |
| KMS | Phải | Nét đứt đến S3 |

### 4. Bảng mũi tên bắt buộc

| STT | From | To | Label | Màu/Style |
| --- | --- | --- | --- | --- |
| 1 | Threat Actor | Internet | `Attack Traffic` | Đen |
| 2 | Internet | Internet Gateway | `Internet Traffic` | Đen |
| 3 | Internet Gateway | Amazon EC2 | `Port Scan / SSH Brute-force` | Đen |
| 4 | SOC Analyst | AWS Amplify | `HTTPS Access` | Đen |
| 5 | Amplify | Cognito | `Sign In` | Đen |
| 6 | Amplify | API Gateway | `Invoke API` | Đen |
| 7 | Cognito | API Gateway | `JWT Authorizer` | Đen |
| 8 | API Gateway | Dashboard API Lambda | `Invoke Lambda` | Đen |
| 9 | Dashboard API Lambda | DynamoDB | `Read / Update Incident` | Xanh lá hoặc đen |
| 10 | Dashboard API Lambda | S3 | `Get Evidence` | Xanh lá |
| 11 | Dashboard API Lambda | CloudWatch | `API Logs` | Xám nét đứt |
| 12 | Dashboard API Lambda | Step Functions | `Approval Callback` | Tím |
| 13 | CloudTrail / VPC Flow Logs / DNS Logs | GuardDuty | `Threat Telemetry` | Xám nét đứt |
| 14 | GuardDuty | Security Hub | `Security Finding` | Cam/đen |
| 15 | GuardDuty | Detective | `Investigate Finding` | Cam/đen |
| 16 | GuardDuty | EventBridge | `Security Finding` | Cam |
| 17 | EventBridge | Step Functions | `Start Workflow` | Cam |
| 18 | Step Functions | SNS | `Request Approval` | Tím |
| 19 | SNS | Amazon Q Developer | `Forward to Slack` | Tím |
| 20 | Amazon Q Developer | Slack Channel | `Post Slack Alert` | Tím |
| 21 | SNS | Email/SMS | `Send Email/SMS` | Tím |
| 22 | Step Functions | Systems Manager | `Collect Evidence` | Cam/đen |
| 23 | Systems Manager | EC2 | `Run Command` | Đen |
| 24 | Systems Manager | S3 | `Store Forensics` | Xám nét đứt |
| 25 | Systems Manager | EBS Snapshot | `Create Snapshot` | Xám nét đứt |
| 26 | Step Functions | Incident Response Lambda | `Invoke Isolation` | Đỏ |
| 27 | Incident Response Lambda | EC2 | `Apply Isolation - Replace Security Group` | Đỏ đậm |
| 28 | Incident Response Lambda | S3 | `Store SG Before/After` | Xám nét đứt |
| 29 | Incident Response Lambda | DynamoDB | `Store Response` | Xanh lá/đen |
| 30 | Incident Response Lambda | SNS | `Send Result` | Đen |
| 31 | CloudWatch Alarm | SNS | `Error Alarm` | Cam/đỏ |
| 32 | AWS Config | EC2 / Security Group | `Configuration Changes` | Xám nét đứt |
| 33 | IAM | Lambda | `Execution Role` | Xám nét đứt |
| 34 | IAM | Step Functions | `Workflow Role` | Xám nét đứt |
| 35 | IAM | EC2 | `SSM Instance Role` | Xám nét đứt |
| 36 | KMS | S3 | `Encrypt Evidence` | Xám nét đứt |

### 5. Quy tắc routing để sơ đồ không rối

- Luồng attack đi ngang từ trái sang phải.
- Luồng dashboard nằm trên cùng, hạn chế cắt qua vùng Threat Detection.
- Luồng logging/evidence dùng nét xám hoặc nét đứt.
- Luồng approval dùng màu tím, chạy từ Step Functions → SNS → Q Developer/Slack.
- Luồng isolation dùng màu đỏ, chỉ có một mũi tên đỏ chính từ Lambda → EC2.
- Luồng IAM/KMS/Config dùng nét đứt, không dùng cùng style với data flow.
- Nếu hai đường cắt nhau, ưu tiên route bằng connector vuông góc thay vì đường chéo.

### 6. Callout bắt buộc

Gần Step Functions, thêm box nhỏ **Decision Policy**:

```text
Decision Policy
- EC2 finding?
- Instance ID exists?
- Severity: Low / Medium / High / Critical
- AutoIsolate=true?
- Dry-run or Enforce?
- Manual approval required?
```

Mục đích: chứng minh hệ thống không tự động cô lập mọi finding.

### 7. Footer và legend

Footer nên đặt ở góc dưới:

```text
AWS CloudSOC Architecture – Lab / Proof of Concept
Region: ap-southeast-1 | Single AZ | Public Subnet for lab only
Team: Trần Thái Nguyên & Dương Bá Đạt – HUTECH 22DTHB1
July 2026
```

Legend nên có:

- Teal: Dashboard & Access.
- Blue: Logging & Evidence.
- Orange: Threat Detection & Response.
- Red: Security & Governance.
- Red arrow: Isolation action.
- Purple arrow: Approval/notification.
- Gray dashed line: Logs, evidence, IAM/policy/governance.

### 8. Kiểm tra logic cuối cùng

Sơ đồ đạt yêu cầu khi người xem có thể kể lại flow:

```text
Threat traffic
→ GuardDuty detects finding
→ EventBridge starts Step Functions
→ SOC policy checks severity/tag/mode
→ SNS asks for approval if needed
→ Systems Manager collects evidence
→ EBS Snapshot preserves disk state
→ Lambda replaces EC2 Security Group
→ SNS sends final notification
```

