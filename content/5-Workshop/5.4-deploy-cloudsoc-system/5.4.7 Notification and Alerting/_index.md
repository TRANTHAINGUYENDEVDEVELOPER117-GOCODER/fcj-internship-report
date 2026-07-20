---
title : "Notification and Alerting"
date : 2026-07-01
weight : 7
chapter : false
pre : " <b> 5.4.7. </b> "
---

#### Notification and Alerting

In this section, you will implement the **Notification and Alerting** layer for the AWS CloudSOC system. This layer is responsible for sending alerts when an incident is detected, when the incident response Lambda completes its action, or when the response workflow fails.

In the previous sections, the system was able to detect findings, orchestrate the workflow, collect evidence, create snapshots, and isolate an EC2 instance. However, a SOC system should not only respond to incidents, but also notify the SOC Analyst or operations team in a timely manner.

The main notification flow in this section is:

```text
Incident Response Lambda
→ Amazon SNS Topic
→ Email / SMS / Slack
```

In addition, CloudWatch Alarm can send alerts when the Lambda function fails:

```text
CloudWatch Alarm
→ Amazon SNS Topic
→ Email / SMS / Slack
```

---

#### Objectives

After completing this section, you will have:

+ An SNS Topic for CloudSOC incident alerts.
+ An Email subscription for receiving incident notifications.
+ The Incident Response Lambda updated to publish response results to SNS.
+ A CloudWatch Alarm to monitor Incident Response Lambda errors.
+ Alert notifications when Lambda execution fails.
+ Optional Slack integration through Amazon Q Developer in chat applications.
+ Screenshots proving that notifications are sent successfully.

---

#### Notification and Alerting Architecture

The following diagram illustrates the notification flow of AWS CloudSOC.

![Notification and Alerting Architecture](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/notification-alerting-architecture.png)

The main notification workflow is:

```text
Incident Response Lambda
→ Amazon SNS
→ Email / SMS / Slack
```

The error alerting workflow is:

```text
CloudWatch Metrics
→ CloudWatch Alarm
→ Amazon SNS
→ Email / SMS / Slack
```

In this architecture, Amazon SNS acts as the central notification distribution service. Lambda publishes incident response results to SNS, while CloudWatch Alarm sends alerts when Lambda errors occur.

---

#### Recommended Configuration

| Component | Recommended Value |
|---|---|
| SNS Topic | `cloudsoc-incident-alerts` |
| SNS Display name | `CloudSOCAlert` |
| Email subscription | SOC Analyst email address |
| Lambda Function | `cloudsoc-incident-response-lambda` |
| Lambda Environment Variable | `SNS_TOPIC_ARN` |
| CloudWatch Alarm | `cloudsoc-incident-response-lambda-errors` |
| Alarm metric | Lambda Errors |
| Alarm condition | Errors >= 1 |
| Slack integration | Optional |

---

#### Step 1: Create an SNS Topic

Go to:

```text
Amazon SNS → Topics → Create topic
```

Configure the topic:

| Field | Value |
|---|---|
| Type | Standard |
| Name | `cloudsoc-incident-alerts` |
| Display name | `CloudSOCAlert` |

Then choose:

```text
Create topic
```

Expected result:

```text
The SNS Topic cloudsoc-incident-alerts is created successfully.
```

![Create SNS Topic](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/create-sns-topic.png)

---

#### Step 2: Create an Email Subscription

Inside the topic:

```text
cloudsoc-incident-alerts
```

choose:

```text
Create subscription
```

Configure the subscription:

| Field | Value |
|---|---|
| Topic ARN | ARN of `cloudsoc-incident-alerts` |
| Protocol | Email |
| Endpoint | SOC Analyst email address |

Then choose:

```text
Create subscription
```

Expected result:

```text
The email subscription is created and is waiting for confirmation.
```

![SNS Email Subscription](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/sns-email-subscription.png)

---

#### Step 3: Confirm the Email Subscription

Open the email from AWS Notifications.

Choose:

```text
Confirm subscription
```

After confirmation, return to the SNS topic and verify the subscription status.

Expected result:

```text
The subscription status changes from Pending confirmation to Confirmed.
```

![SNS Subscription Confirmed](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/sns-subscription-confirmed.png)

---

#### Step 4: Publish a Test Message from SNS

In the SNS topic:

```text
cloudsoc-incident-alerts
```

choose:

```text
Publish message
```

Configure the message:

| Field | Value |
|---|---|
| Subject | `AWS CloudSOC Test Alert` |
| Message body | `This is a test notification from AWS CloudSOC.` |

Then choose:

```text
Publish message
```

Expected result:

```text
The SOC Analyst receives a test alert email from SNS.
```

