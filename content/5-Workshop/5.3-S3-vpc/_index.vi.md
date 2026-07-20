---
title: "Workshop vẽ sơ đồ kiến trúc CloudSOC"
date: 2026-07-11
weight: 3
chapter: false
pre: " <b> 5.3. </b> "
---

# Workshop: Hướng dẫn vẽ sơ đồ kiến trúc AWS CloudSOC

### Sơ đồ mục tiêu

Sơ đồ bên dưới là phiên bản tham chiếu để nhóm dùng khi vẽ lại bằng draw.io. Khi thực hành, học viên cần bám theo bố cục, vùng màu, service và nhãn mũi tên trong sơ đồ này.

![AWS CloudSOC Architecture](/images/5-Workshop/cloudsoc-architecture.svg)

### Mục tiêu workshop

Sau khi hoàn thành workshop khoảng **2.5 – 3 giờ**, học viên có thể:

- Phân tích yêu cầu SOC thành các nhóm chức năng: Detect, Investigate, Decide, Respond, Contain, Notify.
- Thiết kế architecture diagram có boundary rõ ràng: AWS Cloud, Region, VPC, Subnet.
- Sử dụng draw.io/diagrams.net để vẽ sơ đồ bằng AWS Architecture Icons.
- Dùng màu sắc có ý nghĩa để phân biệt từng vùng chức năng.
- Gắn nhãn mũi tên rõ ràng để người xem hiểu flow trong 30–60 giây.
- Export hình chất lượng cao để đưa vào báo cáo, slide hoặc website Hugo.

### Các module thực hành

1. [Chuẩn bị công cụ vẽ](5.3.1-Prepare/)
2. [Dựng layout tổng thể](5.3.2-Canvas-Layout/)
3. [Vẽ các nhóm dịch vụ AWS](5.3.3-Service-Groups/)
4. [Nối luồng xử lý sự cố](5.3.4-Connect-Flows/)
5. [Export và review sơ đồ](5.3.5-Export-Review/)
6. [Bản đặc tả vẽ sơ đồ chi tiết](5.3.6-Drawing-Spec/)

### Thông tin nhóm thực hiện

| Thành viên | Vai trò trong workshop |
| --- | --- |
| Trần Thái Nguyên | Trình bày kiến trúc, giải thích luồng SOC, tổng hợp tài liệu hướng dẫn |
| Dương Bá Đạt | Hỗ trợ kiểm tra sơ đồ, rà soát service AWS, kiểm tra checklist và tính nhất quán của luồng |

### Chuẩn bị

