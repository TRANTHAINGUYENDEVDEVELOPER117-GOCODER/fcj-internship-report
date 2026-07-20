---
title : "Triển khai hệ thống CloudSOC"
date : 2024-01-01
weight : 4
chapter : false
pre : " <b> 5.4. </b> "
---

#### Triển khai hệ thống CloudSOC

Trong phần này, chúng ta sẽ triển khai toàn bộ hệ thống **AWS CloudSOC** theo kiến trúc đã thiết kế ở phần trước. Đây là phần triển khai chính của workshop, nơi các thành phần bảo mật, giám sát, điều phối phản ứng sự cố, lưu trữ bằng chứng, dashboard phê duyệt và cảnh báo được cấu hình thành một hệ thống hoàn chỉnh.

Mục tiêu của phần 5.4 là xây dựng một mô hình **Security Operations Center trên AWS** có khả năng phát hiện mối đe dọa, điều tra sự cố, phản ứng tự động, lưu lại bằng chứng và gửi cảnh báo đến SOC Analyst.

Quy trình tổng thể của hệ thống:

```text
Detect → Investigate → Respond → Store Evidence → Notify
```

Hệ thống được triển khai theo mô hình **serverless** và **event-driven**, sử dụng các dịch vụ chính như Amazon GuardDuty, AWS Security Hub, Amazon EventBridge, AWS Step Functions, AWS Lambda, AWS Systems Manager, Amazon S3, Amazon DynamoDB, Amazon SNS và Amazon CloudWatch.

---

#### Mục tiêu triển khai

Sau khi hoàn thành phần này, hệ thống CloudSOC sẽ có khả năng:

+ Tạo môi trường mạng cơ bản cho workload EC2.
+ Ghi nhận log và lưu trữ evidence phục vụ điều tra.
+ Bật các dịch vụ phát hiện mối đe dọa như GuardDuty, Security Hub, Detective và AWS Config.
+ Sử dụng EventBridge để nhận security finding.
+ Sử dụng Step Functions để điều phối workflow phản ứng sự cố.
+ Xây dựng dashboard cho SOC Analyst xem incident và phê duyệt hành động.
+ Tự động thu thập forensic evidence.
+ Tạo EBS Snapshot phục vụ điều tra sau sự cố.
+ Cô lập EC2 bị nghi ngờ bằng `SG-Isolation`.
+ Gửi cảnh báo qua SNS, Email và Slack optional.

---

#### Tổng quan triển khai

Sơ đồ dưới đây mô tả tổng quan các bước triển khai hệ thống CloudSOC.

![CloudSOC Deployment Flow](/images/5-Workshop/5.4-Deploy-cloudsoc-system/deployment-flow.png)

Luồng triển khai tổng thể:

```text
Network and EC2
→ Logging and Evidence Storage
→ Threat Detection Services
→ EventBridge and Step Functions
→ Dashboard and Approval Flow
→ Forensics, Snapshot and Isolation
→ Notification and Alerting
```

Mỗi phần trong 5.4 sẽ triển khai một nhóm thành phần riêng. Khi kết hợp lại, các thành phần này tạo thành một quy trình SOC hoàn chỉnh trên AWS.

---

#### Các phần triển khai trong 5.4

Phần 5.4 được chia thành 7 phần con. Bạn nên triển khai theo đúng thứ tự bên dưới để đảm bảo các dịch vụ được kết nối đúng luồng.

