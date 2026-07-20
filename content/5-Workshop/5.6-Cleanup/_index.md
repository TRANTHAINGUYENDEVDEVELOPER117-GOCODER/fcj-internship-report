---
title: "References and Lab Cleanup"
date: 2026-07-11
weight: 6
chapter: false
pre: " <b> 5.6. </b> "
---

# References and Lab Cleanup

### References

- [AWS Architecture Icons](https://aws.amazon.com/architecture/icons/)
- [AWS Well-Architected Framework – Security Pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)
- [Amazon GuardDuty Documentation](https://docs.aws.amazon.com/guardduty/)
- [AWS Security Hub Documentation](https://docs.aws.amazon.com/securityhub/)
- [Amazon Detective Documentation](https://docs.aws.amazon.com/detective/)
- [AWS Step Functions Documentation](https://docs.aws.amazon.com/step-functions/)
- [AWS Systems Manager Documentation](https://docs.aws.amazon.com/systems-manager/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

### Cleanup checklist

After the lab, remove unused EC2 instances, EBS snapshots, S3 objects/buckets, CloudWatch log groups, EventBridge rules, Step Functions state machines, Lambda functions, SNS topics, IAM roles, and temporary security services if they were enabled only for testing.

This prevents unexpected cost and keeps the AWS account clean after the workshop.

