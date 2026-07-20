---
title: "Checklist review sơ đồ & yêu cầu nộp"
date: 2026-07-11
weight: 4
chapter: false
pre: " <b> 5.4. </b> "
---

# Checklist review sơ đồ AWS CloudSOC

Trang này dùng để tự kiểm tra trước khi nộp báo cáo/workshop cho công ty hoặc trình bày trước mentor.

### 1. Checklist tổng quan

| STT | Tiêu chí | Trạng thái |
| --- | --- | --- |
| 1 | Có title rõ ràng: **AWS CloudSOC Architecture – Lab/PoC** | ☐ |
| 2 | Có tên đầy đủ hai thành viên: Trần Thái Nguyên và Dương Bá Đạt | ☐ |
| 3 | Có ngày/tháng/năm và version sơ đồ | ☐ |
| 4 | Có boundary **AWS Cloud → Region → VPC → Subnet** | ☐ |
| 5 | Có phân biệt rõ **Availability Zone**, Public Subnet và workload EC2 lab | ☐ |
| 6 | Có Threat Actor, Internet, Internet Gateway | ☐ |
| 7 | Có SOC Analyst và dashboard access flow | ☐ |
| 8 | Dùng AWS icons chuẩn hoặc shape nhất quán | ☐ |
| 9 | Màu sắc có ý nghĩa và nhất quán | ☐ |
| 10 | Có legend giải thích vùng màu và mũi tên | ☐ |
| 11 | Có thể hiện các đường nét đứt cho IAM role/policy | ☐ |

### 2. Checklist service bắt buộc

| Nhóm | Thành phần cần có |
| --- | --- |
| Dashboard | AWS Amplify, Cognito, API Gateway, Dashboard API Lambda |
| Data | DynamoDB, S3 |
| Logging | CloudTrail, CloudWatch, VPC Flow Logs |
| Detection | GuardDuty, Security Hub, Detective |
| Orchestration | EventBridge, Step Functions |
| Forensic | Systems Manager, EBS Snapshot |
| Response | Incident Response Lambda, SG-Isolation |
| Notification | SNS, Amazon Q Developer, Slack Channel, Email/SMS |
| Governance | IAM, IAM Policy, Config, KMS |

### 3. Checklist mũi tên & nhãn

Các mũi tên quan trọng không được thiếu:

- `HTTPS Access`: SOC Analyst → Amplify.
- `Sign In`: Amplify → Cognito.
- `Invoke API`: Amplify/API client → API Gateway.
- `JWT Authorizer`: API Gateway kiểm tra Cognito token.
- `Read / Update Incidents`: Lambda → DynamoDB.
- `Get Evidence`: Dashboard API Lambda → S3.
- `API Logs`: Dashboard API Lambda → CloudWatch.
- `Security Finding`: GuardDuty → EventBridge/Security Hub/Detective.
- `Start Workflow`: EventBridge → Step Functions.
- `Request Approval`: Step Functions → SNS.
- `Forward to Slack`: SNS → Amazon Q Developer → Slack Channel.
- `Send Email/SMS`: SNS → Email/SMS.
- `Approval Callback`: Dashboard API Lambda → Step Functions.
- `Collect Evidence`: Step Functions → Systems Manager.
- `Store Forensics`: Systems Manager → S3.
- `Create Snapshot`: Systems Manager → EBS Snapshot.
- `Apply Isolation – Replace Security Group`: Lambda → EC2.
- `Store SG Before/After`: Incident Response Lambda → S3.
- `Store Response`: Incident Response Lambda → DynamoDB/S3.
- `Send Result`: Incident Response Lambda → SNS.
- `Error Alarm`: CloudWatch Alarm → SNS.
- `Configuration Changes`: EC2/Security Group → AWS Config.
- `Encrypt Evidence`: KMS → S3.
- `Execution Role`: IAM → Lambda.
- `Workflow Role`: IAM → Step Functions.
- `SSM Instance Role`: IAM → EC2.

### 4. Checklist logic SOC

Kiểm tra sơ đồ và báo cáo phải thể hiện đúng thứ tự:

```text
Detect
→ Investigate
→ Decide
→ Collect Evidence
→ Create Snapshot
→ Contain
→ Notify
→ Recover / Review
```

Không được trình bày theo hướng cô lập EC2 trước khi thu thập evidence. Đây là lỗi logic nghiêm trọng vì có thể làm mất kết nối SSM Agent và mất cơ hội thu thập forensic.

### 5. Checklist policy response

Trong báo cáo hoặc callout trên sơ đồ nên có bảng policy:

| Điều kiện | Hành động |
| --- | --- |
| Finding không liên quan EC2 | Alert only |
| Không có Instance ID | Needs review |
| Low/Medium severity | Alert only |
| High + `AutoIsolate=true` | Manual approval |
| Critical + `AutoIsolate=true` | Auto/approval tùy policy |
| Không có tag `AutoIsolate=true` | Dry-run hoặc manual review |

### 6. Checklist trình bày chuyên nghiệp

- Không để quá nhiều đường chéo cắt nhau.
- Các nhóm service phải có khoảng cách đều.
- Tên service viết đúng chuẩn AWS.
- Không dùng quá 5–6 màu chính.
- Footer phải ghi rõ **Lab / Proof of Concept**.
- Có ghi chú rằng EC2 ở Public Subnet chỉ phục vụ lab.
- Có ghi chú rằng đường nét đứt thể hiện IAM Role/Policy, không phải data flow.
- Có hướng production: Private Subnet, ALB, NAT Gateway, Multi-AZ, IaC.

### 7. File cần nộp

Khuyến nghị nộp đủ:

- File ảnh kiến trúc `.png` chất lượng cao.
- File nguồn draw.io `.drawio`.
- Link website Hugo.
- Bản báo cáo Markdown/HTML trong mục Workshop.
- Slide ngắn 5–7 phút nếu cần thuyết trình.

### 7.1. Checklist nội dung bài nhóm

| Nội dung | Trạng thái |
| --- | --- |
| Proposal thể hiện rõ đây là dự án nhóm | ☐ |
| Workshop ghi đúng tên Trần Thái Nguyên và Dương Bá Đạt | ☐ |
| Có bảng phân công vai trò từng thành viên | ☐ |
| Không còn nội dung xưng “em/tôi” theo dạng bài cá nhân trong phần Proposal/Workshop | ☐ |
| Không còn nội dung cũ sai đề tài CloudSOC | ☐ |
| Có sản phẩm bàn giao rõ ràng: website, sơ đồ, checklist, hướng production | ☐ |
| Có thể giải thích dự án trong 5–7 phút trước công ty/mentor | ☐ |

### 8. Câu hỏi phản biện thường gặp

**Vì sao không cô lập tự động mọi finding?**  
Vì finding có thể là false positive hoặc severity thấp. Hệ thống dùng policy và approval gate để tránh ảnh hưởng nhầm workload.

**Vì sao phải thu thập evidence trước khi cô lập?**  
Vì sau khi thay Security Group, EC2 có thể mất kết nối với Systems Manager. Nếu chưa thu thập forensic, SOC Analyst có thể mất dữ liệu quan trọng.

**Vì sao EC2 đặt ở Public Subnet?**  
Đây là lab/PoC để dễ mô phỏng traffic tấn công. Production nên chuyển workload vào Private Subnet và đặt ALB/WAF phía trước.

**Security Group Isolation có chặn ngay mọi kết nối không?**  
Không hoàn toàn. Security Group là stateful, một số connection đã thiết lập có thể còn tồn tại ngắn hạn, nhưng kết nối mới sẽ bị chặn.

