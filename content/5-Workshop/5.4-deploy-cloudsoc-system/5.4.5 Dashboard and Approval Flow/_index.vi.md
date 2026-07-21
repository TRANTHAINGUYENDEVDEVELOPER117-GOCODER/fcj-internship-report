---
title : "Dashboard and Approval Flow"
date : 2026-07-01
weight : 5
chapter : false
pre : " <b> 5.4.5. </b> "
---

#### Dashboard and Approval Flow

Trong phần này, chúng ta sẽ xây dựng lớp **Dashboard and Approval Flow** cho hệ thống AWS CloudSOC. Dashboard giúp SOC Analyst xem danh sách incident, kiểm tra mức độ nghiêm trọng và phê duyệt hoặc từ chối hành động phản ứng sự cố.

Ở các phần trước, GuardDuty đã tạo security finding, EventBridge đã bắt event và Step Functions đã điều phối workflow phản ứng sự cố. Trong phần này, chúng ta bổ sung giao diện quản trị để con người có thể tham gia vào quá trình xử lý các finding có mức độ **High Severity**.

---

#### Mục tiêu

Sau khi hoàn thành phần này, bạn sẽ có:

+ DynamoDB Incident Table để lưu thông tin incident.
+ Cognito User Pool để xác thực SOC Analyst.
+ API Gateway để cung cấp API cho dashboard.
+ Dashboard API Lambda để xử lý yêu cầu từ frontend.
+ Amplify Hosting để triển khai giao diện dashboard.
+ Approval Flow cho phép analyst approve hoặc reject incident.
+ Dashboard sẵn sàng tích hợp với Step Functions và Lambda response workflow.

---

#### Dashboard and Approval Architecture

Sơ đồ sau minh họa kiến trúc Dashboard and Approval Flow trong hệ thống AWS CloudSOC.

![Dashboard and Approval Architecture](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/dashboard-approval-architecture.png)

Luồng xử lý chính:

```text
SOC Analyst
→ Amplify Hosting Dashboard
→ Amazon Cognito Login
→ API Gateway
→ Dashboard API Lambda
→ DynamoDB Incident Table
→ Step Functions Approval Decision
```

Trong kiến trúc này, dashboard không truy cập trực tiếp DynamoDB hoặc S3. Mọi request từ frontend đều đi qua API Gateway và Lambda để đảm bảo kiểm soát quyền truy cập.

---

#### Thông tin cấu hình đề xuất

| Thành phần | Giá trị đề xuất |
|---|---|
| DynamoDB Table | `CloudSOC-IncidentTable` |
| Partition Key | `incidentId` |
| Cognito User Pool | `cloudsoc-analyst-user-pool` |
| Cognito App Client | `cloudsoc-dashboard-client` |
| API Gateway | `cloudsoc-dashboard-api` |
| Lambda Function | `cloudsoc-dashboard-api-lambda` |
| Lambda IAM Role | `CloudSOC-Dashboard-Lambda-Role` |
| Amplify App | `cloudsoc-soc-dashboard` |
| Main Actions | View, Approve, Reject |
| Approval Status | `Pending`, `Approved`, `Rejected` |

---

#### Bước 1: Tạo DynamoDB Incident Table

DynamoDB được sử dụng để lưu thông tin incident do workflow CloudSOC tạo ra. Mỗi incident sẽ có một `incidentId` duy nhất.

Mở dịch vụ **Amazon DynamoDB**, chọn:

```text
Tables → Create table
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Table name | `CloudSOC-IncidentTable` |
| Partition key | `incidentId` |
| Partition key type | String |
| Table settings | Default settings |
| Capacity mode | On-demand |

Kết quả mong đợi:

```text
DynamoDB table CloudSOC-IncidentTable được tạo thành công.
```

![Create Incident Table](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/create-incident-table.png)

---

#### Bước 2: Thiết kế dữ liệu Incident

Mỗi incident có thể có cấu trúc dữ liệu như sau:

```json
{
  "incidentId": "INC-001",
  "findingId": "sample-finding-id",
  "title": "Sample GuardDuty finding for EC2 SSH brute force",
  "severity": 7.5,
  "resourceType": "Instance",
  "resourceId": "i-xxxxxxxxxxxxxxxxx",
  "findingType": "UnauthorizedAccess:EC2/SSHBruteForce",
  "responseMode": "ApprovalRequired",
  "approvalStatus": "Pending",
  "incidentStatus": "Open",
  "createdAt": "2026-07-17T10:00:00Z",
  "updatedAt": "2026-07-17T10:00:00Z"
}
```

Các trường quan trọng:

| Trường | Ý nghĩa |
|---|---|
| `incidentId` | ID của incident |
| `findingId` | ID của GuardDuty finding |
| `severity` | Mức độ nghiêm trọng |
| `resourceId` | EC2 Instance ID hoặc resource liên quan |
| `responseMode` | AlertOnly, ApprovalRequired hoặc AutoResponse |
| `approvalStatus` | Pending, Approved hoặc Rejected |
| `incidentStatus` | Open, InProgress, Closed |

---

#### Bước 3: Thêm Sample Incident vào DynamoDB

Để test dashboard trước khi tích hợp Lambda response thật, bạn có thể thêm một sample incident thủ công.

Vào:

```text
DynamoDB → Tables → CloudSOC-IncidentTable → Explore table items
```

Chọn:

```text
Create item
```

Thêm sample item:

```json
{
  "incidentId": {
    "S": "INC-001"
  },
  "findingId": {
    "S": "sample-guardduty-finding"
  },
  "title": {
    "S": "Sample GuardDuty finding requiring approval"
  },
  "severity": {
    "N": "7.5"
  },
  "resourceType": {
    "S": "Instance"
  },
  "resourceId": {
    "S": "i-xxxxxxxxxxxxxxxxx"
  },
  "findingType": {
    "S": "UnauthorizedAccess:EC2/SSHBruteForce"
  },
  "responseMode": {
    "S": "ApprovalRequired"
  },
  "approvalStatus": {
    "S": "Pending"
  },
  "incidentStatus": {
    "S": "Open"
  }
}
```

Kết quả mong đợi:

```text
Một sample incident có approvalStatus là Pending được tạo trong DynamoDB.
```

![Sample Incident Item](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/sample-incident-item.png)

---

#### Bước 4: Tạo Cognito User Pool

Amazon Cognito được sử dụng để xác thực SOC Analyst trước khi truy cập dashboard.

Mở dịch vụ **Amazon Cognito**, chọn:

```text
User pools → Create user pool
```

Cấu hình đề xuất:

| Mục | Giá trị |
|---|---|
| User pool name | `cloudsoc-analyst-user-pool` |
| Sign-in options | Email |
| MFA | Optional hoặc No MFA cho lab |
| User account recovery | Email |
| App client name | `cloudsoc-dashboard-client` |

Kết quả mong đợi:

```text
Cognito User Pool được tạo thành công.
```

![Cognito User Pool](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/cognito-user-pool.png)

---

#### Bước 5: Tạo SOC Analyst User

Trong Cognito User Pool, tạo user cho SOC Analyst.

Vào:

```text
Cognito → User pools → cloudsoc-analyst-user-pool → Users → Create user
```

Nhập thông tin:

| Mục | Giá trị ví dụ |
|---|---|
| Username | `soc-analyst` |
| Email | Email của bạn |
| Temporary password | Tạo tự động hoặc nhập thủ công |

Kết quả mong đợi:

```text
SOC Analyst user được tạo và có thể đăng nhập dashboard.
```

![Cognito Analyst User](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/cognito-analyst-user.png)

---

#### Bước 6: Tạo IAM Role cho Dashboard Lambda

Dashboard API Lambda cần quyền đọc và cập nhật DynamoDB Incident Table. Trong các bước tích hợp sau, Lambda cũng có thể cần quyền gọi Step Functions.

Mở dịch vụ **IAM**, chọn:

```text
Roles → Create role
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Trusted entity type | AWS service |
| Use case | Lambda |

Đặt tên role:

```text
CloudSOC-Dashboard-Lambda-Role
```

Gắn quyền cơ bản:

+ `AWSLambdaBasicExecutionRole`
+ Quyền đọc/ghi DynamoDB table `CloudSOC-IncidentTable`
+ Quyền gọi Step Functions nếu cần approval callback

Policy DynamoDB mẫu:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:Scan",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem"
      ],
      "Resource": "arn:aws:dynamodb:ap-southeast-1:<account-id>:table/CloudSOC-IncidentTable"
    }
  ]
}
```

Policy Step Functions mẫu:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "states:StartExecution",
        "states:SendTaskSuccess",
        "states:SendTaskFailure"
      ],
      "Resource": "*"
    }
  ]
}
```

Kết quả mong đợi:

```text
IAM Role CloudSOC-Dashboard-Lambda-Role được tạo thành công.
```

![Dashboard Lambda Role](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/dashboard-lambda-role.png)

---

#### Bước 7: Tạo Dashboard API Lambda

Mở dịch vụ **AWS Lambda**, chọn:

```text
Create function
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Function name | `cloudsoc-dashboard-api-lambda` |
| Runtime | Python 3.12 |
| Architecture | x86_64 |
| Execution role | `CloudSOC-Dashboard-Lambda-Role` |

Lambda này sẽ xử lý các API chính:

| Method | Path | Chức năng |
|---|---|---|
| GET | `/incidents` | Lấy danh sách incident |
| GET | `/incidents/{incidentId}` | Xem chi tiết incident |
| POST | `/incidents/{incidentId}/approve` | Phê duyệt incident |
| POST | `/incidents/{incidentId}/reject` | Từ chối incident |

Kết quả mong đợi:

```text
Lambda function cloudsoc-dashboard-api-lambda được tạo thành công.
```

![Create Dashboard Lambda](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/create-dashboard-lambda.png)

---

#### Bước 8: Cấu hình Lambda Environment Variables

Trong Lambda, vào tab:

```text
Configuration → Environment variables
```

Thêm biến môi trường:

| Key | Value |
|---|---|
| `INCIDENT_TABLE` | `CloudSOC-IncidentTable` |
| `REGION` | `ap-southeast-1` |

Kết quả mong đợi:

```text
Lambda có thể đọc tên DynamoDB table từ environment variables.
```

---

#### Bước 9: Tạo API Gateway

Mở dịch vụ **Amazon API Gateway**, chọn:

```text
Create API
```

Chọn:

```text
HTTP API → Build
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| API name | `cloudsoc-dashboard-api` |
| Integration | Lambda |
| Lambda function | `cloudsoc-dashboard-api-lambda` |
| Stage | `$default` |

Kết quả mong đợi:

```text
API Gateway HTTP API được tạo và kết nối với Dashboard Lambda.
```

![Create Dashboard API](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/create-dashboard-api.png)

---

#### Bước 10: Tạo API Routes

Trong API Gateway, tạo các route sau:

| Method | Route |
|---|---|
| GET | `/incidents` |
| GET | `/incidents/{incidentId}` |
| POST | `/incidents/{incidentId}/approve` |
| POST | `/incidents/{incidentId}/reject` |

Tất cả routes trỏ về Lambda:

```text
cloudsoc-dashboard-api-lambda
```

Kết quả mong đợi:

```text
Các API routes cho dashboard được tạo thành công.
```

![API Gateway Routes](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/api-gateway-routes.png)

---

#### Bước 11: Cấu hình Cognito Authorizer cho API Gateway

Để bảo vệ dashboard API, tạo Cognito Authorizer trong API Gateway.

Vào:

```text
API Gateway → cloudsoc-dashboard-api → Authorization → Create authorizer
```

Cấu hình:

| Mục | Giá trị |
|---|---|
| Authorizer type | JWT |
| Identity source | `$request.header.Authorization` |
| Issuer URL | Cognito User Pool issuer URL |
| Audience | Cognito App Client ID |

Sau đó gắn authorizer này vào các route:

```text
GET /incidents
GET /incidents/{incidentId}
POST /incidents/{incidentId}/approve
POST /incidents/{incidentId}/reject
```

Kết quả mong đợi:

```text
Dashboard API được bảo vệ bằng Cognito JWT Authorizer.
```

![API Gateway Cognito Authorizer](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/api-gateway-cognito-authorizer.png)

> **Lưu ý:** Trong môi trường lab, bạn có thể kiểm thử API không có authorizer trước, sau đó bật Cognito Authorizer để hoàn thiện bảo mật.

---

#### Bước 12: Tạo Amplify Hosting cho Dashboard

AWS Amplify Hosting được sử dụng để triển khai giao diện web dashboard cho SOC Analyst.

Mở dịch vụ **AWS Amplify**, chọn:

```text
Create new app
```

Chọn phương thức triển khai phù hợp:

```text
Deploy without Git provider
```

Đặt tên app:

```text
cloudsoc-soc-dashboard
```

Kết quả mong đợi:

```text
Amplify app cloudsoc-soc-dashboard được tạo thành công.
```

![Amplify Hosting Dashboard](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/amplify-hosting-dashboard.png)

---

#### Bước 13: Dashboard UI Functions

Dashboard cần có các chức năng cơ bản sau:

| Chức năng | Mô tả |
|---|---|
| Login | SOC Analyst đăng nhập bằng Cognito |
| Incident List | Hiển thị danh sách incident |
| Incident Detail | Xem chi tiết finding |
| Approve | Phê duyệt phản ứng sự cố |
| Reject | Từ chối phản ứng sự cố |
| Status Tracking | Theo dõi trạng thái incident |

Giao diện dashboard có thể hiển thị các cột:

```text
Incident ID
Finding Type
Severity
Resource ID
Response Mode
Approval Status
Incident Status
Action
```

