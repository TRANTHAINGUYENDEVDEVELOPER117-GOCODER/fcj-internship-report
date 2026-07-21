---
title : "Triá»ƒn khai há»‡ thá»‘ng CloudSOC"
date : 2024-01-01
weight : 4
chapter : false
pre : " <b> 5.4. </b> "
---

#### Triá»ƒn khai há»‡ thá»‘ng CloudSOC

Trong pháº§n nÃ y, chÃºng ta sáº½ triá»ƒn khai toÃ n bá»™ há»‡ thá»‘ng **AWS CloudSOC** theo kiáº¿n trÃºc Ä‘Ã£ thiáº¿t káº¿ á»Ÿ pháº§n trÆ°á»›c. ÄÃ¢y lÃ  pháº§n triá»ƒn khai chÃ­nh cá»§a workshop, nÆ¡i cÃ¡c thÃ nh pháº§n báº£o máº­t, giÃ¡m sÃ¡t, Ä‘iá»u phá»‘i pháº£n á»©ng sá»± cá»‘, lÆ°u trá»¯ báº±ng chá»©ng, dashboard phÃª duyá»‡t vÃ  cáº£nh bÃ¡o Ä‘Æ°á»£c cáº¥u hÃ¬nh thÃ nh má»™t há»‡ thá»‘ng hoÃ n chá»‰nh.

Má»¥c tiÃªu cá»§a pháº§n 5.4 lÃ  xÃ¢y dá»±ng má»™t mÃ´ hÃ¬nh **Security Operations Center trÃªn AWS** cÃ³ kháº£ nÄƒng phÃ¡t hiá»‡n má»‘i Ä‘e dá»a, Ä‘iá»u tra sá»± cá»‘, pháº£n á»©ng tá»± Ä‘á»™ng, lÆ°u láº¡i báº±ng chá»©ng vÃ  gá»­i cáº£nh bÃ¡o Ä‘áº¿n SOC Analyst.

Quy trÃ¬nh tá»•ng thá»ƒ cá»§a há»‡ thá»‘ng:

```text
Detect â†’ Investigate â†’ Respond â†’ Store Evidence â†’ Notify
```

Há»‡ thá»‘ng Ä‘Æ°á»£c triá»ƒn khai theo mÃ´ hÃ¬nh **serverless** vÃ  **event-driven**, sá»­ dá»¥ng cÃ¡c dá»‹ch vá»¥ chÃ­nh nhÆ° Amazon GuardDuty, AWS Security Hub, Amazon EventBridge, AWS Step Functions, AWS Lambda, AWS Systems Manager, Amazon S3, Amazon DynamoDB, Amazon SNS vÃ  Amazon CloudWatch.

---

#### Má»¥c tiÃªu triá»ƒn khai

Sau khi hoÃ n thÃ nh pháº§n nÃ y, há»‡ thá»‘ng CloudSOC sáº½ cÃ³ kháº£ nÄƒng:

+ Táº¡o mÃ´i trÆ°á»ng máº¡ng cÆ¡ báº£n cho workload EC2.
+ Ghi nháº­n log vÃ  lÆ°u trá»¯ evidence phá»¥c vá»¥ Ä‘iá»u tra.
+ Báº­t cÃ¡c dá»‹ch vá»¥ phÃ¡t hiá»‡n má»‘i Ä‘e dá»a nhÆ° GuardDuty, Security Hub, Detective vÃ  AWS Config.
+ Sá»­ dá»¥ng EventBridge Ä‘á»ƒ nháº­n security finding.
+ Sá»­ dá»¥ng Step Functions Ä‘á»ƒ Ä‘iá»u phá»‘i workflow pháº£n á»©ng sá»± cá»‘.
+ XÃ¢y dá»±ng dashboard cho SOC Analyst xem incident vÃ  phÃª duyá»‡t hÃ nh Ä‘á»™ng.
+ Tá»± Ä‘á»™ng thu tháº­p forensic evidence.
+ Táº¡o EBS Snapshot phá»¥c vá»¥ Ä‘iá»u tra sau sá»± cá»‘.
+ CÃ´ láº­p EC2 bá»‹ nghi ngá» báº±ng `SG-Isolation`.
+ Gá»­i cáº£nh bÃ¡o qua SNS, Email vÃ  Slack optional.

