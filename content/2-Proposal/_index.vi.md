---
title: "Bản đề xuất"
date: 2026-07-19
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# Đề xuất dự án: AWS CloudSOC

## Thiết kế và triển khai hệ thống phát hiện, điều tra và phản ứng sự cố có kiểm soát trên AWS

### 1. Lời mở đầu

Kính gửi anh/chị admin, các mentor và quý đơn vị quan tâm,

Nhóm chúng em xin đề xuất dự án **“AWS CloudSOC – Thiết kế và triển khai hệ thống phát hiện, điều tra và phản ứng sự cố có kiểm soát trên AWS”**. Dự án được xây dựng nhằm mô phỏng quy trình vận hành của một trung tâm điều hành an ninh mạng (**Security Operations Center – SOC**) trên nền tảng AWS, tập trung vào ba năng lực cốt lõi: **phát hiện mối đe dọa**, **điều tra sự cố** và **phản ứng có kiểm soát**.

Trong bối cảnh các tổ chức ngày càng dịch chuyển workload lên cloud, rủi ro bảo mật không chỉ đến từ lỗ hổng ứng dụng mà còn đến từ cấu hình sai, quyền truy cập quá rộng, thiếu giám sát tập trung và phản ứng sự cố không có quy trình rõ ràng. AWS CloudSOC được đề xuất như một mô hình **Lab / Proof of Concept** để chứng minh cách kết hợp các dịch vụ AWS managed và serverless nhằm xây dựng một quy trình SOC có thể quan sát, kiểm soát và mở rộng.

### 2. Thông tin nhóm thực hiện

| Thành viên | Vai trò chính |
| --- | --- |
| Trần Thái Nguyên | Phân tích yêu cầu, thiết kế kiến trúc CloudSOC, tổng hợp báo cáo và xây dựng website Hugo |
| Dương Bá Đạt | Hỗ trợ nghiên cứu dịch vụ AWS, kiểm tra logic luồng SOC, review sơ đồ kiến trúc và checklist nộp |

**Bối cảnh thực hiện:** AWS Vietnam FCJ Workforce Bootcamp 2026  
**Chuyên ngành liên quan:** An ninh mạng  
**Mô hình triển khai:** Lab / Proof of Concept  
**AWS Region chính:** `ap-southeast-1`

### 3. Tóm tắt điều hành

AWS CloudSOC là một hệ thống mô phỏng quy trình SOC trên AWS, cho phép:

- Thu thập log từ nhiều nguồn cloud.
- Phát hiện hành vi đáng ngờ bằng Amazon GuardDuty.
- Tổng hợp và điều tra security findings qua AWS Security Hub và Amazon Detective.
- Điều phối phản ứng sự cố bằng Amazon EventBridge và AWS Step Functions.
- Yêu cầu phê duyệt thủ công khi cần, tránh tự động cô lập nhầm.
- Thu thập forensic bằng AWS Systems Manager trước khi containment.
- Tạo EBS Snapshot để bảo toàn trạng thái ổ đĩa.
- Cô lập EC2 bị ảnh hưởng bằng Security Group Isolation.
- Lưu bằng chứng, cập nhật dashboard và gửi cảnh báo đến SOC Analyst.

Điểm khác biệt của đề xuất này là hệ thống **không tự động cô lập mọi GuardDuty finding**. Quyết định phản ứng được kiểm soát bằng chính sách dựa trên loại tài nguyên, severity, tag `AutoIsolate=true`, chế độ `Dry-run/Enforce` và phê duyệt của SOC Analyst. Cách tiếp cận này phù hợp với nguyên tắc vận hành an toàn trong môi trường doanh nghiệp: tự động hóa nhưng vẫn có kiểm soát.

![Sơ đồ kiến trúc AWS CloudSOC](/images/2-Proposal/aws-cloudsoc-architecture.png)

*Hình 1. Sơ đồ kiến trúc tổng thể AWS CloudSOC – mô hình Lab / Proof of Concept cho quy trình phát hiện, điều tra, thu thập bằng chứng và cô lập EC2 có kiểm soát trên AWS.*

### 4. Vấn đề cần giải quyết

Trong môi trường AWS, một sự cố bảo mật có thể liên quan đến nhiều nguồn dữ liệu và nhiều dịch vụ khác nhau:

- CloudTrail ghi nhận hoạt động API/Console/CLI/SDK.
- VPC Flow Logs ghi metadata traffic mạng.
- GuardDuty tạo finding dựa trên threat intelligence và telemetry.
- Security Group thay đổi theo thời gian.
- EC2 có thể chứa dấu vết tiến trình, kết nối mạng và log hệ thống.
- IAM activity có thể liên quan đến quyền truy cập bất thường.

Nếu không có quy trình điều phối tập trung, SOC Analyst có thể gặp các khó khăn:

- Không biết finding nào cần ưu tiên xử lý.
- Không xác định được tài nguyên bị ảnh hưởng.
- Không thu thập kịp bằng chứng trước khi containment.
- Cô lập nhầm workload do false positive.
- Thiếu audit trail để giải thích sự cố sau khi xử lý.
- Không có cơ chế phê duyệt rõ ràng giữa tự động hóa và quyết định con người.

Vì vậy, dự án AWS CloudSOC được đề xuất nhằm tạo ra một quy trình phản ứng sự cố có kiểm soát, có thể quan sát và có khả năng mở rộng.

### 5. Mục tiêu dự án

#### Mục tiêu tổng quát

Thiết kế một mô hình CloudSOC trên AWS có khả năng mô phỏng đầy đủ chu trình:

```text
Detect → Investigate → Decide → Collect Evidence → Snapshot → Contain → Notify → Review
```

#### Mục tiêu cụ thể

- Xây dựng kiến trúc event-driven để phản ứng với GuardDuty findings.
- Thiết kế SOC Dashboard phục vụ SOC Analyst theo dõi incident.
- Thiết lập luồng log và evidence storage bằng CloudTrail, CloudWatch và S3.
- Sử dụng Security Hub và Detective để hỗ trợ tổng hợp/điều tra.
- Thiết kế Step Functions workflow có policy check và approval gate.
- Thu thập forensic bằng Systems Manager trước khi cô lập.
- Tạo EBS Snapshot để bảo toàn trạng thái ổ đĩa.
- Cô lập EC2 bằng cách thay `SG-Workload` bằng `SG-Isolation`.
- Gửi thông báo qua SNS, Amazon Q Developer, Slack và Email/SMS.
- Trình bày kiến trúc dưới dạng website Hugo và workshop hướng dẫn vẽ sơ đồ.

### 6. Phạm vi đề xuất

#### Trong phạm vi Proof of Concept

- Một AWS Region chính: `ap-southeast-1`.
- Một VPC lab có Public Subnet.
- Một Amazon EC2 làm workload thử nghiệm.
- Một Security Group bình thường (`SG-Workload`) và một Security Group cô lập (`SG-Isolation`).
- GuardDuty finding kích hoạt EventBridge và Step Functions.
- Systems Manager thu thập forensic.
- EBS Snapshot phục vụ điều tra.
- Lambda thực hiện cô lập EC2.
- DynamoDB lưu incident metadata.
- S3 lưu evidence, findings, Security Group trước/sau cô lập.
- CloudWatch lưu logs và alarm.
- IAM, Config, KMS hỗ trợ governance.

#### Ngoài phạm vi hiện tại

- Multi-account SOC.
- SIEM tập trung quy mô lớn.
- Production multi-AZ hoàn chỉnh.
- Tự động rollback/restore sau containment.
- Tích hợp ticketing system như Jira/ServiceNow.
- Incident response playbook đầy đủ cho nhiều loại tài nguyên ngoài EC2.

### 7. Kiến trúc tổng quan và công nghệ

| Nhóm chức năng | Dịch vụ AWS | Vai trò |
| --- | --- | --- |
| Frontend & Hosting | AWS Amplify Hosting | Cung cấp SOC Web Dashboard |
| Xác thực | Amazon Cognito | Đăng nhập và cấp JWT token |
| Backend API | Amazon API Gateway, AWS Lambda | Nhận request, đọc incident, gửi approval callback |
| Incident Data | Amazon DynamoDB | Lưu trạng thái incident và metadata |
| Log & Evidence | CloudTrail, CloudWatch, S3, EBS Snapshot | Lưu audit logs, forensic, snapshot |
| Threat Detection | Amazon GuardDuty | Phát hiện hành vi đáng ngờ |
| Aggregation & Investigation | AWS Security Hub, Amazon Detective | Tổng hợp finding và hỗ trợ điều tra |
| Response Orchestration | EventBridge, Step Functions | Điều phối quy trình phản ứng |
| Forensic Collection | AWS Systems Manager | Run Command/Automation trên EC2 |
| Containment | Incident Response Lambda, SG-Isolation | Cô lập EC2 bằng Security Group |
| Notification | SNS, Amazon Q Developer, Slack, Email/SMS | Alert, approval request, result notification |
| Governance | IAM, Config, KMS | Least privilege, configuration audit, encryption |

