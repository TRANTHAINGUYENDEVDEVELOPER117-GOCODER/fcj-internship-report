---
title : "Logging and Evidence Storage"
date : 2026-07-01
weight : 2
chapter : false
pre : " <b> 5.4.2. </b> "
---

#### Logging and Evidence Storage

Trong phần này, chúng ta sẽ cấu hình lớp **Logging and Evidence Storage** cho hệ thống AWS CloudSOC. Đây là lớp chịu trách nhiệm ghi nhận log, lưu trữ bằng chứng sự cố và chuẩn bị dữ liệu phục vụ quá trình điều tra sau khi phát hiện mối đe dọa.

Các log và bằng chứng thu thập được sẽ được lưu trữ trong Amazon S3 và Amazon CloudWatch. Những dữ liệu này sẽ hỗ trợ SOC Analyst trong quá trình phân tích incident, kiểm tra hành vi bất thường và xác minh kết quả phản ứng sự cố.

---

#### Mục tiêu

Sau khi hoàn thành phần này, bạn sẽ có:

+ Một S3 bucket dùng để lưu CloudTrail audit logs.
+ Một S3 bucket dùng để lưu forensic evidence.
+ AWS CloudTrail được bật để ghi lại management events.
+ Amazon CloudWatch Logs được chuẩn bị để lưu log.
+ VPC Flow Logs được bật để ghi nhận metadata của network traffic.
+ AWS KMS key được chuẩn bị để mã hóa dữ liệu nếu cần.
+ Cấu trúc thư mục S3 dùng để lưu evidence theo từng incident.

---

#### Kiến trúc Logging and Evidence Storage

Sơ đồ sau minh họa lớp Logging and Evidence Storage trong hệ thống AWS CloudSOC.

![Logging and Evidence Storage](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.2-logging-and-evidence-storage/logging-evidence-architecture.png)

Luồng logging và evidence chính:

```text
CloudTrail → S3 Audit Logs
CloudTrail → CloudWatch Logs
VPC Flow Logs → CloudWatch Logs
Systems Manager → S3 Evidence Bucket
Incident Response Lambda → S3 Evidence Bucket
Incident Response Lambda → CloudWatch Logs
KMS → S3 Encryption
```

---

#### Thông tin cấu hình đề xuất

Bạn có thể sử dụng các thông tin cấu hình sau cho workshop:

| Thành phần | Giá trị đề xuất |
|---|---|
| Audit Log Bucket | `cloudsoc-audit-logs-<account-id>` |
| Evidence Bucket | `cloudsoc-evidence-<account-id>` |
| CloudTrail Name | `cloudsoc-cloudtrail` |
| CloudWatch Log Group for CloudTrail | `/aws/cloudtrail/cloudsoc` |
| VPC Flow Logs Log Group | `/aws/vpc-flowlogs/cloudsoc-vpc` |
| KMS Alias | `alias/cloudsoc-evidence-key` |
| S3 Evidence Prefix | `incidents/` |
| S3 Forensic Prefix | `forensics/` |

> **Lưu ý:** Tên S3 bucket phải là duy nhất toàn cầu. Vì vậy, nên thêm Account ID hoặc một chuỗi ngẫu nhiên vào cuối tên bucket.

---

#### Bước 1: Tạo S3 Bucket lưu Audit Logs

Mở dịch vụ **Amazon S3**, chọn:

```text
Buckets → Create bucket
```

Cấu hình bucket:

| Mục | Giá trị |
|---|---|
| Bucket name | `cloudsoc-audit-logs-<account-id>` |
| AWS Region | `ap-southeast-1` |
| Object Ownership | ACLs disabled |
| Block Public Access | Block all public access |
| Bucket Versioning | Enable |
| Default encryption | SSE-S3 hoặc SSE-KMS |

Sau đó chọn **Create bucket**.

Bucket này được sử dụng để lưu log từ AWS CloudTrail.

Kết quả mong đợi:

```text
S3 bucket cloudsoc-audit-logs-<account-id> được tạo thành công.
```