![SNS Test Message](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/sns-test-message.png)

![Email Alert Received](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/email-alert-received.png)

---

#### Step 5: Add SNS Permission to the Incident Response Lambda Role

The Incident Response Lambda needs permission to publish messages to the SNS topic.

Go to:

```text
IAM → Roles → CloudSOC-Incident-Response-Lambda-Role
```

Choose:

```text
Add permissions → Create inline policy
```

Open the:

```text
JSON
```

tab and add the following policy. Replace `<account-id>` with your AWS Account ID.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "SNSPublishIncidentAlerts",
      "Effect": "Allow",
      "Action": [
        "sns:Publish"
      ],
      "Resource": "arn:aws:sns:ap-southeast-1:<account-id>:cloudsoc-incident-alerts"
    }
  ]
}
```

Set the policy name:

```text
CloudSOC-SNS-Publish-Policy
```

Expected result:

```text
The Incident Response Lambda Role can publish messages to SNS.
```

![Lambda SNS Permission](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/lambda-sns-permission.png)

---

#### Step 6: Add SNS Topic ARN to Lambda Environment Variables

Go to:

```text
Lambda → cloudsoc-incident-response-lambda
→ Configuration → Environment variables → Edit
```

Add the following environment variable:

| Key | Value |
|---|---|
| `SNS_TOPIC_ARN` | ARN of the SNS topic `cloudsoc-incident-alerts` |

Example:

```text
SNS_TOPIC_ARN = arn:aws:sns:ap-southeast-1:123456789012:cloudsoc-incident-alerts
```

Expected result:

```text
Lambda knows which SNS Topic to publish notifications to.
```

![Lambda SNS Environment Variable](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/lambda-sns-environment-variable.png)

---

#### Step 7: Update Lambda to Send SNS Notifications

In the Lambda function:

```text
cloudsoc-incident-response-lambda
```

open the:

```text
Code
```

tab.

Add the SNS client and environment variable near the beginning of the file:

```python
sns = boto3.client("sns", region_name=REGION)
SNS_TOPIC_ARN = os.environ.get("SNS_TOPIC_ARN")
```

Add the following notification function:

```python
def publish_notification(subject, message):
    if not SNS_TOPIC_ARN:
        print("SNS_TOPIC_ARN is not configured. Skipping notification.")
        return None

    response = sns.publish(
        TopicArn=SNS_TOPIC_ARN,
        Subject=subject,
        Message=message
    )

    return response.get("MessageId")
```

Then, near the end of `lambda_handler`, before:

```python
return result
```

add the following code:

```python
notification_message = f"""
AWS CloudSOC Incident Response Completed

Incident ID: {incident_id}
Finding Type: {finding_type}
Severity: {severity}
Resource ID: {instance_id}
Response Mode: AutoResponse
Incident Status: Isolated
Isolation Security Group: {ISOLATION_SG_ID}
SSM Command ID: {ssm_command_id}
Snapshot IDs: {snapshot_ids}
Evidence Path: {raw_event_s3_path}

The affected EC2 instance has been isolated and forensic evidence has been collected.
"""

message_id = publish_notification(
    subject="AWS CloudSOC Incident Isolated",
    message=notification_message
)

result["notificationMessageId"] = message_id
```

After updating the code, choose:

```text
Deploy
```

Expected result:

```text
Lambda can send a notification after processing an incident.
```

![Lambda SNS Publish Code](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/lambda-sns-publish-code.png)

---

#### Step 8: Test Lambda Notification

Open the:

```text
Test
```

tab and run the test event:

```text
gd-ec2-test
```

Expected result in the Lambda response:

```text
notificationMessageId
incidentStatus = Isolated
approvalStatus = Approved
responseMode = AutoResponse
```

![Lambda SNS Test Result](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/lambda-sns-test-result.png)

Then check your email inbox.

The email should contain content similar to:

```text
AWS CloudSOC Incident Response Completed

