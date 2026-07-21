---
title : "Forensics, Snapshot and Isolation"
date : 2026-07-01
weight : 6
chapter : false
pre : " <b> 5.4.6. </b> "
---

#### Forensics, Snapshot and Isolation

Trong pháº§n nÃ y, chÃºng ta sáº½ triá»ƒn khai lá»›p **Forensics, Snapshot and Isolation** cho há»‡ thá»‘ng AWS CloudSOC. ÄÃ¢y lÃ  lá»›p chá»‹u trÃ¡ch nhiá»‡m thu tháº­p báº±ng chá»©ng, táº¡o snapshot phá»¥c vá»¥ Ä‘iá»u tra vÃ  cÃ´ láº­p EC2 bá»‹ nghi ngá» cÃ³ dáº¥u hiá»‡u bá»‹ táº¥n cÃ´ng.

á»ž cÃ¡c pháº§n trÆ°á»›c, GuardDuty Ä‘Ã£ phÃ¡t hiá»‡n finding, EventBridge Ä‘Ã£ kÃ­ch hoáº¡t Step Functions, dashboard Ä‘Ã£ há»— trá»£ phÃª duyá»‡t incident. Trong pháº§n nÃ y, chÃºng ta triá»ƒn khai hÃ nh Ä‘á»™ng pháº£n á»©ng tháº­t:

```text
Collect Evidence â†’ Create EBS Snapshot â†’ Apply SG-Isolation â†’ Update Incident Status
```

---

#### Má»¥c tiÃªu

Sau khi hoÃ n thÃ nh pháº§n nÃ y, báº¡n sáº½ cÃ³:

+ Lambda function xá»­ lÃ½ pháº£n á»©ng sá»± cá»‘.
+ IAM Role cho phÃ©p Lambda thao tÃ¡c vá»›i EC2, EBS, S3, SSM vÃ  DynamoDB.
+ Systems Manager Run Command Ä‘á»ƒ thu tháº­p thÃ´ng tin forensic cÆ¡ báº£n.
+ EBS Snapshot phá»¥c vá»¥ Ä‘iá»u tra sau sá»± cá»‘.
+ S3 Evidence Bucket lÆ°u metadata vÃ  output Ä‘iá»u tra.
+ EC2 workload Ä‘Æ°á»£c cÃ´ láº­p báº±ng cÃ¡ch thay Security Group sang `SG-Isolation`.
+ DynamoDB incident Ä‘Æ°á»£c cáº­p nháº­t tráº¡ng thÃ¡i xá»­ lÃ½.

---

#### Forensics, Snapshot and Isolation Architecture

SÆ¡ Ä‘á»“ sau minh há»a luá»“ng pháº£n á»©ng sá»± cá»‘ trong AWS CloudSOC.

![Forensics Snapshot and Isolation Architecture](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/forensics-isolation-architecture.png)

Luá»“ng xá»­ lÃ½ chÃ­nh:

```text
Step Functions
â†’ Incident Response Lambda
â†’ Systems Manager Run Command
â†’ S3 Evidence Bucket
â†’ EBS Forensic Snapshot
â†’ Replace EC2 Security Group with SG-Isolation
â†’ Update DynamoDB Incident Table
```

Trong kiáº¿n trÃºc nÃ y, Lambda Ä‘Ã³ng vai trÃ² Ä‘iá»u phá»‘i hÃ nh Ä‘á»™ng pháº£n á»©ng. Systems Manager thu tháº­p thÃ´ng tin trÃªn EC2, EBS Snapshot lÆ°u tráº¡ng thÃ¡i volume, S3 lÆ°u báº±ng chá»©ng, cÃ²n Security Group Isolation giÃºp cÃ´ láº­p EC2 khá»i luá»“ng traffic khÃ´ng mong muá»‘n.

---

#### ThÃ´ng tin cáº¥u hÃ¬nh Ä‘á» xuáº¥t

| ThÃ nh pháº§n | GiÃ¡ trá»‹ Ä‘á» xuáº¥t |
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

