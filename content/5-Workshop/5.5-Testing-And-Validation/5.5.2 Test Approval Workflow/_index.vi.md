---
title : "Kiá»ƒm thá»­ Approval Workflow"
date : 2026-07-01
weight : 2
chapter : false
pre : " <b> 5.5.2. </b> "
---

#### Kiá»ƒm thá»­ Approval Workflow

Trong pháº§n nÃ y, chÃºng ta sáº½ kiá»ƒm thá»­ luá»“ng **Approval Workflow** cá»§a há»‡ thá»‘ng AWS CloudSOC.

Má»¥c tiÃªu cá»§a bÃ i kiá»ƒm thá»­ lÃ  xÃ¡c nháº­n ráº±ng khi má»™t security finding cÃ³ má»©c Ä‘á»™ nghiÃªm trá»ng cao nhÆ°ng cáº§n sá»± xÃ¡c nháº­n cá»§a SOC Analyst, há»‡ thá»‘ng cÃ³ thá»ƒ Ä‘Æ°a incident vÃ o tráº¡ng thÃ¡i chá» phÃª duyá»‡t. Sau Ä‘Ã³, SOC Analyst cÃ³ thá»ƒ xem incident trÃªn dashboard vÃ  chá»n **Approve** hoáº·c **Reject**.

Approval Workflow giÃºp trÃ¡nh viá»‡c há»‡ thá»‘ng tá»± Ä‘á»™ng cÃ´ láº­p EC2 trong má»i trÆ°á»ng há»£p. Thay vÃ o Ä‘Ã³, cÃ¡c sá»± cá»‘ cáº§n Ä‘Ã¡nh giÃ¡ thÃªm sáº½ Ä‘Æ°á»£c chuyá»ƒn sang tráº¡ng thÃ¡i chá» phÃª duyá»‡t.

Luá»“ng tá»•ng quan:

```text
GuardDuty Finding
â†’ EventBridge
â†’ Step Functions
â†’ Approval Required
â†’ DynamoDB Incident Table
â†’ SOC Dashboard
â†’ Approve / Reject
â†’ Update Incident Status
```

Trong pháº§n nÃ y, trá»ng tÃ¢m lÃ  kiá»ƒm tra quÃ¡ trÃ¬nh chuyá»ƒn Ä‘á»•i tráº¡ng thÃ¡i cá»§a incident tá»« `Pending` sang `Approved` hoáº·c `Rejected`.

---

#### Má»¥c tiÃªu kiá»ƒm thá»­

Sau khi hoÃ n thÃ nh pháº§n nÃ y, chÃºng ta cÃ³ thá»ƒ xÃ¡c nháº­n ráº±ng:

+ Incident cÃ³ thá»ƒ Ä‘Æ°á»£c táº¡o vá»›i tráº¡ng thÃ¡i chá» phÃª duyá»‡t.
+ Dashboard cÃ³ thá»ƒ hiá»ƒn thá»‹ incident cáº§n SOC Analyst xá»­ lÃ½.
+ SOC Analyst cÃ³ thá»ƒ chá»n **Approve** hoáº·c **Reject** trÃªn dashboard.
+ Tráº¡ng thÃ¡i approval Ä‘Æ°á»£c cáº­p nháº­t trong DynamoDB.
+ Approval Workflow hoáº¡t Ä‘á»™ng nhÆ° má»™t bÆ°á»›c kiá»ƒm soÃ¡t trÆ°á»›c khi thá»±c hiá»‡n pháº£n á»©ng tá»± Ä‘á»™ng.

---

#### Kiáº¿n trÃºc kiá»ƒm thá»­

SÆ¡ Ä‘á»“ dÆ°á»›i Ä‘Ã¢y mÃ´ táº£ luá»“ng kiá»ƒm thá»­ Approval Workflow.

![Test Approval Workflow Flow](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/test-approval-workflow-flow.png)

Luá»“ng kiá»ƒm thá»­ gá»“m cÃ¡c bÆ°á»›c chÃ­nh:

```text
Step Functions
â†’ Approval Required Branch
â†’ DynamoDB Incident Table
â†’ SOC Dashboard
â†’ SOC Analyst Approval
â†’ DynamoDB Status Update
```

Trong bÃ i kiá»ƒm thá»­ nÃ y, incident sáº½ Ä‘Æ°á»£c Ä‘Æ°a vÃ o tráº¡ng thÃ¡i cáº§n phÃª duyá»‡t. Sau Ä‘Ã³, SOC Analyst kiá»ƒm tra thÃ´ng tin trÃªn dashboard vÃ  cáº­p nháº­t quyáº¿t Ä‘á»‹nh xá»­ lÃ½.

