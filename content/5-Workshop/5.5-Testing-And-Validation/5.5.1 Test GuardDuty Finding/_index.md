---
title : "Test GuardDuty Finding"
date : 2026-07-01
weight : 1
chapter : false
pre : " <b> 5.5.1. </b> "
---

#### Test GuardDuty Finding

In this section, you will test the ability of **Amazon GuardDuty** to generate and display security findings in the AWS CloudSOC system.

The goal of this test is to confirm that GuardDuty has been enabled successfully and can generate security findings that will be used as input for the next stages of the CloudSOC incident response workflow.

A GuardDuty Finding is the starting point of the incident response flow:

```text
GuardDuty Finding
â†’ EventBridge
â†’ Step Functions
â†’ Incident Response Workflow
```

In section 5.5.1, the focus is on generating and reviewing GuardDuty findings in the GuardDuty console. Workflow execution, approval testing, auto isolation, dashboard validation, and alert delivery will be tested in the following sections.

---

#### Testing Objectives

After completing this section, you will be able to confirm that:

+ Amazon GuardDuty is enabled.
+ GuardDuty can generate sample findings.
+ Findings are displayed in the GuardDuty console.
+ Each finding includes important information such as severity, finding type, resource, account, and region.
+ The finding can be used as input for EventBridge and Step Functions in the next validation steps.

---

#### Testing Architecture

The following diagram shows the GuardDuty Finding test flow.

![Test GuardDuty Finding Flow](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-Test-Guardduty-Finding/test-guardduty-finding-flow.png)

The testing flow includes the following steps:

```text
SOC Analyst
â†’ GuardDuty Console
â†’ Generate Sample Findings
â†’ View Finding Details
â†’ Confirm Finding Information
â†’ Check EventBridge Rule
â†’ Check Step Functions Execution
```

In this test, **GuardDuty sample findings** are used. This is a safe way to validate the lab without performing real attack activities against the EC2 instance.

---

#### Step 1: Open Amazon GuardDuty

First, open the AWS Console and go to **Amazon GuardDuty** in the `Asia Pacific (Singapore) / ap-southeast-1` Region.

The GuardDuty dashboard confirms that the service has been enabled and is ready to generate or display security findings.

![GuardDuty Dashboard Before Test](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-Test-Guardduty-Finding/guardduty-dashboard-before-test.png)

At this stage, GuardDuty is available in the selected Region and can be used as the main detection service for the AWS CloudSOC lab.

---

#### Step 2: Generate Sample Findings

To validate GuardDuty without running a real attack, sample findings are generated from the GuardDuty console.

In GuardDuty, the sample finding feature creates simulated security findings such as:

```text
UnauthorizedAccess:EC2/SSHBruteForce
Recon:EC2/PortProbeUnprotectedPort
CryptoCurrency:EC2/BitcoinTool.B
Trojan:EC2/DNSDataExfiltration
```

These findings are used only for testing. They do not mean that the AWS account is under a real attack.

![Generate GuardDuty Sample Findings](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-Test-Guardduty-Finding/generate-guardduty-sample-findings.png)

After the sample findings are generated, GuardDuty begins displaying multiple simulated security events in the findings list.

---

#### Step 3: Review the Findings List

After generating sample findings, the GuardDuty **Findings** page displays multiple sample findings.

![GuardDuty Sample Findings List](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-Test-Guardduty-Finding/guardduty-sample-findings-list.png)

The findings list shows important information such as finding title, severity, finding type, and related resource.

| Information | Description |
|---|---|
| Finding type | The type of suspicious behavior |
| Severity | The severity level of the finding |
| Resource | The affected or related AWS resource |
| Account ID | The AWS account where the finding was generated |
| Region | The AWS Region where the finding was generated |
| Updated at | The latest update time of the finding |

From the findings list, EC2-related findings can be selected for further review. These findings are useful for validating the CloudSOC detection workflow.

---

#### Step 4: Open a Finding Detail

An EC2-related finding is selected to review the detailed information. Example EC2-related finding types include:

```text
UnauthorizedAccess:EC2/SSHBruteForce
```

