---
title : "Testing and Validation"
date : 2026-07-01
weight : 5
chapter : false
pre : " <b> 5.5. </b> "
---

#### Testing and Validation

In this section, you will test and validate the complete **AWS CloudSOC** system after finishing the deployment steps in **5.4 Deploy CloudSOC System**.

The goal of section 5.5 is to confirm that the main components of the system work correctly according to the designed workflow. This includes detecting security findings, handling the approval workflow, automatically isolating an EC2 instance, updating the dashboard, and sending alerts to the SOC Analyst.

The overall testing workflow is:

```text
GuardDuty Finding
→ EventBridge
→ Step Functions
→ Lambda Response
→ Evidence Storage
→ EC2 Isolation
→ Dashboard Update
→ SNS Alert
→ Email / Slack Notification
```

This testing section proves that CloudSOC is not only deployed successfully, but can also operate as an automated incident response system on AWS.

---

#### Testing Objectives

After completing this section, you will be able to confirm that:

+ Amazon GuardDuty can generate and display security findings.
+ EventBridge can receive GuardDuty Findings.
+ Step Functions can orchestrate the incident response workflow.
+ The Approval Workflow allows the SOC Analyst to approve or reject incidents.
+ Incident Response Lambda can process events and perform auto isolation.
+ Systems Manager can collect forensic evidence from EC2.
+ EBS Snapshot can be created for investigation.
+ Evidence can be stored in the S3 Evidence Bucket.
+ DynamoDB can update incident status.
+ The SOC Dashboard can display the correct incident status.
+ SNS can send alerts to Email and Slack.
+ CloudWatch Alarm can notify when Lambda has an error.

---

#### Testing Overview

The following diagram shows the overall testing flow in section 5.5.

![Testing and Validation Overview](/images/5-Workshop/5.5-Testing-and-validation/testing-validation-overview.png)

The testing process is divided into four main parts:

```text
Test GuardDuty Finding
→ Test Approval Workflow
→ Test Auto Isolation
→ Test Dashboard and Alert
```

Each test focuses on a key capability of the AWS CloudSOC system.

---

#### Testing Sections in 5.5

Section 5.5 is divided into four subsections. The tests should be performed in the following order to make the results clear and easy to validate.

| Section | Content | Testing Goal |
|---|---|---|
| [5.5.1 Test GuardDuty Finding](./5.5.1-test-guardduty-finding/) | Generate and review GuardDuty sample findings | Confirm that GuardDuty works and generates findings |
| [5.5.2 Test Approval Workflow](./5.5.2-test-approval-workflow/) | Test Approve / Reject actions on the dashboard | Confirm that the SOC Analyst can approve incidents |
| [5.5.3 Test Auto Isolation](./5.5.3-test-auto-isolation/) | Test Lambda-based EC2 auto isolation | Confirm that EC2 is changed to `SG-Isolation` |
| [5.5.4 Test Dashboard and Alert](./5.5.4-test-dashboard-and-alert/) | Test dashboard, SNS, Email, Slack, and CloudWatch Alarm | Confirm that dashboard and alerting work correctly |

---

#### Quick Navigation

- [5.5.1 Test GuardDuty Finding](./5.5.1-test-guardduty-finding/)
- [5.5.2 Test Approval Workflow](./5.5.2-test-approval-workflow/)
- [5.5.3 Test Auto Isolation](./5.5.3-test-auto-isolation/)
- [5.5.4 Test Dashboard and Alert](./5.5.4-test-dashboard-and-alert/)

---

#### Recommended Testing Order

```text
5.5.1 Test GuardDuty Finding
        ↓
5.5.2 Test Approval Workflow
        ↓
5.5.3 Test Auto Isolation
        ↓
5.5.4 Test Dashboard and Alert
```

This order validates the system according to the operational flow:

```text
Detection → Approval → Automated Response → Dashboard and Alert
```

---

#### Testing Architecture

The CloudSOC system is validated across multiple functional layers.

| Testing Layer | Related Services | Expected Validation Result |
|---|---|---|
| Detection Testing | GuardDuty, Security Hub | Findings are generated and displayed |
| Event Routing Testing | EventBridge, Step Functions | Findings can be routed into the workflow |
| Approval Testing | Dashboard, API Gateway, Lambda, DynamoDB | Incidents can be approved or rejected |
| Response Testing | Lambda, Systems Manager, EC2, EBS Snapshot | EC2 is isolated and evidence is collected |
| Evidence Testing | S3, DynamoDB | Evidence and incident status are stored |
| Alert Testing | SNS, Email, Slack, CloudWatch Alarm | SOC Analyst receives alerts |

---

#### 5.5.1 Test GuardDuty Finding

In this section, you will test the ability to generate and display **GuardDuty Findings**.

GuardDuty sample findings are used to simulate security scenarios without performing real attack activities.

The test includes:

+ Opening the GuardDuty dashboard.
+ Generating sample findings.
+ Reviewing the findings list.
+ Opening a finding detail.
+ Checking the EventBridge rule.
+ Checking Step Functions execution if available.

Expected result:

```text
GuardDuty can generate sample findings and display finding details for the next processing steps.
```

---

#### 5.5.2 Test Approval Workflow

