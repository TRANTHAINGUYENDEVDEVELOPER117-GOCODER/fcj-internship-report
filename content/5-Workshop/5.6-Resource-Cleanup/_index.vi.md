---
title : "Dọn dẹp tài nguyên"
date : 2026-07-01
weight : 6
chapter : false
pre : " <b> 5.6. </b> "
---

#### Dọn dẹp tài nguyên

Trong phần này, chúng ta sẽ dọn dẹp các tài nguyên AWS đã tạo trong workshop **AWS CloudSOC** để tránh phát sinh chi phí không cần thiết sau khi hoàn thành lab.

Trong quá trình triển khai và kiểm thử, hệ thống đã sử dụng nhiều dịch vụ AWS như EC2, S3, Lambda, Step Functions, EventBridge, DynamoDB, SNS, CloudWatch, GuardDuty, Security Hub, Detective, AWS Config, API Gateway, Cognito và Amplify. Một số dịch vụ có thể phát sinh chi phí nếu tiếp tục chạy hoặc lưu trữ dữ liệu sau workshop.

Vì vậy, sau khi đã hoàn thành phần **5.5 Testing and Validation**, cần thực hiện cleanup theo đúng thứ tự.

---

#### Mục tiêu cleanup

Sau khi hoàn thành phần này, chúng ta sẽ:

+ Tắt hoặc xóa các workflow tự động để tránh tiếp tục xử lý event.
+ Xóa các Lambda function không còn sử dụng.
+ Xóa EventBridge rule và Step Functions state machine.
+ Xóa dashboard, API Gateway, Cognito và Amplify app.
+ Xóa SNS Topic, subscription và CloudWatch Alarm.
+ Xóa S3 bucket chứa log và evidence nếu không cần lưu lại.
+ Xóa EBS Snapshot đã tạo trong quá trình forensic test.
+ Terminate EC2 workload.
+ Xóa Security Groups, Route Table, Internet Gateway, Subnet và VPC.
+ Tắt hoặc xóa cấu hình GuardDuty, Security Hub, Detective và AWS Config nếu không còn sử dụng.
+ Xóa các IAM Role/Policy được tạo riêng cho lab.

---

#### Tổng quan quy trình cleanup

Sơ đồ dưới đây mô tả thứ tự dọn dẹp tài nguyên trong workshop CloudSOC.

![Resource Cleanup Overview](/images/5-Workshop/5.6-Resource-Cleanup/resource-cleanup-overview.png)

Thứ tự cleanup tổng quát:

```text
Stop Event Triggers
→ Delete Workflow Resources
→ Delete Dashboard Resources
→ Delete Alerting Resources
→ Delete Evidence and Logs
→ Delete Compute and Network
→ Disable Security Services
→ Remove IAM Roles
```

Thứ tự này giúp tránh trường hợp một dịch vụ vẫn tiếp tục gọi dịch vụ khác trong lúc đang dọn dẹp.

---

#### Lưu ý trước khi xóa tài nguyên

Trước khi xóa tài nguyên, cần đảm bảo rằng tất cả hình ảnh, log và bằng chứng cần đưa vào báo cáo đã được lưu lại.

Các dữ liệu nên kiểm tra trước khi xóa:

```text
GuardDuty findings screenshots
Step Functions execution screenshots
Lambda execution results
Systems Manager command output
S3 evidence screenshots
EBS snapshot screenshots
DynamoDB incident records
Dashboard screenshots
Email / Slack alert screenshots
CloudWatch Alarm screenshots
```

Nếu cần giữ lại evidence để phục vụ báo cáo, nên tải các file quan trọng từ S3 về máy trước khi xóa bucket.

---

#### Bước 1: Tắt EventBridge Rule

Đầu tiên, tắt hoặc xóa EventBridge rule để hệ thống không tiếp tục kích hoạt workflow khi có GuardDuty finding mới.

Rule sử dụng trong lab:

```text
cloudsoc-guardduty-finding-rule
```

Vào:

```text
Amazon EventBridge
→ Rules
→ cloudsoc-guardduty-finding-rule
```

Tắt rule bằng cách chọn:

```text
Disable
```

hoặc xóa rule nếu không còn sử dụng:

```text
Delete
```

![Disable EventBridge Rule](/images/5-Workshop/5.6-Resource-Cleanup/disable-eventbridge-rule.png)

Sau khi rule bị disable hoặc delete, GuardDuty findings mới sẽ không còn tự động kích hoạt Step Functions workflow.

---

#### Bước 2: Xóa Step Functions State Machine

Tiếp theo, xóa Step Functions state machine đã dùng để điều phối incident response workflow.

