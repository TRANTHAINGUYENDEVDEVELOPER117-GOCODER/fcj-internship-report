---
title : "Kiáº¿n trÃºc vÃ  luá»“ng hoáº¡t Ä‘á»™ng"
date : 2024-01-01
weight : 3
chapter : false
pre : " <b> 5.3. </b> "
---

#### Kiáº¿n trÃºc vÃ  luá»“ng hoáº¡t Ä‘á»™ng

Pháº§n nÃ y trÃ¬nh bÃ y kiáº¿n trÃºc tá»•ng quan vÃ  luá»“ng hoáº¡t Ä‘á»™ng chÃ­nh cá»§a há»‡ thá»‘ng **AWS CloudSOC**. Kiáº¿n trÃºc Ä‘Æ°á»£c xÃ¢y dá»±ng nháº±m mÃ´ phá»ng má»™t há»‡ thá»‘ng SOC trÃªn AWS cÃ³ kháº£ nÄƒng phÃ¡t hiá»‡n má»‘i Ä‘e dá»a, Ä‘iá»u phá»‘i pháº£n á»©ng sá»± cá»‘, thu tháº­p báº±ng chá»©ng, cÃ´ láº­p tÃ i nguyÃªn bá»‹ áº£nh hÆ°á»Ÿng vÃ  gá»­i cáº£nh bÃ¡o Ä‘áº¿n SOC Analyst.

Há»‡ thá»‘ng Ä‘Æ°á»£c thiáº¿t káº¿ theo mÃ´ hÃ¬nh **event-driven** vÃ  **serverless**, trong Ä‘Ã³ cÃ¡c security finding tá»« Amazon GuardDuty sáº½ kÃ­ch hoáº¡t workflow pháº£n á»©ng sá»± cá»‘ thÃ´ng qua Amazon EventBridge vÃ  AWS Step Functions.

---

#### Kiáº¿n trÃºc tá»•ng quan

SÆ¡ Ä‘á»“ dÆ°á»›i Ä‘Ã¢y mÃ´ táº£ kiáº¿n trÃºc tá»•ng quan cá»§a há»‡ thá»‘ng AWS CloudSOC.

![AWS CloudSOC Architecture](/images/5-Workshop/5.3-Architecture-and-Workflow/cloudsoc-architecture.png)

Kiáº¿n trÃºc Ä‘Æ°á»£c chia thÃ nh cÃ¡c nhÃ³m chÃ­nh:

+ **Network and Workload**
+ **Logging and Evidence Storage**
+ **Threat Detection and Response**
+ **SOC Dashboard and Access**
+ **Security, Governance, and Notification**

Má»—i nhÃ³m Ä‘áº£m nháº­n má»™t vai trÃ² riÃªng trong toÃ n bá»™ quÃ¡ trÃ¬nh phÃ¡t hiá»‡n, Ä‘iá»u tra vÃ  pháº£n á»©ng sá»± cá»‘.

---

#### NhÃ³m Network and Workload

NhÃ³m Network and Workload lÃ  nÆ¡i triá»ƒn khai tÃ i nguyÃªn má»¥c tiÃªu Ä‘á»ƒ kiá»ƒm thá»­ báº£o máº­t.

CÃ¡c thÃ nh pháº§n chÃ­nh gá»“m:

+ Amazon VPC
+ Public Subnet
+ Internet Gateway
+ Amazon EC2
+ SG-Workload
+ SG-Isolation

Trong workshop nÃ y, má»™t Amazon EC2 instance Ä‘Æ°á»£c triá»ƒn khai trong Public Subnet Ä‘á»ƒ Ä‘Æ¡n giáº£n hÃ³a quÃ¡ trÃ¬nh mÃ´ phá»ng táº¥n cÃ´ng vÃ  kiá»ƒm thá»­ GuardDuty finding.