| Phần | Nội dung | Vai trò trong hệ thống |
|---|---|---|
| [5.4.1 Network and EC2 Workload](./5.4.1-network-and-ec2/) | Tạo VPC, subnet, EC2, IAM Role và Security Groups | Chuẩn bị workload để giám sát và cô lập |
| [5.4.2 Logging and Evidence Storage](./5.4.2-logging-and-evidence-storage/) | Tạo S3 bucket, CloudTrail và VPC Flow Logs | Lưu log và evidence phục vụ điều tra |
| [5.4.3 Threat Detection Services](./5.4.3-threat-detection-services/) | Bật GuardDuty, Security Hub, Detective và AWS Config | Phát hiện và điều tra mối đe dọa |
| [5.4.4 EventBridge and Step Functions](./5.4.4-eventbridge-and-step-functions/) | Tạo EventBridge Rule và Step Functions workflow | Điều phối luồng phản ứng sự cố |
| [5.4.5 Dashboard and Approval Flow](./5.4.5-dashboard-and-approval-flow/) | Tạo DynamoDB, Cognito, API Gateway, Lambda và Amplify Dashboard | Cho phép SOC Analyst xem và phê duyệt incident |
| [5.4.6 Forensics, Snapshot and Isolation](./5.4.6-forensics-snapshot-and-isolation/) | Tạo Incident Response Lambda, SSM, EBS Snapshot và SG-Isolation | Thu thập bằng chứng, tạo snapshot và cô lập EC2 |
| [5.4.7 Notification and Alerting](./5.4.7-notification-and-alerting/) | Tạo SNS, Email alert, CloudWatch Alarm và Slack optional | Gửi cảnh báo cho SOC Analyst |

---

#### Quick Navigation

- [5.4.1 Network and EC2 Workload](./5.4.1-network-and-ec2/)
- [5.4.2 Logging and Evidence Storage](./5.4.2-logging-and-evidence-storage/)
- [5.4.3 Threat Detection Services](./5.4.3-threat-detection-services/)
- [5.4.4 EventBridge and Step Functions](./5.4.4-eventbridge-and-step-functions/)
- [5.4.5 Dashboard and Approval Flow](./5.4.5-dashboard-and-approval-flow/)
- [5.4.6 Forensics, Snapshot and Isolation](./5.4.6-forensics-snapshot-and-isolation/)
- [5.4.7 Notification and Alerting](./5.4.7-notification-and-alerting/)

---

#### Thứ tự triển khai khuyến nghị

```text
5.4.1 Network and EC2 Workload
        ↓
5.4.2 Logging and Evidence Storage
        ↓
5.4.3 Threat Detection Services
        ↓
5.4.4 EventBridge and Step Functions
        ↓
5.4.5 Dashboard and Approval Flow
        ↓
5.4.6 Forensics, Snapshot and Isolation
        ↓
5.4.7 Notification and Alerting
```

Thứ tự này giúp hệ thống được triển khai theo đúng luồng:

```text
Infrastructure → Logging → Detection → Workflow → Dashboard → Response → Notification
```

---

#### Kiến trúc triển khai trong phần này

Hệ thống CloudSOC được chia thành nhiều lớp chức năng. Mỗi lớp đảm nhiệm một vai trò riêng trong quy trình phát hiện và phản ứng sự cố.

| Nhóm chức năng | Dịch vụ sử dụng | Vai trò |
|---|---|---|
| Network Layer | VPC, Subnet, Internet Gateway, Route Table, EC2, Security Group | Tạo môi trường workload để giám sát |
| Logging Layer | CloudTrail, VPC Flow Logs, CloudWatch Logs, S3 | Ghi nhận log và lưu bằng chứng |
| Detection Layer | GuardDuty, Security Hub, Detective, AWS Config | Phát hiện, tổng hợp và điều tra finding |
| Workflow Layer | EventBridge, Step Functions | Điều phối phản ứng sự cố |
| Dashboard Layer | Cognito, API Gateway, Lambda, DynamoDB, Amplify | Cho phép SOC Analyst xem và phê duyệt incident |
| Response Layer | Lambda, Systems Manager, EBS Snapshot, Security Group | Thu thập evidence, tạo snapshot và cô lập EC2 |
| Notification Layer | SNS, Email, CloudWatch Alarm, Slack optional | Gửi cảnh báo đến SOC Analyst |

---

#### 5.4.1 Network and EC2 Workload

Trong phần này, chúng ta tạo nền tảng mạng cho lab CloudSOC.

Các thành phần được triển khai gồm:

+ VPC `cloudsoc-vpc`.
+ Public subnet `cloudsoc-public-subnet`.
+ Internet Gateway.
+ Public Route Table.
+ EC2 instance `cloudsoc-workload-ec2`.
+ IAM Role cho EC2 sử dụng Systems Manager.
+ Security Group bình thường `SG-Workload`.
+ Security Group cô lập `SG-Isolation`.

Mục tiêu chính là tạo một EC2 workload có thể được quản lý bằng Systems Manager và có thể bị cô lập bằng cách thay Security Group khi xảy ra incident.