State machine trong lab:

```text
cloudsoc-incident-response-workflow
```

Vào:

```text
AWS Step Functions
→ State machines
→ cloudsoc-incident-response-workflow
```

Chọn:

```text
Delete
```

![Delete Step Functions Workflow](/images/5-Workshop/5.6-Resource-Cleanup/delete-stepfunctions-workflow.png)

Việc xóa state machine giúp loại bỏ luồng điều phối phản ứng sự cố sau khi workshop kết thúc.

---

#### Bước 3: Xóa Lambda Functions

Xóa các Lambda function đã tạo trong workshop.

Các Lambda function thường gồm:

```text
cloudsoc-incident-response-lambda
cloudsoc-dashboard-api-lambda
```

Vào:

```text
AWS Lambda
→ Functions
```

Chọn từng function và xóa:

```text
Actions → Delete
```

![Delete Lambda Functions](/images/5-Workshop/5.6-Resource-Cleanup/delete-lambda-functions.png)

Các Lambda này không còn cần thiết sau khi workflow và dashboard đã kết thúc.

---

#### Bước 4: Xóa Dashboard Resources

Trong phần dashboard, hệ thống đã sử dụng Amplify, API Gateway, Cognito, Dashboard API Lambda và DynamoDB.

Các tài nguyên cần dọn dẹp gồm:

```text
AWS Amplify App
API Gateway
Cognito User Pool
Dashboard API Lambda
DynamoDB Incident Table
```

##### Xóa Amplify App

Vào:

```text
AWS Amplify
→ cloudsoc-soc-dashboard
→ App settings
→ General settings
→ Delete app
```

![Delete Amplify Dashboard](/images/5-Workshop/5.6-Resource-Cleanup/delete-amplify-dashboard.png)

##### Xóa API Gateway

Vào:

```text
Amazon API Gateway
→ APIs
→ CloudSOC Dashboard API
→ Delete
```

![Delete API Gateway](/images/5-Workshop/5.6-Resource-Cleanup/delete-api-gateway.png)

##### Xóa Cognito User Pool

Vào:

```text
Amazon Cognito
→ User pools
→ CloudSOC user pool
→ Delete
```

![Delete Cognito User Pool](/images/5-Workshop/5.6-Resource-Cleanup/delete-cognito-user-pool.png)

##### Xóa DynamoDB Incident Table

Vào:

```text
DynamoDB
→ Tables
→ CloudSOC-IncidentTable
→ Delete table
```

![Delete DynamoDB Incident Table](/images/5-Workshop/5.6-Resource-Cleanup/delete-dynamodb-table.png)

Trước khi xóa DynamoDB, cần đảm bảo đã chụp hoặc lưu lại các incident record cần đưa vào báo cáo.

---

#### Bước 5: Xóa SNS Topic và Subscriptions

Tiếp theo, xóa lớp notification.

SNS Topic trong lab:

```text
cloudsoc-incident-alerts
```

Vào:

```text
Amazon SNS
→ Topics
→ cloudsoc-incident-alerts
```

Xóa các subscription nếu cần:

```text
Subscriptions → Delete
```

Sau đó xóa topic:

```text
Delete topic
```

![Delete SNS Topic](/images/5-Workshop/5.6-Resource-Cleanup/delete-sns-topic.png)

Nếu có cấu hình Slack qua Amazon Q Developer in chat applications, có thể xóa channel configuration tương ứng.

![Delete Slack Channel Configuration](/images/5-Workshop/5.6-Resource-Cleanup/delete-slack-channel-configuration.png)

---

#### Bước 6: Xóa CloudWatch Alarm và Log Groups

Trong workshop, CloudWatch được dùng để lưu log và tạo alarm theo dõi lỗi Lambda.

Các tài nguyên cần kiểm tra:

```text
CloudWatch Alarms
Lambda log groups
CloudTrail log group
VPC Flow Logs log group
Step Functions log group
```

Vào:

```text
CloudWatch
→ Alarms
→ All alarms
```

Xóa alarm:

```text
cloudsoc-incident-response-lambda-errors
```

![Delete CloudWatch Alarm](/images/5-Workshop/5.6-Resource-Cleanup/delete-cloudwatch-alarm.png)

Sau đó vào:

```text
CloudWatch
→ Logs
→ Log groups
```

Xóa các log group liên quan nếu không cần giữ lại:

```text
/aws/lambda/cloudsoc-incident-response-lambda
/aws/lambda/cloudsoc-dashboard-api-lambda
/aws/cloudtrail/cloudsoc
/aws/vpc-flowlogs/cloudsoc-vpc
/aws/states/cloudsoc-incident-response-workflow
```

