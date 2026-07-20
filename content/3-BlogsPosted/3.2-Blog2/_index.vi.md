---
title: "Quy trình xử lý sự cố thông minh và có kiểm soát trong AWS CloudSOC"
date: 2026-07-02
weight: 2
chapter: false
pre: " <b> 3.2. </b> "
---

Sau khi hoàn thành Proof of Concept cho dự án **AWS CloudSOC**, điều mình thấy giá trị nhất không chỉ là kiến trúc tổng thể, mà còn là **quy trình xử lý sự cố được thiết kế có kiểm soát, rõ ràng và bám sát thực tế vận hành SOC trên Cloud**.

Khi **Amazon GuardDuty** phát hiện các hành vi bất thường như **SSH brute-force**, **port scanning** hoặc truy cập từ **IP đáng ngờ**, hệ thống không phản ứng một cách máy móc mà sẽ đi qua một chuỗi bước được thiết kế cẩn thận để vừa đảm bảo tốc độ phản ứng, vừa tránh tác động sai tới tài nguyên đang chạy.

---

## Luồng xử lý sự cố trong AWS CloudSOC

Quy trình xử lý sự cố của hệ thống diễn ra như sau:

1. **Amazon GuardDuty** phát hiện finding và phát sinh alert.
2. Alert được đưa vào **Amazon EventBridge** để làm đầu vào cho workflow xử lý sự cố.
3. **AWS Step Functions** được kích hoạt và đóng vai trò là bộ não trung tâm điều phối toàn bộ quy trình.
4. Tại đây, workflow sẽ đánh giá nhiều điều kiện như:
   - Mức độ nghiêm trọng của finding  
   - Sự tồn tại của tag `AutoIsolate=true`  
   - Chế độ **Dry-run**  
   - Loại tài nguyên bị ảnh hưởng  
   - Các điều kiện bổ sung khác phục vụ quyết định phản ứng
5. Nếu finding thuộc trường hợp cần phê duyệt, hệ thống sẽ gửi thông báo tới **SOC Analyst** qua **Slack** và **Email / SMS**.
6. SOC Analyst truy cập **Dashboard** để xem chi tiết incident và đưa ra quyết định **Approve** hoặc **Reject**.
7. Sau khi được phê duyệt, **AWS Systems Manager** sẽ thực thi các lệnh forensic để thu thập thông tin từ EC2, bao gồm:
   - Tiến trình đang chạy  
   - Kết nối mạng  
   - System logs  
   - Routing table  
   - Thông tin người dùng
8. Tiếp theo, hệ thống tạo **EBS Snapshot** để bảo toàn trạng thái ổ đĩa làm bằng chứng phục vụ điều tra.
9. Sau đó, **Incident Response Lambda** sẽ thay đổi **Security Group** từ `SG-Workload` sang `SG-Isolation` để cô lập hoàn toàn EC2 instance bị nghi ngờ.
10. Cuối cùng, toàn bộ bằng chứng sẽ được lưu vào **Amazon S3**, trạng thái incident được cập nhật trong **Amazon DynamoDB**, và kết quả xử lý được gửi thông báo tới SOC Analyst.

---

## Luồng xử lý tổng quát

```text
GuardDuty
→ EventBridge
→ Step Functions
→ Approval / Decision
→ Systems Manager Forensics
→ EBS Snapshot
→ Lambda Isolation
→ S3 Evidence Storage
→ DynamoDB Incident Update
→ SNS / Slack / Email Notification
```

---

## Diagram phần Threat Detection & Response

Dưới đây là sơ đồ tập trung vào phần **Threat Detection & Response** trong hệ thống AWS CloudSOC:

![Threat Detection and Response Diagram](/images/3-BlogsPosted/3.2-Blog2/threat-detection-response-diagram.png)

Sơ đồ này thể hiện rõ cách **GuardDuty**, **EventBridge**, **Step Functions**, **Systems Manager**, **Lambda**, **S3**, **DynamoDB** và **SNS** phối hợp với nhau để tạo thành một quy trình phản ứng sự cố có kiểm soát.

---

## Những điều mình học được

Qua phần triển khai workflow này, mình rút ra được khá nhiều điều quan trọng:

- **AWS Step Functions** là một công cụ cực kỳ mạnh mẽ để xây dựng các workflow phức tạp, đặc biệt khi có nhiều nhánh điều kiện và có sự tham gia của con người.
- **AWS Systems Manager** kết hợp với **Run Command** là một giải pháp rất hiệu quả để thu thập forensic trên EC2 mà không cần đăng nhập thủ công.
- Trong xử lý sự cố, **thứ tự thực hiện** là yếu tố cực kỳ quan trọng. Nếu làm sai thứ tự, chúng ta có thể vô tình làm mất hoặc thay đổi bằng chứng.

---

## Những kinh nghiệm thực tế

Trong quá trình làm dự án, nhóm mình cũng nhận ra một số kinh nghiệm rất thực tế:

- Không nên thiết kế hệ thống **tự động cô lập ngay lập tức với mọi alert**. Cần phân loại rõ ràng theo mức độ nghiêm trọng và bối cảnh cụ thể.
- Cần có cơ chế **phê duyệt thủ công** cho các trường hợp chưa đủ chắc chắn, nhằm tránh gây gián đoạn ngoài ý muốn.
- Việc **backup bằng chứng đầy đủ** như tạo snapshot và lưu trữ vào S3 phải được thực hiện **trước bất kỳ hành động nào có thể làm thay đổi dữ liệu**.
- Chế độ **Dry-run** là rất cần thiết trong giai đoạn kiểm thử để đảm bảo workflow chạy đúng logic trước khi áp dụng phản ứng thật.

---

## Kết luận

Điều thú vị nhất khi xây dựng AWS CloudSOC không chỉ nằm ở việc “tự động hóa”, mà là làm sao để **tự động hóa một cách thông minh, có kiểm soát và phù hợp với thực tế vận hành an ninh trên Cloud**.

Hệ thống chỉ thực sự có giá trị khi nó không chỉ phát hiện được mối đe dọa, mà còn phản ứng đúng lúc, đúng cách và vẫn đảm bảo bảo toàn bằng chứng phục vụ điều tra.

Anh chị em nào đã từng gặp tình huống **GuardDuty sinh ra quá nhiều alert** nhưng chưa biết cách tổ chức xử lý hiệu quả chưa? Hãy chia sẻ kinh nghiệm thực chiến của mình bên dưới để mọi người cùng học hỏi.