---
title : "Threat Detection Services"
date : 2027-07-01
weight : 3
chapter : false
pre : " <b> 5.4.3. </b> "
---

#### Threat Detection Services

Trong pháº§n nÃ y, chÃºng ta sáº½ báº­t vÃ  cáº¥u hÃ¬nh cÃ¡c dá»‹ch vá»¥ phÃ¡t hiá»‡n má»‘i Ä‘e dá»a cho há»‡ thá»‘ng **AWS CloudSOC**. ÄÃ¢y lÃ  lá»›p chá»‹u trÃ¡ch nhiá»‡m phÃ¡t hiá»‡n hÃ nh vi Ä‘Ã¡ng ngá», táº­p trung security findings vÃ  há»— trá»£ SOC Analyst trong quÃ¡ trÃ¬nh Ä‘iá»u tra sá»± cá»‘.

CÃ¡c dá»‹ch vá»¥ chÃ­nh Ä‘Æ°á»£c sá»­ dá»¥ng trong pháº§n nÃ y gá»“m:

+ Amazon GuardDuty
+ AWS Security Hub
+ Amazon Detective
+ AWS Config

Trong kiáº¿n trÃºc CloudSOC, Amazon GuardDuty Ä‘Ã³ng vai trÃ² lÃ  dá»‹ch vá»¥ phÃ¡t hiá»‡n má»‘i Ä‘e dá»a chÃ­nh. Khi GuardDuty phÃ¡t hiá»‡n hÃ nh vi báº¥t thÆ°á»ng, finding sáº½ Ä‘Æ°á»£c gá»­i Ä‘áº¿n Security Hub, Detective vÃ  EventBridge Ä‘á»ƒ phá»¥c vá»¥ phÃ¢n tÃ­ch vÃ  kÃ­ch hoáº¡t workflow pháº£n á»©ng sá»± cá»‘.

---

#### Má»¥c tiÃªu

Sau khi hoÃ n thÃ nh pháº§n nÃ y, báº¡n sáº½ cÃ³:

+ Amazon GuardDuty Ä‘Æ°á»£c báº­t trong Region `ap-southeast-1`.
+ AWS Security Hub Ä‘Æ°á»£c báº­t Ä‘á»ƒ táº­p trung security findings.
+ Amazon Detective Ä‘Æ°á»£c báº­t Ä‘á»ƒ há»— trá»£ Ä‘iá»u tra finding.
+ AWS Config Ä‘Æ°á»£c báº­t Ä‘á»ƒ theo dÃµi thay Ä‘á»•i cáº¥u hÃ¬nh tÃ i nguyÃªn.
+ GuardDuty findings sáºµn sÃ ng Ä‘á»ƒ gá»­i sang EventBridge trong pháº§n tiáº¿p theo.
+ SOC Analyst cÃ³ thá»ƒ xem finding trong GuardDuty, Security Hub vÃ  Detective.

---

#### Kiáº¿n trÃºc Threat Detection Services

SÆ¡ Ä‘á»“ sau minh há»a lá»›p Threat Detection Services trong há»‡ thá»‘ng AWS CloudSOC.

![Threat Detection Services Architecture](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/threat-detection-architecture.png)

Luá»“ng phÃ¡t hiá»‡n má»‘i Ä‘e dá»a chÃ­nh:

```text
AWS Telemetry
â†’ Amazon GuardDuty
â†’ AWS Security Hub
â†’ Amazon Detective
â†’ Amazon EventBridge
â†’ Step Functions Response Workflow
```

Amazon GuardDuty phÃ¢n tÃ­ch cÃ¡c nguá»“n telemetry do AWS quáº£n lÃ½ nhÆ° CloudTrail management events, VPC Flow Logs vÃ  DNS logs. Khi phÃ¡t hiá»‡n hoáº¡t Ä‘á»™ng Ä‘Ã¡ng ngá», GuardDuty táº¡o ra security finding. Finding nÃ y sáº½ Ä‘Æ°á»£c sá»­ dá»¥ng á»Ÿ cÃ¡c pháº§n sau Ä‘á»ƒ kÃ­ch hoáº¡t EventBridge vÃ  Step Functions.