![Delete CloudWatch Log Groups](/images/5-Workshop/5.6-Resource-Cleanup/delete-cloudwatch-log-groups.png)

---

#### Bước 7: Xóa S3 Buckets và Evidence

Trong workshop, S3 được sử dụng để lưu audit logs và incident evidence.

Các bucket thường gồm:

```text
cloudsoc-audit-logs-<account-id>
cloudsoc-evidence-<account-id>
```

Vào:

```text
Amazon S3
→ Buckets
```

Trước khi xóa bucket, cần empty bucket trước:

```text
Empty bucket
→ Delete bucket
```

![Delete S3 Evidence Bucket](/images/5-Workshop/5.6-Resource-Cleanup/delete-s3-evidence-bucket.png)

Các object cần kiểm tra trước khi xóa:

```text
CloudTrail logs
raw-event.json
response-summary.json
SSM command output
forensic evidence
```

Nếu cần lưu lại bằng chứng cho báo cáo, tải các file quan trọng về máy trước khi xóa.

---

#### Bước 8: Xóa EBS Forensic Snapshots

Trong quá trình auto isolation, Lambda đã tạo EBS Snapshot để phục vụ forensic investigation.

Vào:

```text
EC2
→ Elastic Block Store
→ Snapshots
```

Tìm snapshot có tag hoặc description liên quan:

```text
Project = AWS-CloudSOC
Purpose = Forensics
IncidentId = INC-sample-finding-001
```

Chọn snapshot và xóa:

```text
Actions → Delete snapshot
```

![Delete EBS Forensic Snapshot](/images/5-Workshop/5.6-Resource-Cleanup/delete-ebs-forensic-snapshot.png)

Snapshot có thể phát sinh chi phí lưu trữ, nên cần xóa nếu không còn sử dụng.

---

#### Bước 9: Terminate EC2 Workload

Sau khi đã lưu evidence và xóa snapshot không cần thiết, terminate EC2 workload.

EC2 trong lab:

```text
cloudsoc-workload-ec2
```

Vào:

```text
EC2
→ Instances
→ cloudsoc-workload-ec2
```

Chọn:

```text
Instance state
→ Terminate instance
```

![Terminate EC2 Workload](/images/5-Workshop/5.6-Resource-Cleanup/terminate-ec2-workload.png)

Sau khi terminate, kiểm tra trạng thái instance chuyển sang:

```text
Terminated
```

---

#### Bước 10: Xóa Security Groups

Sau khi EC2 đã terminated, xóa các Security Group đã tạo cho lab.

Các Security Group thường gồm:

```text
SG-Workload
SG-Isolation
```

Vào:

```text
EC2
→ Security Groups
```

Chọn từng security group và xóa:

```text
Actions → Delete security groups
```

![Delete Security Groups](/images/5-Workshop/5.6-Resource-Cleanup/delete-security-groups.png)

Lưu ý: không thể xóa Security Group nếu vẫn còn tài nguyên đang sử dụng nó. Nếu bị lỗi, kiểm tra lại EC2, network interface hoặc resource liên quan.

---

#### Bước 11: Xóa Network Resources

Sau khi EC2 và Security Groups đã được xóa, tiếp tục xóa tài nguyên mạng.

Các tài nguyên cần xóa:

```text
Public Route Table
Public Subnet
Internet Gateway
VPC
```

Thứ tự khuyến nghị:

```text
Detach Internet Gateway
Delete Internet Gateway
Delete Subnet
Delete Route Table
Delete VPC
```

![Delete Network Resources](/images/5-Workshop/5.6-Resource-Cleanup/delete-network-resources.png)

Tài nguyên mạng trong lab có thể gồm:

```text
cloudsoc-vpc
cloudsoc-public-subnet
cloudsoc-public-rtb
cloudsoc-igw
```

---

#### Bước 12: Tắt các dịch vụ Security nếu không còn sử dụng

Các dịch vụ security như GuardDuty, Security Hub, Detective và AWS Config có thể tiếp tục phát sinh chi phí tùy theo cấu hình và dữ liệu được xử lý.

Các dịch vụ cần kiểm tra:

```text
Amazon GuardDuty
AWS Security Hub
Amazon Detective
AWS Config
```

Vào từng dịch vụ và disable nếu không còn sử dụng trong lab.

![Disable Security Services](/images/5-Workshop/5.6-Resource-Cleanup/disable-security-services.png)

Lưu ý: chỉ disable các dịch vụ này nếu tài khoản AWS chỉ dùng cho lab. Nếu tài khoản còn dùng cho mục đích bảo mật khác, cần cân nhắc trước khi tắt.

