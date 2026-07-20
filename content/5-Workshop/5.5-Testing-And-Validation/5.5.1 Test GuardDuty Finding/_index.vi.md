---
title : "Kiểm thử GuardDuty Finding"
date : 2026-07-01
weight : 1
chapter : false
pre : " <b> 5.5.1. </b> "
---

#### Kiểm thử GuardDuty Finding

Trong phần này, chúng ta sẽ kiểm thử khả năng tạo và hiển thị **security findings** của **Amazon GuardDuty** trong hệ thống AWS CloudSOC.

Mục tiêu của bài kiểm thử là xác nhận rằng GuardDuty đã được bật thành công và có thể tạo ra các security findings. Các finding này sẽ được sử dụng làm dữ liệu đầu vào cho những bước tiếp theo trong quy trình phản ứng sự cố của CloudSOC.

GuardDuty Finding là điểm bắt đầu của luồng phản ứng sự cố:

```text
GuardDuty Finding
→ EventBridge
→ Step Functions
→ Incident Response Workflow
```

Trong phần 5.5.1, trọng tâm là tạo và xem lại GuardDuty findings trong GuardDuty console. Các bước kiểm thử workflow, approval, auto isolation, dashboard và alert sẽ được thực hiện ở các phần tiếp theo.

---

#### Mục tiêu kiểm thử

Sau khi hoàn thành phần này, chúng ta có thể xác nhận rằng:

+ Amazon GuardDuty đã được bật.
+ GuardDuty có thể tạo sample findings.
+ Findings được hiển thị trong GuardDuty console.
+ Mỗi finding có các thông tin quan trọng như severity, finding type, resource, account và region.
+ Finding có thể được sử dụng làm dữ liệu đầu vào cho EventBridge và Step Functions ở các bước kiểm thử tiếp theo.

---

#### Kiến trúc kiểm thử

Sơ đồ dưới đây mô tả luồng kiểm thử GuardDuty Finding.

![Test GuardDuty Finding Flow](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-test-guardduty-finding/test-guardduty-finding-flow.png)

Luồng kiểm thử bao gồm các bước chính:

```text
SOC Analyst
→ GuardDuty Console
→ Generate Sample Findings
→ View Finding Details
→ Confirm Finding Information
→ Check EventBridge Rule
→ Check Step Functions Execution
```

Trong bài kiểm thử này, chúng ta sử dụng **GuardDuty sample findings**. Đây là cách an toàn để kiểm thử lab mà không cần thực hiện hành vi tấn công thật vào EC2 instance.

---

#### Bước 1: Mở Amazon GuardDuty

Đầu tiên, truy cập AWS Console và mở dịch vụ **Amazon GuardDuty** trong Region:

```text
Asia Pacific (Singapore) / ap-southeast-1
```

GuardDuty dashboard xác nhận rằng dịch vụ đã được bật và sẵn sàng hiển thị security findings.

![GuardDuty Dashboard Before Test](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-test-guardduty-finding/guardduty-dashboard-before-test.png)

Ở bước này, GuardDuty đã sẵn sàng đóng vai trò là dịch vụ phát hiện mối đe dọa chính trong AWS CloudSOC lab.

---

#### Bước 2: Tạo Sample Findings

Để kiểm thử GuardDuty mà không cần thực hiện tấn công thật, chúng ta sử dụng tính năng tạo sample findings trong GuardDuty console.

GuardDuty có thể tạo các findings mô phỏng nhiều tình huống bảo mật khác nhau, ví dụ:

```text
UnauthorizedAccess:EC2/SSHBruteForce
Recon:EC2/PortProbeUnprotectedPort
CryptoCurrency:EC2/BitcoinTool.B
Trojan:EC2/DNSDataExfiltration
```

Các sample findings này chỉ phục vụ mục đích kiểm thử. Chúng không có nghĩa là AWS account đang bị tấn công thật.

![Generate GuardDuty Sample Findings](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-test-guardduty-finding/generate-guardduty-sample-findings.png)

Sau khi sample findings được tạo, GuardDuty sẽ hiển thị nhiều sự kiện bảo mật mô phỏng trong danh sách findings.

---

#### Bước 3: Kiểm tra danh sách Findings

Sau khi tạo sample findings, trang **Findings** của GuardDuty sẽ hiển thị nhiều findings mẫu.

![GuardDuty Sample Findings List](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-test-guardduty-finding/guardduty-sample-findings-list.png)

Danh sách findings hiển thị các thông tin quan trọng như title, severity, finding type và resource liên quan.

| Thông tin | Mô tả |
|---|---|
| Finding type | Loại hành vi đáng ngờ |
| Severity | Mức độ nghiêm trọng của finding |
| Resource | Tài nguyên AWS có liên quan |
| Account ID | AWS account phát sinh finding |
| Region | AWS Region phát sinh finding |
| Updated at | Thời điểm finding được cập nhật gần nhất |

Từ danh sách findings, chúng ta có thể chọn một finding liên quan đến EC2 để xem chi tiết. Những finding này giúp xác nhận rằng lớp phát hiện mối đe dọa của CloudSOC đang hoạt động.

---

#### Bước 4: Mở chi tiết một Finding

Một finding liên quan đến EC2 được chọn để kiểm tra thông tin chi tiết. Ví dụ các finding type liên quan EC2:

```text
UnauthorizedAccess:EC2/SSHBruteForce
```

hoặc:

```text
Recon:EC2/PortProbeUnprotectedPort
```