---

#### Tá»•ng quan triá»ƒn khai

SÆ¡ Ä‘á»“ dÆ°á»›i Ä‘Ã¢y mÃ´ táº£ tá»•ng quan cÃ¡c bÆ°á»›c triá»ƒn khai há»‡ thá»‘ng CloudSOC.

![CloudSOC Deployment Flow](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/deployment-flow.png)

Luá»“ng triá»ƒn khai tá»•ng thá»ƒ:

```text
Network and EC2
â†’ Logging and Evidence Storage
â†’ Threat Detection Services
â†’ EventBridge and Step Functions
â†’ Dashboard and Approval Flow
â†’ Forensics, Snapshot and Isolation
â†’ Notification and Alerting
```

Má»—i pháº§n trong 5.4 sáº½ triá»ƒn khai má»™t nhÃ³m thÃ nh pháº§n riÃªng. Khi káº¿t há»£p láº¡i, cÃ¡c thÃ nh pháº§n nÃ y táº¡o thÃ nh má»™t quy trÃ¬nh SOC hoÃ n chá»‰nh trÃªn AWS.

---

#### CÃ¡c pháº§n triá»ƒn khai trong 5.4

Pháº§n 5.4 Ä‘Æ°á»£c chia thÃ nh 7 pháº§n con. Báº¡n nÃªn triá»ƒn khai theo Ä‘Ãºng thá»© tá»± bÃªn dÆ°á»›i Ä‘á»ƒ Ä‘áº£m báº£o cÃ¡c dá»‹ch vá»¥ Ä‘Æ°á»£c káº¿t ná»‘i Ä‘Ãºng luá»“ng.

| Pháº§n | Ná»™i dung | Vai trÃ² trong há»‡ thá»‘ng |
|---|---|---|
| [5.4.1 Network and EC2 Workload](./5.4.1-network-and-ec2/) | Táº¡o VPC, subnet, EC2, IAM Role vÃ  Security Groups | Chuáº©n bá»‹ workload Ä‘á»ƒ giÃ¡m sÃ¡t vÃ  cÃ´ láº­p |
| [5.4.2 Logging and Evidence Storage](./5.4.2-logging-and-evidence-storage/) | Táº¡o S3 bucket, CloudTrail vÃ  VPC Flow Logs | LÆ°u log vÃ  evidence phá»¥c vá»¥ Ä‘iá»u tra |
| [5.4.3 Threat Detection Services](./5.4.3-threat-detection-services/) | Báº­t GuardDuty, Security Hub, Detective vÃ  AWS Config | PhÃ¡t hiá»‡n vÃ  Ä‘iá»u tra má»‘i Ä‘e dá»a |
| [5.4.4 EventBridge and Step Functions](./5.4.4-eventbridge-and-step-functions/) | Táº¡o EventBridge Rule vÃ  Step Functions workflow | Äiá»u phá»‘i luá»“ng pháº£n á»©ng sá»± cá»‘ |
| [5.4.5 Dashboard and Approval Flow](./5.4.5-dashboard-and-approval-flow/) | Táº¡o DynamoDB, Cognito, API Gateway, Lambda vÃ  Amplify Dashboard | Cho phÃ©p SOC Analyst xem vÃ  phÃª duyá»‡t incident |
| [5.4.6 Forensics, Snapshot and Isolation](./5.4.6-forensics-snapshot-and-isolation/) | Táº¡o Incident Response Lambda, SSM, EBS Snapshot vÃ  SG-Isolation | Thu tháº­p báº±ng chá»©ng, táº¡o snapshot vÃ  cÃ´ láº­p EC2 |
| [5.4.7 Notification and Alerting](./5.4.7-notification-and-alerting/) | Táº¡o SNS, Email alert, CloudWatch Alarm vÃ  Slack optional | Gá»­i cáº£nh bÃ¡o cho SOC Analyst |

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