---

#### BÆ°á»›c 1: Kiá»ƒm tra nhÃ¡nh Approval Required

Trong Step Functions workflow, nhÃ¡nh `Approval Required` Ä‘Æ°á»£c sá»­ dá»¥ng cho cÃ¡c finding cÃ³ má»©c Ä‘á»™ nghiÃªm trá»ng cao nhÆ°ng chÆ°a Ä‘á»§ Ä‘iá»u kiá»‡n Ä‘á»ƒ thá»±c hiá»‡n pháº£n á»©ng tá»± Ä‘á»™ng ngay láº­p tá»©c.

![Step Functions Approval Branch](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/stepfunctions-approval-branch.png)

NhÃ¡nh nÃ y giÃºp há»‡ thá»‘ng tÃ¡ch biá»‡t giá»¯a ba loáº¡i pháº£n á»©ng:

| NhÃ¡nh xá»­ lÃ½ | Ã nghÄ©a |
|---|---|
| Alert Only | Chá»‰ gá»­i cáº£nh bÃ¡o, khÃ´ng thá»±c hiá»‡n hÃ nh Ä‘á»™ng cÃ´ láº­p |
| Approval Required | Cáº§n SOC Analyst phÃª duyá»‡t trÆ°á»›c khi xá»­ lÃ½ |
| Auto Response | Tá»± Ä‘á»™ng xá»­ lÃ½ khi finding Ä‘á»§ Ä‘iá»u kiá»‡n |

Trong bÃ i kiá»ƒm thá»­ nÃ y, chÃºng ta táº­p trung vÃ o nhÃ¡nh:

```text
Approval Required
```

---

#### BÆ°á»›c 2: Táº¡o incident á»Ÿ tráº¡ng thÃ¡i Pending

Má»™t incident máº«u Ä‘Æ°á»£c táº¡o trong DynamoDB Ä‘á»ƒ mÃ´ phá»ng finding cáº§n phÃª duyá»‡t.

Incident nÃ y cÃ³ tráº¡ng thÃ¡i ban Ä‘áº§u lÃ :

```text
approvalStatus = Pending
incidentStatus = WaitingApproval
responseMode = ApprovalRequired
```

![Pending Incident in DynamoDB](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/incident-pending-in-dynamodb.png)

VÃ­ dá»¥ dá»¯ liá»‡u incident:

| Field | Example |
|---|---|
| incidentId | INC-001 |
| findingType | UnauthorizedAccess:EC2/SSHBruteForce |
| severity | 7.5 |
| resourceId | EC2 instance ID |
| responseMode | ApprovalRequired |
| approvalStatus | Pending |
| incidentStatus | WaitingApproval |

Tráº¡ng thÃ¡i `Pending` cho biáº¿t incident Ä‘ang chá» SOC Analyst xem xÃ©t trÆ°á»›c khi thá»±c hiá»‡n hÃ nh Ä‘á»™ng tiáº¿p theo.

---

#### BÆ°á»›c 3: Kiá»ƒm tra incident trÃªn SOC Dashboard

Sau khi incident Ä‘Æ°á»£c ghi vÃ o DynamoDB, dashboard sáº½ Ä‘á»c dá»¯ liá»‡u tá»« Incident Table vÃ  hiá»ƒn thá»‹ incident cho SOC Analyst.

![Dashboard Pending Incident](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/dashboard-pending-incident.png)

Dashboard hiá»ƒn thá»‹ cÃ¡c thÃ´ng tin chÃ­nh cá»§a incident, bao gá»“m:

```text
Incident ID
Finding Type
Severity
Resource ID
Response Mode
Approval Status
Incident Status
```

á»ž tráº¡ng thÃ¡i ban Ä‘áº§u, dashboard hiá»ƒn thá»‹:

```text
Approval Status: Pending
Incident Status: WaitingApproval
```

Äiá»u nÃ y xÃ¡c nháº­n ráº±ng dashboard Ä‘Ã£ Ä‘á»c Ä‘Ãºng dá»¯ liá»‡u incident tá»« DynamoDB.

---

#### BÆ°á»›c 4: SOC Analyst thá»±c hiá»‡n Approve

SOC Analyst kiá»ƒm tra ná»™i dung incident vÃ  chá»n hÃ nh Ä‘á»™ng **Approve** trÃªn dashboard.

![Dashboard Approve Action](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/dashboard-approve-action.png)

Khi chá»n **Approve**, dashboard gá»­i request Ä‘áº¿n backend API Ä‘á»ƒ cáº­p nháº­t tráº¡ng thÃ¡i incident.

