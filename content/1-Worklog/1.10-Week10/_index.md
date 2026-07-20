---
title: "Week 10 Worklog"
date: 2026-07-06
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

### Implementation Period

* **Week 10:** From **2026-07-06** to **2026-07-12**.

### Week 10 Objectives

* Understand the automated response process for security incidents involving Amazon EC2.
* Use AWS Lambda to validate findings and perform response actions.
* Use AWS Systems Manager to collect investigation information and execute response commands.
* Create a quarantine Security Group for isolating suspicious EC2 instances.
* Check the `AutoIsolate` tag before performing automated actions.
* Implement separate approval and automated-response branches.
* Store the original EC2 configuration before isolation.
* Update incident status in Amazon DynamoDB.
* Store investigation evidence in Amazon S3.
* Implement rollback and recovery procedures for isolated EC2 instances.
* Test the complete automated incident response workflow.

### Tasks to Be Carried Out This Week

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| Monday | - Review the Step Functions workflow created in Week 9 <br> - Identify the automated response actions required for EC2 findings <br> - Define response conditions based on severity, resource type, Instance ID, and the `AutoIsolate` tag <br> - Review safety controls to prevent unintended isolation | 2026-07-06 | 2026-07-06 | <https://docs.aws.amazon.com/whitepapers/latest/aws-security-incident-response-guide/welcome.html> |
| Tuesday | - Create a quarantine Security Group <br> - Configure restrictive inbound and outbound rules <br> - Create the IAM roles and policies required by Lambda and Systems Manager <br> - Apply the principle of least privilege to response permissions | 2026-07-07 | 2026-07-07 | <https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html> |
| Wednesday | - Create a Lambda function to validate the affected EC2 instance <br> - Use the EC2 API to retrieve the instance state, tags, network interfaces, and Security Groups <br> - Verify the `AutoIsolate=true` tag <br> - Save the original Security Group configuration in DynamoDB before performing isolation | 2026-07-08 | 2026-07-08 | <https://docs.aws.amazon.com/lambda/latest/dg/with-ec2-example.html> |
| Thursday | - Learn how AWS Systems Manager can support incident response <br> - Verify that the EC2 instance is managed by Systems Manager <br> - Use Run Command or Automation to collect system and network information <br> - Send investigation results and command output to Amazon S3 or CloudWatch Logs | 2026-07-09 | 2026-07-09 | <https://docs.aws.amazon.com/systems-manager/latest/userguide/run-command.html> |
| Friday | - Implement the Approval Required branch for High-severity findings <br> - Send an approval request to the SOC analyst through Amazon SNS <br> - Use the Step Functions callback pattern with a task token when appropriate <br> - Continue or stop the response workflow based on the analyst decision | 2026-07-10 | 2026-07-10 | <https://docs.aws.amazon.com/step-functions/latest/dg/connect-to-resource.html#connect-wait-token> |
| Saturday | - Implement the Automated Response branch for Critical findings <br> - Invoke Lambda to replace the original Security Groups with the quarantine Security Group <br> - Use Systems Manager to collect investigation information <br> - Update the incident status in DynamoDB <br> - Store response evidence in Amazon S3 and send a notification through Amazon SNS | 2026-07-11 | 2026-07-11 | <https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_ModifyNetworkInterfaceAttribute.html> |
| Sunday | - Create a rollback function to restore the original Security Groups <br> - Test Alert Only, Approval Required, Automated Response, and Rollback scenarios <br> - Review Step Functions execution history, Lambda logs, Systems Manager output, DynamoDB records, and S3 evidence <br> - Check service costs and complete the Week 10 worklog | 2026-07-12 | 2026-07-12 | <https://docs.aws.amazon.com/step-functions/latest/dg/concepts-view-execution-details.html> |

### Week 10 Achievements

* Understood the main stages of an automated EC2 incident response process:

  * Finding validation
  * Resource verification
  * Response condition evaluation
  * Analyst approval
  * Resource isolation
  * Investigation data collection
  * Notification
  * Recovery and rollback

* Defined the required conditions before performing automated isolation:

  * The affected resource must be an Amazon EC2 instance.
  * The finding must contain a valid EC2 Instance ID.
  * The severity must meet the configured response threshold.
  * The EC2 instance must contain the `AutoIsolate=true` tag.
  * The response mode must allow automated actions.

* Created a quarantine Security Group for isolating suspicious EC2 instances.

* Configured restrictive Security Group rules to limit network communication during an incident.

* Created IAM roles and policies for:

  * AWS Lambda
  * AWS Step Functions
  * AWS Systems Manager
  * Amazon DynamoDB
  * Amazon S3
  * Amazon SNS

* Applied least-privilege permissions to the automated response components.

* Created a Lambda function to retrieve EC2 information, including:

  * Instance ID
  * Instance state
  * Instance tags
  * VPC ID
  * Subnet ID
  * Network Interface ID
  * Current Security Group IDs

* Implemented validation for the `AutoIsolate` tag.

* Stored the original EC2 Security Group configuration in DynamoDB before isolation.

* Verified whether the affected EC2 instance was registered as an AWS Systems Manager managed node.

* Used AWS Systems Manager Run Command or Automation to collect investigation information, including:

  * Running processes
  * Active network connections
  * Logged-in users
  * System information
  * Network configuration
  * Recent system events

* Sent investigation command output to Amazon S3 or CloudWatch Logs.

* Implemented the Approval Required branch for High-severity findings.

* Sent an approval request to the SOC analyst through Amazon SNS.

* Learned how the Step Functions callback pattern and task token can be used to pause a workflow until an approval decision is received.

* Implemented the Automated Response branch for Critical findings.

* Created a Lambda response function to replace the current Security Groups with the quarantine Security Group.

* Updated DynamoDB incident records with information such as:

  * Response status
  * Approval status
  * Isolation time
  * Original Security Groups
  * Quarantine Security Group
  * Systems Manager command ID
  * Last updated time

* Stored incident response evidence and investigation results in Amazon S3.

* Sent security response notifications through Amazon SNS.

* Created a rollback function to restore the original EC2 Security Groups.

* Tested the main response scenarios:

  * **Alert Only:** The finding generates a notification without changing the resource.
  * **Approval Required:** The workflow waits for approval before performing isolation.
  * **Automated Response:** A Critical finding automatically triggers EC2 isolation.
  * **Rollback:** The original Security Groups are restored after investigation.

* Reviewed Step Functions Execution History to verify each workflow state and response result.

* Reviewed Lambda logs and Systems Manager command output for troubleshooting.

* Verified the main Week 10 automated response workflow:

  **Security Finding → EventBridge → Step Functions → Lambda Validation → Approval or Automatic Isolation → Systems Manager Investigation → DynamoDB/S3 → SNS Notification**

* Completed Week 10 with practical knowledge of automated EC2 isolation, analyst approval, investigation using AWS Systems Manager, incident tracking, evidence storage, and resource recovery.