#### Thá»© tá»± triá»ƒn khai khuyáº¿n nghá»‹

```text
5.4.1 Network and EC2 Workload
        â†“
5.4.2 Logging and Evidence Storage
        â†“
5.4.3 Threat Detection Services
        â†“
5.4.4 EventBridge and Step Functions
        â†“
5.4.5 Dashboard and Approval Flow
        â†“
5.4.6 Forensics, Snapshot and Isolation
        â†“
5.4.7 Notification and Alerting
```

Thá»© tá»± nÃ y giÃºp há»‡ thá»‘ng Ä‘Æ°á»£c triá»ƒn khai theo Ä‘Ãºng luá»“ng:

```text
Infrastructure â†’ Logging â†’ Detection â†’ Workflow â†’ Dashboard â†’ Response â†’ Notification
```

---

#### Kiáº¿n trÃºc triá»ƒn khai trong pháº§n nÃ y

Há»‡ thá»‘ng CloudSOC Ä‘Æ°á»£c chia thÃ nh nhiá»u lá»›p chá»©c nÄƒng. Má»—i lá»›p Ä‘áº£m nhiá»‡m má»™t vai trÃ² riÃªng trong quy trÃ¬nh phÃ¡t hiá»‡n vÃ  pháº£n á»©ng sá»± cá»‘.

| NhÃ³m chá»©c nÄƒng | Dá»‹ch vá»¥ sá»­ dá»¥ng | Vai trÃ² |
|---|---|---|
| Network Layer | VPC, Subnet, Internet Gateway, Route Table, EC2, Security Group | Táº¡o mÃ´i trÆ°á»ng workload Ä‘á»ƒ giÃ¡m sÃ¡t |
| Logging Layer | CloudTrail, VPC Flow Logs, CloudWatch Logs, S3 | Ghi nháº­n log vÃ  lÆ°u báº±ng chá»©ng |
| Detection Layer | GuardDuty, Security Hub, Detective, AWS Config | PhÃ¡t hiá»‡n, tá»•ng há»£p vÃ  Ä‘iá»u tra finding |
| Workflow Layer | EventBridge, Step Functions | Äiá»u phá»‘i pháº£n á»©ng sá»± cá»‘ |
| Dashboard Layer | Cognito, API Gateway, Lambda, DynamoDB, Amplify | Cho phÃ©p SOC Analyst xem vÃ  phÃª duyá»‡t incident |
| Response Layer | Lambda, Systems Manager, EBS Snapshot, Security Group | Thu tháº­p evidence, táº¡o snapshot vÃ  cÃ´ láº­p EC2 |
| Notification Layer | SNS, Email, CloudWatch Alarm, Slack optional | Gá»­i cáº£nh bÃ¡o Ä‘áº¿n SOC Analyst |

---

#### 5.4.1 Network and EC2 Workload

Trong pháº§n nÃ y, chÃºng ta táº¡o ná»n táº£ng máº¡ng cho lab CloudSOC.

CÃ¡c thÃ nh pháº§n Ä‘Æ°á»£c triá»ƒn khai gá»“m:

+ VPC `cloudsoc-vpc`.
+ Public subnet `cloudsoc-public-subnet`.
+ Internet Gateway.
+ Public Route Table.
+ EC2 instance `cloudsoc-workload-ec2`.
+ IAM Role cho EC2 sá»­ dá»¥ng Systems Manager.
+ Security Group bÃ¬nh thÆ°á»ng `SG-Workload`.
+ Security Group cÃ´ láº­p `SG-Isolation`.

