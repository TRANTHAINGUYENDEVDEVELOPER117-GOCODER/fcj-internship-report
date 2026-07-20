---
title : "Threat Detection Services"
date : 2026-07-01
weight : 3
chapter : false
pre : " <b> 5.4.3. </b> "
---

#### Threat Detection Services

In this section, you will enable and configure the **Threat Detection Services** layer for the AWS CloudSOC system. This layer is responsible for detecting suspicious activities, centralizing security findings, and supporting the SOC Analyst during incident investigation.

The main services used in this section are:

+ Amazon GuardDuty
+ AWS Security Hub
+ Amazon Detective
+ AWS Config

In the CloudSOC architecture, Amazon GuardDuty acts as the primary threat detection service. When GuardDuty detects suspicious activity, it generates a security finding. This finding can then be sent to Security Hub, Detective, and EventBridge for analysis and automated response.

---

#### Objectives

After completing this section, you will have:

+ Amazon GuardDuty enabled in the `ap-southeast-1` Region.
+ AWS Security Hub enabled to centralize security findings.
+ Amazon Detective enabled to support investigation.
+ AWS Config enabled to track resource configuration changes.
+ GuardDuty findings ready to be sent to EventBridge in the next section.
+ The SOC Analyst able to review findings in GuardDuty, Security Hub, and Detective.

---

#### Threat Detection Services Architecture

The following diagram illustrates the Threat Detection Services layer in the AWS CloudSOC system.

![Threat Detection Services Architecture](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.3-threat-detection-services/threat-detection-architecture.png)

The main threat detection flow is:

```text
AWS Telemetry
→ Amazon GuardDuty
→ AWS Security Hub
→ Amazon Detective
→ Amazon EventBridge
→ Step Functions Response Workflow
```

Amazon GuardDuty analyzes AWS-managed telemetry sources such as CloudTrail management events, VPC Flow Logs, and DNS logs. When suspicious behavior is detected, GuardDuty creates a security finding. This finding will be used in later sections to trigger EventBridge and Step Functions.

---

#### Recommended Configuration

You can use the following configuration values for this workshop:

| Component | Recommended Value |
|---|---|
| Region | `ap-southeast-1` |
| GuardDuty | Enabled |
| Security Hub | Enabled |
| Detective | Enabled |
| AWS Config | Enabled |
| Config Recorder | Record all supported resources |
| Config Delivery Channel | S3 bucket or default bucket |
| Main Finding Source | Amazon GuardDuty |
| Finding Target | EventBridge Rule |

---

#### Step 1: Enable Amazon GuardDuty

Open the **Amazon GuardDuty** service in the AWS Management Console.

Choose:

```text
GuardDuty → Get started
```

Then choose:

```text
Enable GuardDuty
```

GuardDuty will begin analyzing security data sources in the AWS account to detect suspicious activity.

Expected result:

```text
Amazon GuardDuty is enabled successfully in the ap-southeast-1 Region.
```

![Enable GuardDuty](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.3-threat-detection-services/enable-guardduty.png)

---

#### Step 2: Check GuardDuty Status

After enabling GuardDuty, check the GuardDuty dashboard.

Go to:

```text
GuardDuty → Summary
```

Or:

```text
GuardDuty → Findings
```

At the beginning, there may be no real findings. This is normal because GuardDuty needs activity data to analyze.

Expected result:

```text
GuardDuty is active.
The GuardDuty Findings page is accessible.
```

![GuardDuty Dashboard](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.3-threat-detection-services/guardduty-dashboard.png)

---

#### Step 3: Generate GuardDuty Sample Findings

To test the interface and prepare sample data for the EventBridge section, you can generate sample findings in GuardDuty.

Go to:

```text
GuardDuty → Settings
```

Find the section:

```text
Sample findings
```

Choose:

```text
Generate sample findings
```

After generating sample findings, return to:

```text
GuardDuty → Findings
```

Expected result:

```text
Sample findings appear in the GuardDuty Findings page.
```

![GuardDuty Sample Findings](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.3-threat-detection-services/guardduty-sample-findings.png)

> **Note:** Sample findings are used to test the interface and event flow. In the Testing and Validation section, the workflow will be tested with more specific findings.

---

#### Step 4: Enable AWS Security Hub

AWS Security Hub is used to centralize security findings from multiple AWS services. In this workshop, Security Hub receives findings from GuardDuty and displays them in a centralized view.

Open the **AWS Security Hub** service.

Choose:

```text
Security Hub → Go to Security Hub
```

If this is the first time using Security Hub, choose:

```text
Enable Security Hub
```

For this lab environment, you can keep the default configuration.

Expected result:

```text
AWS Security Hub is enabled successfully.
```

![Enable Security Hub](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.3-threat-detection-services/enable-security-hub.png)

---

#### Step 5: Check Findings in Security Hub

After enabling Security Hub, go to:

```text
Security Hub → Findings
```

If GuardDuty has generated sample findings or real findings, they may appear in Security Hub after a short period.

Expected result:

```text
Security Hub can display findings from GuardDuty.
```

![Security Hub Findings](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.3-threat-detection-services/security-hub-findings.png)

Security Hub helps the SOC Analyst:

+ View security findings in a centralized place.
+ Filter findings by severity.
+ Check finding status.
+ Monitor compliance and security posture.
+ Combine findings from multiple AWS security services.

---

#### Step 6: Enable Amazon Detective

Amazon Detective helps the SOC Analyst investigate suspicious activities in more detail. Detective supports the analysis of relationships between resources, API calls, network activity, and findings.

Open the **Amazon Detective** service.

Choose:

```text
Detective → Get started
```

Then choose:

```text
Enable Detective
```

Expected result:

```text
Amazon Detective is enabled successfully.
```

![Enable Detective](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.3-threat-detection-services/enable-detective.png)

---

#### Step 7: Check Detective Investigation

After enabling Detective, it may take some time for data to be collected and displayed.

Go to:

```text
Detective → Search
```

Or:

```text
Detective → Investigations
```

The SOC Analyst can use Detective to investigate entities such as:

+ AWS Account
+ IAM Role
+ EC2 Instance
+ IP address
+ GuardDuty finding

Expected result:

```text
Detective is ready to support security finding investigation.
```

![Detective Investigation](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.3-threat-detection-services/detective-investigation.png)

---

#### Step 8: Enable AWS Config

AWS Config is used to track configuration changes of AWS resources. In CloudSOC, AWS Config helps record changes to EC2 instances, security groups, and related resources.

Open the **AWS Config** service.

Choose:

```text
AWS Config → Get started
```

Basic configuration:

| Field | Value |
|---|---|
| Resource types to record | Record all supported resources |
| AWS Config role | Create AWS Config service-linked role |
| Delivery method | Amazon S3 bucket |
| S3 bucket | Create a new bucket or choose an existing bucket |
| Frequency | Continuous recording |

Then choose:

```text
Confirm
```

Expected result:

```text
AWS Config is enabled and starts recording resource configuration changes.
```

![Enable AWS Config](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.3-threat-detection-services/enable-aws-config.png)

---

#### Step 9: Check Resource Inventory in AWS Config

After enabling AWS Config, go to:

```text
AWS Config → Resources
```

Search for CloudSOC-related resources, such as:

+ EC2 instance `cloudsoc-workload-ec2`
+ Security Group `SG-Workload`
+ Security Group `SG-Isolation`
+ VPC `cloudsoc-vpc`

Expected result:

```text
AWS Config records the main resources of the CloudSOC Lab.
```

![AWS Config Resources](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.3-threat-detection-services/aws-config-resources.png)

AWS Config will be useful later when Lambda changes the EC2 security group from:

```text
SG-Workload → SG-Isolation
```

This change can be recorded as a configuration change.

---

#### Step 10: Prepare GuardDuty Findings for EventBridge

GuardDuty findings can be sent to Amazon EventBridge as events. In the next section, you will create an EventBridge rule to capture GuardDuty findings and trigger the Step Functions workflow.

In this section, you only need to make sure that GuardDuty is enabled and can generate findings.

Preparation flow for the next section:

```text
GuardDuty Finding
→ EventBridge Rule
→ Step Functions
→ Incident Response Workflow
```

Expected result:

```text
GuardDuty is ready to act as an event source for EventBridge.
```

---

#### Completion Checklist

After completing this section, verify the following items:

- [ ] Amazon GuardDuty is enabled.
- [ ] The GuardDuty Findings page is accessible.
- [ ] GuardDuty sample findings are generated if required.
- [ ] AWS Security Hub is enabled.
- [ ] Security Hub can receive findings from GuardDuty.
- [ ] Amazon Detective is enabled.
- [ ] Detective is ready to support finding investigation.
- [ ] AWS Config is enabled.
- [ ] AWS Config can record EC2 and Security Group resources.
- [ ] GuardDuty findings are ready to be used with EventBridge.

---

#### Completion Result

After completing this section, the AWS CloudSOC system has a threat detection and investigation layer.

The following components are now ready:

```text
Amazon GuardDuty
AWS Security Hub
Amazon Detective
AWS Config
```

When suspicious activity occurs, GuardDuty creates a security finding. The finding can be centralized in Security Hub, investigated in Detective, and used by EventBridge to trigger the incident response workflow.

---

#### Summary

In this section, you enabled the threat detection and investigation services for AWS CloudSOC. GuardDuty acts as the primary detection service, Security Hub centralizes findings, Detective supports deeper investigation, and AWS Config tracks resource configuration changes.

In the next section, you will configure the **EventBridge and Step Functions Workflow** to automatically process GuardDuty findings and start the incident response process.