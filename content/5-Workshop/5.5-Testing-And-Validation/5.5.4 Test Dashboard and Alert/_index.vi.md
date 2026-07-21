---
title : "Kiá»ƒm thá»­ Dashboard vÃ  Alert"
date : 2026-07-01
weight : 4
chapter : false
pre : " <b> 5.5.4. </b> "
---

#### Kiá»ƒm thá»­ Dashboard vÃ  Alert

Trong pháº§n nÃ y, chÃºng ta sáº½ kiá»ƒm thá»­ kháº£ nÄƒng hiá»ƒn thá»‹ incident trÃªn **SOC Dashboard** vÃ  kháº£ nÄƒng gá»­i cáº£nh bÃ¡o qua **Amazon SNS**, **Email** vÃ  **Slack**.

Sau khi há»‡ thá»‘ng CloudSOC phÃ¡t hiá»‡n vÃ  xá»­ lÃ½ incident, SOC Analyst cáº§n cÃ³ kháº£ nÄƒng theo dÃµi tráº¡ng thÃ¡i incident trÃªn dashboard vÃ  nháº­n cáº£nh bÃ¡o ká»‹p thá»i qua cÃ¡c kÃªnh notification.

Luá»“ng tá»•ng quan:

```text
Incident Response Lambda
â†’ DynamoDB Incident Table
â†’ SOC Dashboard

Incident Response Lambda
â†’ Amazon SNS
â†’ Email / Slack
â†’ SOC Analyst

CloudWatch Alarm
â†’ Amazon SNS
â†’ Email / Slack
```

Pháº§n kiá»ƒm thá»­ nÃ y xÃ¡c nháº­n ráº±ng dashboard vÃ  alerting layer hoáº¡t Ä‘á»™ng Ä‘Ãºng sau khi incident Ä‘Æ°á»£c xá»­ lÃ½.

---

#### Má»¥c tiÃªu kiá»ƒm thá»­

Sau khi hoÃ n thÃ nh pháº§n nÃ y, chÃºng ta cÃ³ thá»ƒ xÃ¡c nháº­n ráº±ng:

+ SOC Dashboard hiá»ƒn thá»‹ Ä‘Æ°á»£c danh sÃ¡ch incident.
+ Dashboard cáº­p nháº­t tráº¡ng thÃ¡i incident sau khi há»‡ thá»‘ng xá»­ lÃ½.
+ DynamoDB lÆ°u Ä‘Æ°á»£c thÃ´ng tin notification.
+ SNS Topic cÃ³ subscription hoáº¡t Ä‘á»™ng.
+ Email nháº­n Ä‘Æ°á»£c incident alert.
+ Slack nháº­n Ä‘Æ°á»£c incident alert thÃ´ng qua Amazon Q Developer in chat applications.
+ CloudWatch Alarm cÃ³ thá»ƒ gá»­i cáº£nh bÃ¡o lá»—i vá» SNS.

---

#### Kiáº¿n trÃºc kiá»ƒm thá»­

SÆ¡ Ä‘á»“ dÆ°á»›i Ä‘Ã¢y mÃ´ táº£ luá»“ng kiá»ƒm thá»­ Dashboard vÃ  Alert.

![Test Dashboard and Alert Flow](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-Test-Dashboard-And-Alert/test-dashboard-alert-flow.png)

Luá»“ng kiá»ƒm thá»­ gá»“m hai nhÃ¡nh chÃ­nh:

```text
Dashboard Validation:
DynamoDB Incident Table
â†’ Dashboard API Lambda
â†’ API Gateway
â†’ Amplify Dashboard
â†’ SOC Analyst

Alert Validation:
Incident Response Lambda / CloudWatch Alarm
â†’ Amazon SNS
â†’ Email / Slack
â†’ SOC Analyst
```

---

#### BÆ°á»›c 1: Kiá»ƒm tra dashboard trÆ°á»›c khi nháº­n alert má»›i

Äáº§u tiÃªn, má»Ÿ SOC Dashboard Ä‘Ã£ triá»ƒn khai báº±ng AWS Amplify.

Dashboard sá»­ dá»¥ng trong lab:

```text
AWS CloudSOC Dashboard
```

Dashboard cáº§n hiá»ƒn thá»‹ cÃ¡c thÃ´ng tin tá»•ng quan nhÆ°:

```text
Total Incidents
Pending Approval
Critical Findings
Incident List
```

![Dashboard Before Alert Test](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-Test-Dashboard-And-Alert/dashboard-before-alert-test.png)