Má»¥c tiÃªu chÃ­nh lÃ  táº¡o má»™t EC2 workload cÃ³ thá»ƒ Ä‘Æ°á»£c quáº£n lÃ½ báº±ng Systems Manager vÃ  cÃ³ thá»ƒ bá»‹ cÃ´ láº­p báº±ng cÃ¡ch thay Security Group khi xáº£y ra incident.

Luá»“ng cÆ¡ báº£n:

```text
Internet
â†’ Internet Gateway
â†’ Public Subnet
â†’ EC2 Workload
```

EC2 workload Ä‘Æ°á»£c gáº¯n tag:

```text
AutoIsolate = true
```

Tag nÃ y giÃºp Incident Response Lambda xÃ¡c Ä‘á»‹nh EC2 cÃ³ Ä‘Æ°á»£c phÃ©p cÃ´ láº­p tá»± Ä‘á»™ng hay khÃ´ng.

Káº¿t quáº£ mong Ä‘á»£i sau pháº§n 5.4.1:

```text
EC2 workload Ä‘ang cháº¡y vá»›i SG-Workload, cÃ³ IAM Role cho SSM vÃ  cÃ³ SG-Isolation sáºµn sÃ ng Ä‘á»ƒ cÃ´ láº­p.
```

---

#### 5.4.2 Logging and Evidence Storage

Trong pháº§n nÃ y, chÃºng ta táº¡o lá»›p lÆ°u trá»¯ log vÃ  evidence.

CÃ¡c thÃ nh pháº§n chÃ­nh gá»“m:

+ S3 bucket lÆ°u CloudTrail audit logs.
+ S3 bucket lÆ°u incident evidence.
+ CloudTrail ghi nháº­n management events.
+ VPC Flow Logs ghi network traffic metadata vÃ o CloudWatch Logs.
+ Cáº¥u trÃºc thÆ° má»¥c evidence phá»¥c vá»¥ forensic investigation.

Má»¥c tiÃªu lÃ  Ä‘áº£m báº£o má»i sá»± kiá»‡n quan trá»ng vÃ  báº±ng chá»©ng pháº£n á»©ng sá»± cá»‘ Ä‘á»u Ä‘Æ°á»£c lÆ°u trá»¯ Ä‘á»ƒ Ä‘iá»u tra sau nÃ y.

Luá»“ng logging chÃ­nh:

```text
CloudTrail â†’ S3 Audit Logs
VPC Flow Logs â†’ CloudWatch Logs
Incident Response Lambda â†’ S3 Evidence Bucket
Systems Manager â†’ S3 Evidence Bucket
```

Káº¿t quáº£ mong Ä‘á»£i sau pháº§n 5.4.2:

```text
CloudTrail, VPC Flow Logs vÃ  S3 Evidence Bucket Ä‘Ã£ sáºµn sÃ ng Ä‘á»ƒ lÆ°u log vÃ  báº±ng chá»©ng.
```

---

#### 5.4.3 Threat Detection Services

Trong pháº§n nÃ y, chÃºng ta báº­t cÃ¡c dá»‹ch vá»¥ phÃ¡t hiá»‡n vÃ  Ä‘iá»u tra má»‘i Ä‘e dá»a.

CÃ¡c dá»‹ch vá»¥ gá»“m:

+ Amazon GuardDuty.
+ AWS Security Hub.
+ Amazon Detective.
+ AWS Config.

GuardDuty Ä‘Ã³ng vai trÃ² phÃ¡t hiá»‡n hÃ nh vi báº¥t thÆ°á»ng. Security Hub tá»•ng há»£p finding. Detective há»— trá»£ Ä‘iá»u tra má»‘i quan há»‡ giá»¯a tÃ i nguyÃªn, cÃ²n AWS Config theo dÃµi thay Ä‘á»•i cáº¥u hÃ¬nh tÃ i nguyÃªn.

Luá»“ng detection chÃ­nh:

```text
CloudTrail / VPC Flow Logs / DNS Logs
â†’ GuardDuty
â†’ Security Hub
â†’ EventBridge
```