EC2 instance ban Ä‘áº§u Ä‘Æ°á»£c gÃ¡n security group tÃªn lÃ  `SG-Workload`. ÄÃ¢y lÃ  security group dÃ¹ng cho workload bÃ¬nh thÆ°á»ng. Khi há»‡ thá»‘ng xÃ¡c Ä‘á»‹nh EC2 cáº§n Ä‘Æ°á»£c cÃ´ láº­p, AWS Lambda sáº½ thay tháº¿ `SG-Workload` báº±ng `SG-Isolation`.

`SG-Isolation` lÃ  security group Ä‘Æ°á»£c táº¡o sáºµn trong VPC vÃ  khÃ´ng cho phÃ©p inbound hoáº·c outbound traffic. CÃ¡ch nÃ y giÃºp cÃ´ láº­p EC2 instance bá»‹ áº£nh hÆ°á»Ÿng khá»i cÃ¡c káº¿t ná»‘i máº¡ng má»›i.

> **LÆ°u Ã½:** Security Group trÃªn AWS lÃ  stateful. Viá»‡c cÃ´ láº­p báº±ng security group chá»§ yáº¿u nháº±m cháº·n cÃ¡c káº¿t ná»‘i má»›i vÃ  giáº£m pháº¡m vi áº£nh hÆ°á»Ÿng cá»§a sá»± cá»‘.

---

#### NhÃ³m Logging and Evidence Storage

NhÃ³m Logging and Evidence Storage chá»‹u trÃ¡ch nhiá»‡m ghi log, lÆ°u báº±ng chá»©ng vÃ  há»— trá»£ quÃ¡ trÃ¬nh Ä‘iá»u tra sau sá»± cá»‘.

CÃ¡c thÃ nh pháº§n chÃ­nh gá»“m:

+ AWS CloudTrail
+ Amazon CloudWatch
+ VPC Flow Logs
+ Amazon S3
+ Amazon EBS Snapshot
+ AWS KMS

Luá»“ng logging vÃ  evidence trong há»‡ thá»‘ng:

```text
CloudTrail â†’ S3
CloudTrail â†’ CloudWatch
VPC Flow Logs â†’ CloudWatch
Systems Manager â†’ S3
Systems Manager â†’ EBS Snapshot
Incident Response Lambda â†’ S3
Incident Response Lambda â†’ CloudWatch
KMS â†’ S3
```

Vai trÃ² cá»§a tá»«ng thÃ nh pháº§n:

+ **AWS CloudTrail** ghi láº¡i cÃ¡c management events trong AWS account.
+ **Amazon CloudWatch** lÆ°u trá»¯ logs, metrics vÃ  alarms.
+ **VPC Flow Logs** ghi láº¡i metadata cá»§a network traffic trong VPC.
+ **Amazon S3** lÆ°u trá»¯ audit logs, forensic output vÃ  incident evidence.
+ **Amazon EBS Snapshot** báº£o toÃ n dá»¯ liá»‡u á»• Ä‘Ä©a cá»§a EC2 Ä‘á»ƒ phá»¥c vá»¥ Ä‘iá»u tra.
+ **AWS KMS** há»— trá»£ mÃ£ hÃ³a dá»¯ liá»‡u lÆ°u trá»¯ trong S3 náº¿u Ä‘Æ°á»£c cáº¥u hÃ¬nh.

---

#### NhÃ³m Threat Detection and Response

NhÃ³m Threat Detection and Response lÃ  pháº§n lÃµi cá»§a há»‡ thá»‘ng AWS CloudSOC.

CÃ¡c thÃ nh pháº§n chÃ­nh gá»“m:

+ Amazon GuardDuty
+ AWS Security Hub
+ Amazon Detective
+ Amazon EventBridge
+ AWS Step Functions
+ AWS Systems Manager
+ AWS Lambda

Luá»“ng phÃ¡t hiá»‡n vÃ  pháº£n á»©ng sá»± cá»‘:

```text
GuardDuty
â†’ EventBridge
â†’ Step Functions
â†’ Systems Manager / Lambda
â†’ Evidence Storage / Isolation / Notification
```

