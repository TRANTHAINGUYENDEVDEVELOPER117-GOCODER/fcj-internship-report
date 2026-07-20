---
title : "Tổng quan Workshop"
date : 2026-07-01 
weight : 1 
chapter : false
pre : " <b> 5.1. </b> "
---

#### Tổng quan AWS CloudSOC Workshop

Trong workshop này, chúng ta sẽ xây dựng hệ thống **AWS CloudSOC – Hệ thống phát hiện, điều tra và phản ứng sự cố tự động trên Amazon Web Services (AWS)**.

Mục đích của workshop là mô phỏng cách một **Security Operations Center (SOC)** có thể phát hiện các hoạt động đáng ngờ, phân tích security finding, thu thập bằng chứng forensic, cô lập tài nguyên bị ảnh hưởng và gửi cảnh báo đến SOC Analyst.

Workshop này được thiết kế theo mô hình **Lab / Proof of Concept**. Một Amazon EC2 instance được sử dụng làm workload mục tiêu, trong khi nhiều dịch vụ bảo mật và serverless của AWS được tích hợp để xây dựng một quy trình phản ứng sự cố hoàn chỉnh.

Luồng xử lý chính của hệ thống là:

```text
Phát hiện → Điều tra → Đánh giá → Phê duyệt → Thu thập bằng chứng → Snapshot → Cô lập → Cảnh báo
```

---

#### Kịch bản Workshop

Trong môi trường cloud, các workload public có thể bị tác động bởi nhiều hành vi đáng ngờ như port scanning, SSH brute-force, hoạt động API bất thường hoặc traffic đến từ các địa chỉ IP không đáng tin cậy. Nếu những sự kiện này không được phát hiện và xử lý kịp thời, tài nguyên bị ảnh hưởng có thể trở thành rủi ro bảo mật.

Trong workshop này, một **Amazon EC2 instance** được triển khai trong Public Subnet để đóng vai trò là workload thử nghiệm. Thiết kế này giúp việc mô phỏng traffic tấn công và quan sát luồng phát hiện, phản ứng sự cố trở nên dễ dàng hơn.

Khi **Amazon GuardDuty** phát hiện hoạt động đáng ngờ, dịch vụ này sẽ tạo một security finding. Finding sau đó được gửi đến **Amazon EventBridge**, từ đó kích hoạt workflow của **AWS Step Functions**. Workflow sẽ đánh giá finding và quyết định có gửi cảnh báo, yêu cầu phê duyệt, thu thập bằng chứng forensic, tạo snapshot hoặc cô lập EC2 instance bị ảnh hưởng hay không.

Quy trình phản ứng được kiểm soát dựa trên mức độ nghiêm trọng, loại tài nguyên, Instance ID, chế độ phản ứng và tag `AutoIsolate=true`.

---

#### Hình minh họa kiến trúc

Sơ đồ sau thể hiện kiến trúc tổng quan của hệ thống AWS CloudSOC.

![AWS CloudSOC Architecture](/images/5-Workshop/5.1-Workshop-overview/architecture.png)

Kiến trúc được chia thành năm nhóm thành phần chính:

+ **Network and Workload**: Amazon VPC, Public Subnet, Internet Gateway, Amazon EC2, SG-Workload và SG-Isolation.
+ **Logging and Evidence Storage**: AWS CloudTrail, Amazon CloudWatch, Amazon S3, VPC Flow Logs và Amazon EBS Snapshot.
+ **Threat Detection and Response**: Amazon GuardDuty, AWS Security Hub, Amazon Detective, Amazon EventBridge, AWS Step Functions, AWS Systems Manager và AWS Lambda.
+ **SOC Dashboard and Access**: AWS Amplify Hosting, Amazon Cognito, Amazon API Gateway, Dashboard API Lambda và Amazon DynamoDB.
+ **Security, Governance, and Notification**: AWS IAM, AWS KMS, AWS Config, Amazon SNS, Amazon Q Developer, Slack, Email và SMS.

---

#### Vòng đời phản ứng sự cố

Workflow AWS CloudSOC tuân theo một vòng đời phản ứng sự cố có kiểm soát. Hệ thống không cô lập mọi finding ngay lập tức. Thay vào đó, finding sẽ được đánh giá trước khi thực hiện hành động phản ứng.

![CloudSOC Incident Response Lifecycle](/images/5-Workshop/5.1-Workshop-overview/incident-response-lifecycle.png)

Vòng đời phản ứng sự cố bao gồm các bước sau:

1. **Phát hiện**  
   Amazon GuardDuty phân tích AWS-managed telemetry và phát hiện hoạt động đáng ngờ.

2. **Điều tra**  
   AWS Security Hub tập trung các finding bảo mật, trong khi Amazon Detective hỗ trợ điều tra chuyên sâu.

3. **Đánh giá**  
   AWS Step Functions kiểm tra loại tài nguyên, Instance ID, mức độ nghiêm trọng, tag `AutoIsolate=true` và chế độ phản ứng.

4. **Phê duyệt**  
   Đối với finding mức High, SOC Analyst sẽ xem xét incident và phê duyệt hoặc từ chối hành động phản ứng.

5. **Thu thập bằng chứng**  
   AWS Systems Manager thu thập thông tin forensic từ EC2 instance bị ảnh hưởng.

6. **Tạo Snapshot**  
   Amazon EBS Snapshot được tạo để bảo toàn dữ liệu ổ đĩa phục vụ điều tra hoặc khôi phục.

