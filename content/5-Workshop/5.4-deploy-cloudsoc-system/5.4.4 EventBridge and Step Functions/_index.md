---
title : "EventBridge and Step Functions Workflow"
date : 2026-07-01
weight : 4
chapter : false
pre : " <b> 5.4.4. </b> "
---

#### EventBridge and Step Functions Workflow

In this section, you will configure **Amazon EventBridge** and **AWS Step Functions** to build an event-driven incident response workflow for the AWS CloudSOC system.

When Amazon GuardDuty generates a security finding, Amazon EventBridge receives the event and triggers AWS Step Functions. Step Functions then orchestrates the incident response process, including finding evaluation, severity checking, response branch selection, and preparation for the next response actions.

---

#### Objectives

After completing this section, you will have:

+ An AWS Step Functions State Machine for incident response workflow.
+ An IAM Role that allows Step Functions to run the workflow.
+ An Amazon EventBridge Rule to capture GuardDuty findings.
+ EventBridge able to trigger Step Functions when a GuardDuty finding is generated.
+ Workflow branches for Alert Only, Approval Required, and Auto Response.
+ CloudSOC ready for the next sections, including Dashboard Approval, Forensics, Snapshot, and Isolation.

---

#### EventBridge and Step Functions Architecture

The following diagram illustrates the EventBridge and Step Functions workflow in the AWS CloudSOC system.

![EventBridge and Step Functions Architecture](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/eventbridge-stepfunctions-architecture.png)

The main processing flow is:

```text
Amazon GuardDuty Finding
â†’ Amazon EventBridge Rule
â†’ AWS Step Functions State Machine
â†’ Evaluate Finding
â†’ Alert Only / Approval Required / Auto Response
```

In this architecture, GuardDuty acts as the threat detection source. EventBridge acts as the event router that sends findings to Step Functions. Step Functions acts as the incident response orchestrator.

---

#### Recommended Configuration

You can use the following configuration values for this workshop:

| Component | Recommended Value |
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

#### Step 1: Create an IAM Role for Step Functions

AWS Step Functions needs an IAM Role to run the workflow and call other AWS services in later sections, such as Lambda, SNS, Systems Manager, DynamoDB, and S3.

Open the **IAM** service and choose:

```text
Roles â†’ Create role
```

Configure the role:

| Field | Value |
|---|---|
| Trusted entity type | AWS service |
| Use case | Step Functions |

Set the role name:

```text
CloudSOC-StepFunctions-Workflow-Role
```

In this lab environment, you can attach the required permissions gradually as the workshop progresses. In later sections, this role may need permissions to:

+ Invoke Lambda functions.
+ Publish SNS messages.
+ Start Systems Manager commands.
+ Read and write DynamoDB incident records.
+ Put evidence metadata to Amazon S3.
+ Create or reference EBS Snapshot metadata.
+ Write execution logs to CloudWatch Logs.

Expected result:

```text
The IAM Role CloudSOC-StepFunctions-Workflow-Role is created successfully.
```

![Step Functions IAM Role](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/stepfunctions-execution-role.png)

---

#### Step 2: Create a CloudWatch Log Group for Step Functions

CloudWatch Logs is used to store Step Functions execution logs. This helps verify whether the workflow runs correctly.

Open the **Amazon CloudWatch** service and choose:

```text
Logs â†’ Log groups â†’ Create log group
```

Enter the log group name:

```text
/aws/states/cloudsoc-incident-response-workflow
```

Choose a suitable retention period for the lab environment, for example:

```text
7 days
```

Expected result:

```text
The CloudWatch Log Group for Step Functions is created successfully.
```

---

#### Step 3: Create a Step Functions State Machine

Open the **AWS Step Functions** service and choose:

```text
State machines â†’ Create state machine
```

Choose:

```text
Write your workflow in code
```

Select workflow type:

```text
Standard
```

Set the State Machine name:

```text
cloudsoc-incident-response-workflow
```

![Create State Machine](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/create-state-machine.png)

---

#### Step 4: Define the Workflow Logic

In the Step Functions definition section, use the following sample workflow.

This workflow is used to simulate the initial response logic. Real response actions such as sending SNS notifications, invoking Lambda, collecting evidence, creating snapshots, and isolating EC2 will be implemented in later sections.

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

> **Note:** This is the foundation workflow for testing EventBridge and Step Functions. Real integrations with Lambda, Systems Manager, EBS Snapshot, and SNS will be added in later sections.

Expected result:

```text
The cloudsoc-incident-response-workflow State Machine is created successfully.
```

![State Machine Graph](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/state-machine-graph.png)

---

#### Step 5: Configure Logging for Step Functions

During State Machine creation, enable logging to make troubleshooting easier.

Recommended configuration:

| Field | Value |
|---|---|
| Logging | Enabled |
| Log level | ALL |
| Include execution data | Enabled |
| Log group | `/aws/states/cloudsoc-incident-response-workflow` |

Expected result:

```text
Step Functions execution logs are sent to CloudWatch Logs.
```

---

#### Step 6: Test the State Machine Manually

Before connecting the workflow to EventBridge, test the State Machine with sample input.

In Step Functions, select the State Machine:

```text
cloudsoc-incident-response-workflow
```

Choose:

```text
Start execution
```

