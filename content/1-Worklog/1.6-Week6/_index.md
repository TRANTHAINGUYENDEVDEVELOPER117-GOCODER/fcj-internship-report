---
title: "Week 6 Worklog"
date: 2026-06-13
weight: 6
chapter: false
pre: " <b> 1.6. </b> "
---

### Week 6 Overview (13/06 – 19/06/2026)

In week six, I finished **Lab 20 – Step 06: Add Transit Gateway Routes to VPC Route Tables** ([video guide](https://youtu.be/QSXgL2KodQI?si=M1erQf5i0Zrk0PQJ)), then moved to **Optimize – Operate** on [Cloud Journey](https://cloudjourney.awsstudygroup.com/3-optimize/). This week focused on **serverless automation**, **system monitoring**, and **tag-based resource management**.

### Week 6 Objectives

* Complete **Lab 22 – Lambda auto-stop EC2** with Slack notifications.
* Deploy **Lab 29 – CloudWatch + Grafana** monitoring.
* Practice **Lab 27 – Tags & Resource Groups** and **Lab 28 – Tag through IAM**.

### Tasks Completed

| Step | Task | Status | Link |
| --- | --- | --- | --- |
| 20-06 | Add Transit Gateway routes to VPC route tables | ✅ | [Lab 20-06 Video](https://youtu.be/QSXgL2KodQI?si=M1erQf5i0Zrk0PQJ) |
| 22 | Lambda auto-stop EC2 + EventBridge schedule | ✅ | [Lab 22](https://000022.awsstudygroup.com/) |
| 22 | Slack Incoming Webhook notifications | ✅ | [Slack Webhook](https://000022.awsstudygroup.com/2-prerequiste/2.4-incomingwebhooksslack/) |
| 29 | Grafana on EC2 with CloudWatch data source | ✅ | [Lab 29](https://000029.awsstudygroup.com/) |
| 27 | EC2 tags and tag-based Resource Groups | ✅ | [Lab 27](https://000027.awsstudygroup.com/) |
| 28 | IAM policies with `aws:RequestTag` conditions | ✅ | [Lab 28](https://000028.awsstudygroup.com/) |
| — | Cleanup lab resources | ✅ | [Cleanup](https://000022.awsstudygroup.com/7-cleanup/) |

### What I Did

**Lab 20 – Step 06:** Added TGW routes to each VPC route table; verified cross-VPC ping via Transit Gateway using the [Lab 20-06 video](https://youtu.be/QSXgL2KodQI?si=M1erQf5i0Zrk0PQJ).

**Lab 22:** Built Lambda function to stop EC2 instances by tag, triggered by EventBridge schedule, with Slack webhook notifications.

**Lab 29:** Installed Grafana, connected CloudWatch data source, created EC2 monitoring dashboards.

**Lab 27:** Tagged EC2 instances and created Resource Groups filtered by `Team=Alpha`.

**Lab 28:** Created IAM policies with tag-based conditions for ABAC — users can only manage EC2 with correct tags.

### Achievements

* Completed Lab 20 step 06 and all week 6 labs (22, 27, 28, 29).
* Automated EC2 shutdown with Lambda + EventBridge.
* Built Grafana dashboards on top of CloudWatch metrics.
* Implemented tag-based access control with IAM conditions.

### Challenges

* Lambda missing `ec2:StopInstances` permission on execution role.
* Slack webhook misconfiguration — wrong URL or channel.
* Grafana CloudWatch connection failed — IAM user lacked `cloudwatch:GetMetricData`.
* IAM condition confusion between `aws:RequestTag` and `ec2:ResourceTag`.

### Next Week

* Start Security track: IAM Permission Boundary, IAM Conditions, Security Hub, WAF.
