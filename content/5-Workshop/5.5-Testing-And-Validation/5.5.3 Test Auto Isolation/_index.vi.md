---
title : "Kiá»ƒm thá»­ Auto Isolation"
date : 2026-07-01
weight : 3
chapter : false
pre : " <b> 5.5.3. </b> "
---

#### Kiá»ƒm thá»­ Auto Isolation

Trong pháº§n nÃ y, chÃºng ta sáº½ kiá»ƒm thá»­ chá»©c nÄƒng **Auto Isolation** cá»§a há»‡ thá»‘ng AWS CloudSOC.

Má»¥c tiÃªu cá»§a bÃ i kiá»ƒm thá»­ lÃ  xÃ¡c nháº­n ráº±ng khi má»™t GuardDuty Finding nghiÃªm trá»ng liÃªn quan Ä‘áº¿n EC2 Ä‘Æ°á»£c xá»­ lÃ½, há»‡ thá»‘ng cÃ³ thá»ƒ tá»± Ä‘á»™ng thá»±c hiá»‡n cÃ¡c hÃ nh Ä‘á»™ng pháº£n á»©ng sá»± cá»‘ nhÆ° thu tháº­p forensic evidence, táº¡o EBS Snapshot, cáº­p nháº­t DynamoDB vÃ  cÃ´ láº­p EC2 báº±ng `SG-Isolation`.

Auto Isolation lÃ  pháº§n quan trá»ng nháº¥t trong quy trÃ¬nh pháº£n á»©ng sá»± cá»‘ tá»± Ä‘á»™ng cá»§a CloudSOC.

Luá»“ng tá»•ng quan:

```text
GuardDuty Finding
â†’ EventBridge / Step Functions
â†’ Incident Response Lambda
â†’ Systems Manager
â†’ EBS Snapshot
â†’ S3 Evidence Bucket
â†’ Replace SG-Workload with SG-Isolation
â†’ DynamoDB Incident Update
```

Trong pháº§n nÃ y, chÃºng ta sá»­ dá»¥ng má»™t sample event cÃ³ kiá»ƒm soÃ¡t Ä‘á»ƒ Ä‘áº£m báº£o event chá»©a Ä‘Ãºng EC2 instance ID cá»§a lab.

---

#### Má»¥c tiÃªu kiá»ƒm thá»­

Sau khi hoÃ n thÃ nh pháº§n nÃ y, chÃºng ta cÃ³ thá»ƒ xÃ¡c nháº­n ráº±ng:

+ Incident Response Lambda cÃ³ thá»ƒ nháº­n event mÃ´ phá»ng GuardDuty Finding.
+ Lambda xÃ¡c Ä‘á»‹nh Ä‘Ãºng EC2 instance cáº§n xá»­ lÃ½.
+ Lambda kiá»ƒm tra tag `AutoIsolate=true`.
+ Systems Manager cÃ³ thá»ƒ thu tháº­p forensic evidence tá»« EC2.
+ EBS Snapshot Ä‘Æ°á»£c táº¡o Ä‘á»ƒ phá»¥c vá»¥ Ä‘iá»u tra.
+ Evidence Ä‘Æ°á»£c lÆ°u vÃ o S3 Evidence Bucket.
+ EC2 Ä‘Æ°á»£c thay Security Group tá»« `SG-Workload` sang `SG-Isolation`.
+ DynamoDB Ä‘Æ°á»£c cáº­p nháº­t tráº¡ng thÃ¡i incident sau khi cÃ´ láº­p.

---

#### Kiáº¿n trÃºc kiá»ƒm thá»­

SÆ¡ Ä‘á»“ dÆ°á»›i Ä‘Ã¢y mÃ´ táº£ luá»“ng kiá»ƒm thá»­ Auto Isolation.

![Test Auto Isolation Flow](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/test-auto-isolation-flow.png)

Luá»“ng kiá»ƒm thá»­ gá»“m cÃ¡c bÆ°á»›c chÃ­nh:

```text
Sample GuardDuty Event
â†’ Incident Response Lambda
â†’ Validate EC2 Instance
â†’ Collect Evidence with SSM
â†’ Create EBS Snapshot
â†’ Store Evidence in S3
â†’ Apply SG-Isolation
â†’ Update DynamoDB
```

