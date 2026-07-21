---
title : "Test Approval Workflow"
date : 2026-07-01
weight : 2
chapter : false
pre : " <b> 5.5.2. </b> "
---

#### Test Approval Workflow

In this section, you will test the **Approval Workflow** of the AWS CloudSOC system.

The goal of this test is to confirm that when a security finding has a high severity level but requires human confirmation, the system can place the incident into a pending approval state. The SOC Analyst can then review the incident on the dashboard and choose either **Approve** or **Reject**.

The Approval Workflow helps prevent the system from automatically isolating EC2 instances in every situation. Instead, incidents that require additional validation are sent to the SOC Analyst for manual review.

The overall workflow is:

```text
GuardDuty Finding
→ EventBridge
→ Step Functions
→ Approval Required
→ DynamoDB Incident Table
→ SOC Dashboard
→ Approve / Reject
→ Update Incident Status
```

In this section, the focus is on validating the incident status transition from `Pending` to `Approved` or `Rejected`.

---

#### Testing Objectives

After completing this section, you will be able to confirm that:

+ An incident can be created with a pending approval status.
+ The dashboard can display incidents that require SOC Analyst review.
+ The SOC Analyst can select **Approve** or **Reject** on the dashboard.
+ The approval status is updated in DynamoDB.
+ The Approval Workflow works as a control step before automated response actions are performed.

---

#### Testing Architecture

The following diagram shows the Approval Workflow test flow.

![Test Approval Workflow Flow](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/test-approval-workflow-flow.png)

The testing flow includes the following steps:

```text
Step Functions
→ Approval Required Branch
→ DynamoDB Incident Table
→ SOC Dashboard
→ SOC Analyst Approval
→ DynamoDB Status Update
```

In this test, an incident is placed into a pending approval state. The SOC Analyst then reviews the incident on the dashboard and updates the response decision.

---

#### Step 1: Check the Approval Required Branch

In the Step Functions workflow, the `Approval Required` branch is used for findings that have high severity but should not trigger automated response immediately.

![Step Functions Approval Branch](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/stepfunctions-approval-branch.png)

This branch helps separate three response paths:

| Response Branch | Description |
|---|---|
| Alert Only | Send an alert only and do not isolate the EC2 instance |
| Approval Required | Require SOC Analyst approval before continuing |
| Auto Response | Automatically respond when the finding is eligible |

In this test, the focus is on the following branch:

```text
Approval Required
```

---

#### Step 2: Create an Incident with Pending Status

A sample incident is created in DynamoDB to simulate a finding that requires SOC Analyst approval.

The initial status of the incident is:

```text
approvalStatus = Pending
incidentStatus = WaitingApproval
responseMode = ApprovalRequired
```

![Pending Incident in DynamoDB](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/incident-pending-in-dynamodb.png)

Example incident data:

| Field | Example |
|---|---|
| incidentId | INC-001 |
| findingType | UnauthorizedAccess:EC2/SSHBruteForce |
| severity | 7.5 |
| resourceId | EC2 instance ID |
| responseMode | ApprovalRequired |
| approvalStatus | Pending |
| incidentStatus | WaitingApproval |

The `Pending` status indicates that the incident is waiting for SOC Analyst review before the next response action is performed.

---

#### Step 3: Review the Incident on the SOC Dashboard

After the incident is written to DynamoDB, the dashboard reads data from the Incident Table and displays the incident for the SOC Analyst.

![Dashboard Pending Incident](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/dashboard-pending-incident.png)

The dashboard displays the main incident information, including:

```text
Incident ID
Finding Type
Severity
Resource ID
Response Mode
Approval Status
Incident Status
```

At the initial stage, the dashboard shows:

```text
Approval Status: Pending
Incident Status: WaitingApproval
```

This confirms that the dashboard can read incident data from DynamoDB correctly.

---

#### Step 4: SOC Analyst Approves the Incident

The SOC Analyst reviews the incident information and selects **Approve** on the dashboard.

![Dashboard Approve Action](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/dashboard-approve-action.png)

When **Approve** is selected, the dashboard sends a request to the backend API to update the incident status.

