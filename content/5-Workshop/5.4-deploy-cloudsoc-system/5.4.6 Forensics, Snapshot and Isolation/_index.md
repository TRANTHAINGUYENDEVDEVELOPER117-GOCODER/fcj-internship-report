---
title : "Forensics, Snapshot and Isolation"
date : 2026-07-01
weight : 6
chapter : false
pre : " <b> 5.4.6. </b> "
---

#### Forensics, Snapshot and Isolation

In this section, you will implement the **Forensics, Snapshot and Isolation** layer for the AWS CloudSOC system. This layer is responsible for collecting evidence, creating snapshots for investigation, and isolating a suspected compromised EC2 instance.

In the previous sections, GuardDuty detected a finding, EventBridge triggered Step Functions, and the dashboard supported analyst approval. In this section, you will implement the actual response actions:

```text
Collect Evidence → Create EBS Snapshot → Apply SG-Isolation → Update Incident Status
```

---

#### Objectives

After completing this section, you will have:

+ A Lambda function for incident response actions.
+ An IAM Role that allows Lambda to work with EC2, EBS, S3, SSM, and DynamoDB.
+ Systems Manager Run Command for basic forensic data collection.
+ An EBS Snapshot for post-incident investigation.
+ An S3 Evidence Bucket for storing metadata and forensic output.
+ The workload EC2 instance isolated by replacing its security group with `SG-Isolation`.
+ The incident status updated in DynamoDB.

---

#### Forensics, Snapshot and Isolation Architecture

The following diagram illustrates the incident response flow in AWS CloudSOC.

![Forensics Snapshot and Isolation Architecture](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.6-forensics-snapshot-and-isolation/forensics-isolation-architecture.png)

The main workflow is:

```text
Step Functions
→ Incident Response Lambda
→ Systems Manager Run Command
→ S3 Evidence Bucket
→ EBS Forensic Snapshot
→ Replace EC2 Security Group with SG-Isolation
→ Update DynamoDB Incident Table
```

In this architecture, Lambda orchestrates the response actions. Systems Manager collects information from the EC2 instance, EBS Snapshot preserves the volume state, S3 stores evidence, and Security Group Isolation helps isolate the EC2 instance from unwanted traffic.

---

#### Recommended Configuration

| Component | Recommended Value |
|---|---|
| Lambda Function | `cloudsoc-incident-response-lambda` |
| Lambda Role | `CloudSOC-Incident-Response-Lambda-Role` |
| Evidence Bucket | `cloudsoc-evidence-<account-id>` |
| Incident Table | `CloudSOC-IncidentTable` |
| Workload EC2 | `cloudsoc-workload-ec2` |
| Normal Security Group | `SG-Workload` |
| Isolation Security Group | `SG-Isolation` |
| EC2 Tag Requirement | `AutoIsolate=true` |
| SSM Document | `AWS-RunShellScript` |
| Snapshot Type | EBS Snapshot |

---

#### Step 1: Check EC2 Before Isolation

Before implementing automated response, verify the current workload EC2 instance.

Go to:

```text
EC2 → Instances → cloudsoc-workload-ec2
```

Check the following information:

| Field | Value |
|---|---|
| Instance state | Running |
| IAM Role | `CloudSOC-EC2-SSM-Role` |
| Current Security Group | `SG-Workload` |
| Tag | `AutoIsolate=true` |
| SSM status | Managed instance |

Expected result:

```text
The EC2 instance is running with SG-Workload and can be managed by Systems Manager.
```

![EC2 Before Isolation SG](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.6-forensics-snapshot-and-isolation/ec2-before-isolation-sg.png)

---

#### Step 2: Verify SG-Isolation

The `SG-Isolation` security group is used to isolate the EC2 instance when an incident is confirmed.

Go to:

```text
EC2 → Security Groups → SG-Isolation
```

Verify:

```text
Inbound rules: no rules
Outbound rules: no rules
```

Expected result:

```text
SG-Isolation does not allow inbound or outbound traffic.
```

![SG Isolation Rules](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.6-forensics-snapshot-and-isolation/sg-isolation-rules.png)

> **Note:** Security groups are stateful. Replacing the workload security group with SG-Isolation mainly blocks new connections and isolates the resource in this lab environment.

---