Khi GuardDuty phÃ¡t hiá»‡n hoáº¡t Ä‘á»™ng Ä‘Ã¡ng ngá», dá»‹ch vá»¥ nÃ y táº¡o ra má»™t security finding. Finding Ä‘Æ°á»£c gá»­i Ä‘áº¿n EventBridge Ä‘á»ƒ kÃ­ch hoáº¡t Step Functions workflow.

Step Functions sáº½ Ä‘iá»u phá»‘i toÃ n bá»™ quÃ¡ trÃ¬nh pháº£n á»©ng sá»± cá»‘, bao gá»“m:

+ Kiá»ƒm tra loáº¡i tÃ i nguyÃªn bá»‹ áº£nh hÆ°á»Ÿng
+ Kiá»ƒm tra Instance ID
+ Kiá»ƒm tra má»©c Ä‘á»™ nghiÃªm trá»ng
+ Kiá»ƒm tra tag `AutoIsolate=true`
+ XÃ¡c Ä‘á»‹nh cháº¿ Ä‘á»™ pháº£n á»©ng
+ Gá»­i yÃªu cáº§u phÃª duyá»‡t náº¿u cáº§n
+ Thu tháº­p báº±ng chá»©ng forensic
+ Táº¡o EBS Snapshot
+ CÃ´ láº­p EC2 instance
+ Gá»­i thÃ´ng bÃ¡o káº¿t quáº£

Amazon Detective vÃ  AWS Security Hub há»— trá»£ SOC Analyst trong quÃ¡ trÃ¬nh phÃ¢n tÃ­ch vÃ  Ä‘iá»u tra finding.

---

#### NhÃ³m SOC Dashboard and Access

NhÃ³m SOC Dashboard and Access cung cáº¥p giao diá»‡n cho SOC Analyst theo dÃµi incident vÃ  phÃª duyá»‡t hÃ nh Ä‘á»™ng pháº£n á»©ng.

CÃ¡c thÃ nh pháº§n chÃ­nh gá»“m:

+ AWS Amplify Hosting
+ Amazon Cognito
+ Amazon API Gateway
+ Dashboard API Lambda
+ Amazon DynamoDB
+ Amazon S3
+ AWS Step Functions

Luá»“ng dashboard:

```text
SOC Analyst
â†’ AWS Amplify Hosting
â†’ Amazon Cognito
â†’ Amazon API Gateway
â†’ Dashboard API Lambda
â†’ Amazon DynamoDB / Amazon S3
â†’ AWS Step Functions Approval Callback
```

Vai trÃ² cá»§a tá»«ng thÃ nh pháº§n:

+ **AWS Amplify Hosting** host giao diá»‡n SOC Dashboard.
+ **Amazon Cognito** xÃ¡c thá»±c SOC Analyst trÆ°á»›c khi truy cáº­p dashboard.
+ **Amazon API Gateway** cung cáº¥p HTTPS API cho dashboard.
+ **Dashboard API Lambda** xá»­ lÃ½ cÃ¡c request tá»« dashboard.
+ **Amazon DynamoDB** lÆ°u thÃ´ng tin incident vÃ  tráº¡ng thÃ¡i xá»­ lÃ½.
+ **Amazon S3** lÆ°u evidence vÃ  forensic output.
+ **AWS Step Functions** nháº­n approval callback tá»« dashboard.

SOC Dashboard khÃ´ng truy cáº­p trá»±c tiáº¿p vÃ o DynamoDB hoáº·c S3. Má»i thao tÃ¡c Ä‘á»c incident, xem evidence hoáº·c gá»­i phÃª duyá»‡t Ä‘á»u Ä‘i qua API Gateway vÃ  Lambda.

---

#### NhÃ³m Security, Governance, and Notification

NhÃ³m nÃ y chá»‹u trÃ¡ch nhiá»‡m quáº£n lÃ½ quyá»n truy cáº­p, theo dÃµi cáº¥u hÃ¬nh vÃ  gá»­i cáº£nh bÃ¡o.

CÃ¡c thÃ nh pháº§n chÃ­nh gá»“m:

+ AWS IAM
+ AWS Config
+ AWS KMS
+ Amazon SNS
+ Amazon Q Developer
+ Slack
+ Email / SMS

