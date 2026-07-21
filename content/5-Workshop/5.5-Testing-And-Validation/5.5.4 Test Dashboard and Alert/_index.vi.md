---
title : "Kiểm thử Dashboard và Alert"
date : 2026-07-01
weight : 4
chapter : false
pre : " <b> 5.5.4. </b> "
---

#### Kiểm thử Dashboard và Alert

Trong phần này, chúng ta sẽ kiểm thử khả năng hiển thị incident trên **SOC Dashboard** và khả năng gửi cảnh báo qua **Amazon SNS**, **Email** và **Slack**.

Sau khi hệ thống CloudSOC phát hiện và xử lý incident, SOC Analyst cần có khả năng theo dõi trạng thái incident trên dashboard và nhận cảnh báo kịp thời qua các kênh notification.

Luồng tổng quan:

```text
Incident Response Lambda
→ DynamoDB Incident Table
→ SOC Dashboard

Incident Response Lambda
→ Amazon SNS
→ Email / Slack
→ SOC Analyst

CloudWatch Alarm
→ Amazon SNS
→ Email / Slack
```

Phần kiểm thử này xác nhận rằng dashboard và alerting layer hoạt động đúng sau khi incident được xử lý.

---

#### Mục tiêu kiểm thử

Sau khi hoàn thành phần này, chúng ta có thể xác nhận rằng:

+ SOC Dashboard hiển thị được danh sách incident.
+ Dashboard cập nhật trạng thái incident sau khi hệ thống xử lý.
+ DynamoDB lưu được thông tin notification.
+ SNS Topic có subscription hoạt động.
+ Email nhận được incident alert.
+ Slack nhận được incident alert thông qua Amazon Q Developer in chat applications.
+ CloudWatch Alarm có thể gửi cảnh báo lỗi về SNS.

---

#### Kiến trúc kiểm thử

Sơ đồ dưới đây mô tả luồng kiểm thử Dashboard và Alert.

![Test Dashboard and Alert Flow](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-Test-Dashboard-And-Alert/test-dashboard-alert-flow.png)

Luồng kiểm thử gồm hai nhánh chính:

```text
Dashboard Validation:
DynamoDB Incident Table
→ Dashboard API Lambda
→ API Gateway
→ Amplify Dashboard
→ SOC Analyst

Alert Validation:
Incident Response Lambda / CloudWatch Alarm
→ Amazon SNS
→ Email / Slack
→ SOC Analyst
```

---

#### Bước 1: Kiểm tra dashboard trước khi nhận alert mới

Đầu tiên, mở SOC Dashboard đã triển khai bằng AWS Amplify.

Dashboard sử dụng trong lab:

```text
AWS CloudSOC Dashboard
```

Dashboard cần hiển thị các thông tin tổng quan như:

```text
Total Incidents
Pending Approval
Critical Findings
Incident List
```

![Dashboard Before Alert Test](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-Test-Dashboard-And-Alert/dashboard-before-alert-test.png)

Ở bước này, dashboard đóng vai trò là giao diện theo dõi incident cho SOC Analyst.

---

#### Bước 2: Kiểm tra incident đã được xử lý trên dashboard

Sau khi phần **5.5.3 Test Auto Isolation** hoàn thành, incident đã được xử lý bởi Incident Response Lambda.

Dashboard cần hiển thị trạng thái mới của incident.

Ví dụ trạng thái mong đợi:

```text
Incident ID: INC-sample-finding-001
Finding Type: UnauthorizedAccess:EC2/SSHBruteForce
Severity: 8.5
Response Mode: AutoResponse
Approval Status: Approved
Incident Status: Isolated
```

![Dashboard Isolated Incident](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-Test-Dashboard-And-Alert/dashboard-isolated-incident.png)

Thông tin này xác nhận rằng dashboard có thể hiển thị kết quả xử lý incident sau khi auto isolation hoàn tất.

---