NgoÃ i ra, Detective há»— trá»£ Ä‘iá»u tra incident sau khi cÃ³ finding:

```text
GuardDuty Finding
â†’ Amazon Detective
â†’ Investigation
```

Káº¿t quáº£ mong Ä‘á»£i sau pháº§n 5.4.3:

```text
GuardDuty, Security Hub, Detective vÃ  AWS Config Ä‘Ã£ Ä‘Æ°á»£c báº­t Ä‘á»ƒ phá»¥c vá»¥ phÃ¡t hiá»‡n vÃ  Ä‘iá»u tra má»‘i Ä‘e dá»a.
```

---

#### 5.4.4 EventBridge and Step Functions

Trong pháº§n nÃ y, chÃºng ta triá»ƒn khai lá»›p Ä‘iá»u phá»‘i pháº£n á»©ng sá»± cá»‘.

CÃ¡c thÃ nh pháº§n chÃ­nh gá»“m:

+ EventBridge Rule nháº­n GuardDuty Finding.
+ Step Functions State Machine Ä‘iá»u phá»‘i workflow.
+ NhÃ¡nh `Alert Only`.
+ NhÃ¡nh `Approval Required`.
+ NhÃ¡nh `Auto Response`.

Workflow giÃºp há»‡ thá»‘ng quyáº¿t Ä‘á»‹nh cÃ¡ch pháº£n á»©ng tÃ¹y theo severity, resource type vÃ  chÃ­nh sÃ¡ch xá»­ lÃ½.

Luá»“ng xá»­ lÃ½ chÃ­nh:

```text
GuardDuty Finding
â†’ EventBridge Rule
â†’ Step Functions
â†’ Evaluate Finding
â†’ Alert Only / Approval Required / Auto Response
```

CÃ¡c nhÃ¡nh xá»­ lÃ½:

| NhÃ¡nh | Äiá»u kiá»‡n | HÃ nh Ä‘á»™ng |
|---|---|---|
| Alert Only | Finding cÃ³ má»©c Ä‘á»™ tháº¥p hoáº·c khÃ´ng Ä‘á»§ Ä‘iá»u kiá»‡n xá»­ lÃ½ | Gá»­i cáº£nh bÃ¡o, khÃ´ng cÃ´ láº­p EC2 |
| Approval Required | Finding cÃ³ má»©c Ä‘á»™ cao nhÆ°ng cáº§n SOC Analyst phÃª duyá»‡t | Táº¡o incident chá» phÃª duyá»‡t |
| Auto Response | Finding nghiÃªm trá»ng vÃ  EC2 cÃ³ tag `AutoIsolate=true` | Tá»± Ä‘á»™ng pháº£n á»©ng vÃ  cÃ´ láº­p EC2 |

Káº¿t quáº£ mong Ä‘á»£i sau pháº§n 5.4.4:

```text
GuardDuty finding cÃ³ thá»ƒ kÃ­ch hoáº¡t Step Functions workflow thÃ´ng qua EventBridge.
```

---

#### 5.4.5 Dashboard and Approval Flow

Trong pháº§n nÃ y, chÃºng ta triá»ƒn khai dashboard cho SOC Analyst.

CÃ¡c thÃ nh pháº§n gá»“m:

+ DynamoDB Incident Table.
+ Cognito User Pool.
+ Dashboard API Lambda.
+ API Gateway.
+ Amplify Hosting.
+ Dashboard giao diá»‡n web.
+ Approval action: Approve hoáº·c Reject.

Dashboard giÃºp SOC Analyst xem incident, kiá»ƒm tra thÃ´ng tin finding vÃ  phÃª duyá»‡t hÃ nh Ä‘á»™ng pháº£n á»©ng khi cáº§n.

Luá»“ng dashboard:

```text
SOC Analyst
â†’ Amplify Dashboard
â†’ Cognito Authentication
â†’ API Gateway
â†’ Dashboard API Lambda
â†’ DynamoDB Incident Table
```