#### BÆ°á»›c 1: Kiá»ƒm tra EC2 trÆ°á»›c khi cÃ´ láº­p

TrÆ°á»›c khi triá»ƒn khai pháº£n á»©ng tá»± Ä‘á»™ng, kiá»ƒm tra EC2 workload hiá»‡n táº¡i.

VÃ o:

```text
EC2 â†’ Instances â†’ cloudsoc-workload-ec2
```

Kiá»ƒm tra cÃ¡c thÃ´ng tin:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Instance state | Running |
| IAM Role | `CloudSOC-EC2-SSM-Role` |
| Security Group hiá»‡n táº¡i | `SG-Workload` |
| Tag | `AutoIsolate=true` |
| SSM status | Managed instance |

Káº¿t quáº£ mong Ä‘á»£i:

```text
EC2 Ä‘ang cháº¡y vá»›i SG-Workload vÃ  cÃ³ thá»ƒ Ä‘Æ°á»£c quáº£n lÃ½ báº±ng Systems Manager.
```

![EC2 Before Isolation SG](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/ec2-before-isolation-sg.png)

---

#### BÆ°á»›c 2: Kiá»ƒm tra SG-Isolation

Security Group `SG-Isolation` Ä‘Æ°á»£c dÃ¹ng Ä‘á»ƒ cÃ´ láº­p EC2 khi incident Ä‘Æ°á»£c xÃ¡c nháº­n.

VÃ o:

```text
EC2 â†’ Security Groups â†’ SG-Isolation
```

Kiá»ƒm tra:

```text
Inbound rules: khÃ´ng cÃ³ rule
Outbound rules: khÃ´ng cÃ³ rule
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
SG-Isolation khÃ´ng cho phÃ©p inbound vÃ  outbound traffic.
```

![SG Isolation Rules](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/sg-isolation-rules.png)

> **LÆ°u Ã½:** Security Group lÃ  stateful. Viá»‡c thay sang SG-Isolation chá»§ yáº¿u giÃºp cháº·n káº¿t ná»‘i má»›i vÃ  cÃ´ láº­p tÃ i nguyÃªn trong mÃ´i trÆ°á»ng lab.

---

#### BÆ°á»›c 3: Táº¡o IAM Role cho Incident Response Lambda

Lambda cáº§n quyá»n Ä‘á»ƒ:

+ Äá»c thÃ´ng tin EC2.
+ Gá»­i SSM Run Command.
+ Táº¡o EBS Snapshot.
+ Thay Security Group cá»§a EC2.
+ Ghi báº±ng chá»©ng vÃ o S3.
+ Cáº­p nháº­t DynamoDB incident.

VÃ o:

```text
IAM â†’ Roles â†’ Create role
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Trusted entity type | AWS service |
| Use case | Lambda |
| Role name | `CloudSOC-Incident-Response-Lambda-Role` |

Gáº¯n policy cÆ¡ báº£n:

```text
AWSLambdaBasicExecutionRole
```

Sau Ä‘Ã³ táº¡o thÃªm inline policy cho lab.

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

Káº¿t quáº£ mong Ä‘á»£i:

```text
IAM Role cho Incident Response Lambda Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![Response Lambda Role](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/response-lambda-role.png)

---

#### BÆ°á»›c 4: Táº¡o Incident Response Lambda

VÃ o:

```text
AWS Lambda â†’ Create function
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Function name | `cloudsoc-incident-response-lambda` |
| Runtime | Python 3.12 |
| Architecture | x86_64 |
| Execution role | `CloudSOC-Incident-Response-Lambda-Role` |

Káº¿t quáº£ mong Ä‘á»£i:

```text
Lambda function cloudsoc-incident-response-lambda Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![Create Response Lambda](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/create-response-lambda.png)

---

#### BÆ°á»›c 5: Cáº¥u hÃ¬nh Environment Variables cho Lambda

Trong Lambda, vÃ o:

```text
Configuration â†’ Environment variables â†’ Edit
```

ThÃªm cÃ¡c biáº¿n mÃ´i trÆ°á»ng sau:

| Key | Value |
|---|---|
| `EVIDENCE_BUCKET` | `cloudsoc-evidence-<account-id>` |
| `INCIDENT_TABLE` | `CloudSOC-IncidentTable` |
| `ISOLATION_SG_ID` | Security Group ID cá»§a `SG-Isolation` |
| `REGION` | `ap-southeast-1` |

VÃ­ dá»¥:

```text
EVIDENCE_BUCKET = cloudsoc-evidence-123456789012
INCIDENT_TABLE = CloudSOC-IncidentTable
ISOLATION_SG_ID = sg-xxxxxxxxxxxxxxxxx
REGION = ap-southeast-1
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
Lambda cÃ³ Ä‘á»§ thÃ´ng tin Ä‘á»ƒ ghi evidence, cáº­p nháº­t incident vÃ  cÃ´ láº­p EC2.
```

![Lambda Environment Variables](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/lambda-environment-variables.png)

---

#### BÆ°á»›c 6: ThÃªm code cho Incident Response Lambda

Trong tab **Code** cá»§a Lambda, thay ná»™i dung máº·c Ä‘á»‹nh báº±ng code sau.

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

Sau khi dÃ¡n code, chá»n:

```text
Deploy
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
Incident Response Lambda Ä‘Æ°á»£c deploy thÃ nh cÃ´ng.
```

---

#### BÆ°á»›c 7: Táº¡o Test Event cho Lambda

Trong Lambda, chá»n:

```text
Test â†’ Create new event
```

Äáº·t tÃªn event:

```text
cloudsoc-critical-finding-test
```

DÃ¡n sample event sau. Thay `i-xxxxxxxxxxxxxxxxx` báº±ng EC2 Instance ID cá»§a báº¡n.

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

Káº¿t quáº£ mong Ä‘á»£i:

```text
Test event Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![Lambda Test Event](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/response-lambda-test-event.png)

---

#### BÆ°á»›c 8: Cháº¡y Lambda Test

Chá»n:

```text
Test
```

Náº¿u Lambda cháº¡y thÃ nh cÃ´ng, káº¿t quáº£ tráº£ vá» sáº½ cÃ³ cÃ¡c thÃ´ng tin:

```text
incidentId
resourceId
ssmCommandId
snapshotIds
isolationSecurityGroupId
incidentStatus = Isolated
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
Lambda cháº¡y thÃ nh cÃ´ng vÃ  báº¯t Ä‘áº§u quy trÃ¬nh thu tháº­p evidence, táº¡o snapshot vÃ  cÃ´ láº­p EC2.
```

![Lambda Test Result](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/response-lambda-test-result.png)

---

#### BÆ°á»›c 9: Kiá»ƒm tra Systems Manager Run Command

Sau khi Lambda cháº¡y, vÃ o:

```text
Systems Manager â†’ Run Command â†’ Command history
```

TÃ¬m command má»›i nháº¥t Ä‘Æ°á»£c táº¡o bá»Ÿi Lambda.

Kiá»ƒm tra:

```text
Status = Success
Target = cloudsoc-workload-ec2
Document = AWS-RunShellScript
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
SSM Run Command Ä‘Ã£ cháº¡y thÃ nh cÃ´ng trÃªn EC2 workload.
```

![SSM Command Output](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/ssm-command-output.png)

---

#### BÆ°á»›c 10: Kiá»ƒm tra Evidence trong S3

VÃ o evidence bucket:

```text
S3 â†’ cloudsoc-evidence-<account-id>
```

Kiá»ƒm tra cÃ¡c thÆ° má»¥c:

```text
incidents/
forensics/
```

Trong thÆ° má»¥c `incidents/`, báº¡n sáº½ tháº¥y cÃ¡c file metadata nhÆ°:

```text
guardduty-event.json
response-summary.json
```

Trong thÆ° má»¥c `forensics/`, báº¡n sáº½ tháº¥y output tá»« SSM Run Command.

Káº¿t quáº£ mong Ä‘á»£i:

```text
Evidence vÃ  forensic output Ä‘Æ°á»£c lÆ°u trong S3 Evidence Bucket.
```

![S3 Evidence Objects](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/s3-evidence-objects.png)

---

#### BÆ°á»›c 11: Kiá»ƒm tra EBS Snapshot

VÃ o:

```text
EC2 â†’ Elastic Block Store â†’ Snapshots
```

TÃ¬m snapshot cÃ³ tag:

```text
Project = AWS-CloudSOC
Purpose = Forensics
IncidentId = <incident-id>
SourceInstanceId = <instance-id>
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
EBS Snapshot phá»¥c vá»¥ forensic investigation Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![EBS Forensic Snapshot](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/ebs-forensic-snapshot.png)