Kiến trúc không hoàn toàn serverless vì workload thử nghiệm vẫn chạy trên Amazon EC2. Tuy nhiên, dashboard, API, workflow, notification và phần lớn quy trình phản ứng sử dụng dịch vụ managed/serverless, giúp giảm vận hành thủ công và dễ mở rộng trong tương lai.

### 8. Luồng hoạt động chính

#### 8.1. Luồng truy cập SOC Dashboard

SOC Analyst truy cập dashboard qua HTTPS:

```text
SOC Analyst
→ AWS Amplify Hosting
→ Amazon Cognito
→ Amazon API Gateway
→ Dashboard API Lambda
```

Dashboard API Lambda có nhiệm vụ:

- Đọc danh sách incident từ DynamoDB.
- Đọc bằng chứng chi tiết từ S3.
- Ghi API logs vào CloudWatch.
- Gửi Approve/Reject về Step Functions thông qua Approval Callback.

#### 8.2. Luồng traffic thử nghiệm

Trong môi trường lab, nhóm đặt một Amazon EC2 trong Public Subnet để mô phỏng threat traffic:

```text
Threat Actor
→ Internet
→ Internet Gateway
→ Amazon EC2
```

Các tình huống thử nghiệm:

- Port scanning.
- SSH brute-force.
- Truy cập từ IP đáng ngờ.
- Hành vi mạng bất thường.

EC2 hoạt động bình thường với `SG-Workload`. Khi cần containment, Lambda thay thế Security Group này bằng `SG-Isolation`, security group không có inbound/outbound rules.

#### 8.3. Thu thập log và lưu bằng chứng

Hệ thống thu thập và lưu trữ:

- **CloudTrail → S3:** audit logs dài hạn.
- **CloudTrail → CloudWatch:** management events phục vụ giám sát nhanh.
- **VPC Flow Logs → CloudWatch:** metadata traffic mạng.
- **Systems Manager → S3:** forensic output.
- **Systems Manager → EBS Snapshot:** snapshot phục vụ điều tra.
- **Lambda/Step Functions → CloudWatch:** execution logs.

S3 evidence bucket có thể sử dụng SSE-KMS để mã hóa bằng khóa do AWS KMS quản lý.

#### 8.4. Phát hiện và điều tra mối đe dọa

Amazon GuardDuty phân tích:

- CloudTrail events.
- VPC Flow Logs.
- DNS logs.

Khi phát hiện bất thường, GuardDuty tạo finding và gửi theo ba hướng:

```text
GuardDuty
├──→ AWS Security Hub
├──→ Amazon Detective
└──→ Amazon EventBridge
```

Security Hub phục vụ tổng hợp findings. Detective hỗ trợ SOC Analyst điều tra mối liên hệ giữa finding, EC2, IP và hành vi. EventBridge kích hoạt workflow phản ứng nếu finding phù hợp event pattern.

#### 8.5. Điều phối phản ứng bằng Step Functions

Step Functions đóng vai trò trung tâm điều phối. Workflow kiểm tra:

- Finding có liên quan đến EC2 không?
- Có xác định được Instance ID không?
- Severity là Low, Medium, High hay Critical?
- EC2 có tag `AutoIsolate=true` không?
- Hệ thống đang ở chế độ Dry-run hay Enforce?
- Có cần SOC Analyst phê duyệt không?

Chính sách xử lý đề xuất:

| Điều kiện | Hành động |
| --- | --- |
| Finding không phải EC2 | Lưu incident và gửi cảnh báo |
| Không xác định được Instance ID | Chuyển sang `NEEDS_REVIEW` |
| Low hoặc Medium severity | Alert only, không cô lập |
| High + `AutoIsolate=true` | Yêu cầu SOC Analyst phê duyệt |
| Critical + `AutoIsolate=true` | Có thể tự động tiếp tục tùy policy |
| Thiếu tag `AutoIsolate=true` | Dry-run hoặc chờ xem xét |