#### Step 3: Create an IAM Role for Incident Response Lambda

The Lambda function needs permissions to:

+ Read EC2 information.
+ Send SSM Run Command.
+ Create EBS Snapshots.
+ Replace the EC2 security group.
+ Write evidence to S3.
+ Update the DynamoDB incident record.

Go to:

```text
IAM → Roles → Create role
```

Configure the role:

| Field | Value |
|---|---|
| Trusted entity type | AWS service |
| Use case | Lambda |
| Role name | `CloudSOC-Incident-Response-Lambda-Role` |

Attach the basic policy:

```text
AWSLambdaBasicExecutionRole
```

Then create an additional inline policy for the lab.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EC2ForensicsAndIsolation",
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeVolumes",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:ModifyInstanceAttribute"
      ],
      "Resource": "*"
    },
    {
      "Sid": "SSMRunCommand",
      "Effect": "Allow",
      "Action": [
        "ssm:SendCommand",
        "ssm:GetCommandInvocation"
      ],
      "Resource": "*"
    },
    {
      "Sid": "S3EvidenceWrite",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject"
      ],
      "Resource": "arn:aws:s3:::cloudsoc-evidence-<account-id>/*"
    },
    {
      "Sid": "DynamoDBIncidentUpdate",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:GetItem"
      ],
      "Resource": "arn:aws:dynamodb:ap-southeast-1:<account-id>:table/CloudSOC-IncidentTable"
    }
  ]
}
```

Expected result:

```text
The IAM Role for the Incident Response Lambda is created successfully.
```

![Response Lambda Role](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.6-forensics-snapshot-and-isolation/response-lambda-role.png)

---

#### Step 4: Create the Incident Response Lambda

Go to:

```text
AWS Lambda → Create function
```

Configure the function:

| Field | Value |
|---|---|
| Function name | `cloudsoc-incident-response-lambda` |
| Runtime | Python 3.12 |
| Architecture | x86_64 |
| Execution role | `CloudSOC-Incident-Response-Lambda-Role` |

Expected result:

```text
The Lambda function cloudsoc-incident-response-lambda is created successfully.
```

![Create Response Lambda](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.6-forensics-snapshot-and-isolation/create-response-lambda.png)

---

#### Step 5: Configure Lambda Environment Variables

In the Lambda function, open:

```text
Configuration → Environment variables → Edit
```

Add the following environment variables:

| Key | Value |
|---|---|
| `EVIDENCE_BUCKET` | `cloudsoc-evidence-<account-id>` |
| `INCIDENT_TABLE` | `CloudSOC-IncidentTable` |
| `ISOLATION_SG_ID` | Security Group ID of `SG-Isolation` |
| `REGION` | `ap-southeast-1` |

Example:

```text
EVIDENCE_BUCKET = cloudsoc-evidence-123456789012
INCIDENT_TABLE = CloudSOC-IncidentTable
ISOLATION_SG_ID = sg-xxxxxxxxxxxxxxxxx
REGION = ap-southeast-1
```

Expected result:

```text
Lambda has the required information to write evidence, update incidents, and isolate EC2.
```

![Lambda Environment Variables](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.6-forensics-snapshot-and-isolation/lambda-environment-variables.png)

---

#### Step 6: Add Code to the Incident Response Lambda

In the Lambda **Code** tab, replace the default code with the following code.

```python
import boto3
import json
import os
import datetime

REGION = os.environ.get("REGION", "ap-southeast-1")
EVIDENCE_BUCKET = os.environ["EVIDENCE_BUCKET"]
INCIDENT_TABLE = os.environ["INCIDENT_TABLE"]
ISOLATION_SG_ID = os.environ["ISOLATION_SG_ID"]

ec2 = boto3.client("ec2", region_name=REGION)
ssm = boto3.client("ssm", region_name=REGION)
s3 = boto3.client("s3", region_name=REGION)
dynamodb = boto3.resource("dynamodb", region_name=REGION)
table = dynamodb.Table(INCIDENT_TABLE)


def now_iso():
    return datetime.datetime.utcnow().replace(microsecond=0).isoformat() + "Z"


def extract_instance_id(event):
    detail = event.get("detail", {})
    resource = detail.get("resource", {})
    instance_details = resource.get("instanceDetails", {})
    return instance_details.get("instanceId")


