---
title : "Kiến trúc và luồng hoạt động"
date : 2024-01-01
weight : 3
chapter : false
pre : " <b> 5.3. </b> "
---

#### Kiến trúc và luồng hoạt động

Phần này trình bày kiến trúc tổng quan và luồng hoạt động chính của hệ thống **AWS CloudSOC**. Kiến trúc được xây dựng nhằm mô phỏng một hệ thống SOC trên AWS có khả năng phát hiện mối đe dọa, điều phối phản ứng sự cố, thu thập bằng chứng, cô lập tài nguyên bị ảnh hưởng và gửi cảnh báo đến SOC Analyst.

Hệ thống được thiết kế theo mô hình **event-driven** và **serverless**, trong đó các security finding từ Amazon GuardDuty sẽ kích hoạt workflow phản ứng sự cố thông qua Amazon EventBridge và AWS Step Functions.

---

#### Kiến trúc tổng quan

Sơ đồ dưới đây mô tả kiến trúc tổng quan của hệ thống AWS CloudSOC.

![AWS CloudSOC Architecture](/images/5-Workshop/5.3-Architecture-and-Workflow/cloudsoc-architecture.png)

Kiến trúc được chia thành các nhóm chính:

+ **Network and Workload**
+ **Logging and Evidence Storage**
+ **Threat Detection and Response**
+ **SOC Dashboard and Access**
+ **Security, Governance, and Notification**

Mỗi nhóm đảm nhận một vai trò riêng trong toàn bộ quá trình phát hiện, điều tra và phản ứng sự cố.

---

#### Nhóm Network and Workload

Nhóm Network and Workload là nơi triển khai tài nguyên mục tiêu để kiểm thử bảo mật.

Các thành phần chính gồm:

+ Amazon VPC
+ Public Subnet
+ Internet Gateway
+ Amazon EC2
+ SG-Workload
+ SG-Isolation

Trong workshop này, một Amazon EC2 instance được triển khai trong Public Subnet để đơn giản hóa quá trình mô phỏng tấn công và kiểm thử GuardDuty finding.

EC2 instance ban đầu được gán security group tên là `SG-Workload`. Đây là security group dùng cho workload bình thường. Khi hệ thống xác định EC2 cần được cô lập, AWS Lambda sẽ thay thế `SG-Workload` bằng `SG-Isolation`.

`SG-Isolation` là security group được tạo sẵn trong VPC và không cho phép inbound hoặc outbound traffic. Cách này giúp cô lập EC2 instance bị ảnh hưởng khỏi các kết nối mạng mới.

> **Lưu ý:** Security Group trên AWS là stateful. Việc cô lập bằng security group chủ yếu nhằm chặn các kết nối mới và giảm phạm vi ảnh hưởng của sự cố.

---

#### Nhóm Logging and Evidence Storage

Nhóm Logging and Evidence Storage chịu trách nhiệm ghi log, lưu bằng chứng và hỗ trợ quá trình điều tra sau sự cố.

Các thành phần chính gồm:

+ AWS CloudTrail
+ Amazon CloudWatch
+ VPC Flow Logs
+ Amazon S3
+ Amazon EBS Snapshot
+ AWS KMS

Luồng logging và evidence trong hệ thống:

```text
CloudTrail → S3
CloudTrail → CloudWatch
VPC Flow Logs → CloudWatch
Systems Manager → S3
Systems Manager → EBS Snapshot
Incident Response Lambda → S3
Incident Response Lambda → CloudWatch
KMS → S3
```

Vai trò của từng thành phần:

+ **AWS CloudTrail** ghi lại các management events trong AWS account.
+ **Amazon CloudWatch** lưu trữ logs, metrics và alarms.
+ **VPC Flow Logs** ghi lại metadata của network traffic trong VPC.
+ **Amazon S3** lưu trữ audit logs, forensic output và incident evidence.
+ **Amazon EBS Snapshot** bảo toàn dữ liệu ổ đĩa của EC2 để phục vụ điều tra.
+ **AWS KMS** hỗ trợ mã hóa dữ liệu lưu trữ trong S3 nếu được cấu hình.

---

#### Nhóm Threat Detection and Response

Nhóm Threat Detection and Response là phần lõi của hệ thống AWS CloudSOC.

Các thành phần chính gồm:

+ Amazon GuardDuty
+ AWS Security Hub
+ Amazon Detective
+ Amazon EventBridge
+ AWS Step Functions
+ AWS Systems Manager
+ AWS Lambda

Luồng phát hiện và phản ứng sự cố:

```text
GuardDuty
→ EventBridge
→ Step Functions
→ Systems Manager / Lambda
→ Evidence Storage / Isolation / Notification
```

Khi GuardDuty phát hiện hoạt động đáng ngờ, dịch vụ này tạo ra một security finding. Finding được gửi đến EventBridge để kích hoạt Step Functions workflow.

Step Functions sẽ điều phối toàn bộ quá trình phản ứng sự cố, bao gồm:

+ Kiểm tra loại tài nguyên bị ảnh hưởng
+ Kiểm tra Instance ID
+ Kiểm tra mức độ nghiêm trọng
+ Kiểm tra tag `AutoIsolate=true`
+ Xác định chế độ phản ứng
+ Gửi yêu cầu phê duyệt nếu cần
+ Thu thập bằng chứng forensic
+ Tạo EBS Snapshot
+ Cô lập EC2 instance
+ Gửi thông báo kết quả

Amazon Detective và AWS Security Hub hỗ trợ SOC Analyst trong quá trình phân tích và điều tra finding.

---

#### Nhóm SOC Dashboard and Access

Nhóm SOC Dashboard and Access cung cấp giao diện cho SOC Analyst theo dõi incident và phê duyệt hành động phản ứng.

Các thành phần chính gồm:

+ AWS Amplify Hosting
+ Amazon Cognito
+ Amazon API Gateway
+ Dashboard API Lambda
+ Amazon DynamoDB
+ Amazon S3
+ AWS Step Functions

Luồng dashboard:

```text
SOC Analyst
→ AWS Amplify Hosting
→ Amazon Cognito
→ Amazon API Gateway
→ Dashboard API Lambda
→ Amazon DynamoDB / Amazon S3
→ AWS Step Functions Approval Callback
```

Vai trò của từng thành phần:

+ **AWS Amplify Hosting** host giao diện SOC Dashboard.
+ **Amazon Cognito** xác thực SOC Analyst trước khi truy cập dashboard.
+ **Amazon API Gateway** cung cấp HTTPS API cho dashboard.
+ **Dashboard API Lambda** xử lý các request từ dashboard.
+ **Amazon DynamoDB** lưu thông tin incident và trạng thái xử lý.
+ **Amazon S3** lưu evidence và forensic output.
+ **AWS Step Functions** nhận approval callback từ dashboard.

SOC Dashboard không truy cập trực tiếp vào DynamoDB hoặc S3. Mọi thao tác đọc incident, xem evidence hoặc gửi phê duyệt đều đi qua API Gateway và Lambda.

---

#### Nhóm Security, Governance, and Notification

Nhóm này chịu trách nhiệm quản lý quyền truy cập, theo dõi cấu hình và gửi cảnh báo.

Các thành phần chính gồm:

+ AWS IAM
+ AWS Config
+ AWS KMS
+ Amazon SNS
+ Amazon Q Developer
+ Slack
+ Email / SMS

Vai trò của từng thành phần:

+ **AWS IAM** quản lý quyền truy cập và execution roles cho các dịch vụ.
+ **AWS Config** theo dõi thay đổi cấu hình của EC2, Security Group và các tài nguyên liên quan.
+ **AWS KMS** hỗ trợ mã hóa dữ liệu nhạy cảm.
+ **Amazon SNS** gửi cảnh báo và kết quả xử lý incident.
+ **Amazon Q Developer** có thể được dùng để chuyển tiếp thông báo đến Slack.
+ **Email / SMS** giúp SOC Analyst nhận cảnh báo nhanh chóng.

Các IAM role chính trong hệ thống gồm:

+ Dashboard Lambda Role
+ Incident Response Lambda Role
+ Step Functions Workflow Role
+ EC2 SSM Instance Role

Các role này đảm bảo mỗi dịch vụ chỉ có quyền cần thiết để thực hiện đúng chức năng của mình.

---

#### Luồng hoạt động chính

Sơ đồ sau minh họa luồng hoạt động chính của hệ thống AWS CloudSOC.

![AWS CloudSOC Main Workflow](/images/5-Workshop/5.3-Architecture-and-Workflow/cloudsoc-main-workflow.png)

Luồng hoạt động chính gồm các bước:

```text
1. Threat activity occurs on EC2
2. GuardDuty detects suspicious behavior
3. GuardDuty generates a finding
4. EventBridge receives the finding
5. EventBridge starts Step Functions workflow
6. Step Functions evaluates the finding
7. Step Functions requests approval or starts response
8. Systems Manager collects forensic evidence
9. EBS Snapshot is created
10. Lambda replaces EC2 security group with SG-Isolation
11. Incident status is updated in DynamoDB
12. Evidence is stored in S3
13. SNS sends notification to SOC Analyst
```

---

#### Chi tiết luồng xử lý

##### Bước 1: Phát sinh hoạt động đáng ngờ

Một hoạt động đáng ngờ xảy ra trên EC2 instance, ví dụ:

+ Port scanning
+ SSH brute-force
+ Suspicious IP communication
+ Abnormal API activity

EC2 instance trong workshop được sử dụng làm workload mục tiêu để mô phỏng các tình huống bảo mật này.

---

##### Bước 2: GuardDuty phát hiện mối đe dọa

Amazon GuardDuty phân tích các nguồn telemetry do AWS quản lý như:

+ CloudTrail management events
+ VPC Flow Logs
+ DNS logs

Khi phát hiện hành vi bất thường, GuardDuty tạo security finding.