Vai trÃ² cá»§a tá»«ng thÃ nh pháº§n:

+ **AWS IAM** quáº£n lÃ½ quyá»n truy cáº­p vÃ  execution roles cho cÃ¡c dá»‹ch vá»¥.
+ **AWS Config** theo dÃµi thay Ä‘á»•i cáº¥u hÃ¬nh cá»§a EC2, Security Group vÃ  cÃ¡c tÃ i nguyÃªn liÃªn quan.
+ **AWS KMS** há»— trá»£ mÃ£ hÃ³a dá»¯ liá»‡u nháº¡y cáº£m.
+ **Amazon SNS** gá»­i cáº£nh bÃ¡o vÃ  káº¿t quáº£ xá»­ lÃ½ incident.
+ **Amazon Q Developer** cÃ³ thá»ƒ Ä‘Æ°á»£c dÃ¹ng Ä‘á»ƒ chuyá»ƒn tiáº¿p thÃ´ng bÃ¡o Ä‘áº¿n Slack.
+ **Email / SMS** giÃºp SOC Analyst nháº­n cáº£nh bÃ¡o nhanh chÃ³ng.

CÃ¡c IAM role chÃ­nh trong há»‡ thá»‘ng gá»“m:

+ Dashboard Lambda Role
+ Incident Response Lambda Role
+ Step Functions Workflow Role
+ EC2 SSM Instance Role

CÃ¡c role nÃ y Ä‘áº£m báº£o má»—i dá»‹ch vá»¥ chá»‰ cÃ³ quyá»n cáº§n thiáº¿t Ä‘á»ƒ thá»±c hiá»‡n Ä‘Ãºng chá»©c nÄƒng cá»§a mÃ¬nh.

---

#### Luá»“ng hoáº¡t Ä‘á»™ng chÃ­nh

SÆ¡ Ä‘á»“ sau minh há»a luá»“ng hoáº¡t Ä‘á»™ng chÃ­nh cá»§a há»‡ thá»‘ng AWS CloudSOC.

![AWS CloudSOC Main Workflow](/images/5-Workshop/5.3-Architecture-and-Workflow/cloudsoc-main-workflow.png)

Luá»“ng hoáº¡t Ä‘á»™ng chÃ­nh gá»“m cÃ¡c bÆ°á»›c:

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

#### Chi tiáº¿t luá»“ng xá»­ lÃ½

##### BÆ°á»›c 1: PhÃ¡t sinh hoáº¡t Ä‘á»™ng Ä‘Ã¡ng ngá»

Má»™t hoáº¡t Ä‘á»™ng Ä‘Ã¡ng ngá» xáº£y ra trÃªn EC2 instance, vÃ­ dá»¥:

+ Port scanning
+ SSH brute-force
+ Suspicious IP communication
+ Abnormal API activity

EC2 instance trong workshop Ä‘Æ°á»£c sá»­ dá»¥ng lÃ m workload má»¥c tiÃªu Ä‘á»ƒ mÃ´ phá»ng cÃ¡c tÃ¬nh huá»‘ng báº£o máº­t nÃ y.

---

##### BÆ°á»›c 2: GuardDuty phÃ¡t hiá»‡n má»‘i Ä‘e dá»a

Amazon GuardDuty phÃ¢n tÃ­ch cÃ¡c nguá»“n telemetry do AWS quáº£n lÃ½ nhÆ°:

+ CloudTrail management events
+ VPC Flow Logs
+ DNS logs

Khi phÃ¡t hiá»‡n hÃ nh vi báº¥t thÆ°á»ng, GuardDuty táº¡o security finding.

---

##### BÆ°á»›c 3: EventBridge kÃ­ch hoáº¡t workflow

Finding tá»« GuardDuty Ä‘Æ°á»£c gá»­i Ä‘áº¿n Amazon EventBridge. EventBridge sá»­ dá»¥ng rule Ä‘Ã£ cáº¥u hÃ¬nh Ä‘á»ƒ lá»c cÃ¡c finding phÃ¹ há»£p vÃ  kÃ­ch hoáº¡t AWS Step Functions.

