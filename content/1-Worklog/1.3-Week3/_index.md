---
title: "Week 3 Worklog"
date: 2026-05-18
weight: 3
chapter: false
pre: " <b> 1.3. </b> "
---

### Implementation Period

* **Week 3:** From **2026-05-18** to **2026-05-24**.

### Week 3 Objectives

* Understand the basic concepts of Amazon VPC.
* Learn about CIDR blocks, subnets, route tables, Internet Gateways, and NAT Gateways.
* Understand the differences between public and private subnets.
* Practice creating a custom VPC.
* Deploy EC2 instances in public and private subnets.
* Configure security groups and network routing.
* Test connectivity between AWS resources.

### Tasks to Be Carried Out This Week

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| Monday | - Review Amazon EC2 knowledge from Week 2 <br> - Learn the basic concepts of Amazon VPC <br> - Understand VPC CIDR blocks, IP address ranges, and network isolation | 2026-05-18 | 2026-05-18 | <https://cloudjourney.awsstudygroup.com/> |
| Tuesday | - Learn about public and private subnets <br> - Understand subnet CIDR blocks and Availability Zones <br> - Learn how resources communicate inside a VPC | 2026-05-19 | 2026-05-19 | <https://cloudjourney.awsstudygroup.com/> |
| Wednesday | - Create a custom Amazon VPC <br> - Create one public subnet and one private subnet <br> - Select suitable CIDR blocks <br> - Review subnet configuration and resource placement | 2026-05-20 | 2026-05-20 | <https://docs.aws.amazon.com/vpc/latest/userguide/create-vpc.html> |
| Thursday | - Create and attach an Internet Gateway to the VPC <br> - Create route tables <br> - Configure a default route for the public subnet <br> - Associate route tables with the correct subnets | 2026-05-21 | 2026-05-21 | <https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html> |
| Friday | - Learn about NAT Gateway and private subnet Internet access <br> - Create a NAT Gateway if required <br> - Configure the private route table <br> - Review the cost of NAT Gateway usage | 2026-05-22 | 2026-05-22 | <https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html> |
| Saturday | - Launch one EC2 instance in the public subnet <br> - Launch one EC2 instance in the private subnet <br> - Configure security groups <br> - Connect to the public EC2 instance using SSH <br> - Test private connectivity between the two instances | 2026-05-23 | 2026-05-23 | <https://cloudjourney.awsstudygroup.com/> |
| Sunday | - Learn about Network ACLs and compare them with security groups <br> - Check routes, IP addresses, and instance connectivity <br> - Troubleshoot common VPC configuration errors <br> - Delete unnecessary resources and complete the Week 3 worklog | 2026-05-24 | 2026-05-24 | <https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html> |

### Week 3 Achievements

* Understood the purpose of Amazon VPC as an isolated virtual network environment on AWS.

* Learned the main Amazon VPC components, including:

  * VPC CIDR Block
  * Public Subnet
  * Private Subnet
  * Route Table
  * Internet Gateway
  * NAT Gateway
  * Security Group
  * Network ACL

* Understood how CIDR blocks are used to define IP address ranges.

* Learned the difference between public and private subnets.

* Created a custom Amazon VPC.

* Created and configured public and private subnets.

* Attached an Internet Gateway to the VPC.

* Created route tables and associated them with the correct subnets.

* Configured Internet access for the public subnet.

* Learned how a NAT Gateway can provide outbound Internet access for resources in a private subnet.

* Launched EC2 instances in public and private subnets.

* Connected to the public EC2 instance using SSH.

* Tested private communication between EC2 instances.

* Understood the differences between security groups and Network ACLs.

* Practiced troubleshooting common networking issues related to routes, IP addresses, security groups, and subnet configuration.

* Completed Week 3 with fundamental knowledge of Amazon VPC, subnet design, routing, Internet connectivity, and network security.