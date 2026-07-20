---
title: "Week 11 Worklog"
date: 2026-07-18
weight: 11
chapter: false
pre: " <b> 1.11. </b> "
---

# Week 11 Worklog: Docker, Amazon ECS, and CI/CD

### Overview

Week 11 focused on **DevOps & Containers** in the Modernize track. The main topics were Docker, Amazon ECR, Amazon ECS, CodeBuild, CodePipeline, and security considerations for automated deployments.

### Completed tasks

| Item | Task | Status |
| --- | --- | --- |
| 01 | Dockerfile, image build, and local container run | ✅ Completed |
| 02 | Amazon ECR repository and image push | ✅ Completed |
| 03 | Amazon ECS task definition, cluster, and service | ✅ Completed |
| 04 | CodeBuild build/test/push workflow | ✅ Completed |
| 05 | CodePipeline source → build → deploy flow | ✅ Completed |
| 06 | Cleanup ECS/ECR/pipeline resources | ✅ Completed |

### Key learning outcomes

- Understood how containers make application deployment more consistent.
- Learned the flow: build image → push to ECR → deploy with ECS.
- Practiced the basic concepts of ECS task definitions and services.
- Learned how CodeBuild and CodePipeline support CI/CD automation.
- Identified key security points in container and pipeline workflows.

### Cybersecurity relevance

CI/CD pipelines must be secured carefully. Secrets should not be hard-coded, CodeBuild/CodePipeline roles should follow least privilege, container images should be scanned, and build logs should not expose tokens or passwords.

### Preparation for week 12

After completing week 11, I prepared for the final phase: cleanup, final report review, Proposal, Workshop, Self-evaluation, Feedback, and full website validation.

