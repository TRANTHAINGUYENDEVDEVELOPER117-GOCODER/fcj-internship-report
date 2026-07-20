---
title: "Báo cáo chi tiết dự án AWS CloudSOC"
date: 2026-07-11
weight: 1
chapter: false
pre: " <b> 5.1. </b> "
---

# Báo cáo dự án AWS CloudSOC

**Tên đề tài:** Thiết kế và triển khai hệ thống AWS CloudSOC – Phát hiện, điều tra và phản ứng sự cố có kiểm soát trên AWS  
**Nhóm thực hiện:** Trần Thái Nguyên, Dương Bá Đạt  
**Trường/Lớp:** HUTECH – 22DTHB1  
**Chuyên ngành:** An ninh mạng  
**Chương trình:** AWS Vietnam FCJ Workforce Bootcamp 2026  
**Thời gian:** Tháng 7/2026

### 1. Mục tiêu dự án

Dự án **AWS CloudSOC** mô phỏng quy trình hoạt động của một trung tâm điều hành an ninh mạng (**Security Operations Center – SOC**) trên AWS. Hệ thống hỗ trợ phát hiện, điều tra và phản ứng sự cố theo hướng có kiểm soát, thay vì tự động cô lập mọi cảnh báo.

### 1.1. Thành viên & phân công

| Thành viên | Phân công chính |
| --- | --- |
| Trần Thái Nguyên | Tổng hợp yêu cầu, thiết kế kiến trúc tổng thể, viết báo cáo dự án, chuẩn hóa nội dung website Hugo |
| Dương Bá Đạt | Hỗ trợ nghiên cứu AWS services, kiểm tra luồng SOC, review sơ đồ kiến trúc, rà soát checklist trước khi nộp |

Nhóm thống nhất xây dựng dự án theo hướng **Lab / Proof of Concept** để có thể trình bày rõ ràng trước công ty, mentor và admin chương trình FCJ.

Mục tiêu chính:

- Thu thập log từ CloudTrail, VPC Flow Logs, CloudWatch và workload EC2.
- Phát hiện hành vi đáng ngờ bằng Amazon GuardDuty.
- Tổng hợp finding qua AWS Security Hub.
- Hỗ trợ điều tra quan hệ giữa finding, IP, EC2 và hành vi bằng Amazon Detective.
- Điều phối phản ứng bằng EventBridge và Step Functions.
- Có bước **Approval Gate** để SOC Analyst phê duyệt trước khi cô lập trong các trường hợp cần kiểm tra.
- Thu thập forensic và tạo EBS Snapshot trước khi cô lập.
- Cô lập EC2 bằng Security Group Isolation.
- Gửi cảnh báo qua SNS đến Slack/Email/SMS.

### 2. Bối cảnh & lý do chọn đề tài

Trong môi trường cloud, các sự cố bảo mật có thể đến từ nhiều nguồn: port scanning, brute-force SSH, truy cập từ IP đáng ngờ, hành vi API bất thường hoặc thay đổi cấu hình không mong muốn. Nếu chỉ xử lý thủ công, SOC Analyst có thể mất nhiều thời gian để xác định mức độ nguy hiểm, thu thập bằng chứng và containment.

Đề tài CloudSOC giúp nhóm liên hệ kiến thức **An ninh mạng** với AWS:

- **Detect:** GuardDuty phát hiện finding.
- **Investigate:** Security Hub và Detective hỗ trợ điều tra.
- **Decide:** Step Functions áp dụng chính sách xử lý có điều kiện.
- **Collect Evidence:** Systems Manager thu thập forensic.
- **Contain:** Lambda thay Security Group để cô lập EC2.
- **Notify:** SNS gửi alert/approval request.
- **Recover:** EBS Snapshot và dữ liệu trong S3 phục vụ phân tích sau sự cố.

### 3. Phạm vi Proof of Concept

Đây là mô hình **Lab / Proof of Concept**, không phải bản production hoàn chỉnh.

