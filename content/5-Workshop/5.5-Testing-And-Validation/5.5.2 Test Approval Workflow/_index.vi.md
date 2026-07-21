---
title : "Kiểm thử Approval Workflow"
date : 2026-07-01
weight : 2
chapter : false
pre : " <b> 5.5.2. </b> "
---

#### Kiểm thử Approval Workflow

Trong phần này, chúng ta sẽ kiểm thử luồng **Approval Workflow** của hệ thống AWS CloudSOC.

Mục tiêu của bài kiểm thử là xác nhận rằng khi một security finding có mức độ nghiêm trọng cao nhưng cần sự xác nhận của SOC Analyst, hệ thống có thể đưa incident vào trạng thái chờ phê duyệt. Sau đó, SOC Analyst có thể xem incident trên dashboard và chọn **Approve** hoặc **Reject**.

Approval Workflow giúp tránh việc hệ thống tự động cô lập EC2 trong mọi trường hợp. Thay vào đó, các sự cố cần đánh giá thêm sẽ được chuyển sang trạng thái chờ phê duyệt.

Luồng tổng quan:

```text
GuardDuty Finding
→ EventBridge
→ Step Functions
→ Approval Required
→ DynamoDB Incident Table
→ SOC Dashboard
→ Approve / Reject
→ Update Incident Status
```

Trong phần này, trọng tâm là kiểm tra quá trình chuyển đổi trạng thái của incident từ `Pending` sang `Approved` hoặc `Rejected`.

---

#### Mục tiêu kiểm thử

Sau khi hoàn thành phần này, chúng ta có thể xác nhận rằng:

+ Incident có thể được tạo với trạng thái chờ phê duyệt.
+ Dashboard có thể hiển thị incident cần SOC Analyst xử lý.
+ SOC Analyst có thể chọn **Approve** hoặc **Reject** trên dashboard.
+ Trạng thái approval được cập nhật trong DynamoDB.
+ Approval Workflow hoạt động như một bước kiểm soát trước khi thực hiện phản ứng tự động.

---

#### Kiến trúc kiểm thử

Sơ đồ dưới đây mô tả luồng kiểm thử Approval Workflow.

![Test Approval Workflow Flow](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/test-approval-workflow-flow.png)

Luồng kiểm thử gồm các bước chính:

```text
Step Functions
→ Approval Required Branch
→ DynamoDB Incident Table
→ SOC Dashboard
→ SOC Analyst Approval
→ DynamoDB Status Update
```

Trong bài kiểm thử này, incident sẽ được đưa vào trạng thái cần phê duyệt. Sau đó, SOC Analyst kiểm tra thông tin trên dashboard và cập nhật quyết định xử lý.

---

#### Bước 1: Kiểm tra nhánh Approval Required

Trong Step Functions workflow, nhánh `Approval Required` được sử dụng cho các finding có mức độ nghiêm trọng cao nhưng chưa đủ điều kiện để thực hiện phản ứng tự động ngay lập tức.

![Step Functions Approval Branch](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/stepfunctions-approval-branch.png)

Nhánh này giúp hệ thống tách biệt giữa ba loại phản ứng:

| Nhánh xử lý | Ý nghĩa |
|---|---|
| Alert Only | Chỉ gửi cảnh báo, không thực hiện hành động cô lập |
| Approval Required | Cần SOC Analyst phê duyệt trước khi xử lý |
| Auto Response | Tự động xử lý khi finding đủ điều kiện |

Trong bài kiểm thử này, chúng ta tập trung vào nhánh:

```text
Approval Required
```

---

#### Bước 2: Tạo incident ở trạng thái Pending

Một incident mẫu được tạo trong DynamoDB để mô phỏng finding cần phê duyệt.

Incident này có trạng thái ban đầu là:

```text
approvalStatus = Pending
incidentStatus = WaitingApproval
responseMode = ApprovalRequired
```

![Pending Incident in DynamoDB](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/incident-pending-in-dynamodb.png)

Ví dụ dữ liệu incident:

| Field | Example |
|---|---|
| incidentId | INC-001 |
| findingType | UnauthorizedAccess:EC2/SSHBruteForce |
| severity | 7.5 |
| resourceId | EC2 instance ID |
| responseMode | ApprovalRequired |
| approvalStatus | Pending |
| incidentStatus | WaitingApproval |

Trạng thái `Pending` cho biết incident đang chờ SOC Analyst xem xét trước khi thực hiện hành động tiếp theo.

---

#### Bước 3: Kiểm tra incident trên SOC Dashboard

Sau khi incident được ghi vào DynamoDB, dashboard sẽ đọc dữ liệu từ Incident Table và hiển thị incident cho SOC Analyst.

![Dashboard Pending Incident](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/dashboard-pending-incident.png)

Dashboard hiển thị các thông tin chính của incident, bao gồm:

```text
Incident ID
Finding Type
Severity
Resource ID
Response Mode
Approval Status
Incident Status
```

Ở trạng thái ban đầu, dashboard hiển thị:

```text
Approval Status: Pending
Incident Status: WaitingApproval
```

Điều này xác nhận rằng dashboard đã đọc đúng dữ liệu incident từ DynamoDB.

---

#### Bước 4: SOC Analyst thực hiện Approve

SOC Analyst kiểm tra nội dung incident và chọn hành động **Approve** trên dashboard.

![Dashboard Approve Action](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/dashboard-approve-action.png)

Khi chọn **Approve**, dashboard gửi request đến backend API để cập nhật trạng thái incident.