---

#### BÆ°á»›c 1: Kiá»ƒm tra EC2 trÆ°á»›c khi cÃ´ láº­p

TrÆ°á»›c khi thá»±c hiá»‡n auto isolation, EC2 workload cáº§n Ä‘ang á»Ÿ tráº¡ng thÃ¡i bÃ¬nh thÆ°á»ng vÃ  sá»­ dá»¥ng Security Group ban Ä‘áº§u.

EC2 workload trong lab:

```text
cloudsoc-workload-ec2
```

Tráº¡ng thÃ¡i mong Ä‘á»£i trÆ°á»›c khi test:

```text
Instance state: Running
Security Group: SG-Workload
AutoIsolate tag: true
```

![EC2 Before Auto Isolation](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/ec2-before-auto-isolation.png)

á»ž thá»i Ä‘iá»ƒm nÃ y, EC2 váº«n chÆ°a bá»‹ cÃ´ láº­p. Security Group hiá»‡n táº¡i cho tháº¥y instance Ä‘ang á»Ÿ tráº¡ng thÃ¡i hoáº¡t Ä‘á»™ng bÃ¬nh thÆ°á»ng trÆ°á»›c khi há»‡ thá»‘ng pháº£n á»©ng sá»± cá»‘.

---

#### BÆ°á»›c 2: Chuáº©n bá»‹ sample GuardDuty event

Äá»ƒ kiá»ƒm thá»­ chÃ­nh xÃ¡c, má»™t sample GuardDuty event Ä‘Æ°á»£c sá»­ dá»¥ng vá»›i Ä‘Ãºng EC2 instance ID cá»§a lab.

Sample event mÃ´ phá»ng má»™t finding cÃ³ má»©c Ä‘á»™ nghiÃªm trá»ng cao:

```json
{
  "version": "0",
  "id": "sample-guardduty-event",
  "detail-type": "GuardDuty Finding",
  "source": "aws.guardduty",
  "region": "ap-southeast-1",
  "detail": {
    "id": "sample-finding-001",
    "severity": 8.5,
    "type": "UnauthorizedAccess:EC2/SSHBruteForce",
    "title": "Sample GuardDuty finding for EC2 SSH brute force",
    "resource": {
      "resourceType": "Instance",
      "instanceDetails": {
        "instanceId": "i-0aa99a09aeb62061c"
      }
    }
  }
}
```

Sample event nÃ y giÃºp kiá»ƒm tra chÃ­nh xÃ¡c luá»“ng auto response mÃ  khÃ´ng cáº§n thá»±c hiá»‡n hÃ nh vi táº¥n cÃ´ng tháº­t.

![Lambda Auto Isolation Test Event](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/lambda-auto-isolation-test-event.png)

Event cÃ³ cÃ¡c thÃ´ng tin quan trá»ng:

| Field | Ã nghÄ©a |
|---|---|
| `detail-type` | Loáº¡i event lÃ  GuardDuty Finding |
| `severity` | Má»©c Ä‘á»™ nghiÃªm trá»ng cá»§a finding |
| `type` | Loáº¡i hÃ nh vi báº¥t thÆ°á»ng |
| `resourceType` | TÃ i nguyÃªn bá»‹ áº£nh hÆ°á»Ÿng |
| `instanceId` | EC2 instance cáº§n xá»­ lÃ½ |

---

#### BÆ°á»›c 3: Cháº¡y Incident Response Lambda

Sau khi chuáº©n bá»‹ sample event, Incident Response Lambda Ä‘Æ°á»£c cháº¡y Ä‘á»ƒ kiá»ƒm thá»­ luá»“ng auto isolation.

Lambda sá»­ dá»¥ng trong lab:

```text
cloudsoc-incident-response-lambda
```

Khi Lambda Ä‘Æ°á»£c kÃ­ch hoáº¡t, cÃ¡c bÆ°á»›c xá»­ lÃ½ chÃ­nh gá»“m:

```text
1. Äá»c GuardDuty Finding event.
2. Láº¥y EC2 instance ID tá»« event.
3. Kiá»ƒm tra EC2 instance cÃ³ tá»“n táº¡i hay khÃ´ng.
4. Kiá»ƒm tra tag AutoIsolate=true.
5. Thu tháº­p forensic evidence báº±ng Systems Manager.
6. Táº¡o EBS Snapshot.
7. LÆ°u evidence vÃ o S3.
8. Thay Security Group cá»§a EC2 sang SG-Isolation.
9. Cáº­p nháº­t incident status vÃ o DynamoDB.
```

![Lambda Auto Isolation Success](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/lambda-auto-isolation-success.png)

Káº¿t quáº£ Lambda thÃ nh cÃ´ng cho tháº¥y há»‡ thá»‘ng Ä‘Ã£ xá»­ lÃ½ Ä‘Æ°á»£c event vÃ  thá»±c hiá»‡n cÃ¡c hÃ nh Ä‘á»™ng pháº£n á»©ng sá»± cá»‘.

---

#### BÆ°á»›c 4: Kiá»ƒm tra Systems Manager forensic command

Trong quÃ¡ trÃ¬nh auto isolation, Lambda sá»­ dá»¥ng AWS Systems Manager Ä‘á»ƒ cháº¡y command thu tháº­p thÃ´ng tin forensic cÆ¡ báº£n tá»« EC2.

CÃ¡c thÃ´ng tin forensic cÃ³ thá»ƒ bao gá»“m:

```text
Hostname
Current user
System information
Uptime
Network connections
Running processes
Recent login history
Recent system logs
```

![SSM Forensic Command Output](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/ssm-forensic-command-output.png)

Káº¿t quáº£ nÃ y xÃ¡c nháº­n ráº±ng Systems Manager cÃ³ thá»ƒ giao tiáº¿p vá»›i EC2 vÃ  thá»±c hiá»‡n lá»‡nh thu tháº­p báº±ng chá»©ng.

---

#### BÆ°á»›c 5: Kiá»ƒm tra evidence trong S3

Sau khi Lambda xá»­ lÃ½ event, evidence Ä‘Æ°á»£c lÆ°u vÃ o S3 Evidence Bucket.

CÃ¡c object evidence cÃ³ thá»ƒ bao gá»“m:

```text
raw-event.json
response-summary.json
ssm-output/
```

![S3 Auto Isolation Evidence](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/s3-auto-isolation-evidence.png)

S3 Evidence Bucket Ä‘Ã³ng vai trÃ² lÆ°u trá»¯ báº±ng chá»©ng phá»¥c vá»¥ Ä‘iá»u tra sau sá»± cá»‘. CÃ¡c file nÃ y giÃºp SOC Analyst xem láº¡i event gá»‘c, káº¿t quáº£ xá»­ lÃ½ vÃ  dá»¯ liá»‡u forensic thu tháº­p Ä‘Æ°á»£c tá»« EC2.

---

#### BÆ°á»›c 6: Kiá»ƒm tra EBS Forensic Snapshot

Má»™t trong cÃ¡c hÃ nh Ä‘á»™ng quan trá»ng cá»§a auto isolation lÃ  táº¡o **EBS Snapshot** tá»« volume cá»§a EC2.

Snapshot giÃºp lÆ°u láº¡i tráº¡ng thÃ¡i volume táº¡i thá»i Ä‘iá»ƒm xáº£y ra incident, phá»¥c vá»¥ cho Ä‘iá»u tra forensic sau nÃ y.

![EBS Forensic Snapshot Created](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/ebs-forensic-snapshot-created.png)

Snapshot Ä‘Æ°á»£c gáº¯n cÃ¡c tag liÃªn quan Ä‘áº¿n incident, vÃ­ dá»¥:

```text
Project = AWS-CloudSOC
IncidentId = sample-finding-001
SourceInstanceId = i-0aa99a09aeb62061c
Purpose = Forensics
```

Viá»‡c táº¡o snapshot giÃºp báº£o toÃ n dá»¯ liá»‡u trÃªn volume trÆ°á»›c khi thá»±c hiá»‡n cÃ¡c bÆ°á»›c xá»­ lÃ½ tiáº¿p theo.

---

#### BÆ°á»›c 7: Kiá»ƒm tra EC2 sau khi cÃ´ láº­p

