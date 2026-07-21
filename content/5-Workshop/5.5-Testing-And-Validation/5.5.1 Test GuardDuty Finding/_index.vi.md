---
title : "Kiá»ƒm thá»­ GuardDuty Finding"
date : 2026-07-01
weight : 1
chapter : false
pre : " <b> 5.5.1. </b> "
---

#### Kiá»ƒm thá»­ GuardDuty Finding

Trong pháº§n nÃ y, chÃºng ta sáº½ kiá»ƒm thá»­ kháº£ nÄƒng táº¡o vÃ  hiá»ƒn thá»‹ **security findings** cá»§a **Amazon GuardDuty** trong há»‡ thá»‘ng AWS CloudSOC.

Má»¥c tiÃªu cá»§a bÃ i kiá»ƒm thá»­ lÃ  xÃ¡c nháº­n ráº±ng GuardDuty Ä‘Ã£ Ä‘Æ°á»£c báº­t thÃ nh cÃ´ng vÃ  cÃ³ thá»ƒ táº¡o ra cÃ¡c security findings. CÃ¡c finding nÃ y sáº½ Ä‘Æ°á»£c sá»­ dá»¥ng lÃ m dá»¯ liá»‡u Ä‘áº§u vÃ o cho nhá»¯ng bÆ°á»›c tiáº¿p theo trong quy trÃ¬nh pháº£n á»©ng sá»± cá»‘ cá»§a CloudSOC.

GuardDuty Finding lÃ  Ä‘iá»ƒm báº¯t Ä‘áº§u cá»§a luá»“ng pháº£n á»©ng sá»± cá»‘:

```text
GuardDuty Finding
â†’ EventBridge
â†’ Step Functions
â†’ Incident Response Workflow
```

Trong pháº§n 5.5.1, trá»ng tÃ¢m lÃ  táº¡o vÃ  xem láº¡i GuardDuty findings trong GuardDuty console. CÃ¡c bÆ°á»›c kiá»ƒm thá»­ workflow, approval, auto isolation, dashboard vÃ  alert sáº½ Ä‘Æ°á»£c thá»±c hiá»‡n á»Ÿ cÃ¡c pháº§n tiáº¿p theo.

---

#### Má»¥c tiÃªu kiá»ƒm thá»­

Sau khi hoÃ n thÃ nh pháº§n nÃ y, chÃºng ta cÃ³ thá»ƒ xÃ¡c nháº­n ráº±ng:

+ Amazon GuardDuty Ä‘Ã£ Ä‘Æ°á»£c báº­t.
+ GuardDuty cÃ³ thá»ƒ táº¡o sample findings.
+ Findings Ä‘Æ°á»£c hiá»ƒn thá»‹ trong GuardDuty console.
+ Má»—i finding cÃ³ cÃ¡c thÃ´ng tin quan trá»ng nhÆ° severity, finding type, resource, account vÃ  region.
+ Finding cÃ³ thá»ƒ Ä‘Æ°á»£c sá»­ dá»¥ng lÃ m dá»¯ liá»‡u Ä‘áº§u vÃ o cho EventBridge vÃ  Step Functions á»Ÿ cÃ¡c bÆ°á»›c kiá»ƒm thá»­ tiáº¿p theo.

---

#### Kiáº¿n trÃºc kiá»ƒm thá»­

SÆ¡ Ä‘á»“ dÆ°á»›i Ä‘Ã¢y mÃ´ táº£ luá»“ng kiá»ƒm thá»­ GuardDuty Finding.

![Test GuardDuty Finding Flow](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-Test-Guardduty-Finding/test-guardduty-finding-flow.png)

Luá»“ng kiá»ƒm thá»­ bao gá»“m cÃ¡c bÆ°á»›c chÃ­nh:

```text
SOC Analyst
â†’ GuardDuty Console
â†’ Generate Sample Findings
â†’ View Finding Details
â†’ Confirm Finding Information
â†’ Check EventBridge Rule
â†’ Check Step Functions Execution
```

Trong bÃ i kiá»ƒm thá»­ nÃ y, chÃºng ta sá»­ dá»¥ng **GuardDuty sample findings**. ÄÃ¢y lÃ  cÃ¡ch an toÃ n Ä‘á»ƒ kiá»ƒm thá»­ lab mÃ  khÃ´ng cáº§n thá»±c hiá»‡n hÃ nh vi táº¥n cÃ´ng tháº­t vÃ o EC2 instance.

---

#### BÆ°á»›c 1: Má»Ÿ Amazon GuardDuty

Äáº§u tiÃªn, truy cáº­p AWS Console vÃ  má»Ÿ dá»‹ch vá»¥ **Amazon GuardDuty** trong Region:

```text
Asia Pacific (Singapore) / ap-southeast-1
```

GuardDuty dashboard xÃ¡c nháº­n ráº±ng dá»‹ch vá»¥ Ä‘Ã£ Ä‘Æ°á»£c báº­t vÃ  sáºµn sÃ ng hiá»ƒn thá»‹ security findings.

![GuardDuty Dashboard Before Test](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-Test-Guardduty-Finding/guardduty-dashboard-before-test.png)

á»ž bÆ°á»›c nÃ y, GuardDuty Ä‘Ã£ sáºµn sÃ ng Ä‘Ã³ng vai trÃ² lÃ  dá»‹ch vá»¥ phÃ¡t hiá»‡n má»‘i Ä‘e dá»a chÃ­nh trong AWS CloudSOC lab.

---

#### BÆ°á»›c 2: Táº¡o Sample Findings

Äá»ƒ kiá»ƒm thá»­ GuardDuty mÃ  khÃ´ng cáº§n thá»±c hiá»‡n táº¥n cÃ´ng tháº­t, chÃºng ta sá»­ dá»¥ng tÃ­nh nÄƒng táº¡o sample findings trong GuardDuty console.

GuardDuty cÃ³ thá»ƒ táº¡o cÃ¡c findings mÃ´ phá»ng nhiá»u tÃ¬nh huá»‘ng báº£o máº­t khÃ¡c nhau, vÃ­ dá»¥:

```text
UnauthorizedAccess:EC2/SSHBruteForce
Recon:EC2/PortProbeUnprotectedPort
CryptoCurrency:EC2/BitcoinTool.B
Trojan:EC2/DNSDataExfiltration
```

CÃ¡c sample findings nÃ y chá»‰ phá»¥c vá»¥ má»¥c Ä‘Ã­ch kiá»ƒm thá»­. ChÃºng khÃ´ng cÃ³ nghÄ©a lÃ  AWS account Ä‘ang bá»‹ táº¥n cÃ´ng tháº­t.

![Generate GuardDuty Sample Findings](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-Test-Guardduty-Finding/generate-guardduty-sample-findings.png)

Sau khi sample findings Ä‘Æ°á»£c táº¡o, GuardDuty sáº½ hiá»ƒn thá»‹ nhiá»u sá»± kiá»‡n báº£o máº­t mÃ´ phá»ng trong danh sÃ¡ch findings.

---

#### BÆ°á»›c 3: Kiá»ƒm tra danh sÃ¡ch Findings

Sau khi táº¡o sample findings, trang **Findings** cá»§a GuardDuty sáº½ hiá»ƒn thá»‹ nhiá»u findings máº«u.

![GuardDuty Sample Findings List](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-Test-Guardduty-Finding/guardduty-sample-findings-list.png)

Danh sÃ¡ch findings hiá»ƒn thá»‹ cÃ¡c thÃ´ng tin quan trá»ng nhÆ° title, severity, finding type vÃ  resource liÃªn quan.

| ThÃ´ng tin | MÃ´ táº£ |
|---|---|
| Finding type | Loáº¡i hÃ nh vi Ä‘Ã¡ng ngá» |
| Severity | Má»©c Ä‘á»™ nghiÃªm trá»ng cá»§a finding |
| Resource | TÃ i nguyÃªn AWS cÃ³ liÃªn quan |
| Account ID | AWS account phÃ¡t sinh finding |
| Region | AWS Region phÃ¡t sinh finding |
| Updated at | Thá»i Ä‘iá»ƒm finding Ä‘Æ°á»£c cáº­p nháº­t gáº§n nháº¥t |

Tá»« danh sÃ¡ch findings, chÃºng ta cÃ³ thá»ƒ chá»n má»™t finding liÃªn quan Ä‘áº¿n EC2 Ä‘á»ƒ xem chi tiáº¿t. Nhá»¯ng finding nÃ y giÃºp xÃ¡c nháº­n ráº±ng lá»›p phÃ¡t hiá»‡n má»‘i Ä‘e dá»a cá»§a CloudSOC Ä‘ang hoáº¡t Ä‘á»™ng.

---

#### BÆ°á»›c 4: Má»Ÿ chi tiáº¿t má»™t Finding

Má»™t finding liÃªn quan Ä‘áº¿n EC2 Ä‘Æ°á»£c chá»n Ä‘á»ƒ kiá»ƒm tra thÃ´ng tin chi tiáº¿t. VÃ­ dá»¥ cÃ¡c finding type liÃªn quan EC2:

```text
UnauthorizedAccess:EC2/SSHBruteForce
```

hoáº·c:

```text
Recon:EC2/PortProbeUnprotectedPort
```

Trang chi tiáº¿t finding cung cáº¥p thÃ´ng tin rÃµ hÆ¡n vá» hÃ nh vi Ä‘Ã¡ng ngá», tÃ i nguyÃªn bá»‹ áº£nh hÆ°á»Ÿng, má»©c Ä‘á»™ nghiÃªm trá»ng vÃ  má»‘c thá»i gian phÃ¡t hiá»‡n.

![GuardDuty Finding Detail](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-Test-Guardduty-Finding/guardduty-finding-detail.png)

CÃ¡c trÆ°á»ng thÃ´ng tin Ä‘Æ°á»£c kiá»ƒm tra trong trang chi tiáº¿t finding gá»“m:

```text
Finding ID
Finding type
Severity
Resource type
Instance ID
Account ID
Region
First seen
Last seen
```

Nhá»¯ng thÃ´ng tin nÃ y giÃºp SOC Analyst hiá»ƒu sá»± cá»‘ Ä‘ang thuá»™c loáº¡i nÃ o, tÃ i nguyÃªn nÃ o liÃªn quan vÃ  má»©c Ä‘á»™ nghiÃªm trá»ng ra sao.

---

#### BÆ°á»›c 5: Ghi nháº­n thÃ´ng tin Finding

Sau khi xem chi tiáº¿t finding, cÃ¡c thÃ´ng tin quan trá»ng Ä‘Æ°á»£c ghi nháº­n Ä‘á»ƒ phá»¥c vá»¥ cho cÃ¡c bÆ°á»›c kiá»ƒm thá»­ tiáº¿p theo.

VÃ­ dá»¥:

| TrÆ°á»ng thÃ´ng tin | VÃ­ dá»¥ |
|---|---|
| Finding type | UnauthorizedAccess:EC2/SSHBruteForce |
| Severity | High |
| Resource type | EC2 Instance |
| Region | ap-southeast-1 |
| Response action | Send to EventBridge and Step Functions |

ThÃ´ng tin nÃ y giÃºp xÃ¡c Ä‘á»‹nh finding nÃªn Ä‘i theo nhÃ¡nh `Alert Only`, `Approval Required` hay `Auto Response` trong CloudSOC workflow.

---

#### BÆ°á»›c 6: Kiá»ƒm tra EventBridge Rule

Sau khi GuardDuty táº¡o findings, EventBridge rule Ä‘Æ°á»£c kiá»ƒm tra Ä‘á»ƒ xÃ¡c nháº­n rule nháº­n GuardDuty findings Ä‘ang hoáº¡t Ä‘á»™ng.

Rule sá»­ dá»¥ng trong lab nÃ y lÃ :

```text
cloudsoc-guardduty-finding-rule
```

Event pattern Ä‘Æ°á»£c cáº¥u hÃ¬nh Ä‘á»ƒ khá»›p vá»›i GuardDuty findings:

```json
{
  "source": ["aws.guardduty"],
  "detail-type": ["GuardDuty Finding"]
}
```

![EventBridge GuardDuty Rule Enabled](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-Test-Guardduty-Finding/eventbridge-guardduty-rule-enabled.png)

Rule nÃ y cho phÃ©p cÃ¡c GuardDuty findings Ä‘Æ°á»£c chuyá»ƒn tiáº¿p vÃ o CloudSOC workflow.

---

#### BÆ°á»›c 7: Kiá»ƒm tra Step Functions Execution

Tiáº¿p theo, Step Functions state machine Ä‘Æ°á»£c kiá»ƒm tra Ä‘á»ƒ xÃ¡c nháº­n workflow Ä‘Ã£ sáºµn sÃ ng xá»­ lÃ½ GuardDuty findings.

State machine sá»­ dá»¥ng trong lab nÃ y lÃ :

```text
cloudsoc-incident-response-workflow
```

Trang executions cho biáº¿t workflow Ä‘Ã£ nháº­n vÃ  xá»­ lÃ½ event finding hay chÆ°a.

![Step Functions Execution From GuardDuty](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-Test-Guardduty-Finding/stepfunctions-execution-from-guardduty.png)

Trong má»™t sá»‘ trÆ°á»ng há»£p, GuardDuty sample findings cÃ³ thá»ƒ khÃ´ng kÃ­ch hoáº¡t ngay workflow execution Ä‘Ãºng nhÆ° mong Ä‘á»£i trong lab. VÃ¬ váº­y, bÃ i kiá»ƒm thá»­ auto isolation Ä‘áº§y Ä‘á»§ sáº½ Ä‘Æ°á»£c thá»±c hiá»‡n á»Ÿ pháº§n **5.5.3 Test Auto Isolation** báº±ng má»™t sample event cÃ³ kiá»ƒm soÃ¡t.

