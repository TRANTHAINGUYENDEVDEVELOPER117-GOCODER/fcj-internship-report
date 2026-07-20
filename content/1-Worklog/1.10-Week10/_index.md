---
title: "Week 10 Worklog"
date: 2026-07-11
weight: 10
chapter: false
pre: " <b> 1.10. </b> "
---

# Week 10 Worklog: Serverless, API Gateway, and Event-Driven Architecture

### Overview

Week 10 focused on the **Modernize Application** track. I studied serverless and event-driven architecture using AWS Lambda, Amazon API Gateway, DynamoDB, S3, Cognito, SQS/SNS, CloudWatch, and AWS X-Ray.

### Completed tasks

| Item | Task | Status |
| --- | --- | --- |
| 01 | Lambda interacting with DynamoDB/S3 | ✅ Completed |
| 02 | API Gateway REST API integrated with Lambda | ✅ Completed |
| 03 | Cognito User Pool and API Authorizer | ✅ Completed |
| 04 | SQS/SNS asynchronous message processing | ✅ Completed |
| 05 | CloudWatch Logs and X-Ray tracing | ✅ Completed |
| 06 | Cleanup serverless resources | ✅ Completed |

### Key learning outcomes

- Built an understanding of API Gateway + Lambda serverless APIs.
- Learned how Cognito protects API access using JWT tokens and authorizers.
- Understood the role of SQS/SNS in loosely coupled application design.
- Practiced observing Lambda logs and errors through CloudWatch.
- Learned that serverless reduces server operations but still requires strong IAM, logging, and cost control.

### Cybersecurity relevance

Serverless applications still need security controls. Lambda roles must follow least privilege, APIs should use authentication and throttling, sensitive data should not be logged, and queues/topics must be protected with proper IAM policies and encryption where needed.

### Preparation for week 11

After serverless topics, I moved to **DevOps & Containers**, focusing on Docker, Amazon ECS, CodeBuild, and CodePipeline.