Luá»“ng approval:

```text
SOC Analyst
â†’ Approve / Reject
â†’ API Gateway
â†’ Dashboard API Lambda
â†’ DynamoDB Incident Table
```

Káº¿t quáº£ mong Ä‘á»£i sau pháº§n 5.4.5:

```text
SOC Analyst cÃ³ thá»ƒ xem incident trÃªn dashboard vÃ  thay Ä‘á»•i approval status tá»« Pending sang Approved hoáº·c Rejected.
```

---

#### 5.4.6 Forensics, Snapshot and Isolation

Trong pháº§n nÃ y, chÃºng ta triá»ƒn khai hÃ nh Ä‘á»™ng pháº£n á»©ng sá»± cá»‘ tháº­t.

CÃ¡c thÃ nh pháº§n gá»“m:

+ Incident Response Lambda.
+ Systems Manager Run Command.
+ S3 Evidence Bucket.
+ EBS Forensic Snapshot.
+ Security Group Isolation.
+ DynamoDB incident update.

Khi Lambda Ä‘Æ°á»£c kÃ­ch hoáº¡t, há»‡ thá»‘ng sáº½:

```text
Collect Evidence
â†’ Create EBS Snapshot
â†’ Store Evidence in S3
â†’ Replace SG-Workload with SG-Isolation
â†’ Update DynamoDB Incident Status
```

Incident Response Lambda thá»±c hiá»‡n cÃ¡c hÃ nh Ä‘á»™ng chÃ­nh:

| HÃ nh Ä‘á»™ng | Má»¥c Ä‘Ã­ch |
|---|---|
| Äá»c GuardDuty event | XÃ¡c Ä‘á»‹nh finding vÃ  EC2 bá»‹ áº£nh hÆ°á»Ÿng |
| Kiá»ƒm tra tag `AutoIsolate=true` | Äáº£m báº£o chá»‰ cÃ´ láº­p workload Ä‘Æ°á»£c phÃ©p |
| Cháº¡y SSM Run Command | Thu tháº­p thÃ´ng tin forensic cÆ¡ báº£n |
| Táº¡o EBS Snapshot | LÆ°u tráº¡ng thÃ¡i volume phá»¥c vá»¥ Ä‘iá»u tra |
| Ghi evidence vÃ o S3 | LÆ°u event vÃ  response summary |
| Thay Security Group | CÃ´ láº­p EC2 báº±ng `SG-Isolation` |
| Cáº­p nháº­t DynamoDB | Ghi nháº­n tráº¡ng thÃ¡i incident |

Káº¿t quáº£ mong Ä‘á»£i sau pháº§n 5.4.6:

```text
Lambda cÃ³ thá»ƒ thu tháº­p evidence, táº¡o snapshot, ghi dá»¯ liá»‡u vÃ o S3/DynamoDB vÃ  Ä‘á»•i EC2 sang SG-Isolation.
```

---

#### 5.4.7 Notification and Alerting

Trong pháº§n nÃ y, chÃºng ta triá»ƒn khai lá»›p cáº£nh bÃ¡o.

CÃ¡c thÃ nh pháº§n gá»“m:

+ SNS Topic `cloudsoc-incident-alerts`.
+ Email subscription.
+ Lambda publish notification.
+ CloudWatch Alarm theo dÃµi Lambda Errors.
+ Slack notification optional thÃ´ng qua Amazon Q Developer in chat applications.

Luá»“ng notification chÃ­nh:

```text
Incident Response Lambda
â†’ Amazon SNS
â†’ Email / Slack
â†’ SOC Analyst
```

Luá»“ng cáº£nh bÃ¡o lá»—i:

```text
CloudWatch Metrics
â†’ CloudWatch Alarm
â†’ Amazon SNS
â†’ Email / Slack
```