In this section, you will test the **Approval Workflow**.

The Approval Workflow is used for incidents that require SOC Analyst review before stronger response actions are performed.

The test includes:

+ Checking the `Approval Required` branch in Step Functions.
+ Creating an incident with `Pending` status.
+ Reviewing the incident on the SOC Dashboard.
+ Performing the `Approve` action.
+ Checking the updated status in DynamoDB.
+ Performing the `Reject` action.
+ Confirming that rejected incidents do not continue to the auto response phase.

Expected result:

```text
The SOC Analyst can approve or reject incidents, and DynamoDB updates the incident status correctly.
```

---

#### 5.5.3 Test Auto Isolation

In this section, you will test the **Auto Isolation** capability.

Auto Isolation is the automated response flow used when the system processes a critical finding related to an EC2 instance.

The test includes:

+ Checking EC2 before isolation.
+ Running a sample GuardDuty event with the correct EC2 instance ID.
+ Triggering the Incident Response Lambda.
+ Collecting forensic evidence with Systems Manager.
+ Storing evidence in S3.
+ Creating an EBS Forensic Snapshot.
+ Replacing the EC2 Security Group from `SG-Workload` to `SG-Isolation`.
+ Updating the incident status in DynamoDB.
+ Checking Step Functions Auto Response execution if available.

Expected result:

```text
The suspected EC2 instance is isolated with SG-Isolation, evidence is stored in S3, a snapshot is created, and DynamoDB is updated.
```

---

#### 5.5.4 Test Dashboard and Alert

In this section, you will test the **SOC Dashboard** and the **Alerting** layer.

After an incident is processed, the SOC Analyst needs to monitor the status on the dashboard and receive alerts through Email or Slack.

The test includes:

+ Checking the dashboard before alert testing.
+ Checking that the dashboard displays the isolated incident.
+ Checking the DynamoDB notification record.
+ Checking the SNS Topic and subscriptions.
+ Checking that Email receives the incident alert.
+ Checking that Slack receives the incident alert.
+ Checking the CloudWatch Alarm for Lambda errors.
+ Checking that alarm notifications are sent through SNS.
+ Checking the final incident status on the dashboard.

Expected result:

```text
The dashboard displays the correct incident status, and the SOC Analyst receives alerts through Email or Slack.
```

---

#### Validation Checklist

The following table summarizes the expected validation results after completing the testing section.

![Testing and Validation Checklist](/images/5-Workshop/5.5-Testing-and-validation/testing-validation-checklist.png)

| Item | Expected Result |
|---|---|
| GuardDuty sample findings | Generated successfully |
| GuardDuty finding detail | Displays complete finding information |
| EventBridge rule | Enabled |
| Step Functions workflow | Able to process events |
| Approval workflow | Approve / Reject actions work correctly |
| DynamoDB incident table | Stores incident status |
| Incident Response Lambda | Runs successfully |
| Systems Manager Run Command | Collects forensic evidence |
| S3 Evidence Bucket | Stores raw event and response summary |
| EBS Snapshot | Created from the EC2 volume |
| EC2 Security Group | Changed to `SG-Isolation` |
| SOC Dashboard | Displays incident status |
| SNS Topic | Sends notifications successfully |
| Email alert | Email notification is received |
| Slack alert | Alert is received in the Slack channel |
| CloudWatch Alarm | Sends alert when Lambda has an error |

---

#### Overall Validation Result

After completing section 5.5, the AWS CloudSOC system has been validated through the full operational workflow:

```text
1. GuardDuty generates a security finding.
2. EventBridge receives the GuardDuty Finding.
3. Step Functions orchestrates the workflow.
4. The dashboard displays the incident that requires action.
5. The SOC Analyst can approve or reject the incident.
6. Lambda processes incidents that are eligible for auto response.
7. Systems Manager collects forensic evidence.
8. An EBS Snapshot is created for investigation.
9. Evidence is stored in the S3 Evidence Bucket.
10. EC2 is isolated using SG-Isolation.
11. DynamoDB updates the incident status.
12. SNS sends notifications to Email or Slack.
13. CloudWatch Alarm sends alerts when response automation fails.
```

---

#### Validation Evidence

The validation evidence collected in section 5.5 includes:

```text
GuardDuty findings
Step Functions executions
DynamoDB incident records
Lambda execution results
Systems Manager command outputs
S3 evidence objects
EBS forensic snapshots
EC2 security group changes
SOC Dashboard screenshots
SNS subscription records
Email notifications
Slack notifications
CloudWatch alarm notifications
```

These pieces of evidence confirm that the CloudSOC system works according to the design and can support the process of detection, investigation, response, evidence storage, and alerting.

---

#### Summary

Section 5.5 completed the testing and validation of the AWS CloudSOC system.

The testing results show that the system can perform the following process:

```text
Detect → Investigate → Approve → Respond → Store Evidence → Notify
```

Through this validation section, the CloudSOC system is confirmed to detect security findings, orchestrate workflows, support SOC Analyst approval, automatically isolate EC2, store evidence, and send alerts to notification channels.

The next section is:

```text
5.6 Resource Cleanup
```

In section 5.6, the resources created during the workshop will be cleaned up to avoid unnecessary costs.