or:

```text
Recon:EC2/PortProbeUnprotectedPort
```

The finding detail page provides more information about the suspicious activity, affected resource, severity level, and event timeline.

![GuardDuty Finding Detail](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-Test-Guardduty-Finding/guardduty-finding-detail.png)

The following fields are reviewed in the finding detail page:

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

This information helps the SOC Analyst understand what happened, which resource is involved, and how severe the finding is.

---

#### Step 5: Record Finding Information

After reviewing the finding detail, the important information is recorded for the next validation steps.

Example:

| Field | Example |
|---|---|
| Finding type | UnauthorizedAccess:EC2/SSHBruteForce |
| Severity | High |
| Resource type | EC2 Instance |
| Region | ap-southeast-1 |
| Response action | Send to EventBridge and Step Functions |

This information helps determine whether the finding should follow the `Alert Only`, `Approval Required`, or `Auto Response` path in the CloudSOC workflow.

---

#### Step 6: Check the EventBridge Rule

After GuardDuty generates findings, the EventBridge rule is checked to confirm that the rule for GuardDuty findings is enabled.

The rule used in this lab is:

```text
cloudsoc-guardduty-finding-rule
```

The event pattern is configured to match GuardDuty findings:

```json
{
  "source": ["aws.guardduty"],
  "detail-type": ["GuardDuty Finding"]
}
```

![EventBridge GuardDuty Rule Enabled](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-Test-Guardduty-Finding/eventbridge-guardduty-rule-enabled.png)

This rule allows GuardDuty findings to be routed to the CloudSOC workflow.

---

#### Step 7: Check Step Functions Execution

The Step Functions state machine is then checked to verify whether the workflow is ready to process GuardDuty findings.

The state machine used in this lab is:

```text
cloudsoc-incident-response-workflow
```

The executions page shows whether the workflow has received and processed a finding event.

![Step Functions Execution From GuardDuty](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-Test-Guardduty-Finding/stepfunctions-execution-from-guardduty.png)

In some cases, GuardDuty sample findings may not immediately trigger the exact workflow execution expected in the lab. Therefore, the full auto isolation test will be performed later using a controlled sample event in section **5.5.3 Test Auto Isolation**.

---

#### Expected Results

After completing this section, the following results are expected:

| Component | Expected Result |
|---|---|
| GuardDuty | Sample findings are generated |
| Findings list | New findings are displayed |
| Finding detail | Finding type, severity, and resource information are visible |
| EventBridge Rule | GuardDuty Finding rule is enabled |
| Step Functions | Workflow is ready to receive findings or can be tested using a sample event |

---

#### Validation Evidence

The validation evidence for this test includes the following screenshots:

| No. | Image | Purpose |
|---|---|---|
| 1 | GuardDuty finding flow diagram | Shows the overall testing flow |
| 2 | GuardDuty dashboard | Confirms that GuardDuty is enabled |
| 3 | Generate sample findings | Confirms that sample findings are generated |
| 4 | GuardDuty findings list | Shows multiple generated sample findings |
| 5 | GuardDuty finding detail | Shows detailed information of a selected finding |
| 6 | EventBridge rule | Confirms the GuardDuty rule is enabled |
| 7 | Step Functions executions | Confirms the workflow is ready for event processing |

---

#### Notes

GuardDuty sample findings may not always point to the actual EC2 workload created in this lab. Therefore, the main goal of this section is to verify that GuardDuty can generate and display findings correctly.

The actual EC2 isolation test will be performed in:

```text
5.5.3 Test Auto Isolation
```

In that section, a controlled sample event will be used with the correct EC2 instance ID from the lab. This allows the Incident Response Lambda to collect evidence, create an EBS Snapshot, update DynamoDB, and replace the EC2 Security Group with `SG-Isolation`.

---

#### Completion

You have completed the GuardDuty Finding test.

The result of this section confirms that GuardDuty is working and can generate security findings. These findings are important input data for the CloudSOC system to process through EventBridge, Step Functions, Lambda, and SNS in the next testing sections.