---

#### Bước 13: Xóa IAM Roles và Policies

Cuối cùng, xóa các IAM Role và Policy đã tạo riêng cho workshop.

Các role có thể bao gồm:

```text
CloudSOC-EC2-SSM-Role
CloudSOC-Incident-Response-Lambda-Role
CloudSOC-Dashboard-API-Lambda-Role
CloudSOC-EventBridge-StepFunctions-Role
CloudSOC-CloudTrail-CloudWatch-Role
CloudSOC-VPCFlowLogs-Role
CloudSOC-QDeveloper-ChatOps-Role
```

Vào:

```text
IAM
→ Roles
```

Chọn role không còn sử dụng và xóa.

![Delete IAM Roles](/images/5-Workshop/5.6-Resource-Cleanup/delete-iam-roles.png)

Trước khi xóa role, cần đảm bảo role không còn được gắn với EC2, Lambda, EventBridge hoặc dịch vụ nào khác.

---

#### Cleanup Checklist

Bảng dưới đây tóm tắt các tài nguyên cần dọn dẹp sau workshop.

| Nhóm tài nguyên | Tài nguyên cần xóa hoặc tắt | Trạng thái |
|---|---|---|
| Event Routing | EventBridge Rule | Deleted / Disabled |
| Workflow | Step Functions State Machine | Deleted |
| Compute | Lambda Functions, EC2 Instance | Deleted / Terminated |
| Dashboard | Amplify, API Gateway, Cognito | Deleted |
| Database | DynamoDB Incident Table | Deleted |
| Notification | SNS Topic, Email Subscription, Slack Configuration | Deleted |
| Monitoring | CloudWatch Alarm, Log Groups | Deleted |
| Storage | S3 Audit Logs, S3 Evidence Bucket | Deleted |
| Forensics | EBS Snapshots | Deleted |
| Network | Security Groups, Subnet, Route Table, IGW, VPC | Deleted |
| Security Services | GuardDuty, Security Hub, Detective, AWS Config | Disabled if not needed |
| IAM | CloudSOC Roles and Policies | Deleted |

---

#### Kiểm tra sau cleanup

Sau khi xóa tài nguyên, kiểm tra lại các khu vực chính trong AWS Console:

```text
EC2 Instances
EBS Snapshots
S3 Buckets
Lambda Functions
Step Functions
EventBridge Rules
DynamoDB Tables
SNS Topics
CloudWatch Alarms
Amplify Apps
API Gateway APIs
Cognito User Pools
IAM Roles
```

Mục tiêu là đảm bảo không còn tài nguyên lab nào đang chạy hoặc có thể phát sinh chi phí.

![Final Cleanup Check](/images/5-Workshop/5.6-Resource-Cleanup/final-cleanup-check.png)

---

#### Kết quả mong đợi

Sau khi hoàn thành phần cleanup, các kết quả mong đợi gồm:

| Hạng mục | Kết quả mong đợi |
|---|---|
| EventBridge | Rule đã bị disable hoặc delete |
| Step Functions | State machine đã được xóa |
| Lambda | Các function lab đã được xóa |
| EC2 | Workload instance đã terminated |
| EBS Snapshot | Snapshot forensic đã được xóa |
| S3 | Bucket log/evidence đã được empty và delete |
| DynamoDB | Incident table đã được xóa |
| SNS | Topic và subscription đã được xóa |
| CloudWatch | Alarm và log group không cần thiết đã được xóa |
| Dashboard | Amplify app, API Gateway, Cognito đã được xóa |
| Network | VPC, subnet, IGW, route table và SG đã được xóa |
| Security Services | Các dịch vụ security đã được tắt nếu không còn dùng |
| IAM | Role/policy riêng cho lab đã được xóa |

---

#### Tổng kết

Phần 5.6 đã hoàn thành quá trình dọn dẹp tài nguyên của workshop **AWS CloudSOC**.

Việc cleanup giúp tránh phát sinh chi phí không cần thiết và giữ cho tài khoản AWS sạch sau khi hoàn thành lab.

Sau khi hoàn tất phần này, toàn bộ workshop đã đi qua đầy đủ các giai đoạn:

```text
Design Architecture
→ Deploy CloudSOC System
→ Test and Validate
→ Resource Cleanup
```

Kết quả cuối cùng là một mô hình AWS CloudSOC hoàn chỉnh, có khả năng phát hiện finding, điều phối workflow, hỗ trợ approval, tự động cô lập EC2, lưu evidence, gửi cảnh báo và dọn dẹp tài nguyên sau khi sử dụng.