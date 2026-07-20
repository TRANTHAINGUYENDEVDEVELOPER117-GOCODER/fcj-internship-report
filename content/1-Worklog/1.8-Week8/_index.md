---
title: "Week 8 Worklog"
date: 2026-06-27
weight: 8
chapter: false
pre: " <b> 1.8. </b> "
---
### Week 8 Overview (06/27 – 07/03/2026)

In week eight, I continued the security track with a focus on **data protection** and **threat detection**: encryption with **AWS KMS**, private S3 connectivity with **VPC Endpoints**, **S3 security best practices**, enabling **GuardDuty**, and safer secret handling with **Secrets Manager**.

### Week 8 Objectives

* Practice **KMS** to understand key management and encrypt/decrypt basics.
* Use **VPC Endpoints** to access S3 privately (reduce Internet exposure).
* Apply **S3 Security Best Practices**: block public access, bucket policy, encryption.
* Enable **GuardDuty** and review findings/severity.
* Store credentials in **Secrets Manager** instead of hardcoding.

### Tasks Completed

| Item | Task | Status | Reference |
| --- | --- | --- | --- |
| 01 | KMS: create key, test encrypt/decrypt | ✅ | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 02 | S3 Gateway VPC Endpoint + routing | ✅ | [S3 Endpoint Lab](https://000069.awsstudygroup.com/) |
| 03 | S3 security hardening (BPA, policy, encryption) | ✅ | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 04 | GuardDuty: enable + review findings | ✅ | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 05 | Secrets Manager: create secret + basic permissions | ✅ | [Cloud Journey](https://cloudjourney.awsstudygroup.com/) |
| 06 | Cleanup and cost check | ✅ | — |

### What I Did

**KMS**
* Created a customer managed key and learned the difference between key policy and IAM policy.
* Performed a simple encrypt/decrypt flow to understand KMS usage permissions.

**VPC Endpoint for S3**
* Created a Gateway VPC Endpoint for S3 and attached it to the correct route table.
* Noted how endpoint policies and bucket policies must align to avoid unexpected denies.

**S3 Security**
* Enabled Block Public Access.
* Reviewed bucket policies for least privilege.
* Enabled default encryption and verified object encryption on upload.

**GuardDuty**
* Enabled GuardDuty and learned severity-based triage.
* Documented findings workflow: triage → validate → remediate.

**Secrets Manager**
* Stored demo credentials as a secret and controlled access with least privilege.

### Achievements

* Built a security baseline around encryption, private connectivity, threat detection, and secret hygiene.
* Reduced attack surface by removing public paths and unsafe credential storage.

### Challenges

* Policy confusion (KMS key policy vs IAM policy) required checking both layers.
* Endpoint worked but S3 access was denied until bucket policy/endpoint policy were aligned.
* GuardDuty findings may take time to appear after enabling.

