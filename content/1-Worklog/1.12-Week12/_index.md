---
title: "Week 12 Worklog"
date: 2026-07-20
weight: 12
chapter: false
pre: " <b> 1.12. </b> "
---

### Implementation Period

* **Week 12:** From **2026-07-20** to **2026-07-30**.

### Week 12 Objectives

* Complete the final AWS CloudSOC internship report.
* Document the project requirements, architecture, implementation, testing, and results.
* Finalize the AWS CloudSOC architecture diagram and security event flow.
* Prepare screenshots, test evidence, and technical explanations.
* Review the project according to AWS security and architecture best practices.
* Prepare the final presentation slides and demonstration scenario.
* Review AWS resource usage and estimated operating costs.
* Back up project documents, source code, configurations, and test results.
* Remove unnecessary AWS resources to prevent unexpected charges.
* Complete the final review and submit all internship deliverables.

### Tasks to Be Carried Out This Week

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| Monday | - Review the internship report requirements and submission guidelines <br> - Organize the report structure and table of contents <br> - Review the project objectives, scope, and implementation progress <br> - Create a checklist of documents and deliverables that must be completed | 2026-07-20 | 2026-07-20 | <https://hcm-rules.awsfcaj.com/3-project/> |
| Tuesday | - Complete the project overview and problem statement <br> - Describe the security risks addressed by the AWS CloudSOC system <br> - Document the functional and non-functional requirements <br> - Explain the selected AWS services and their roles | 2026-07-21 | 2026-07-21 | <https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html> |
| Wednesday | - Finalize the AWS CloudSOC architecture diagram <br> - Verify AWS service icons, service groups, trust boundaries, and network boundaries <br> - Add numbered event flows and explanatory notes <br> - Ensure that all connections represent valid AWS service interactions | 2026-07-22 | 2026-07-22 | <https://aws.amazon.com/architecture/icons/> |
| Thursday | - Document the main security detection flow <br> - Explain how CloudTrail, GuardDuty, Security Hub, and Inspector provide security information <br> - Describe how EventBridge receives and routes findings <br> - Explain the role of CloudWatch in monitoring and troubleshooting | 2026-07-23 | 2026-07-23 | <https://docs.aws.amazon.com/securityhub/latest/userguide/what-is-securityhub.html> |
| Friday | - Document the incident response workflow <br> - Explain the Step Functions finding evaluation logic <br> - Describe the Alert Only, Approval Required, and Automated Response branches <br> - Document the roles of Lambda, Systems Manager, DynamoDB, S3, and SNS | 2026-07-24 | 2026-07-24 | <https://docs.aws.amazon.com/step-functions/latest/dg/welcome.html> |
| Saturday | - Organize test cases and test evidence <br> - Add screenshots of Step Functions executions, Lambda logs, DynamoDB records, S3 evidence, SNS notifications, and Systems Manager results <br> - Record expected results, actual results, identified issues, and corrective actions | 2026-07-25 | 2026-07-25 | <https://docs.aws.amazon.com/step-functions/latest/dg/concepts-view-execution-details.html> |
| Sunday | - Review the architecture according to the AWS Well-Architected Framework <br> - Document security, reliability, operational excellence, performance efficiency, cost optimization, and sustainability considerations <br> - Identify limitations and future improvement opportunities | 2026-07-26 | 2026-07-26 | <https://docs.aws.amazon.com/wellarchitected/latest/framework/the-pillars-of-the-framework.html> |
| Monday | - Prepare the final presentation slides <br> - Create slides for the problem, objectives, architecture, security workflow, implementation, testing, results, costs, and conclusion <br> - Simplify technical content for clear presentation <br> - Add the final architecture diagram and important screenshots | 2026-07-27 | 2026-07-27 | <https://aws.amazon.com/architecture/> |
| Tuesday | - Prepare the final demonstration scenario <br> - Create sample findings for Alert Only, Approval Required, and Automated Response scenarios <br> - Verify the rollback process <br> - Rehearse the presentation and demonstration <br> - Record backup screenshots or a demonstration video when required | 2026-07-28 | 2026-07-28 | <https://docs.aws.amazon.com/guardduty/latest/ug/sample_findings.html> |
| Wednesday | - Review active AWS resources and service costs <br> - Check AWS Billing, Cost Explorer, and AWS Budgets <br> - Export or record important configuration information <br> - Back up project files and test results <br> - Delete or disable unnecessary paid resources | 2026-07-29 | 2026-07-29 | <https://docs.aws.amazon.com/cost-management/latest/userguide/what-is-costmanagement.html> |
| Thursday | - Proofread the final report and worklog <br> - Verify dates, headings, image captions, references, and table of contents <br> - Perform a final review of the website and presentation slides <br> - Submit the report, project website, slides, and required internship documents <br> - Record lessons learned and complete the Week 12 worklog | 2026-07-30 | 2026-07-30 | <https://hcm-rules.awsfcaj.com/3-project/> |

