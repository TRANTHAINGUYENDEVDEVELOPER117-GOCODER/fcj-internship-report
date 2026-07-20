---
title : "Notification and Alerting"
date : 2026-07-01
weight : 7
chapter : false
pre : " <b> 5.4.7. </b> "
---

#### Notification and Alerting

Trong phần này, chúng ta sẽ triển khai lớp **Notification and Alerting** cho hệ thống AWS CloudSOC. Đây là lớp chịu trách nhiệm gửi thông báo khi có incident, khi Lambda xử lý xong, hoặc khi hệ thống phản ứng sự cố gặp lỗi.

Ở các phần trước, hệ thống đã có khả năng phát hiện finding, điều phối workflow, thu thập evidence, tạo snapshot và cô lập EC2. Tuy nhiên, một hệ thống SOC không chỉ xử lý sự cố mà còn phải thông báo kịp thời cho SOC Analyst hoặc đội vận hành.

Luồng thông báo chính trong phần này:

```text
Incident Response Lambda
→ Amazon SNS Topic
→ Email / SMS / Slack
```

Ngoài ra, CloudWatch Alarm cũng có thể gửi cảnh báo khi Lambda gặp lỗi:

```text
CloudWatch Alarm
→ Amazon SNS Topic
→ Email / SMS / Slack
```

---

#### Mục tiêu

Sau khi hoàn thành phần này, bạn sẽ có:

+ SNS Topic dùng để gửi cảnh báo CloudSOC.
+ Email subscription để nhận thông báo incident.
+ Lambda được cập nhật để publish kết quả xử lý incident lên SNS.
+ CloudWatch Alarm theo dõi lỗi của Incident Response Lambda.
+ Cảnh báo khi Lambda execution bị lỗi.
+ Tuỳ chọn tích hợp Slack thông qua Amazon Q Developer in chat applications.
+ Ảnh chứng minh hệ thống đã gửi notification thành công.

---

#### Notification and Alerting Architecture

Sơ đồ sau minh họa luồng thông báo của AWS CloudSOC.

![Notification and Alerting Architecture](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/notification-alerting-architecture.png)

Luồng xử lý chính:

```text
Incident Response Lambda
→ Amazon SNS
→ Email / SMS / Slack
```

Luồng cảnh báo lỗi:

```text
CloudWatch Metrics
→ CloudWatch Alarm
→ Amazon SNS
→ Email / SMS / Slack
```

Trong kiến trúc này, Amazon SNS đóng vai trò trung tâm phân phối thông báo. Lambda gửi kết quả phản ứng sự cố đến SNS, còn CloudWatch Alarm gửi cảnh báo khi Lambda có lỗi.

---

#### Thông tin cấu hình đề xuất

| Thành phần | Giá trị đề xuất |
|---|---|
| SNS Topic | `cloudsoc-incident-alerts` |
| SNS Display name | `CloudSOCAlert` |
| Email subscription | Email của SOC Analyst |
| Lambda Function | `cloudsoc-incident-response-lambda` |
| Lambda Environment Variable | `SNS_TOPIC_ARN` |
| CloudWatch Alarm | `cloudsoc-incident-response-lambda-errors` |
| Alarm metric | Lambda Errors |
| Alarm condition | Errors >= 1 |
| Slack integration | Optional |

---

#### Bước 1: Tạo SNS Topic

Vào:

```text
Amazon SNS → Topics → Create topic
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Type | Standard |
| Name | `cloudsoc-incident-alerts` |
| Display name | `CloudSOCAlert` |

Sau đó chọn:

```text
Create topic
```

Kết quả mong đợi:

```text
SNS Topic cloudsoc-incident-alerts được tạo thành công.
```

![Create SNS Topic](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/create-sns-topic.png)

---

#### Bước 2: Tạo Email Subscription

Trong topic:

```text
cloudsoc-incident-alerts
```

chọn:

```text
Create subscription
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Topic ARN | ARN của `cloudsoc-incident-alerts` |
| Protocol | Email |
| Endpoint | Email của SOC Analyst |