![Create Audit Logs Bucket](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.2-logging-and-evidence-storage/create-audit-logs-bucket.png)

---

#### Bước 2: Tạo S3 Bucket lưu Evidence

Tiếp tục tạo bucket thứ hai để lưu evidence và forensic output.

Trong Amazon S3, chọn:

```text
Buckets → Create bucket
```

Cấu hình bucket:

| Mục | Giá trị |
|---|---|
| Bucket name | `cloudsoc-evidence-<account-id>` |
| AWS Region | `ap-southeast-1` |
| Object Ownership | ACLs disabled |
| Block Public Access | Block all public access |
| Bucket Versioning | Enable |
| Default encryption | SSE-S3 hoặc SSE-KMS |

Bucket này dùng để lưu:

+ Forensic output từ Systems Manager.
+ Incident evidence từ Lambda.
+ Metadata liên quan đến snapshot.
+ File JSON mô tả incident.

Kết quả mong đợi:

```text
S3 bucket cloudsoc-evidence-<account-id> được tạo thành công.
```

![Create Evidence Bucket](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.2-logging-and-evidence-storage/create-evidence-bucket.png)

---

#### Bước 3: Tạo cấu trúc thư mục trong Evidence Bucket

Mở bucket:

```text
cloudsoc-evidence-<account-id>
```

Tạo các folder/prefix sau:

```text
incidents/
forensics/
snapshots/
lambda-output/
```

Ý nghĩa từng folder:

| Prefix | Mục đích |
|---|---|
| `incidents/` | Lưu thông tin incident theo từng finding |
| `forensics/` | Lưu output thu thập từ Systems Manager |
| `snapshots/` | Lưu metadata liên quan đến EBS Snapshot |
| `lambda-output/` | Lưu kết quả xử lý từ Lambda |

Kết quả mong đợi:

```text
Evidence bucket đã có cấu trúc folder phục vụ lưu trữ bằng chứng.
```

![Evidence Bucket Folders](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.2-logging-and-evidence-storage/evidence-bucket-folders.png)

---

#### Bước 4: Tạo KMS Key cho Evidence Storage

AWS KMS được sử dụng để mã hóa dữ liệu nhạy cảm trong S3 nếu cần. Trong môi trường lab, bạn có thể dùng SSE-S3 để đơn giản hóa. Tuy nhiên, để kiến trúc bảo mật đầy đủ hơn, nên chuẩn bị KMS key riêng cho evidence bucket.

Mở dịch vụ **AWS KMS**, chọn:

```text
Customer managed keys → Create key
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Key type | Symmetric |
| Key usage | Encrypt and decrypt |
| Alias | `alias/cloudsoc-evidence-key` |
| Key administrators | Chọn user/role quản trị |
| Key users | Chọn các role cần dùng key |

Các role có thể cần quyền sử dụng KMS key:

+ Incident Response Lambda Role
+ Step Functions Workflow Role
+ EC2 SSM Instance Role

Kết quả mong đợi:

```text
KMS key alias/cloudsoc-evidence-key được tạo thành công.
```

![Create KMS Key](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.2-logging-and-evidence-storage/create-kms-key.png)

---

#### Bước 5: Bật CloudTrail

AWS CloudTrail được sử dụng để ghi lại các management events trong AWS account. Những event này giúp SOC Analyst biết được ai đã thực hiện hành động gì, trên tài nguyên nào và vào thời điểm nào.

Mở dịch vụ **AWS CloudTrail**, chọn:

```text
Trails → Create trail
```

Cấu hình trail:

| Mục | Giá trị |
|---|---|
| Trail name | `cloudsoc-cloudtrail` |
| Storage location | Use existing S3 bucket |
| S3 bucket | `cloudsoc-audit-logs-<account-id>` |
| Log file SSE-KMS encryption | Enable nếu dùng KMS |
| CloudWatch Logs | Enable |
| Log group | `/aws/cloudtrail/cloudsoc` |

Ở phần **Events**, chọn:

```text
Management events
```

Chọn:

```text
Read
Write
```

Sau đó chọn **Create trail**.

Kết quả mong đợi:

```text
CloudTrail cloudsoc-cloudtrail được bật và ghi log vào S3 / CloudWatch.
```

![Create CloudTrail](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.2-logging-and-evidence-storage/create-cloudtrail.png)

---

#### Bước 6: Kiểm tra CloudTrail Logs trong S3

Sau khi bật CloudTrail, chờ vài phút để log được ghi vào S3.

Mở bucket:

```text
cloudsoc-audit-logs-<account-id>
```

Kiểm tra thư mục log CloudTrail:

```text
AWSLogs/
```

Bên trong sẽ có log theo cấu trúc account, region và ngày.

Kết quả mong đợi:

```text
CloudTrail log files xuất hiện trong S3 audit logs bucket.
```

![CloudTrail Logs in S3](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.2-logging-and-evidence-storage/cloudtrail-logs-s3.png)

---

#### Bước 7: Tạo CloudWatch Log Group cho VPC Flow Logs

Mở dịch vụ **Amazon CloudWatch**, chọn:

```text
Logs → Log groups → Create log group
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Log group name | `/aws/vpc-flowlogs/cloudsoc-vpc` |
| Retention setting | 7 days hoặc 14 days |