### Week 12 Achievements

* Completed the final AWS CloudSOC internship report.

* Documented the main sections of the project, including:

  * Project background
  * Problem statement
  * Project objectives
  * Scope and requirements
  * Proposed architecture
  * AWS services
  * Implementation process
  * Security event flow
  * Incident response workflow
  * Testing and evaluation
  * Cost analysis
  * Limitations
  * Future improvements
  * Conclusion

* Finalized the AWS CloudSOC architecture diagram.

* Organized the architecture into clear functional layers:

  * Edge and network protection
  * Identity and access management
  * Security monitoring and threat detection
  * Security finding aggregation
  * Event routing
  * Incident response orchestration
  * Automated containment and investigation
  * Incident and evidence storage
  * Notification
  * Logging and operational monitoring

* Verified the roles and relationships of the main AWS services:

  * AWS CloudTrail
  * Amazon GuardDuty
  * AWS Security Hub
  * Amazon Inspector
  * AWS WAF
  * AWS Network Firewall
  * Amazon EventBridge
  * AWS Step Functions
  * AWS Lambda
  * AWS Systems Manager
  * Amazon DynamoDB
  * Amazon S3
  * Amazon SNS
  * Amazon CloudWatch
  * AWS Identity and Access Management

* Completed the documentation of the main security detection flow:

  **AWS Resources and Logs → CloudTrail/GuardDuty/Inspector → Security Hub → EventBridge**

* Completed the documentation of the main incident response flow:

  **Security Finding → EventBridge → Step Functions → Lambda Evaluation → Response Branch → Systems Manager → DynamoDB/S3 → SNS**

* Documented the three main response scenarios:

  * **Alert Only:** Sends notifications without modifying the affected resource.
  * **Approval Required:** Waits for SOC analyst approval before performing containment.
  * **Automated Response:** Automatically isolates a Critical EC2 instance when all response conditions are met.

* Documented the required automated response conditions:

  * Supported resource type
  * Valid EC2 Instance ID
  * Required severity level
  * `AutoIsolate=true` tag
  * Valid response mode
  * Sufficient IAM permissions

* Added test cases for:

  * Low-severity findings
  * Medium-severity findings
  * High-severity findings
  * Critical-severity findings
  * Unsupported resources
  * Missing Instance IDs
  * Missing `AutoIsolate` tags
  * Lambda failures
  * IAM permission failures
  * Systems Manager failures
  * Analyst approval and rejection
  * Automated EC2 isolation
  * EC2 rollback and recovery

* Organized screenshots and evidence from:

  * AWS Step Functions Execution History
  * Amazon CloudWatch Logs
  * AWS Lambda
  * AWS Systems Manager
  * Amazon DynamoDB
  * Amazon S3
  * Amazon SNS
  * Amazon GuardDuty
  * AWS Security Hub

* Recorded the expected result and actual result of each test case.

* Documented identified errors, troubleshooting steps, and corrective actions.

* Reviewed the architecture according to the six AWS Well-Architected pillars:

  * Operational Excellence
  * Security
  * Reliability
  * Performance Efficiency
  * Cost Optimization
  * Sustainability

* Identified project limitations, including:

  * The demonstration was implemented in a limited AWS account and Region.
  * Some paid security services were tested only for a short period.
  * The approval process was simplified for demonstration purposes.
  * The project focused mainly on Amazon EC2 incident response.
  * Multi-account and multi-Region deployment was not fully implemented.

* Proposed future improvements, including:

  * AWS Organizations and multi-account security management
  * Cross-Region incident response
  * AWS Security Hub delegated administration
  * Centralized log storage
  * AWS KMS customer-managed keys
  * Amazon OpenSearch Service for security analytics
  * Amazon Athena for investigation queries
  * Integration with ticketing or chat systems
  * Additional automated response playbooks
  * Infrastructure as Code deployment

* Prepared the final presentation slides.

* Prepared and rehearsed the final project demonstration.

* Created demonstration scenarios for Alert Only, Approval Required, Automated Response, and Rollback.

* Reviewed AWS service usage and estimated project costs.

* Checked AWS Billing, AWS Budgets, and active resources.

* Backed up important project materials, including:

  * Internship report
  * Hugo project website
  * Architecture diagrams
  * Presentation slides
  * Lambda source code
  * Step Functions definitions
  * IAM policies
  * Test events
  * Screenshots
  * Test results

* Deleted or disabled unnecessary AWS resources to reduce the risk of unexpected charges.

* Performed a final review of the report, worklog, website, architecture diagram, slides, and demonstration content.

* Submitted the final internship deliverables.

* Completed the 12-week internship period with practical knowledge of AWS cloud infrastructure, networking, monitoring, security detection, event-driven architecture, automated incident response, testing, cost management, and technical documentation.