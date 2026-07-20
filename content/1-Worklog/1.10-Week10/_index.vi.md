---
title: "Worklog Tuần 10"
date: 2026-07-11
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

# Worklog Tuần 10: Serverless, API Gateway và Event-Driven Architecture

### Tổng quan tuần 10 (11/07 – 17/07/2026)

Tuần 10 đánh dấu giai đoạn chuyển từ phần **Optimize** sang **Modernize Application**. Nội dung chính tập trung vào kiến trúc **serverless** và **event-driven**, gồm AWS Lambda, Amazon API Gateway, Amazon DynamoDB, Amazon S3, Amazon Cognito, Amazon SQS/SNS, CloudWatch và AWS X-Ray.

Mục tiêu của tuần này là hiểu cách xây dựng ứng dụng hiện đại mà không cần quản lý server trực tiếp, đồng thời đảm bảo API có xác thực, log, giám sát và khả năng mở rộng.

### Mục tiêu tuần 10

- Hiểu nguyên tắc thiết kế serverless và event-driven.
- Xây dựng API cơ bản bằng API Gateway và Lambda.
- Tìm hiểu cách Lambda tương tác với DynamoDB/S3.
- Sử dụng Cognito để xác thực người dùng và bảo vệ API.
- Tìm hiểu SQS/SNS để xử lý message bất đồng bộ.
- Quan sát log, metric và trace bằng CloudWatch/X-Ray.
- Cleanup tài nguyên sau khi thực hành.

### Công việc đã thực hiện

| Bước | Nội dung | Trạng thái | Nguồn |
| --- | --- | --- | --- |
| 01 | Lambda tương tác DynamoDB/S3 | ✅ Hoàn thành | [Cloud Journey – Modernize](https://cloudjourney.awsstudygroup.com/4-modernize/) |
| 02 | API Gateway REST API tích hợp Lambda | ✅ Hoàn thành | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 03 | Cognito User Pool và API Authorizer | ✅ Hoàn thành | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 04 | SQS/SNS xử lý message bất đồng bộ | ✅ Hoàn thành | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 05 | CloudWatch Logs và X-Ray tracing | ✅ Hoàn thành | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 06 | Cleanup tài nguyên serverless | ✅ Hoàn thành | — |

### Nội dung chi tiết

#### AWS Lambda

Em tìm hiểu cách Lambda chạy code theo sự kiện mà không cần quản lý máy chủ. Lambda có thể được kích hoạt bởi nhiều nguồn như API Gateway, S3 event, DynamoDB stream hoặc SQS.

Các điểm quan trọng:

- Lambda cần IAM execution role phù hợp.
- Không nên cấp quyền quá rộng cho Lambda.
- Cần theo dõi timeout, memory, retry và error handling.
- Log của Lambda được ghi vào CloudWatch Logs.

#### Amazon API Gateway

API Gateway đóng vai trò public endpoint cho ứng dụng serverless. Em tìm hiểu cách:

- Tạo REST API hoặc HTTP API.
- Tích hợp API Gateway với Lambda.
- Thiết kế resource/method.
- Kiểm tra request/response.
- Bảo vệ API bằng authorizer.

API Gateway giúp tách frontend/client khỏi backend Lambda, đồng thời hỗ trợ throttling, logging và authorization.

#### Amazon Cognito

Cognito được sử dụng để xác thực người dùng. Sau khi đăng nhập thành công, Cognito cấp token để client gọi API. API Gateway có thể dùng Cognito Authorizer để kiểm tra token trước khi cho request đi tiếp.

Luồng cơ bản:

```text
User → Cognito Sign In → JWT Token → API Gateway Authorizer → Lambda
```

#### SQS/SNS

Em tìm hiểu cách SQS và SNS giúp xử lý message bất đồng bộ:

- **SNS:** publish/subscribe, gửi thông báo đến nhiều subscriber.
- **SQS:** queue message để worker xử lý dần.
- Kết hợp SNS + SQS giúp giảm coupling giữa các thành phần.

Kiến trúc này phù hợp cho các tác vụ không cần xử lý đồng bộ ngay lập tức, ví dụ gửi email, xử lý ảnh, ghi log hoặc trigger workflow phụ.

#### CloudWatch và X-Ray

CloudWatch hỗ trợ xem logs, metrics và alarms. X-Ray giúp trace request qua nhiều thành phần, đặc biệt hữu ích khi debug kiến trúc serverless nhiều service.

### Kết quả đạt được

- Hiểu cách xây dựng API serverless bằng API Gateway + Lambda.
- Biết cách dùng Cognito để bảo vệ API.
- Nắm được vai trò của SQS/SNS trong xử lý bất đồng bộ.
- Biết theo dõi Lambda logs và lỗi bằng CloudWatch.
- Hiểu cách serverless giúp giảm vận hành server nhưng vẫn cần kiểm soát IAM, logging và chi phí.

### Liên hệ An ninh mạng

Serverless không có nghĩa là không cần bảo mật. Các rủi ro chính gồm:

- Lambda execution role cấp quyền quá rộng.
- API Gateway thiếu authorizer hoặc throttling.
- Token Cognito cấu hình sai.
- Message queue chứa dữ liệu nhạy cảm.
- Log vô tình ghi thông tin bí mật.

Vì vậy, cần áp dụng least privilege, input validation, API authentication, encryption và logging có kiểm soát.

### Khó khăn và bài học

- Debug serverless khó hơn ứng dụng truyền thống vì request đi qua nhiều service.
- IAM permission cho Lambda cần được cấp đúng và đủ.
- Cần cleanup API, Lambda, queue và log group để tránh phát sinh chi phí.
- Observability là bắt buộc khi thiết kế ứng dụng serverless.

### Chuẩn bị cho tuần 11

Sau khi hoàn thành phần serverless, em chuyển sang **DevOps & Containers**, tập trung vào Docker, Amazon ECS, CodeBuild và CodePipeline.