Incident ID: INC-sample-finding-001
Finding Type: UnauthorizedAccess:EC2/SSHBruteForce
Severity: 8.5
Resource ID: i-xxxxxxxxxxxxxxxxx
Response Mode: AutoResponse
Incident Status: Isolated
```

![Incident Email Notification](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/incident-email-notification.png)

---

#### Step 9: Create a CloudWatch Alarm for Lambda Errors

CloudWatch Alarm helps notify the SOC Analyst when the Incident Response Lambda fails.

Go to:

```text
CloudWatch → Alarms → All alarms → Create alarm
```

Select the metric:

```text
Lambda → By Function Name → cloudsoc-incident-response-lambda → Errors
```

Configure the metric condition:

| Field | Value |
|---|---|
| Metric | `Errors` |
| Statistic | Sum |
| Period | 1 minute |
| Condition | Greater/Equal |
| Threshold | 1 |

Configure notification:

| Field | Value |
|---|---|
| Alarm state trigger | In alarm |
| SNS topic | `cloudsoc-incident-alerts` |

Set the alarm name:

```text
cloudsoc-incident-response-lambda-errors
```

Expected result:

```text
A CloudWatch Alarm is created to monitor Incident Response Lambda errors.
```

![Create Lambda Error Alarm](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/create-lambda-error-alarm.png)

---

#### Step 10: Verify Alarm Notification

To test the alarm, create a controlled error by running Lambda with a test event that does not include `instanceId`.

Example error test event:

```json
{
  "version": "0",
  "id": "sample-error-event",
  "detail-type": "GuardDuty Finding",
  "source": "aws.guardduty",
  "account": "123456789012",
  "region": "ap-southeast-1",
  "detail": {
    "id": "sample-error-finding",
    "severity": 8.5,
    "type": "UnauthorizedAccess:EC2/SSHBruteForce",
    "title": "Sample error finding",
    "resource": {
      "resourceType": "Instance",
      "instanceDetails": {}
    }
  }
}
```

When Lambda fails, CloudWatch records the `Errors` metric. After a short period, the alarm should change to:

```text
In alarm
```

Expected result:

```text
The SOC Analyst receives an email alert when the Incident Response Lambda fails.
```

![CloudWatch Alarm In Alarm](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/cloudwatch-alarm-in-alarm.png)

![Alarm Email Notification](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/alarm-email-notification.png)

---

#### Step 11: Optional - Integrate Slack with Amazon Q Developer in chat applications

In addition to email, the system can send alerts to Slack through Amazon Q Developer in chat applications.

The integration flow is:

```text
Amazon SNS
→ Amazon Q Developer in chat applications
→ Slack Channel
```

General configuration steps:

```text
Amazon Q Developer in chat applications
→ Configure Slack workspace
→ Configure Slack channel
→ Subscribe SNS topic
→ Test notification
```

Expected result:

```text
Incident alerts are delivered to the Slack channel used by the SOC team.
```

![Slack Channel Configuration](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/slack-channel-configuration.png)

![Slack Incident Alert](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/slack-incident-alert.png)

> **Note:** Slack integration is optional for this lab. Email notification is enough to demonstrate the notification flow.

---

#### Step 12: Check DynamoDB After Sending Notification

Go to:

```text
DynamoDB → Tables → CloudSOC-IncidentTable → Explore table items
```

Find the latest incident.

If `notificationMessageId` is added to the result, DynamoDB can store notification information in the incident record.

Check the following fields:

```text
incidentStatus = Isolated
approvalStatus = Approved
notificationMessageId = <sns-message-id>
```

Expected result:

```text
The incident record shows that the response action has completed and a notification has been sent.
```

![DynamoDB Notification Updated](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.7-notification-and-alerting/dynamodb-notification-updated.png)

---

#### Completion Checklist

After completing this section, verify the following items:

- [ ] SNS Topic `cloudsoc-incident-alerts` is created.
- [ ] Email subscription is confirmed.
- [ ] SNS test message is sent successfully.
- [ ] Incident Response Lambda has `sns:Publish` permission.
- [ ] Lambda has the environment variable `SNS_TOPIC_ARN`.
- [ ] Lambda sends notification after processing an incident.
- [ ] Incident alert email is received.
- [ ] CloudWatch Alarm monitors Lambda Errors.
- [ ] Alarm notification is sent when Lambda fails.
- [ ] Slack integration is configured if required by the workshop.

---

#### Completion Result

After completing this section, AWS CloudSOC can send alerts when an incident is processed and when the response workflow fails.

The following components are now ready:

```text
Amazon SNS
Email Subscription
Incident Response Lambda Notification
CloudWatch Alarm
Optional Slack Notification
```

The complete workflow after this section is:

```text
GuardDuty Finding
→ EventBridge
→ Step Functions
→ Incident Response Lambda
→ Forensics / Snapshot / Isolation
→ SNS Notification
→ SOC Analyst
```

---

#### Summary

In this section, you implemented the Notification and Alerting layer for AWS CloudSOC. Amazon SNS is used as the central notification service, Email helps the SOC Analyst receive alerts quickly, CloudWatch Alarm helps detect Lambda failures, and Slack can be integrated as an additional alerting channel.

After this section, the main CloudSOC deployment workflow is complete. In the next section, you will move to **Testing and Validation** to verify the full flow of detection, response, evidence storage, EC2 isolation, and notification.