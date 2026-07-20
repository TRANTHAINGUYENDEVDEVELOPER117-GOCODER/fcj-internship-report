---
title: "Bảo vệ ứng dụng Generative AI bằng Amazon Bedrock Guardrails"
date: 2026-07-19
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---

# AWS Artificial Intelligence Blog: Bảo vệ ứng dụng Generative AI bằng Amazon Bedrock Guardrails

Trong quá trình tham gia chương trình **FCAJ** và tìm hiểu các dịch vụ AWS liên quan đến AI/security, mình đọc được bài viết **“Safeguard generative AI applications with Amazon Bedrock Guardrails”** trên AWS Artificial Intelligence Blog. Bài viết đưa ra một kiến trúc đáng chú ý: xây dựng **Generative AI Gateway** tập trung để kiểm soát prompt trước khi gửi đến Amazon Bedrock hoặc các mô hình LLM bên ngoài.

![Generative AI Gateway với Amazon Bedrock Guardrails](/images/3-BlogsPosted/blog1-bedrock-guardrails.png)

### 1. Bài toán đặt ra

Khi doanh nghiệp sử dụng nhiều ứng dụng AI và nhiều foundation model khác nhau, mỗi đội có thể tự xây cơ chế bảo vệ riêng. Điều này dễ tạo ra các vấn đề:

- Chính sách an toàn không đồng nhất giữa các ứng dụng.
- Dữ liệu cá nhân có thể bị gửi đến model ngoài ý muốn.
- Credential/API key nằm rải rác trong nhiều service.
- Khó theo dõi chi phí và điều tra sự cố.
- Một số ứng dụng có lớp bảo vệ tốt, trong khi ứng dụng khác gần như không có.

Prompt engineering có thể yêu cầu model không trả lời nội dung nguy hiểm, nhưng đây không phải lớp bảo vệ đủ mạnh. Prompt vẫn có thể bị **jailbreak**, **prompt injection** hoặc bị khai thác bằng các câu lệnh được thiết kế tinh vi.

Giải pháp của bài viết là đặt một **gateway trung tâm** giữa ứng dụng và LLM. Mọi request đều phải đi qua gateway trước khi được gửi đến model.

### 2. Amazon Bedrock Guardrails làm gì?

**Amazon Bedrock Guardrails** cho phép cấu hình các chính sách an toàn như:

- Lọc nội dung nguy hiểm.
- Chặn các chủ đề không được phép.
- Phát hiện prompt attack.
- Chặn hoặc che thông tin nhận dạng cá nhân như email, số điện thoại, mã định danh.
- Lọc các từ hoặc cụm từ cụ thể.
- Kiểm tra mức độ liên quan và grounded của câu trả lời trong một số trường hợp.

Điểm đáng chú ý là API **ApplyGuardrail** có thể hoạt động độc lập với model inference. Gateway có thể gửi prompt đến Guardrails để kiểm tra trước. Nếu prompt vi phạm chính sách, request sẽ bị chặn mà không cần gọi LLM. Nếu prompt chứa dữ liệu nhạy cảm, dữ liệu có thể được che trước khi gửi tiếp.

### 3. Luồng hoạt động của kiến trúc

Luồng xử lý có thể tóm tắt như sau:

```text
Authenticated User / Application
→ Application Load Balancer
→ Generative AI Gateway
→ Amazon Bedrock Guardrails
→ Block / Mask / Allow
→ Amazon Bedrock hoặc External LLM
→ Response trả về người dùng
```

Quy trình gồm 5 bước:

1. Người dùng hoặc ứng dụng gửi prompt đến gateway qua HTTPS.
2. Gateway gọi Amazon Bedrock Guardrails để kiểm tra nội dung đầu vào.
3. Guardrails quyết định chặn request, che dữ liệu nhạy cảm hoặc cho phép tiếp tục.
4. Gateway chuyển prompt đã được kiểm tra đến Amazon Bedrock hoặc LLM bên ngoài.
5. Kết quả được trả về người dùng, đồng thời metadata giao dịch được ghi lại để monitoring và phân tích.

Trong kiến trúc tham khảo, gateway được đóng gói thành container và chạy bằng **Amazon ECS trên AWS Fargate**. **Application Load Balancer** phân phối request đến các container, còn **AWS Secrets Manager** lưu credential của các nhà cung cấp model bên ngoài.

### 4. Logging và theo dõi hoạt động

Kiến trúc sử dụng hai nhánh quan sát chính:

- **Amazon CloudWatch** thu thập log và metric để đội vận hành phát hiện lỗi, latency cao hoặc số request bị Guardrails chặn tăng bất thường.
- Dữ liệu giao dịch có thể đi qua **Amazon Kinesis Data Streams** và **Amazon Data Firehose**, sau đó lưu vào **Amazon S3**. **AWS Glue** và **Amazon Athena** hỗ trợ truy vấn dữ liệu để phân tích mức sử dụng hoặc phân bổ chi phí theo đội/dự án.

Tuy nhiên, logging cũng tạo ra rủi ro mới. Prompt và response có thể chứa dữ liệu nhạy cảm, vì vậy không nên mặc định lưu toàn bộ nội dung. Doanh nghiệp cần kiểm soát quyền truy cập, thời gian lưu trữ và những trường dữ liệu thật sự cần thiết.

### 5. Một số tình huống ứng dụng

#### Chặn tư vấn tài chính không phù hợp

Nếu chatbot không được phép đưa ra lời khuyên đầu tư, Guardrails có thể phát hiện chủ đề bị cấm và chặn prompt trước khi model được gọi. Như vậy chính sách được thực thi tại gateway, thay vì phụ thuộc hoàn toàn vào việc model có tuân thủ system prompt hay không.

#### Che thông tin cá nhân

Nếu prompt chứa email, số điện thoại hoặc mã định danh, Guardrails có thể thay thế dữ liệu đó bằng ký hiệu ẩn danh trước khi chuyển đến LLM. Cách này giúp giảm lượng thông tin nhạy cảm được gửi tới model.

Dù vậy, việc phát hiện PII vẫn có thể có false positive hoặc false negative, nên không thể coi đây là hệ thống DLP hoàn chỉnh.

#### Quản lý nhiều ứng dụng AI trong doanh nghiệp

Một doanh nghiệp có thể cho các đội marketing, kỹ thuật và tài chính sử dụng chung gateway nhưng áp dụng policy khác nhau. Gateway cũng có thể ghi nhận application ID và cost center để biết bộ phận nào đang sử dụng model nào và tiêu thụ bao nhiêu tài nguyên.

### 6. Những trade-off cần lưu ý

Thứ nhất, Guardrails không thay thế authentication, authorization, IAM hay data governance. Một prompt không chứa nội dung nguy hiểm không có nghĩa người dùng được quyền truy cập mọi dữ liệu.

Thứ hai, mỗi lần gọi ApplyGuardrail tạo thêm một bước xử lý, vì vậy latency và chi phí có thể tăng. Đổi lại, request vi phạm có thể bị chặn trước khi phát sinh model inference.

Thứ ba, gateway tập trung giúp chính sách đồng nhất nhưng cũng trở thành một thành phần quan trọng. Nếu gateway gặp sự cố hoặc cấu hình sai, nhiều ứng dụng AI có thể bị ảnh hưởng cùng lúc.

Đặc biệt, reference implementation trong bài AWS Blog chủ yếu áp dụng Guardrails cho input. Với hệ thống nhạy cảm, mình nghĩ nên bổ sung thêm kiểm tra output:

```text
Prompt
→ Input Guardrail
→ LLM
→ Output Guardrail
→ Safe Response
```

Đây là phần mở rộng dựa trên khả năng của ApplyGuardrail, không phải phần đã được triển khai hoàn chỉnh trong mẫu của bài viết.

### 7. Góc nhìn cá nhân

Điểm mình thấy đáng học nhất là cách đưa chính sách an toàn ra khỏi từng ứng dụng và đặt tại một gateway chung. Cách tiếp cận này phù hợp với doanh nghiệp có nhiều đội và nhiều LLM provider, vì giúp giảm tình trạng mỗi dự án tự xây một lớp bảo vệ khác nhau.

Tuy nhiên, với một ứng dụng nhỏ chỉ dùng một model, kiến trúc gồm ECS, Fargate, Kinesis, Firehose, S3, Glue và Athena có thể phức tạp hơn nhu cầu thực tế.

Bài học mình rút ra là **Guardrails không phải “lá chắn tuyệt đối”**. Đây là một phần của mô hình **defense in depth**, cần kết hợp với IAM least privilege, encryption, monitoring, data minimization và kiểm thử thường xuyên.

### Tài liệu tham khảo

- [AWS Blog: Safeguard generative AI applications with Amazon Bedrock Guardrails](https://aws.amazon.com/blogs/machine-learning/safeguard-generative-ai-applications-with-amazon-bedrock-guardrails/)
- [Amazon Bedrock Guardrails documentation](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html)
- [Use the ApplyGuardrail API](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-use-independent-api.html)

