---
title : "Kiểm thử Auto Isolation"
date : 2026-07-01
weight : 3
chapter : false
pre : " <b> 5.5.3. </b> "
---

#### Kiểm thử Auto Isolation

Trong phần này, chúng ta sẽ kiểm thử chức năng **Auto Isolation** của hệ thống AWS CloudSOC.

Mục tiêu của bài kiểm thử là xác nhận rằng khi một GuardDuty Finding nghiêm trọng liên quan đến EC2 được xử lý, hệ thống có thể tự động thực hiện các hành động phản ứng sự cố như thu thập forensic evidence, tạo EBS Snapshot, cập nhật DynamoDB và cô lập EC2 bằng `SG-Isolation`.

Auto Isolation là phần quan trọng nhất trong quy trình phản ứng sự cố tự động của CloudSOC.

Luồng tổng quan:

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

Trong phần này, chúng ta sử dụng một sample event có kiểm soát để đảm bảo event chứa đúng EC2 instance ID của lab.

---

#### Mục tiêu kiểm thử

Sau khi hoàn thành phần này, chúng ta có thể xác nhận rằng:

+ Incident Response Lambda có thể nhận event mô phỏng GuardDuty Finding.
+ Lambda xác định đúng EC2 instance cần xử lý.
+ Lambda kiểm tra tag `AutoIsolate=true`.
+ Systems Manager có thể thu thập forensic evidence từ EC2.
+ EBS Snapshot được tạo để phục vụ điều tra.
+ Evidence được lưu vào S3 Evidence Bucket.
+ EC2 được thay Security Group từ `SG-Workload` sang `SG-Isolation`.
+ DynamoDB được cập nhật trạng thái incident sau khi cô lập.

---

#### Kiến trúc kiểm thử

Sơ đồ dưới đây mô tả luồng kiểm thử Auto Isolation.

![Test Auto Isolation Flow](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/test-auto-isolation-flow.png)

Luồng kiểm thử gồm các bước chính:

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

#### Bước 1: Kiểm tra EC2 trước khi cô lập

Trước khi thực hiện auto isolation, EC2 workload cần đang ở trạng thái bình thường và sử dụng Security Group ban đầu.

EC2 workload trong lab:

```text
cloudsoc-workload-ec2
```

Trạng thái mong đợi trước khi test:

```text
Instance state: Running
Security Group: SG-Workload
AutoIsolate tag: true
```

![EC2 Before Auto Isolation](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/ec2-before-auto-isolation.png)

Ở thời điểm này, EC2 vẫn chưa bị cô lập. Security Group hiện tại cho thấy instance đang ở trạng thái hoạt động bình thường trước khi hệ thống phản ứng sự cố.

---

#### Bước 2: Chuẩn bị sample GuardDuty event

Để kiểm thử chính xác, một sample GuardDuty event được sử dụng với đúng EC2 instance ID của lab.

Sample event mô phỏng một finding có mức độ nghiêm trọng cao:

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

Sample event này giúp kiểm tra chính xác luồng auto response mà không cần thực hiện hành vi tấn công thật.

![Lambda Auto Isolation Test Event](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/lambda-auto-isolation-test-event.png)

Event có các thông tin quan trọng:

| Field | Ý nghĩa |
|---|---|
| `detail-type` | Loại event là GuardDuty Finding |
| `severity` | Mức độ nghiêm trọng của finding |
| `type` | Loại hành vi bất thường |
| `resourceType` | Tài nguyên bị ảnh hưởng |
| `instanceId` | EC2 instance cần xử lý |

---

#### Bước 3: Chạy Incident Response Lambda

Sau khi chuẩn bị sample event, Incident Response Lambda được chạy để kiểm thử luồng auto isolation.

Lambda sử dụng trong lab:

```text
cloudsoc-incident-response-lambda
```

Khi Lambda được kích hoạt, các bước xử lý chính gồm:

```text
1. Đọc GuardDuty Finding event.
2. Lấy EC2 instance ID từ event.
3. Kiểm tra EC2 instance có tồn tại hay không.
4. Kiểm tra tag AutoIsolate=true.
5. Thu thập forensic evidence bằng Systems Manager.
6. Tạo EBS Snapshot.
7. Lưu evidence vào S3.
8. Thay Security Group của EC2 sang SG-Isolation.
9. Cập nhật incident status vào DynamoDB.
```

![Lambda Auto Isolation Success](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/lambda-auto-isolation-success.png)

Kết quả Lambda thành công cho thấy hệ thống đã xử lý được event và thực hiện các hành động phản ứng sự cố.

---

#### Bước 4: Kiểm tra Systems Manager forensic command

Trong quá trình auto isolation, Lambda sử dụng AWS Systems Manager để chạy command thu thập thông tin forensic cơ bản từ EC2.

Các thông tin forensic có thể bao gồm:

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

![SSM Forensic Command Output](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/ssm-forensic-command-output.png)

Kết quả này xác nhận rằng Systems Manager có thể giao tiếp với EC2 và thực hiện lệnh thu thập bằng chứng.

---

#### Bước 5: Kiểm tra evidence trong S3

Sau khi Lambda xử lý event, evidence được lưu vào S3 Evidence Bucket.

Các object evidence có thể bao gồm:

```text
raw-event.json
response-summary.json
ssm-output/
```

![S3 Auto Isolation Evidence](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/s3-auto-isolation-evidence.png)

S3 Evidence Bucket đóng vai trò lưu trữ bằng chứng phục vụ điều tra sau sự cố. Các file này giúp SOC Analyst xem lại event gốc, kết quả xử lý và dữ liệu forensic thu thập được từ EC2.

---

#### Bước 6: Kiểm tra EBS Forensic Snapshot

Một trong các hành động quan trọng của auto isolation là tạo **EBS Snapshot** từ volume của EC2.

Snapshot giúp lưu lại trạng thái volume tại thời điểm xảy ra incident, phục vụ cho điều tra forensic sau này.

![EBS Forensic Snapshot Created](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/ebs-forensic-snapshot-created.png)

Snapshot được gắn các tag liên quan đến incident, ví dụ:

```text
Project = AWS-CloudSOC
IncidentId = sample-finding-001
SourceInstanceId = i-0aa99a09aeb62061c
Purpose = Forensics
```

Việc tạo snapshot giúp bảo toàn dữ liệu trên volume trước khi thực hiện các bước xử lý tiếp theo.

---

#### Bước 7: Kiểm tra EC2 sau khi cô lập

Sau khi Lambda hoàn tất xử lý, EC2 workload sẽ được thay Security Group từ `SG-Workload` sang `SG-Isolation`.

Trạng thái mong đợi sau khi auto isolation:

```text
Instance state: Running
Security Group: SG-Isolation
Inbound rules: None
Outbound rules: None
```

![EC2 After Auto Isolation](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/ec2-after-auto-isolation.png)

Việc thay Security Group giúp cô lập EC2 khỏi các kết nối không mong muốn. Trong lab này, `SG-Isolation` được cấu hình không có inbound và outbound rules để giảm khả năng EC2 tiếp tục giao tiếp mạng.

---

#### Bước 8: Kiểm tra DynamoDB incident status

Sau khi EC2 được cô lập, DynamoDB Incident Table được cập nhật trạng thái mới.

![DynamoDB Auto Isolation Updated](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/dynamodb-auto-isolation-updated.png)

Kết quả mong đợi:

```text
approvalStatus = Approved
incidentStatus = Isolated
responseMode = AutoResponse
isolationSecurityGroupId = SG-Isolation
snapshotIds = Created
ssmCommandId = Created
evidencePath = S3 path
```

DynamoDB giúp SOC Analyst theo dõi trạng thái xử lý incident và xác nhận rằng auto isolation đã hoàn tất.