---

#### Káº¿t quáº£ mong Ä‘á»£i

Sau khi hoÃ n thÃ nh pháº§n nÃ y, cÃ¡c káº¿t quáº£ mong Ä‘á»£i gá»“m:

| ThÃ nh pháº§n | Káº¿t quáº£ mong Ä‘á»£i |
|---|---|
| GuardDuty | Sample findings Ä‘Æ°á»£c táº¡o |
| Findings list | CÃ¡c findings má»›i Ä‘Æ°á»£c hiá»ƒn thá»‹ |
| Finding detail | ThÃ´ng tin finding type, severity vÃ  resource Ä‘Æ°á»£c hiá»ƒn thá»‹ |
| EventBridge Rule | Rule nháº­n GuardDuty Finding Ä‘ang enabled |
| Step Functions | Workflow sáºµn sÃ ng nháº­n findings hoáº·c cÃ³ thá»ƒ kiá»ƒm thá»­ báº±ng sample event |

---

#### Báº±ng chá»©ng kiá»ƒm thá»­

CÃ¡c báº±ng chá»©ng kiá»ƒm thá»­ trong pháº§n nÃ y bao gá»“m nhá»¯ng hÃ¬nh áº£nh sau:

| STT | HÃ¬nh áº£nh | Má»¥c Ä‘Ã­ch |
|---|---|---|
| 1 | GuardDuty finding flow diagram | MÃ´ táº£ luá»“ng kiá»ƒm thá»­ tá»•ng quan |
| 2 | GuardDuty dashboard | XÃ¡c nháº­n GuardDuty Ä‘Ã£ Ä‘Æ°á»£c báº­t |
| 3 | Generate sample findings | XÃ¡c nháº­n sample findings Ä‘Æ°á»£c táº¡o |
| 4 | GuardDuty findings list | Hiá»ƒn thá»‹ danh sÃ¡ch sample findings |
| 5 | GuardDuty finding detail | Hiá»ƒn thá»‹ chi tiáº¿t má»™t finding Ä‘Æ°á»£c chá»n |
| 6 | EventBridge rule | XÃ¡c nháº­n GuardDuty rule Ä‘ang enabled |
| 7 | Step Functions executions | XÃ¡c nháº­n workflow sáºµn sÃ ng xá»­ lÃ½ event |

---

#### LÆ°u Ã½

GuardDuty sample findings khÃ´ng pháº£i lÃºc nÃ o cÅ©ng trá» Ä‘Ãºng Ä‘áº¿n EC2 workload tháº­t Ä‘Ã£ táº¡o trong lab. VÃ¬ váº­y, má»¥c tiÃªu chÃ­nh cá»§a pháº§n nÃ y lÃ  xÃ¡c nháº­n GuardDuty cÃ³ thá»ƒ táº¡o vÃ  hiá»ƒn thá»‹ findings thÃ nh cÃ´ng.

BÃ i kiá»ƒm thá»­ cÃ´ láº­p EC2 tháº­t sáº½ Ä‘Æ°á»£c thá»±c hiá»‡n á»Ÿ pháº§n:

```text
5.5.3 Test Auto Isolation
```

Trong pháº§n Ä‘Ã³, má»™t sample event cÃ³ kiá»ƒm soÃ¡t sáº½ Ä‘Æ°á»£c sá»­ dá»¥ng vá»›i Ä‘Ãºng EC2 instance ID cá»§a lab. Äiá»u nÃ y giÃºp Incident Response Lambda cÃ³ thá»ƒ thu tháº­p evidence, táº¡o EBS Snapshot, cáº­p nháº­t DynamoDB vÃ  thay Security Group cá»§a EC2 sang `SG-Isolation`.

---

#### HoÃ n thÃ nh

Báº¡n Ä‘Ã£ hoÃ n thÃ nh pháº§n kiá»ƒm thá»­ GuardDuty Finding.

Káº¿t quáº£ cá»§a pháº§n nÃ y xÃ¡c nháº­n ráº±ng GuardDuty Ä‘ang hoáº¡t Ä‘á»™ng vÃ  cÃ³ thá»ƒ táº¡o security findings. ÄÃ¢y lÃ  dá»¯ liá»‡u Ä‘áº§u vÃ o quan trá»ng Ä‘á»ƒ há»‡ thá»‘ng CloudSOC tiáº¿p tá»¥c xá»­ lÃ½ qua EventBridge, Step Functions, Lambda vÃ  SNS trong cÃ¡c pháº§n kiá»ƒm thá»­ tiáº¿p theo.