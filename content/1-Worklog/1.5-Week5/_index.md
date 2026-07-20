---
title: "Week 5 Worklog"
date: 2026-06-01
weight: 5
chapter: false
pre: " <b> 1.5. </b> "
---

### Implementation Period

* **Week 5:** From **2026-06-01** to **2026-06-07**.

### Week 5 Objectives

* Understand the basic concepts of AWS monitoring and logging.
* Learn how Amazon CloudWatch monitors AWS resources.
* Understand CloudWatch Metrics, Logs, Alarms, and Dashboards.
* Practice monitoring Amazon EC2 instances.
* Learn how VPC Flow Logs record network traffic information.
* Create alarms and dashboards for resource monitoring.
* Review AWS resource usage and cost information.

### Tasks to Be Carried Out This Week

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| Monday | - Review the networking and VPN knowledge from Week 4 <br> - Learn the basic concepts of monitoring and logging <br> - Understand the role of Amazon CloudWatch in AWS operations | 2026-06-01 | 2026-06-01 | <https://cloudjourney.awsstudygroup.com/> |
| Tuesday | - Learn about CloudWatch Metrics <br> - Review EC2 metrics such as CPU Utilization, Network In, Network Out, and Status Checks <br> - Understand metric namespace, dimension, period, and statistic | 2026-06-02 | 2026-06-02 | <https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/working_with_metrics.html> |
| Wednesday | - Monitor an EC2 instance using Amazon CloudWatch <br> - View resource performance metrics <br> - Compare metric values over different periods <br> - Identify unusual resource usage | 2026-06-03 | 2026-06-03 | <https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-cloudwatch.html> |
| Thursday | - Create a CloudWatch Alarm for an EC2 metric <br> - Configure the threshold, evaluation period, and alarm conditions <br> - Learn the alarm states: OK, ALARM, and INSUFFICIENT_DATA <br> - Review notification options using Amazon SNS | 2026-06-04 | 2026-06-04 | <https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html> |
| Friday | - Learn about VPC Flow Logs <br> - Create a Flow Log for a VPC, subnet, or network interface <br> - Send Flow Log records to CloudWatch Logs <br> - Review ACCEPT and REJECT network traffic records | 2026-06-05 | 2026-06-05 | <https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html> |
| Saturday | - Create a CloudWatch Log Group and review log events <br> - Create a metric filter for rejected traffic when required <br> - Build a simple CloudWatch Dashboard <br> - Add EC2 metrics and alarm information to the dashboard | 2026-06-06 | 2026-06-06 | <https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Dashboards.html> |
| Sunday | - Review AWS Billing, Free Tier usage, and active resources <br> - Check the possible costs of CloudWatch Logs, NAT Gateway, VPN, and EC2 <br> - Delete unnecessary test resources <br> - Complete the Week 5 worklog | 2026-06-07 | 2026-06-07 | <https://aws.amazon.com/cloudwatch/pricing/> |

### Week 5 Achievements

* Understood the importance of monitoring and logging in AWS environments.

* Learned the main Amazon CloudWatch components, including:

  * Metrics
  * Logs
  * Alarms
  * Dashboards
  * Log Groups
  * Metric Filters

* Viewed and analyzed basic Amazon EC2 metrics, including:

  * CPU Utilization
  * Network In
  * Network Out
  * Status Checks

* Understood how CloudWatch Metrics are organized by namespace, dimension, period, and statistic.

* Created a CloudWatch Alarm to monitor an EC2 resource.

* Understood the main CloudWatch Alarm states:

  * OK
  * ALARM
  * INSUFFICIENT_DATA

* Learned how Amazon SNS can be used to send alarm notifications.

* Understood the purpose of VPC Flow Logs in recording network traffic information.

* Created a VPC Flow Log and sent records to CloudWatch Logs.

* Reviewed ACCEPT and REJECT records to identify allowed and denied network traffic.

* Learned how metric filters can be used to detect specific patterns in log data.

* Created a basic CloudWatch Dashboard to display important EC2 metrics and alarm information.

* Reviewed AWS Billing and Free Tier usage to identify resources that could generate costs.

* Deleted unnecessary test resources after completing the monitoring exercises.

* Completed Week 5 with fundamental knowledge of Amazon CloudWatch, VPC Flow Logs, alarms, dashboards, logging, and AWS cost monitoring.