Chọn **Create**.

Kết quả mong đợi:

```text
CloudWatch Log Group cho VPC Flow Logs được tạo thành công.
```

![Create VPC Flow Logs Log Group](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.2-logging-and-evidence-storage/vpc-flowlogs-cloudwatch.png)

---

#### Bước 8: Bật VPC Flow Logs

VPC Flow Logs được sử dụng để ghi nhận metadata của network traffic trong VPC. Trong workshop này, log được gửi đến CloudWatch Logs để dễ quan sát.

Mở dịch vụ **VPC**, chọn:

```text
Your VPCs → cloudsoc-vpc → Flow logs
```

Chọn:

```text
Create flow log
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Name | `cloudsoc-vpc-flowlogs` |
| Filter | All |
| Maximum aggregation interval | 1 minute |
| Destination | Send to CloudWatch Logs |
| Destination log group | `/aws/vpc-flowlogs/cloudsoc-vpc` |
| IAM role | Role cho phép VPC Flow Logs ghi vào CloudWatch |

Nếu chưa có IAM Role cho VPC Flow Logs, tạo role mới theo hướng dẫn trên AWS Console.

Kết quả mong đợi:

```text
VPC Flow Logs được bật cho cloudsoc-vpc và gửi log đến CloudWatch.
```

![Create VPC Flow Logs](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.2-logging-and-evidence-storage/create-vpc-flowlogs.png)

---

#### Bước 9: Kiểm tra VPC Flow Logs trong CloudWatch

Sau khi bật VPC Flow Logs, chờ vài phút rồi mở:

```text
CloudWatch → Logs → Log groups
```

Chọn log group:

```text
/aws/vpc-flowlogs/cloudsoc-vpc
```

Kiểm tra các log stream được tạo.

Kết quả mong đợi:

```text
VPC Flow Logs xuất hiện trong CloudWatch Logs.
```

![VPC Flow Logs in CloudWatch](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.2-logging-and-evidence-storage/vpc-flowlogs-cloudwatch.png)

---

#### Bước 10: Chuẩn bị nơi lưu forensic output từ Systems Manager

Trong các phần sau, Systems Manager sẽ chạy command trên EC2 để thu thập forensic evidence. Output của command có thể được lưu vào S3 evidence bucket.

Đường dẫn lưu forensic output đề xuất:

```text
s3://cloudsoc-evidence-<account-id>/forensics/
```

Khi chạy Systems Manager Run Command, cấu hình output như sau:

| Mục | Giá trị |
|---|---|
| S3 bucket name | `cloudsoc-evidence-<account-id>` |
| S3 key prefix | `forensics/` |
| CloudWatch output | Enable nếu cần |

Kết quả mong đợi:

```text
S3 evidence bucket đã sẵn sàng để lưu forensic output từ Systems Manager.
```

---

#### Bước 11: Chuẩn bị nơi lưu incident evidence từ Lambda

Incident Response Lambda sẽ lưu kết quả xử lý incident vào S3 evidence bucket.

Đường dẫn lưu incident evidence đề xuất:

```text
s3://cloudsoc-evidence-<account-id>/incidents/
```

Ví dụ cấu trúc evidence theo từng incident:

```text
incidents/
└── finding-id/
    ├── finding.json
    ├── response-result.json
    ├── isolation-status.json
    └── snapshot-metadata.json
