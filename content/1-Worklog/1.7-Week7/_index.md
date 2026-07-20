---
title: "Week 7 Worklog"
date: 2026-06-15
weight: 7
chapter: false
pre: " <b> 1.7. </b> "
---

### Implementation Period

* **Week 7:** From **2026-06-15** to **2026-06-21**.

### Week 7 Objectives

* Understand the concept of layered security in AWS.
* Learn how AWS WAF protects web applications from common web attacks.
* Understand Web ACLs, rules, managed rule groups, and request filtering actions.
* Learn the basic role of Elastic Load Balancing in distributing application traffic.
* Understand how AWS Network Firewall protects traffic inside a VPC.
* Learn the difference between AWS WAF, Security Groups, Network ACLs, and AWS Network Firewall.
* Explore Amazon Inspector for vulnerability and exposure management.
* Review security findings and identify how they can support the final AWS CloudSOC project.

### Tasks to Be Carried Out This Week

| Day | Task | Start Date | Completion Date | Reference Material |
| --- | --- | --- | --- | --- |
| Monday | - Review the security monitoring knowledge from Week 6 <br> - Learn the concept of defense in depth <br> - Identify the protection layers in an AWS architecture <br> - Compare preventive, detective, and responsive security controls | 2026-06-15 | 2026-06-15 | <https://docs.aws.amazon.com/whitepapers/latest/aws-security-incident-response-guide/welcome.html> |
| Tuesday | - Learn about AWS WAF <br> - Understand Web ACLs, rules, rule groups, and rule priorities <br> - Learn the difference between Allow, Block, Count, CAPTCHA, and Challenge actions <br> - Review the AWS resources that can be protected by AWS WAF | 2026-06-16 | 2026-06-16 | <https://docs.aws.amazon.com/waf/latest/developerguide/what-is-aws-waf.html> |
| Wednesday | - Create an AWS WAF Web ACL <br> - Add AWS Managed Rules to the Web ACL <br> - Configure rule priority and default action <br> - Review sampled web requests and rule metrics <br> - Test request filtering when possible | 2026-06-17 | 2026-06-17 | <https://docs.aws.amazon.com/waf/latest/developerguide/web-acl-creating.html> |
| Thursday | - Learn about Elastic Load Balancing and Application Load Balancer <br> - Understand listeners, target groups, health checks, and traffic distribution <br> - Review how AWS WAF can be associated with an Application Load Balancer <br> - Examine the role of load balancing in improving availability | 2026-06-18 | 2026-06-18 | <https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html> |
| Friday | - Learn about AWS Network Firewall <br> - Understand firewall policies, stateless rule groups, and stateful rule groups <br> - Review the required VPC subnet and routing design <br> - Compare AWS Network Firewall with Security Groups and Network ACLs | 2026-06-19 | 2026-06-19 | <https://docs.aws.amazon.com/network-firewall/latest/developerguide/what-is-aws-network-firewall.html> |
| Saturday | - Learn about Amazon Inspector <br> - Enable Amazon Inspector for supported resources when appropriate <br> - Review EC2, ECR container image, and Lambda findings <br> - Examine severity, vulnerability details, affected resources, and remediation recommendations | 2026-06-20 | 2026-06-20 | <https://docs.aws.amazon.com/inspector/latest/user/what-is-inspector.html> |
| Sunday | - Compare AWS WAF, AWS Network Firewall, Security Groups, and Network ACLs <br> - Review WAF logs, firewall logs, and Inspector findings <br> - Identify which security findings can be integrated into the AWS CloudSOC workflow <br> - Review service costs, remove unnecessary resources, and complete the Week 7 worklog | 2026-06-21 | 2026-06-21 | <https://aws.amazon.com/security/> |

### Week 7 Achievements

* Understood the concept of defense in depth and the importance of using multiple security layers in an AWS architecture.

* Identified three main types of security controls:

  * Preventive controls
  * Detective controls
  * Responsive controls

* Understood the role of AWS WAF in protecting web applications from common attacks and unwanted requests.

* Learned the main components of AWS WAF, including:

  * Web ACL
  * Rule
  * Rule Group
  * Managed Rule Group
  * Rule Priority
  * Default Action

* Reviewed the main AWS WAF request actions:

  * Allow
  * Block
  * Count
  * CAPTCHA
  * Challenge

* Created a Web ACL and added AWS Managed Rules.

* Learned how rule priority affects the order in which AWS WAF evaluates incoming requests.

* Reviewed sampled requests and metrics to understand how WAF rules process web traffic.

* Understood the basic role of an Application Load Balancer in distributing traffic across multiple targets.

* Learned the main Application Load Balancer components, including:

  * Listener
  * Listener Rule
  * Target Group
  * Health Check
  * Registered Target

* Understood how AWS WAF can be associated with an Application Load Balancer to protect web applications.

* Learned the basic architecture and purpose of AWS Network Firewall.

* Reviewed the main AWS Network Firewall components, including:

  * Firewall
  * Firewall Policy
  * Stateless Rule Group
  * Stateful Rule Group
  * Firewall Endpoint
  * Logging Configuration

* Understood that AWS Network Firewall requires appropriate subnet placement and route table configuration to inspect VPC traffic.

* Compared the roles of AWS security controls:

  * AWS WAF protects the web application layer.
  * AWS Network Firewall inspects network traffic inside a VPC.
  * Security Groups control traffic at the resource or network interface level.
  * Network ACLs control traffic at the subnet level.

* Understood the role of Amazon Inspector in continuously identifying software vulnerabilities and unintended network exposure.

* Reviewed Amazon Inspector findings and examined information such as:

  * Finding severity
  * Vulnerability identifier
  * Affected resource
  * Package information
  * Network exposure
  * Recommended remediation

* Identified AWS WAF logs, Network Firewall logs, and Amazon Inspector findings as useful security data sources for the final AWS CloudSOC project.

* Reviewed service pricing and removed unnecessary resources to reduce unexpected AWS costs.

* Completed Week 7 with fundamental knowledge of AWS WAF, Elastic Load Balancing, AWS Network Firewall, Amazon Inspector, and layered cloud security.