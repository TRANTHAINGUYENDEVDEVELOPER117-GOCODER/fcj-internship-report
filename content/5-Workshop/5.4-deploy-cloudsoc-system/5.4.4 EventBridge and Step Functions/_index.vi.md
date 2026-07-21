---
title : "EventBridge and Step Functions Workflow"
date : 2026-07-01
weight : 4
chapter : false
pre : " <b> 5.4.4. </b> "
---

#### EventBridge and Step Functions Workflow

Trong pháº§n nÃ y, chÃºng ta sáº½ cáº¥u hÃ¬nh **Amazon EventBridge** vÃ  **AWS Step Functions** Ä‘á»ƒ xÃ¢y dá»±ng luá»“ng xá»­ lÃ½ sá»± cá»‘ theo mÃ´ hÃ¬nh event-driven cho há»‡ thá»‘ng AWS CloudSOC.

Khi Amazon GuardDuty táº¡o security finding, Amazon EventBridge sáº½ nháº­n event vÃ  kÃ­ch hoáº¡t AWS Step Functions. Step Functions sau Ä‘Ã³ sáº½ Ä‘iá»u phá»‘i quy trÃ¬nh pháº£n á»©ng sá»± cá»‘ nhÆ° Ä‘Ã¡nh giÃ¡ finding, xÃ¡c Ä‘á»‹nh má»©c Ä‘á»™ nghiÃªm trá»ng, chá»n nhÃ¡nh xá»­ lÃ½ vÃ  chuáº©n bá»‹ cÃ¡c bÆ°á»›c pháº£n á»©ng tiáº¿p theo.

---

#### Má»¥c tiÃªu

Sau khi hoÃ n thÃ nh pháº§n nÃ y, báº¡n sáº½ cÃ³:

+ Má»™t AWS Step Functions State Machine cho quy trÃ¬nh xá»­ lÃ½ incident.
+ Má»™t IAM Role cho phÃ©p Step Functions thá»±c thi workflow.
+ Má»™t Amazon EventBridge Rule Ä‘á»ƒ báº¯t GuardDuty findings.
+ EventBridge cÃ³ thá»ƒ kÃ­ch hoáº¡t Step Functions khi cÃ³ GuardDuty finding.
+ Workflow cÃ³ cÃ¡c nhÃ¡nh xá»­ lÃ½: Alert Only, Approval Required vÃ  Auto Response.
+ CloudSOC sáºµn sÃ ng cho cÃ¡c pháº§n tiáº¿p theo nhÆ° Dashboard Approval, Forensics, Snapshot vÃ  Isolation.

---

#### Kiáº¿n trÃºc EventBridge and Step Functions

SÆ¡ Ä‘á»“ sau minh há»a luá»“ng EventBridge vÃ  Step Functions trong há»‡ thá»‘ng AWS CloudSOC.

![EventBridge and Step Functions Architecture](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/eventbridge-stepfunctions-architecture.png)

Luá»“ng xá»­ lÃ½ chÃ­nh:

```text
Amazon GuardDuty Finding
â†’ Amazon EventBridge Rule
â†’ AWS Step Functions State Machine
â†’ Evaluate Finding
â†’ Alert Only / Approval Required / Auto Response
```

Trong kiáº¿n trÃºc nÃ y, GuardDuty Ä‘Ã³ng vai trÃ² nguá»“n phÃ¡t hiá»‡n má»‘i Ä‘e dá»a. EventBridge Ä‘Ã³ng vai trÃ² router Ä‘á»ƒ chuyá»ƒn finding Ä‘áº¿n Step Functions. Step Functions Ä‘Ã³ng vai trÃ² bá»™ Ä‘iá»u phá»‘i pháº£n á»©ng sá»± cá»‘.

---

#### ThÃ´ng tin cáº¥u hÃ¬nh Ä‘á» xuáº¥t

Báº¡n cÃ³ thá»ƒ sá»­ dá»¥ng cÃ¡c thÃ´ng tin cáº¥u hÃ¬nh sau cho workshop:

| ThÃ nh pháº§n | GiÃ¡ trá»‹ Ä‘á» xuáº¥t |
|---|---|
| EventBridge Rule Name | `cloudsoc-guardduty-finding-rule` |
| Event Source | `aws.guardduty` |
| Detail Type | `GuardDuty Finding` |
| Step Functions Name | `cloudsoc-incident-response-workflow` |
| Step Functions Log Group | `/aws/states/cloudsoc-incident-response-workflow` |
| Step Functions IAM Role | `CloudSOC-StepFunctions-Workflow-Role` |
| EventBridge IAM Role | `CloudSOC-EventBridge-StepFunctions-Role` |
| Workflow Type | Standard |
| Main Branches | Alert Only, Approval Required, Auto Response |