---

#### ThÃ´ng tin cáº¥u hÃ¬nh Ä‘á» xuáº¥t

Báº¡n cÃ³ thá»ƒ sá»­ dá»¥ng cÃ¡c thÃ´ng tin cáº¥u hÃ¬nh sau cho workshop:

| ThÃ nh pháº§n | GiÃ¡ trá»‹ Ä‘á» xuáº¥t |
|---|---|
| Region | `ap-southeast-1` |
| GuardDuty | Enabled |
| Security Hub | Enabled |
| Detective | Enabled |
| AWS Config | Enabled |
| Config Recorder | Record all supported resources |
| Config Delivery Channel | S3 bucket hoáº·c bucket máº·c Ä‘á»‹nh |
| Main Finding Source | Amazon GuardDuty |
| Finding Target | EventBridge Rule |

---

#### BÆ°á»›c 1: Báº­t Amazon GuardDuty

Má»Ÿ dá»‹ch vá»¥ **Amazon GuardDuty** trong AWS Management Console.

Chá»n:

```text
GuardDuty â†’ Get started
```

Sau Ä‘Ã³ chá»n:

```text
Enable GuardDuty
```

GuardDuty sáº½ báº¯t Ä‘áº§u phÃ¢n tÃ­ch cÃ¡c nguá»“n dá»¯ liá»‡u báº£o máº­t trong AWS account Ä‘á»ƒ phÃ¡t hiá»‡n hÃ nh vi Ä‘Ã¡ng ngá».

Káº¿t quáº£ mong Ä‘á»£i:

```text
Amazon GuardDuty Ä‘Æ°á»£c báº­t thÃ nh cÃ´ng trong Region ap-southeast-1.
```

![Enable GuardDuty](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/enable-guardduty.png)

---

#### BÆ°á»›c 2: Kiá»ƒm tra tráº¡ng thÃ¡i GuardDuty

Sau khi báº­t GuardDuty, kiá»ƒm tra dashboard cá»§a GuardDuty.

VÃ o:

```text
GuardDuty â†’ Summary
```

Hoáº·c:

```text
GuardDuty â†’ Findings
```

á»ž thá»i Ä‘iá»ƒm má»›i báº­t, cÃ³ thá»ƒ chÆ°a cÃ³ finding tháº­t. Äiá»u nÃ y lÃ  bÃ¬nh thÆ°á»ng vÃ¬ GuardDuty cáº§n cÃ³ dá»¯ liá»‡u hoáº¡t Ä‘á»™ng Ä‘á»ƒ phÃ¢n tÃ­ch.

Káº¿t quáº£ mong Ä‘á»£i:

```text
GuardDuty status Ä‘ang hoáº¡t Ä‘á»™ng.
GuardDuty Findings page cÃ³ thá»ƒ truy cáº­p Ä‘Æ°á»£c.
```

![GuardDuty Dashboard](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/guardduty-dashboard.png)

---

#### BÆ°á»›c 3: Táº¡o GuardDuty Sample Findings

Äá»ƒ kiá»ƒm tra giao diá»‡n vÃ  chuáº©n bá»‹ dá»¯ liá»‡u cho pháº§n EventBridge, báº¡n cÃ³ thá»ƒ táº¡o sample findings trong GuardDuty.

VÃ o:

```text
GuardDuty â†’ Settings
```

TÃ¬m pháº§n:

```text
Sample findings
```

Chá»n:

```text
Generate sample findings
```

Sau khi táº¡o sample findings, quay láº¡i:

```text
GuardDuty â†’ Findings
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
CÃ¡c sample findings xuáº¥t hiá»‡n trong GuardDuty Findings.
```

![GuardDuty Sample Findings](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/guardduty-sample-findings.png)

