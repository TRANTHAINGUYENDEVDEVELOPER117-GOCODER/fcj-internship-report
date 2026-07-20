---
title: "Worklog Tuần 11"
date: 2026-07-18
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

# Worklog Tuần 11: Docker, Amazon ECS và CI/CD

### Tổng quan tuần 11 (18/07 – 24/07/2026)

Tuần 11 tập trung vào phần **DevOps & Containers** trong lộ trình Modernize. Nội dung chính gồm Docker, Amazon ECS, Amazon ECR, CodeBuild, CodePipeline và các điểm cần lưu ý khi tự động hóa triển khai ứng dụng trên AWS.

Mục tiêu của tuần này là hiểu cách đóng gói ứng dụng bằng container, triển khai container lên ECS và xây dựng pipeline CI/CD để giảm thao tác thủ công khi build/deploy.

### Mục tiêu tuần 11

- Hiểu Dockerfile, image, container và container registry.
- Làm quen Amazon ECR để lưu trữ container image.
- Hiểu ECS cluster, task definition, service và deployment.
- Tìm hiểu CodeBuild để build image và chạy kiểm thử.
- Tìm hiểu CodePipeline để tự động hóa source → build → deploy.
- Nhận diện rủi ro bảo mật trong pipeline và container.
- Cleanup container image, service và pipeline sau lab.

### Công việc đã thực hiện

| Bước | Nội dung | Trạng thái | Nguồn |
| --- | --- | --- | --- |
| 01 | Docker: Dockerfile, build image, chạy container local | ✅ Hoàn thành | [Cloud Journey – Modernize](https://cloudjourney.awsstudygroup.com/4-modernize/) |
| 02 | Amazon ECR: tạo repository và push image | ✅ Hoàn thành | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 03 | Amazon ECS: task definition, cluster, service | ✅ Hoàn thành | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 04 | CodeBuild: build/test/push image | ✅ Hoàn thành | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 05 | CodePipeline: source → build → deploy | ✅ Hoàn thành | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 06 | Cleanup ECS/ECR/pipeline resources | ✅ Hoàn thành | — |

### Nội dung chi tiết

#### Docker

Em tìm hiểu Docker ở mức nền tảng:

- **Dockerfile:** mô tả cách build image.
- **Image:** gói ứng dụng và dependency.
- **Container:** instance chạy từ image.
- **Port mapping:** ánh xạ cổng container ra bên ngoài.
- **Environment variables:** truyền cấu hình khi chạy container.

Docker giúp ứng dụng chạy nhất quán hơn giữa môi trường local, test và cloud.

#### Amazon ECR

Amazon Elastic Container Registry dùng để lưu trữ container image. Flow cơ bản:

```text
Build image → Tag image → Login ECR → Push image → ECS pulls image
```

ECR giúp quản lý image trong AWS account, tích hợp IAM và có thể kết hợp image scanning để kiểm tra lỗ hổng.

#### Amazon ECS

Amazon ECS giúp chạy container ở quy mô lớn. Các khái niệm chính:

- **Cluster:** nhóm tài nguyên để chạy workload.
- **Task Definition:** mô tả container image, CPU/memory, port, environment variables, IAM role.
- **Task:** instance chạy theo task definition.
- **Service:** duy trì số lượng task mong muốn và hỗ trợ deployment.

Qua phần này, em hiểu ECS phù hợp để triển khai ứng dụng container mà không cần tự quản lý quá nhiều chi tiết hạ tầng.

#### CodeBuild và CodePipeline

CI/CD giúp tự động hóa quá trình build và deploy:

```text
Source → CodeBuild → ECR → ECS Deploy
```

CodeBuild có thể chạy buildspec để:

- Cài dependency.
- Chạy test.
- Build Docker image.
- Push image lên ECR.

CodePipeline điều phối các stage từ source đến build và deploy, giúp giảm lỗi do thao tác thủ công.

### Kết quả đạt được

- Hiểu vai trò của container trong modern application.
- Biết flow cơ bản để build image và push lên ECR.
- Nắm được cách ECS sử dụng task definition và service.
- Hiểu cách CodeBuild/CodePipeline hỗ trợ CI/CD.
- Biết các điểm cần kiểm soát trong pipeline: IAM role, secrets, image, logs và approval.

### Liên hệ An ninh mạng

CI/CD và container có nhiều điểm liên quan trực tiếp đến security:

- Image có thể chứa lỗ hổng nếu base image cũ.
- Secret không được hard-code trong Dockerfile hoặc source code.
- IAM role cho CodeBuild/CodePipeline cần giới hạn theo least privilege.
- Pipeline nên có bước kiểm thử hoặc scan trước khi deploy.
- Log build không nên in ra token, password hoặc secret.
- ECR image scanning giúp phát hiện một số lỗ hổng container phổ biến.

### Khó khăn và bài học

- Dockerfile cần tối ưu để image nhỏ và ít dependency dư thừa.
- ECS có nhiều thành phần nên cần hiểu rõ task definition, service, security group và IAM role.
- Pipeline tự động giúp giảm thao tác thủ công nhưng nếu cấu hình sai có thể tự động deploy lỗi.
- Cleanup ECR image, ECS service và pipeline rất quan trọng để tránh phát sinh chi phí.

### Chuẩn bị cho tuần 12

Sau khi hoàn thành tuần 11, em chuyển sang giai đoạn cuối: tổng kết, cleanup tài nguyên, hoàn thiện Proposal, Workshop, Self-evaluation, Feedback và rà soát toàn bộ website báo cáo trước khi nộp.

