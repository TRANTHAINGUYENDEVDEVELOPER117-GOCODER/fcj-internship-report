---
title : "Notification and Alerting"
date : 2026-07-01
weight : 7
chapter : false
pre : " <b> 5.4.7. </b> "
---

#### Notification and Alerting

Trong pháº§n nÃ y, chÃºng ta sáº½ triá»ƒn khai lá»›p **Notification and Alerting** cho há»‡ thá»‘ng AWS CloudSOC. ÄÃ¢y lÃ  lá»›p chá»‹u trÃ¡ch nhiá»‡m gá»­i thÃ´ng bÃ¡o khi cÃ³ incident, khi Lambda xá»­ lÃ½ xong, hoáº·c khi há»‡ thá»‘ng pháº£n á»©ng sá»± cá»‘ gáº·p lá»—i.

á»ž cÃ¡c pháº§n trÆ°á»›c, há»‡ thá»‘ng Ä‘Ã£ cÃ³ kháº£ nÄƒng phÃ¡t hiá»‡n finding, Ä‘iá»u phá»‘i workflow, thu tháº­p evidence, táº¡o snapshot vÃ  cÃ´ láº­p EC2. Tuy nhiÃªn, má»™t há»‡ thá»‘ng SOC khÃ´ng chá»‰ xá»­ lÃ½ sá»± cá»‘ mÃ  cÃ²n pháº£i thÃ´ng bÃ¡o ká»‹p thá»i cho SOC Analyst hoáº·c Ä‘á»™i váº­n hÃ nh.

Luá»“ng thÃ´ng bÃ¡o chÃ­nh trong pháº§n nÃ y:

```text
Incident Response Lambda
â†’ Amazon SNS Topic
â†’ Email / SMS / Slack
```

NgoÃ i ra, CloudWatch Alarm cÅ©ng cÃ³ thá»ƒ gá»­i cáº£nh bÃ¡o khi Lambda gáº·p lá»—i:

```text
CloudWatch Alarm
â†’ Amazon SNS Topic
â†’ Email / SMS / Slack
```

---

#### Má»¥c tiÃªu

Sau khi hoÃ n thÃ nh pháº§n nÃ y, báº¡n sáº½ cÃ³:

+ SNS Topic dÃ¹ng Ä‘á»ƒ gá»­i cáº£nh bÃ¡o CloudSOC.
+ Email subscription Ä‘á»ƒ nháº­n thÃ´ng bÃ¡o incident.
+ Lambda Ä‘Æ°á»£c cáº­p nháº­t Ä‘á»ƒ publish káº¿t quáº£ xá»­ lÃ½ incident lÃªn SNS.
+ CloudWatch Alarm theo dÃµi lá»—i cá»§a Incident Response Lambda.
+ Cáº£nh bÃ¡o khi Lambda execution bá»‹ lá»—i.
+ Tuá»³ chá»n tÃ­ch há»£p Slack thÃ´ng qua Amazon Q Developer in chat applications.
+ áº¢nh chá»©ng minh há»‡ thá»‘ng Ä‘Ã£ gá»­i notification thÃ nh cÃ´ng.

---

#### Notification and Alerting Architecture

SÆ¡ Ä‘á»“ sau minh há»a luá»“ng thÃ´ng bÃ¡o cá»§a AWS CloudSOC.

![Notification and Alerting Architecture](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.7-Notification-And-Alerting/notification-alerting-architecture.png)

Luá»“ng xá»­ lÃ½ chÃ­nh:

```text
Incident Response Lambda
â†’ Amazon SNS
â†’ Email / SMS / Slack
```

Luá»“ng cáº£nh bÃ¡o lá»—i:

```text
CloudWatch Metrics
â†’ CloudWatch Alarm
â†’ Amazon SNS
â†’ Email / SMS / Slack
```