á»ž bÆ°á»›c nÃ y, dashboard Ä‘Ã³ng vai trÃ² lÃ  giao diá»‡n theo dÃµi incident cho SOC Analyst.

---

#### BÆ°á»›c 2: Kiá»ƒm tra incident Ä‘Ã£ Ä‘Æ°á»£c xá»­ lÃ½ trÃªn dashboard

Sau khi pháº§n **5.5.3 Test Auto Isolation** hoÃ n thÃ nh, incident Ä‘Ã£ Ä‘Æ°á»£c xá»­ lÃ½ bá»Ÿi Incident Response Lambda.

Dashboard cáº§n hiá»ƒn thá»‹ tráº¡ng thÃ¡i má»›i cá»§a incident.

VÃ­ dá»¥ tráº¡ng thÃ¡i mong Ä‘á»£i:

```text
Incident ID: INC-sample-finding-001
Finding Type: UnauthorizedAccess:EC2/SSHBruteForce
Severity: 8.5
Response Mode: AutoResponse
Approval Status: Approved
Incident Status: Isolated
```

![Dashboard Isolated Incident](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-Test-Dashboard-And-Alert/dashboard-isolated-incident.png)

ThÃ´ng tin nÃ y xÃ¡c nháº­n ráº±ng dashboard cÃ³ thá»ƒ hiá»ƒn thá»‹ káº¿t quáº£ xá»­ lÃ½ incident sau khi auto isolation hoÃ n táº¥t.

---

#### BÆ°á»›c 3: Kiá»ƒm tra DynamoDB notification record

Sau khi Lambda xá»­ lÃ½ incident vÃ  gá»­i notification, DynamoDB Incident Table cáº§n lÆ°u láº¡i thÃ´ng tin liÃªn quan Ä‘áº¿n tráº¡ng thÃ¡i xá»­ lÃ½ vÃ  notification.

CÃ¡c trÆ°á»ng quan trá»ng cÃ³ thá»ƒ bao gá»“m:

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

TrÆ°á»ng `notificationMessageId` cho biáº¿t Lambda Ä‘Ã£ gá»i SNS publish thÃ nh cÃ´ng vÃ  SNS Ä‘Ã£ táº¡o message ID cho notification.

---

#### BÆ°á»›c 4: Kiá»ƒm tra SNS Topic vÃ  Subscriptions

Tiáº¿p theo, kiá»ƒm tra SNS Topic dÃ¹ng Ä‘á»ƒ gá»­i cáº£nh bÃ¡o.

SNS Topic trong lab:

```text
cloudsoc-incident-alerts
```

Topic nÃ y Ä‘Æ°á»£c sá»­ dá»¥ng Ä‘á»ƒ gá»­i incident alert Ä‘áº¿n Email vÃ  Slack.

![SNS Topic Subscriptions Validation](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-Test-Dashboard-And-Alert/sns-topic-subscriptions-validation.png)

Subscription cáº§n cÃ³ tráº¡ng thÃ¡i:

```text
Confirmed
```

CÃ¡c endpoint cÃ³ thá»ƒ bao gá»“m:

```text
Email subscription
Slack integration through Amazon Q Developer in chat applications
```

Äiá»u nÃ y xÃ¡c nháº­n ráº±ng SNS Topic Ä‘Ã£ sáºµn sÃ ng gá»­i cáº£nh bÃ¡o Ä‘áº¿n SOC Analyst.

---

#### BÆ°á»›c 5: Kiá»ƒm tra Email incident alert

Sau khi Incident Response Lambda publish message Ä‘áº¿n SNS, email subscription sáº½ nháº­n Ä‘Æ°á»£c incident alert.

Ná»™i dung email cÃ³ thá»ƒ bao gá»“m:

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

Email alert xÃ¡c nháº­n ráº±ng SOC Analyst cÃ³ thá»ƒ nháº­n thÃ´ng bÃ¡o sau khi incident Ä‘Æ°á»£c xá»­ lÃ½.

---

#### BÆ°á»›c 6: Kiá»ƒm tra Slack incident alert

NgoÃ i email, SNS cÅ©ng cÃ³ thá»ƒ gá»­i alert Ä‘áº¿n Slack thÃ´ng qua Amazon Q Developer in chat applications.

Slack channel sá»­ dá»¥ng trong lab:

```text
#cloudsoc-alerts
```

Sau khi SNS gá»­i message, Slack channel sáº½ hiá»ƒn thá»‹ notification tá»« AWS.

