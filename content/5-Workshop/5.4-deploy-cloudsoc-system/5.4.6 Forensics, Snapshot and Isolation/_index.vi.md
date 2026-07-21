---
title : "Forensics, Snapshot and Isolation"
date : 2026-07-01
weight : 6
chapter : false
pre : " <b> 5.4.6. </b> "
---

#### Forensics, Snapshot and Isolation

Trong phần này, chúng ta sẽ triển khai lớp **Forensics, Snapshot and Isolation** cho hệ thống AWS CloudSOC. Đây là lớp chịu trách nhiệm thu thập bằng chứng, tạo snapshot phục vụ điều tra và cô lập EC2 bị nghi ngờ có dấu hiệu bị tấn công.

Ở các phần trước, GuardDuty đã phát hiện finding, EventBridge đã kích hoạt Step Functions, dashboard đã hỗ trợ phê duyệt incident. Trong phần này, chúng ta triển khai hành động phản ứng thật:

```text
Collect Evidence → Create EBS Snapshot → Apply SG-Isolation → Update Incident Status
```

---

#### Mục tiêu

Sau khi hoàn thành phần này, bạn sẽ có:

+ Lambda function xử lý phản ứng sự cố.
+ IAM Role cho phép Lambda thao tác với EC2, EBS, S3, SSM và DynamoDB.
+ Systems Manager Run Command để thu thập thông tin forensic cơ bản.
+ EBS Snapshot phục vụ điều tra sau sự cố.
+ S3 Evidence Bucket lưu metadata và output điều tra.
+ EC2 workload được cô lập bằng cách thay Security Group sang `SG-Isolation`.
+ DynamoDB incident được cập nhật trạng thái xử lý.

---

#### Forensics, Snapshot and Isolation Architecture

Sơ đồ sau minh họa luồng phản ứng sự cố trong AWS CloudSOC.

![Forensics Snapshot and Isolation Architecture](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/forensics-isolation-architecture.png)

Luồng xử lý chính:

```text
Step Functions
→ Incident Response Lambda
→ Systems Manager Run Command
→ S3 Evidence Bucket
→ EBS Forensic Snapshot
→ Replace EC2 Security Group with SG-Isolation
→ Update DynamoDB Incident Table
```

Trong kiến trúc này, Lambda đóng vai trò điều phối hành động phản ứng. Systems Manager thu thập thông tin trên EC2, EBS Snapshot lưu trạng thái volume, S3 lưu bằng chứng, còn Security Group Isolation giúp cô lập EC2 khỏi luồng traffic không mong muốn.

---

#### Thông tin cấu hình đề xuất

| Thành phần | Giá trị đề xuất |
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

#### Bước 1: Kiểm tra EC2 trước khi cô lập

Trước khi triển khai phản ứng tự động, kiểm tra EC2 workload hiện tại.

Vào:

```text
EC2 → Instances → cloudsoc-workload-ec2
```

Kiểm tra các thông tin:

| Mục | Giá trị |
|---|---|
| Instance state | Running |
| IAM Role | `CloudSOC-EC2-SSM-Role` |
| Security Group hiện tại | `SG-Workload` |
| Tag | `AutoIsolate=true` |
| SSM status | Managed instance |

Kết quả mong đợi:

```text
EC2 đang chạy với SG-Workload và có thể được quản lý bằng Systems Manager.
```

![EC2 Before Isolation SG](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/ec2-before-isolation-sg.png)

---

#### Bước 2: Kiểm tra SG-Isolation

Security Group `SG-Isolation` được dùng để cô lập EC2 khi incident được xác nhận.

Vào:

```text
EC2 → Security Groups → SG-Isolation
```

Kiểm tra:

```text
Inbound rules: không có rule
Outbound rules: không có rule
```

Kết quả mong đợi:

```text
SG-Isolation không cho phép inbound và outbound traffic.
```

![SG Isolation Rules](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/sg-isolation-rules.png)

> **Lưu ý:** Security Group là stateful. Việc thay sang SG-Isolation chủ yếu giúp chặn kết nối mới và cô lập tài nguyên trong môi trường lab.

---

#### Bước 3: Tạo IAM Role cho Incident Response Lambda

Lambda cần quyền để:

+ Đọc thông tin EC2.
+ Gửi SSM Run Command.
+ Tạo EBS Snapshot.
+ Thay Security Group của EC2.
+ Ghi bằng chứng vào S3.
+ Cập nhật DynamoDB incident.

Vào:

```text
IAM → Roles → Create role
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Trusted entity type | AWS service |
| Use case | Lambda |
| Role name | `CloudSOC-Incident-Response-Lambda-Role` |

Gắn policy cơ bản:

```text
AWSLambdaBasicExecutionRole
```

Sau đó tạo thêm inline policy cho lab.

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

Kết quả mong đợi:

```text
IAM Role cho Incident Response Lambda được tạo thành công.
```

![Response Lambda Role](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/response-lambda-role.png)

---

#### Bước 4: Tạo Incident Response Lambda

Vào:

```text
AWS Lambda → Create function
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Function name | `cloudsoc-incident-response-lambda` |
| Runtime | Python 3.12 |
| Architecture | x86_64 |
| Execution role | `CloudSOC-Incident-Response-Lambda-Role` |

Kết quả mong đợi:

```text
Lambda function cloudsoc-incident-response-lambda được tạo thành công.
```

![Create Response Lambda](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/create-response-lambda.png)

---

#### Bước 5: Cấu hình Environment Variables cho Lambda

Trong Lambda, vào:

```text
Configuration → Environment variables → Edit
```

Thêm các biến môi trường sau:

| Key | Value |
|---|---|
| `EVIDENCE_BUCKET` | `cloudsoc-evidence-<account-id>` |
| `INCIDENT_TABLE` | `CloudSOC-IncidentTable` |
| `ISOLATION_SG_ID` | Security Group ID của `SG-Isolation` |
| `REGION` | `ap-southeast-1` |

Ví dụ:

```text
EVIDENCE_BUCKET = cloudsoc-evidence-123456789012
INCIDENT_TABLE = CloudSOC-IncidentTable
ISOLATION_SG_ID = sg-xxxxxxxxxxxxxxxxx
REGION = ap-southeast-1
```

Kết quả mong đợi:

```text
Lambda có đủ thông tin để ghi evidence, cập nhật incident và cô lập EC2.
```

![Lambda Environment Variables](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/lambda-environment-variables.png)

---

#### Bước 6: Thêm code cho Incident Response Lambda

Trong tab **Code** của Lambda, thay nội dung mặc định bằng code sau.

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

Sau khi dán code, chọn:

```text
Deploy
```

Kết quả mong đợi:

```text
Incident Response Lambda được deploy thành công.
```

---

#### Bước 7: Tạo Test Event cho Lambda

Trong Lambda, chọn:

```text
Test → Create new event
```

Đặt tên event:

```text
cloudsoc-critical-finding-test
```

Dán sample event sau. Thay `i-xxxxxxxxxxxxxxxxx` bằng EC2 Instance ID của bạn.

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

Kết quả mong đợi:

```text
Test event được tạo thành công.
```

![Lambda Test Event](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/response-lambda-test-event.png)

---

#### Bước 8: Chạy Lambda Test

Chọn:

```text
Test
```

Nếu Lambda chạy thành công, kết quả trả về sẽ có các thông tin:

```text
incidentId
resourceId
ssmCommandId
snapshotIds
isolationSecurityGroupId
incidentStatus = Isolated
```

Kết quả mong đợi:

```text
Lambda chạy thành công và bắt đầu quy trình thu thập evidence, tạo snapshot và cô lập EC2.
```

![Lambda Test Result](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/response-lambda-test-result.png)

---

#### Bước 9: Kiểm tra Systems Manager Run Command

Sau khi Lambda chạy, vào:

```text
Systems Manager → Run Command → Command history
```

Tìm command mới nhất được tạo bởi Lambda.

Kiểm tra:

```text
Status = Success
Target = cloudsoc-workload-ec2
Document = AWS-RunShellScript
```

Kết quả mong đợi:

```text
SSM Run Command đã chạy thành công trên EC2 workload.
```

![SSM Command Output](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/ssm-command-output.png)

---

#### Bước 10: Kiểm tra Evidence trong S3

Vào evidence bucket:

```text
S3 → cloudsoc-evidence-<account-id>
```

Kiểm tra các thư mục:

```text
incidents/
forensics/
```

Trong thư mục `incidents/`, bạn sẽ thấy các file metadata như:

```text
guardduty-event.json
response-summary.json
```

Trong thư mục `forensics/`, bạn sẽ thấy output từ SSM Run Command.

Kết quả mong đợi:

```text
Evidence và forensic output được lưu trong S3 Evidence Bucket.
```

![S3 Evidence Objects](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/s3-evidence-objects.png)

---

#### Bước 11: Kiểm tra EBS Snapshot

Vào:

```text
EC2 → Elastic Block Store → Snapshots
```

Tìm snapshot có tag:

```text
Project = AWS-CloudSOC
Purpose = Forensics
IncidentId = <incident-id>
SourceInstanceId = <instance-id>
```

Kết quả mong đợi:

```text
EBS Snapshot phục vụ forensic investigation được tạo thành công.
```

![EBS Forensic Snapshot](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/ebs-forensic-snapshot.png)

---