#### 8.6. Luồng phê duyệt thủ công

Với incident cần kiểm tra trước khi containment:

```text
Step Functions
→ Amazon SNS
→ Amazon Q Developer / Slack / Email / SMS
→ SOC Analyst
→ SOC Dashboard
→ Dashboard API Lambda
→ Step Functions Callback
```

Step Functions có thể sử dụng callback task token để tạm dừng workflow cho đến khi nhận được quyết định Approve hoặc Reject.

#### 8.7. Thu thập forensic và tạo EBS Snapshot

Sau khi được phê duyệt hoặc đủ điều kiện xử lý, Step Functions gọi Systems Manager:

```text
Step Functions
→ AWS Systems Manager
→ Amazon EC2
→ Run Command / Automation
```

Thông tin forensic có thể gồm:

- Tiến trình đang chạy.
- Kết nối mạng hiện tại.
- Người dùng đang đăng nhập.
- System logs.
- IP address và routing table.
- Trạng thái Security Group trước khi cô lập.

Kết quả được lưu vào S3, sau đó Systems Manager tạo EBS Snapshot:

```text
Collect Evidence
→ Store Forensics
→ Create Snapshot
→ Apply Isolation
```

Không cô lập EC2 trước khi thu thập dữ liệu vì `SG-Isolation` không có outbound rule và có thể làm mất kết nối với Systems Manager.

#### 8.8. Cô lập EC2

Incident Response Lambda thực hiện:

- Đọc Instance ID từ workflow.
- Kiểm tra EC2 và tag.
- Lưu Security Group hiện tại.
- Thay `SG-Workload` bằng `SG-Isolation`.
- Lưu finding và kết quả xử lý vào S3.
- Cập nhật incident trong DynamoDB.
- Ghi execution logs vào CloudWatch.
- Gửi kết quả qua SNS.

Luồng chính:

```text
Incident Response Lambda
├──→ EC2: Replace Security Group
├──→ S3: Store Evidence
├──→ DynamoDB: Update Incident
├──→ CloudWatch: Execution Logs
└──→ SNS: Send Result
```

### 9. Giá trị đề xuất

#### Giá trị kỹ thuật

- Mô phỏng được quy trình SOC hiện đại trên AWS.
- Thể hiện cách kết hợp detection, investigation, orchestration và containment.
- Minh họa rõ nguyên tắc evidence-first trong incident response.
- Tận dụng dịch vụ managed/serverless để giảm vận hành thủ công.

#### Giá trị bảo mật

- Giảm rủi ro phản ứng tự động sai bằng approval gate.
- Lưu bằng chứng trước khi cô lập tài nguyên.
- Áp dụng least privilege cho IAM roles.
- Hỗ trợ audit bằng CloudTrail, CloudWatch và AWS Config.
- Có thể mở rộng thành playbook phản ứng cho các loại finding khác.

#### Giá trị học thuật và trình bày

- Phù hợp chuyên ngành An ninh mạng.
- Có kiến trúc rõ ràng, có sơ đồ, có checklist.
- Có thể trình bày trước mentor, công ty hoặc hội đồng đánh giá.
- Có định hướng nâng cấp production thay vì chỉ dừng ở lab.

### 10. Kế hoạch triển khai đề xuất

| Giai đoạn | Nội dung | Đầu ra |
| --- | --- | --- |
| Phase 1 | Phân tích yêu cầu SOC và threat scenario | Use case, scope, response policy |
| Phase 2 | Thiết kế kiến trúc CloudSOC | Architecture diagram, service mapping |
| Phase 3 | Xây dựng dashboard/API và incident data model | Amplify, Cognito, API Gateway, Lambda, DynamoDB |
| Phase 4 | Thiết lập logging/evidence storage | CloudTrail, CloudWatch, S3, KMS |
| Phase 5 | Thiết kế detection và orchestration | GuardDuty, Security Hub, Detective, EventBridge, Step Functions |
| Phase 6 | Xây dựng forensic và containment flow | Systems Manager, EBS Snapshot, Lambda SG-Isolation |
| Phase 7 | Kiểm thử và review | Test cases, evidence, checklist |
| Phase 8 | Hoàn thiện báo cáo và workshop | Website Hugo, Proposal, Workshop, Drawing Guide |