The processing flow is:

```text
SOC Analyst
→ Click Approve
→ API Gateway
→ Dashboard API Lambda
→ DynamoDB Incident Table
```

After the request is processed successfully, the approval status of the incident is updated.

---

#### Step 5: Verify DynamoDB After Approval

After the SOC Analyst selects **Approve**, DynamoDB is checked to confirm that the status has been updated.

![DynamoDB Approval Updated](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/dynamodb-approval-updated.png)

Expected result:

```text
approvalStatus = Approved
incidentStatus = Approved
```

In some workflow designs, the incident status may be:

```text
approvalStatus = Approved
incidentStatus = InProgress
```

The `Approved` status confirms that the SOC Analyst has allowed the incident to continue to the next response step.

---

#### Step 6: Check the Dashboard After the Update

After DynamoDB is updated, the dashboard displays the new status of the incident.

![Dashboard Approved Status](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/dashboard-approved-status.png)

The dashboard now shows that the incident has been approved.

Example displayed status:

```text
Approval Status: Approved
Incident Status: Approved
```

Or:

```text
Approval Status: Approved
Incident Status: InProgress
```

This confirms that the Approval Workflow works correctly from the dashboard interface to DynamoDB.

---

#### Step 7: Test the Reject Workflow

In addition to **Approve**, the SOC Analyst can also select **Reject** if the incident should not continue to the next response step.

![Dashboard Reject Action](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/dashboard-reject-action.png)

Reject processing flow:

```text
SOC Analyst
→ Click Reject
→ API Gateway
→ Dashboard API Lambda
→ DynamoDB Incident Table
```

After the incident is rejected, the expected status is:

```text
approvalStatus = Rejected
incidentStatus = Closed
```

Or:

```text
approvalStatus = Rejected
incidentStatus = Rejected
```

![DynamoDB Rejected Status](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/dynamodb-rejected-status.png)

The `Rejected` status confirms that the incident will not continue to the auto response phase.

---

#### Expected Results

After completing this section, the following results are expected:

| Component | Expected Result |
|---|---|
| Step Functions | The `Approval Required` branch exists |
| DynamoDB | An incident is stored with `Pending` status |
| Dashboard | The pending incident is displayed |
| Approve action | `approvalStatus` is updated to `Approved` |
| Reject action | `approvalStatus` is updated to `Rejected` |
| Incident status | The status changes based on the SOC Analyst decision |

---

#### Validation Evidence

The validation evidence for this test includes the following screenshots:

| No. | Image | Purpose |
|---|---|---|
| 1 | Approval workflow diagram | Shows the overall Approval Workflow test flow |
| 2 | Step Functions approval branch | Confirms that the workflow has the Approval Required branch |
| 3 | Pending incident in DynamoDB | Confirms that the incident is waiting for approval |
| 4 | Dashboard pending incident | Confirms that the dashboard displays the incident |
| 5 | Dashboard approve action | Confirms that the SOC Analyst can select Approve |
| 6 | DynamoDB approval updated | Confirms that the status is updated after approval |
| 7 | Dashboard approved status | Confirms that the dashboard displays the updated status |
| 8 | Dashboard reject action | Confirms that the SOC Analyst can select Reject |
| 9 | DynamoDB rejected status | Confirms that the status is updated after rejection |

---

#### Notes

The Approval Workflow acts as a control layer between threat detection and automated response.

In a real environment, not every finding should trigger an automatic response. Some findings may be false positives or may require additional analysis before isolating a workload.

In this lab, the Approval Workflow simulates the SOC Analyst decision-making process before the system performs stronger response actions such as:

```text
Collect Evidence
Create EBS Snapshot
Apply SG-Isolation
Send Notification
```

These automated response actions will be tested in the next section:

```text
5.5.3 Test Auto Isolation
```

---

#### Completion

You have completed the Approval Workflow test.

The result of this section confirms that the CloudSOC system can place an incident into a pending approval state, display the incident on the dashboard, and update the SOC Analyst decision in DynamoDB.

The Approval Workflow makes the incident response process safer by preventing automatic isolation when there is not enough confirmation.