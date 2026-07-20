---
title: "Week 11 Worklog"
date: 2026-07-13
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

### Implementation Period

* **Week 11:** From **2026-07-13** to **2026-07-19**.

### Week 11 Objectives

* Perform end-to-end testing of the AWS CloudSOC incident response workflow.
* Verify the integration between all security detection, orchestration, response, storage, and notification services.
* Test multiple security finding scenarios and response branches.
* Validate IAM permissions and apply the principle of least privilege.
* Review system monitoring, logging, error handling, and recovery mechanisms.
* Evaluate the architecture according to AWS Well-Architected principles.
* Review security, reliability, performance, operational efficiency, and cost optimization.
* Complete the final AWS architecture diagram.
* Record test results, identified issues, and corrective actions.
* Prepare the AWS CloudSOC project for final documentation and presentation.

### Tasks to Be Carried Out This Week

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| Monday | - Review the complete AWS CloudSOC architecture developed in previous weeks <br> - Verify the connection between GuardDuty, Security Hub, EventBridge, Step Functions, Lambda, Systems Manager, DynamoDB, S3, and SNS <br> - Define test cases and expected results for the complete workflow | 2026-07-13 | 2026-07-13 | <https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html> |
| Tuesday | - Test the Alert Only branch using unsupported resources and Low or Medium findings <br> - Verify that no isolation action is performed <br> - Confirm that incident data is recorded and notifications are delivered <br> - Review Step Functions Execution History and Lambda Logs | 2026-07-14 | 2026-07-14 | <https://docs.aws.amazon.com/step-functions/latest/dg/concepts-view-execution-details.html> |
| Wednesday | - Test the Approval Required branch using a High-severity EC2 finding <br> - Verify the approval notification and workflow waiting state <br> - Test approval and rejection decisions <br> - Confirm that the workflow continues or stops according to the analyst decision | 2026-07-15 | 2026-07-15 | <https://docs.aws.amazon.com/step-functions/latest/dg/connect-to-resource.html#connect-wait-token> |
| Thursday | - Test the Automated Response branch using a Critical EC2 finding with the `AutoIsolate=true` tag <br> - Verify EC2 validation, Security Group replacement, Systems Manager data collection, DynamoDB updates, S3 evidence storage, and SNS notifications <br> - Test the rollback process to restore the original Security Groups | 2026-07-16 | 2026-07-16 | <https://docs.aws.amazon.com/whitepapers/latest/aws-security-incident-response-guide/welcome.html> |
| Friday | - Test error-handling scenarios such as missing Instance ID, invalid resource type, missing tag, Lambda failure, permission failure, and Systems Manager unavailable <br> - Verify Retry, Catch, Fail, and notification branches <br> - Review CloudWatch Logs and correct identified errors | 2026-07-17 | 2026-07-17 | <https://docs.aws.amazon.com/step-functions/latest/dg/concepts-error-handling.html> |
| Saturday | - Review the architecture using AWS Well-Architected principles <br> - Evaluate security, reliability, operational excellence, performance efficiency, cost optimization, and sustainability <br> - Review IAM roles, resource policies, encryption, logging, availability, and service costs <br> - Identify architecture improvements | 2026-07-18 | 2026-07-18 | <https://docs.aws.amazon.com/wellarchitected/latest/framework/the-pillars-of-the-framework.html> |
| Sunday | - Complete the final AWS CloudSOC architecture diagram <br> - Add AWS service groups, data flows, event numbers, trust boundaries, and explanatory notes <br> - Record test cases, results, problems, and corrective actions <br> - Review active resources and estimated costs <br> - Complete the Week 11 worklog | 2026-07-19 | 2026-07-19 | <https://aws.amazon.com/architecture/> |

### Week 11 Achievements

* Completed an end-to-end review of the AWS CloudSOC architecture.

* Verified the integration of the main AWS services:

  * Amazon GuardDuty
  * AWS Security Hub
  * Amazon EventBridge
  * AWS Step Functions
  * AWS Lambda
  * AWS Systems Manager
  * Amazon DynamoDB
  * Amazon S3
  * Amazon SNS
  * Amazon CloudWatch
  * AWS CloudTrail