#### Bước 3: Kiểm tra DynamoDB notification record

Sau khi Lambda xử lý incident và gửi notification, DynamoDB Incident Table cần lưu lại thông tin liên quan đến trạng thái xử lý và notification.

Các trường quan trọng có thể bao gồm:

```text
incidentId
findingType
severity
resourceId
responseMode
approvalStatus
incidentStatus
evidencePath
snapshotIds
ssmCommandId
notificationMessageId
```

![DynamoDB Notification Record](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-Test-Dashboard-And-Alert/dynamodb-notification-record.png)

Trường `notificationMessageId` cho biết Lambda đã gọi SNS publish thành công và SNS đã tạo message ID cho notification.

---

#### Bước 4: Kiểm tra SNS Topic và Subscriptions

Tiếp theo, kiểm tra SNS Topic dùng để gửi cảnh báo.

SNS Topic trong lab:

```text
cloudsoc-incident-alerts
```

Topic này được sử dụng để gửi incident alert đến Email và Slack.

![SNS Topic Subscriptions Validation](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-Test-Dashboard-And-Alert/sns-topic-subscriptions-validation.png)

Subscription cần có trạng thái:

```text
Confirmed
```

Các endpoint có thể bao gồm:

```text
Email subscription
Slack integration through Amazon Q Developer in chat applications
```

Điều này xác nhận rằng SNS Topic đã sẵn sàng gửi cảnh báo đến SOC Analyst.

---

#### Bước 5: Kiểm tra Email incident alert

Sau khi Incident Response Lambda publish message đến SNS, email subscription sẽ nhận được incident alert.

Nội dung email có thể bao gồm:

```text
AWS CloudSOC Incident Response Completed

Incident ID
Finding Type
Severity
Resource ID
Response Mode
Incident Status
Isolation Security Group
SSM Command ID
Snapshot IDs
Evidence Path
```

![Email Incident Alert Received](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-Test-Dashboard-And-Alert/email-incident-alert-received.png)

Email alert xác nhận rằng SOC Analyst có thể nhận thông báo sau khi incident được xử lý.

---

#### Bước 6: Kiểm tra Slack incident alert

Ngoài email, SNS cũng có thể gửi alert đến Slack thông qua Amazon Q Developer in chat applications.

Slack channel sử dụng trong lab:

```text
#cloudsoc-alerts
```

Sau khi SNS gửi message, Slack channel sẽ hiển thị notification từ AWS.

![Slack Incident Alert Validation](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-Test-Dashboard-And-Alert/slack-incident-alert-validation.png)

Slack alert giúp SOC Analyst nhận thông báo nhanh trong kênh làm việc nhóm.

Nội dung alert nên thể hiện được các thông tin chính:

```text
Incident ID
Finding Type
Severity
Resource ID
Incident Status
```

---

#### Bước 7: Kiểm tra CloudWatch Alarm

Ngoài incident alert, hệ thống cũng cần cảnh báo khi Lambda phản ứng sự cố gặp lỗi.

CloudWatch Alarm được sử dụng để theo dõi metric lỗi của Lambda:

```text
Lambda Errors >= 1
```

Alarm trong lab:

```text
cloudsoc-incident-response-lambda-errors
```

![CloudWatch Alarm Dashboard](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-Test-Dashboard-And-Alert/cloudwatch-alarm-dashboard.png)

Alarm này giúp SOC Analyst biết khi Incident Response Lambda bị lỗi và cần kiểm tra lại hệ thống.

---

#### Bước 8: Kiểm tra alarm notification

Khi CloudWatch Alarm chuyển sang trạng thái `In alarm`, alarm sẽ gửi notification đến SNS Topic.

Luồng cảnh báo lỗi:

```text
CloudWatch Alarm
→ Amazon SNS
→ Email / Slack
→ SOC Analyst
```

![CloudWatch Alarm Notification](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-Test-Dashboard-And-Alert/cloudwatch-alarm-notification.png)