---

#### BÆ°á»›c 1: Táº¡o IAM Role cho Step Functions

AWS Step Functions cáº§n má»™t IAM Role Ä‘á»ƒ thá»±c thi workflow vÃ  gá»i cÃ¡c dá»‹ch vá»¥ khÃ¡c trong cÃ¡c pháº§n sau nhÆ° Lambda, SNS, Systems Manager, DynamoDB vÃ  S3.

Má»Ÿ dá»‹ch vá»¥ **IAM**, chá»n:

```text
Roles â†’ Create role
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Trusted entity type | AWS service |
| Use case | Step Functions |

Äáº·t tÃªn role:

```text
CloudSOC-StepFunctions-Workflow-Role
```

Trong mÃ´i trÆ°á»ng lab, báº¡n cÃ³ thá»ƒ gáº¯n cÃ¡c quyá»n cáº§n thiáº¿t theo tá»«ng bÆ°á»›c triá»ƒn khai. á»ž cÃ¡c pháº§n sau, role nÃ y cÃ³ thá»ƒ cáº§n quyá»n:

+ Invoke Lambda functions
+ Publish SNS messages
+ Start Systems Manager commands
+ Read and write DynamoDB incident records
+ Put evidence metadata to Amazon S3
+ Create or reference EBS Snapshot metadata
+ Write execution logs to CloudWatch Logs

Káº¿t quáº£ mong Ä‘á»£i:

```text
IAM Role CloudSOC-StepFunctions-Workflow-Role Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![Step Functions IAM Role](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/stepfunctions-execution-role.png)

---

#### BÆ°á»›c 2: Táº¡o CloudWatch Log Group cho Step Functions

CloudWatch Logs Ä‘Æ°á»£c sá»­ dá»¥ng Ä‘á»ƒ lÆ°u execution logs cá»§a Step Functions. Äiá»u nÃ y giÃºp kiá»ƒm tra workflow cÃ³ cháº¡y Ä‘Ãºng hay khÃ´ng.

Má»Ÿ dá»‹ch vá»¥ **Amazon CloudWatch**, chá»n:

```text
Logs â†’ Log groups â†’ Create log group
```

Nháº­p tÃªn log group:

```text
/aws/states/cloudsoc-incident-response-workflow
```

Chá»n retention phÃ¹ há»£p cho mÃ´i trÆ°á»ng lab, vÃ­ dá»¥:

```text
7 days
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
CloudWatch Log Group cho Step Functions Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

---

#### BÆ°á»›c 3: Táº¡o Step Functions State Machine

Má»Ÿ dá»‹ch vá»¥ **AWS Step Functions**, chá»n:

```text
State machines â†’ Create state machine
```

Chá»n:

```text
Write your workflow in code
```

Chá»n workflow type:

```text
Standard
```

Äáº·t tÃªn State Machine:

```text
cloudsoc-incident-response-workflow
```

![Create State Machine](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/create-state-machine.png)

---

#### BÆ°á»›c 4: Khai bÃ¡o workflow logic

Trong pháº§n definition cá»§a Step Functions, sá»­ dá»¥ng workflow máº«u sau.

Workflow nÃ y dÃ¹ng Ä‘á»ƒ mÃ´ phá»ng logic xá»­ lÃ½ ban Ä‘áº§u. CÃ¡c hÃ nh Ä‘á»™ng thá»±c táº¿ nhÆ° gá»­i SNS, gá»i Lambda, thu tháº­p evidence, táº¡o snapshot vÃ  cÃ´ láº­p EC2 sáº½ Ä‘Æ°á»£c triá»ƒn khai chi tiáº¿t á»Ÿ cÃ¡c pháº§n tiáº¿p theo.

```json
{
  "Comment": "AWS CloudSOC Incident Response Workflow",
  "StartAt": "Evaluate Finding",
  "States": {
    "Evaluate Finding": {
      "Type": "Choice",
      "Choices": [
        {
          "And": [
            {
              "Variable": "$.detail.resource.resourceType",
              "StringEquals": "Instance"
            },
            {
              "Variable": "$.detail.severity",
              "NumericGreaterThanEquals": 8
            }
          ],
          "Next": "Auto Response"
        },
        {
          "And": [
            {
              "Variable": "$.detail.resource.resourceType",
              "StringEquals": "Instance"
            },
            {
              "Variable": "$.detail.severity",
              "NumericGreaterThanEquals": 7
            }
          ],
          "Next": "Approval Required"
        }
      ],
      "Default": "Alert Only"
    },
    "Alert Only": {
      "Type": "Pass",
      "Result": {
        "responseMode": "AlertOnly",
        "message": "Finding does not require isolation. Alert only."
      },
      "End": true
    },
    "Approval Required": {
      "Type": "Pass",
      "Result": {
        "responseMode": "ApprovalRequired",
        "message": "High severity finding requires SOC Analyst approval."
      },
      "Next": "Wait For Approval Placeholder"
    },
    "Wait For Approval Placeholder": {
      "Type": "Pass",
      "Result": {
        "approvalStatus": "Pending",
        "message": "Approval flow will be implemented in the Dashboard section."
      },
      "End": true
    },
    "Auto Response": {
      "Type": "Pass",
      "Result": {
        "responseMode": "AutoResponse",
        "message": "Critical finding is eligible for automated response."
      },
      "Next": "Response Actions Placeholder"
    },
    "Response Actions Placeholder": {
      "Type": "Pass",
      "Result": {
        "actions": [
          "Collect forensic evidence",
          "Create EBS snapshot",
          "Apply SG-Isolation",
          "Update DynamoDB",
          "Send SNS notification"
        ],
        "message": "Detailed response actions will be implemented in later sections."
      },
      "End": true
    }
  }
}
```

> **LÆ°u Ã½:** ÄÃ¢y lÃ  workflow ná»n táº£ng Ä‘á»ƒ kiá»ƒm tra EventBridge vÃ  Step Functions. CÃ¡c bÆ°á»›c thá»±c thi tháº­t nhÆ° Lambda, Systems Manager, EBS Snapshot vÃ  SNS sáº½ Ä‘Æ°á»£c tÃ­ch há»£p trong cÃ¡c pháº§n sau.

Káº¿t quáº£ mong Ä‘á»£i:

```text
State Machine cloudsoc-incident-response-workflow Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![State Machine Graph](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/state-machine-graph.png)

---

#### BÆ°á»›c 5: Cáº¥u hÃ¬nh Logging cho Step Functions

Trong quÃ¡ trÃ¬nh táº¡o State Machine, báº­t logging Ä‘á»ƒ dá»… kiá»ƒm tra lá»—i.

Cáº¥u hÃ¬nh Ä‘á» xuáº¥t:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Logging | Enabled |
| Log level | ALL |
| Include execution data | Enabled |
| Log group | `/aws/states/cloudsoc-incident-response-workflow` |

Káº¿t quáº£ mong Ä‘á»£i:

```text
Step Functions execution logs Ä‘Æ°á»£c gá»­i Ä‘áº¿n CloudWatch Logs.
```

---

#### BÆ°á»›c 6: Test State Machine thá»§ cÃ´ng

TrÆ°á»›c khi káº¿t ná»‘i vá»›i EventBridge, nÃªn test State Machine báº±ng sample input.

Trong Step Functions, chá»n State Machine:

```text
cloudsoc-incident-response-workflow
```

Chá»n:

```text
Start execution
```

DÃ¹ng sample input sau Ä‘á»ƒ mÃ´ phá»ng GuardDuty finding má»©c Critical:

```json
{
  "version": "0",
  "id": "sample-guardduty-event",
  "detail-type": "GuardDuty Finding",
  "source": "aws.guardduty",
  "account": "123456789012",
  "region": "ap-southeast-1",
  "detail": {
    "severity": 8.5,
    "type": "UnauthorizedAccess:EC2/SSHBruteForce",
    "title": "Sample GuardDuty finding for EC2 SSH brute force",
    "resource": {
      "resourceType": "Instance",
      "instanceDetails": {
        "instanceId": "i-xxxxxxxxxxxxxxxxx"
      }
    }
  }
}
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
Workflow cháº¡y vÃ o nhÃ¡nh Auto Response.
Execution status lÃ  Succeeded.
```

![Test State Machine Execution](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/test-state-machine-execution.png)

---

#### BÆ°á»›c 7: Test nhÃ¡nh Approval Required

Tiáº¿p tá»¥c test vá»›i sample input má»©c High:

```json
{
  "version": "0",
  "id": "sample-guardduty-event-high",
  "detail-type": "GuardDuty Finding",
  "source": "aws.guardduty",
  "account": "123456789012",
  "region": "ap-southeast-1",
  "detail": {
    "severity": 7.2,
    "type": "Recon:EC2/PortProbeUnprotectedPort",
    "title": "Sample GuardDuty finding requiring approval",
    "resource": {
      "resourceType": "Instance",
      "instanceDetails": {
        "instanceId": "i-xxxxxxxxxxxxxxxxx"
      }
    }
  }
}
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
Workflow cháº¡y vÃ o nhÃ¡nh Approval Required.
Execution status lÃ  Succeeded.
```