Luá»“ng xá»­ lÃ½:

```text
SOC Analyst
â†’ Click Approve
â†’ API Gateway
â†’ Dashboard API Lambda
â†’ DynamoDB Incident Table
```

Sau khi xá»­ lÃ½ thÃ nh cÃ´ng, approval status cá»§a incident sáº½ Ä‘Æ°á»£c cáº­p nháº­t.

---

#### BÆ°á»›c 5: Kiá»ƒm tra DynamoDB sau khi Approve

Sau khi SOC Analyst chá»n **Approve**, DynamoDB Ä‘Æ°á»£c kiá»ƒm tra Ä‘á»ƒ xÃ¡c nháº­n tráº¡ng thÃ¡i Ä‘Ã£ Ä‘Æ°á»£c cáº­p nháº­t.

![DynamoDB Approval Updated](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/dynamodb-approval-updated.png)

Káº¿t quáº£ mong Ä‘á»£i:

```text
approvalStatus = Approved
incidentStatus = Approved
```

Hoáº·c trong má»™t sá»‘ thiáº¿t káº¿ workflow:

```text
approvalStatus = Approved
incidentStatus = InProgress
```

Tráº¡ng thÃ¡i `Approved` xÃ¡c nháº­n ráº±ng SOC Analyst Ä‘Ã£ cho phÃ©p incident tiáº¿p tá»¥c Ä‘i vÃ o bÆ°á»›c xá»­ lÃ½ tiáº¿p theo.

---

#### BÆ°á»›c 6: Kiá»ƒm tra dashboard sau khi cáº­p nháº­t

Sau khi DynamoDB Ä‘Æ°á»£c cáº­p nháº­t, dashboard sáº½ hiá»ƒn thá»‹ tráº¡ng thÃ¡i má»›i cá»§a incident.

![Dashboard Approved Status](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/dashboard-approved-status.png)

Dashboard lÃºc nÃ y thá»ƒ hiá»‡n ráº±ng incident Ä‘Ã£ Ä‘Æ°á»£c phÃª duyá»‡t.

VÃ­ dá»¥ tráº¡ng thÃ¡i hiá»ƒn thá»‹:

```text
Approval Status: Approved
Incident Status: Approved
```

Hoáº·c:

```text
Approval Status: Approved
Incident Status: InProgress
```

Káº¿t quáº£ nÃ y xÃ¡c nháº­n ráº±ng approval workflow Ä‘Ã£ hoáº¡t Ä‘á»™ng Ä‘Ãºng tá»« giao diá»‡n dashboard Ä‘áº¿n DynamoDB.

---

#### BÆ°á»›c 7: Kiá»ƒm thá»­ Reject Workflow

NgoÃ i hÃ nh Ä‘á»™ng **Approve**, SOC Analyst cÅ©ng cÃ³ thá»ƒ chá»n **Reject** náº¿u incident khÃ´ng Ä‘á»§ Ä‘iá»u kiá»‡n Ä‘á»ƒ tiáº¿p tá»¥c xá»­ lÃ½.

![Dashboard Reject Action](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/dashboard-reject-action.png)

Luá»“ng xá»­ lÃ½ Reject:

```text
SOC Analyst
â†’ Click Reject
â†’ API Gateway
â†’ Dashboard API Lambda
â†’ DynamoDB Incident Table
```

Sau khi Reject, tráº¡ng thÃ¡i mong Ä‘á»£i lÃ :

```text
approvalStatus = Rejected
incidentStatus = Closed
```

Hoáº·c:

```text
approvalStatus = Rejected
incidentStatus = Rejected
```

![DynamoDB Rejected Status](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/dynamodb-rejected-status.png)

Tráº¡ng thÃ¡i `Rejected` xÃ¡c nháº­n ráº±ng incident khÃ´ng tiáº¿p tá»¥c Ä‘i vÃ o bÆ°á»›c auto response.

---

#### Káº¿t quáº£ mong Ä‘á»£i

Sau khi hoÃ n thÃ nh pháº§n nÃ y, cÃ¡c káº¿t quáº£ mong Ä‘á»£i gá»“m:

| ThÃ nh pháº§n | Káº¿t quáº£ mong Ä‘á»£i |
|---|---|
| Step Functions | CÃ³ nhÃ¡nh `Approval Required` |
| DynamoDB | CÃ³ incident á»Ÿ tráº¡ng thÃ¡i `Pending` |
| Dashboard | Hiá»ƒn thá»‹ incident cáº§n phÃª duyá»‡t |
| Approve action | Cáº­p nháº­t `approvalStatus` sang `Approved` |
| Reject action | Cáº­p nháº­t `approvalStatus` sang `Rejected` |
| Incident status | Thay Ä‘á»•i theo quyáº¿t Ä‘á»‹nh cá»§a SOC Analyst |