Thông báo alarm giúp SOC Analyst phát hiện lỗi trong quy trình phản ứng sự cố, ví dụ Lambda error hoặc workflow failure.

---

#### Bước 9: Kiểm tra trạng thái cuối cùng trên dashboard

Sau khi incident đã được xử lý và alert đã được gửi, dashboard được kiểm tra lại để xác nhận trạng thái cuối cùng.

Trạng thái mong đợi:

```text
Incident Status: Isolated
Response Mode: AutoResponse
Approval Status: Approved
Notification: Sent
```

![Dashboard Final Incident Status](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-Test-Dashboard-And-Alert/dashboard-final-incident-status.png)

Kết quả này xác nhận rằng SOC Dashboard đã phản ánh đúng trạng thái cuối cùng của incident.

---

#### Kết quả mong đợi

Sau khi hoàn thành phần này, các kết quả mong đợi gồm:

| Thành phần | Kết quả mong đợi |
|---|---|
| SOC Dashboard | Hiển thị incident và trạng thái xử lý |
| DynamoDB | Lưu trạng thái incident và notification message ID |
| SNS Topic | Có subscription hoạt động |
| Email | Nhận được incident alert |
| Slack | Nhận được incident alert |
| CloudWatch Alarm | Có thể gửi alarm notification qua SNS |
| SOC Analyst | Có thể theo dõi incident qua dashboard và alert |

---

#### Bằng chứng kiểm thử

Các bằng chứng kiểm thử trong phần này bao gồm những hình ảnh sau:

| STT | Hình ảnh | Mục đích |
|---|---|---|
| 1 | Dashboard and alert flow diagram | Mô tả luồng kiểm thử dashboard và alert |
| 2 | Dashboard before alert test | Xác nhận dashboard đã hoạt động |
| 3 | Dashboard isolated incident | Xác nhận dashboard hiển thị incident đã xử lý |
| 4 | DynamoDB notification record | Xác nhận DynamoDB lưu trạng thái notification |
| 5 | SNS topic subscriptions | Xác nhận SNS subscription đã confirmed |
| 6 | Email incident alert | Xác nhận email nhận incident alert |
| 7 | Slack incident alert | Xác nhận Slack nhận incident alert |
| 8 | CloudWatch alarm dashboard | Xác nhận alarm theo dõi Lambda error |
| 9 | CloudWatch alarm notification | Xác nhận alarm gửi notification |
| 10 | Dashboard final incident status | Xác nhận trạng thái cuối cùng trên dashboard |

---

#### Ghi chú

Dashboard và alert là hai thành phần quan trọng trong hoạt động SOC.

Dashboard giúp SOC Analyst theo dõi incident tập trung, trong khi SNS, Email và Slack giúp gửi cảnh báo nhanh khi có sự cố hoặc khi hệ thống phản ứng sự cố gặp lỗi.

Trong môi trường thực tế, dashboard và alerting layer giúp đội SOC:

```text
Theo dõi incident theo thời gian gần thực
Nhận thông báo nhanh khi có sự cố
Kiểm tra trạng thái xử lý incident
Theo dõi lỗi của hệ thống response automation
Hỗ trợ điều tra và ra quyết định nhanh hơn
```

---

#### Hoàn thành

Bạn đã hoàn thành phần kiểm thử Dashboard và Alert.

Kết quả của phần này xác nhận rằng hệ thống AWS CloudSOC không chỉ có thể xử lý incident tự động, mà còn có thể hiển thị trạng thái trên dashboard và gửi cảnh báo đến SOC Analyst qua Email, Slack và CloudWatch Alarm.

Đây là bước kiểm thử cuối cùng trong phần **5.5 Testing and Validation**, giúp xác nhận toàn bộ luồng CloudSOC đã hoạt động từ phát hiện, xử lý, lưu evidence đến cảnh báo.