---

#### BÆ°á»›c 8: Test nhÃ¡nh Alert Only

Test vá»›i sample input má»©c Low hoáº·c Medium:

```json
{
  "version": "0",
  "id": "sample-guardduty-event-medium",
  "detail-type": "GuardDuty Finding",
  "source": "aws.guardduty",
  "account": "123456789012",
  "region": "ap-southeast-1",
  "detail": {
    "severity": 4.5,
    "type": "Recon:EC2/Portscan",
    "title": "Sample GuardDuty finding for alert only",
    "resource": {
      "resourceType": "Instance",
      "instanceDetails": {
        "instanceId": "i-xxxxxxxxxxxxxxxxx"
      }
    }
  }
}
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
Workflow cháº¡y vÃ o nhÃ¡nh Alert Only.
Execution status lÃ  Succeeded.
```

---

#### BÆ°á»›c 9: Táº¡o IAM Role cho EventBridge

Amazon EventBridge cáº§n quyá»n Ä‘á»ƒ start execution cá»§a Step Functions.

Má»Ÿ dá»‹ch vá»¥ **IAM**, chá»n:

```text
Roles â†’ Create role
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Trusted entity type | AWS service |
| Use case | EventBridge |

Äáº·t tÃªn role:

```text
CloudSOC-EventBridge-StepFunctions-Role
```

Role nÃ y cáº§n quyá»n:

```text
states:StartExecution
```

Resource lÃ  State Machine:

```text
cloudsoc-incident-response-workflow
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
EventBridge cÃ³ quyá»n kÃ­ch hoáº¡t Step Functions State Machine.
```

---

#### BÆ°á»›c 10: Táº¡o EventBridge Rule cho GuardDuty Findings

Má»Ÿ dá»‹ch vá»¥ **Amazon EventBridge**, chá»n:

```text
Rules â†’ Create rule
```

Cáº¥u hÃ¬nh rule:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Name | `cloudsoc-guardduty-finding-rule` |
| Description | `Trigger CloudSOC workflow when GuardDuty finding is generated` |
| Event bus | default |
| Rule type | Rule with an event pattern |

![Create EventBridge Rule](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/create-eventbridge-rule.png)

---

#### BÆ°á»›c 11: Cáº¥u hÃ¬nh Event Pattern

á»ž pháº§n Event pattern, chá»n:

```text
Custom pattern JSON
```

Nháº­p pattern sau:

```json
{
  "source": ["aws.guardduty"],
  "detail-type": ["GuardDuty Finding"]
}
```

Event pattern nÃ y sáº½ báº¯t táº¥t cáº£ GuardDuty findings trong Region hiá»‡n táº¡i.

Káº¿t quáº£ mong Ä‘á»£i:

```text
EventBridge rule cÃ³ thá»ƒ match GuardDuty findings.
```

![EventBridge Rule Pattern](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/eventbridge-rule-pattern.png)

---

#### BÆ°á»›c 12: Chá»n Target lÃ  Step Functions

á»ž pháº§n Target, chá»n:

```text
AWS service
```

Chá»n target type:

```text
Step Functions state machine
```

Chá»n State Machine:

```text
cloudsoc-incident-response-workflow
```

Chá»n execution role:

```text
CloudSOC-EventBridge-StepFunctions-Role
```

Sau Ä‘Ã³ chá»n:

```text
Create rule
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
EventBridge rule Ä‘Æ°á»£c táº¡o vÃ  target lÃ  Step Functions State Machine.
```

![EventBridge Target Step Functions](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/eventbridge-target-stepfunctions.png)

---

#### BÆ°á»›c 13: Kiá»ƒm tra EventBridge Rule

Sau khi táº¡o rule, kiá»ƒm tra láº¡i rule:

```text
EventBridge â†’ Rules â†’ cloudsoc-guardduty-finding-rule
```

Kiá»ƒm tra cÃ¡c thÃ´ng tin:

+ Event bus lÃ  `default`
+ Event pattern cÃ³ source `aws.guardduty`
+ Target lÃ  `cloudsoc-incident-response-workflow`
+ Rule status lÃ  Enabled

Káº¿t quáº£ mong Ä‘á»£i:

```text
EventBridge rule Ä‘Ã£ Ä‘Æ°á»£c báº­t vÃ  sáºµn sÃ ng nháº­n GuardDuty findings.
```

---

#### BÆ°á»›c 14: Kiá»ƒm tra GuardDuty Sample Finding kÃ­ch hoáº¡t Workflow

Náº¿u báº¡n Ä‘Ã£ táº¡o sample findings trong GuardDuty, EventBridge cÃ³ thá»ƒ nháº­n event vÃ  kÃ­ch hoáº¡t Step Functions.

Kiá»ƒm tra táº¡i:

```text
Step Functions â†’ State machines â†’ cloudsoc-incident-response-workflow â†’ Executions
```

Náº¿u EventBridge Ä‘Ã£ trigger workflow, báº¡n sáº½ tháº¥y execution má»›i.

Káº¿t quáº£ mong Ä‘á»£i:

```text
Step Functions cÃ³ execution Ä‘Æ°á»£c táº¡o tá»« GuardDuty finding event.
```

![EventBridge Trigger Execution](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/eventbridge-trigger-execution.png)

> **LÆ°u Ã½:** Náº¿u khÃ´ng tháº¥y execution ngay láº­p tá»©c, hÃ£y táº¡o láº¡i GuardDuty sample findings hoáº·c kiá»ƒm tra EventBridge rule pattern vÃ  target permission.

---

#### Kiá»ƒm tra sau khi hoÃ n thÃ nh

Sau khi hoÃ n thÃ nh pháº§n nÃ y, kiá»ƒm tra láº¡i cÃ¡c má»¥c sau:

- [ ] Step Functions State Machine `cloudsoc-incident-response-workflow` Ä‘Ã£ Ä‘Æ°á»£c táº¡o.
- [ ] Step Functions logging Ä‘Ã£ Ä‘Æ°á»£c báº­t.
- [ ] Workflow cÃ³ cÃ¡c nhÃ¡nh Alert Only, Approval Required vÃ  Auto Response.
- [ ] State Machine cÃ³ thá»ƒ cháº¡y thÃ nh cÃ´ng vá»›i sample input.
- [ ] EventBridge rule `cloudsoc-guardduty-finding-rule` Ä‘Ã£ Ä‘Æ°á»£c táº¡o.
- [ ] Event pattern match GuardDuty findings.
- [ ] Target cá»§a EventBridge lÃ  Step Functions State Machine.
- [ ] EventBridge cÃ³ quyá»n `states:StartExecution`.
- [ ] GuardDuty finding cÃ³ thá»ƒ kÃ­ch hoáº¡t Step Functions execution.

---

#### Káº¿t quáº£ sau khi hoÃ n thÃ nh

Sau khi hoÃ n thÃ nh pháº§n nÃ y, há»‡ thá»‘ng AWS CloudSOC Ä‘Ã£ cÃ³ luá»“ng event-driven Ä‘á»ƒ xá»­ lÃ½ GuardDuty findings.

CÃ¡c thÃ nh pháº§n Ä‘Ã£ sáºµn sÃ ng gá»“m:

```text
Amazon GuardDuty
Amazon EventBridge
AWS Step Functions
CloudWatch Logs
IAM Roles
```

Khi GuardDuty táº¡o finding, EventBridge sáº½ báº¯t event vÃ  kÃ­ch hoáº¡t Step Functions. Workflow sáº½ Ä‘Ã¡nh giÃ¡ finding vÃ  chá»n nhÃ¡nh xá»­ lÃ½ phÃ¹ há»£p dá»±a trÃªn má»©c Ä‘á»™ nghiÃªm trá»ng vÃ  loáº¡i tÃ i nguyÃªn bá»‹ áº£nh hÆ°á»Ÿng.

---

#### TÃ³m táº¯t

Trong pháº§n nÃ y, chÃºng ta Ä‘Ã£ xÃ¢y dá»±ng luá»“ng xá»­ lÃ½ sá»± cá»‘ dá»±a trÃªn EventBridge vÃ  Step Functions. EventBridge Ä‘Ã³ng vai trÃ² nháº­n GuardDuty findings, cÃ²n Step Functions Ä‘iá»u phá»‘i logic pháº£n á»©ng sá»± cá»‘.

á»ž pháº§n tiáº¿p theo, chÃºng ta sáº½ triá»ƒn khai **Dashboard and Approval Flow** Ä‘á»ƒ SOC Analyst cÃ³ thá»ƒ xem incident vÃ  phÃª duyá»‡t hoáº·c tá»« chá»‘i hÃ nh Ä‘á»™ng pháº£n á»©ng.