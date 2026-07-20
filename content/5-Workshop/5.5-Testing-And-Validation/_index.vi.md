---
title : "Kiểm thử và xác thực hệ thống"
date : 2026-07-01
weight : 5
chapter : false
pre : " <b> 5.5. </b> "
---

#### Kiểm thử và xác thực hệ thống

Trong phần này, chúng ta sẽ kiểm thử toàn bộ hệ thống **AWS CloudSOC** sau khi đã hoàn thành quá trình triển khai ở phần **5.4 Deploy CloudSOC System**.

Mục tiêu của phần 5.5 là xác nhận rằng các thành phần chính của hệ thống hoạt động đúng theo luồng đã thiết kế, bao gồm phát hiện security finding, xử lý approval workflow, cô lập EC2 tự động, cập nhật dashboard và gửi cảnh báo đến SOC Analyst.

Luồng kiểm thử tổng thể:

```text
GuardDuty Finding
→ EventBridge
→ Step Functions
→ Lambda Response
→ Evidence Storage
→ EC2 Isolation
→ Dashboard Update
→ SNS Alert
→ Email / Slack Notification
```

Phần kiểm thử này giúp chứng minh rằng CloudSOC không chỉ được triển khai thành công, mà còn có thể vận hành theo đúng quy trình phản ứng sự cố tự động trên AWS.

---

#### Mục tiêu kiểm thử

Sau khi hoàn thành phần này, chúng ta có thể xác nhận rằng:

+ Amazon GuardDuty có thể tạo và hiển thị security findings.
+ EventBridge rule có thể nhận GuardDuty Finding.
+ Step Functions workflow có thể điều phối luồng phản ứng sự cố.
+ Approval Workflow cho phép SOC Analyst phê duyệt hoặc từ chối incident.
+ Incident Response Lambda có thể xử lý event và thực hiện auto isolation.
+ Systems Manager có thể thu thập forensic evidence từ EC2.
+ EBS Snapshot được tạo để phục vụ điều tra.
+ Evidence được lưu vào S3 Evidence Bucket.
+ DynamoDB cập nhật trạng thái incident.
+ SOC Dashboard hiển thị đúng trạng thái incident.
+ SNS gửi cảnh báo đến Email và Slack.
+ CloudWatch Alarm có thể cảnh báo khi Lambda gặp lỗi.

---

#### Tổng quan kiểm thử

Sơ đồ dưới đây mô tả tổng quan các bước kiểm thử trong phần 5.5.

![Testing and Validation Overview](/images/5-Workshop/5.5-Testing-and-validation/testing-validation-overview.png)

Quy trình kiểm thử được chia thành bốn nhóm chính:

```text
Test GuardDuty Finding
→ Test Approval Workflow
→ Test Auto Isolation
→ Test Dashboard and Alert
```

Mỗi nhóm kiểm thử tập trung vào một phần quan trọng của hệ thống CloudSOC.

---

#### Các phần kiểm thử trong 5.5

Phần 5.5 được chia thành bốn phần con. Bạn nên thực hiện theo đúng thứ tự bên dưới để đảm bảo kết quả kiểm thử rõ ràng và dễ theo dõi.

| Phần | Nội dung | Mục tiêu kiểm thử |
|---|---|---|
| [5.5.1 Test GuardDuty Finding](./5.5.1-test-guardduty-finding/) | Tạo và kiểm tra GuardDuty sample findings | Xác nhận GuardDuty hoạt động và tạo findings |
| [5.5.2 Test Approval Workflow](./5.5.2-test-approval-workflow/) | Kiểm thử luồng Approve / Reject trên dashboard | Xác nhận SOC Analyst có thể phê duyệt incident |
| [5.5.3 Test Auto Isolation](./5.5.3-test-auto-isolation/) | Kiểm thử Lambda tự động cô lập EC2 | Xác nhận EC2 được chuyển sang `SG-Isolation` |
| [5.5.4 Test Dashboard and Alert](./5.5.4-test-dashboard-and-alert/) | Kiểm thử dashboard, SNS, Email, Slack và CloudWatch Alarm | Xác nhận dashboard và alert hoạt động |

---

#### Quick Navigation

- [5.5.1 Test GuardDuty Finding](./5.5.1-test-guardduty-finding/)
- [5.5.2 Test Approval Workflow](./5.5.2-test-approval-workflow/)
- [5.5.3 Test Auto Isolation](./5.5.3-test-auto-isolation/)
- [5.5.4 Test Dashboard and Alert](./5.5.4-test-dashboard-and-alert/)