---

#### Báº±ng chá»©ng kiá»ƒm thá»­

CÃ¡c báº±ng chá»©ng kiá»ƒm thá»­ trong pháº§n nÃ y bao gá»“m nhá»¯ng hÃ¬nh áº£nh sau:

| STT | HÃ¬nh áº£nh | Má»¥c Ä‘Ã­ch |
|---|---|---|
| 1 | Approval workflow diagram | MÃ´ táº£ luá»“ng kiá»ƒm thá»­ Approval Workflow |
| 2 | Step Functions approval branch | XÃ¡c nháº­n workflow cÃ³ nhÃ¡nh Approval Required |
| 3 | Pending incident in DynamoDB | XÃ¡c nháº­n incident Ä‘ang chá» phÃª duyá»‡t |
| 4 | Dashboard pending incident | XÃ¡c nháº­n dashboard hiá»ƒn thá»‹ incident |
| 5 | Dashboard approve action | XÃ¡c nháº­n SOC Analyst cÃ³ thá»ƒ chá»n Approve |
| 6 | DynamoDB approval updated | XÃ¡c nháº­n tráº¡ng thÃ¡i Ä‘Æ°á»£c cáº­p nháº­t sau Approve |
| 7 | Dashboard approved status | XÃ¡c nháº­n dashboard hiá»ƒn thá»‹ tráº¡ng thÃ¡i má»›i |
| 8 | Dashboard reject action | XÃ¡c nháº­n SOC Analyst cÃ³ thá»ƒ chá»n Reject |
| 9 | DynamoDB rejected status | XÃ¡c nháº­n tráº¡ng thÃ¡i Ä‘Æ°á»£c cáº­p nháº­t sau Reject |

---

#### Ghi chÃº

Approval Workflow Ä‘Ã³ng vai trÃ² lÃ  lá»›p kiá»ƒm soÃ¡t giá»¯a phÃ¡t hiá»‡n má»‘i Ä‘e dá»a vÃ  pháº£n á»©ng tá»± Ä‘á»™ng.

Trong mÃ´i trÆ°á»ng thá»±c táº¿, khÃ´ng pháº£i má»i finding Ä‘á»u nÃªn Ä‘Æ°á»£c xá»­ lÃ½ tá»± Ä‘á»™ng. Má»™t sá»‘ finding cÃ³ thá»ƒ lÃ  false positive hoáº·c cáº§n SOC Analyst Ä‘Ã¡nh giÃ¡ thÃªm trÆ°á»›c khi cÃ´ láº­p workload.

Trong lab nÃ y, Approval Workflow giÃºp mÃ´ phá»ng quy trÃ¬nh ra quyáº¿t Ä‘á»‹nh cá»§a SOC Analyst trÆ°á»›c khi há»‡ thá»‘ng thá»±c hiá»‡n cÃ¡c bÆ°á»›c response máº¡nh hÆ¡n nhÆ°:

```text
Collect Evidence
Create EBS Snapshot
Apply SG-Isolation
Send Notification
```

CÃ¡c hÃ nh Ä‘á»™ng pháº£n á»©ng tá»± Ä‘á»™ng nÃ y sáº½ Ä‘Æ°á»£c kiá»ƒm thá»­ trong pháº§n tiáº¿p theo:

```text
5.5.3 Test Auto Isolation
```

---

#### HoÃ n thÃ nh

Báº¡n Ä‘Ã£ hoÃ n thÃ nh pháº§n kiá»ƒm thá»­ Approval Workflow.

Káº¿t quáº£ cá»§a pháº§n nÃ y xÃ¡c nháº­n ráº±ng há»‡ thá»‘ng CloudSOC cÃ³ thá»ƒ Ä‘Æ°a incident vÃ o tráº¡ng thÃ¡i chá» phÃª duyá»‡t, hiá»ƒn thá»‹ incident trÃªn dashboard vÃ  cáº­p nháº­t quyáº¿t Ä‘á»‹nh xá»­ lÃ½ cá»§a SOC Analyst vÃ o DynamoDB.

Approval Workflow giÃºp há»‡ thá»‘ng pháº£n á»©ng sá»± cá»‘ an toÃ n hÆ¡n, trÃ¡nh viá»‡c tá»± Ä‘á»™ng cÃ´ láº­p tÃ i nguyÃªn khi chÆ°a cÃ³ Ä‘á»§ thÃ´ng tin xÃ¡c nháº­n.