Sau khi Lambda hoÃ n táº¥t xá»­ lÃ½, EC2 workload sáº½ Ä‘Æ°á»£c thay Security Group tá»« `SG-Workload` sang `SG-Isolation`.

Tráº¡ng thÃ¡i mong Ä‘á»£i sau khi auto isolation:

```text
Instance state: Running
Security Group: SG-Isolation
Inbound rules: None
Outbound rules: None
```

![EC2 After Auto Isolation](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/ec2-after-auto-isolation.png)

Viá»‡c thay Security Group giÃºp cÃ´ láº­p EC2 khá»i cÃ¡c káº¿t ná»‘i khÃ´ng mong muá»‘n. Trong lab nÃ y, `SG-Isolation` Ä‘Æ°á»£c cáº¥u hÃ¬nh khÃ´ng cÃ³ inbound vÃ  outbound rules Ä‘á»ƒ giáº£m kháº£ nÄƒng EC2 tiáº¿p tá»¥c giao tiáº¿p máº¡ng.

---

#### BÆ°á»›c 8: Kiá»ƒm tra DynamoDB incident status

Sau khi EC2 Ä‘Æ°á»£c cÃ´ láº­p, DynamoDB Incident Table Ä‘Æ°á»£c cáº­p nháº­t tráº¡ng thÃ¡i má»›i.

![DynamoDB Auto Isolation Updated](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/dynamodb-auto-isolation-updated.png)

Káº¿t quáº£ mong Ä‘á»£i:

```text
approvalStatus = Approved
incidentStatus = Isolated
responseMode = AutoResponse
isolationSecurityGroupId = SG-Isolation
snapshotIds = Created
ssmCommandId = Created
evidencePath = S3 path
```

DynamoDB giÃºp SOC Analyst theo dÃµi tráº¡ng thÃ¡i xá»­ lÃ½ incident vÃ  xÃ¡c nháº­n ráº±ng auto isolation Ä‘Ã£ hoÃ n táº¥t.

---

#### BÆ°á»›c 9: Kiá»ƒm tra Step Functions Auto Response execution

Náº¿u auto isolation Ä‘Æ°á»£c kÃ­ch hoáº¡t thÃ´ng qua Step Functions, execution sáº½ Ä‘i qua nhÃ¡nh `Auto Response`.

![Step Functions Auto Response Execution](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/stepfunctions-auto-response-execution.png)

Execution thÃ nh cÃ´ng xÃ¡c nháº­n ráº±ng workflow cÃ³ thá»ƒ Ä‘iá»u phá»‘i incident theo Ä‘Ãºng nhÃ¡nh pháº£n á»©ng tá»± Ä‘á»™ng.

Trong trÆ°á»ng há»£p kiá»ƒm thá»­ trá»±c tiáº¿p báº±ng Lambda test event, áº£nh Lambda execution vÃ  cÃ¡c káº¿t quáº£ trong EC2, S3, EBS Snapshot, DynamoDB váº«n Ä‘á»§ Ä‘á»ƒ chá»©ng minh auto isolation hoáº¡t Ä‘á»™ng.

---

#### Káº¿t quáº£ mong Ä‘á»£i

Sau khi hoÃ n thÃ nh pháº§n nÃ y, cÃ¡c káº¿t quáº£ mong Ä‘á»£i gá»“m:

| ThÃ nh pháº§n | Káº¿t quáº£ mong Ä‘á»£i |
|---|---|
| EC2 before test | Instance Ä‘ang dÃ¹ng `SG-Workload` |
| Lambda | Xá»­ lÃ½ sample GuardDuty event thÃ nh cÃ´ng |
| Systems Manager | Cháº¡y forensic command thÃ nh cÃ´ng |
| S3 Evidence Bucket | LÆ°u event vÃ  response summary |
| EBS Snapshot | Snapshot Ä‘Æ°á»£c táº¡o tá»« volume cá»§a EC2 |
| EC2 after test | Instance Ä‘Æ°á»£c thay sang `SG-Isolation` |
| DynamoDB | Incident status Ä‘Æ°á»£c cáº­p nháº­t thÃ nh `Isolated` |
| Step Functions | Auto Response execution thÃ nh cÃ´ng hoáº·c sáºµn sÃ ng kiá»ƒm thá»­ |

---