Trong kiáº¿n trÃºc nÃ y, Amazon SNS Ä‘Ã³ng vai trÃ² trung tÃ¢m phÃ¢n phá»‘i thÃ´ng bÃ¡o. Lambda gá»­i káº¿t quáº£ pháº£n á»©ng sá»± cá»‘ Ä‘áº¿n SNS, cÃ²n CloudWatch Alarm gá»­i cáº£nh bÃ¡o khi Lambda cÃ³ lá»—i.

---

#### ThÃ´ng tin cáº¥u hÃ¬nh Ä‘á» xuáº¥t

| ThÃ nh pháº§n | GiÃ¡ trá»‹ Ä‘á» xuáº¥t |
|---|---|
| SNS Topic | `cloudsoc-incident-alerts` |
| SNS Display name | `CloudSOCAlert` |
| Email subscription | Email cá»§a SOC Analyst |
| Lambda Function | `cloudsoc-incident-response-lambda` |
| Lambda Environment Variable | `SNS_TOPIC_ARN` |
| CloudWatch Alarm | `cloudsoc-incident-response-lambda-errors` |
| Alarm metric | Lambda Errors |
| Alarm condition | Errors >= 1 |
| Slack integration | Optional |

---

#### BÆ°á»›c 1: Táº¡o SNS Topic

VÃ o:

```text
Amazon SNS â†’ Topics â†’ Create topic
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Type | Standard |
| Name | `cloudsoc-incident-alerts` |
| Display name | `CloudSOCAlert` |

Sau Ä‘Ã³ chá»n:

```text
Create topic
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
SNS Topic cloudsoc-incident-alerts Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![Create SNS Topic](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.7-Notification-And-Alerting/create-sns-topic.png)

---

#### BÆ°á»›c 2: Táº¡o Email Subscription

Trong topic:

```text
cloudsoc-incident-alerts
```

chá»n:

```text
Create subscription
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Topic ARN | ARN cá»§a `cloudsoc-incident-alerts` |
| Protocol | Email |
| Endpoint | Email cá»§a SOC Analyst |

Sau Ä‘Ã³ chá»n:

```text
Create subscription
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
Email subscription Ä‘Æ°á»£c táº¡o vÃ  Ä‘ang á»Ÿ tráº¡ng thÃ¡i Pending confirmation.
```

![SNS Email Subscription](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.7-Notification-And-Alerting/sns-email-subscription.png)

---

#### BÆ°á»›c 3: Confirm Email Subscription

Má»Ÿ email nháº­n Ä‘Æ°á»£c tá»« AWS Notifications.

Chá»n:

```text
Confirm subscription
```

Sau khi xÃ¡c nháº­n, quay láº¡i SNS topic vÃ  kiá»ƒm tra tráº¡ng thÃ¡i subscription.

Káº¿t quáº£ mong Ä‘á»£i:

```text
Subscription status chuyá»ƒn tá»« Pending confirmation sang Confirmed.
```

![SNS Subscription Confirmed](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.7-Notification-And-Alerting/sns-subscription-confirmed.png)

---

#### BÆ°á»›c 4: Gá»­i Test Message tá»« SNS

Trong SNS topic:

```text
cloudsoc-incident-alerts
```

chá»n:

```text
Publish message
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Subject | `AWS CloudSOC Test Alert` |
| Message body | `This is a test notification from AWS CloudSOC.` |

Sau Ä‘Ã³ chá»n:

```text
Publish message
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
SOC Analyst nháº­n Ä‘Æ°á»£c email test alert tá»« SNS.
```

![SNS Test Message](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.7-Notification-And-Alerting/sns-test-message.png)

![Email Alert Received](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.7-Notification-And-Alerting/email-alert-received.png)

---

#### BÆ°á»›c 5: ThÃªm SNS Permission cho Incident Response Lambda Role

Lambda cáº§n quyá»n publish message Ä‘áº¿n SNS topic.

VÃ o:

```text
IAM â†’ Roles â†’ CloudSOC-Incident-Response-Lambda-Role
```

Chá»n:

```text
Add permissions â†’ Create inline policy
```

Chá»n tab:

```text
JSON
```

ThÃªm policy sau. Thay `<account-id>` báº±ng AWS Account ID cá»§a báº¡n.

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

Äáº·t tÃªn policy:

```text
CloudSOC-SNS-Publish-Policy
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
Incident Response Lambda Role cÃ³ quyá»n publish message Ä‘áº¿n SNS.
```

![Lambda SNS Permission](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.7-Notification-And-Alerting/lambda-sns-permission.png)

---

#### BÆ°á»›c 6: ThÃªm SNS Topic ARN vÃ o Lambda Environment Variables

VÃ o:

```text
Lambda â†’ cloudsoc-incident-response-lambda
â†’ Configuration â†’ Environment variables â†’ Edit
```

ThÃªm biáº¿n mÃ´i trÆ°á»ng:

| Key | Value |
|---|---|
| `SNS_TOPIC_ARN` | ARN cá»§a SNS topic `cloudsoc-incident-alerts` |

VÃ­ dá»¥:

```text
SNS_TOPIC_ARN = arn:aws:sns:ap-southeast-1:123456789012:cloudsoc-incident-alerts
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
Lambda biáº¿t SNS Topic cáº§n gá»­i notification.
```

![Lambda SNS Environment Variable](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.7-Notification-And-Alerting/lambda-sns-environment-variable.png)

---

#### BÆ°á»›c 7: Cáº­p nháº­t Lambda Ä‘á»ƒ gá»­i SNS Notification

Trong Lambda function:

```text
cloudsoc-incident-response-lambda
```

má»Ÿ tab:

```text
Code
```

ThÃªm import vÃ  biáº¿n SNS vÃ o Ä‘áº§u file:

```python
sns = boto3.client("sns", region_name=REGION)
SNS_TOPIC_ARN = os.environ.get("SNS_TOPIC_ARN")
```

ThÃªm function gá»­i notification:

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

Sau Ä‘Ã³, trong pháº§n cuá»‘i cá»§a `lambda_handler`, trÆ°á»›c dÃ²ng:

```python
return result
```

thÃªm Ä‘oáº¡n sau:

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

Sau khi chá»‰nh code, chá»n:

```text
Deploy
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
Lambda cÃ³ thá»ƒ gá»­i notification sau khi xá»­ lÃ½ incident.
```

![Lambda SNS Publish Code](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.7-Notification-And-Alerting/lambda-sns-publish-code.png)

---

#### BÆ°á»›c 8: Test Lambda Notification

VÃ o tab:

```text
Test
```

Cháº¡y láº¡i test event:

```text
gd-ec2-test
```

Káº¿t quáº£ mong Ä‘á»£i trong Lambda response:

```text
notificationMessageId
incidentStatus = Isolated
approvalStatus = Approved
responseMode = AutoResponse
```

![Lambda SNS Test Result](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.7-Notification-And-Alerting/lambda-sns-test-result.png)

Sau Ä‘Ã³ kiá»ƒm tra email.

Email nháº­n Ä‘Æ°á»£c nÃªn cÃ³ ná»™i dung tÆ°Æ¡ng tá»±:

```text
AWS CloudSOC Incident Response Completed

Incident ID: INC-sample-finding-001
Finding Type: UnauthorizedAccess:EC2/SSHBruteForce
Severity: 8.5
Resource ID: i-xxxxxxxxxxxxxxxxx
Response Mode: AutoResponse
Incident Status: Isolated
```

![Incident Email Notification](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.7-Notification-And-Alerting/incident-email-notification.png)

---

#### BÆ°á»›c 9: Táº¡o CloudWatch Alarm cho Lambda Errors

CloudWatch Alarm giÃºp cáº£nh bÃ¡o khi Lambda xá»­ lÃ½ incident bá»‹ lá»—i.

VÃ o:

```text
CloudWatch â†’ Alarms â†’ All alarms â†’ Create alarm
```

