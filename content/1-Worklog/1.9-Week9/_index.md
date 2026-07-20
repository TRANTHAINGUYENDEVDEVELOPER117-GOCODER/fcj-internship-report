---
title: "Week 9 Worklog"
date: 2026-06-29
weight: 9
chapter: false
pre: " <b> 1.9. </b> "
---

### Implementation Period

* **Week 9:** From **2026-06-29** to **2026-07-05**.

### Week 9 Objectives

* Understand the role of AWS Step Functions in security incident response orchestration.
* Learn the basic components of a Step Functions state machine.
* Use AWS Lambda to receive, normalize, and evaluate security findings.
* Classify findings based on resource type, severity, resource identifier, and response conditions.
* Design separate branches for alert-only, approval-required, and automated-response scenarios.
* Use Amazon DynamoDB to store incident records and workflow status.
* Use Amazon S3 to store security evidence, finding details, and investigation data.
* Configure error handling, retry, and failure notification mechanisms.
* Build the main incident response workflow for the AWS CloudSOC project.

### Tasks to Be Carried Out This Week

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| Monday | - Review the EventBridge and SNS notification flow from Week 8 <br> - Learn the basic concepts of AWS Step Functions <br> - Understand State Machine, State, Execution, Input, Output, and Amazon States Language <br> - Identify the role of Step Functions in the AWS CloudSOC architecture | 2026-06-29 | 2026-06-29 | <https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html> |
| Tuesday | - Learn about the main Step Functions state types <br> - Review Task, Choice, Pass, Wait, Succeed, Fail, Parallel, and Map states <br> - Use Workflow Studio to create a basic state machine <br> - Test a simple workflow execution | 2026-06-30 | 2026-06-30 | <https://docs.aws.amazon.com/step-functions/latest/dg/concepts-states.html> |
| Wednesday | - Create an AWS Lambda function to process security findings <br> - Receive a sample GuardDuty or Security Hub event <br> - Extract information such as finding ID, severity, resource type, resource ID, account, Region, and title <br> - Return normalized data to the Step Functions workflow | 2026-07-01 | 2026-07-01 | <https://docs.aws.amazon.com/lambda/latest/dg/getting-started.html> |
| Thursday | - Design the finding evaluation logic <br> - Add Choice states to classify findings by resource type and severity <br> - Check whether the finding contains a valid EC2 Instance ID <br> - Check the AutoIsolate response condition <br> - Create Alert Only, Approval Required, and Automated Response branches | 2026-07-02 | 2026-07-02 | <https://docs.aws.amazon.com/step-functions/latest/dg/state-choice.html> |
| Friday | - Create an Amazon DynamoDB table for incident records <br> - Define attributes such as Incident ID, Finding ID, Severity, Resource ID, Status, Response Mode, and Timestamp <br> - Configure the workflow to create or update incident records <br> - Verify the stored data using the DynamoDB Console | 2026-07-03 | 2026-07-03 | <https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GettingStartedDynamoDB.html> |
| Saturday | - Create an Amazon S3 bucket for security evidence <br> - Configure encryption, Block Public Access, and suitable access permissions <br> - Store original finding data or investigation files in the bucket <br> - Organize evidence using folders or object prefixes based on incident ID and date | 2026-07-04 | 2026-07-04 | <https://docs.aws.amazon.com/AmazonS3/latest/userguide/GetStartedWithS3.html> |
| Sunday | - Add Retry and Catch configurations to the Step Functions workflow <br> - Configure failure handling and SNS notifications <br> - Test the workflow using Low, Medium, High, and Critical sample findings <br> - Review execution history, Lambda logs, DynamoDB records, and S3 evidence <br> - Check service costs and complete the Week 9 worklog | 2026-07-05 | 2026-07-05 | <https://docs.aws.amazon.com/step-functions/latest/dg/concepts-error-handling.html> |

### Week 9 Achievements

* Understood the role of AWS Step Functions in coordinating multiple services in an automated incident response workflow.

* Learned the main AWS Step Functions concepts, including:

  * State Machine
  * State
  * Execution
  * Input
  * Output
  * Amazon States Language
  * Execution History

* Reviewed the main state types used in Step Functions:

  * Task
  * Choice
  * Pass
  * Wait
  * Succeed
  * Fail
  * Parallel
  * Map

* Created a basic Step Functions state machine using Workflow Studio.

* Created an AWS Lambda function to receive and process security finding data.

* Extracted important information from GuardDuty or Security Hub findings, including:

  * Finding ID
  * Finding Type
  * Severity
  * Resource Type
  * Resource ID
  * EC2 Instance ID
  * AWS Account
  * AWS Region
  * Finding Title
  * Finding Description

* Normalized the finding data before sending it to the next state in the workflow.

* Designed the main finding evaluation logic using Step Functions Choice states.

* Created three main incident response branches:

  * **Alert Only:** Used for unsupported resources, Low or Medium findings, missing instance identifiers, or resources without the required response condition.
  * **Approval Required:** Used for High-severity EC2 findings that require approval from a SOC analyst.
  * **Automated Response:** Used for Critical EC2 findings that meet the automated response conditions.

* Added validation for:

  * Resource type
  * EC2 Instance ID
  * Finding severity
  * AutoIsolate condition
  * Response mode

* Created an Amazon DynamoDB table to store incident information.

* Defined important incident attributes, including:

  * Incident ID
  * Finding ID
  * Severity
  * Resource Type
  * Resource ID
  * Response Mode
  * Incident Status
  * Created Time
  * Updated Time

* Configured the workflow to create and update incident records in DynamoDB.

* Created an Amazon S3 bucket for storing security evidence and investigation data.

* Configured security settings for the evidence bucket, including:

  * Block Public Access
  * Server-side encryption
  * IAM access permissions
  * Object organization using prefixes

* Stored original finding data and security evidence in Amazon S3.

* Added Retry and Catch configurations to improve workflow reliability.

* Configured a failure branch to record errors and send notifications through Amazon SNS.

* Tested the workflow using findings with different severity levels.

* Reviewed Step Functions Execution History to verify the input, output, selected branch, and execution result.

* Verified the main Week 9 workflow:

  **Security Finding → EventBridge → Step Functions → Lambda Evaluation → Choice Branch → DynamoDB/S3 → SNS Notification**

* Prepared the automated response branch for integration with AWS Systems Manager during Week 10.

* Completed Week 9 with fundamental knowledge of AWS Step Functions, Lambda-based finding evaluation, DynamoDB incident storage, S3 evidence storage, and security workflow orchestration.