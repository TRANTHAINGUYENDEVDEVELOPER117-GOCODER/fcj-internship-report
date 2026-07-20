---
title: "Kiến trúc hệ thống & luồng xử lý SOC"
date: 2026-07-11
weight: 2
chapter: false
pre: " <b> 5.2. </b> "
---

# Kiến trúc hệ thống AWS CloudSOC

### 1. Nguyên tắc thiết kế

Kiến trúc AWS CloudSOC được thiết kế theo các nguyên tắc:

- **Event-driven:** finding từ GuardDuty được đưa vào EventBridge để kích hoạt Step Functions.
- **Controlled response:** không tự động cô lập mọi cảnh báo, có policy và approval gate.
- **Evidence first:** thu thập forensic và tạo snapshot trước khi containment.
- **Least privilege:** mỗi Lambda/Step Functions/EC2 role chỉ có quyền cần thiết.
- **Auditability:** mọi bước quan trọng đều ghi log vào CloudWatch/S3/DynamoDB.
- **Lab-friendly:** tối ưu chi phí, dễ demo, dễ giải thích trước mentor/admin.

### 2. Luồng truy cập SOC Dashboard

SOC Analyst truy cập dashboard qua **AWS Amplify Hosting** bằng HTTPS. Người dùng đăng nhập bằng **Amazon Cognito**, sau đó nhận JWT token. Khi dashboard gọi API, **Amazon API Gateway** kiểm tra JWT bằng Authorizer trước khi chuyển request đến **Dashboard API Lambda**.

Luồng:

```text
SOC Analyst
→ AWS Amplify
→ Amazon Cognito (Sign In)
→ API Gateway (JWT Authorizer)
→ Dashboard API Lambda
→ DynamoDB / S3 / Step Functions
```

Dashboard API Lambda có các nhiệm vụ:

- Đọc danh sách incident từ DynamoDB.
- Lấy evidence từ S3.
- Ghi API logs vào CloudWatch.
- Gửi approval callback về Step Functions khi SOC Analyst chọn Approve/Reject.

### 3. Luồng traffic thử nghiệm trong VPC

Trong lab, EC2 được đặt ở **Public Subnet** để dễ mô phỏng traffic tấn công:

```text
Threat Actor
→ Internet
→ Internet Gateway
→ Amazon EC2 (SG-Workload)
```

Các hành vi mô phỏng:

- Port scanning.
- SSH brute-force.
- Truy cập từ IP đáng ngờ.
- Traffic bất thường đến EC2.

Hai Security Group chính:

| Security Group | Vai trò |
| --- | --- |
| `SG-Workload` | Security Group bình thường của EC2 |
| `SG-Isolation` | Security Group rỗng, dùng để cô lập EC2 |

Khi containment, Lambda thay Security Group hiện tại của EC2 bằng `SG-Isolation`.

### 4. Thu thập log & lưu trữ bằng chứng

Hệ thống thu thập log từ nhiều nguồn:

| Nguồn | Đích lưu trữ | Mục đích |
| --- | --- | --- |
| CloudTrail | S3 + CloudWatch Logs | Audit hoạt động API/Console/CLI |
| VPC Flow Logs | CloudWatch Logs | Theo dõi traffic metadata |
| GuardDuty Findings | Security Hub + EventBridge + S3 | Phát hiện threat và lưu bằng chứng |
| Systems Manager Output | S3 | Lưu forensic |
| EBS Snapshot | EBS Snapshot | Bảo toàn trạng thái volume |
| Lambda/Step Functions Logs | CloudWatch | Debug và audit workflow |

S3 nên bật mã hóa **SSE-KMS** để bảo vệ log và evidence.

### 5. Phát hiện mối đe dọa

**Amazon GuardDuty** phân tích telemetry từ:

- CloudTrail management events.
- VPC Flow Logs.
- DNS logs.

Khi có finding, GuardDuty gửi dữ liệu đến:

- **Security Hub:** tổng hợp finding.
- **Detective:** hỗ trợ điều tra chuyên sâu.
- **EventBridge:** kích hoạt Step Functions nếu finding match pattern.