Trang chi tiết finding cung cấp thông tin rõ hơn về hành vi đáng ngờ, tài nguyên bị ảnh hưởng, mức độ nghiêm trọng và mốc thời gian phát hiện.

![GuardDuty Finding Detail](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-test-guardduty-finding/guardduty-finding-detail.png)

Các trường thông tin được kiểm tra trong trang chi tiết finding gồm:

```text
Finding ID
Finding type
Severity
Resource type
Instance ID
Account ID
Region
First seen
Last seen
```

Những thông tin này giúp SOC Analyst hiểu sự cố đang thuộc loại nào, tài nguyên nào liên quan và mức độ nghiêm trọng ra sao.

---

#### Bước 5: Ghi nhận thông tin Finding

Sau khi xem chi tiết finding, các thông tin quan trọng được ghi nhận để phục vụ cho các bước kiểm thử tiếp theo.

Ví dụ:

| Trường thông tin | Ví dụ |
|---|---|
| Finding type | UnauthorizedAccess:EC2/SSHBruteForce |
| Severity | High |
| Resource type | EC2 Instance |
| Region | ap-southeast-1 |
| Response action | Send to EventBridge and Step Functions |

Thông tin này giúp xác định finding nên đi theo nhánh `Alert Only`, `Approval Required` hay `Auto Response` trong CloudSOC workflow.

---

#### Bước 6: Kiểm tra EventBridge Rule

Sau khi GuardDuty tạo findings, EventBridge rule được kiểm tra để xác nhận rule nhận GuardDuty findings đang hoạt động.

Rule sử dụng trong lab này là:

```text
cloudsoc-guardduty-finding-rule
```

Event pattern được cấu hình để khớp với GuardDuty findings:

```json
{
  "source": ["aws.guardduty"],
  "detail-type": ["GuardDuty Finding"]
}
```

![EventBridge GuardDuty Rule Enabled](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-test-guardduty-finding/eventbridge-guardduty-rule-enabled.png)

Rule này cho phép các GuardDuty findings được chuyển tiếp vào CloudSOC workflow.

---

#### Bước 7: Kiểm tra Step Functions Execution

Tiếp theo, Step Functions state machine được kiểm tra để xác nhận workflow đã sẵn sàng xử lý GuardDuty findings.

State machine sử dụng trong lab này là:

```text
cloudsoc-incident-response-workflow
```

Trang executions cho biết workflow đã nhận và xử lý event finding hay chưa.

![Step Functions Execution From GuardDuty](/images/5-Workshop/5.5-Testing-and-validation/5.5.1-test-guardduty-finding/stepfunctions-execution-from-guardduty.png)

Trong một số trường hợp, GuardDuty sample findings có thể không kích hoạt ngay workflow execution đúng như mong đợi trong lab. Vì vậy, bài kiểm thử auto isolation đầy đủ sẽ được thực hiện ở phần **5.5.3 Test Auto Isolation** bằng một sample event có kiểm soát.

---

#### Kết quả mong đợi

Sau khi hoàn thành phần này, các kết quả mong đợi gồm:

| Thành phần | Kết quả mong đợi |
|---|---|
| GuardDuty | Sample findings được tạo |
| Findings list | Các findings mới được hiển thị |
| Finding detail | Thông tin finding type, severity và resource được hiển thị |
| EventBridge Rule | Rule nhận GuardDuty Finding đang enabled |
| Step Functions | Workflow sẵn sàng nhận findings hoặc có thể kiểm thử bằng sample event |

---

#### Bằng chứng kiểm thử

Các bằng chứng kiểm thử trong phần này bao gồm những hình ảnh sau:

| STT | Hình ảnh | Mục đích |
|---|---|---|
| 1 | GuardDuty finding flow diagram | Mô tả luồng kiểm thử tổng quan |
| 2 | GuardDuty dashboard | Xác nhận GuardDuty đã được bật |
| 3 | Generate sample findings | Xác nhận sample findings được tạo |
| 4 | GuardDuty findings list | Hiển thị danh sách sample findings |
| 5 | GuardDuty finding detail | Hiển thị chi tiết một finding được chọn |
| 6 | EventBridge rule | Xác nhận GuardDuty rule đang enabled |
| 7 | Step Functions executions | Xác nhận workflow sẵn sàng xử lý event |

---

#### Lưu ý

GuardDuty sample findings không phải lúc nào cũng trỏ đúng đến EC2 workload thật đã tạo trong lab. Vì vậy, mục tiêu chính của phần này là xác nhận GuardDuty có thể tạo và hiển thị findings thành công.

Bài kiểm thử cô lập EC2 thật sẽ được thực hiện ở phần:

```text
5.5.3 Test Auto Isolation
```

Trong phần đó, một sample event có kiểm soát sẽ được sử dụng với đúng EC2 instance ID của lab. Điều này giúp Incident Response Lambda có thể thu thập evidence, tạo EBS Snapshot, cập nhật DynamoDB và thay Security Group của EC2 sang `SG-Isolation`.

---

#### Hoàn thành

Bạn đã hoàn thành phần kiểm thử GuardDuty Finding.

Kết quả của phần này xác nhận rằng GuardDuty đang hoạt động và có thể tạo security findings. Đây là dữ liệu đầu vào quan trọng để hệ thống CloudSOC tiếp tục xử lý qua EventBridge, Step Functions, Lambda và SNS trong các phần kiểm thử tiếp theo.