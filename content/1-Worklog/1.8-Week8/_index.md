---
title: "Week 8 Worklog"
date: 2026-06-22
weight: 8
chapter: false
pre: " <b> 1.8. </b> "
---

### Implementation Period

* **Week 8:** From **2026-06-22** to **2026-06-28**.

### Week 8 Objectives

* Understand the concept of event-driven architecture on AWS.
* Learn how Amazon EventBridge receives and routes security events.
* Create EventBridge rules for Amazon GuardDuty and AWS Security Hub findings.
* Learn how Amazon SNS sends security notifications to administrators.
* Configure an SNS topic and email subscription.
* Build a basic security event and notification workflow.
* Filter security findings based on source, resource type, and severity.
* Prepare the event-processing foundation for the automated AWS CloudSOC response workflow.

### Tasks to Be Carried Out This Week

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| Monday | - Review the layered security services studied in Week 7 <br> - Learn the basic concepts of event-driven architecture <br> - Understand events, event sources, event buses, rules, and targets <br> - Identify the role of Amazon EventBridge in the AWS CloudSOC architecture | 2026-06-22 | 2026-06-22 | <https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-what-is.html> |
| Tuesday | - Learn about Amazon EventBridge Event Bus <br> - Review the structure of an AWS service event <br> - Identify fields such as source, detail-type, account, Region, time, resources, and detail <br> - Review example GuardDuty and Security Hub events | 2026-06-23 | 2026-06-23 | <https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-events-structure.html> |
| Wednesday | - Create an Amazon SNS topic for security notifications <br> - Create an email subscription <br> - Confirm the SNS subscription through email <br> - Publish a test message and verify that the notification is received | 2026-06-24 | 2026-06-24 | <https://docs.aws.amazon.com/sns/latest/dg/sns-create-topic.html> |
| Thursday | - Create an EventBridge rule for Amazon GuardDuty findings <br> - Configure an event pattern using the GuardDuty event source <br> - Add Amazon SNS as the target <br> - Test the rule using a sample finding or test event | 2026-06-25 | 2026-06-25 | <https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_findings_eventbridge.html> |
| Friday | - Create an EventBridge rule for AWS Security Hub findings <br> - Filter findings based on workflow status, severity, or resource type <br> - Add Amazon SNS as the notification target <br> - Review the notification message received by email | 2026-06-26 | 2026-06-26 | <https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cwe-integration.html> |
| Saturday | - Review EventBridge event patterns <br> - Create separate rules for Low, Medium, High, and Critical findings when required <br> - Test filtering by EC2 resource type and severity <br> - Verify that only matching security findings are sent to the SNS topic | 2026-06-27 | 2026-06-27 | <https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-event-patterns.html> |
| Sunday | - Review IAM permissions for EventBridge and Amazon SNS <br> - Check EventBridge rule metrics and invocation results <br> - Review retry behavior and failed event handling concepts <br> - Check service costs and remove unnecessary test resources <br> - Complete the Week 8 worklog | 2026-06-28 | 2026-06-28 | <https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-rule-dlq.html> |

### Week 8 Achievements

* Understood the concept of event-driven architecture and its role in automating cloud security operations.

* Learned the main components of Amazon EventBridge, including:

  * Event
  * Event Source
  * Event Bus
  * Event Pattern
  * Rule
  * Target

* Understood how AWS services publish events to the default EventBridge Event Bus.

* Reviewed the basic structure of an AWS event and identified important fields, including:

  * Source
  * Detail Type
  * AWS Account
  * AWS Region
  * Event Time
  * Resources
  * Event Detail

* Understood how Amazon GuardDuty findings can be delivered to Amazon EventBridge.

* Understood how AWS Security Hub findings can be routed through Amazon EventBridge.

* Created an Amazon SNS topic for security notifications.

* Created and confirmed an email subscription for the SNS topic.

* Published a test SNS message and verified that the email notification was received.

* Created an EventBridge rule for Amazon GuardDuty findings.

* Configured Amazon SNS as the target of the EventBridge rule.

* Created an EventBridge rule for AWS Security Hub findings.

* Practiced filtering security findings using event pattern fields such as:

  * Security service source
  * Finding severity
  * Resource type
  * AWS account
  * AWS Region
  * Workflow status

* Reviewed the differences between Low, Medium, High, and Critical security findings.

* Tested the notification flow using sample security findings or test events.

* Verified the basic security notification workflow:

  **GuardDuty or Security Hub → Amazon EventBridge → Amazon SNS → Email Notification**

* Reviewed IAM permissions required for EventBridge to publish messages to an SNS topic.

* Learned about EventBridge retry behavior and dead-letter queues for failed event delivery.

* Reviewed EventBridge metrics to check successful and failed target invocations.

* Identified Amazon EventBridge as the central event-routing service for the final AWS CloudSOC project.

* Prepared the event-processing foundation required for AWS Step Functions and Lambda integration in the following weeks.

* Completed Week 8 with fundamental knowledge of Amazon EventBridge, Amazon SNS, security event filtering, and automated security notifications.