Detective không trực tiếp nằm trong luồng cô lập tự động, mà phục vụ nhánh điều tra thủ công của SOC Analyst.

### 6. Điều phối phản ứng bằng Step Functions

Step Functions là trung tâm điều phối phản ứng sự cố. Workflow kiểm tra:

- Finding có liên quan đến EC2 không?
- Có xác định được Instance ID không?
- Severity là Low/Medium/High/Critical?
- EC2 có tag `AutoIsolate=true` không?
- Hệ thống đang ở chế độ Dry-run hay Enforce?
- Có cần approval thủ công không?

Chính sách đề xuất:

| Điều kiện | Hành động đề xuất |
| --- | --- |
| Finding không phải EC2 | Lưu incident + gửi cảnh báo |
| Không xác định được Instance ID | Chuyển `NEEDS_REVIEW` |
| Low/Medium severity | Alert only, không cô lập |
| High + `AutoIsolate=true` | Yêu cầu SOC Analyst phê duyệt |
| Critical + `AutoIsolate=true` | Có thể tự động tiếp tục tùy policy |
| Thiếu tag `AutoIsolate=true` | Dry-run hoặc chờ review thủ công |

### 7. Approval Gate

Với incident cần kiểm tra trước khi containment:

```text
Step Functions
→ SNS
→ Amazon Q Developer / Slack / Email / SMS
→ SOC Analyst mở Dashboard
→ Approve / Reject
→ Dashboard API Lambda
→ Step Functions callback
```

Cơ chế callback task token giúp workflow tạm dừng cho đến khi SOC Analyst quyết định.

### 8. Thu thập forensic & snapshot

Thứ tự bắt buộc:

```text
Collect Evidence
→ Store Forensics
→ Create EBS Snapshot
→ Apply Isolation
```

Không được cô lập EC2 trước khi thu thập evidence vì `SG-Isolation` có thể làm mất kết nối của SSM Agent với Systems Manager.

Evidence cần thu thập:

- Danh sách process đang chạy.
- Kết nối mạng hiện tại.
- User đang login.
- System logs.
- IP/routing table.
- Security Group trước khi cô lập.

### 9. Cô lập EC2

Incident Response Lambda thực hiện:

1. Nhận Instance ID từ Step Functions.
2. Kiểm tra tag và trạng thái instance.
3. Lưu Security Group hiện tại.
4. Thay `SG-Workload` bằng `SG-Isolation`.
5. Lưu Security Group trước/sau cô lập vào S3.
6. Lưu kết quả xử lý vào S3/DynamoDB.
7. Ghi log vào CloudWatch.
8. Gửi notification kết quả qua SNS.

Lưu ý: Security Group là **stateful**, nên một số connection đã thiết lập có thể chưa bị cắt ngay lập tức. Tuy nhiên, kết nối mới sẽ bị chặn theo rule của `SG-Isolation`.

### 10. Governance & Monitoring

- **CloudWatch Alarm:** theo dõi lỗi Lambda/workflow.
- **AWS Config:** ghi lại thay đổi Security Group, EC2, cấu hình liên quan.
- **IAM:** role theo least privilege cho Dashboard API Lambda, Incident Response Lambda, Step Functions, EC2 SSM Role.
- **KMS:** mã hóa evidence và audit logs.

Trong sơ đồ, các quan hệ IAM nên được vẽ bằng đường nét đứt để phân biệt với luồng dữ liệu:

- `Execution Role`: IAM → Lambda.
- `Workflow Role`: IAM → Step Functions.
- `SSM Instance Role`: IAM → EC2.
- `KMS Policy`: KMS/IAM Policy → S3 evidence bucket.

### 11. Kết luận kiến trúc

Kiến trúc CloudSOC thể hiện đầy đủ tư duy SOC trên AWS: phát hiện, điều tra, ra quyết định, thu thập bằng chứng, cô lập và thông báo. Điểm quan trọng nhất là có **policy kiểm soát** và **approval gate**, giúp giảm rủi ro tự động hóa sai.