Má»¥c tiÃªu lÃ  giÃºp SOC Analyst nháº­n Ä‘Æ°á»£c thÃ´ng bÃ¡o ká»‹p thá»i khi incident Ä‘Æ°á»£c xá»­ lÃ½ hoáº·c khi há»‡ thá»‘ng pháº£n á»©ng sá»± cá»‘ gáº·p lá»—i.

Káº¿t quáº£ mong Ä‘á»£i sau pháº§n 5.4.7:

```text
SNS gá»­i notification thÃ nh cÃ´ng Ä‘áº¿n Email vÃ  Slack optional sau khi incident Ä‘Æ°á»£c xá»­ lÃ½.
```

---

#### Deployment Checklist

Báº£ng dÆ°á»›i Ä‘Ã¢y tÃ³m táº¯t cÃ¡c thÃ nh pháº§n cáº§n hoÃ n thÃ nh trong pháº§n triá»ƒn khai.

![CloudSOC Deployment Checklist](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/deployment-checklist.png)

| Má»¥c | Tráº¡ng thÃ¡i mong Ä‘á»£i |
|---|---|
| VPC vÃ  EC2 workload | ÄÃ£ táº¡o |
| SG-Workload vÃ  SG-Isolation | ÄÃ£ cáº¥u hÃ¬nh |
| EC2 tag `AutoIsolate=true` | ÄÃ£ thÃªm |
| IAM Role cho EC2 SSM | ÄÃ£ táº¡o |
| CloudTrail | ÄÃ£ báº­t |
| VPC Flow Logs | ÄÃ£ báº­t |
| S3 Audit Logs Bucket | ÄÃ£ táº¡o |
| S3 Evidence Bucket | ÄÃ£ táº¡o |
| GuardDuty | ÄÃ£ báº­t |
| Security Hub | ÄÃ£ báº­t |
| Detective | ÄÃ£ báº­t |
| AWS Config | ÄÃ£ báº­t |
| EventBridge Rule | ÄÃ£ táº¡o |
| Step Functions Workflow | ÄÃ£ táº¡o |
| DynamoDB Incident Table | ÄÃ£ táº¡o |
| Cognito User Pool | ÄÃ£ táº¡o |
| Dashboard API Lambda | ÄÃ£ táº¡o |
| API Gateway | ÄÃ£ táº¡o |
| Amplify Dashboard | ÄÃ£ triá»ƒn khai |
| Incident Response Lambda | ÄÃ£ triá»ƒn khai |
| Systems Manager Run Command | Cháº¡y thÃ nh cÃ´ng khi test |
| EBS Snapshot | Táº¡o thÃ nh cÃ´ng khi test |
| EC2 Isolation | Äá»•i sang SG-Isolation khi test |
| SNS Topic | ÄÃ£ táº¡o |
| Email Notification | Gá»­i thÃ nh cÃ´ng |
| CloudWatch Alarm | ÄÃ£ táº¡o |
| Slack Notification | Optional |

---

#### Káº¿t quáº£ mong Ä‘á»£i sau tá»«ng pháº§n

| Pháº§n | Káº¿t quáº£ mong Ä‘á»£i |
|---|---|
| 5.4.1 | EC2 workload cháº¡y trong VPC vÃ  cÃ³ thá»ƒ Ä‘Æ°á»£c quáº£n lÃ½ báº±ng Systems Manager |
| 5.4.2 | CloudTrail, VPC Flow Logs vÃ  S3 Evidence Bucket hoáº¡t Ä‘á»™ng |
| 5.4.3 | GuardDuty, Security Hub, Detective vÃ  AWS Config Ä‘Æ°á»£c báº­t |
| 5.4.4 | GuardDuty finding cÃ³ thá»ƒ kÃ­ch hoáº¡t Step Functions qua EventBridge |
| 5.4.5 | SOC Analyst cÃ³ dashboard Ä‘á»ƒ xem incident vÃ  phÃª duyá»‡t response |
| 5.4.6 | Lambda cÃ³ thá»ƒ thu tháº­p evidence, táº¡o snapshot vÃ  cÃ´ láº­p EC2 |
| 5.4.7 | SNS cÃ³ thá»ƒ gá»­i alert qua Email vÃ  Slack optional |