def get_instance(instance_id):
    response = ec2.describe_instances(InstanceIds=[instance_id])
    reservations = response.get("Reservations", [])

    if not reservations:
        raise Exception("Instance not found")

    instances = reservations[0].get("Instances", [])

    if not instances:
        raise Exception("Instance not found")

    return instances[0]


def has_auto_isolate_tag(instance):
    tags = instance.get("Tags", [])

    for tag in tags:
        if tag.get("Key") == "AutoIsolate" and tag.get("Value") == "true":
            return True

    return False


def put_evidence_object(incident_id, name, data):
    key = f"incidents/{incident_id}/{name}"

    s3.put_object(
        Bucket=EVIDENCE_BUCKET,
        Key=key,
        Body=json.dumps(data, indent=2, default=str),
        ContentType="application/json"
    )

    return f"s3://{EVIDENCE_BUCKET}/{key}"


def create_snapshots(instance_id, instance, incident_id):
    snapshot_ids = []

    for mapping in instance.get("BlockDeviceMappings", []):
        ebs = mapping.get("Ebs")

        if not ebs:
            continue

        volume_id = ebs.get("VolumeId")

        if not volume_id:
            continue

        snapshot = ec2.create_snapshot(
            VolumeId=volume_id,
            Description=f"CloudSOC forensic snapshot for {instance_id}, incident {incident_id}"
        )

        snapshot_id = snapshot["SnapshotId"]
        snapshot_ids.append(snapshot_id)

        ec2.create_tags(
            Resources=[snapshot_id],
            Tags=[
                {"Key": "Project", "Value": "AWS-CloudSOC"},
                {"Key": "IncidentId", "Value": incident_id},
                {"Key": "SourceInstanceId", "Value": instance_id},
                {"Key": "Purpose", "Value": "Forensics"}
            ]
        )

    return snapshot_ids


def collect_ssm_evidence(instance_id, incident_id):
    commands = [
        "echo 'CloudSOC Forensic Collection'",
        "date -u",
        "hostname",
        "whoami",
        "uname -a",
        "uptime",
        "echo '--- Network Connections ---'",
        "ss -tulpn || netstat -tulpn || true",
        "echo '--- Running Processes ---'",
        "ps aux --sort=-%mem | head -30",
        "echo '--- Recent Logins ---'",
        "last -n 20 || true",
        "echo '--- Recent System Logs ---'",
        "journalctl -n 100 --no-pager || true"
    ]

    response = ssm.send_command(
        InstanceIds=[instance_id],
        DocumentName="AWS-RunShellScript",
        Parameters={"commands": commands},
        OutputS3BucketName=EVIDENCE_BUCKET,
        OutputS3KeyPrefix=f"forensics/{incident_id}/ssm-output",
        Comment=f"CloudSOC forensic collection for incident {incident_id}"
    )

    return response["Command"]["CommandId"]


def apply_isolation(instance_id):
    ec2.modify_instance_attribute(
        InstanceId=instance_id,
        Groups=[ISOLATION_SG_ID]
    )


def update_incident(incident_id, data):
    table.put_item(Item=data)