---

#### Bước 9: Kiểm tra Step Functions Auto Response execution

Nếu auto isolation được kích hoạt thông qua Step Functions, execution sẽ đi qua nhánh `Auto Response`.

![Step Functions Auto Response Execution](/images/5-Workshop/5.5-Testing-and-validation/5.5.3-Test-Auto-Isolation/stepfunctions-auto-response-execution.png)

Execution thành công xác nhận rằng workflow có thể điều phối incident theo đúng nhánh phản ứng tự động.

Trong trường hợp kiểm thử trực tiếp bằng Lambda test event, ảnh Lambda execution và các kết quả trong EC2, S3, EBS Snapshot, DynamoDB vẫn đủ để chứng minh auto isolation hoạt động.

---

#### Kết quả mong đợi

Sau khi hoàn thành phần này, các kết quả mong đợi gồm:

| Thành phần | Kết quả mong đợi |
|---|---|
| EC2 before test | Instance đang dùng `SG-Workload` |
| Lambda | Xử lý sample GuardDuty event thành công |
| Systems Manager | Chạy forensic command thành công |
| S3 Evidence Bucket | Lưu event và response summary |
| EBS Snapshot | Snapshot được tạo từ volume của EC2 |
| EC2 after test | Instance được thay sang `SG-Isolation` |
| DynamoDB | Incident status được cập nhật thành `Isolated` |
| Step Functions | Auto Response execution thành công hoặc sẵn sàng kiểm thử |

---

#### Bằng chứng kiểm thử

Các bằng chứng kiểm thử trong phần này bao gồm những hình ảnh sau:

| STT | Hình ảnh | Mục đích |
|---|---|---|
| 1 | Auto isolation flow diagram | Mô tả luồng kiểm thử Auto Isolation |
| 2 | EC2 before auto isolation | Xác nhận EC2 đang dùng `SG-Workload` |
| 3 | Lambda test event | Xác nhận event mô phỏng GuardDuty Finding |
| 4 | Lambda success result | Xác nhận Lambda xử lý thành công |
| 5 | SSM forensic command output | Xác nhận forensic command được thực thi |
| 6 | S3 evidence objects | Xác nhận evidence được lưu vào S3 |
| 7 | EBS forensic snapshot | Xác nhận snapshot được tạo |
| 8 | EC2 after auto isolation | Xác nhận EC2 đã chuyển sang `SG-Isolation` |
| 9 | DynamoDB incident update | Xác nhận incident status đã cập nhật |
| 10 | Step Functions auto response execution | Xác nhận workflow auto response |

---

#### Ghi chú

Trong bài kiểm thử này, sample event được dùng thay cho tấn công thật để đảm bảo an toàn cho môi trường lab.

GuardDuty sample findings mặc định có thể không chứa đúng EC2 instance ID của workload trong lab. Vì vậy, việc sử dụng controlled sample event giúp đảm bảo Lambda xử lý đúng tài nguyên cần kiểm thử.

Ngoài ra, EC2 phải có các điều kiện sau để auto isolation hoạt động:

```text
EC2 instance đang running
EC2 có tag AutoIsolate=true
EC2 có IAM Role cho Systems Manager
EC2 đang được quản lý bởi Systems Manager
Lambda có quyền EC2, SSM, S3 và DynamoDB
SG-Isolation tồn tại trong cùng VPC với EC2
```

---

#### Hoàn thành

Bạn đã hoàn thành phần kiểm thử Auto Isolation.

Kết quả của phần này xác nhận rằng hệ thống AWS CloudSOC có thể tự động xử lý incident nghiêm trọng bằng cách thu thập evidence, tạo forensic snapshot, cập nhật trạng thái incident và cô lập EC2 bằng `SG-Isolation`.

Đây là bước xác nhận quan trọng nhất cho khả năng phản ứng sự cố tự động của hệ thống CloudSOC.