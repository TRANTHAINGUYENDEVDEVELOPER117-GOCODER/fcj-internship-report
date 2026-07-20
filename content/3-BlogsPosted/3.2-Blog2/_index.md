---
title: "A Smart and Controlled Incident Response Workflow in AWS CloudSOC"
date: 2026-07-02
weight: 2
chapter: false
pre: " <b> 3.2. </b> "
---

After completing the Proof of Concept for the **AWS CloudSOC** project, one of the most important parts of the system is not only the architecture itself, but also the way incidents are processed in a smart, controlled, and practical manner.

When **Amazon GuardDuty** detects suspicious activities such as **SSH brute-force attempts**, **port scanning**, or access from a suspicious IP address, the system does not immediately perform aggressive actions. Instead, the finding is processed through a carefully designed workflow to ensure both fast response and operational safety.

---

## Incident Response Workflow in AWS CloudSOC

The incident response process works as follows:

1. **Amazon GuardDuty** detects a security finding and generates an alert.
2. The finding event is sent to **Amazon EventBridge**.
3. **Amazon EventBridge** triggers **AWS Step Functions**, which acts as the central orchestration engine of the incident response workflow.
4. **AWS Step Functions** evaluates multiple conditions, including:
   - Finding severity
   - The `AutoIsolate=true` tag
   - Dry-run mode
   - Affected resource type
   - Other response conditions
5. If the incident requires manual approval, the system sends a notification to the **SOC Analyst** through **Slack** and **Email / SMS**.
6. The SOC Analyst accesses the **SOC Dashboard** to review incident details and decides whether to **Approve** or **Reject** the response action.
7. After approval, **AWS Systems Manager** executes forensic collection commands on the EC2 instance, including:
   - Running processes
   - Network connections
   - System logs
   - Routing table
   - User information
8. Next, an **EBS Snapshot** is created to preserve the disk state as forensic evidence.
9. The **Incident Response Lambda** changes the EC2 Security Group from `SG-Workload` to `SG-Isolation` to isolate the suspected instance.
10. Finally, all evidence is stored in **Amazon S3**, the incident status is updated in **Amazon DynamoDB**, and the response result is sent to the SOC Analyst.

---

## Overall Processing Flow

```text
GuardDuty
→ EventBridge
→ Step Functions
→ Approval / Decision
→ Systems Manager Forensics
→ EBS Snapshot
→ Lambda Isolation
→ S3 Evidence Storage
→ DynamoDB Incident Update
→ SNS / Slack / Email Notification
```

---

## Threat Detection and Response Diagram

The following diagram focuses on the **Threat Detection and Response** part of the AWS CloudSOC system:

![Threat Detection and Response Diagram](/images/3-BlogsPosted/3.2-Blog2/threat-detection-response-diagram.png)

This diagram shows how **GuardDuty**, **EventBridge**, **Step Functions**, **Systems Manager**, **Lambda**, **S3**, **DynamoDB**, and **SNS** work together to create a controlled incident response workflow.

---

## What I Learned

Through this part of the implementation, I learned several important lessons:

- **AWS Step Functions** is a powerful service for building complex workflows, especially when the process includes multiple decision branches and human approval.
- **AWS Systems Manager Run Command** is an effective solution for collecting forensic data from EC2 instances without manually logging in through SSH.
- The order of incident response steps is extremely important. Evidence collection and snapshot creation should be completed before isolation actions are performed.
- A good cloud security workflow should balance automation with human control.

---

## Practical Lessons Learned

During the project, our team also gained several practical insights:

- The system should not automatically isolate every alert immediately. Findings must be classified based on severity and context.
- Manual approval is important for cases where the system does not have enough confidence to perform automatic response.
- Forensic evidence collection, including EBS Snapshot creation and S3 storage, should happen before any action that may change the state of the resource.
- Dry-run mode is useful during testing to validate the workflow before applying real response actions.
- Clear resource tagging, such as `AutoIsolate=true`, helps prevent accidental isolation of resources that are not part of the lab scope.

---

## Conclusion

The most interesting part of building AWS CloudSOC is not just automation. The real value comes from building automation that is smart, controlled, and suitable for real cloud security operations.

A useful incident response system should not only detect threats, but also respond at the right time, in the right way, while preserving evidence for investigation.

Have you ever faced a situation where **GuardDuty generated too many alerts** and it was difficult to decide how to handle them effectively? Sharing real-world experiences can help everyone learn better approaches to cloud incident response.