def lambda_handler(event, context):
    timestamp = now_iso()

    detail = event.get("detail", {})
    finding_id = detail.get("id", "sample-finding-id")
    finding_type = detail.get("type", "UnknownFindingType")
    title = detail.get("title", "CloudSOC Security Finding")
    severity = detail.get("severity", 0)

    instance_id = extract_instance_id(event)

    if not instance_id:
        raise Exception("No EC2 instance ID found in GuardDuty finding event")

    incident_id = f"INC-{finding_id.replace(':', '-').replace('/', '-')[:40]}"

    instance = get_instance(instance_id)

    if not has_auto_isolate_tag(instance):
        result = {
            "incidentId": incident_id,
            "findingId": finding_id,
            "title": title,
            "findingType": finding_type,
            "severity": str(severity),
            "resourceType": "Instance",
            "resourceId": instance_id,
            "responseMode": "AlertOnly",
            "approvalStatus": "NotRequired",
            "incidentStatus": "Skipped",
            "reason": "Instance does not have AutoIsolate=true tag",
            "createdAt": timestamp,
            "updatedAt": timestamp
        }

        put_evidence_object(incident_id, "skipped-response.json", result)
        update_incident(incident_id, result)

        return result

    raw_event_s3_path = put_evidence_object(incident_id, "guardduty-event.json", event)

    ssm_command_id = collect_ssm_evidence(instance_id, incident_id)

    snapshot_ids = create_snapshots(instance_id, instance, incident_id)

    apply_isolation(instance_id)

    result = {
        "incidentId": incident_id,
        "findingId": finding_id,
        "title": title,
        "findingType": finding_type,
        "severity": str(severity),
        "resourceType": "Instance",
        "resourceId": instance_id,
        "responseMode": "AutoResponse",
        "approvalStatus": "Approved",
        "incidentStatus": "Isolated",
        "isolationSecurityGroupId": ISOLATION_SG_ID,
        "ssmCommandId": ssm_command_id,
        "snapshotIds": snapshot_ids,
        "evidencePath": raw_event_s3_path,
        "createdAt": timestamp,
        "updatedAt": timestamp
    }

    put_evidence_object(incident_id, "response-summary.json", result)
    update_incident(incident_id, result)

    return result