> **LÆ°u Ã½:** Sample findings chá»‰ dÃ¹ng Ä‘á»ƒ kiá»ƒm tra giao diá»‡n vÃ  luá»“ng xá»­ lÃ½. Trong pháº§n Testing and Validation, chÃºng ta sáº½ kiá»ƒm thá»­ workflow vá»›i finding phÃ¹ há»£p hÆ¡n.

---

#### BÆ°á»›c 4: Báº­t AWS Security Hub

AWS Security Hub Ä‘Æ°á»£c sá»­ dá»¥ng Ä‘á»ƒ táº­p trung security findings tá»« nhiá»u dá»‹ch vá»¥ AWS. Trong workshop nÃ y, Security Hub nháº­n findings tá»« GuardDuty vÃ  hiá»ƒn thá»‹ chÃºng á»Ÿ má»™t nÆ¡i táº­p trung.

Má»Ÿ dá»‹ch vá»¥ **AWS Security Hub**.

Chá»n:

```text
Security Hub â†’ Go to Security Hub
```

Náº¿u láº§n Ä‘áº§u sá»­ dá»¥ng, chá»n:

```text
Enable Security Hub
```

Trong quÃ¡ trÃ¬nh báº­t Security Hub, báº¡n cÃ³ thá»ƒ giá»¯ cáº¥u hÃ¬nh máº·c Ä‘á»‹nh cho mÃ´i trÆ°á»ng lab.

Káº¿t quáº£ mong Ä‘á»£i:

```text
AWS Security Hub Ä‘Æ°á»£c báº­t thÃ nh cÃ´ng.
```

![Enable Security Hub](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/enable-security-hub.png)

---

#### BÆ°á»›c 5: Kiá»ƒm tra Findings trong Security Hub

Sau khi báº­t Security Hub, vÃ o:

```text
Security Hub â†’ Findings
```

Náº¿u GuardDuty Ä‘Ã£ táº¡o sample findings hoáº·c cÃ³ finding tháº­t, cÃ¡c finding nÃ y cÃ³ thá»ƒ xuáº¥t hiá»‡n trong Security Hub sau má»™t khoáº£ng thá»i gian ngáº¯n.

Káº¿t quáº£ mong Ä‘á»£i:

```text
Security Hub cÃ³ thá»ƒ hiá»ƒn thá»‹ findings tá»« GuardDuty.
```

![Security Hub Findings](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/security-hub-findings.png)

Security Hub giÃºp SOC Analyst:

+ Xem security findings táº­p trung.
+ Lá»c findings theo severity.
+ Kiá»ƒm tra tráº¡ng thÃ¡i finding.
+ Theo dÃµi compliance vÃ  security posture.
+ Káº¿t há»£p findings tá»« nhiá»u dá»‹ch vá»¥ báº£o máº­t AWS.

---

#### BÆ°á»›c 6: Báº­t Amazon Detective

Amazon Detective há»— trá»£ SOC Analyst Ä‘iá»u tra sÃ¢u hÆ¡n cÃ¡c hoáº¡t Ä‘á»™ng Ä‘Ã¡ng ngá». Detective giÃºp phÃ¢n tÃ­ch má»‘i quan há»‡ giá»¯a tÃ i nguyÃªn, API calls, network activity vÃ  findings.

Má»Ÿ dá»‹ch vá»¥ **Amazon Detective**.

Chá»n:

```text
Detective â†’ Get started
```

Sau Ä‘Ã³ chá»n:

```text
Enable Detective
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
Amazon Detective Ä‘Æ°á»£c báº­t thÃ nh cÃ´ng.
```

![Enable Detective](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/enable-detective.png)

---

#### BÆ°á»›c 7: Kiá»ƒm tra Detective Investigation

Sau khi báº­t Detective, dá»¯ liá»‡u cÃ³ thá»ƒ cáº§n má»™t khoáº£ng thá»i gian Ä‘á»ƒ Ä‘Æ°á»£c thu tháº­p vÃ  hiá»ƒn thá»‹.

VÃ o:

```text
Detective â†’ Search
```

Hoáº·c:

```text
Detective â†’ Investigations
```