Kết quả mong đợi:

```text
SOC Analyst có thể xem danh sách incident từ dashboard.
```

![Dashboard Incidents List](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/dashboard-incidents-list.png)

---

#### Bước 14: Approval Action

Khi SOC Analyst chọn **Approve**, frontend sẽ gọi API:

```text
POST /incidents/{incidentId}/approve
```

Lambda sẽ cập nhật DynamoDB:

```text
approvalStatus = Approved
incidentStatus = InProgress
```

Khi SOC Analyst chọn **Reject**, frontend sẽ gọi API:

```text
POST /incidents/{incidentId}/reject
```

Lambda sẽ cập nhật DynamoDB:

```text
approvalStatus = Rejected
incidentStatus = Closed
```

Kết quả mong đợi:

```text
SOC Analyst có thể approve hoặc reject incident từ dashboard.
```

![Dashboard Approval Action](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/dashboard-approval-action.png)

---

#### Bước 15: Kiểm tra DynamoDB sau Approval

Sau khi approve hoặc reject incident, quay lại DynamoDB để kiểm tra item.

Vào:

```text
DynamoDB → Tables → CloudSOC-IncidentTable → Explore table items
```

Kiểm tra các trường:

```text
approvalStatus
incidentStatus
updatedAt
```

Kết quả sau khi approve:

```text
approvalStatus = Approved
incidentStatus = InProgress
```

Kết quả sau khi reject:

```text
approvalStatus = Rejected
incidentStatus = Closed
```

![DynamoDB Approval Updated](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/dynamodb-approval-updated.png)

---

#### Bước 16: Liên kết Approval Flow với Step Functions

Trong kiến trúc hoàn chỉnh, Step Functions sẽ đưa các finding mức High Severity vào trạng thái chờ phê duyệt. Dashboard sẽ cho phép SOC Analyst approve hoặc reject incident.

Luồng approval tổng quát:

```text
Step Functions
→ Create Pending Incident in DynamoDB
→ SOC Analyst opens Dashboard
→ Analyst Approves or Rejects
→ Dashboard Lambda updates DynamoDB
→ Step Functions continues response path
```

Với môi trường lab, phần approval có thể được kiểm thử bằng cách cập nhật DynamoDB trước. Ở phần tiếp theo, các hành động phản ứng thật như thu thập evidence, tạo snapshot và cô lập EC2 sẽ được triển khai.

---

#### Kiểm tra sau khi hoàn thành

Sau khi hoàn thành phần này, kiểm tra lại các mục sau:

- [ ] DynamoDB table `CloudSOC-IncidentTable` đã được tạo.
- [ ] Sample incident đã được thêm vào DynamoDB.
- [ ] Cognito User Pool `cloudsoc-analyst-user-pool` đã được tạo.
- [ ] SOC Analyst user đã được tạo.
- [ ] Lambda `cloudsoc-dashboard-api-lambda` đã được tạo.
- [ ] API Gateway `cloudsoc-dashboard-api` đã được tạo.
- [ ] API routes `/incidents`, `/approve`, `/reject` đã được cấu hình.
- [ ] Amplify Hosting app `cloudsoc-soc-dashboard` đã được tạo.
- [ ] Dashboard có thể hiển thị danh sách incident.
- [ ] SOC Analyst có thể approve hoặc reject incident.
- [ ] DynamoDB cập nhật đúng trạng thái approval.

---

#### Kết quả sau khi hoàn thành

Sau khi hoàn thành phần này, hệ thống AWS CloudSOC có dashboard cơ bản để SOC Analyst theo dõi và xử lý incident.

Các thành phần đã sẵn sàng gồm:

```text
Amazon DynamoDB
Amazon Cognito
Amazon API Gateway
AWS Lambda
AWS Amplify Hosting
AWS Step Functions Approval Flow
```

Dashboard giúp bổ sung yếu tố con người vào quy trình phản ứng sự cố. Các incident mức Low hoặc Medium có thể chỉ gửi cảnh báo, các incident mức Critical có thể tự động phản ứng, còn incident mức High có thể yêu cầu SOC Analyst phê duyệt trước khi thực hiện hành động cô lập.

---

#### Tóm tắt

Trong phần này, chúng ta đã xây dựng lớp Dashboard and Approval Flow cho AWS CloudSOC. SOC Analyst có thể đăng nhập dashboard, xem incident, phê duyệt hoặc từ chối hành động phản ứng.

Ở phần tiếp theo, chúng ta sẽ triển khai **Forensics, Snapshot and Isolation** để thu thập bằng chứng, tạo EBS Snapshot và cô lập EC2 bằng Security Group Isolation.