Luồng cơ bản:

```text
Internet
→ Internet Gateway
→ Public Subnet
→ EC2 Workload
```

EC2 workload được gắn tag:

```text
AutoIsolate = true
```

Tag này giúp Incident Response Lambda xác định EC2 có được phép cô lập tự động hay không.

Kết quả mong đợi sau phần 5.4.1:

```text
EC2 workload đang chạy với SG-Workload, có IAM Role cho SSM và có SG-Isolation sẵn sàng để cô lập.
```

---

#### 5.4.2 Logging and Evidence Storage

Trong phần này, chúng ta tạo lớp lưu trữ log và evidence.

Các thành phần chính gồm:

+ S3 bucket lưu CloudTrail audit logs.
+ S3 bucket lưu incident evidence.
+ CloudTrail ghi nhận management events.
+ VPC Flow Logs ghi network traffic metadata vào CloudWatch Logs.
+ Cấu trúc thư mục evidence phục vụ forensic investigation.

Mục tiêu là đảm bảo mọi sự kiện quan trọng và bằng chứng phản ứng sự cố đều được lưu trữ để điều tra sau này.

Luồng logging chính:

```text
CloudTrail → S3 Audit Logs
VPC Flow Logs → CloudWatch Logs
Incident Response Lambda → S3 Evidence Bucket
Systems Manager → S3 Evidence Bucket
```

Kết quả mong đợi sau phần 5.4.2:

```text
CloudTrail, VPC Flow Logs và S3 Evidence Bucket đã sẵn sàng để lưu log và bằng chứng.
```

---

#### 5.4.3 Threat Detection Services

Trong phần này, chúng ta bật các dịch vụ phát hiện và điều tra mối đe dọa.

Các dịch vụ gồm:

+ Amazon GuardDuty.
+ AWS Security Hub.
+ Amazon Detective.
+ AWS Config.

GuardDuty đóng vai trò phát hiện hành vi bất thường. Security Hub tổng hợp finding. Detective hỗ trợ điều tra mối quan hệ giữa tài nguyên, còn AWS Config theo dõi thay đổi cấu hình tài nguyên.

Luồng detection chính:

```text
CloudTrail / VPC Flow Logs / DNS Logs
→ GuardDuty
→ Security Hub
→ EventBridge
```

Ngoài ra, Detective hỗ trợ điều tra incident sau khi có finding:

```text
GuardDuty Finding
→ Amazon Detective
→ Investigation
```

Kết quả mong đợi sau phần 5.4.3:

```text
GuardDuty, Security Hub, Detective và AWS Config đã được bật để phục vụ phát hiện và điều tra mối đe dọa.
```

---

#### 5.4.4 EventBridge and Step Functions

Trong phần này, chúng ta triển khai lớp điều phối phản ứng sự cố.

Các thành phần chính gồm:

+ EventBridge Rule nhận GuardDuty Finding.
+ Step Functions State Machine điều phối workflow.
+ Nhánh `Alert Only`.
+ Nhánh `Approval Required`.
+ Nhánh `Auto Response`.

Workflow giúp hệ thống quyết định cách phản ứng tùy theo severity, resource type và chính sách xử lý.

Luồng xử lý chính:

```text
GuardDuty Finding
→ EventBridge Rule
→ Step Functions
→ Evaluate Finding
→ Alert Only / Approval Required / Auto Response
```

Các nhánh xử lý:

| Nhánh | Điều kiện | Hành động |
|---|---|---|
| Alert Only | Finding có mức độ thấp hoặc không đủ điều kiện xử lý | Gửi cảnh báo, không cô lập EC2 |
| Approval Required | Finding có mức độ cao nhưng cần SOC Analyst phê duyệt | Tạo incident chờ phê duyệt |
| Auto Response | Finding nghiêm trọng và EC2 có tag `AutoIsolate=true` | Tự động phản ứng và cô lập EC2 |

Kết quả mong đợi sau phần 5.4.4:

```text
GuardDuty finding có thể kích hoạt Step Functions workflow thông qua EventBridge.
```

---

#### 5.4.5 Dashboard and Approval Flow

Trong phần này, chúng ta triển khai dashboard cho SOC Analyst.

Các thành phần gồm:

+ DynamoDB Incident Table.
+ Cognito User Pool.
+ Dashboard API Lambda.
+ API Gateway.
+ Amplify Hosting.
+ Dashboard giao diện web.
+ Approval action: Approve hoặc Reject.

Dashboard giúp SOC Analyst xem incident, kiểm tra thông tin finding và phê duyệt hành động phản ứng khi cần.

Luồng dashboard:

```text
SOC Analyst
→ Amplify Dashboard
→ Cognito Authentication
→ API Gateway
→ Dashboard API Lambda
→ DynamoDB Incident Table
```

Luồng approval:

```text
SOC Analyst
→ Approve / Reject
→ API Gateway
→ Dashboard API Lambda
→ DynamoDB Incident Table
```

Kết quả mong đợi sau phần 5.4.5:

```text
SOC Analyst có thể xem incident trên dashboard và thay đổi approval status từ Pending sang Approved hoặc Rejected.
```

---

#### 5.4.6 Forensics, Snapshot and Isolation

Trong phần này, chúng ta triển khai hành động phản ứng sự cố thật.

Các thành phần gồm:

+ Incident Response Lambda.
+ Systems Manager Run Command.
+ S3 Evidence Bucket.
+ EBS Forensic Snapshot.
+ Security Group Isolation.
+ DynamoDB incident update.

Khi Lambda được kích hoạt, hệ thống sẽ:

```text
Collect Evidence
→ Create EBS Snapshot
→ Store Evidence in S3
→ Replace SG-Workload with SG-Isolation
→ Update DynamoDB Incident Status
```

Incident Response Lambda thực hiện các hành động chính:

| Hành động | Mục đích |
|---|---|
| Đọc GuardDuty event | Xác định finding và EC2 bị ảnh hưởng |
| Kiểm tra tag `AutoIsolate=true` | Đảm bảo chỉ cô lập workload được phép |
| Chạy SSM Run Command | Thu thập thông tin forensic cơ bản |
| Tạo EBS Snapshot | Lưu trạng thái volume phục vụ điều tra |
| Ghi evidence vào S3 | Lưu event và response summary |
| Thay Security Group | Cô lập EC2 bằng `SG-Isolation` |
| Cập nhật DynamoDB | Ghi nhận trạng thái incident |

Kết quả mong đợi sau phần 5.4.6:

```text
Lambda có thể thu thập evidence, tạo snapshot, ghi dữ liệu vào S3/DynamoDB và đổi EC2 sang SG-Isolation.
```

---

#### 5.4.7 Notification and Alerting

Trong phần này, chúng ta triển khai lớp cảnh báo.

Các thành phần gồm:

+ SNS Topic `cloudsoc-incident-alerts`.
+ Email subscription.
+ Lambda publish notification.
+ CloudWatch Alarm theo dõi Lambda Errors.
+ Slack notification optional thông qua Amazon Q Developer in chat applications.

Luồng notification chính:

```text
Incident Response Lambda
→ Amazon SNS
→ Email / Slack
→ SOC Analyst
```

Luồng cảnh báo lỗi:

```text
CloudWatch Metrics
→ CloudWatch Alarm
→ Amazon SNS
→ Email / Slack
```

Mục tiêu là giúp SOC Analyst nhận được thông báo kịp thời khi incident được xử lý hoặc khi hệ thống phản ứng sự cố gặp lỗi.

Kết quả mong đợi sau phần 5.4.7:

```text
SNS gửi notification thành công đến Email và Slack optional sau khi incident được xử lý.
```

---

#### Deployment Checklist

Bảng dưới đây tóm tắt các thành phần cần hoàn thành trong phần triển khai.

![CloudSOC Deployment Checklist](/images/5-Workshop/5.4-Deploy-cloudsoc-system/deployment-checklist.png)