* Confirmed the main incident response workflow:

  **GuardDuty or Security Hub → EventBridge → Step Functions → Lambda Evaluation → Response Branch → Systems Manager → DynamoDB/S3 → SNS**

* Created test cases for different security finding conditions, including:

  * Unsupported resource type
  * Missing EC2 Instance ID
  * Missing `AutoIsolate` tag
  * Low-severity finding
  * Medium-severity finding
  * High-severity finding
  * Critical-severity finding
  * Lambda execution failure
  * IAM permission failure
  * Systems Manager unavailable
  * Rollback request

* Successfully tested the Alert Only branch.

* Verified that Low and Medium findings generated notifications without changing the affected resource.

* Confirmed that incident information was stored in DynamoDB and evidence was stored in Amazon S3 when required.

* Successfully tested the Approval Required branch for High-severity EC2 findings.

* Verified that the Step Functions workflow could pause while waiting for the SOC analyst’s decision.

* Tested both approval and rejection scenarios.

* Confirmed that the workflow continued only after receiving a valid approval response.

* Successfully tested the Automated Response branch for Critical EC2 findings.

* Verified the automated response steps:

  * Validate the affected resource.
  * Check the EC2 Instance ID.
  * Check the `AutoIsolate=true` tag.
  * Save the original Security Group configuration.
  * Attach the Quarantine Security Group.
  * Collect investigation data using Systems Manager.
  * Update the incident record in DynamoDB.
  * Store evidence in Amazon S3.
  * Send a response notification through Amazon SNS.

* Successfully tested the rollback process.

* Restored the original Security Groups of the isolated EC2 instance after completing the investigation.

* Tested error-handling mechanisms for missing information and failed service calls.

* Verified the operation of Step Functions configurations, including:

  * Retry
  * Catch
  * Fail State
  * Timeout
  * Error Notification

* Reviewed Step Functions Execution History to examine each workflow state, input, output, error, and result.

* Reviewed CloudWatch Logs for Lambda and Systems Manager troubleshooting.

* Verified that important actions were recorded by AWS CloudTrail.

* Reviewed the IAM roles and policies used by the AWS CloudSOC system.

* Removed unnecessary permissions and improved alignment with the principle of least privilege.

* Reviewed security controls, including:

  * IAM permissions
  * Multi-Factor Authentication
  * S3 Block Public Access
  * Server-side encryption
  * Resource policies
  * Security Groups
  * Logging and monitoring
  * Incident evidence protection

* Evaluated the architecture according to the six AWS Well-Architected pillars:

  * Operational Excellence
  * Security
  * Reliability
  * Performance Efficiency
  * Cost Optimization
  * Sustainability

* Identified several architecture improvement areas, including:

  * Improving IAM permission scope
  * Adding more detailed CloudWatch metrics and alarms
  * Improving failure notification
  * Adding dead-letter queues where appropriate
  * Defining incident retention policies
  * Improving evidence encryption and lifecycle management
  * Limiting unnecessary paid resources

* Reviewed resource usage and possible costs from:

  * Amazon EC2
  * NAT Gateway
  * AWS Site-to-Site VPN
  * AWS Network Firewall
  * Amazon GuardDuty
  * AWS Security Hub
  * AWS Step Functions
  * AWS Lambda
  * Amazon DynamoDB
  * Amazon S3
  * Amazon CloudWatch

* Completed the final AWS CloudSOC architecture diagram.

* Organized the architecture diagram into clear functional layers:

  * Edge and network protection
  * Security monitoring and detection
  * Security event routing
  * Incident response orchestration
  * Automated containment and investigation
  * Evidence and incident storage
  * Notification and monitoring

* Added numbered event flows and explanatory notes to make the architecture easier to understand.

* Recorded the test cases, expected results, actual results, identified problems, and corrective actions.

* Prepared the AWS CloudSOC system for the final report, presentation, demonstration, cost review, and submission in Week 12.

* Completed Week 11 with practical knowledge of end-to-end security workflow testing, AWS Well-Architected assessment, error handling, architecture validation, and project documentation.