**Trong phạm vi:**

- Một AWS Region chính: `ap-southeast-1`.
- Một VPC lab với Public Subnet và EC2 workload thử nghiệm.
- Một Security Group bình thường (`SG-Workload`) và một Security Group cô lập (`SG-Isolation`).
- GuardDuty finding kích hoạt workflow qua EventBridge.
- Step Functions điều phối toàn bộ response flow.
- Systems Manager thu thập evidence trước khi containment.
- Incident Response Lambda thực hiện thay Security Group.
- Dashboard/API đọc incident và gửi approval callback.

**Ngoài phạm vi hiện tại:**

- Multi-account SOC.
- SIEM tập trung như OpenSearch/Splunk.
- Multi-AZ production architecture.
- ALB/WAF/Private Subnet production hardening.
- Automation restore hoàn chỉnh.

### 4. Dịch vụ AWS sử dụng

| Nhóm chức năng | Dịch vụ AWS | Vai trò |
| --- | --- | --- |
| Dashboard & Access | AWS Amplify | Host SOC Web Dashboard |
| Xác thực | Amazon Cognito | Đăng nhập, JWT token |
| API Backend | API Gateway + Lambda | Xử lý request từ dashboard |
| Incident Data | DynamoDB | Lưu incident metadata/trạng thái |
| Audit Logs | CloudTrail | Ghi hoạt động API/Console/CLI |
| Network Logs | VPC Flow Logs | Ghi metadata traffic |
| Evidence Storage | S3 | Lưu log, forensic, finding, kết quả xử lý |
| Detection | GuardDuty | Phát hiện hành vi đáng ngờ |
| Finding Aggregation | Security Hub | Tổng hợp finding |
| Investigation | Detective | Điều tra mối liên hệ giữa entity |
| Event Routing | EventBridge | Kích hoạt workflow |
| Orchestration | Step Functions | Điều phối phản ứng sự cố |
| Forensic | Systems Manager | Run Command/Automation |
| Containment | Lambda + Security Group | Cô lập EC2 |
| Notification | SNS, Amazon Q Developer, Slack/Email/SMS | Gửi alert, approval request và kết quả xử lý |
| Governance | IAM, Config, KMS | Least privilege, audit config, mã hóa |

### 5. Điểm nổi bật của kiến trúc

Điểm mạnh nhất của hệ thống là **phản ứng sự cố có kiểm soát**:

- Không cô lập tự động với mọi finding.
- Kiểm tra severity, Instance ID, tag `AutoIsolate=true`, chế độ Dry-run/Enforce.
- Finding mức Low/Medium chỉ alert.
- Finding High có thể yêu cầu SOC Analyst phê duyệt.
- Finding Critical có thể tự động tiếp tục tùy policy.
- Evidence luôn được thu thập trước khi cô lập.

Điều này giúp giảm rủi ro **false positive** và tránh ảnh hưởng nhầm đến workload hợp lệ.

### 6. Sản phẩm bàn giao

- Website báo cáo Hugo với đầy đủ mục Proposal, Worklog, Workshop, Self-evaluation và Feedback.
- Tài liệu workshop hướng dẫn vẽ sơ đồ AWS CloudSOC.
- Checklist review sơ đồ trước khi nộp.
- Bản mô tả kiến trúc Lab/PoC và hướng nâng cấp Production.
- Danh sách tài liệu tham khảo chính thức từ AWS/NIST.

### 7. Kết luận phần báo cáo

CloudSOC là một mô hình phù hợp để trình bày trong môi trường FCJ Bootcamp vì kết hợp nhiều nhóm kiến thức: IAM, VPC, EC2, logging, threat detection, incident response, serverless workflow và governance. Với chuyên ngành An ninh mạng, dự án giúp nhóm hiểu rõ hơn cách xây dựng một quy trình SOC trên cloud thay vì chỉ học lý thuyết detection/response.

