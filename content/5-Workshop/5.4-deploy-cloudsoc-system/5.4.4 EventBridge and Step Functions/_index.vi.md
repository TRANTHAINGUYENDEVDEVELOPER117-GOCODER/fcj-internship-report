---
title : "EventBridge and Step Functions Workflow"
date : 2026-07-01
weight : 4
chapter : false
pre : " <b> 5.4.4. </b> "
---

#### EventBridge and Step Functions Workflow

Trong phần này, chúng ta sẽ cấu hình **Amazon EventBridge** và **AWS Step Functions** để xây dựng luồng xử lý sự cố theo mô hình event-driven cho hệ thống AWS CloudSOC.

Khi Amazon GuardDuty tạo security finding, Amazon EventBridge sẽ nhận event và kích hoạt AWS Step Functions. Step Functions sau đó sẽ điều phối quy trình phản ứng sự cố như đánh giá finding, xác định mức độ nghiêm trọng, chọn nhánh xử lý và chuẩn bị các bước phản ứng tiếp theo.

---

#### Mục tiêu

Sau khi hoàn thành phần này, bạn sẽ có:

+ Một AWS Step Functions State Machine cho quy trình xử lý incident.
+ Một IAM Role cho phép Step Functions thực thi workflow.
+ Một Amazon EventBridge Rule để bắt GuardDuty findings.
+ EventBridge có thể kích hoạt Step Functions khi có GuardDuty finding.
+ Workflow có các nhánh xử lý: Alert Only, Approval Required và Auto Response.
+ CloudSOC sẵn sàng cho các phần tiếp theo như Dashboard Approval, Forensics, Snapshot và Isolation.

---

#### Kiến trúc EventBridge and Step Functions

Sơ đồ sau minh họa luồng EventBridge và Step Functions trong hệ thống AWS CloudSOC.

![EventBridge and Step Functions Architecture](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/eventbridge-stepfunctions-architecture.png)

Luồng xử lý chính:

```text
Amazon GuardDuty Finding
→ Amazon EventBridge Rule
→ AWS Step Functions State Machine
→ Evaluate Finding
→ Alert Only / Approval Required / Auto Response
```

Trong kiến trúc này, GuardDuty đóng vai trò nguồn phát hiện mối đe dọa. EventBridge đóng vai trò router để chuyển finding đến Step Functions. Step Functions đóng vai trò bộ điều phối phản ứng sự cố.

---

#### Thông tin cấu hình đề xuất

Bạn có thể sử dụng các thông tin cấu hình sau cho workshop:

| Thành phần | Giá trị đề xuất |
|---|---|
| EventBridge Rule Name | `cloudsoc-guardduty-finding-rule` |
| Event Source | `aws.guardduty` |
| Detail Type | `GuardDuty Finding` |
| Step Functions Name | `cloudsoc-incident-response-workflow` |
| Step Functions Log Group | `/aws/states/cloudsoc-incident-response-workflow` |
| Step Functions IAM Role | `CloudSOC-StepFunctions-Workflow-Role` |
| EventBridge IAM Role | `CloudSOC-EventBridge-StepFunctions-Role` |
| Workflow Type | Standard |
| Main Branches | Alert Only, Approval Required, Auto Response |

---

#### Bước 1: Tạo IAM Role cho Step Functions

AWS Step Functions cần một IAM Role để thực thi workflow và gọi các dịch vụ khác trong các phần sau như Lambda, SNS, Systems Manager, DynamoDB và S3.

Mở dịch vụ **IAM**, chọn:

```text
Roles → Create role
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Trusted entity type | AWS service |
| Use case | Step Functions |

Đặt tên role:

```text
CloudSOC-StepFunctions-Workflow-Role
```

Trong môi trường lab, bạn có thể gắn các quyền cần thiết theo từng bước triển khai. Ở các phần sau, role này có thể cần quyền:

+ Invoke Lambda functions
+ Publish SNS messages
+ Start Systems Manager commands
+ Read and write DynamoDB incident records
+ Put evidence metadata to Amazon S3
+ Create or reference EBS Snapshot metadata
+ Write execution logs to CloudWatch Logs

Kết quả mong đợi:

```text
IAM Role CloudSOC-StepFunctions-Workflow-Role được tạo thành công.
```

![Step Functions IAM Role](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/stepfunctions-execution-role.png)

---

#### Bước 2: Tạo CloudWatch Log Group cho Step Functions

CloudWatch Logs được sử dụng để lưu execution logs của Step Functions. Điều này giúp kiểm tra workflow có chạy đúng hay không.

Mở dịch vụ **Amazon CloudWatch**, chọn:

```text
Logs → Log groups → Create log group
```

Nhập tên log group:

```text
/aws/states/cloudsoc-incident-response-workflow
```

Chọn retention phù hợp cho môi trường lab, ví dụ:

```text
7 days
```

Kết quả mong đợi:

```text
CloudWatch Log Group cho Step Functions được tạo thành công.
```

---

#### Bước 3: Tạo Step Functions State Machine

Mở dịch vụ **AWS Step Functions**, chọn:

```text
State machines → Create state machine
```

Chọn:

```text
Write your workflow in code
```

Chọn workflow type:

```text
Standard
```

Đặt tên State Machine:

```text
cloudsoc-incident-response-workflow
```

![Create State Machine](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/create-state-machine.png)

---

#### Bước 4: Khai báo workflow logic

Trong phần definition của Step Functions, sử dụng workflow mẫu sau.

Workflow này dùng để mô phỏng logic xử lý ban đầu. Các hành động thực tế như gửi SNS, gọi Lambda, thu thập evidence, tạo snapshot và cô lập EC2 sẽ được triển khai chi tiết ở các phần tiếp theo.

```json
{
  "Comment": "AWS CloudSOC Incident Response Workflow",
  "StartAt": "Evaluate Finding",
  "States": {
    "Evaluate Finding": {
      "Type": "Choice",
      "Choices": [
        {
          "And": [
            {
              "Variable": "$.detail.resource.resourceType",
              "StringEquals": "Instance"
            },
            {
              "Variable": "$.detail.severity",
              "NumericGreaterThanEquals": 8
            }
          ],
          "Next": "Auto Response"
        },
        {
          "And": [
            {
              "Variable": "$.detail.resource.resourceType",
              "StringEquals": "Instance"
            },
            {
              "Variable": "$.detail.severity",
              "NumericGreaterThanEquals": 7
            }
          ],
          "Next": "Approval Required"
        }
      ],
      "Default": "Alert Only"
    },
    "Alert Only": {
      "Type": "Pass",
      "Result": {
        "responseMode": "AlertOnly",
        "message": "Finding does not require isolation. Alert only."
      },
      "End": true
    },
    "Approval Required": {
      "Type": "Pass",
      "Result": {
        "responseMode": "ApprovalRequired",
        "message": "High severity finding requires SOC Analyst approval."
      },
      "Next": "Wait For Approval Placeholder"
    },
    "Wait For Approval Placeholder": {
      "Type": "Pass",
      "Result": {
        "approvalStatus": "Pending",
        "message": "Approval flow will be implemented in the Dashboard section."
      },
      "End": true
    },
    "Auto Response": {
      "Type": "Pass",
      "Result": {
        "responseMode": "AutoResponse",
        "message": "Critical finding is eligible for automated response."
      },
      "Next": "Response Actions Placeholder"
    },
    "Response Actions Placeholder": {
      "Type": "Pass",
      "Result": {
        "actions": [
          "Collect forensic evidence",
          "Create EBS snapshot",
          "Apply SG-Isolation",
          "Update DynamoDB",
          "Send SNS notification"
        ],
        "message": "Detailed response actions will be implemented in later sections."
      },
      "End": true
    }
  }
}
```

> **Lưu ý:** Đây là workflow nền tảng để kiểm tra EventBridge và Step Functions. Các bước thực thi thật như Lambda, Systems Manager, EBS Snapshot và SNS sẽ được tích hợp trong các phần sau.

Kết quả mong đợi:

```text
State Machine cloudsoc-incident-response-workflow được tạo thành công.
```

![State Machine Graph](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/state-machine-graph.png)

---

#### Bước 5: Cấu hình Logging cho Step Functions

Trong quá trình tạo State Machine, bật logging để dễ kiểm tra lỗi.

Cấu hình đề xuất:

| Mục | Giá trị |
|---|---|
| Logging | Enabled |
| Log level | ALL |
| Include execution data | Enabled |
| Log group | `/aws/states/cloudsoc-incident-response-workflow` |

Kết quả mong đợi:

```text
Step Functions execution logs được gửi đến CloudWatch Logs.
```

---

#### Bước 6: Test State Machine thủ công

Trước khi kết nối với EventBridge, nên test State Machine bằng sample input.

Trong Step Functions, chọn State Machine:

```text
cloudsoc-incident-response-workflow
```

Chọn:

```text
Start execution
```

Dùng sample input sau để mô phỏng GuardDuty finding mức Critical:

```json
{
  "version": "0",
  "id": "sample-guardduty-event",
  "detail-type": "GuardDuty Finding",
  "source": "aws.guardduty",
  "account": "123456789012",
  "region": "ap-southeast-1",
  "detail": {
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
Workflow chạy vào nhánh Auto Response.
Execution status là Succeeded.
```

![Test State Machine Execution](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/test-state-machine-execution.png)

---

#### Bước 7: Test nhánh Approval Required

Tiếp tục test với sample input mức High:

```json
{
  "version": "0",
  "id": "sample-guardduty-event-high",
  "detail-type": "GuardDuty Finding",
  "source": "aws.guardduty",
  "account": "123456789012",
  "region": "ap-southeast-1",
  "detail": {
    "severity": 7.2,
    "type": "Recon:EC2/PortProbeUnprotectedPort",
    "title": "Sample GuardDuty finding requiring approval",
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
Workflow chạy vào nhánh Approval Required.
Execution status là Succeeded.
```

---

#### Bước 8: Test nhánh Alert Only

Test với sample input mức Low hoặc Medium:

```json
{
  "version": "0",
  "id": "sample-guardduty-event-medium",
  "detail-type": "GuardDuty Finding",
  "source": "aws.guardduty",
  "account": "123456789012",
  "region": "ap-southeast-1",
  "detail": {
    "severity": 4.5,
    "type": "Recon:EC2/Portscan",
    "title": "Sample GuardDuty finding for alert only",
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
Workflow chạy vào nhánh Alert Only.
Execution status là Succeeded.
```

---

#### Bước 9: Tạo IAM Role cho EventBridge

Amazon EventBridge cần quyền để start execution của Step Functions.

Mở dịch vụ **IAM**, chọn:

```text
Roles → Create role
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Trusted entity type | AWS service |
| Use case | EventBridge |

Đặt tên role:

```text
CloudSOC-EventBridge-StepFunctions-Role
```

Role này cần quyền:

```text
states:StartExecution
```

Resource là State Machine:

```text
cloudsoc-incident-response-workflow
```

Kết quả mong đợi:

```text
EventBridge có quyền kích hoạt Step Functions State Machine.
```

---

#### Bước 10: Tạo EventBridge Rule cho GuardDuty Findings

Mở dịch vụ **Amazon EventBridge**, chọn:

```text
Rules → Create rule
```

Cấu hình rule:

| Mục | Giá trị |
|---|---|
| Name | `cloudsoc-guardduty-finding-rule` |
| Description | `Trigger CloudSOC workflow when GuardDuty finding is generated` |
| Event bus | default |
| Rule type | Rule with an event pattern |

![Create EventBridge Rule](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/create-eventbridge-rule.png)

---

#### Bước 11: Cấu hình Event Pattern

Ở phần Event pattern, chọn:

```text
Custom pattern JSON
```

Nhập pattern sau:

```json
{
  "source": ["aws.guardduty"],
  "detail-type": ["GuardDuty Finding"]
}
```

Event pattern này sẽ bắt tất cả GuardDuty findings trong Region hiện tại.

Kết quả mong đợi:

```text
EventBridge rule có thể match GuardDuty findings.
```

![EventBridge Rule Pattern](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/eventbridge-rule-pattern.png)

---

#### Bước 12: Chọn Target là Step Functions

Ở phần Target, chọn:

```text
AWS service
```

Chọn target type:

```text
Step Functions state machine
```

Chọn State Machine:

```text
cloudsoc-incident-response-workflow
```

Chọn execution role:

```text
CloudSOC-EventBridge-StepFunctions-Role
```

Sau đó chọn:

```text
Create rule
```

Kết quả mong đợi:

```text
EventBridge rule được tạo và target là Step Functions State Machine.
```

![EventBridge Target Step Functions](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/eventbridge-target-stepfunctions.png)

---

#### Bước 13: Kiểm tra EventBridge Rule

Sau khi tạo rule, kiểm tra lại rule:

```text
EventBridge → Rules → cloudsoc-guardduty-finding-rule
```

Kiểm tra các thông tin:

+ Event bus là `default`
+ Event pattern có source `aws.guardduty`
+ Target là `cloudsoc-incident-response-workflow`
+ Rule status là Enabled

Kết quả mong đợi:

```text
EventBridge rule đã được bật và sẵn sàng nhận GuardDuty findings.
```

---

#### Bước 14: Kiểm tra GuardDuty Sample Finding kích hoạt Workflow

Nếu bạn đã tạo sample findings trong GuardDuty, EventBridge có thể nhận event và kích hoạt Step Functions.

Kiểm tra tại:

```text
Step Functions → State machines → cloudsoc-incident-response-workflow → Executions
```

Nếu EventBridge đã trigger workflow, bạn sẽ thấy execution mới.

Kết quả mong đợi:

```text
Step Functions có execution được tạo từ GuardDuty finding event.
```

![EventBridge Trigger Execution](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.4-Eventbridge-And-Step-Functions/eventbridge-trigger-execution.png)

> **Lưu ý:** Nếu không thấy execution ngay lập tức, hãy tạo lại GuardDuty sample findings hoặc kiểm tra EventBridge rule pattern và target permission.

---

#### Kiểm tra sau khi hoàn thành

Sau khi hoàn thành phần này, kiểm tra lại các mục sau:

- [ ] Step Functions State Machine `cloudsoc-incident-response-workflow` đã được tạo.
- [ ] Step Functions logging đã được bật.
- [ ] Workflow có các nhánh Alert Only, Approval Required và Auto Response.
- [ ] State Machine có thể chạy thành công với sample input.
- [ ] EventBridge rule `cloudsoc-guardduty-finding-rule` đã được tạo.
- [ ] Event pattern match GuardDuty findings.
- [ ] Target của EventBridge là Step Functions State Machine.
- [ ] EventBridge có quyền `states:StartExecution`.
- [ ] GuardDuty finding có thể kích hoạt Step Functions execution.

---

#### Kết quả sau khi hoàn thành

Sau khi hoàn thành phần này, hệ thống AWS CloudSOC đã có luồng event-driven để xử lý GuardDuty findings.

Các thành phần đã sẵn sàng gồm:

```text
Amazon GuardDuty
Amazon EventBridge
AWS Step Functions
CloudWatch Logs
IAM Roles
```

Khi GuardDuty tạo finding, EventBridge sẽ bắt event và kích hoạt Step Functions. Workflow sẽ đánh giá finding và chọn nhánh xử lý phù hợp dựa trên mức độ nghiêm trọng và loại tài nguyên bị ảnh hưởng.

---

#### Tóm tắt

Trong phần này, chúng ta đã xây dựng luồng xử lý sự cố dựa trên EventBridge và Step Functions. EventBridge đóng vai trò nhận GuardDuty findings, còn Step Functions điều phối logic phản ứng sự cố.

Ở phần tiếp theo, chúng ta sẽ triển khai **Dashboard and Approval Flow** để SOC Analyst có thể xem incident và phê duyệt hoặc từ chối hành động phản ứng.