SOC Analyst cÃ³ thá»ƒ sá»­ dá»¥ng Detective Ä‘á»ƒ Ä‘iá»u tra cÃ¡c Ä‘á»‘i tÆ°á»£ng nhÆ°:

+ AWS Account
+ IAM Role
+ EC2 Instance
+ IP address
+ GuardDuty finding

Káº¿t quáº£ mong Ä‘á»£i:

```text
Detective Ä‘Ã£ sáºµn sÃ ng Ä‘á»ƒ há»— trá»£ Ä‘iá»u tra security findings.
```

![Detective Investigation](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/detective-investigation.png)

---

#### BÆ°á»›c 8: Báº­t AWS Config

AWS Config Ä‘Æ°á»£c sá»­ dá»¥ng Ä‘á»ƒ theo dÃµi thay Ä‘á»•i cáº¥u hÃ¬nh cá»§a tÃ i nguyÃªn AWS. Trong CloudSOC, AWS Config giÃºp ghi nháº­n sá»± thay Ä‘á»•i cá»§a EC2, Security Group vÃ  cÃ¡c tÃ i nguyÃªn liÃªn quan.

Má»Ÿ dá»‹ch vá»¥ **AWS Config**.

Chá»n:

```text
AWS Config â†’ Get started
```

Cáº¥u hÃ¬nh cÆ¡ báº£n:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Resource types to record | Record all supported resources |
| AWS Config role | Create AWS Config service-linked role |
| Delivery method | Amazon S3 bucket |
| S3 bucket | Táº¡o má»›i hoáº·c chá»n bucket cÃ³ sáºµn |
| Frequency | Continuous recording |

Sau Ä‘Ã³ chá»n:

```text
Confirm
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
AWS Config Ä‘Æ°á»£c báº­t vÃ  báº¯t Ä‘áº§u ghi nháº­n thay Ä‘á»•i cáº¥u hÃ¬nh tÃ i nguyÃªn.
```

![Enable AWS Config](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/enable-aws-config.png)

---

#### BÆ°á»›c 9: Kiá»ƒm tra Resource Inventory trong AWS Config

Sau khi báº­t AWS Config, vÃ o:

```text
AWS Config â†’ Resources
```

TÃ¬m cÃ¡c tÃ i nguyÃªn liÃªn quan Ä‘áº¿n CloudSOC, vÃ­ dá»¥:

+ EC2 instance `cloudsoc-workload-ec2`
+ Security Group `SG-Workload`
+ Security Group `SG-Isolation`
+ VPC `cloudsoc-vpc`

Káº¿t quáº£ mong Ä‘á»£i:

```text
AWS Config ghi nháº­n cÃ¡c tÃ i nguyÃªn chÃ­nh cá»§a CloudSOC Lab.
```

![AWS Config Resources](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.3-Threat-Detection-Services/aws-config-resources.png)

AWS Config sáº½ há»¯u Ã­ch trong cÃ¡c pháº§n sau khi Lambda thay Ä‘á»•i security group cá»§a EC2 tá»«:

```text
SG-Workload â†’ SG-Isolation
```

Thay Ä‘á»•i nÃ y cÃ³ thá»ƒ Ä‘Æ°á»£c ghi nháº­n nhÆ° má»™t configuration change.

---

#### BÆ°á»›c 10: Kiá»ƒm tra liÃªn káº¿t GuardDuty vá»›i EventBridge

GuardDuty findings cÃ³ thá»ƒ Ä‘Æ°á»£c gá»­i Ä‘áº¿n Amazon EventBridge dÆ°á»›i dáº¡ng events. Trong pháº§n tiáº¿p theo, chÃºng ta sáº½ táº¡o EventBridge rule Ä‘á»ƒ báº¯t GuardDuty finding vÃ  kÃ­ch hoáº¡t Step Functions workflow.

á»ž pháº§n nÃ y, báº¡n chá»‰ cáº§n Ä‘áº£m báº£o GuardDuty Ä‘Ã£ Ä‘Æ°á»£c báº­t vÃ  cÃ³ thá»ƒ táº¡o finding.