```text
GuardDuty Finding â†’ EventBridge Rule â†’ Step Functions
```

---

##### BÆ°á»›c 4: Step Functions Ä‘Ã¡nh giÃ¡ finding

AWS Step Functions kiá»ƒm tra cÃ¡c thÃ´ng tin quan trá»ng trong finding:

+ Resource Type
+ Instance ID
+ Severity
+ AutoIsolate Tag
+ Response Mode

Dá»±a trÃªn káº¿t quáº£ Ä‘Ã¡nh giÃ¡, workflow sáº½ chá»n má»™t trong cÃ¡c nhÃ¡nh xá»­ lÃ½:

```text
Alert Only
Approval Required
Auto Response
```

---

##### BÆ°á»›c 5: Xá»­ lÃ½ theo chÃ­nh sÃ¡ch pháº£n á»©ng

ChÃ­nh sÃ¡ch pháº£n á»©ng cá»§a há»‡ thá»‘ng:

```text
Non-EC2 Finding        â†’ Alert Only
Low / Medium Severity  â†’ Dry Run
High Severity          â†’ Request Approval
Critical Severity      â†’ Auto Response
Reject / Timeout       â†’ End Workflow
```

Vá»›i finding má»©c High, há»‡ thá»‘ng yÃªu cáº§u SOC Analyst phÃª duyá»‡t trÆ°á»›c khi cÃ´ láº­p EC2.

Vá»›i finding má»©c Critical vÃ  cÃ³ tag `AutoIsolate=true`, há»‡ thá»‘ng cÃ³ thá»ƒ tá»± Ä‘á»™ng thá»±c hiá»‡n pháº£n á»©ng.

---

##### BÆ°á»›c 6: Thu tháº­p báº±ng chá»©ng forensic

AWS Systems Manager Ä‘Æ°á»£c sá»­ dá»¥ng Ä‘á»ƒ cháº¡y command trÃªn EC2 instance nháº±m thu tháº­p thÃ´ng tin phá»¥c vá»¥ Ä‘iá»u tra.

ThÃ´ng tin forensic cÃ³ thá»ƒ bao gá»“m:

+ Running processes
+ Network connections
+ Logged-in users
+ System logs
+ Security logs
+ Instance metadata

Káº¿t quáº£ thu tháº­p Ä‘Æ°á»£c lÆ°u vÃ o Amazon S3.

---

##### BÆ°á»›c 7: Táº¡o EBS Snapshot

TrÆ°á»›c khi cÃ´ láº­p hoáº·c xá»­ lÃ½ sÃ¢u hÆ¡n, há»‡ thá»‘ng táº¡o Amazon EBS Snapshot Ä‘á»ƒ báº£o toÃ n tráº¡ng thÃ¡i á»• Ä‘Ä©a cá»§a EC2 instance.

Snapshot nÃ y cÃ³ thá»ƒ Ä‘Æ°á»£c sá»­ dá»¥ng cho:

+ Äiá»u tra forensic
+ KhÃ´i phá»¥c dá»¯ liá»‡u
+ PhÃ¢n tÃ­ch sau sá»± cá»‘
+ LÆ°u trá»¯ báº±ng chá»©ng

---

##### BÆ°á»›c 8: CÃ´ láº­p EC2 instance

AWS Lambda thá»±c hiá»‡n hÃ nh Ä‘á»™ng cÃ´ láº­p báº±ng cÃ¡ch thay tháº¿ security group hiá»‡n táº¡i cá»§a EC2.

```text
SG-Workload â†’ SG-Isolation
```

`SG-Isolation` khÃ´ng cho phÃ©p inbound hoáº·c outbound traffic, giÃºp háº¡n cháº¿ kháº£ nÄƒng EC2 tiáº¿p tá»¥c giao tiáº¿p vá»›i cÃ¡c há»‡ thá»‘ng khÃ¡c.

---

##### BÆ°á»›c 9: Cáº­p nháº­t incident record