- Laptop có internet.
- Trình duyệt Chrome/Firefox hoặc draw.io Desktop.
- Truy cập [diagrams.net](https://app.diagrams.net/).
- Bật thư viện AWS icons trong draw.io: **More Shapes → AWS Architecture**.
- Đọc trước phần [Kiến trúc hệ thống & luồng xử lý SOC](../5.2-Prerequiste/).

### Quy ước màu

| Vùng | Màu nền gợi ý | Ý nghĩa |
| --- | --- | --- |
| Dashboard & Access | `#E0F7FA` | Teal, truy cập và dashboard |
| Logging & Evidence | `#E3F2FD` | Xanh dương, log và bằng chứng |
| Threat Detection & Response | `#FFF3E0` | Cam, detection và orchestration |
| Security & Governance | `#FFEBEE` | Đỏ nhạt, IAM/Config/KMS |
| VPC/Workload | `#FFFDE7` | Vàng nhạt, EC2 lab |
| Boundary tổng thể | `#F5F5F5` | Xám nhạt, AWS Cloud/Region |

Màu mũi tên gợi ý:

| Màu mũi tên | Ý nghĩa |
| --- | --- |
| Xám | Logging / audit flow |
| Xanh lá | Read / query |
| Cam | Event-driven workflow |
| Tím | Approval / callback |
| Đỏ | Isolation / response action |

### Phần A: Best practices trước khi vẽ

1. Dùng icon AWS chuẩn, tránh dùng icon chung chung.
2. Luôn có boundary: AWS Cloud → Region → VPC → Subnet.
3. Grouping theo chức năng, không đặt tất cả service rải rác.
4. Mũi tên phải có nhãn hành động cụ thể như `Invoke API`, `Create Snapshot`, `Apply Isolation`.
5. Luồng chính nên đi từ trái sang phải hoặc từ trên xuống dưới.
6. Không để quá nhiều đường chéo cắt nhau.
7. Có legend, version, ngày, tên người thực hiện.

### Phần B: Thực hành vẽ chi tiết

#### Bước 1: Vẽ khung tổng thể & workload layer

1. Tạo diagram mới trong draw.io.
2. Vẽ rectangle lớn màu xám nhạt, đặt tên **AWS Cloud**.
3. Bên trong vẽ rectangle nhỏ hơn, đặt tên **AWS Region: ap-southeast-1**.
4. Vẽ boundary **VPC – CloudSOC Lab VPC**.
5. Bên trong VPC vẽ thêm **Availability Zone** rồi đặt **Public Subnet** bên trong AZ.
6. Đặt icon **Amazon EC2** trong Public Subnet.
7. Tạo hai box nhỏ cạnh EC2:
   - `SG-Workload`: Security Group hiện tại.
   - `SG-Isolation`: Security Group rỗng hoặc deny toàn bộ rule để cô lập.
8. Thêm **Internet**, **Internet Gateway**, **Threat Actor** ở bên trái.
9. Vẽ luồng:

```text
Threat Actor → Internet → Internet Gateway → Amazon EC2
```

Nhãn mũi tên: `Port Scan / SSH Brute-force / Suspicious Traffic`.

10. Thêm một đường nét đứt từ EC2 sang IAM với nhãn `SSM Instance Role` để thể hiện EC2 có role cho Systems Manager.

#### Bước 2: Vẽ vùng Dashboard & Access

1. Tạo rounded rectangle màu teal `#E0F7FA`, tiêu đề **SOC Dashboard & Access**.
2. Kéo các icon:
   - AWS Amplify
   - Amazon Cognito
   - Amazon API Gateway
   - AWS Lambda
   - Amazon DynamoDB
3. Sắp xếp theo thứ tự:

```text
SOC Analyst → Amplify → Cognito → API Gateway → Dashboard API Lambda → DynamoDB
```

4. Gắn nhãn mũi tên:
   - `HTTPS Access`
   - `Sign In`
   - `JWT Authorizer`
   - `Invoke API`
   - `Read / Update Incidents`

5. Từ Dashboard API Lambda vẽ thêm mũi tên đến S3 với nhãn `Get Evidence`.
6. Vẽ mũi tên từ Dashboard API Lambda về Step Functions với nhãn `Approval Callback`.
7. Từ Dashboard API Lambda vẽ mũi tên đến CloudWatch với nhãn `API Logs`.
8. Từ Dashboard API Lambda vẽ mũi tên đến DynamoDB với nhãn `Update Incident`.

#### Bước 3: Vẽ vùng Logging & Evidence Storage

1. Tạo rounded rectangle màu xanh dương `#E3F2FD`, tiêu đề **Logging & Evidence Storage**.
2. Thêm các icon:
   - AWS CloudTrail
   - Amazon CloudWatch
   - Amazon S3
   - Amazon EBS Snapshot
   - CloudWatch Alarm
3. Vẽ luồng:

```text
CloudTrail → S3
CloudTrail → CloudWatch Logs
VPC Flow Logs → CloudWatch Logs
Systems Manager → S3
Systems Manager → EBS Snapshot
Lambda / Step Functions → CloudWatch Logs
CloudWatch Alarm → SNS
```

4. Gắn nhãn:
   - `Audit Logs`
   - `Management Events`
   - `Network Metadata`
   - `Store Forensics`
   - `Create Snapshot`
   - `Execution Logs`
   - `Error Alarm`

#### Bước 4: Vẽ vùng Threat Detection & Response

Đây là phần quan trọng nhất của sơ đồ.

1. Tạo rounded rectangle màu cam `#FFF3E0`, tiêu đề **Threat Detection & Response**.
2. Thêm các icon:
   - Amazon GuardDuty
   - AWS Security Hub
   - Amazon Detective
   - Amazon EventBridge
   - AWS Step Functions
   - AWS Systems Manager
   - AWS Lambda (Incident Response)
   - Amazon SNS
   - Amazon Q Developer
   - Slack Channel
   - Email / SMS
3. Vẽ luồng chính:

```text
GuardDuty → EventBridge → Step Functions
```

4. Từ GuardDuty vẽ thêm:

```text
GuardDuty → Security Hub
GuardDuty → Detective
```

5. Từ Step Functions vẽ các nhánh:

```text
Step Functions → Systems Manager
Step Functions → Incident Response Lambda
Step Functions → SNS
```

6. Nhãn mũi tên:
   - `Security Finding`
   - `Match Event Pattern`
   - `Start Workflow`
   - `Collect Evidence`
   - `Apply Isolation`
   - `Request Approval`

7. Từ SNS vẽ sang Slack/Email/SMS:

```text
SNS → Amazon Q Developer → Slack Channel
SNS → Email / SMS
```

Nhãn: `Approval Request / Incident Alert`.

8. Từ Incident Response Lambda vẽ về EC2:

```text
Incident Response Lambda → Amazon EC2
```

Nhãn mũi tên màu đỏ: `Apply Isolation – Replace Security Group`.

9. Từ Incident Response Lambda vẽ thêm các mũi tên:

```text
Incident Response Lambda → S3
Incident Response Lambda → DynamoDB
Incident Response Lambda → SNS
```

Nhãn:

- `Store SG Before/After`
- `Store Response`
- `Send Result`

10. Vẽ các đường nét đứt từ IAM đến Step Functions, Lambda và EC2:

- `Workflow Role`: IAM → Step Functions.
- `Execution Role`: IAM → Lambda.
- `SSM Instance Role`: IAM → EC2.

#### Bước 5: Vẽ vùng Security, Compliance & Governance

1. Tạo rounded rectangle màu đỏ nhạt `#FFEBEE`, tiêu đề **Security, Compliance & Governance**.
2. Thêm icon:
   - AWS IAM
   - IAM Policy
   - AWS Config
   - AWS KMS
3. Vẽ luồng:

```text
IAM → Lambda / Step Functions / EC2 Role
AWS Config → EC2 / Security Group
KMS → S3 Evidence Bucket
```

4. Gắn nhãn:
   - `Least Privilege Roles`
   - `Configuration Changes`
   - `Encrypt Evidence`

5. Nếu muốn sơ đồ giống hình mẫu hơn, vẽ các đường nét đứt từ vùng Governance sang các service cần quyền:
   - `Execution Role` đến Dashboard API Lambda và Incident Response Lambda.
   - `Workflow Role` đến Step Functions.
   - `SSM Instance Role` đến EC2.
   - `KMS Policy` đến S3 evidence bucket.

#### Bước 6: Thêm policy decision trong sơ đồ

Gần Step Functions, thêm một callout nhỏ tên **Decision Policy**:

| Điều kiện | Hành động |
| --- | --- |
| Non-EC2 finding | Alert only |
| Missing Instance ID | Needs review |
| Low/Medium | Alert only |
| High + AutoIsolate | Manual approval |
| Critical + AutoIsolate | Auto/approval tùy policy |
| No AutoIsolate tag | Dry-run/manual review |

Callout này giúp người xem hiểu vì sao hệ thống không cô lập bừa bãi.

#### Bước 7: Thêm legend & thông tin tài liệu

Ở góc dưới sơ đồ, thêm legend:

- Teal: Dashboard & Access.
- Blue: Logging & Evidence.
- Orange: Detection & Response.
- Red: Security & Governance.
- Red arrow: Isolation action.
- Purple arrow: Approval callback.
- Gray arrow: Logging/audit.
- Dashed line: IAM role/policy relationship.

Thêm footer:

```text
AWS CloudSOC – Lab / Proof of Concept
Single AZ – Public Subnet – ap-southeast-1
Team: Trần Thái Nguyên & Dương Bá Đạt – HUTECH – 22DTHB1
Date: July 2026
```

### Phần C: Export sơ đồ

Khi hoàn thành:

1. Chọn **File → Export as → PNG**.
2. Chọn Zoom `2x` hoặc chất lượng cao.
3. Bật nền trắng nếu dùng cho Word/PDF.
4. Export thêm bản **SVG/PDF** nếu cần hình vector cho slide.
5. Đặt tên file rõ ràng:

```text
aws-cloudsoc-architecture-tran-thai-nguyen-july-2026.png
```