---

#### Thứ tự kiểm thử khuyến nghị

```text
5.5.1 Test GuardDuty Finding
        ↓
5.5.2 Test Approval Workflow
        ↓
5.5.3 Test Auto Isolation
        ↓
5.5.4 Test Dashboard and Alert
```

Thứ tự này giúp kiểm thử hệ thống theo đúng luồng vận hành:

```text
Detection → Approval → Automated Response → Dashboard and Alert
```

---

#### Kiến trúc kiểm thử

Hệ thống CloudSOC được kiểm thử theo nhiều lớp chức năng khác nhau.

| Lớp kiểm thử | Dịch vụ liên quan | Kết quả cần xác nhận |
|---|---|---|
| Detection Testing | GuardDuty, Security Hub | Finding được tạo và hiển thị |
| Event Routing Testing | EventBridge, Step Functions | Finding được chuyển vào workflow |
| Approval Testing | Dashboard, API Gateway, Lambda, DynamoDB | Incident có thể Approve hoặc Reject |
| Response Testing | Lambda, Systems Manager, EC2, EBS Snapshot | EC2 được cô lập và evidence được thu thập |
| Evidence Testing | S3, DynamoDB | Evidence và trạng thái incident được lưu |
| Alert Testing | SNS, Email, Slack, CloudWatch Alarm | SOC Analyst nhận được cảnh báo |

---

#### 5.5.1 Test GuardDuty Finding

Trong phần này, chúng ta kiểm thử khả năng tạo và hiển thị **GuardDuty Findings**.

GuardDuty sample findings được sử dụng để mô phỏng các tình huống bảo mật mà không cần thực hiện hành vi tấn công thật.

Các nội dung kiểm thử gồm:

+ Mở GuardDuty dashboard.
+ Tạo sample findings.
+ Kiểm tra danh sách findings.
+ Mở chi tiết một finding.
+ Kiểm tra EventBridge rule.
+ Kiểm tra Step Functions execution nếu có.

Kết quả mong đợi:

```text
GuardDuty có thể tạo sample findings và hiển thị finding detail để phục vụ các bước xử lý tiếp theo.
```

---

#### 5.5.2 Test Approval Workflow

Trong phần này, chúng ta kiểm thử luồng **Approval Workflow**.

Approval Workflow được sử dụng cho các incident cần SOC Analyst xem xét trước khi thực hiện hành động phản ứng mạnh hơn.

Các nội dung kiểm thử gồm:

+ Kiểm tra nhánh `Approval Required` trong Step Functions.
+ Tạo incident ở trạng thái `Pending`.
+ Kiểm tra incident trên SOC Dashboard.
+ Thực hiện hành động `Approve`.
+ Kiểm tra trạng thái được cập nhật trong DynamoDB.
+ Thực hiện hành động `Reject`.
+ Kiểm tra incident không tiếp tục đi vào auto response khi bị reject.

Kết quả mong đợi:

```text
SOC Analyst có thể phê duyệt hoặc từ chối incident, và DynamoDB cập nhật đúng trạng thái xử lý.
```

---

#### 5.5.3 Test Auto Isolation

Trong phần này, chúng ta kiểm thử chức năng **Auto Isolation**.

Auto Isolation là luồng phản ứng tự động khi hệ thống xử lý một finding nghiêm trọng liên quan đến EC2.

Các nội dung kiểm thử gồm:

+ Kiểm tra EC2 trước khi cô lập.
+ Chạy sample GuardDuty event có đúng EC2 instance ID.
+ Kích hoạt Incident Response Lambda.
+ Thu thập forensic evidence bằng Systems Manager.
+ Lưu evidence vào S3.
+ Tạo EBS Forensic Snapshot.
+ Thay Security Group của EC2 từ `SG-Workload` sang `SG-Isolation`.
+ Cập nhật trạng thái incident trong DynamoDB.
+ Kiểm tra Step Functions Auto Response execution nếu có.

Kết quả mong đợi:

```text
EC2 bị nghi ngờ được cô lập bằng SG-Isolation, evidence được lưu vào S3, snapshot được tạo và DynamoDB được cập nhật.
```

---

#### 5.5.4 Test Dashboard and Alert

Trong phần này, chúng ta kiểm thử **SOC Dashboard** và lớp **Alerting**.

Sau khi incident được xử lý, SOC Analyst cần theo dõi được trạng thái trên dashboard và nhận cảnh báo qua Email hoặc Slack.

Các nội dung kiểm thử gồm:

+ Kiểm tra dashboard trước khi test alert.
+ Kiểm tra dashboard hiển thị incident đã isolated.
+ Kiểm tra DynamoDB lưu notification record.
+ Kiểm tra SNS Topic và subscription.
+ Kiểm tra email nhận incident alert.
+ Kiểm tra Slack nhận incident alert.
+ Kiểm tra CloudWatch Alarm theo dõi Lambda error.
+ Kiểm tra alarm notification được gửi qua SNS.
+ Kiểm tra trạng thái cuối cùng trên dashboard.

Kết quả mong đợi:

```text
Dashboard hiển thị đúng trạng thái incident và SOC Analyst nhận được alert qua Email hoặc Slack.
```

---

#### Validation Checklist

Bảng dưới đây tóm tắt các tiêu chí cần đạt sau khi hoàn thành phần kiểm thử.

![Testing and Validation Checklist](/images/5-Workshop/5.5-Testing-and-validation/testing-validation-checklist.png)

| Hạng mục | Kết quả mong đợi |
|---|---|
| GuardDuty sample findings | Được tạo thành công |
| GuardDuty finding detail | Hiển thị đầy đủ thông tin finding |
| EventBridge rule | Đang enabled |
| Step Functions workflow | Có thể xử lý event |
| Approval workflow | Approve / Reject hoạt động |
| DynamoDB incident table | Lưu trạng thái incident |
| Incident Response Lambda | Chạy thành công |
| Systems Manager Run Command | Thu thập forensic evidence |
| S3 Evidence Bucket | Lưu raw event và response summary |
| EBS Snapshot | Được tạo từ EC2 volume |
| EC2 Security Group | Được đổi sang `SG-Isolation` |
| SOC Dashboard | Hiển thị trạng thái incident |
| SNS Topic | Gửi notification thành công |
| Email alert | Nhận được email cảnh báo |
| Slack alert | Nhận được alert trong channel |
| CloudWatch Alarm | Gửi cảnh báo khi có Lambda error |

---

#### Kết quả kiểm thử tổng thể

Sau khi hoàn thành phần 5.5, hệ thống AWS CloudSOC đã được xác thực theo luồng vận hành đầy đủ:

```text
1. GuardDuty tạo security finding.
2. EventBridge nhận GuardDuty Finding.
3. Step Functions điều phối workflow.
4. Dashboard hiển thị incident cần xử lý.
5. SOC Analyst có thể Approve hoặc Reject incident.
6. Lambda xử lý incident đủ điều kiện auto response.
7. Systems Manager thu thập forensic evidence.
8. EBS Snapshot được tạo để phục vụ điều tra.
9. Evidence được lưu vào S3 Evidence Bucket.
10. EC2 được cô lập bằng SG-Isolation.
11. DynamoDB cập nhật trạng thái incident.
12. SNS gửi notification đến Email hoặc Slack.
13. CloudWatch Alarm gửi cảnh báo khi response automation gặp lỗi.
```

---

#### Bằng chứng kiểm thử

Các bằng chứng kiểm thử được thu thập trong phần 5.5 bao gồm:

```text
GuardDuty findings
Step Functions executions
DynamoDB incident records
Lambda execution results
Systems Manager command outputs
S3 evidence objects
EBS forensic snapshots
EC2 security group changes
SOC Dashboard screenshots
SNS subscription records
Email notifications
Slack notifications
CloudWatch alarm notifications
```

Những bằng chứng này giúp xác nhận rằng hệ thống CloudSOC đã hoạt động đúng theo thiết kế và có thể hỗ trợ quy trình phát hiện, điều tra, phản ứng và cảnh báo sự cố bảo mật.

---

#### Tổng kết

Phần 5.5 đã hoàn thành quá trình kiểm thử và xác thực hệ thống AWS CloudSOC.

Kết quả kiểm thử cho thấy hệ thống có thể thực hiện quy trình:

```text
Detect → Investigate → Approve → Respond → Store Evidence → Notify
```

Thông qua phần kiểm thử này, chúng ta xác nhận rằng CloudSOC có thể phát hiện security finding, điều phối workflow, hỗ trợ SOC Analyst phê duyệt incident, tự động cô lập EC2, lưu evidence và gửi cảnh báo đến các kênh thông báo.

Phần tiếp theo là:

```text
5.6 Resource Cleanup
```

Trong phần 5.6, chúng ta sẽ dọn dẹp các tài nguyên đã tạo trong workshop để tránh phát sinh chi phí không cần thiết.