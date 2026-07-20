---
title : "Test Dashboard and Alert"
date : 2026-07-01
weight : 4
chapter : false
pre : " <b> 5.5.4. </b> "
---

#### Test Dashboard and Alert

In this section, you will test the ability of the **SOC Dashboard** to display incident information and the ability of the alerting layer to send notifications through **Amazon SNS**, **Email**, and **Slack**.

After the CloudSOC system detects and processes an incident, the SOC Analyst needs to monitor the incident status on the dashboard and receive timely alerts through notification channels.

The overall workflow is:

```text
Incident Response Lambda
→ DynamoDB Incident Table
→ SOC Dashboard

Incident Response Lambda
→ Amazon SNS
→ Email / Slack
→ SOC Analyst

CloudWatch Alarm
→ Amazon SNS
→ Email / Slack
```

This test validates that the dashboard and alerting layer work correctly after an incident is processed.

---

#### Testing Objectives

After completing this section, you will be able to confirm that:

+ The SOC Dashboard can display the incident list.
+ The dashboard can show the updated incident status after response actions.
+ DynamoDB stores incident and notification information.
+ The SNS Topic has active subscriptions.
+ Email receives incident alerts.
+ Slack receives incident alerts through Amazon Q Developer in chat applications.
+ CloudWatch Alarm can send error notifications to SNS.

---

#### Testing Architecture

The following diagram shows the Dashboard and Alert test flow.

![Test Dashboard and Alert Flow](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-test-dashboard-and-alert/test-dashboard-alert-flow.png)

The testing flow has two main validation paths:

```text
Dashboard Validation:
DynamoDB Incident Table
→ Dashboard API Lambda
→ API Gateway
→ Amplify Dashboard
→ SOC Analyst

Alert Validation:
Incident Response Lambda / CloudWatch Alarm
→ Amazon SNS
→ Email / Slack
→ SOC Analyst
```

---

#### Step 1: Check the Dashboard Before New Alert Testing

First, open the SOC Dashboard deployed by AWS Amplify.

The dashboard used in this lab is:

```text
AWS CloudSOC Dashboard
```

The dashboard should display summary information such as:

```text
Total Incidents
Pending Approval
Critical Findings
Incident List
```

![Dashboard Before Alert Test](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-test-dashboard-and-alert/dashboard-before-alert-test.png)

At this stage, the dashboard acts as the monitoring interface for the SOC Analyst.

---

#### Step 2: Check the Processed Incident on the Dashboard

After completing **5.5.3 Test Auto Isolation**, the incident has been processed by the Incident Response Lambda.

The dashboard should display the updated status of the incident.

Expected example:

```text
Incident ID: INC-sample-finding-001
Finding Type: UnauthorizedAccess:EC2/SSHBruteForce
Severity: 8.5
Response Mode: AutoResponse
Approval Status: Approved
Incident Status: Isolated
```

![Dashboard Isolated Incident](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-test-dashboard-and-alert/dashboard-isolated-incident.png)

This confirms that the dashboard can display the incident response result after auto isolation is completed.

---

#### Step 3: Check the DynamoDB Notification Record

After Lambda processes the incident and sends a notification, the DynamoDB Incident Table should store the response status and notification-related information.

Important fields may include:

```text
incidentId
findingType
severity
resourceId
responseMode
approvalStatus
incidentStatus
evidencePath
snapshotIds
ssmCommandId
notificationMessageId
```

![DynamoDB Notification Record](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-test-dashboard-and-alert/dynamodb-notification-record.png)

The `notificationMessageId` field indicates that Lambda successfully called SNS publish and that SNS generated a message ID for the notification.

---

#### Step 4: Check SNS Topic and Subscriptions

Next, verify the SNS Topic used for incident alerts.

The SNS Topic used in this lab is:

```text
cloudsoc-incident-alerts
```

This topic is used to send incident alerts to Email and Slack.

![SNS Topic Subscriptions Validation](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-test-dashboard-and-alert/sns-topic-subscriptions-validation.png)

The subscription status should be:

```text
Confirmed
```

The endpoints may include:

```text
Email subscription
Slack integration through Amazon Q Developer in chat applications
```

This confirms that the SNS Topic is ready to deliver alerts to the SOC Analyst.

---

#### Step 5: Check Email Incident Alert

After the Incident Response Lambda publishes a message to SNS, the email subscription should receive an incident alert.

The email content may include:

```text
AWS CloudSOC Incident Response Completed

Incident ID
Finding Type
Severity
Resource ID
Response Mode
Incident Status
Isolation Security Group
SSM Command ID
Snapshot IDs
Evidence Path
```