| Mục | Trạng thái mong đợi |
|---|---|
| VPC và EC2 workload | Đã tạo |
| SG-Workload và SG-Isolation | Đã cấu hình |
| EC2 tag `AutoIsolate=true` | Đã thêm |
| IAM Role cho EC2 SSM | Đã tạo |
| CloudTrail | Đã bật |
| VPC Flow Logs | Đã bật |
| S3 Audit Logs Bucket | Đã tạo |
| S3 Evidence Bucket | Đã tạo |
| GuardDuty | Đã bật |
| Security Hub | Đã bật |
| Detective | Đã bật |
| AWS Config | Đã bật |
| EventBridge Rule | Đã tạo |
| Step Functions Workflow | Đã tạo |
| DynamoDB Incident Table | Đã tạo |
| Cognito User Pool | Đã tạo |
| Dashboard API Lambda | Đã tạo |
| API Gateway | Đã tạo |
| Amplify Dashboard | Đã triển khai |
| Incident Response Lambda | Đã triển khai |
| Systems Manager Run Command | Chạy thành công khi test |
| EBS Snapshot | Tạo thành công khi test |
| EC2 Isolation | Đổi sang SG-Isolation khi test |
| SNS Topic | Đã tạo |
| Email Notification | Gửi thành công |
| CloudWatch Alarm | Đã tạo |
| Slack Notification | Optional |

---

#### Kết quả mong đợi sau từng phần

| Phần | Kết quả mong đợi |
|---|---|
| 5.4.1 | EC2 workload chạy trong VPC và có thể được quản lý bằng Systems Manager |
| 5.4.2 | CloudTrail, VPC Flow Logs và S3 Evidence Bucket hoạt động |
| 5.4.3 | GuardDuty, Security Hub, Detective và AWS Config được bật |
| 5.4.4 | GuardDuty finding có thể kích hoạt Step Functions qua EventBridge |
| 5.4.5 | SOC Analyst có dashboard để xem incident và phê duyệt response |
| 5.4.6 | Lambda có thể thu thập evidence, tạo snapshot và cô lập EC2 |
| 5.4.7 | SNS có thể gửi alert qua Email và Slack optional |

---

#### Luồng hoạt động sau khi triển khai

Sau khi hoàn thành phần 5.4, hệ thống AWS CloudSOC có thể hoạt động theo luồng sau:

```text
1. GuardDuty phát hiện finding bất thường.
2. Security Hub tổng hợp finding bảo mật.
3. EventBridge nhận GuardDuty Finding.
4. Step Functions đánh giá severity và resource type.
5. Dashboard hiển thị incident cho SOC Analyst.
6. Incident Response Lambda được kích hoạt khi finding đủ điều kiện.
7. Systems Manager thu thập forensic evidence từ EC2.
8. Lambda tạo EBS Snapshot để phục vụ điều tra.
9. Lambda ghi event và response summary vào S3 Evidence Bucket.
10. Lambda đổi EC2 từ SG-Workload sang SG-Isolation.
11. DynamoDB cập nhật trạng thái incident.
12. SNS gửi notification đến Email hoặc Slack.
```

---

#### Kết quả sau khi hoàn thành phần 5.4

Sau khi hoàn thành toàn bộ phần 5.4, hệ thống AWS CloudSOC đã có đầy đủ các thành phần cốt lõi của một mô hình SOC tự động trên AWS.

Hệ thống có thể thực hiện quy trình:

```text
GuardDuty detects a finding
→ EventBridge routes the finding
→ Step Functions evaluates the response path
→ Lambda performs response actions
→ Systems Manager collects evidence
→ EBS Snapshot preserves forensic state
→ EC2 is isolated with SG-Isolation
→ DynamoDB records incident status
→ SNS sends notification to SOC Analyst
```

Các thành phần chính đã hoàn thành:

```text
VPC
EC2
Security Groups
CloudTrail
VPC Flow Logs
S3
GuardDuty
Security Hub
Detective
AWS Config
EventBridge
Step Functions
Lambda
Systems Manager
EBS Snapshot
DynamoDB
Cognito
API Gateway
Amplify
SNS
CloudWatch Alarm
Slack optional
```

---

#### Tổng kết

Phần 5.4 đã hoàn thành quá trình triển khai hệ thống CloudSOC từ hạ tầng mạng, logging, detection, workflow, dashboard, forensic response đến alerting.

Đây là phần triển khai chính của workshop và là nền tảng để thực hiện phần tiếp theo:

```text
5.5 Testing and Validation
```

Trong phần tiếp theo, chúng ta sẽ kiểm tra toàn bộ luồng hoạt động của hệ thống, bao gồm phát hiện finding, chạy workflow, cô lập EC2, lưu evidence và gửi notification.