Use the following sample input to simulate a Critical GuardDuty finding:

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

Expected result:

```text
The workflow enters the Auto Response branch.
Execution status is Succeeded.
```

![Test State Machine Execution](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/test-state-machine-execution.png)

---

#### Step 7: Test the Approval Required Branch

Next, test the workflow with a High severity input:

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

Expected result:

```text
The workflow enters the Approval Required branch.
Execution status is Succeeded.
```

---

#### Step 8: Test the Alert Only Branch

Test the workflow with a Low or Medium severity input:

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

Expected result:

```text
The workflow enters the Alert Only branch.
Execution status is Succeeded.
```

---

#### Step 9: Create an IAM Role for EventBridge

Amazon EventBridge needs permission to start the Step Functions execution.

Open the **IAM** service and choose:

```text
Roles â†’ Create role
```

Configure the role:

| Field | Value |
|---|---|
| Trusted entity type | AWS service |
| Use case | EventBridge |

Set the role name:

```text
CloudSOC-EventBridge-StepFunctions-Role
```

This role needs the following permission:

```text
states:StartExecution
```

The resource should be the State Machine:

```text
cloudsoc-incident-response-workflow
```

Expected result:

```text
EventBridge has permission to trigger the Step Functions State Machine.
```

---

#### Step 10: Create an EventBridge Rule for GuardDuty Findings

Open the **Amazon EventBridge** service and choose:

```text
Rules â†’ Create rule
```

Configure the rule:

| Field | Value |
|---|---|
| Name | `cloudsoc-guardduty-finding-rule` |
| Description | `Trigger CloudSOC workflow when GuardDuty finding is generated` |
| Event bus | default |
| Rule type | Rule with an event pattern |

![Create EventBridge Rule](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/create-eventbridge-rule.png)

---

#### Step 11: Configure the Event Pattern

In the Event pattern section, choose:

```text
Custom pattern JSON
```

Enter the following pattern:

```json
{
  "source": ["aws.guardduty"],
  "detail-type": ["GuardDuty Finding"]
}
```

This event pattern captures all GuardDuty findings in the current Region.

Expected result:

```text
The EventBridge rule can match GuardDuty findings.
```

![EventBridge Rule Pattern](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/eventbridge-rule-pattern.png)

---

#### Step 12: Select Step Functions as the Target

In the Target section, choose:

```text
AWS service
```

Select target type:

```text
Step Functions state machine
```

Choose the State Machine:

```text
cloudsoc-incident-response-workflow
```

Choose the execution role:

```text
CloudSOC-EventBridge-StepFunctions-Role
```

Then choose:

```text
Create rule
```

Expected result:

```text
The EventBridge rule is created with Step Functions as the target.
```

![EventBridge Target Step Functions](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/eventbridge-target-stepfunctions.png)

---

#### Step 13: Verify the EventBridge Rule

After creating the rule, verify it:

```text
EventBridge â†’ Rules â†’ cloudsoc-guardduty-finding-rule
```

Check the following information:

+ Event bus is `default`.
+ Event pattern uses source `aws.guardduty`.
+ Target is `cloudsoc-incident-response-workflow`.
+ Rule status is Enabled.

Expected result:

```text
The EventBridge rule is enabled and ready to receive GuardDuty findings.
```

---

#### Step 14: Verify GuardDuty Sample Finding Trigger

If you generated sample findings in GuardDuty, EventBridge can receive the event and trigger Step Functions.

Check:

```text
Step Functions â†’ State machines â†’ cloudsoc-incident-response-workflow â†’ Executions
```

If EventBridge successfully triggered the workflow, a new execution will appear.

Expected result:

```text
A Step Functions execution is created from the GuardDuty finding event.
```

![EventBridge Trigger Execution](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/eventbridge-trigger-execution.png)

> **Note:** If no execution appears immediately, generate GuardDuty sample findings again or verify the EventBridge event pattern and target permissions.

---

#### Completion Checklist

After completing this section, verify the following items:

- [ ] Step Functions State Machine `cloudsoc-incident-response-workflow` is created.
- [ ] Step Functions logging is enabled.
- [ ] The workflow has Alert Only, Approval Required, and Auto Response branches.
- [ ] The State Machine runs successfully with sample input.
- [ ] EventBridge rule `cloudsoc-guardduty-finding-rule` is created.
- [ ] The event pattern matches GuardDuty findings.
- [ ] The EventBridge target is the Step Functions State Machine.
- [ ] EventBridge has `states:StartExecution` permission.
- [ ] GuardDuty findings can trigger Step Functions execution.

---

#### Completion Result

After completing this section, the AWS CloudSOC system has an event-driven workflow for processing GuardDuty findings.

The following components are now ready:

```text
Amazon GuardDuty
Amazon EventBridge
AWS Step Functions
CloudWatch Logs
IAM Roles
```

When GuardDuty creates a finding, EventBridge captures the event and triggers Step Functions. The workflow evaluates the finding and selects the appropriate response branch based on severity and affected resource type.

---

#### Summary

In this section, you built an incident processing workflow using EventBridge and Step Functions. EventBridge receives GuardDuty findings, while Step Functions orchestrates the incident response logic.

In the next section, you will deploy the **Dashboard and Approval Flow** so that the SOC Analyst can review incidents and approve or reject response actions.