Sau đó chọn:

```text
Create subscription
```

Kết quả mong đợi:

```text
Email subscription được tạo và đang ở trạng thái Pending confirmation.
```

![SNS Email Subscription](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/sns-email-subscription.png)

---

#### Bước 3: Confirm Email Subscription

Mở email nhận được từ AWS Notifications.

Chọn:

```text
Confirm subscription
```

Sau khi xác nhận, quay lại SNS topic và kiểm tra trạng thái subscription.

Kết quả mong đợi:

```text
Subscription status chuyển từ Pending confirmation sang Confirmed.
```

![SNS Subscription Confirmed](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/sns-subscription-confirmed.png)

---

#### Bước 4: Gửi Test Message từ SNS

Trong SNS topic:

```text
cloudsoc-incident-alerts
```

chọn:

```text
Publish message
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Subject | `AWS CloudSOC Test Alert` |
| Message body | `This is a test notification from AWS CloudSOC.` |

Sau đó chọn:

```text
Publish message
```

Kết quả mong đợi:

```text
SOC Analyst nhận được email test alert từ SNS.
```

![SNS Test Message](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/sns-test-message.png)

![Email Alert Received](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/email-alert-received.png)

---

#### Bước 5: Thêm SNS Permission cho Incident Response Lambda Role

Lambda cần quyền publish message đến SNS topic.

Vào:

```text
IAM → Roles → CloudSOC-Incident-Response-Lambda-Role
```

Chọn:

```text
Add permissions → Create inline policy
```

Chọn tab:

```text
JSON
```

Thêm policy sau. Thay `<account-id>` bằng AWS Account ID của bạn.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "SNSPublishIncidentAlerts",
      "Effect": "Allow",
      "Action": [
        "sns:Publish"
      ],
      "Resource": "arn:aws:sns:ap-southeast-1:<account-id>:cloudsoc-incident-alerts"
    }
  ]
}
```

Đặt tên policy:

```text
CloudSOC-SNS-Publish-Policy
```

Kết quả mong đợi:

```text
Incident Response Lambda Role có quyền publish message đến SNS.
```

![Lambda SNS Permission](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/lambda-sns-permission.png)

---

#### Bước 6: Thêm SNS Topic ARN vào Lambda Environment Variables

Vào:

```text
Lambda → cloudsoc-incident-response-lambda
→ Configuration → Environment variables → Edit
```

Thêm biến môi trường:

| Key | Value |
|---|---|
| `SNS_TOPIC_ARN` | ARN của SNS topic `cloudsoc-incident-alerts` |

Ví dụ:

```text
SNS_TOPIC_ARN = arn:aws:sns:ap-southeast-1:123456789012:cloudsoc-incident-alerts
```

Kết quả mong đợi:

```text
Lambda biết SNS Topic cần gửi notification.
```

![Lambda SNS Environment Variable](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/lambda-sns-environment-variable.png)

---

#### Bước 7: Cập nhật Lambda để gửi SNS Notification

Trong Lambda function:

```text
cloudsoc-incident-response-lambda
```

mở tab:

```text
Code
```

Thêm import và biến SNS vào đầu file:

```python
sns = boto3.client("sns", region_name=REGION)
SNS_TOPIC_ARN = os.environ.get("SNS_TOPIC_ARN")
```

Thêm function gửi notification:

```python
def publish_notification(subject, message):
    if not SNS_TOPIC_ARN:
        print("SNS_TOPIC_ARN is not configured. Skipping notification.")
        return None

    response = sns.publish(
        TopicArn=SNS_TOPIC_ARN,
        Subject=subject,
        Message=message
    )

    return response.get("MessageId")
```

Sau đó, trong phần cuối của `lambda_handler`, trước dòng:

```python
return result
```

thêm đoạn sau:

```python
notification_message = f"""
AWS CloudSOC Incident Response Completed

Incident ID: {incident_id}
Finding Type: {finding_type}
Severity: {severity}
Resource ID: {instance_id}
Response Mode: AutoResponse
Incident Status: Isolated
Isolation Security Group: {ISOLATION_SG_ID}
SSM Command ID: {ssm_command_id}
Snapshot IDs: {snapshot_ids}
Evidence Path: {raw_event_s3_path}

The affected EC2 instance has been isolated and forensic evidence has been collected.
"""

message_id = publish_notification(
    subject="AWS CloudSOC Incident Isolated",
    message=notification_message
)

result["notificationMessageId"] = message_id
```

Sau khi chỉnh code, chọn:

```text
Deploy
```

Kết quả mong đợi:

```text
Lambda có thể gửi notification sau khi xử lý incident.
```

![Lambda SNS Publish Code](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/lambda-sns-publish-code.png)

---

#### Bước 8: Test Lambda Notification

Vào tab:

```text
Test
```

Chạy lại test event:

```text
gd-ec2-test
```

Kết quả mong đợi trong Lambda response:

```text
notificationMessageId
incidentStatus = Isolated
approvalStatus = Approved
responseMode = AutoResponse
```

![Lambda SNS Test Result](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/lambda-sns-test-result.png)

Sau đó kiểm tra email.

Email nhận được nên có nội dung tương tự:

```text
AWS CloudSOC Incident Response Completed

Incident ID: INC-sample-finding-001
Finding Type: UnauthorizedAccess:EC2/SSHBruteForce
Severity: 8.5
Resource ID: i-xxxxxxxxxxxxxxxxx
Response Mode: AutoResponse
Incident Status: Isolated
```

![Incident Email Notification](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/incident-email-notification.png)

---

#### Bước 9: Tạo CloudWatch Alarm cho Lambda Errors

CloudWatch Alarm giúp cảnh báo khi Lambda xử lý incident bị lỗi.

Vào:

```text
CloudWatch → Alarms → All alarms → Create alarm
```

Chọn metric:

```text
Lambda → By Function Name → cloudsoc-incident-response-lambda → Errors
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Metric | `Errors` |
| Statistic | Sum |
| Period | 1 minute |
| Condition | Greater/Equal |
| Threshold | 1 |

Cấu hình notification:

| Mục | Giá trị |
|---|---|
| Alarm state trigger | In alarm |
| SNS topic | `cloudsoc-incident-alerts` |

Đặt tên alarm:

```text
cloudsoc-incident-response-lambda-errors
```

Kết quả mong đợi:

```text
CloudWatch Alarm được tạo để theo dõi lỗi của Incident Response Lambda.
```

![Create Lambda Error Alarm](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/create-lambda-error-alarm.png)

---

#### Bước 10: Kiểm tra Alarm Notification

Để kiểm tra alarm, có thể tạo một lần lỗi có kiểm soát bằng cách chạy Lambda với test event thiếu `instanceId`.

Ví dụ test event lỗi:

```json
{
  "version": "0",
  "id": "sample-error-event",
  "detail-type": "GuardDuty Finding",
  "source": "aws.guardduty",
  "account": "123456789012",
  "region": "ap-southeast-1",
  "detail": {
    "id": "sample-error-finding",
    "severity": 8.5,
    "type": "UnauthorizedAccess:EC2/SSHBruteForce",
    "title": "Sample error finding",
    "resource": {
      "resourceType": "Instance",
      "instanceDetails": {}
    }
  }
}
```

Khi Lambda bị lỗi, CloudWatch sẽ ghi nhận metric `Errors`. Sau một thời gian ngắn, alarm sẽ chuyển sang trạng thái:

```text
In alarm
```

Kết quả mong đợi:

```text
SOC Analyst nhận được email cảnh báo khi Incident Response Lambda có lỗi.
```

![CloudWatch Alarm In Alarm](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/cloudwatch-alarm-in-alarm.png)

![Alarm Email Notification](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/alarm-email-notification.png)

---

#### Bước 11: Optional - Tích hợp Slack bằng Amazon Q Developer in chat applications

Ngoài email, hệ thống có thể gửi cảnh báo đến Slack thông qua Amazon Q Developer in chat applications.

Luồng tích hợp:

```text
Amazon SNS
→ Amazon Q Developer in chat applications
→ Slack Channel
```

Các bước tổng quát:

```text
Amazon Q Developer in chat applications
→ Configure Slack workspace
→ Configure Slack channel
→ Subscribe SNS topic
→ Test notification
```

Kết quả mong đợi:

```text
Incident alert được gửi đến Slack channel của SOC team.
```

![Slack Channel Configuration](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/slack-channel-configuration.png)

![Slack Incident Alert](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/slack-incident-alert.png)

> **Note:** Slack integration is optional for this lab. Email notification is enough to demonstrate the notification flow.

---

#### Bước 12: Kiểm tra DynamoDB sau khi gửi Notification

Vào:

```text
DynamoDB → Tables → CloudSOC-IncidentTable → Explore table items
```

Kiểm tra incident mới nhất.

Nếu bạn đã thêm `notificationMessageId` vào result, DynamoDB có thể lưu thêm thông tin notification trong incident record.

Các trường cần kiểm tra:

```text
incidentStatus = Isolated
approvalStatus = Approved
notificationMessageId = <sns-message-id>
```

Kết quả mong đợi:

```text
Incident record thể hiện rằng response action đã hoàn tất và notification đã được gửi.
```

![DynamoDB Notification Updated](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/dynamodb-notification-updated.png)

---

#### Kiểm tra sau khi hoàn thành

Sau khi hoàn thành phần này, kiểm tra lại các mục sau:

- [ ] SNS Topic `cloudsoc-incident-alerts` đã được tạo.
- [ ] Email subscription đã được confirm.
- [ ] SNS test message được gửi thành công.
- [ ] Incident Response Lambda có quyền `sns:Publish`.
- [ ] Lambda có environment variable `SNS_TOPIC_ARN`.
- [ ] Lambda gửi notification sau khi xử lý incident.
- [ ] Email nhận được incident alert.
- [ ] CloudWatch Alarm theo dõi Lambda Errors.
- [ ] Alarm gửi notification khi Lambda bị lỗi.
- [ ] Slack integration được cấu hình nếu workshop yêu cầu.

---

#### Kết quả sau khi hoàn thành

Sau khi hoàn thành phần này, AWS CloudSOC đã có khả năng gửi cảnh báo khi có incident và khi hệ thống phản ứng sự cố gặp lỗi.

Các thành phần đã sẵn sàng gồm:

```text
Amazon SNS
Email Subscription
Incident Response Lambda Notification
CloudWatch Alarm
Optional Slack Notification
```

Quy trình tổng thể sau khi hoàn thành phần này:

```text
GuardDuty Finding
→ EventBridge
→ Step Functions
→ Incident Response Lambda
→ Forensics / Snapshot / Isolation
→ SNS Notification
→ SOC Analyst
```

---

#### Tóm tắt

Trong phần này, chúng ta đã triển khai lớp Notification and Alerting cho AWS CloudSOC. Amazon SNS được sử dụng làm trung tâm gửi thông báo, Email giúp SOC Analyst nhận cảnh báo nhanh, CloudWatch Alarm giúp phát hiện lỗi trong Lambda, và Slack có thể được tích hợp thêm nếu cần mở rộng kênh cảnh báo.

Sau phần này, quy trình triển khai chính của CloudSOC đã hoàn tất. Ở phần tiếp theo, chúng ta sẽ chuyển sang **Testing and Validation** để kiểm tra toàn bộ luồng phát hiện, phản ứng, lưu evidence, cô lập EC2 và gửi notification.