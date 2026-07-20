---
title: "Event 1: AWS AI Day / FCAJ Meetup"
date: 2026-05-09
weight: 1
chapter: false
pre: " <b> 4.1. </b> "
---

### Thông tin sự kiện

* **Tên sự kiện:** AWS AI Day / FCAJ Meetup  
* **Ngày:** 09 tháng 5 năm 2026  
* **Vai trò:** Người tham dự

### Mục đích sự kiện

Sự kiện được tổ chức nhằm chia sẻ kiến thức thực tiễn về Trí tuệ Nhân tạo (AI), các dịch vụ đám mây AWS, phát triển sản phẩm AI, kiến trúc serverless và các phương pháp phát triển phần mềm hiện đại sử dụng AI.

Qua các phiên chia sẻ, người tham dự có cơ hội học cách thiết kế, tối ưu, bảo mật và triển khai sản phẩm AI bằng các dịch vụ AWS. Sự kiện cũng giới thiệu các cách tiếp cận hiện đại như Vibe Coding, Vibe Method, Multi-Agent AI, lập kế hoạch dựa trên PRD và quy trình kỹ thuật phần mềm có cấu trúc.

### Nội dung chính

#### Ý tưởng sản phẩm AI và công cụ tối ưu Prompt

Một trong những nội dung chính là xây dựng sản phẩm AI giúp người dùng tối ưu prompt và sử dụng AI hiệu quả hơn.

Diễn giả giới thiệu ý tưởng về một công cụ AI giống như “Proximizer”, có thể hỗ trợ người dùng bằng cách:
* Tối ưu prompt đầu vào cho AI.
* Tách biệt các ngữ cảnh chat AI để tránh làm model bị nhầm lẫn.
* Cho phép sử dụng AI ở bất kỳ đâu trên màn hình thông qua phím tắt.
* Giúp người dùng nhanh chóng hỏi AI từ đoạn văn bản được chọn.

Ví dụ: Khi đọc bài báo, người dùng chỉ cần highlight cụm từ “Zelensky là ai?” và hỏi AI ngay lập tức mà không cần mở cửa sổ chat riêng.

Ý tưởng này cho thấy một sản phẩm AI tốt không chỉ tập trung vào model mà còn phải chú trọng đến trải nghiệm người dùng và cách họ tương tác với AI trong công việc hàng ngày.

#### Chi phí xây dựng sản phẩm AI trên AWS

Sự kiện cũng thảo luận về chi phí khi xây dựng ứng dụng AI bằng dịch vụ AWS.

AWS có nhiều dịch vụ hỗ trợ Free Tier. Tuy nhiên, Amazon Bedrock không sử dụng tín dụng Free Tier giống như một số dịch vụ khác. Chi phí sử dụng Amazon Bedrock phụ thuộc vào:
* Số token đầu vào (Input tokens)
* Số token đầu ra (Output tokens)
* Model AI đang sử dụng

Diễn giả giải thích rằng các model nhẹ như Haiku hoặc model dựa trên Gemini thường rẻ hơn so với các model mạnh hơn.

Phiên chia sẻ nhấn mạnh lợi ích của kiến trúc **serverless**. Với serverless, developer không cần quản lý server thủ công và chỉ trả tiền khi hệ thống được sử dụng. Với một ứng dụng nhỏ có khoảng 100 người dùng/ngày, chi phí có thể vẫn rất thấp, thậm chí một số thành phần vẫn nằm trong giới hạn AWS Free Tier.

#### EC2 so với Lambda

Sự kiện giải thích sự khác biệt giữa Amazon EC2 và AWS Lambda.

**AWS Lambda** là dịch vụ serverless. Nó chỉ chạy khi có request hoặc event và tự động dừng sau khi hoàn thành. Lambda phù hợp với các tác vụ nhẹ, API nhỏ và xử lý theo sự kiện. Tuy nhiên, nó có giới hạn thời gian thực thi tối đa 15 phút.

**Amazon EC2** là máy chủ ảo chạy liên tục. Chi phí tính theo thời gian instance đang chạy. EC2 phù hợp với backend nặng, xử lý lâu dài, Redis và các ứng dụng lớn cần kiểm soát môi trường nhiều hơn.

**Tóm tắt so sánh:**

| AWS Lambda              | Amazon EC2                  |
|-------------------------|-----------------------------|
| Serverless              | Máy chủ ảo                  |
| Chỉ chạy khi có trigger | Chạy liên tục               |
| Tính phí theo request   | Tính phí theo thời gian chạy|
| Phù hợp công việc nhẹ   | Phù hợp workload nặng       |
| Tự động dừng sau khi chạy | Phải quản lý thủ công     |

#### AI Hallucination và thiết kế Prompt

Một chủ đề quan trọng khác là **AI Hallucination** (tình trạng AI bịa thông tin). Hallucination xảy ra khi AI tạo ra thông tin sai, không có cơ sở hoặc bịa đặt.

