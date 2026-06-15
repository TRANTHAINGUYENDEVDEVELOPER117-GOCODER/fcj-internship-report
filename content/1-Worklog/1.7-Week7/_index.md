---
title: "Week 7 Worklog"
date: 2026-06-20
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
---

### Week 7 Overview (20/06 – 26/06/2026)

In week seven, I moved to the **Security** section of [Cloud Journey – Optimize](https://cloudjourney.awsstudygroup.com/3-optimize/) — aligned with my **Cybersecurity** major at HUTECH. I practiced **IAM Permission Boundary**, **IAM Conditions for role assumption**, **AWS Security Hub**, and **AWS WAF**.

### Week 7 Objectives — Security Track

* Deploy **Lab 30 – IAM Permission Boundary** to cap maximum permissions.
* Configure **Lab 44 – IAM Role & Condition** (IP and time restrictions).
* Enable **Lab 18 – AWS Security Hub** and review compliance findings.
* Protect web apps with **Lab 26 – AWS WAF** (OWASP Juice Shop).

### Tasks Completed

| Step | Task | Status | Link |
| --- | --- | --- | --- |
| 30 | Create `ec2-admin-restrict-region` boundary policy | ✅ | [Lab 30](https://000030.awsstudygroup.com/) |
| 30 | Verify effective permissions = boundary ∩ identity policy | ✅ | [Create Policy](https://000030.awsstudygroup.com/3-createpolicy/) |
| 44 | Restrict assume role by source IP | ✅ | [Lab 44](https://000044.awsstudygroup.com/) |
| 44 | Restrict assume role by time window | ✅ | [IAM Condition](https://000044.awsstudygroup.com/4-configure-iam-role-with-condition/3-condition/) |
| 18 | Enable Security Hub, review CIS/benchmark findings | ✅ | [Lab 18](https://000018.awsstudygroup.com/) |
| 26 | Deploy OWASP Juice Shop via CloudFormation | ✅ | [Lab 26](https://000026.awsstudygroup.com/2-prepare/2.2-deploythesamplewebapp/) |
| 26 | Web ACL + AWS Managed Rules (Core, SQLi) | ✅ | [Web ACL](https://000026.awsstudygroup.com/3-useawswaf/3.1-createswebacl/) |
| 26 | Test Count action, cleanup resources | ✅ | [Test WAF](https://000026.awsstudygroup.com/3-useawswaf/3.4-testingnewrule/) |

### What I Did

**Lab 30:** Created region-restricted EC2 boundary policy; attached as permissions boundary. Even with `AdministratorAccess`, effective permissions stay within the boundary.

**Lab 44:** Built separate EC2/RDS admin roles; added trust policy conditions for `aws:SourceIp` and time-based access.

**Lab 18:** Enabled Security Hub with AWS Foundational and CIS standards; reviewed aggregated security findings by severity.

**Lab 26:** Deployed Juice Shop, created Web ACL with managed rule groups, tested XSS/SQLi blocking via curl, used Count action before Block, then cleaned up all resources.

### Achievements

* Completed four security lab groups: Permission Boundary, IAM Condition, Security Hub, WAF.
* Understood defense in depth: IAM → Security Hub → WAF.
* Practiced least privilege and permission boundaries.
* Learned WAF rule testing workflow (Count → Block).

### Challenges

* Confused boundary as granting vs limiting permissions.
* Assume role denied due to wrong `aws:SourceIp` or dynamic IP changes.
* Security Hub findings took time to appear after enable.
* WAF false positives — used Count action and CloudWatch metrics first.

### Next Week

* Continue Cloud Journey — Reliability or Performance track per FCJ schedule.