```

After pasting the code, choose:

```text
Deploy
```

Expected result:

```text
The Incident Response Lambda is deployed successfully.
```

---

#### Step 7: Create a Lambda Test Event

In Lambda, choose:

```text
Test → Create new event
```

Set the event name:

```text
cloudsoc-critical-finding-test
```

Paste the following sample event. Replace `i-xxxxxxxxxxxxxxxxx` with your actual EC2 Instance ID.

```json
{
  "version": "0",
  "id": "sample-guardduty-event",
  "detail-type": "GuardDuty Finding",
  "source": "aws.guardduty",
  "account": "123456789012",
  "region": "ap-southeast-1",
  "detail": {
    "id": "sample-finding-001",
    "severity": 8.5,
    "type": "UnauthorizedAccess:EC2/SSHBruteForce",
    "title": "Sample GuardDuty finding for EC2 SSH brute force",
    "resource": {
      "resourceType": "Instance",
      "instanceDetails": {
        "instanceId": "i-xxxxxxxxxxxxxxxxx"
      }
    }
  }
}
```

Expected result:

```text
The test event is created successfully.
```

![Lambda Test Event](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.6-forensics-snapshot-and-isolation/response-lambda-test-event.png)

---

#### Step 8: Run the Lambda Test

Choose:

```text
Test
```

If the Lambda function runs successfully, the response should include:

```text
incidentId
resourceId
ssmCommandId
snapshotIds
isolationSecurityGroupId
incidentStatus = Isolated
```

Expected result:

```text
Lambda runs successfully and starts the evidence collection, snapshot, and EC2 isolation process.
```

![Lambda Test Result](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.6-forensics-snapshot-and-isolation/response-lambda-test-result.png)

---

#### Step 9: Check Systems Manager Run Command

After Lambda runs, go to:

```text
Systems Manager → Run Command → Command history
```

Find the latest command created by Lambda.

Check:

```text
Status = Success
Target = cloudsoc-workload-ec2
Document = AWS-RunShellScript
```

Expected result:

```text
SSM Run Command runs successfully on the workload EC2 instance.
```

![SSM Command Output](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.6-forensics-snapshot-and-isolation/ssm-command-output.png)

---

#### Step 10: Check Evidence in S3

Go to the evidence bucket:

```text
S3 → cloudsoc-evidence-<account-id>
```

Check the following prefixes:

```text
incidents/
forensics/
```

Inside `incidents/`, you should see metadata files such as:

```text
guardduty-event.json
response-summary.json
```

Inside `forensics/`, you should see the output from SSM Run Command.

Expected result:

```text
Evidence and forensic output are stored in the S3 Evidence Bucket.
```

![S3 Evidence Objects](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.6-forensics-snapshot-and-isolation/s3-evidence-objects.png)

---

#### Step 11: Check the EBS Snapshot

Go to:

```text
EC2 → Elastic Block Store → Snapshots
```

Find the snapshot with the following tags:

```text
Project = AWS-CloudSOC
Purpose = Forensics
IncidentId = <incident-id>
SourceInstanceId = <instance-id>
```

Expected result:

```text
An EBS Snapshot for forensic investigation is created successfully.
```

![EBS Forensic Snapshot](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.6-forensics-snapshot-and-isolation/ebs-forensic-snapshot.png)

---

#### Step 12: Verify EC2 Isolation

Go to:

```text
EC2 → Instances → cloudsoc-workload-ec2 → Security
```

Check the current Security Group.

Before response:

```text
SG-Workload
```

After Lambda runs:

```text
SG-Isolation
```

Expected result:

```text
The EC2 instance is replaced with SG-Isolation.
```

![EC2 After Isolation SG](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.6-forensics-snapshot-and-isolation/ec2-after-isolation-sg.png)

---

#### Step 13: Check DynamoDB Incident Status

Go to:

```text
DynamoDB → Tables → CloudSOC-IncidentTable → Explore table items
```

Find the incident created or updated by Lambda.

Check the following fields:

```text
incidentStatus = Isolated
approvalStatus = Approved
responseMode = AutoResponse
resourceId = <instance-id>
snapshotIds = [...]
ssmCommandId = <command-id>
```

Expected result:

```text
DynamoDB records that the incident has been processed and the EC2 instance has been isolated.
```

![DynamoDB Incident Updated](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.6-forensics-snapshot-and-isolation/dynamodb-incident-updated.png)

---

#### Step 14: Integrate Lambda with Step Functions

After Lambda works correctly, update Step Functions so that the **Auto Response** branch invokes Lambda instead of using a placeholder.

The desired workflow is:

```text
Evaluate Finding
→ Auto Response
→ Incident Response Lambda
→ End
```

In Step Functions Workflow Studio, replace the state:

```text
Response Actions Placeholder
```

with the following action:

```text
Lambda Invoke
```

Choose the Lambda function:

```text
cloudsoc-incident-response-lambda
```

Expected result:

```text
Step Functions can invoke the Incident Response Lambda when a finding is eligible for Auto Response.
```

![Step Functions Lambda Integration](/images/5-Workshop/5.4-Deploy-cloudsoc-system/5.4.6-forensics-snapshot-and-isolation/stepfunctions-lambda-integration.png)

---

#### Step 15: Restore EC2 to SG-Workload After Testing

After testing, restore the EC2 instance to its original Security Group to avoid losing access or affecting later workshop steps.

Go to:

```text
EC2 → Instances → cloudsoc-workload-ec2 → Actions → Security → Change security groups
```

Change:

```text
SG-Isolation
```

back to:

```text
SG-Workload
```

Expected result:

```text
The EC2 instance is restored to its original Security Group for the next workshop steps.
```

---

#### Completion Checklist

After completing this section, verify the following items:

- [ ] EC2 has the tag `AutoIsolate=true`.
- [ ] `SG-Isolation` has no inbound and outbound rules.
- [ ] IAM Role `CloudSOC-Incident-Response-Lambda-Role` is created.
- [ ] Lambda `cloudsoc-incident-response-lambda` is created.
- [ ] Lambda environment variables are configured correctly.
- [ ] Lambda can read the sample GuardDuty event.
- [ ] Systems Manager Run Command runs successfully.
- [ ] Evidence is stored in S3.
- [ ] EBS Snapshot is created.
- [ ] EC2 Security Group is replaced with `SG-Isolation`.
- [ ] DynamoDB incident status is updated.
- [ ] Step Functions can invoke the Incident Response Lambda.

---

#### Completion Result

After completing this section, AWS CloudSOC has a lab-level automated incident response capability.

The following components are now ready:

```text
AWS Lambda
AWS Systems Manager
Amazon EBS Snapshot
Amazon S3 Evidence Bucket
Amazon DynamoDB
EC2 Security Group Isolation
AWS Step Functions Integration
```

When a finding is eligible for automated response, Lambda collects evidence, creates snapshots, stores metadata, updates the incident record, and replaces the EC2 security group with `SG-Isolation`.

---

#### Summary

In this section, you implemented the Forensics, Snapshot and Isolation workflow for AWS CloudSOC. This workflow allows the CloudSOC system to respond quickly to incidents while preserving evidence for post-incident investigation.

In the next section, you will implement **Notification and Alerting** to send incident response results through SNS, Email, SMS, or Slack.