#### Bước 12: Kiểm tra EC2 đã bị cô lập

Vào:

```text
EC2 → Instances → cloudsoc-workload-ec2 → Security
```

Kiểm tra Security Group hiện tại.

Trước khi phản ứng:

```text
SG-Workload
```

Sau khi Lambda chạy:

```text
SG-Isolation
```

Kết quả mong đợi:

```text
EC2 đã được thay Security Group sang SG-Isolation.
```

![EC2 After Isolation SG](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/ec2-after-isolation-sg.png)

---

#### Bước 13: Kiểm tra DynamoDB Incident Status

Vào:

```text
DynamoDB → Tables → CloudSOC-IncidentTable → Explore table items
```

Tìm incident được Lambda tạo hoặc cập nhật.

Kiểm tra các trường:

```text
incidentStatus = Isolated
approvalStatus = Approved
responseMode = AutoResponse
resourceId = <instance-id>
snapshotIds = [...]
ssmCommandId = <command-id>
```

Kết quả mong đợi:

```text
DynamoDB ghi nhận incident đã được xử lý và EC2 đã bị cô lập.
```

![DynamoDB Incident Updated](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/dynamodb-incident-updated.png)

---

#### Bước 14: Tích hợp Lambda vào Step Functions

Sau khi Lambda hoạt động, cập nhật Step Functions để nhánh **Auto Response** gọi Lambda thay vì chỉ dùng placeholder.

Luồng mong muốn:

```text
Evaluate Finding
→ Auto Response
→ Incident Response Lambda
→ End
```

Trong Step Functions Workflow Studio, thay state:

```text
Response Actions Placeholder
```

bằng action:

```text
Lambda Invoke
```

Chọn Lambda function:

```text
cloudsoc-incident-response-lambda
```

Kết quả mong đợi:

```text
Step Functions có thể gọi Incident Response Lambda khi finding đủ điều kiện Auto Response.
```

![Step Functions Lambda Integration](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.6-Forensics-Snapshot-And-Isolation/stepfunctions-lambda-integration.png)

---

#### Bước 15: Khôi phục EC2 về SG-Workload sau khi test

Sau khi test xong, để tránh mất kết nối hoặc ảnh hưởng các phần sau, nên đưa EC2 về Security Group ban đầu.

Vào:

```text
EC2 → Instances → cloudsoc-workload-ec2 → Actions → Security → Change security groups
```

Thay:

```text
SG-Isolation
```

về:

```text
SG-Workload
```

Kết quả mong đợi:

```text
EC2 được khôi phục về Security Group ban đầu để tiếp tục workshop.
```

---

#### Kiểm tra sau khi hoàn thành

Sau khi hoàn thành phần này, kiểm tra lại các mục sau:

- [ ] EC2 có tag `AutoIsolate=true`.
- [ ] `SG-Isolation` không có inbound và outbound rule.
- [ ] IAM Role `CloudSOC-Incident-Response-Lambda-Role` đã được tạo.
- [ ] Lambda `cloudsoc-incident-response-lambda` đã được tạo.
- [ ] Lambda có environment variables đúng.
- [ ] Lambda có thể đọc GuardDuty event mẫu.
- [ ] Systems Manager Run Command chạy thành công.
- [ ] Evidence được lưu vào S3.
- [ ] EBS Snapshot được tạo.
- [ ] EC2 được thay Security Group sang `SG-Isolation`.
- [ ] DynamoDB incident được cập nhật trạng thái.
- [ ] Step Functions có thể gọi Incident Response Lambda.

---

#### Kết quả sau khi hoàn thành

Sau khi hoàn thành phần này, AWS CloudSOC đã có khả năng phản ứng sự cố tự động ở mức lab.

Các thành phần đã sẵn sàng gồm:

```text
AWS Lambda
AWS Systems Manager
Amazon EBS Snapshot
Amazon S3 Evidence Bucket
Amazon DynamoDB
EC2 Security Group Isolation
AWS Step Functions Integration
```

Khi finding đủ điều kiện xử lý tự động, Lambda sẽ thu thập bằng chứng, tạo snapshot, lưu metadata, cập nhật incident và thay Security Group của EC2 sang `SG-Isolation`.

---

#### Tóm tắt

Trong phần này, chúng ta đã triển khai quy trình Forensics, Snapshot and Isolation cho AWS CloudSOC. Quy trình này giúp SOC Analyst và hệ thống CloudSOC có thể phản ứng nhanh với incident, đồng thời vẫn lưu lại bằng chứng phục vụ điều tra sau sự cố.

Ở phần tiếp theo, chúng ta sẽ triển khai **Notification and Alerting** để gửi thông báo kết quả xử lý incident qua SNS, Email, SMS hoặc Slack.