![Slack Incident Alert Validation](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-Test-Dashboard-And-Alert/slack-incident-alert-validation.png)

Slack alert giÃºp SOC Analyst nháº­n thÃ´ng bÃ¡o nhanh trong kÃªnh lÃ m viá»‡c nhÃ³m.

Ná»™i dung alert nÃªn thá»ƒ hiá»‡n Ä‘Æ°á»£c cÃ¡c thÃ´ng tin chÃ­nh:

```text
Incident ID
Finding Type
Severity
Resource ID
Incident Status
```

---

#### BÆ°á»›c 7: Kiá»ƒm tra CloudWatch Alarm

NgoÃ i incident alert, há»‡ thá»‘ng cÅ©ng cáº§n cáº£nh bÃ¡o khi Lambda pháº£n á»©ng sá»± cá»‘ gáº·p lá»—i.

CloudWatch Alarm Ä‘Æ°á»£c sá»­ dá»¥ng Ä‘á»ƒ theo dÃµi metric lá»—i cá»§a Lambda:

```text
Lambda Errors >= 1
```

Alarm trong lab:

```text
cloudsoc-incident-response-lambda-errors
```

![CloudWatch Alarm Dashboard](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-Test-Dashboard-And-Alert/cloudwatch-alarm-dashboard.png)

Alarm nÃ y giÃºp SOC Analyst biáº¿t khi Incident Response Lambda bá»‹ lá»—i vÃ  cáº§n kiá»ƒm tra láº¡i há»‡ thá»‘ng.

---

#### BÆ°á»›c 8: Kiá»ƒm tra alarm notification

Khi CloudWatch Alarm chuyá»ƒn sang tráº¡ng thÃ¡i `In alarm`, alarm sáº½ gá»­i notification Ä‘áº¿n SNS Topic.

Luá»“ng cáº£nh bÃ¡o lá»—i:

```text
CloudWatch Alarm
â†’ Amazon SNS
â†’ Email / Slack
â†’ SOC Analyst
```

![CloudWatch Alarm Notification](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-Test-Dashboard-And-Alert/cloudwatch-alarm-notification.png)

ThÃ´ng bÃ¡o alarm giÃºp SOC Analyst phÃ¡t hiá»‡n lá»—i trong quy trÃ¬nh pháº£n á»©ng sá»± cá»‘, vÃ­ dá»¥ Lambda error hoáº·c workflow failure.

---

#### BÆ°á»›c 9: Kiá»ƒm tra tráº¡ng thÃ¡i cuá»‘i cÃ¹ng trÃªn dashboard

Sau khi incident Ä‘Ã£ Ä‘Æ°á»£c xá»­ lÃ½ vÃ  alert Ä‘Ã£ Ä‘Æ°á»£c gá»­i, dashboard Ä‘Æ°á»£c kiá»ƒm tra láº¡i Ä‘á»ƒ xÃ¡c nháº­n tráº¡ng thÃ¡i cuá»‘i cÃ¹ng.

Tráº¡ng thÃ¡i mong Ä‘á»£i:

```text
Incident Status: Isolated
Response Mode: AutoResponse
Approval Status: Approved
Notification: Sent
```

![Dashboard Final Incident Status](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-Test-Dashboard-And-Alert/dashboard-final-incident-status.png)

Káº¿t quáº£ nÃ y xÃ¡c nháº­n ráº±ng SOC Dashboard Ä‘Ã£ pháº£n Ã¡nh Ä‘Ãºng tráº¡ng thÃ¡i cuá»‘i cÃ¹ng cá»§a incident.

---

#### Káº¿t quáº£ mong Ä‘á»£i

Sau khi hoÃ n thÃ nh pháº§n nÃ y, cÃ¡c káº¿t quáº£ mong Ä‘á»£i gá»“m:

| ThÃ nh pháº§n | Káº¿t quáº£ mong Ä‘á»£i |
|---|---|
| SOC Dashboard | Hiá»ƒn thá»‹ incident vÃ  tráº¡ng thÃ¡i xá»­ lÃ½ |
| DynamoDB | LÆ°u tráº¡ng thÃ¡i incident vÃ  notification message ID |
| SNS Topic | CÃ³ subscription hoáº¡t Ä‘á»™ng |
| Email | Nháº­n Ä‘Æ°á»£c incident alert |
| Slack | Nháº­n Ä‘Æ°á»£c incident alert |
| CloudWatch Alarm | CÃ³ thá»ƒ gá»­i alarm notification qua SNS |
| SOC Analyst | CÃ³ thá»ƒ theo dÃµi incident qua dashboard vÃ  alert |