#### Báº±ng chá»©ng kiá»ƒm thá»­

CÃ¡c báº±ng chá»©ng kiá»ƒm thá»­ trong pháº§n nÃ y bao gá»“m nhá»¯ng hÃ¬nh áº£nh sau:

| STT | HÃ¬nh áº£nh | Má»¥c Ä‘Ã­ch |
|---|---|---|
| 1 | Auto isolation flow diagram | MÃ´ táº£ luá»“ng kiá»ƒm thá»­ Auto Isolation |
| 2 | EC2 before auto isolation | XÃ¡c nháº­n EC2 Ä‘ang dÃ¹ng `SG-Workload` |
| 3 | Lambda test event | XÃ¡c nháº­n event mÃ´ phá»ng GuardDuty Finding |
| 4 | Lambda success result | XÃ¡c nháº­n Lambda xá»­ lÃ½ thÃ nh cÃ´ng |
| 5 | SSM forensic command output | XÃ¡c nháº­n forensic command Ä‘Æ°á»£c thá»±c thi |
| 6 | S3 evidence objects | XÃ¡c nháº­n evidence Ä‘Æ°á»£c lÆ°u vÃ o S3 |
| 7 | EBS forensic snapshot | XÃ¡c nháº­n snapshot Ä‘Æ°á»£c táº¡o |
| 8 | EC2 after auto isolation | XÃ¡c nháº­n EC2 Ä‘Ã£ chuyá»ƒn sang `SG-Isolation` |
| 9 | DynamoDB incident update | XÃ¡c nháº­n incident status Ä‘Ã£ cáº­p nháº­t |
| 10 | Step Functions auto response execution | XÃ¡c nháº­n workflow auto response |

---

#### Ghi chÃº

Trong bÃ i kiá»ƒm thá»­ nÃ y, sample event Ä‘Æ°á»£c dÃ¹ng thay cho táº¥n cÃ´ng tháº­t Ä‘á»ƒ Ä‘áº£m báº£o an toÃ n cho mÃ´i trÆ°á»ng lab.

GuardDuty sample findings máº·c Ä‘á»‹nh cÃ³ thá»ƒ khÃ´ng chá»©a Ä‘Ãºng EC2 instance ID cá»§a workload trong lab. VÃ¬ váº­y, viá»‡c sá»­ dá»¥ng controlled sample event giÃºp Ä‘áº£m báº£o Lambda xá»­ lÃ½ Ä‘Ãºng tÃ i nguyÃªn cáº§n kiá»ƒm thá»­.

NgoÃ i ra, EC2 pháº£i cÃ³ cÃ¡c Ä‘iá»u kiá»‡n sau Ä‘á»ƒ auto isolation hoáº¡t Ä‘á»™ng:

```text
EC2 instance Ä‘ang running
EC2 cÃ³ tag AutoIsolate=true
EC2 cÃ³ IAM Role cho Systems Manager
EC2 Ä‘ang Ä‘Æ°á»£c quáº£n lÃ½ bá»Ÿi Systems Manager
Lambda cÃ³ quyá»n EC2, SSM, S3 vÃ  DynamoDB
SG-Isolation tá»“n táº¡i trong cÃ¹ng VPC vá»›i EC2
```

---

#### HoÃ n thÃ nh

Báº¡n Ä‘Ã£ hoÃ n thÃ nh pháº§n kiá»ƒm thá»­ Auto Isolation.

Káº¿t quáº£ cá»§a pháº§n nÃ y xÃ¡c nháº­n ráº±ng há»‡ thá»‘ng AWS CloudSOC cÃ³ thá»ƒ tá»± Ä‘á»™ng xá»­ lÃ½ incident nghiÃªm trá»ng báº±ng cÃ¡ch thu tháº­p evidence, táº¡o forensic snapshot, cáº­p nháº­t tráº¡ng thÃ¡i incident vÃ  cÃ´ láº­p EC2 báº±ng `SG-Isolation`.

ÄÃ¢y lÃ  bÆ°á»›c xÃ¡c nháº­n quan trá»ng nháº¥t cho kháº£ nÄƒng pháº£n á»©ng sá»± cá»‘ tá»± Ä‘á»™ng cá»§a há»‡ thá»‘ng CloudSOC.