```

Kết quả mong đợi:

```text
S3 evidence bucket đã sẵn sàng để lưu incident evidence từ Lambda.
```

---

#### Bước 12: Kiểm tra CloudWatch Logs cho Lambda

Trong các phần sau, khi Lambda được tạo và thực thi, CloudWatch sẽ tự động tạo log group tương ứng.

Log group Lambda thường có dạng:

```text
/aws/lambda/<lambda-function-name>
```

Ví dụ:

```text
/aws/lambda/cloudsoc-incident-response-lambda
/aws/lambda/cloudsoc-dashboard-api-lambda
```

Các log này dùng để kiểm tra:

+ Lambda có được invoke hay không.
+ Lambda xử lý finding thành công hay thất bại.
+ Lambda có lỗi permission hay không.
+ Lambda có cập nhật DynamoDB hoặc S3 thành công hay không.

Kết quả mong đợi:

```text
CloudWatch Logs đã sẵn sàng để lưu execution logs của Lambda.
```

---

#### Kiểm tra sau khi hoàn thành

Sau khi hoàn thành phần này, kiểm tra lại các mục sau:

- [ ] S3 bucket `cloudsoc-audit-logs-<account-id>` đã được tạo.
- [ ] S3 bucket `cloudsoc-evidence-<account-id>` đã được tạo.
- [ ] Block Public Access đã được bật cho cả hai bucket.
- [ ] Bucket Versioning đã được bật cho các bucket quan trọng.
- [ ] Evidence bucket có các prefix `incidents/`, `forensics/`, `snapshots/`, `lambda-output/`.
- [ ] KMS key `alias/cloudsoc-evidence-key` đã được tạo nếu dùng SSE-KMS.
- [ ] CloudTrail `cloudsoc-cloudtrail` đã được bật.
- [ ] CloudTrail ghi log vào S3 audit logs bucket.
- [ ] CloudTrail có thể gửi log đến CloudWatch Logs.
- [ ] VPC Flow Logs đã được bật cho `cloudsoc-vpc`.
- [ ] VPC Flow Logs gửi log đến CloudWatch Logs.
- [ ] Evidence bucket đã sẵn sàng để nhận forensic output từ Systems Manager.
- [ ] Evidence bucket đã sẵn sàng để nhận incident evidence từ Lambda.

---

#### Kết quả sau khi hoàn thành

Sau khi hoàn thành phần này, hệ thống AWS CloudSOC đã có nền tảng logging và evidence storage.

Các thành phần đã sẵn sàng gồm:

```text
CloudTrail
Amazon S3
Amazon CloudWatch Logs
VPC Flow Logs
AWS KMS
Evidence folder structure
```

Lớp này giúp hệ thống lưu lại audit logs, network flow logs và bằng chứng sự cố. Đây là dữ liệu quan trọng để SOC Analyst điều tra, xác minh và báo cáo sau khi incident xảy ra.

---

#### Tóm tắt

Trong phần này, chúng ta đã cấu hình các thành phần phục vụ logging và lưu trữ bằng chứng cho AWS CloudSOC. CloudTrail ghi lại management events, VPC Flow Logs ghi lại metadata của network traffic, CloudWatch Logs hỗ trợ quan sát log, còn Amazon S3 được sử dụng để lưu audit logs và forensic evidence.

Ở phần tiếp theo, chúng ta sẽ bật các dịch vụ **Threat Detection Services** như Amazon GuardDuty, AWS Security Hub, Amazon Detective và AWS Config để phát hiện và phân tích các mối đe dọa trong môi trường AWS.