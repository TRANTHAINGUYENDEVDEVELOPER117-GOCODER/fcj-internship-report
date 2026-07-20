---
title: "Tài liệu tham khảo & cleanup lab"
date: 2026-07-11
weight: 6
chapter: false
pre: " <b> 5.6. </b> "
---

# Tài liệu tham khảo & cleanup lab

### 1. Tài liệu tham khảo

- [AWS Architecture Icons](https://aws.amazon.com/architecture/icons/)
- [AWS Well-Architected Framework – Security Pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)
- [Amazon GuardDuty Documentation](https://docs.aws.amazon.com/guardduty/)
- [AWS Security Hub Documentation](https://docs.aws.amazon.com/securityhub/)
- [Amazon Detective Documentation](https://docs.aws.amazon.com/detective/)
- [AWS Step Functions Documentation](https://docs.aws.amazon.com/step-functions/)
- [AWS Systems Manager Documentation](https://docs.aws.amazon.com/systems-manager/)
- [AWS Config Documentation](https://docs.aws.amazon.com/config/)
- [AWS KMS Documentation](https://docs.aws.amazon.com/kms/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

### 2. Checklist cleanup sau lab

Sau khi hoàn thành demo/workshop, cần cleanup để tránh phát sinh chi phí.

#### EC2 & Network

- Terminate EC2 workload thử nghiệm.
- Xóa Elastic IP nếu có.
- Xóa NAT Gateway nếu đã tạo.
- Xóa ALB/Target Group nếu có.
- Xóa Security Group không còn dùng.
- Xóa VPC Flow Logs nếu không cần lưu tiếp.

#### Detection & Security

- Disable GuardDuty nếu chỉ bật để test ngắn hạn.
- Disable Security Hub nếu không tiếp tục sử dụng.
- Xóa EventBridge rules phục vụ lab.
- Xóa Detective graph nếu đã tạo và không dùng nữa.

#### Serverless & Workflow

- Xóa Step Functions state machine.
- Xóa Lambda functions:
  - Dashboard API Lambda.
  - Incident Response Lambda.
- Xóa API Gateway endpoint.
- Xóa SNS topics/subscriptions.

#### Storage & Evidence

- Kiểm tra S3 evidence bucket.
- Tải evidence cần giữ trước khi xóa.
- Xóa object trong bucket nếu không cần.
- Xóa bucket sau khi đã empty.
- Xóa EBS Snapshots lab.
- Xóa CloudWatch log groups nếu không cần lưu.

#### IAM & Governance

- Xóa IAM roles/policies tạo riêng cho lab.
- Xóa KMS key alias nếu không dùng.
- Xóa AWS Config rules/recorder nếu chỉ bật để demo.

### 3. Lưu ý chi phí

Các dịch vụ có thể phát sinh chi phí nếu để lâu:

- EC2 instance.
- EBS volume/snapshot.
- NAT Gateway.
- GuardDuty.
- Security Hub.
- Detective.
- CloudWatch Logs.
- S3 storage.
- KMS key.
- Step Functions executions.

Vì vậy, sau khi hoàn tất báo cáo và chụp evidence, nên cleanup ngay những tài nguyên không cần thiết.

### 4. Cách trình bày khi nộp công ty

Khi nộp, nên chuẩn bị:

- Link website Hugo đã build/deploy.
- Ảnh kiến trúc CloudSOC chất lượng cao.
- File `.drawio` gốc để chứng minh có thể chỉnh sửa.
- Báo cáo tóm tắt 1–2 trang nếu công ty yêu cầu bản Word/PDF.
- Danh sách service AWS đã nghiên cứu.
- Ghi chú rõ đây là **Lab / Proof of Concept**, chưa phải hệ thống production.

### 5. Checklist cuối trước khi gửi công ty

Trước khi gửi link website hoặc file báo cáo cho công ty, nhóm cần kiểm tra:

- Tên nhóm hiển thị đầy đủ: **Trần Thái Nguyên** và **Dương Bá Đạt**.
- Proposal và Workshop đều thống nhất cùng một đề tài **AWS CloudSOC**.
- Sơ đồ kiến trúc khớp với tài liệu hướng dẫn vẽ.
- Luồng phản ứng sự cố đúng thứ tự: Detect → Investigate → Decide → Collect Evidence → Create Snapshot → Contain → Notify.
- Có ghi rõ đây là **Lab / Proof of Concept**, không phải production hoàn chỉnh.
- Có hướng nâng cấp production để thể hiện tư duy mở rộng.
- Đã cleanup hoặc ghi chú cleanup các tài nguyên AWS có thể phát sinh chi phí.

### 6. Kết luận workshop

Workshop AWS CloudSOC giúp nhóm thể hiện tư duy thiết kế hệ thống an ninh mạng trên AWS: biết phát hiện, điều tra, thu thập bằng chứng, phản ứng có kiểm soát và trình bày kiến trúc một cách chuyên nghiệp. Đây là nền tảng tốt để tiếp tục phát triển thành một SOC cloud production-ready trong tương lai.