---

#### BÆ°á»›c 12: Kiá»ƒm tra EC2 Ä‘Ã£ bá»‹ cÃ´ láº­p

VÃ o:

```text
EC2 â†’ Instances â†’ cloudsoc-workload-ec2 â†’ Security
```

Kiá»ƒm tra Security Group hiá»‡n táº¡i.

TrÆ°á»›c khi pháº£n á»©ng:

```text
SG-Workload
```

Sau khi Lambda cháº¡y:

```text
SG-Isolation
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
EC2 Ä‘Ã£ Ä‘Æ°á»£c thay Security Group sang SG-Isolation.
```

![EC2 After Isolation SG](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/ec2-after-isolation-sg.png)

---

#### BÆ°á»›c 13: Kiá»ƒm tra DynamoDB Incident Status

VÃ o:

```text
DynamoDB â†’ Tables â†’ CloudSOC-IncidentTable â†’ Explore table items
```

TÃ¬m incident Ä‘Æ°á»£c Lambda táº¡o hoáº·c cáº­p nháº­t.

Kiá»ƒm tra cÃ¡c trÆ°á»ng:

```text
incidentStatus = Isolated
approvalStatus = Approved
responseMode = AutoResponse
resourceId = <instance-id>
snapshotIds = [...]
ssmCommandId = <command-id>
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
DynamoDB ghi nháº­n incident Ä‘Ã£ Ä‘Æ°á»£c xá»­ lÃ½ vÃ  EC2 Ä‘Ã£ bá»‹ cÃ´ láº­p.
```

![DynamoDB Incident Updated](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/dynamodb-incident-updated.png)

---

#### BÆ°á»›c 14: TÃ­ch há»£p Lambda vÃ o Step Functions

Sau khi Lambda hoáº¡t Ä‘á»™ng, cáº­p nháº­t Step Functions Ä‘á»ƒ nhÃ¡nh **Auto Response** gá»i Lambda thay vÃ¬ chá»‰ dÃ¹ng placeholder.

Luá»“ng mong muá»‘n:

```text
Evaluate Finding
â†’ Auto Response
â†’ Incident Response Lambda
â†’ End
```

Trong Step Functions Workflow Studio, thay state:

```text
Response Actions Placeholder
```

báº±ng action:

```text
Lambda Invoke
```

Chá»n Lambda function:

```text
cloudsoc-incident-response-lambda
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
Step Functions cÃ³ thá»ƒ gá»i Incident Response Lambda khi finding Ä‘á»§ Ä‘iá»u kiá»‡n Auto Response.
```

![Step Functions Lambda Integration](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/stepfunctions-lambda-integration.png)

---

#### BÆ°á»›c 15: KhÃ´i phá»¥c EC2 vá» SG-Workload sau khi test

Sau khi test xong, Ä‘á»ƒ trÃ¡nh máº¥t káº¿t ná»‘i hoáº·c áº£nh hÆ°á»Ÿng cÃ¡c pháº§n sau, nÃªn Ä‘Æ°a EC2 vá» Security Group ban Ä‘áº§u.

VÃ o:

```text
EC2 â†’ Instances â†’ cloudsoc-workload-ec2 â†’ Actions â†’ Security â†’ Change security groups
```

Thay:

```text
SG-Isolation
```

vá»:

```text
SG-Workload
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
EC2 Ä‘Æ°á»£c khÃ´i phá»¥c vá» Security Group ban Ä‘áº§u Ä‘á»ƒ tiáº¿p tá»¥c workshop.
```

---

#### Kiá»ƒm tra sau khi hoÃ n thÃ nh

Sau khi hoÃ n thÃ nh pháº§n nÃ y, kiá»ƒm tra láº¡i cÃ¡c má»¥c sau:

- [ ] EC2 cÃ³ tag `AutoIsolate=true`.
- [ ] `SG-Isolation` khÃ´ng cÃ³ inbound vÃ  outbound rule.
- [ ] IAM Role `CloudSOC-Incident-Response-Lambda-Role` Ä‘Ã£ Ä‘Æ°á»£c táº¡o.
- [ ] Lambda `cloudsoc-incident-response-lambda` Ä‘Ã£ Ä‘Æ°á»£c táº¡o.
- [ ] Lambda cÃ³ environment variables Ä‘Ãºng.
- [ ] Lambda cÃ³ thá»ƒ Ä‘á»c GuardDuty event máº«u.
- [ ] Systems Manager Run Command cháº¡y thÃ nh cÃ´ng.
- [ ] Evidence Ä‘Æ°á»£c lÆ°u vÃ o S3.
- [ ] EBS Snapshot Ä‘Æ°á»£c táº¡o.
- [ ] EC2 Ä‘Æ°á»£c thay Security Group sang `SG-Isolation`.
- [ ] DynamoDB incident Ä‘Æ°á»£c cáº­p nháº­t tráº¡ng thÃ¡i.
- [ ] Step Functions cÃ³ thá»ƒ gá»i Incident Response Lambda.

---

#### Káº¿t quáº£ sau khi hoÃ n thÃ nh

Sau khi hoÃ n thÃ nh pháº§n nÃ y, AWS CloudSOC Ä‘Ã£ cÃ³ kháº£ nÄƒng pháº£n á»©ng sá»± cá»‘ tá»± Ä‘á»™ng á»Ÿ má»©c lab.

CÃ¡c thÃ nh pháº§n Ä‘Ã£ sáºµn sÃ ng gá»“m:

```text
AWS Lambda
AWS Systems Manager
Amazon EBS Snapshot
Amazon S3 Evidence Bucket
Amazon DynamoDB
EC2 Security Group Isolation
AWS Step Functions Integration
```

Khi finding Ä‘á»§ Ä‘iá»u kiá»‡n xá»­ lÃ½ tá»± Ä‘á»™ng, Lambda sáº½ thu tháº­p báº±ng chá»©ng, táº¡o snapshot, lÆ°u metadata, cáº­p nháº­t incident vÃ  thay Security Group cá»§a EC2 sang `SG-Isolation`.

---

#### TÃ³m táº¯t

Trong pháº§n nÃ y, chÃºng ta Ä‘Ã£ triá»ƒn khai quy trÃ¬nh Forensics, Snapshot and Isolation cho AWS CloudSOC. Quy trÃ¬nh nÃ y giÃºp SOC Analyst vÃ  há»‡ thá»‘ng CloudSOC cÃ³ thá»ƒ pháº£n á»©ng nhanh vá»›i incident, Ä‘á»“ng thá»i váº«n lÆ°u láº¡i báº±ng chá»©ng phá»¥c vá»¥ Ä‘iá»u tra sau sá»± cá»‘.

á»ž pháº§n tiáº¿p theo, chÃºng ta sáº½ triá»ƒn khai **Notification and Alerting** Ä‘á»ƒ gá»­i thÃ´ng bÃ¡o káº¿t quáº£ xá»­ lÃ½ incident qua SNS, Email, SMS hoáº·c Slack.