Luá»“ng chuáº©n bá»‹ cho pháº§n sau:

```text
GuardDuty Finding
â†’ EventBridge Rule
â†’ Step Functions
â†’ Incident Response Workflow
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
GuardDuty Ä‘Ã£ sáºµn sÃ ng lÃ m nguá»“n sá»± kiá»‡n cho EventBridge.
```

---

#### Kiá»ƒm tra sau khi hoÃ n thÃ nh

Sau khi hoÃ n thÃ nh pháº§n nÃ y, kiá»ƒm tra láº¡i cÃ¡c má»¥c sau:

- [ ] Amazon GuardDuty Ä‘Ã£ Ä‘Æ°á»£c báº­t.
- [ ] GuardDuty Findings page cÃ³ thá»ƒ truy cáº­p Ä‘Æ°á»£c.
- [ ] GuardDuty sample findings Ä‘Ã£ Ä‘Æ°á»£c táº¡o náº¿u cáº§n.
- [ ] AWS Security Hub Ä‘Ã£ Ä‘Æ°á»£c báº­t.
- [ ] Security Hub cÃ³ thá»ƒ nháº­n findings tá»« GuardDuty.
- [ ] Amazon Detective Ä‘Ã£ Ä‘Æ°á»£c báº­t.
- [ ] Detective sáºµn sÃ ng há»— trá»£ Ä‘iá»u tra finding.
- [ ] AWS Config Ä‘Ã£ Ä‘Æ°á»£c báº­t.
- [ ] AWS Config cÃ³ thá»ƒ ghi nháº­n tÃ i nguyÃªn EC2 vÃ  Security Group.
- [ ] GuardDuty findings sáºµn sÃ ng Ä‘á»ƒ sá»­ dá»¥ng vá»›i EventBridge.

---

#### Káº¿t quáº£ sau khi hoÃ n thÃ nh

Sau khi hoÃ n thÃ nh pháº§n nÃ y, há»‡ thá»‘ng AWS CloudSOC Ä‘Ã£ cÃ³ lá»›p phÃ¡t hiá»‡n má»‘i Ä‘e dá»a vÃ  há»— trá»£ Ä‘iá»u tra sá»± cá»‘.

CÃ¡c thÃ nh pháº§n Ä‘Ã£ sáºµn sÃ ng gá»“m:

```text
Amazon GuardDuty
AWS Security Hub
Amazon Detective
AWS Config
```

Khi má»™t hoáº¡t Ä‘á»™ng Ä‘Ã¡ng ngá» xáº£y ra, GuardDuty sáº½ táº¡o security finding. Finding nÃ y cÃ³ thá»ƒ Ä‘Æ°á»£c Security Hub táº­p trung, Detective há»— trá»£ Ä‘iá»u tra vÃ  EventBridge sá»­ dá»¥ng Ä‘á»ƒ kÃ­ch hoáº¡t workflow pháº£n á»©ng sá»± cá»‘.

---

#### TÃ³m táº¯t

Trong pháº§n nÃ y, chÃºng ta Ä‘Ã£ báº­t cÃ¡c dá»‹ch vá»¥ phÃ¡t hiá»‡n vÃ  Ä‘iá»u tra má»‘i Ä‘e dá»a cho AWS CloudSOC. GuardDuty Ä‘Ã³ng vai trÃ² phÃ¡t hiá»‡n chÃ­nh, Security Hub táº­p trung findings, Detective há»— trá»£ Ä‘iá»u tra chuyÃªn sÃ¢u, cÃ²n AWS Config theo dÃµi thay Ä‘á»•i cáº¥u hÃ¬nh tÃ i nguyÃªn.

á»ž pháº§n tiáº¿p theo, chÃºng ta sáº½ cáº¥u hÃ¬nh **EventBridge and Step Functions Workflow** Ä‘á»ƒ tá»± Ä‘á»™ng xá»­ lÃ½ GuardDuty findings vÃ  báº¯t Ä‘áº§u quy trÃ¬nh pháº£n á»©ng sá»± cá»‘.