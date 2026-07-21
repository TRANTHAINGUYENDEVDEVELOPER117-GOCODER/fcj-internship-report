---
title : "Logging and Evidence Storage"
date : 2026-07-01
weight : 2
chapter : false
pre : " <b> 5.4.2. </b> "
---

#### Logging and Evidence Storage

Trong pháº§n nÃ y, chÃºng ta sáº½ cáº¥u hÃ¬nh lá»›p **Logging and Evidence Storage** cho há»‡ thá»‘ng AWS CloudSOC. ÄÃ¢y lÃ  lá»›p chá»‹u trÃ¡ch nhiá»‡m ghi nháº­n log, lÆ°u trá»¯ báº±ng chá»©ng sá»± cá»‘ vÃ  chuáº©n bá»‹ dá»¯ liá»‡u phá»¥c vá»¥ quÃ¡ trÃ¬nh Ä‘iá»u tra sau khi phÃ¡t hiá»‡n má»‘i Ä‘e dá»a.

CÃ¡c log vÃ  báº±ng chá»©ng thu tháº­p Ä‘Æ°á»£c sáº½ Ä‘Æ°á»£c lÆ°u trá»¯ trong Amazon S3 vÃ  Amazon CloudWatch. Nhá»¯ng dá»¯ liá»‡u nÃ y sáº½ há»— trá»£ SOC Analyst trong quÃ¡ trÃ¬nh phÃ¢n tÃ­ch incident, kiá»ƒm tra hÃ nh vi báº¥t thÆ°á»ng vÃ  xÃ¡c minh káº¿t quáº£ pháº£n á»©ng sá»± cá»‘.

---

#### Má»¥c tiÃªu

Sau khi hoÃ n thÃ nh pháº§n nÃ y, báº¡n sáº½ cÃ³:

+ Má»™t S3 bucket dÃ¹ng Ä‘á»ƒ lÆ°u CloudTrail audit logs.
+ Má»™t S3 bucket dÃ¹ng Ä‘á»ƒ lÆ°u forensic evidence.
+ AWS CloudTrail Ä‘Æ°á»£c báº­t Ä‘á»ƒ ghi láº¡i management events.
+ Amazon CloudWatch Logs Ä‘Æ°á»£c chuáº©n bá»‹ Ä‘á»ƒ lÆ°u log.
+ VPC Flow Logs Ä‘Æ°á»£c báº­t Ä‘á»ƒ ghi nháº­n metadata cá»§a network traffic.
+ AWS KMS key Ä‘Æ°á»£c chuáº©n bá»‹ Ä‘á»ƒ mÃ£ hÃ³a dá»¯ liá»‡u náº¿u cáº§n.
+ Cáº¥u trÃºc thÆ° má»¥c S3 dÃ¹ng Ä‘á»ƒ lÆ°u evidence theo tá»«ng incident.

---

#### Kiáº¿n trÃºc Logging and Evidence Storage

SÆ¡ Ä‘á»“ sau minh há»a lá»›p Logging and Evidence Storage trong há»‡ thá»‘ng AWS CloudSOC.

![Logging and Evidence Storage](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/logging-evidence-architecture.png)

Luá»“ng logging vÃ  evidence chÃ­nh:

```text
CloudTrail â†’ S3 Audit Logs
CloudTrail â†’ CloudWatch Logs
VPC Flow Logs â†’ CloudWatch Logs
Systems Manager â†’ S3 Evidence Bucket
Incident Response Lambda â†’ S3 Evidence Bucket
Incident Response Lambda â†’ CloudWatch Logs
KMS â†’ S3 Encryption
```

---

#### ThÃ´ng tin cáº¥u hÃ¬nh Ä‘á» xuáº¥t

Báº¡n cÃ³ thá»ƒ sá»­ dá»¥ng cÃ¡c thÃ´ng tin cáº¥u hÃ¬nh sau cho workshop:

| ThÃ nh pháº§n | GiÃ¡ trá»‹ Ä‘á» xuáº¥t |
|---|---|
| Audit Log Bucket | `cloudsoc-audit-logs-<account-id>` |
| Evidence Bucket | `cloudsoc-evidence-<account-id>` |
| CloudTrail Name | `cloudsoc-cloudtrail` |
| CloudWatch Log Group for CloudTrail | `/aws/cloudtrail/cloudsoc` |
| VPC Flow Logs Log Group | `/aws/vpc-flowlogs/cloudsoc-vpc` |
| KMS Alias | `alias/cloudsoc-evidence-key` |
| S3 Evidence Prefix | `incidents/` |
| S3 Forensic Prefix | `forensics/` |

> **LÆ°u Ã½:** TÃªn S3 bucket pháº£i lÃ  duy nháº¥t toÃ n cáº§u. VÃ¬ váº­y, nÃªn thÃªm Account ID hoáº·c má»™t chuá»—i ngáº«u nhiÃªn vÃ o cuá»‘i tÃªn bucket.

---

#### BÆ°á»›c 1: Táº¡o S3 Bucket lÆ°u Audit Logs

Má»Ÿ dá»‹ch vá»¥ **Amazon S3**, chá»n:

```text
Buckets â†’ Create bucket
```

Cáº¥u hÃ¬nh bucket:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Bucket name | `cloudsoc-audit-logs-<account-id>` |
| AWS Region | `ap-southeast-1` |
| Object Ownership | ACLs disabled |
| Block Public Access | Block all public access |
| Bucket Versioning | Enable |
| Default encryption | SSE-S3 hoáº·c SSE-KMS |

Sau Ä‘Ã³ chá»n **Create bucket**.

Bucket nÃ y Ä‘Æ°á»£c sá»­ dá»¥ng Ä‘á»ƒ lÆ°u log tá»« AWS CloudTrail.

Káº¿t quáº£ mong Ä‘á»£i:

```text
S3 bucket cloudsoc-audit-logs-<account-id> Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![Create Audit Logs Bucket](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/create-audit-logs-bucket.png)

---

#### BÆ°á»›c 2: Táº¡o S3 Bucket lÆ°u Evidence

Tiáº¿p tá»¥c táº¡o bucket thá»© hai Ä‘á»ƒ lÆ°u evidence vÃ  forensic output.

Trong Amazon S3, chá»n:

```text
Buckets â†’ Create bucket
```

Cáº¥u hÃ¬nh bucket:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Bucket name | `cloudsoc-evidence-<account-id>` |
| AWS Region | `ap-southeast-1` |
| Object Ownership | ACLs disabled |
| Block Public Access | Block all public access |
| Bucket Versioning | Enable |
| Default encryption | SSE-S3 hoáº·c SSE-KMS |

Bucket nÃ y dÃ¹ng Ä‘á»ƒ lÆ°u:

+ Forensic output tá»« Systems Manager.
+ Incident evidence tá»« Lambda.
+ Metadata liÃªn quan Ä‘áº¿n snapshot.
+ File JSON mÃ´ táº£ incident.

Káº¿t quáº£ mong Ä‘á»£i:

```text
S3 bucket cloudsoc-evidence-<account-id> Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![Create Evidence Bucket](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/create-evidence-bucket.png)

---

#### BÆ°á»›c 3: Táº¡o cáº¥u trÃºc thÆ° má»¥c trong Evidence Bucket

Má»Ÿ bucket:

```text
cloudsoc-evidence-<account-id>
```

Táº¡o cÃ¡c folder/prefix sau:

```text
incidents/
forensics/
snapshots/
lambda-output/
```

Ã nghÄ©a tá»«ng folder:

| Prefix | Má»¥c Ä‘Ã­ch |
|---|---|
| `incidents/` | LÆ°u thÃ´ng tin incident theo tá»«ng finding |
| `forensics/` | LÆ°u output thu tháº­p tá»« Systems Manager |
| `snapshots/` | LÆ°u metadata liÃªn quan Ä‘áº¿n EBS Snapshot |
| `lambda-output/` | LÆ°u káº¿t quáº£ xá»­ lÃ½ tá»« Lambda |

Káº¿t quáº£ mong Ä‘á»£i:

```text
Evidence bucket Ä‘Ã£ cÃ³ cáº¥u trÃºc folder phá»¥c vá»¥ lÆ°u trá»¯ báº±ng chá»©ng.
```

![Evidence Bucket Folders](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/evidence-bucket-folders.png)

---

#### BÆ°á»›c 4: Táº¡o KMS Key cho Evidence Storage

AWS KMS Ä‘Æ°á»£c sá»­ dá»¥ng Ä‘á»ƒ mÃ£ hÃ³a dá»¯ liá»‡u nháº¡y cáº£m trong S3 náº¿u cáº§n. Trong mÃ´i trÆ°á»ng lab, báº¡n cÃ³ thá»ƒ dÃ¹ng SSE-S3 Ä‘á»ƒ Ä‘Æ¡n giáº£n hÃ³a. Tuy nhiÃªn, Ä‘á»ƒ kiáº¿n trÃºc báº£o máº­t Ä‘áº§y Ä‘á»§ hÆ¡n, nÃªn chuáº©n bá»‹ KMS key riÃªng cho evidence bucket.

Má»Ÿ dá»‹ch vá»¥ **AWS KMS**, chá»n:

```text
Customer managed keys â†’ Create key
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Key type | Symmetric |
| Key usage | Encrypt and decrypt |
| Alias | `alias/cloudsoc-evidence-key` |
| Key administrators | Chá»n user/role quáº£n trá»‹ |
| Key users | Chá»n cÃ¡c role cáº§n dÃ¹ng key |

CÃ¡c role cÃ³ thá»ƒ cáº§n quyá»n sá»­ dá»¥ng KMS key:

+ Incident Response Lambda Role
+ Step Functions Workflow Role
+ EC2 SSM Instance Role

Káº¿t quáº£ mong Ä‘á»£i:

```text
KMS key alias/cloudsoc-evidence-key Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![Create KMS Key](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/create-kms-key.png)

---

#### BÆ°á»›c 5: Báº­t CloudTrail

AWS CloudTrail Ä‘Æ°á»£c sá»­ dá»¥ng Ä‘á»ƒ ghi láº¡i cÃ¡c management events trong AWS account. Nhá»¯ng event nÃ y giÃºp SOC Analyst biáº¿t Ä‘Æ°á»£c ai Ä‘Ã£ thá»±c hiá»‡n hÃ nh Ä‘á»™ng gÃ¬, trÃªn tÃ i nguyÃªn nÃ o vÃ  vÃ o thá»i Ä‘iá»ƒm nÃ o.

Má»Ÿ dá»‹ch vá»¥ **AWS CloudTrail**, chá»n:

```text
Trails â†’ Create trail
```

Cáº¥u hÃ¬nh trail:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Trail name | `cloudsoc-cloudtrail` |
| Storage location | Use existing S3 bucket |
| S3 bucket | `cloudsoc-audit-logs-<account-id>` |
| Log file SSE-KMS encryption | Enable náº¿u dÃ¹ng KMS |
| CloudWatch Logs | Enable |
| Log group | `/aws/cloudtrail/cloudsoc` |

á»ž pháº§n **Events**, chá»n:

```text
Management events
```

Chá»n:

```text
Read
Write
```

Sau Ä‘Ã³ chá»n **Create trail**.

Káº¿t quáº£ mong Ä‘á»£i:

```text
CloudTrail cloudsoc-cloudtrail Ä‘Æ°á»£c báº­t vÃ  ghi log vÃ o S3 / CloudWatch.
```

![Create CloudTrail](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/create-cloudtrail.png)

---