### 11. Rủi ro và biện pháp kiểm soát

| Rủi ro | Ảnh hưởng | Biện pháp kiểm soát |
| --- | --- | --- |
| GuardDuty finding false positive | Cô lập nhầm tài nguyên | Dùng severity, tag `AutoIsolate`, approval gate |
| Không thu thập được forensic | Thiếu bằng chứng điều tra | Thu thập evidence trước isolation, kiểm tra SSM Agent/Role |
| Lambda thiếu quyền | Workflow thất bại | IAM least privilege nhưng đủ quyền cần thiết |
| S3 evidence chứa dữ liệu nhạy cảm | Rủi ro rò rỉ dữ liệu | SSE-KMS, bucket policy, block public access |
| EC2 public subnet không phù hợp production | Attack surface lớn | Ghi rõ Lab/PoC, đề xuất Private Subnet khi production |
| Chi phí phát sinh | Ảnh hưởng tài khoản lab | Cleanup checklist, lifecycle policy |

### 12. Khả năng mở rộng production

Trong phiên bản production, nhóm đề xuất:

- Chuyển workload vào Private Subnet.
- Thêm Application Load Balancer và AWS WAF.
- Triển khai Multi-AZ.
- Tách môi trường Lab/Staging/Production.
- Bổ sung rollback Security Group có phê duyệt.
- Thiết lập lifecycle cho S3 evidence và EBS Snapshots.
- Dùng AWS CDK/Terraform/CloudFormation để triển khai nhất quán.
- Tích hợp ticketing system và SIEM nếu mở rộng đa tài khoản.

### 13. Sản phẩm bàn giao

- Website báo cáo Hugo song ngữ.
- Proposal học thuật và thuyết phục cho dự án AWS CloudSOC.
- Báo cáo chi tiết kiến trúc và luồng xử lý SOC.
- Workshop hướng dẫn vẽ sơ đồ kiến trúc.
- Sơ đồ AWS CloudSOC minh họa trực tiếp trên website.
- Checklist review trước khi nộp.
- Định hướng nâng cấp production và cleanup lab.

### 14. Tiêu chí nghiệm thu

Dự án được xem là đạt yêu cầu nếu:

- Kiến trúc thể hiện đầy đủ các vùng: Dashboard, Logging, Detection/Response, Governance và VPC Workload.
- Luồng xử lý đúng thứ tự: Detect → Investigate → Decide → Collect Evidence → Snapshot → Contain → Notify.
- Có giải thích rõ vì sao cần approval gate.
- Có giải thích rõ vì sao cần forensic trước isolation.
- Có bảng policy xử lý GuardDuty findings.
- Có phân biệt rõ Lab/PoC và Production roadmap.
- Có tài liệu đủ rõ để người khác đọc và vẽ lại sơ đồ.

### 15. Đề xuất chấp thuận

Nhóm đề xuất anh/chị admin, mentor và đơn vị đánh giá chấp thuận dự án AWS CloudSOC như một đề tài phù hợp để trình bày trong chương trình FCAJ. Dự án có tính thực tiễn cao, bám sát chuyên ngành An ninh mạng, khai thác nhiều dịch vụ AWS quan trọng và thể hiện tư duy thiết kế hệ thống bảo mật theo hướng có kiểm soát.

Tóm lại, AWS CloudSOC không chỉ là một bài lab về từng dịch vụ riêng lẻ mà là một mô hình tích hợp, mô phỏng quy trình SOC hoàn chỉnh trên AWS:

```text
Thu thập log
→ Phát hiện mối đe dọa
→ Tổng hợp finding
→ Điều tra bằng Detective
→ Phân loại bằng Step Functions
→ Yêu cầu phê duyệt khi cần
→ Thu thập forensic
→ Tạo EBS Snapshot
→ Cô lập EC2
→ Lưu bằng chứng
→ Cập nhật Dashboard
→ Gửi cảnh báo
```

Nhóm rất mong nhận được câu hỏi phản biện và góp ý từ anh/chị admin, mentor và mọi người để tiếp tục hoàn thiện kiến trúc, quy trình phản ứng sự cố và khả năng mở rộng của dự án.