Diễn giả cho biết prompt mơ hồ sẽ làm tăng nguy cơ hallucination. Thay vì chỉ nói AI “không được làm gì”, nên nói rõ AI “phải làm gì”.

Ví dụ:
- Thay vì: “Đừng mắc lỗi.”
- Nên dùng: “Nếu không có đủ thông tin, hãy trả lời là bạn không biết.”  
  “Không được tạo thông tin không có trong dữ liệu.”  
  “Chỉ trả lời dựa trên dữ liệu được cung cấp.”

Phần này giúp hiểu rằng thiết kế prompt rất quan trọng. Hướng dẫn rõ ràng, quy tắc và giới hạn sẽ giảm hallucination và nâng cao chất lượng phản hồi của AI.

#### Bảo mật cho hệ thống AI

Sự kiện giới thiệu một số dịch vụ và khái niệm bảo mật AWS hữu ích khi xây dựng hệ thống AI:
* **Amazon WAF**: Bảo vệ ứng dụng web bằng cách lọc request độc hại, chặn IP xấu.
* **Amazon Cognito**: Quản lý xác thực người dùng (login, tài khoản, mật khẩu).
* **Amazon Bedrock Guardrails**: Kiểm soát hành vi AI, lọc prompt nguy hiểm hoặc nội dung nhạy cảm.

Diễn giả cũng nhấn mạnh tầm quan trọng của **disclaimer** (lời cảnh báo) khi AI đưa ra thông tin liên quan đến sức khỏe, pháp lý… để tránh hiểu lầm hoặc rủi ro pháp lý.

#### Ý tưởng UX/UI cho công cụ AI

Nhiều người dùng không biết cách viết prompt tốt. Vì vậy, công cụ AI tốt cần giảm thiểu suy nghĩ và thao tác thủ công cho người dùng bằng cách:
* Gợi ý prompt
* Tự động tối ưu prompt
* Cung cấp form nhập liệu đơn giản

Tuy nhiên, không nên ép người dùng điền quá nhiều trường thông tin. Tự động tối ưu prompt sẽ mang lại trải nghiệm mượt mà và tiện lợi hơn.

#### Vibe Coding và những hạn chế

**Vibe Coding** là cách nhiều người dùng AI bằng cách liên tục prompt và mong AI tự xây dựng toàn bộ sản phẩm. Tuy nhiên cách này dễ dẫn đến:
* AI quên mục tiêu ban đầu
* Context bị rối
* Code lộn xộn, khó triển khai và bảo trì
* Tăng nguy cơ hallucination

#### Vibe Method

Để khắc phục hạn chế của Vibe Coding, diễn giả giới thiệu **Vibe Method** – cách sử dụng AI có cấu trúc.

Thay vì để AI làm tất cả trong một cuộc chat lớn, dự án được chia nhỏ với ngữ cảnh rõ ràng, trách nhiệm cụ thể và quy trình có hệ thống (gần với Agile, Scrum).

Quy trình tổng quát:
**Idea → PRD → Architecture → Epic → Story → Coding → Review → QA → Deploy**

#### Multi-Agent AI

Một ý tưởng quan trọng là **Multi-Agent AI**: Sử dụng nhiều AI agent với vai trò khác nhau (Product Manager, Architect, Developer, Code Reviewer, QA…).

Mỗi agent chỉ tập trung vào một phần nhỏ, giúp giảm hallucination và dễ quản lý hơn.

#### Vai trò của con người

AI chỉ là công cụ hỗ trợ. Con người vẫn phải duyệt, phê duyệt, điều phối và chịu trách nhiệm cuối cùng.

### Bài học rút ra
* Serverless giúp giảm chi phí cho ứng dụng AI nhỏ và vừa.
* Lambda phù hợp công việc nhẹ, EC2 phù hợp workload nặng.
* Prompt rõ ràng giúp giảm hallucination.
* Bảo mật phải được xem xét từ đầu.
* UX/UI quan trọng vì người dùng thường không biết viết prompt tốt.
* Vibe Coding không cấu trúc dễ thất bại.
* Vibe Method + Multi-Agent AI là cách sử dụng AI hiệu quả hơn.
* Con người vẫn là yếu tố quyết định.

### Áp dụng vào công việc
* Sử dụng Lambda cho API nhẹ, EC2 cho hệ thống nặng.
* Thiết kế prompt tốt hơn khi dùng AI.
* Áp dụng PRD, Architecture, Task breakdown khi xây dựng dự án.
* Sử dụng AI như trợ lý, nhưng vẫn kiểm tra và kiểm soát kết quả.

### Cảm nhận về sự kiện
Tham gia sự kiện mang lại cái nhìn toàn diện về cả kỹ thuật lẫn sản phẩm khi xây dựng ứng dụng AI. Sự kiện giúp tôi hiểu rõ hơn về AWS, serverless, prompt engineering, bảo mật AI và cách sử dụng AI trong phát triển phần mềm hiện đại.

**Hình ảnh sự kiện**  
![Event 09/05](/images/event1.png)