---

#### Luá»“ng hoáº¡t Ä‘á»™ng sau khi triá»ƒn khai

Sau khi hoÃ n thÃ nh pháº§n 5.4, há»‡ thá»‘ng AWS CloudSOC cÃ³ thá»ƒ hoáº¡t Ä‘á»™ng theo luá»“ng sau:

```text
1. GuardDuty phÃ¡t hiá»‡n finding báº¥t thÆ°á»ng.
2. Security Hub tá»•ng há»£p finding báº£o máº­t.
3. EventBridge nháº­n GuardDuty Finding.
4. Step Functions Ä‘Ã¡nh giÃ¡ severity vÃ  resource type.
5. Dashboard hiá»ƒn thá»‹ incident cho SOC Analyst.
6. Incident Response Lambda Ä‘Æ°á»£c kÃ­ch hoáº¡t khi finding Ä‘á»§ Ä‘iá»u kiá»‡n.
7. Systems Manager thu tháº­p forensic evidence tá»« EC2.
8. Lambda táº¡o EBS Snapshot Ä‘á»ƒ phá»¥c vá»¥ Ä‘iá»u tra.
9. Lambda ghi event vÃ  response summary vÃ o S3 Evidence Bucket.
10. Lambda Ä‘á»•i EC2 tá»« SG-Workload sang SG-Isolation.
11. DynamoDB cáº­p nháº­t tráº¡ng thÃ¡i incident.
12. SNS gá»­i notification Ä‘áº¿n Email hoáº·c Slack.
```

---

#### Káº¿t quáº£ sau khi hoÃ n thÃ nh pháº§n 5.4

Sau khi hoÃ n thÃ nh toÃ n bá»™ pháº§n 5.4, há»‡ thá»‘ng AWS CloudSOC Ä‘Ã£ cÃ³ Ä‘áº§y Ä‘á»§ cÃ¡c thÃ nh pháº§n cá»‘t lÃµi cá»§a má»™t mÃ´ hÃ¬nh SOC tá»± Ä‘á»™ng trÃªn AWS.

Há»‡ thá»‘ng cÃ³ thá»ƒ thá»±c hiá»‡n quy trÃ¬nh:

```text
GuardDuty detects a finding
â†’ EventBridge routes the finding
â†’ Step Functions evaluates the response path
â†’ Lambda performs response actions
â†’ Systems Manager collects evidence
â†’ EBS Snapshot preserves forensic state
â†’ EC2 is isolated with SG-Isolation
â†’ DynamoDB records incident status
â†’ SNS sends notification to SOC Analyst
```

CÃ¡c thÃ nh pháº§n chÃ­nh Ä‘Ã£ hoÃ n thÃ nh:

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

#### Tá»•ng káº¿t

Pháº§n 5.4 Ä‘Ã£ hoÃ n thÃ nh quÃ¡ trÃ¬nh triá»ƒn khai há»‡ thá»‘ng CloudSOC tá»« háº¡ táº§ng máº¡ng, logging, detection, workflow, dashboard, forensic response Ä‘áº¿n alerting.

ÄÃ¢y lÃ  pháº§n triá»ƒn khai chÃ­nh cá»§a workshop vÃ  lÃ  ná»n táº£ng Ä‘á»ƒ thá»±c hiá»‡n pháº§n tiáº¿p theo:

```text
5.5 Testing and Validation
```

Trong pháº§n tiáº¿p theo, chÃºng ta sáº½ kiá»ƒm tra toÃ n bá»™ luá»“ng hoáº¡t Ä‘á»™ng cá»§a há»‡ thá»‘ng, bao gá»“m phÃ¡t hiá»‡n finding, cháº¡y workflow, cÃ´ láº­p EC2, lÆ°u evidence vÃ  gá»­i notification.