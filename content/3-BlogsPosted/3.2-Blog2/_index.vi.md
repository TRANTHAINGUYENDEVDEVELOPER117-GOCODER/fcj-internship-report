---
title: "Ứng dụng Apache Iceberg và Materialized Views để truy vấn log siêu tốc"
date: 2026-07-19
weight: 2
chapter: false
pre: " <b> 3.2. </b> "
---

# AWS Big Data Blog: Ứng dụng Apache Iceberg và Materialized Views để truy vấn log siêu tốc

Trong quá trình tham gia chương trình **FCAJ**, mình quan tâm nhiều hơn đến bài toán vận hành hệ thống dữ liệu lớn, đặc biệt là xử lý log. Log hệ thống, log mạng và log ứng dụng thường được lưu rất nhiều, nhưng khi cần truy vấn để phát hiện bất thường hoặc tạo dashboard, việc quét dữ liệu thô liên tục có thể gây độ trễ cao và chi phí lớn.

Gần đây, mình đọc bài **“Accelerating log analytics at scale with AWS Glue and Apache Iceberg materialized views”** trên AWS Big Data Blog. Bài viết giới thiệu một kiến trúc kết hợp **AWS Glue**, **Apache Iceberg** và **Materialized Views** để tăng tốc phân tích log ở quy mô lớn.

![AWS Glue, Apache Iceberg và Materialized Views](/images/3-BlogsPosted/blog2-iceberg-materialized-views.png)

### 1. Nỗi ám ảnh mang tên truy vấn dữ liệu thô

Trong các hệ thống phân tích truyền thống, log thường được lưu dưới dạng JSON, CSV hoặc Parquet trên Amazon S3. Khi đội vận hành cần dashboard hoặc truy vấn phân tích xu hướng, công cụ như Amazon Athena có thể phải quét qua lượng dữ liệu rất lớn.

Nếu một query cứ chạy đi chạy lại trên cùng tập log khổng lồ chỉ để tính vài chỉ số tổng hợp, hệ thống gặp hai vấn đề:

- **Độ trễ cao:** dashboard có thể mất vài phút, thậm chí lâu hơn để tải.
- **Chi phí tăng:** chi phí scan dữ liệu và tính toán tăng theo lượng dữ liệu truy vấn.

Với hệ thống security/operation, tốc độ truy vấn log ảnh hưởng trực tiếp đến tốc độ điều tra và ra quyết định.

### 2. Bộ ba giải pháp: AWS Glue, Apache Iceberg và Materialized Views

#### Apache Iceberg: định dạng bảng dữ liệu hiện đại

Thay vì lưu log thành các file rời rạc khó quản lý, bài viết sử dụng **Apache Iceberg**, một open table format giúp tổ chức dữ liệu trên Amazon S3 giống như bảng dữ liệu hiện đại.

Iceberg hỗ trợ:

- ACID transaction.
- Schema evolution.
- Time travel.
- Quản lý metadata hiệu quả.
- Tối ưu hóa việc đọc dữ liệu.

Nhờ đó, dữ liệu log liên tục đổ về vẫn có thể được quản lý và truy vấn ổn định hơn so với việc chỉ lưu file thô.

#### AWS Glue: cỗ máy xử lý dữ liệu serverless

**AWS Glue** được sử dụng như dịch vụ ETL/serverless integration. Glue có thể:

- Thu thập log thô từ các nguồn như EC2 application logs hoặc VPC Flow Logs.
- Làm sạch và chuyển đổi định dạng.
- Ghi dữ liệu vào bảng Apache Iceberg trên S3.
- Quản lý metadata thông qua AWS Glue Data Catalog.

Điểm mạnh là nhóm vận hành không cần tự quản lý cluster ETL cố định.

#### Materialized Views: bảng tổng hợp đã tính sẵn

Điểm quan trọng nhất trong bài là **Materialized Views (MV)**.

Có thể hiểu MV là một bảng tổng hợp đã được tính toán trước. Ví dụ, thay vì truy vấn hàng triệu dòng log mỗi lần, MV có thể lưu sẵn kết quả:

```text
Trong 1 giờ qua, IP A gửi bao nhiêu request?
Service nào có nhiều HTTP 5xx nhất?
Tổng băng thông theo từng 5 phút là bao nhiêu?
```

Khi dashboard mở lên, hệ thống chỉ đọc dữ liệu từ MV nhỏ hơn rất nhiều so với bảng log gốc. Điều này giúp giảm thời gian phản hồi và tiết kiệm chi phí scan dữ liệu.

### 3. Quy trình triển khai thực tế

#### Bước 1: Tập trung dữ liệu log

Các log mạng, log ứng dụng hoặc log truy cập được đẩy liên tục vào Amazon S3. Đây là vùng lưu trữ dữ liệu thô ban đầu, đóng vai trò data lake.

#### Bước 2: Chuẩn hóa bằng AWS Glue Data Catalog và Apache Iceberg

Dữ liệu thô thường không đồng nhất. AWS Glue Data Catalog giúp nhận diện schema, còn Glue job chuyển đổi dữ liệu sang bảng Apache Iceberg. Sau bước này, dữ liệu log có metadata và cấu trúc tốt hơn để truy vấn.

#### Bước 3: Tạo và tự động làm mới Materialized Views

Sử dụng AWS Glue/Spark SQL để tạo MV cho các chỉ số thường dùng. Ví dụ:

- Số request lỗi HTTP 5xx theo service.
- Tổng traffic theo IP nguồn/đích.
- Số lượng event theo account, region hoặc application.
- Tỷ lệ lỗi theo khoảng thời gian.

MV có thể được refresh theo lịch hoặc incremental, giúp chỉ xử lý phần dữ liệu mới thay vì tính lại toàn bộ.

#### Bước 4: Truy vấn tốc độ cao và trực quan hóa

Cuối cùng, kỹ sư vận hành có thể dùng Amazon Athena truy vấn trực tiếp vào Materialized Views thay vì bảng log gốc. Kết quả có thể đưa lên dashboard như Amazon QuickSight hoặc Grafana.

### 4. Giá trị đối với vận hành và bảo mật

Kiến trúc này đặc biệt hữu ích trong các tình huống:

- Tạo dashboard giám sát hạ tầng.
- Phân tích VPC Flow Logs để phát hiện IP bất thường.
- Tổng hợp application logs phục vụ incident response.
- Theo dõi lỗi HTTP 4xx/5xx.
- Giảm chi phí Athena scan dữ liệu.
- Tăng tốc điều tra khi có sự cố.

Với góc nhìn An ninh mạng, việc truy vấn log nhanh hơn đồng nghĩa với **Mean Time To Detect (MTTD)** và **Mean Time To Investigate (MTTI)** có thể giảm.

### 5. Trade-off cần lưu ý

Materialized Views không thay thế hoàn toàn bảng log gốc. Một số truy vấn điều tra sâu vẫn cần dữ liệu raw chi tiết.

Ngoài ra, nhóm vận hành cần thiết kế MV cẩn thận:

- Nếu MV quá ít, dashboard vẫn phải quét dữ liệu gốc.
- Nếu MV quá nhiều, chi phí refresh và quản lý metadata tăng.
- Nếu schema log thay đổi, pipeline cần xử lý schema evolution đúng cách.
- Cần có lifecycle policy cho dữ liệu cũ trên S3 để kiểm soát chi phí.

### 6. Kết luận

Phân tích log ở quy mô lớn luôn là bài toán khó về hiệu năng và chi phí. Cách kết hợp **AWS Glue**, **Apache Iceberg** và **Materialized Views** thể hiện tư duy “tính toán một lần, truy vấn nhiều lần”.

Thay vì để dashboard liên tục quét dữ liệu thô, hệ thống chuẩn bị sẵn các bảng tổng hợp phục vụ những truy vấn phổ biến. Đây là một hướng tiếp cận rất phù hợp cho Data Engineering, Cloud Operations và Cloud Security.

### Tài liệu tham khảo

- [AWS Big Data Blog: Accelerating log analytics at scale with AWS Glue and Apache Iceberg materialized views](https://aws.amazon.com/vi/blogs/big-data/accelerating-log-analytics-at-scale-with-aws-glue-and-apache-iceberg-materialized-views/)

