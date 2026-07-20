---
title: "Week 6 Worklog"
date: 2026-06-08
weight: 6
chapter: false
pre: " <b> 1.6. </b> "
---

### Implementation Period

* **Week 6:** From **2026-06-08** to **2026-06-14**.

### Week 6 Objectives

* Understand the importance of security logging and threat detection in AWS.
* Learn how AWS CloudTrail records activities performed in an AWS account.
* Configure a CloudTrail trail to store activity logs in Amazon S3.
* Learn how Amazon GuardDuty detects suspicious activities and potential threats.
* Understand GuardDuty finding severity, resource information, and recommended actions.
* Learn how AWS Security Hub centralizes security findings from multiple AWS services.
* Review IAM security practices, including least privilege and Multi-Factor Authentication.
* Build a foundation for the automated incident response workflow used in the final project.

### Tasks to Be Carried Out This Week

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| Monday | - Review the monitoring and logging knowledge from Week 5 <br> - Learn the basic concepts of cloud security monitoring <br> - Review the AWS Shared Responsibility Model <br> - Understand the difference between operational monitoring and security monitoring | 2026-06-08 | 2026-06-08 | <https://aws.amazon.com/compliance/shared-responsibility-model/> |
| Tuesday | - Learn about AWS CloudTrail <br> - Review CloudTrail Event History <br> - Understand management events and data events <br> - Identify information such as user identity, event time, source IP address, service, and API action | 2026-06-09 | 2026-06-09 | <https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html> |
| Wednesday | - Create a CloudTrail trail <br> - Configure the trail to deliver log files to an Amazon S3 bucket <br> - Enable log file validation when required <br> - Perform several AWS Console or CLI operations and verify the recorded events | 2026-06-10 | 2026-06-10 | <https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-create-and-update-a-trail.html> |
| Thursday | - Learn about Amazon GuardDuty <br> - Enable GuardDuty in the selected AWS Region <br> - Understand how GuardDuty analyzes AWS activity and network-related data sources <br> - Review finding categories and severity levels | 2026-06-11 | 2026-06-11 | <https://docs.aws.amazon.com/guardduty/latest/ug/what-is-guardduty.html> |
| Friday | - Generate or review sample GuardDuty findings <br> - Examine the finding type, affected resource, severity, account, Region, and recommended action <br> - Compare Low, Medium, High, and Critical findings <br> - Record important finding fields for the final incident response project | 2026-06-12 | 2026-06-12 | <https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_findings.html> |
| Saturday | - Learn about AWS Security Hub <br> - Enable Security Hub in the selected Region <br> - Review security standards, controls, insights, and findings <br> - Examine how GuardDuty findings are centralized in Security Hub <br> - Review the AWS Security Finding Format | 2026-06-13 | 2026-06-13 | <https://docs.aws.amazon.com/securityhub/latest/userguide/what-is-securityhub.html> |
| Sunday | - Review IAM security practices <br> - Check root account MFA, IAM users, roles, and policies <br> - Review the principle of least privilege <br> - Check the status and possible costs of CloudTrail, GuardDuty, Security Hub, and S3 resources <br> - Complete the Week 6 worklog | 2026-06-14 | 2026-06-14 | <https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html> |

### Week 6 Achievements

* Understood the importance of security visibility, activity logging, and threat detection in an AWS environment.

* Reviewed the AWS Shared Responsibility Model and understood the security responsibilities of AWS and its customers.

* Learned the role of AWS CloudTrail in recording activities performed through:

  * AWS Management Console
  * AWS Command Line Interface
  * AWS SDKs
  * AWS service APIs

* Reviewed CloudTrail Event History and identified important event information, including:

  * Event name
  * Event time
  * AWS service
  * User identity
  * Source IP address
  * AWS Region
  * Resource information

* Understood the difference between management events and data events.

* Created a CloudTrail trail and configured log delivery to an Amazon S3 bucket.

* Verified that AWS account activities were recorded by CloudTrail.

* Understood the role of Amazon GuardDuty in continuously detecting suspicious activities and potential security threats.

* Enabled Amazon GuardDuty in the selected AWS Region.

* Reviewed GuardDuty finding information, including:

  * Finding type
  * Severity
  * Affected resource
  * AWS account
  * AWS Region
  * Recommended response action

* Reviewed sample GuardDuty findings and learned how to interpret their security impact.

* Understood the purpose of AWS Security Hub as a centralized service for security posture management and finding aggregation.

* Enabled AWS Security Hub and reviewed its main components, including:

  * Security standards
  * Security controls
  * Findings
  * Insights
  * Security score

* Examined how GuardDuty findings can be centralized in AWS Security Hub.

* Learned the basic structure of the AWS Security Finding Format.

* Reviewed IAM security best practices, including Multi-Factor Authentication, role-based access, and least-privilege permissions.

* Identified the main security finding fields required for the automated incident response workflow in the final AWS CloudSOC project.

* Completed Week 6 with fundamental knowledge of AWS CloudTrail, Amazon GuardDuty, AWS Security Hub, security findings, and IAM security practices.