![Email Incident Alert Received](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-test-dashboard-and-alert/email-incident-alert-received.png)

The email alert confirms that the SOC Analyst can receive a notification after an incident is processed.

---

#### Step 6: Check Slack Incident Alert

In addition to email, SNS can also send alerts to Slack through Amazon Q Developer in chat applications.

The Slack channel used in this lab is:

```text
#cloudsoc-alerts
```

After SNS sends the message, the Slack channel displays a notification from AWS.

![Slack Incident Alert Validation](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-test-dashboard-and-alert/slack-incident-alert-validation.png)

Slack alerts help the SOC Analyst receive incident notifications quickly in the team communication channel.

The alert should include key incident information such as:

```text
Incident ID
Finding Type
Severity
Resource ID
Incident Status
```

---

#### Step 7: Check CloudWatch Alarm

In addition to incident alerts, the system should also send alerts when the Incident Response Lambda has an error.

CloudWatch Alarm is used to monitor the Lambda error metric:

```text
Lambda Errors >= 1
```

The alarm used in this lab is:

```text
cloudsoc-incident-response-lambda-errors
```

![CloudWatch Alarm Dashboard](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-test-dashboard-and-alert/cloudwatch-alarm-dashboard.png)

This alarm helps the SOC Analyst know when the incident response automation has an error and needs investigation.

---

#### Step 8: Check Alarm Notification

When the CloudWatch Alarm changes to the `In alarm` state, it sends a notification to the SNS Topic.

The error alert flow is:

```text
CloudWatch Alarm
→ Amazon SNS
→ Email / Slack
→ SOC Analyst
```

![CloudWatch Alarm Notification](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-test-dashboard-and-alert/cloudwatch-alarm-notification.png)

The alarm notification helps the SOC Analyst detect failures in the response workflow, such as Lambda errors or workflow execution failures.

---

#### Step 9: Check the Final Incident Status on the Dashboard

After the incident has been processed and the alert has been sent, the dashboard is checked again to confirm the final incident status.

Expected final status:

```text
Incident Status: Isolated
Response Mode: AutoResponse
Approval Status: Approved
Notification: Sent
```

![Dashboard Final Incident Status](/images/5-Workshop/5.5-Testing-and-validation/5.5.4-test-dashboard-and-alert/dashboard-final-incident-status.png)

This result confirms that the SOC Dashboard reflects the final state of the incident correctly.

---

#### Expected Results

After completing this section, the following results are expected:

| Component | Expected Result |
|---|---|
| SOC Dashboard | Displays incidents and response status |
| DynamoDB | Stores incident status and notification message ID |
| SNS Topic | Has active subscriptions |
| Email | Receives the incident alert |
| Slack | Receives the incident alert |
| CloudWatch Alarm | Sends alarm notification through SNS |
| SOC Analyst | Can monitor incidents through dashboard and alerts |

---

#### Validation Evidence

The validation evidence for this test includes the following screenshots:

| No. | Image | Purpose |
|---|---|---|
| 1 | Dashboard and alert flow diagram | Shows the dashboard and alert validation flow |
| 2 | Dashboard before alert test | Confirms that the dashboard is working |
| 3 | Dashboard isolated incident | Confirms that the dashboard displays the processed incident |
| 4 | DynamoDB notification record | Confirms that DynamoDB stores notification status |
| 5 | SNS topic subscriptions | Confirms that SNS subscriptions are confirmed |
| 6 | Email incident alert | Confirms that email receives the incident alert |
| 7 | Slack incident alert | Confirms that Slack receives the incident alert |
| 8 | CloudWatch alarm dashboard | Confirms that the alarm monitors Lambda errors |
| 9 | CloudWatch alarm notification | Confirms that the alarm sends a notification |
| 10 | Dashboard final incident status | Confirms the final incident status on the dashboard |

---

#### Notes

Dashboard and alerting are important components in SOC operations.

The dashboard helps SOC Analysts monitor incidents in one place, while SNS, Email, and Slack provide fast notifications when an incident occurs or when the response automation fails.

In a real environment, the dashboard and alerting layer help the SOC team:

```text
Monitor incidents in near real time
Receive fast notifications when incidents occur
Check the incident response status
Track failures in response automation
Support faster investigation and decision-making
```

---

#### Completion

You have completed the Dashboard and Alert test.

The result of this section confirms that the AWS CloudSOC system can not only process incidents automatically, but also display incident status on the dashboard and send alerts to the SOC Analyst through Email, Slack, and CloudWatch Alarm.

This is the final validation step in **5.5 Testing and Validation**, confirming that the complete CloudSOC workflow works from detection, response, evidence storage, to alert delivery.