Sau khi thá»±c hiá»‡n hÃ nh Ä‘á»™ng pháº£n á»©ng, Lambda cáº­p nháº­t tráº¡ng thÃ¡i incident vÃ o Amazon DynamoDB.

CÃ¡c thÃ´ng tin cÃ³ thá»ƒ Ä‘Æ°á»£c lÆ°u gá»“m:

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

##### BÆ°á»›c 10: Gá»­i thÃ´ng bÃ¡o

Amazon SNS gá»­i thÃ´ng bÃ¡o Ä‘áº¿n SOC Analyst sau khi workflow hoÃ n táº¥t hoáº·c khi cáº§n phÃª duyá»‡t.

ThÃ´ng bÃ¡o cÃ³ thá»ƒ Ä‘Æ°á»£c gá»­i qua:

+ Email
+ SMS
+ Slack thÃ´ng qua Amazon Q Developer

Ná»™i dung thÃ´ng bÃ¡o gá»“m thÃ´ng tin incident, má»©c Ä‘á»™ nghiÃªm trá»ng, tÃ i nguyÃªn bá»‹ áº£nh hÆ°á»Ÿng vÃ  káº¿t quáº£ xá»­ lÃ½.

---

#### Luá»“ng phÃª duyá»‡t cá»§a SOC Analyst

Äá»‘i vá»›i finding má»©c High, há»‡ thá»‘ng khÃ´ng tá»± Ä‘á»™ng cÃ´ láº­p EC2 ngay láº­p tá»©c. Thay vÃ o Ä‘Ã³, SOC Analyst sáº½ xem xÃ©t thÃ´ng tin incident trÃªn dashboard.

Luá»“ng phÃª duyá»‡t:

```text
SOC Analyst
â†’ SOC Dashboard
â†’ Review Incident
â†’ Approve / Reject
â†’ Step Functions Callback
â†’ Continue or End Workflow
```

Náº¿u SOC Analyst phÃª duyá»‡t, workflow tiáº¿p tá»¥c thu tháº­p báº±ng chá»©ng, táº¡o snapshot vÃ  cÃ´ láº­p EC2.

Náº¿u SOC Analyst tá»« chá»‘i hoáº·c quÃ¡ thá»i gian chá», workflow káº¿t thÃºc vÃ  chá»‰ ghi nháº­n tráº¡ng thÃ¡i incident.

---

#### TÃ³m táº¯t luá»“ng kiáº¿n trÃºc

Báº£ng sau tÃ³m táº¯t vai trÃ² cá»§a tá»«ng nhÃ³m trong kiáº¿n trÃºc AWS CloudSOC.

| NhÃ³m | Chá»©c nÄƒng |
|------|-----------|
| Network and Workload | Triá»ƒn khai EC2 má»¥c tiÃªu vÃ  security group phá»¥c vá»¥ cÃ´ láº­p |
| Logging and Evidence Storage | Ghi log, lÆ°u evidence vÃ  táº¡o snapshot phá»¥c vá»¥ Ä‘iá»u tra |
| Threat Detection and Response | PhÃ¡t hiá»‡n finding vÃ  Ä‘iá»u phá»‘i pháº£n á»©ng sá»± cá»‘ |
| SOC Dashboard and Access | Cung cáº¥p giao diá»‡n theo dÃµi incident vÃ  phÃª duyá»‡t |
| Security, Governance, and Notification | Quáº£n lÃ½ quyá»n, theo dÃµi cáº¥u hÃ¬nh vÃ  gá»­i cáº£nh bÃ¡o |

Kiáº¿n trÃºc nÃ y giÃºp mÃ´ phá»ng má»™t quy trÃ¬nh SOC cÆ¡ báº£n trÃªn AWS, trong Ä‘Ã³ cÃ¡c bÆ°á»›c phÃ¡t hiá»‡n, Ä‘iá»u tra, pháº£n á»©ng vÃ  cáº£nh bÃ¡o Ä‘Æ°á»£c tá»± Ä‘á»™ng hÃ³a theo hÆ°á»›ng cÃ³ kiá»ƒm soÃ¡t.