7. **Cô lập**  
   AWS Lambda thay thế security group ban đầu bằng `SG-Isolation` để cô lập EC2 instance bị ảnh hưởng.

8. **Cảnh báo**  
   Amazon SNS gửi kết quả xử lý đến Slack, Email hoặc SMS.

---

#### Chính sách phản ứng

Workflow sử dụng chính sách phản ứng nhằm giảm false positive và tránh cô lập tài nguyên không cần thiết.

![Response Policy](/images/5-Workshop/5.1-Workshop-overview/response-policy.png)

Chính sách phản ứng được định nghĩa như sau:

```text
Non-EC2 Finding        → Alert Only
Low / Medium Severity  → Dry Run
High Severity          → Request Approval
Critical Severity      → Auto Response
Reject / Timeout       → End Workflow
```

Chính sách này cho phép hệ thống tự động phản ứng với các incident mức Critical, đồng thời yêu cầu con người phê duyệt đối với các finding mức High.

---

#### Tổng quan SOC Dashboard

SOC Dashboard cho phép SOC Analyst xem incident, kiểm tra bằng chứng và phê duyệt hoặc từ chối hành động phản ứng.

![SOC Dashboard Flow](/images/5-Workshop/5.1-Workshop-overview/soc-dashboard-flow.png)

Luồng hoạt động của dashboard:

```text
SOC Analyst
→ AWS Amplify Hosting
→ Amazon Cognito
→ Amazon API Gateway
→ Dashboard API Lambda
→ Amazon DynamoDB / Amazon S3
→ AWS Step Functions Approval Callback
```

Dashboard hiển thị các thông tin quan trọng của incident, bao gồm:

+ Incident ID
+ Loại finding
+ Mức độ nghiêm trọng
+ EC2 Instance ID
+ Trạng thái phê duyệt
+ Trạng thái cô lập
+ Vị trí lưu bằng chứng
+ Snapshot ID
+ Kết quả gửi cảnh báo

---

#### Các dịch vụ AWS chính được sử dụng

Workshop sử dụng các dịch vụ AWS sau:

+ **Amazon EC2** được sử dụng làm workload mục tiêu để kiểm thử bảo mật.
+ **Amazon VPC** cung cấp môi trường mạng cho EC2 instance.
+ **Internet Gateway** cho phép internet traffic đi đến Public Subnet.
+ **Security Groups** kiểm soát inbound và outbound traffic của EC2 instance.
+ **AWS CloudTrail** ghi lại hoạt động trong AWS account và các management events.
+ **Amazon CloudWatch** lưu trữ logs, metrics và alarms.
+ **VPC Flow Logs** ghi lại metadata của network traffic.
+ **Amazon S3** lưu trữ audit logs, forensic output và incident evidence.
+ **Amazon GuardDuty** phát hiện hoạt động đáng ngờ và tạo security findings.
+ **AWS Security Hub** tập trung các security findings.
+ **Amazon Detective** hỗ trợ điều tra và phân tích sự cố.
+ **Amazon EventBridge** chuyển GuardDuty findings đến response workflow.
+ **AWS Step Functions** điều phối quy trình phản ứng sự cố.
+ **AWS Systems Manager** thu thập forensic data từ EC2 instance.
+ **Amazon EBS Snapshot** bảo toàn disk evidence trước khi cô lập.
+ **AWS Lambda** thực hiện các hành động phản ứng như cập nhật incident record và thay đổi security group.
+ **Amazon DynamoDB** lưu incident metadata và response status.
+ **Amazon SNS** gửi approval request và incident alert.
+ **Amazon Q Developer** chuyển tiếp SNS notification đến Slack.
+ **AWS Amplify Hosting** host frontend của SOC Dashboard.
+ **Amazon Cognito** cung cấp xác thực cho SOC Analyst.
+ **Amazon API Gateway** cung cấp API cho SOC Dashboard.
+ **AWS IAM** quản lý quyền truy cập và execution roles.
+ **AWS KMS** hỗ trợ mã hóa dữ liệu nhạy cảm.
+ **AWS Config** theo dõi thay đổi cấu hình của AWS resources.

---

#### Phạm vi Workshop

Workshop này tập trung vào việc xây dựng môi trường CloudSOC Lab. Mục tiêu chính là phục vụ học tập, demo và thực hành thiết kế kiến trúc bảo mật trên AWS.

Trong workshop này:

+ EC2 instance được đặt trong Public Subnet để đơn giản hóa việc mô phỏng tấn công.
+ Amazon GuardDuty được sử dụng làm dịch vụ phát hiện mối đe dọa chính.
+ AWS Step Functions kiểm soát response workflow.
+ AWS Systems Manager thu thập forensic data trước khi cô lập.
+ AWS Lambda cô lập EC2 instance bằng cách thay thế security group.
+ Amazon S3 và Amazon DynamoDB lưu trữ evidence và incident metadata.
+ Amazon SNS gửi thông báo đến SOC Analyst.
+ SOC Dashboard cung cấp khả năng quan sát và phê duyệt xử lý.

Workshop này chưa phải là kiến trúc production hoàn chỉnh. Trong môi trường production, workload thường nên được đặt trong Private Subnet và được bảo vệ bởi các lớp bổ sung như Application Load Balancer, AWS WAF, thiết kế multi-AZ, centralized logging và các kiểm soát mạng nghiêm ngặt hơn.