---

##### Bước 3: EventBridge kích hoạt workflow

Finding từ GuardDuty được gửi đến Amazon EventBridge. EventBridge sử dụng rule đã cấu hình để lọc các finding phù hợp và kích hoạt AWS Step Functions.

```text
GuardDuty Finding → EventBridge Rule → Step Functions
```

---

##### Bước 4: Step Functions đánh giá finding

AWS Step Functions kiểm tra các thông tin quan trọng trong finding:

+ Resource Type
+ Instance ID
+ Severity
+ AutoIsolate Tag
+ Response Mode

Dựa trên kết quả đánh giá, workflow sẽ chọn một trong các nhánh xử lý:

```text
Alert Only
Approval Required
Auto Response
```

---

##### Bước 5: Xử lý theo chính sách phản ứng

Chính sách phản ứng của hệ thống:

```text
Non-EC2 Finding        → Alert Only
Low / Medium Severity  → Dry Run
High Severity          → Request Approval
Critical Severity      → Auto Response
Reject / Timeout       → End Workflow
```

Với finding mức High, hệ thống yêu cầu SOC Analyst phê duyệt trước khi cô lập EC2.

Với finding mức Critical và có tag `AutoIsolate=true`, hệ thống có thể tự động thực hiện phản ứng.

---

##### Bước 6: Thu thập bằng chứng forensic

AWS Systems Manager được sử dụng để chạy command trên EC2 instance nhằm thu thập thông tin phục vụ điều tra.

Thông tin forensic có thể bao gồm:

+ Running processes
+ Network connections
+ Logged-in users
+ System logs
+ Security logs
+ Instance metadata

Kết quả thu thập được lưu vào Amazon S3.

---

##### Bước 7: Tạo EBS Snapshot

Trước khi cô lập hoặc xử lý sâu hơn, hệ thống tạo Amazon EBS Snapshot để bảo toàn trạng thái ổ đĩa của EC2 instance.

Snapshot này có thể được sử dụng cho:

+ Điều tra forensic
+ Khôi phục dữ liệu
+ Phân tích sau sự cố
+ Lưu trữ bằng chứng

---

##### Bước 8: Cô lập EC2 instance

AWS Lambda thực hiện hành động cô lập bằng cách thay thế security group hiện tại của EC2.

```text
SG-Workload → SG-Isolation
```

`SG-Isolation` không cho phép inbound hoặc outbound traffic, giúp hạn chế khả năng EC2 tiếp tục giao tiếp với các hệ thống khác.

---

##### Bước 9: Cập nhật incident record

Sau khi thực hiện hành động phản ứng, Lambda cập nhật trạng thái incident vào Amazon DynamoDB.

Các thông tin có thể được lưu gồm:

+ Incident ID
+ Finding ID
+ Instance ID
+ Severity
+ Response action
+ Approval status
+ Isolation status
+ Snapshot ID
+ Evidence S3 path
+ Timestamp

---

##### Bước 10: Gửi thông báo

Amazon SNS gửi thông báo đến SOC Analyst sau khi workflow hoàn tất hoặc khi cần phê duyệt.

Thông báo có thể được gửi qua:

+ Email
+ SMS
+ Slack thông qua Amazon Q Developer

Nội dung thông báo gồm thông tin incident, mức độ nghiêm trọng, tài nguyên bị ảnh hưởng và kết quả xử lý.

---

#### Luồng phê duyệt của SOC Analyst

Đối với finding mức High, hệ thống không tự động cô lập EC2 ngay lập tức. Thay vào đó, SOC Analyst sẽ xem xét thông tin incident trên dashboard.

Luồng phê duyệt:

```text
SOC Analyst
→ SOC Dashboard
→ Review Incident
→ Approve / Reject
→ Step Functions Callback
→ Continue or End Workflow
```

Nếu SOC Analyst phê duyệt, workflow tiếp tục thu thập bằng chứng, tạo snapshot và cô lập EC2.

Nếu SOC Analyst từ chối hoặc quá thời gian chờ, workflow kết thúc và chỉ ghi nhận trạng thái incident.

---

#### Tóm tắt luồng kiến trúc

Bảng sau tóm tắt vai trò của từng nhóm trong kiến trúc AWS CloudSOC.

| Nhóm | Chức năng |
|------|-----------|
| Network and Workload | Triển khai EC2 mục tiêu và security group phục vụ cô lập |
| Logging and Evidence Storage | Ghi log, lưu evidence và tạo snapshot phục vụ điều tra |
| Threat Detection and Response | Phát hiện finding và điều phối phản ứng sự cố |
| SOC Dashboard and Access | Cung cấp giao diện theo dõi incident và phê duyệt |
| Security, Governance, and Notification | Quản lý quyền, theo dõi cấu hình và gửi cảnh báo |

Kiến trúc này giúp mô phỏng một quy trình SOC cơ bản trên AWS, trong đó các bước phát hiện, điều tra, phản ứng và cảnh báo được tự động hóa theo hướng có kiểm soát.