---

#### Báº±ng chá»©ng kiá»ƒm thá»­

CÃ¡c báº±ng chá»©ng kiá»ƒm thá»­ trong pháº§n nÃ y bao gá»“m nhá»¯ng hÃ¬nh áº£nh sau:

| STT | HÃ¬nh áº£nh | Má»¥c Ä‘Ã­ch |
|---|---|---|
| 1 | Dashboard and alert flow diagram | MÃ´ táº£ luá»“ng kiá»ƒm thá»­ dashboard vÃ  alert |
| 2 | Dashboard before alert test | XÃ¡c nháº­n dashboard Ä‘Ã£ hoáº¡t Ä‘á»™ng |
| 3 | Dashboard isolated incident | XÃ¡c nháº­n dashboard hiá»ƒn thá»‹ incident Ä‘Ã£ xá»­ lÃ½ |
| 4 | DynamoDB notification record | XÃ¡c nháº­n DynamoDB lÆ°u tráº¡ng thÃ¡i notification |
| 5 | SNS topic subscriptions | XÃ¡c nháº­n SNS subscription Ä‘Ã£ confirmed |
| 6 | Email incident alert | XÃ¡c nháº­n email nháº­n incident alert |
| 7 | Slack incident alert | XÃ¡c nháº­n Slack nháº­n incident alert |
| 8 | CloudWatch alarm dashboard | XÃ¡c nháº­n alarm theo dÃµi Lambda error |
| 9 | CloudWatch alarm notification | XÃ¡c nháº­n alarm gá»­i notification |
| 10 | Dashboard final incident status | XÃ¡c nháº­n tráº¡ng thÃ¡i cuá»‘i cÃ¹ng trÃªn dashboard |

---

#### Ghi chÃº

Dashboard vÃ  alert lÃ  hai thÃ nh pháº§n quan trá»ng trong hoáº¡t Ä‘á»™ng SOC.

Dashboard giÃºp SOC Analyst theo dÃµi incident táº­p trung, trong khi SNS, Email vÃ  Slack giÃºp gá»­i cáº£nh bÃ¡o nhanh khi cÃ³ sá»± cá»‘ hoáº·c khi há»‡ thá»‘ng pháº£n á»©ng sá»± cá»‘ gáº·p lá»—i.

Trong mÃ´i trÆ°á»ng thá»±c táº¿, dashboard vÃ  alerting layer giÃºp Ä‘á»™i SOC:

```text
Theo dÃµi incident theo thá»i gian gáº§n thá»±c
Nháº­n thÃ´ng bÃ¡o nhanh khi cÃ³ sá»± cá»‘
Kiá»ƒm tra tráº¡ng thÃ¡i xá»­ lÃ½ incident
Theo dÃµi lá»—i cá»§a há»‡ thá»‘ng response automation
Há»— trá»£ Ä‘iá»u tra vÃ  ra quyáº¿t Ä‘á»‹nh nhanh hÆ¡n
```

---

#### HoÃ n thÃ nh

Báº¡n Ä‘Ã£ hoÃ n thÃ nh pháº§n kiá»ƒm thá»­ Dashboard vÃ  Alert.

Káº¿t quáº£ cá»§a pháº§n nÃ y xÃ¡c nháº­n ráº±ng há»‡ thá»‘ng AWS CloudSOC khÃ´ng chá»‰ cÃ³ thá»ƒ xá»­ lÃ½ incident tá»± Ä‘á»™ng, mÃ  cÃ²n cÃ³ thá»ƒ hiá»ƒn thá»‹ tráº¡ng thÃ¡i trÃªn dashboard vÃ  gá»­i cáº£nh bÃ¡o Ä‘áº¿n SOC Analyst qua Email, Slack vÃ  CloudWatch Alarm.

ÄÃ¢y lÃ  bÆ°á»›c kiá»ƒm thá»­ cuá»‘i cÃ¹ng trong pháº§n **5.5 Testing and Validation**, giÃºp xÃ¡c nháº­n toÃ n bá»™ luá»“ng CloudSOC Ä‘Ã£ hoáº¡t Ä‘á»™ng tá»« phÃ¡t hiá»‡n, xá»­ lÃ½, lÆ°u evidence Ä‘áº¿n cáº£nh bÃ¡o.