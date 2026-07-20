---
title: "Week 4 Worklog"
date: 2026-05-25
weight: 4
chapter: false
pre: " <b> 1.4. </b> "
---

### Implementation Period

* **Week 4:** From **2026-05-25** to **2026-05-31**.

### Week 4 Objectives

* Understand the hybrid network connectivity model between an on-premises environment and AWS.
* Learn how AWS Site-to-Site VPN works.
* Understand the roles of Customer Gateway, Virtual Private Gateway, and VPN Connection.
* Practice creating the components required for a VPN connection.
* Configure route tables to direct network traffic through the VPN.
* Check VPN tunnel status and network connectivity.
* Learn about the security, availability, and cost considerations of AWS Site-to-Site VPN.

### Tasks to Be Carried Out This Week

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| Monday | - Review the Amazon VPC knowledge from Week 3 <br> - Learn about Hybrid Cloud and connectivity between on-premises networks and AWS <br> - Explore common use cases for AWS Site-to-Site VPN | 2026-05-25 | 2026-05-25 | <https://cloudjourney.awsstudygroup.com/> |
| Tuesday | - Learn about AWS Site-to-Site VPN architecture <br> - Understand the roles of Customer Gateway, Virtual Private Gateway, and VPN Connection <br> - Learn about public IP addresses, Autonomous System Numbers, and the Border Gateway Protocol | 2026-05-26 | 2026-05-26 | <https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html> |
| Wednesday | - Create a Virtual Private Gateway <br> - Attach the Virtual Private Gateway to the VPC <br> - Create a Customer Gateway representing the on-premises network device <br> - Review the configuration information of both gateways | 2026-05-27 | 2026-05-27 | <https://docs.aws.amazon.com/vpn/latest/s2svpn/SetUpVPNConnections.html> |
| Thursday | - Create an AWS Site-to-Site VPN Connection <br> - Select static or dynamic routing <br> - Download the VPN configuration file for the Customer Gateway device <br> - Review the configuration details of the two VPN tunnels | 2026-05-28 | 2026-05-28 | <https://docs.aws.amazon.com/vpn/latest/s2svpn/SetUpVPNConnections.html> |
| Friday | - Configure the route table to direct traffic to the on-premises network through the Virtual Private Gateway <br> - Check the VPC and on-premises CIDR blocks to prevent address overlap <br> - Review Security Group and Network ACL rules for traffic passing through the VPN | 2026-05-29 | 2026-05-29 | <https://docs.aws.amazon.com/vpn/latest/s2svpn/VPC_VPN.html> |
| Saturday | - Check the status of both VPN tunnels <br> - Test connectivity between the simulated on-premises network and an EC2 instance in the VPC when possible <br> - Review tunnel information, routes, and related logs <br> - Troubleshoot common configuration issues | 2026-05-30 | 2026-05-30 | <https://docs.aws.amazon.com/vpn/latest/s2svpn/monitoring-cloudwatch-vpn.html> |
| Sunday | - Learn about high availability using two VPN tunnels <br> - Learn how to monitor the VPN connection with Amazon CloudWatch <br> - Review AWS Site-to-Site VPN pricing <br> - Delete unused resources and complete the Week 4 worklog | 2026-05-31 | 2026-05-31 | <https://aws.amazon.com/vpn/pricing/> |

### Week 4 Achievements

* Understood the concept of Hybrid Cloud and the need to connect on-premises systems with AWS.

* Learned the main components of AWS Site-to-Site VPN, including:

  * Customer Gateway
  * Virtual Private Gateway
  * VPN Connection
  * VPN Tunnel
  * Route Table
  * Static Routing
  * Dynamic Routing
  * Border Gateway Protocol

* Understood the role of the Customer Gateway in representing the network device on the on-premises side.

* Understood the role of the Virtual Private Gateway in connecting a VPC to an external network.

* Created and attached a Virtual Private Gateway to an Amazon VPC.

* Created a Customer Gateway using suitable network information.

* Created an AWS Site-to-Site VPN Connection.

* Reviewed the configuration of the two VPN tunnels provided by AWS.

* Configured route tables to direct traffic between the VPC and the on-premises network.

* Understood the importance of avoiding overlapping CIDR blocks.

* Checked the VPN tunnel status and other connection-related information.

* Understood the basic differences between static routing and dynamic routing with BGP.

* Learned the roles of Security Groups and Network ACLs in controlling traffic through the VPN.

* Understood how two VPN tunnels improve connection availability.

* Learned how to monitor AWS Site-to-Site VPN using Amazon CloudWatch.

* Reviewed and deleted unused VPN resources to reduce unnecessary costs.

* Completed Week 4 with fundamental knowledge of hybrid connectivity, AWS Site-to-Site VPN, routing, availability, and VPN monitoring.