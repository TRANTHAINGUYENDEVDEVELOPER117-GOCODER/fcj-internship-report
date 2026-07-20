---
title : "Test Auto Isolation"
date : 2026-07-01
weight : 3
chapter : false
pre : " <b> 5.5.3. </b> "
---

#### Test Auto Isolation

In this section, you will test the **Auto Isolation** capability of the AWS CloudSOC system.

The goal of this test is to confirm that when a critical GuardDuty finding related to an EC2 instance is processed, the system can automatically perform incident response actions such as collecting forensic evidence, creating an EBS Snapshot, updating DynamoDB, and isolating the EC2 instance by replacing its original Security Group with `SG-Isolation`.

Auto Isolation is one of the most important parts of the automated incident response workflow in CloudSOC.

The overall workflow is:

```text
GuardDuty Finding
→ EventBridge / Step Functions
→ Incident Response Lambda
→ Systems Manager
→ EBS Snapshot
→ S3 Evidence Bucket
→ Replace SG-Workload with SG-Isolation
→ DynamoDB Incident Update
```

In this section, a controlled sample event is used to make sure the event contains the correct EC2 instance ID from the lab environment.

---

#### Testing Objectives

After completing this section, you will be able to confirm that:

+ Incident Response Lambda can receive a simulated GuardDuty Finding event.
+ Lambda can identify the correct EC2 instance.
+ Lambda can check the `AutoIsolate=true` tag.
+ Systems Manager can collect forensic evidence from the EC2 instance.
+ An EBS Snapshot is created for investigation.
+ Evidence is stored in the S3 Evidence Bucket.
+ The EC2 Security Group is changed from `SG-Workload` to `SG-Isolation`.
+ DynamoDB is updated with the incident response status.

---

#### Testing Architecture

The following diagram shows the Auto Isolation test flow.

![Test Auto Isolation Flow](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-test-auto-isolation/test-auto-isolation-flow.png)

The testing flow includes the following steps:

```text
Sample GuardDuty Event
→ Incident Response Lambda
→ Validate EC2 Instance
→ Collect Evidence with SSM
→ Create EBS Snapshot
→ Store Evidence in S3
→ Apply SG-Isolation
→ Update DynamoDB
```

---

#### Step 1: Check EC2 Before Isolation

Before running the auto isolation test, the workload EC2 instance should be running normally with its original Security Group.

The workload EC2 instance in this lab is:

```text
cloudsoc-workload-ec2
```

Expected state before testing:

```text
Instance state: Running
Security Group: SG-Workload
AutoIsolate tag: true
```

![EC2 Before Auto Isolation](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-test-auto-isolation/ec2-before-auto-isolation.png)

At this stage, the EC2 instance has not been isolated yet. The current Security Group shows that the instance is still in its normal operating state before the incident response workflow is triggered.

---

#### Step 2: Prepare the Sample GuardDuty Event

To test the workflow accurately, a sample GuardDuty event is used with the correct EC2 instance ID from the lab.

The sample event simulates a high-severity finding:

```json
{
  "version": "0",
  "id": "sample-guardduty-event",
  "detail-type": "GuardDuty Finding",
  "source": "aws.guardduty",
  "region": "ap-southeast-1",
  "detail": {
    "id": "sample-finding-001",
    "severity": 8.5,
    "type": "UnauthorizedAccess:EC2/SSHBruteForce",
    "title": "Sample GuardDuty finding for EC2 SSH brute force",
    "resource": {
      "resourceType": "Instance",
      "instanceDetails": {
        "instanceId": "i-0aa99a09aeb62061c"
      }
    }
  }
}
```

This sample event allows the auto response workflow to be tested safely without performing real attack activities.

![Lambda Auto Isolation Test Event](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-test-auto-isolation/lambda-auto-isolation-test-event.png)

Important fields in the event:

| Field | Description |
|---|---|
| `detail-type` | Identifies the event as a GuardDuty Finding |
| `severity` | Indicates the severity level of the finding |
| `type` | Shows the suspicious activity type |
| `resourceType` | Shows the affected resource type |
| `instanceId` | Identifies the EC2 instance to be processed |

---

#### Step 3: Run Incident Response Lambda

After preparing the sample event, run the Incident Response Lambda to test the auto isolation workflow.

The Lambda function used in this lab is:

```text
cloudsoc-incident-response-lambda
```

When Lambda is triggered, it performs the following actions:

```text
1. Read the GuardDuty Finding event.
2. Extract the EC2 instance ID from the event.
3. Verify that the EC2 instance exists.
4. Check the AutoIsolate=true tag.
5. Collect forensic evidence using Systems Manager.
6. Create an EBS Snapshot.
7. Store evidence in S3.
8. Replace the EC2 Security Group with SG-Isolation.
9. Update the incident status in DynamoDB.
```

![Lambda Auto Isolation Success](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-test-auto-isolation/lambda-auto-isolation-success.png)

A successful Lambda result confirms that the system processed the event and performed the incident response actions.

---

#### Step 4: Check Systems Manager Forensic Command

During the auto isolation process, Lambda uses AWS Systems Manager to run a command that collects basic forensic information from the EC2 instance.

The collected forensic information may include:

```text
Hostname
Current user
System information
Uptime
Network connections
Running processes
Recent login history
Recent system logs
```

![SSM Forensic Command Output](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-test-auto-isolation/ssm-forensic-command-output.png)