#### BÆ°á»›c 6: Kiá»ƒm tra CloudTrail Logs trong S3

Sau khi báº­t CloudTrail, chá» vÃ i phÃºt Ä‘á»ƒ log Ä‘Æ°á»£c ghi vÃ o S3.

Má»Ÿ bucket:

```text
cloudsoc-audit-logs-<account-id>
```

Kiá»ƒm tra thÆ° má»¥c log CloudTrail:

```text
AWSLogs/
```

BÃªn trong sáº½ cÃ³ log theo cáº¥u trÃºc account, region vÃ  ngÃ y.

Káº¿t quáº£ mong Ä‘á»£i:

```text
CloudTrail log files xuáº¥t hiá»‡n trong S3 audit logs bucket.
```

![CloudTrail Logs in S3](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/cloudtrail-logs-s3.png)

---

#### BÆ°á»›c 7: Táº¡o CloudWatch Log Group cho VPC Flow Logs

Má»Ÿ dá»‹ch vá»¥ **Amazon CloudWatch**, chá»n:

```text
Logs â†’ Log groups â†’ Create log group
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Log group name | `/aws/vpc-flowlogs/cloudsoc-vpc` |
| Retention setting | 7 days hoáº·c 14 days |

Chá»n **Create**.

Káº¿t quáº£ mong Ä‘á»£i:

```text
CloudWatch Log Group cho VPC Flow Logs Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![Create VPC Flow Logs Log Group](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/vpc-flowlogs-cloudwatch.png)

---

#### BÆ°á»›c 8: Báº­t VPC Flow Logs

VPC Flow Logs Ä‘Æ°á»£c sá»­ dá»¥ng Ä‘á»ƒ ghi nháº­n metadata cá»§a network traffic trong VPC. Trong workshop nÃ y, log Ä‘Æ°á»£c gá»­i Ä‘áº¿n CloudWatch Logs Ä‘á»ƒ dá»… quan sÃ¡t.

Má»Ÿ dá»‹ch vá»¥ **VPC**, chá»n:

```text
Your VPCs â†’ cloudsoc-vpc â†’ Flow logs
```

Chá»n:

```text
Create flow log
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Name | `cloudsoc-vpc-flowlogs` |
| Filter | All |
| Maximum aggregation interval | 1 minute |
| Destination | Send to CloudWatch Logs |
| Destination log group | `/aws/vpc-flowlogs/cloudsoc-vpc` |
| IAM role | Role cho phÃ©p VPC Flow Logs ghi vÃ o CloudWatch |

Náº¿u chÆ°a cÃ³ IAM Role cho VPC Flow Logs, táº¡o role má»›i theo hÆ°á»›ng dáº«n trÃªn AWS Console.

Káº¿t quáº£ mong Ä‘á»£i:

```text
VPC Flow Logs Ä‘Æ°á»£c báº­t cho cloudsoc-vpc vÃ  gá»­i log Ä‘áº¿n CloudWatch.
```

![Create VPC Flow Logs](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/create-vpc-flowlogs.png)

---

#### BÆ°á»›c 9: Kiá»ƒm tra VPC Flow Logs trong CloudWatch

Sau khi báº­t VPC Flow Logs, chá» vÃ i phÃºt rá»“i má»Ÿ:

```text
CloudWatch â†’ Logs â†’ Log groups
```

Chá»n log group:

```text
/aws/vpc-flowlogs/cloudsoc-vpc
```

Kiá»ƒm tra cÃ¡c log stream Ä‘Æ°á»£c táº¡o.

Káº¿t quáº£ mong Ä‘á»£i:

```text
VPC Flow Logs xuáº¥t hiá»‡n trong CloudWatch Logs.
```

![VPC Flow Logs in CloudWatch](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.2-Logging-And-Evidence-Storage/vpc-flowlogs-cloudwatch.png)

---

#### BÆ°á»›c 10: Chuáº©n bá»‹ nÆ¡i lÆ°u forensic output tá»« Systems Manager

Trong cÃ¡c pháº§n sau, Systems Manager sáº½ cháº¡y command trÃªn EC2 Ä‘á»ƒ thu tháº­p forensic evidence. Output cá»§a command cÃ³ thá»ƒ Ä‘Æ°á»£c lÆ°u vÃ o S3 evidence bucket.

ÄÆ°á»ng dáº«n lÆ°u forensic output Ä‘á» xuáº¥t:

```text
s3://cloudsoc-evidence-<account-id>/forensics/
```

Khi cháº¡y Systems Manager Run Command, cáº¥u hÃ¬nh output nhÆ° sau:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| S3 bucket name | `cloudsoc-evidence-<account-id>` |
| S3 key prefix | `forensics/` |
| CloudWatch output | Enable náº¿u cáº§n |

Káº¿t quáº£ mong Ä‘á»£i:

```text
S3 evidence bucket Ä‘Ã£ sáºµn sÃ ng Ä‘á»ƒ lÆ°u forensic output tá»« Systems Manager.
```

---

#### BÆ°á»›c 11: Chuáº©n bá»‹ nÆ¡i lÆ°u incident evidence tá»« Lambda

Incident Response Lambda sáº½ lÆ°u káº¿t quáº£ xá»­ lÃ½ incident vÃ o S3 evidence bucket.

ÄÆ°á»ng dáº«n lÆ°u incident evidence Ä‘á» xuáº¥t:

```text
s3://cloudsoc-evidence-<account-id>/incidents/
```

VÃ­ dá»¥ cáº¥u trÃºc evidence theo tá»«ng incident:

```text
incidents/
â””â”€â”€ finding-id/
    â”œâ”€â”€ finding.json
    â”œâ”€â”€ response-result.json
    â”œâ”€â”€ isolation-status.json
    â””â”€â”€ snapshot-metadata.json
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
S3 evidence bucket Ä‘Ã£ sáºµn sÃ ng Ä‘á»ƒ lÆ°u incident evidence tá»« Lambda.
```

---

#### BÆ°á»›c 12: Kiá»ƒm tra CloudWatch Logs cho Lambda

Trong cÃ¡c pháº§n sau, khi Lambda Ä‘Æ°á»£c táº¡o vÃ  thá»±c thi, CloudWatch sáº½ tá»± Ä‘á»™ng táº¡o log group tÆ°Æ¡ng á»©ng.

Log group Lambda thÆ°á»ng cÃ³ dáº¡ng:

```text
/aws/lambda/<lambda-function-name>
```

VÃ­ dá»¥:

```text
/aws/lambda/cloudsoc-incident-response-lambda
/aws/lambda/cloudsoc-dashboard-api-lambda
```

CÃ¡c log nÃ y dÃ¹ng Ä‘á»ƒ kiá»ƒm tra:

+ Lambda cÃ³ Ä‘Æ°á»£c invoke hay khÃ´ng.
+ Lambda xá»­ lÃ½ finding thÃ nh cÃ´ng hay tháº¥t báº¡i.
+ Lambda cÃ³ lá»—i permission hay khÃ´ng.
+ Lambda cÃ³ cáº­p nháº­t DynamoDB hoáº·c S3 thÃ nh cÃ´ng hay khÃ´ng.

Káº¿t quáº£ mong Ä‘á»£i:

```text
CloudWatch Logs Ä‘Ã£ sáºµn sÃ ng Ä‘á»ƒ lÆ°u execution logs cá»§a Lambda.
```

---

#### Kiá»ƒm tra sau khi hoÃ n thÃ nh

Sau khi hoÃ n thÃ nh pháº§n nÃ y, kiá»ƒm tra láº¡i cÃ¡c má»¥c sau:

- [ ] S3 bucket `cloudsoc-audit-logs-<account-id>` Ä‘Ã£ Ä‘Æ°á»£c táº¡o.
- [ ] S3 bucket `cloudsoc-evidence-<account-id>` Ä‘Ã£ Ä‘Æ°á»£c táº¡o.
- [ ] Block Public Access Ä‘Ã£ Ä‘Æ°á»£c báº­t cho cáº£ hai bucket.
- [ ] Bucket Versioning Ä‘Ã£ Ä‘Æ°á»£c báº­t cho cÃ¡c bucket quan trá»ng.
- [ ] Evidence bucket cÃ³ cÃ¡c prefix `incidents/`, `forensics/`, `snapshots/`, `lambda-output/`.
- [ ] KMS key `alias/cloudsoc-evidence-key` Ä‘Ã£ Ä‘Æ°á»£c táº¡o náº¿u dÃ¹ng SSE-KMS.
- [ ] CloudTrail `cloudsoc-cloudtrail` Ä‘Ã£ Ä‘Æ°á»£c báº­t.
- [ ] CloudTrail ghi log vÃ o S3 audit logs bucket.
- [ ] CloudTrail cÃ³ thá»ƒ gá»­i log Ä‘áº¿n CloudWatch Logs.
- [ ] VPC Flow Logs Ä‘Ã£ Ä‘Æ°á»£c báº­t cho `cloudsoc-vpc`.
- [ ] VPC Flow Logs gá»­i log Ä‘áº¿n CloudWatch Logs.
- [ ] Evidence bucket Ä‘Ã£ sáºµn sÃ ng Ä‘á»ƒ nháº­n forensic output tá»« Systems Manager.
- [ ] Evidence bucket Ä‘Ã£ sáºµn sÃ ng Ä‘á»ƒ nháº­n incident evidence tá»« Lambda.

---

#### Káº¿t quáº£ sau khi hoÃ n thÃ nh

Sau khi hoÃ n thÃ nh pháº§n nÃ y, há»‡ thá»‘ng AWS CloudSOC Ä‘Ã£ cÃ³ ná»n táº£ng logging vÃ  evidence storage.

CÃ¡c thÃ nh pháº§n Ä‘Ã£ sáºµn sÃ ng gá»“m:

```text
CloudTrail
Amazon S3
Amazon CloudWatch Logs
VPC Flow Logs
AWS KMS
Evidence folder structure
```

Lá»›p nÃ y giÃºp há»‡ thá»‘ng lÆ°u láº¡i audit logs, network flow logs vÃ  báº±ng chá»©ng sá»± cá»‘. ÄÃ¢y lÃ  dá»¯ liá»‡u quan trá»ng Ä‘á»ƒ SOC Analyst Ä‘iá»u tra, xÃ¡c minh vÃ  bÃ¡o cÃ¡o sau khi incident xáº£y ra.

---

#### TÃ³m táº¯t

Trong pháº§n nÃ y, chÃºng ta Ä‘Ã£ cáº¥u hÃ¬nh cÃ¡c thÃ nh pháº§n phá»¥c vá»¥ logging vÃ  lÆ°u trá»¯ báº±ng chá»©ng cho AWS CloudSOC. CloudTrail ghi láº¡i management events, VPC Flow Logs ghi láº¡i metadata cá»§a network traffic, CloudWatch Logs há»— trá»£ quan sÃ¡t log, cÃ²n Amazon S3 Ä‘Æ°á»£c sá»­ dá»¥ng Ä‘á»ƒ lÆ°u audit logs vÃ  forensic evidence.

á»ž pháº§n tiáº¿p theo, chÃºng ta sáº½ báº­t cÃ¡c dá»‹ch vá»¥ **Threat Detection Services** nhÆ° Amazon GuardDuty, AWS Security Hub, Amazon Detective vÃ  AWS Config Ä‘á»ƒ phÃ¡t hiá»‡n vÃ  phÃ¢n tÃ­ch cÃ¡c má»‘i Ä‘e dá»a trong mÃ´i trÆ°á»ng AWS.