Chá»n metric:

```text
Lambda â†’ By Function Name â†’ cloudsoc-incident-response-lambda â†’ Errors
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Metric | `Errors` |
| Statistic | Sum |
| Period | 1 minute |
| Condition | Greater/Equal |
| Threshold | 1 |

Cáº¥u hÃ¬nh notification:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Alarm state trigger | In alarm |
| SNS topic | `cloudsoc-incident-alerts` |

Äáº·t tÃªn alarm:

```text
cloudsoc-incident-response-lambda-errors
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
CloudWatch Alarm Ä‘Æ°á»£c táº¡o Ä‘á»ƒ theo dÃµi lá»—i cá»§a Incident Response Lambda.
```

![Create Lambda Error Alarm](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.7-Notification-And-Alerting/create-lambda-error-alarm.png)

---

#### BÆ°á»›c 10: Kiá»ƒm tra Alarm Notification

Äá»ƒ kiá»ƒm tra alarm, cÃ³ thá»ƒ táº¡o má»™t láº§n lá»—i cÃ³ kiá»ƒm soÃ¡t báº±ng cÃ¡ch cháº¡y Lambda vá»›i test event thiáº¿u `instanceId`.

VÃ­ dá»¥ test event lá»—i:

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

Khi Lambda bá»‹ lá»—i, CloudWatch sáº½ ghi nháº­n metric `Errors`. Sau má»™t thá»i gian ngáº¯n, alarm sáº½ chuyá»ƒn sang tráº¡ng thÃ¡i:

```text
In alarm
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
SOC Analyst nháº­n Ä‘Æ°á»£c email cáº£nh bÃ¡o khi Incident Response Lambda cÃ³ lá»—i.
```

![CloudWatch Alarm In Alarm](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.7-Notification-And-Alerting/cloudwatch-alarm-in-alarm.png)

![Alarm Email Notification](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.7-Notification-And-Alerting/alarm-email-notification.png)

---

#### BÆ°á»›c 11: Optional - TÃ­ch há»£p Slack báº±ng Amazon Q Developer in chat applications

NgoÃ i email, há»‡ thá»‘ng cÃ³ thá»ƒ gá»­i cáº£nh bÃ¡o Ä‘áº¿n Slack thÃ´ng qua Amazon Q Developer in chat applications.

Luá»“ng tÃ­ch há»£p:

```text
Amazon SNS
â†’ Amazon Q Developer in chat applications
â†’ Slack Channel
```

CÃ¡c bÆ°á»›c tá»•ng quÃ¡t:

```text
Amazon Q Developer in chat applications
â†’ Configure Slack workspace
â†’ Configure Slack channel
â†’ Subscribe SNS topic
â†’ Test notification
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
Incident alert Ä‘Æ°á»£c gá»­i Ä‘áº¿n Slack channel cá»§a SOC team.
```

![Slack Channel Configuration](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.7-Notification-And-Alerting/slack-channel-configuration.png)

![Slack Incident Alert](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.7-Notification-And-Alerting/slack-incident-alert.png)

> **Note:** Slack integration is optional for this lab. Email notification is enough to demonstrate the notification flow.

---

#### BÆ°á»›c 12: Kiá»ƒm tra DynamoDB sau khi gá»­i Notification

VÃ o:

```text
DynamoDB â†’ Tables â†’ CloudSOC-IncidentTable â†’ Explore table items
```

Kiá»ƒm tra incident má»›i nháº¥t.

Náº¿u báº¡n Ä‘Ã£ thÃªm `notificationMessageId` vÃ o result, DynamoDB cÃ³ thá»ƒ lÆ°u thÃªm thÃ´ng tin notification trong incident record.

CÃ¡c trÆ°á»ng cáº§n kiá»ƒm tra:

```text
incidentStatus = Isolated
approvalStatus = Approved
notificationMessageId = <sns-message-id>
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
Incident record thá»ƒ hiá»‡n ráº±ng response action Ä‘Ã£ hoÃ n táº¥t vÃ  notification Ä‘Ã£ Ä‘Æ°á»£c gá»­i.
```

![DynamoDB Notification Updated](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.7-Notification-And-Alerting/dynamodb-notification-updated.png)

---

#### Kiá»ƒm tra sau khi hoÃ n thÃ nh

Sau khi hoÃ n thÃ nh pháº§n nÃ y, kiá»ƒm tra láº¡i cÃ¡c má»¥c sau:

- [ ] SNS Topic `cloudsoc-incident-alerts` Ä‘Ã£ Ä‘Æ°á»£c táº¡o.
- [ ] Email subscription Ä‘Ã£ Ä‘Æ°á»£c confirm.
- [ ] SNS test message Ä‘Æ°á»£c gá»­i thÃ nh cÃ´ng.
- [ ] Incident Response Lambda cÃ³ quyá»n `sns:Publish`.
- [ ] Lambda cÃ³ environment variable `SNS_TOPIC_ARN`.
- [ ] Lambda gá»­i notification sau khi xá»­ lÃ½ incident.
- [ ] Email nháº­n Ä‘Æ°á»£c incident alert.
- [ ] CloudWatch Alarm theo dÃµi Lambda Errors.
- [ ] Alarm gá»­i notification khi Lambda bá»‹ lá»—i.
- [ ] Slack integration Ä‘Æ°á»£c cáº¥u hÃ¬nh náº¿u workshop yÃªu cáº§u.

---

#### Káº¿t quáº£ sau khi hoÃ n thÃ nh

Sau khi hoÃ n thÃ nh pháº§n nÃ y, AWS CloudSOC Ä‘Ã£ cÃ³ kháº£ nÄƒng gá»­i cáº£nh bÃ¡o khi cÃ³ incident vÃ  khi há»‡ thá»‘ng pháº£n á»©ng sá»± cá»‘ gáº·p lá»—i.

CÃ¡c thÃ nh pháº§n Ä‘Ã£ sáºµn sÃ ng gá»“m:

```text
Amazon SNS
Email Subscription
Incident Response Lambda Notification
CloudWatch Alarm
Optional Slack Notification
```

Quy trÃ¬nh tá»•ng thá»ƒ sau khi hoÃ n thÃ nh pháº§n nÃ y:

```text
GuardDuty Finding
â†’ EventBridge
â†’ Step Functions
â†’ Incident Response Lambda
â†’ Forensics / Snapshot / Isolation
â†’ SNS Notification
â†’ SOC Analyst
```

---

#### TÃ³m táº¯t

Trong pháº§n nÃ y, chÃºng ta Ä‘Ã£ triá»ƒn khai lá»›p Notification and Alerting cho AWS CloudSOC. Amazon SNS Ä‘Æ°á»£c sá»­ dá»¥ng lÃ m trung tÃ¢m gá»­i thÃ´ng bÃ¡o, Email giÃºp SOC Analyst nháº­n cáº£nh bÃ¡o nhanh, CloudWatch Alarm giÃºp phÃ¡t hiá»‡n lá»—i trong Lambda, vÃ  Slack cÃ³ thá»ƒ Ä‘Æ°á»£c tÃ­ch há»£p thÃªm náº¿u cáº§n má»Ÿ rá»™ng kÃªnh cáº£nh bÃ¡o.

Sau pháº§n nÃ y, quy trÃ¬nh triá»ƒn khai chÃ­nh cá»§a CloudSOC Ä‘Ã£ hoÃ n táº¥t. á»ž pháº§n tiáº¿p theo, chÃºng ta sáº½ chuyá»ƒn sang **Testing and Validation** Ä‘á»ƒ kiá»ƒm tra toÃ n bá»™ luá»“ng phÃ¡t hiá»‡n, pháº£n á»©ng, lÆ°u evidence, cÃ´ láº­p EC2 vÃ  gá»­i notification.