This result confirms that Systems Manager can communicate with the EC2 instance and execute the forensic evidence collection command.

---

#### Step 5: Check Evidence in S3

After Lambda processes the event, evidence is stored in the S3 Evidence Bucket.

The evidence objects may include:

```text
raw-event.json
response-summary.json
ssm-output/
```

![S3 Auto Isolation Evidence](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-test-auto-isolation/s3-auto-isolation-evidence.png)

The S3 Evidence Bucket stores incident evidence for post-incident investigation. These files help the SOC Analyst review the original event, response result, and forensic data collected from the EC2 instance.

---

#### Step 6: Check EBS Forensic Snapshot

One important action in the auto isolation workflow is creating an **EBS Snapshot** from the EC2 instance volume.

The snapshot preserves the volume state at the time of the incident and can be used for forensic investigation.

![EBS Forensic Snapshot Created](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-test-auto-isolation/ebs-forensic-snapshot-created.png)

The snapshot is tagged with incident-related metadata, for example:

```text
Project = AWS-CloudSOC
IncidentId = sample-finding-001
SourceInstanceId = i-0aa99a09aeb62061c
Purpose = Forensics
```

Creating a snapshot helps preserve evidence before further response actions are performed.

---

#### Step 7: Check EC2 After Isolation

After Lambda finishes processing, the workload EC2 instance should have its Security Group changed from `SG-Workload` to `SG-Isolation`.

Expected state after auto isolation:

```text
Instance state: Running
Security Group: SG-Isolation
Inbound rules: None
Outbound rules: None
```

![EC2 After Auto Isolation](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-test-auto-isolation/ec2-after-auto-isolation.png)

Replacing the Security Group helps isolate the EC2 instance from unwanted network communication. In this lab, `SG-Isolation` is configured with no inbound and outbound rules to reduce the ability of the instance to communicate over the network.

---

#### Step 8: Check DynamoDB Incident Status

After the EC2 instance is isolated, the DynamoDB Incident Table is updated with the new incident status.

![DynamoDB Auto Isolation Updated](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-test-auto-isolation/dynamodb-auto-isolation-updated.png)

Expected result:

```text
approvalStatus = Approved
incidentStatus = Isolated
responseMode = AutoResponse
isolationSecurityGroupId = SG-Isolation
snapshotIds = Created
ssmCommandId = Created
evidencePath = S3 path
```

DynamoDB allows the SOC Analyst to track the incident response status and confirm that auto isolation has been completed.

---

#### Step 9: Check Step Functions Auto Response Execution

If auto isolation is triggered through Step Functions, the execution should follow the `Auto Response` branch.

![Step Functions Auto Response Execution](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-test-auto-isolation/stepfunctions-auto-response-execution.png)

A successful execution confirms that the workflow can route the incident through the correct automated response path.

If the test is performed directly using a Lambda test event, the Lambda execution result together with EC2, S3, EBS Snapshot, and DynamoDB validation is still enough to prove that auto isolation works correctly.

---

#### Expected Results

After completing this section, the following results are expected:

| Component | Expected Result |
|---|---|
| EC2 before test | The instance is using `SG-Workload` |
| Lambda | Processes the sample GuardDuty event successfully |
| Systems Manager | Runs the forensic command successfully |
| S3 Evidence Bucket | Stores the raw event and response summary |
| EBS Snapshot | Creates a snapshot from the EC2 volume |
| EC2 after test | The instance is changed to `SG-Isolation` |
| DynamoDB | Incident status is updated to `Isolated` |
| Step Functions | Auto Response execution succeeds or is ready for validation |

---

#### Validation Evidence

The validation evidence for this test includes the following screenshots:

| No. | Image | Purpose |
|---|---|---|
| 1 | Auto isolation flow diagram | Shows the Auto Isolation test flow |
| 2 | EC2 before auto isolation | Confirms that EC2 is using `SG-Workload` |
| 3 | Lambda test event | Confirms the simulated GuardDuty Finding event |
| 4 | Lambda success result | Confirms that Lambda processed the event successfully |
| 5 | SSM forensic command output | Confirms that the forensic command was executed |
| 6 | S3 evidence objects | Confirms that evidence was stored in S3 |
| 7 | EBS forensic snapshot | Confirms that the snapshot was created |
| 8 | EC2 after auto isolation | Confirms that EC2 was changed to `SG-Isolation` |
| 9 | DynamoDB incident update | Confirms that the incident status was updated |
| 10 | Step Functions auto response execution | Confirms the Auto Response workflow execution |

---

#### Notes

In this test, a controlled sample event is used instead of a real attack to keep the lab environment safe.

Default GuardDuty sample findings may not always contain the actual EC2 instance ID of the workload created in this lab. Therefore, using a controlled sample event ensures that Lambda processes the correct target resource.

The EC2 instance must meet the following conditions for auto isolation to work:

```text
EC2 instance is running
EC2 has the AutoIsolate=true tag
EC2 has an IAM Role for Systems Manager
EC2 is managed by Systems Manager
Lambda has permissions for EC2, SSM, S3, and DynamoDB
SG-Isolation exists in the same VPC as the EC2 instance
```

---

#### Completion

You have completed the Auto Isolation test.

The result of this section confirms that the AWS CloudSOC system can automatically respond to a critical incident by collecting evidence, creating a forensic snapshot, updating the incident status, and isolating the EC2 instance using `SG-Isolation`.

This is the most important validation step for the automated incident response capability of the CloudSOC system.