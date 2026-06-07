---
title: "Week 2 Worklog"
date: 2026-05-16
weight: 2
chapter: false
pre: " <b> 1.2. </b> "
---

### Week 2 Overview (05/16 – 05/22/2026)

Week 2 focused on practicing core AWS services in **Module 01 – AWS Foundation**: networking (VPC), compute (EC2), storage (S3), databases (RDS), and supporting services (CloudWatch, Route 53, CLI). This was the highest-volume lab week in the foundation phase, building an end-to-end basic AWS architecture.

### Week 2 Objectives

* Design and deploy VPC architecture with public/private subnets.
* Operate EC2, S3, RDS and connect services together.
* Learn AWS CLI, CloudWatch, Route 53, and Auto Scaling.

### Work Completed

| Day | Detailed Tasks | Start Date | Completion Date | Reference |
| --- | --- | --- | --- | --- |
| 2 (05/16) | **Lab 05 – VPC:** Created VPC, public/private subnets, IGW, Route Table, Security Group | 05/16/2026 | 05/16/2026 | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 3 (05/17) | **Lab 06–07 – EC2:** Launched Amazon Linux; SSH via key pair; attached EBS; assigned Elastic IP | 05/17/2026 | 05/17/2026 | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 4 (05/18) | **Lab 08 – IAM Roles for EC2** + **Lab 09 – Cloud9** | 05/18/2026 | 05/18/2026 | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 5 (05/19) | **Lab 10 – S3:** Static website hosting + **Lab 11 – RDS:** MySQL instance, connect from EC2 | 05/19/2026 | 05/19/2026 | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 6 (05/20) | **Lab 12 – Lightsail** + **Lab 13 – Auto Scaling** + **Lab 14 – CloudWatch** | 05/20/2026 | 05/20/2026 | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 7 (05/21) | **Lab 15 – Route 53** + **Lab 16 – AWS CLI** + **Lab 17–18 – DynamoDB & ElastiCache** | 05/21/2026 | 05/22/2026 | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |

### Service Group Details

#### Networking – Amazon VPC (Lab 05)
* VPC with CIDR `10.0.0.0/16`, public and private subnets across 2 AZs.
* Internet Gateway for public subnet; Route Table with `0.0.0.0/0` to Internet.
* Stateful Security Groups for SSH (22) and HTTP (80).

#### Compute – Amazon EC2 (Lab 06–07)
* Amazon Linux 2023 AMI, `t3.micro` instance type.
* SSH via key pair; created and mounted additional EBS volume.
* Assigned Elastic IP for persistent public address.

#### Storage & Database (Lab 10–11)
* S3 bucket with static website hosting.
* RDS MySQL in private subnet; Security Group allowing EC2 on port 3306.

#### Operations (Lab 13–16)
* Auto Scaling with Launch Template, ASG, and ALB.
* CloudWatch CPU alarm and monitoring dashboard.
* Route 53 hosted zone with A record.
* AWS CLI: `aws configure`, `aws sts get-caller-identity`, `aws ec2 describe-instances`.

### Achievements

* Completed **14 labs** (Lab 05 – Lab 18) in Module 01.
* Deployed basic 3-tier architecture: **VPC → EC2 → S3/RDS**.
* Used **IAM Roles** instead of hardcoded credentials on EC2.
* Operated **Console** and **CLI** in parallel.
* Set up monitoring with **CloudWatch** and DNS with **Route 53**.

### Challenges & Solutions

* **SSH permission error on Windows:** Fixed .pem file permissions with `icacls`.
* **RDS connection failed:** Security Group missing port 3306 from EC2 SG → updated inbound rule.
* **NAT Gateway costs:** Deleted NAT Gateway and Elastic IP after labs to avoid billing.