Luồng xử lý:

```text
SOC Analyst
→ Click Approve
→ API Gateway
→ Dashboard API Lambda
→ DynamoDB Incident Table
```

Sau khi xử lý thành công, approval status của incident sẽ được cập nhật.

---

#### Bước 5: Kiểm tra DynamoDB sau khi Approve

Sau khi SOC Analyst chọn **Approve**, DynamoDB được kiểm tra để xác nhận trạng thái đã được cập nhật.

![DynamoDB Approval Updated](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/dynamodb-approval-updated.png)

Kết quả mong đợi:

```text
approvalStatus = Approved
incidentStatus = Approved
```

Hoặc trong một số thiết kế workflow:

```text
approvalStatus = Approved
incidentStatus = InProgress
```

Trạng thái `Approved` xác nhận rằng SOC Analyst đã cho phép incident tiếp tục đi vào bước xử lý tiếp theo.

---

#### Bước 6: Kiểm tra dashboard sau khi cập nhật

Sau khi DynamoDB được cập nhật, dashboard sẽ hiển thị trạng thái mới của incident.

![Dashboard Approved Status](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/dashboard-approved-status.png)

Dashboard lúc này thể hiện rằng incident đã được phê duyệt.

Ví dụ trạng thái hiển thị:

```text
Approval Status: Approved
Incident Status: Approved
```

Hoặc:

```text
Approval Status: Approved
Incident Status: InProgress
```

Kết quả này xác nhận rằng approval workflow đã hoạt động đúng từ giao diện dashboard đến DynamoDB.

---

#### Bước 7: Kiểm thử Reject Workflow

Ngoài hành động **Approve**, SOC Analyst cũng có thể chọn **Reject** nếu incident không đủ điều kiện để tiếp tục xử lý.

![Dashboard Reject Action](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/dashboard-reject-action.png)

Luồng xử lý Reject:

```text
SOC Analyst
→ Click Reject
→ API Gateway
→ Dashboard API Lambda
→ DynamoDB Incident Table
```

Sau khi Reject, trạng thái mong đợi là:

```text
approvalStatus = Rejected
incidentStatus = Closed
```

Hoặc:

```text
approvalStatus = Rejected
incidentStatus = Rejected
```

![DynamoDB Rejected Status](/images/5-Workshop/5.5-Testing-and-validation/5.5.2-Test-Approval-Workflow/dynamodb-rejected-status.png)

Trạng thái `Rejected` xác nhận rằng incident không tiếp tục đi vào bước auto response.

---

#### Kết quả mong đợi

Sau khi hoàn thành phần này, các kết quả mong đợi gồm:

| Thành phần | Kết quả mong đợi |
|---|---|
| Step Functions | Có nhánh `Approval Required` |
| DynamoDB | Có incident ở trạng thái `Pending` |
| Dashboard | Hiển thị incident cần phê duyệt |
| Approve action | Cập nhật `approvalStatus` sang `Approved` |
| Reject action | Cập nhật `approvalStatus` sang `Rejected` |
| Incident status | Thay đổi theo quyết định của SOC Analyst |

---

#### Bằng chứng kiểm thử

Các bằng chứng kiểm thử trong phần này bao gồm những hình ảnh sau:

| STT | Hình ảnh | Mục đích |
|---|---|---|
| 1 | Approval workflow diagram | Mô tả luồng kiểm thử Approval Workflow |
| 2 | Step Functions approval branch | Xác nhận workflow có nhánh Approval Required |
| 3 | Pending incident in DynamoDB | Xác nhận incident đang chờ phê duyệt |
| 4 | Dashboard pending incident | Xác nhận dashboard hiển thị incident |
| 5 | Dashboard approve action | Xác nhận SOC Analyst có thể chọn Approve |
| 6 | DynamoDB approval updated | Xác nhận trạng thái được cập nhật sau Approve |
| 7 | Dashboard approved status | Xác nhận dashboard hiển thị trạng thái mới |
| 8 | Dashboard reject action | Xác nhận SOC Analyst có thể chọn Reject |
| 9 | DynamoDB rejected status | Xác nhận trạng thái được cập nhật sau Reject |

---

#### Ghi chú

Approval Workflow đóng vai trò là lớp kiểm soát giữa phát hiện mối đe dọa và phản ứng tự động.

Trong môi trường thực tế, không phải mọi finding đều nên được xử lý tự động. Một số finding có thể là false positive hoặc cần SOC Analyst đánh giá thêm trước khi cô lập workload.

Trong lab này, Approval Workflow giúp mô phỏng quy trình ra quyết định của SOC Analyst trước khi hệ thống thực hiện các bước response mạnh hơn như:

```text
Collect Evidence
Create EBS Snapshot
Apply SG-Isolation
Send Notification
```

Các hành động phản ứng tự động này sẽ được kiểm thử trong phần tiếp theo:

```text
5.5.3 Test Auto Isolation
```

---

#### Hoàn thành

Bạn đã hoàn thành phần kiểm thử Approval Workflow.

Kết quả của phần này xác nhận rằng hệ thống CloudSOC có thể đưa incident vào trạng thái chờ phê duyệt, hiển thị incident trên dashboard và cập nhật quyết định xử lý của SOC Analyst vào DynamoDB.

Approval Workflow giúp hệ thống phản ứng sự cố an toàn hơn, tránh việc tự động cô lập tài nguyên khi chưa có đủ thông tin xác nhận.