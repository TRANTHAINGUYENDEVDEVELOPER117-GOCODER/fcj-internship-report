---
title : "Dashboard and Approval Flow"
date : 2026-07-01
weight : 5
chapter : false
pre : " <b> 5.4.5. </b> "
---

#### Dashboard and Approval Flow

Trong pháº§n nÃ y, chÃºng ta sáº½ xÃ¢y dá»±ng lá»›p **Dashboard and Approval Flow** cho há»‡ thá»‘ng AWS CloudSOC. Dashboard giÃºp SOC Analyst xem danh sÃ¡ch incident, kiá»ƒm tra má»©c Ä‘á»™ nghiÃªm trá»ng vÃ  phÃª duyá»‡t hoáº·c tá»« chá»‘i hÃ nh Ä‘á»™ng pháº£n á»©ng sá»± cá»‘.

á»ž cÃ¡c pháº§n trÆ°á»›c, GuardDuty Ä‘Ã£ táº¡o security finding, EventBridge Ä‘Ã£ báº¯t event vÃ  Step Functions Ä‘Ã£ Ä‘iá»u phá»‘i workflow pháº£n á»©ng sá»± cá»‘. Trong pháº§n nÃ y, chÃºng ta bá»• sung giao diá»‡n quáº£n trá»‹ Ä‘á»ƒ con ngÆ°á»i cÃ³ thá»ƒ tham gia vÃ o quÃ¡ trÃ¬nh xá»­ lÃ½ cÃ¡c finding cÃ³ má»©c Ä‘á»™ **High Severity**.

---

#### Má»¥c tiÃªu

Sau khi hoÃ n thÃ nh pháº§n nÃ y, báº¡n sáº½ cÃ³:

+ DynamoDB Incident Table Ä‘á»ƒ lÆ°u thÃ´ng tin incident.
+ Cognito User Pool Ä‘á»ƒ xÃ¡c thá»±c SOC Analyst.
+ API Gateway Ä‘á»ƒ cung cáº¥p API cho dashboard.
+ Dashboard API Lambda Ä‘á»ƒ xá»­ lÃ½ yÃªu cáº§u tá»« frontend.
+ Amplify Hosting Ä‘á»ƒ triá»ƒn khai giao diá»‡n dashboard.
+ Approval Flow cho phÃ©p analyst approve hoáº·c reject incident.
+ Dashboard sáºµn sÃ ng tÃ­ch há»£p vá»›i Step Functions vÃ  Lambda response workflow.

---

#### Dashboard and Approval Architecture

SÆ¡ Ä‘á»“ sau minh há»a kiáº¿n trÃºc Dashboard and Approval Flow trong há»‡ thá»‘ng AWS CloudSOC.

![Dashboard and Approval Architecture](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/dashboard-approval-architecture.png)

Luá»“ng xá»­ lÃ½ chÃ­nh:

```text
SOC Analyst
â†’ Amplify Hosting Dashboard
â†’ Amazon Cognito Login
â†’ API Gateway
â†’ Dashboard API Lambda
â†’ DynamoDB Incident Table
â†’ Step Functions Approval Decision
```

Trong kiáº¿n trÃºc nÃ y, dashboard khÃ´ng truy cáº­p trá»±c tiáº¿p DynamoDB hoáº·c S3. Má»i request tá»« frontend Ä‘á»u Ä‘i qua API Gateway vÃ  Lambda Ä‘á»ƒ Ä‘áº£m báº£o kiá»ƒm soÃ¡t quyá»n truy cáº­p.

---

#### ThÃ´ng tin cáº¥u hÃ¬nh Ä‘á» xuáº¥t

| ThÃ nh pháº§n | GiÃ¡ trá»‹ Ä‘á» xuáº¥t |
|---|---|
| DynamoDB Table | `CloudSOC-IncidentTable` |
| Partition Key | `incidentId` |
| Cognito User Pool | `cloudsoc-analyst-user-pool` |
| Cognito App Client | `cloudsoc-dashboard-client` |
| API Gateway | `cloudsoc-dashboard-api` |
| Lambda Function | `cloudsoc-dashboard-api-lambda` |
| Lambda IAM Role | `CloudSOC-Dashboard-Lambda-Role` |
| Amplify App | `cloudsoc-soc-dashboard` |
| Main Actions | View, Approve, Reject |
| Approval Status | `Pending`, `Approved`, `Rejected` |

---

#### BÆ°á»›c 1: Táº¡o DynamoDB Incident Table

DynamoDB Ä‘Æ°á»£c sá»­ dá»¥ng Ä‘á»ƒ lÆ°u thÃ´ng tin incident do workflow CloudSOC táº¡o ra. Má»—i incident sáº½ cÃ³ má»™t `incidentId` duy nháº¥t.

Má»Ÿ dá»‹ch vá»¥ **Amazon DynamoDB**, chá»n:

```text
Tables â†’ Create table
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Table name | `CloudSOC-IncidentTable` |
| Partition key | `incidentId` |
| Partition key type | String |
| Table settings | Default settings |
| Capacity mode | On-demand |

Káº¿t quáº£ mong Ä‘á»£i:

```text
DynamoDB table CloudSOC-IncidentTable Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![Create Incident Table](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/create-incident-table.png)

---

#### BÆ°á»›c 2: Thiáº¿t káº¿ dá»¯ liá»‡u Incident

Má»—i incident cÃ³ thá»ƒ cÃ³ cáº¥u trÃºc dá»¯ liá»‡u nhÆ° sau:

```json
{
  "incidentId": "INC-001",
  "findingId": "sample-finding-id",
  "title": "Sample GuardDuty finding for EC2 SSH brute force",
  "severity": 7.5,
  "resourceType": "Instance",
  "resourceId": "i-xxxxxxxxxxxxxxxxx",
  "findingType": "UnauthorizedAccess:EC2/SSHBruteForce",
  "responseMode": "ApprovalRequired",
  "approvalStatus": "Pending",
  "incidentStatus": "Open",
  "createdAt": "2026-07-17T10:00:00Z",
  "updatedAt": "2026-07-17T10:00:00Z"
}
```

CÃ¡c trÆ°á»ng quan trá»ng:

| TrÆ°á»ng | Ã nghÄ©a |
|---|---|
| `incidentId` | ID cá»§a incident |
| `findingId` | ID cá»§a GuardDuty finding |
| `severity` | Má»©c Ä‘á»™ nghiÃªm trá»ng |
| `resourceId` | EC2 Instance ID hoáº·c resource liÃªn quan |
| `responseMode` | AlertOnly, ApprovalRequired hoáº·c AutoResponse |
| `approvalStatus` | Pending, Approved hoáº·c Rejected |
| `incidentStatus` | Open, InProgress, Closed |

---

#### BÆ°á»›c 3: ThÃªm Sample Incident vÃ o DynamoDB

Äá»ƒ test dashboard trÆ°á»›c khi tÃ­ch há»£p Lambda response tháº­t, báº¡n cÃ³ thá»ƒ thÃªm má»™t sample incident thá»§ cÃ´ng.

VÃ o:

```text
DynamoDB â†’ Tables â†’ CloudSOC-IncidentTable â†’ Explore table items
```

Chá»n:

```text
Create item
```

ThÃªm sample item:

```json
{
  "incidentId": {
    "S": "INC-001"
  },
  "findingId": {
    "S": "sample-guardduty-finding"
  },
  "title": {
    "S": "Sample GuardDuty finding requiring approval"
  },
  "severity": {
    "N": "7.5"
  },
  "resourceType": {
    "S": "Instance"
  },
  "resourceId": {
    "S": "i-xxxxxxxxxxxxxxxxx"
  },
  "findingType": {
    "S": "UnauthorizedAccess:EC2/SSHBruteForce"
  },
  "responseMode": {
    "S": "ApprovalRequired"
  },
  "approvalStatus": {
    "S": "Pending"
  },
  "incidentStatus": {
    "S": "Open"
  }
}
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
Má»™t sample incident cÃ³ approvalStatus lÃ  Pending Ä‘Æ°á»£c táº¡o trong DynamoDB.
```

![Sample Incident Item](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/sample-incident-item.png)

---

#### BÆ°á»›c 4: Táº¡o Cognito User Pool

Amazon Cognito Ä‘Æ°á»£c sá»­ dá»¥ng Ä‘á»ƒ xÃ¡c thá»±c SOC Analyst trÆ°á»›c khi truy cáº­p dashboard.

Má»Ÿ dá»‹ch vá»¥ **Amazon Cognito**, chá»n:

```text
User pools â†’ Create user pool
```

Cáº¥u hÃ¬nh Ä‘á» xuáº¥t:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| User pool name | `cloudsoc-analyst-user-pool` |
| Sign-in options | Email |
| MFA | Optional hoáº·c No MFA cho lab |
| User account recovery | Email |
| App client name | `cloudsoc-dashboard-client` |

Káº¿t quáº£ mong Ä‘á»£i:

```text
Cognito User Pool Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![Cognito User Pool](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/cognito-user-pool.png)

---

#### BÆ°á»›c 5: Táº¡o SOC Analyst User

Trong Cognito User Pool, táº¡o user cho SOC Analyst.

VÃ o:

```text
Cognito â†’ User pools â†’ cloudsoc-analyst-user-pool â†’ Users â†’ Create user
```

Nháº­p thÃ´ng tin:

| Má»¥c | GiÃ¡ trá»‹ vÃ­ dá»¥ |
|---|---|
| Username | `soc-analyst` |
| Email | Email cá»§a báº¡n |
| Temporary password | Táº¡o tá»± Ä‘á»™ng hoáº·c nháº­p thá»§ cÃ´ng |

Káº¿t quáº£ mong Ä‘á»£i:

```text
SOC Analyst user Ä‘Æ°á»£c táº¡o vÃ  cÃ³ thá»ƒ Ä‘Äƒng nháº­p dashboard.
```

![Cognito Analyst User](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/cognito-analyst-user.png)

---

#### BÆ°á»›c 6: Táº¡o IAM Role cho Dashboard Lambda

Dashboard API Lambda cáº§n quyá»n Ä‘á»c vÃ  cáº­p nháº­t DynamoDB Incident Table. Trong cÃ¡c bÆ°á»›c tÃ­ch há»£p sau, Lambda cÅ©ng cÃ³ thá»ƒ cáº§n quyá»n gá»i Step Functions.

Má»Ÿ dá»‹ch vá»¥ **IAM**, chá»n:

```text
Roles â†’ Create role
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Trusted entity type | AWS service |
| Use case | Lambda |

Äáº·t tÃªn role:

```text
CloudSOC-Dashboard-Lambda-Role
```

Gáº¯n quyá»n cÆ¡ báº£n:

+ `AWSLambdaBasicExecutionRole`
+ Quyá»n Ä‘á»c/ghi DynamoDB table `CloudSOC-IncidentTable`
+ Quyá»n gá»i Step Functions náº¿u cáº§n approval callback

Policy DynamoDB máº«u:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:Scan",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem"
      ],
      "Resource": "arn:aws:dynamodb:ap-southeast-1:<account-id>:table/CloudSOC-IncidentTable"
    }
  ]
}
```

Policy Step Functions máº«u:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "states:StartExecution",
        "states:SendTaskSuccess",
        "states:SendTaskFailure"
      ],
      "Resource": "*"
    }
  ]
}
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
IAM Role CloudSOC-Dashboard-Lambda-Role Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![Dashboard Lambda Role](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/dashboard-lambda-role.png)

---

#### BÆ°á»›c 7: Táº¡o Dashboard API Lambda

Má»Ÿ dá»‹ch vá»¥ **AWS Lambda**, chá»n:

```text
Create function
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Function name | `cloudsoc-dashboard-api-lambda` |
| Runtime | Python 3.12 |
| Architecture | x86_64 |
| Execution role | `CloudSOC-Dashboard-Lambda-Role` |

Lambda nÃ y sáº½ xá»­ lÃ½ cÃ¡c API chÃ­nh:

| Method | Path | Chá»©c nÄƒng |
|---|---|---|
| GET | `/incidents` | Láº¥y danh sÃ¡ch incident |
| GET | `/incidents/{incidentId}` | Xem chi tiáº¿t incident |
| POST | `/incidents/{incidentId}/approve` | PhÃª duyá»‡t incident |
| POST | `/incidents/{incidentId}/reject` | Tá»« chá»‘i incident |

Káº¿t quáº£ mong Ä‘á»£i:

```text
Lambda function cloudsoc-dashboard-api-lambda Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![Create Dashboard Lambda](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/create-dashboard-lambda.png)

---

#### BÆ°á»›c 8: Cáº¥u hÃ¬nh Lambda Environment Variables

Trong Lambda, vÃ o tab:

```text
Configuration â†’ Environment variables
```

ThÃªm biáº¿n mÃ´i trÆ°á»ng:

| Key | Value |
|---|---|
| `INCIDENT_TABLE` | `CloudSOC-IncidentTable` |
| `REGION` | `ap-southeast-1` |

Káº¿t quáº£ mong Ä‘á»£i:

```text
Lambda cÃ³ thá»ƒ Ä‘á»c tÃªn DynamoDB table tá»« environment variables.
```

---

#### BÆ°á»›c 9: Táº¡o API Gateway

Má»Ÿ dá»‹ch vá»¥ **Amazon API Gateway**, chá»n:

```text
Create API
```

Chá»n:

```text
HTTP API â†’ Build
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| API name | `cloudsoc-dashboard-api` |
| Integration | Lambda |
| Lambda function | `cloudsoc-dashboard-api-lambda` |
| Stage | `$default` |

Káº¿t quáº£ mong Ä‘á»£i:

```text
API Gateway HTTP API Ä‘Æ°á»£c táº¡o vÃ  káº¿t ná»‘i vá»›i Dashboard Lambda.
```

![Create Dashboard API](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/create-dashboard-api.png)

---

#### BÆ°á»›c 10: Táº¡o API Routes

Trong API Gateway, táº¡o cÃ¡c route sau:

| Method | Route |
|---|---|
| GET | `/incidents` |
| GET | `/incidents/{incidentId}` |
| POST | `/incidents/{incidentId}/approve` |
| POST | `/incidents/{incidentId}/reject` |

Táº¥t cáº£ routes trá» vá» Lambda:

```text
cloudsoc-dashboard-api-lambda
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
CÃ¡c API routes cho dashboard Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![API Gateway Routes](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/api-gateway-routes.png)

---

#### BÆ°á»›c 11: Cáº¥u hÃ¬nh Cognito Authorizer cho API Gateway

Äá»ƒ báº£o vá»‡ dashboard API, táº¡o Cognito Authorizer trong API Gateway.

VÃ o:

```text
API Gateway â†’ cloudsoc-dashboard-api â†’ Authorization â†’ Create authorizer
```

Cáº¥u hÃ¬nh:

| Má»¥c | GiÃ¡ trá»‹ |
|---|---|
| Authorizer type | JWT |
| Identity source | `$request.header.Authorization` |
| Issuer URL | Cognito User Pool issuer URL |
| Audience | Cognito App Client ID |

Sau Ä‘Ã³ gáº¯n authorizer nÃ y vÃ o cÃ¡c route:

```text
GET /incidents
GET /incidents/{incidentId}
POST /incidents/{incidentId}/approve
POST /incidents/{incidentId}/reject
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
Dashboard API Ä‘Æ°á»£c báº£o vá»‡ báº±ng Cognito JWT Authorizer.
```

![API Gateway Cognito Authorizer](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/api-gateway-cognito-authorizer.png)

> **LÆ°u Ã½:** Trong mÃ´i trÆ°á»ng lab, báº¡n cÃ³ thá»ƒ kiá»ƒm thá»­ API khÃ´ng cÃ³ authorizer trÆ°á»›c, sau Ä‘Ã³ báº­t Cognito Authorizer Ä‘á»ƒ hoÃ n thiá»‡n báº£o máº­t.

---

#### BÆ°á»›c 12: Táº¡o Amplify Hosting cho Dashboard

AWS Amplify Hosting Ä‘Æ°á»£c sá»­ dá»¥ng Ä‘á»ƒ triá»ƒn khai giao diá»‡n web dashboard cho SOC Analyst.

Má»Ÿ dá»‹ch vá»¥ **AWS Amplify**, chá»n:

```text
Create new app
```

Chá»n phÆ°Æ¡ng thá»©c triá»ƒn khai phÃ¹ há»£p:

```text
Deploy without Git provider
```

Äáº·t tÃªn app:

```text
cloudsoc-soc-dashboard
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
Amplify app cloudsoc-soc-dashboard Ä‘Æ°á»£c táº¡o thÃ nh cÃ´ng.
```

![Amplify Hosting Dashboard](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/amplify-hosting-dashboard.png)

---

#### BÆ°á»›c 13: Dashboard UI Functions

Dashboard cáº§n cÃ³ cÃ¡c chá»©c nÄƒng cÆ¡ báº£n sau:

| Chá»©c nÄƒng | MÃ´ táº£ |
|---|---|
| Login | SOC Analyst Ä‘Äƒng nháº­p báº±ng Cognito |
| Incident List | Hiá»ƒn thá»‹ danh sÃ¡ch incident |
| Incident Detail | Xem chi tiáº¿t finding |
| Approve | PhÃª duyá»‡t pháº£n á»©ng sá»± cá»‘ |
| Reject | Tá»« chá»‘i pháº£n á»©ng sá»± cá»‘ |
| Status Tracking | Theo dÃµi tráº¡ng thÃ¡i incident |

Giao diá»‡n dashboard cÃ³ thá»ƒ hiá»ƒn thá»‹ cÃ¡c cá»™t:

```text
Incident ID
Finding Type
Severity
Resource ID
Response Mode
Approval Status
Incident Status
Action
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
SOC Analyst cÃ³ thá»ƒ xem danh sÃ¡ch incident tá»« dashboard.
```

![Dashboard Incidents List](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/dashboard-incidents-list.png)

---

#### BÆ°á»›c 14: Approval Action

Khi SOC Analyst chá»n **Approve**, frontend sáº½ gá»i API:

```text
POST /incidents/{incidentId}/approve
```

Lambda sáº½ cáº­p nháº­t DynamoDB:

```text
approvalStatus = Approved
incidentStatus = InProgress
```

Khi SOC Analyst chá»n **Reject**, frontend sáº½ gá»i API:

```text
POST /incidents/{incidentId}/reject
```

Lambda sáº½ cáº­p nháº­t DynamoDB:

```text
approvalStatus = Rejected
incidentStatus = Closed
```

Káº¿t quáº£ mong Ä‘á»£i:

```text
SOC Analyst cÃ³ thá»ƒ approve hoáº·c reject incident tá»« dashboard.
```

![Dashboard Approval Action](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/dashboard-approval-action.png)

---

#### BÆ°á»›c 15: Kiá»ƒm tra DynamoDB sau Approval

Sau khi approve hoáº·c reject incident, quay láº¡i DynamoDB Ä‘á»ƒ kiá»ƒm tra item.

VÃ o:

```text
DynamoDB â†’ Tables â†’ CloudSOC-IncidentTable â†’ Explore table items
```

Kiá»ƒm tra cÃ¡c trÆ°á»ng:

```text
approvalStatus
incidentStatus
updatedAt
```

Káº¿t quáº£ sau khi approve:

```text
approvalStatus = Approved
incidentStatus = InProgress
```

Káº¿t quáº£ sau khi reject:

```text
approvalStatus = Rejected
incidentStatus = Closed
```

![DynamoDB Approval Updated](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/dynamodb-approval-updated.png)

---

#### BÆ°á»›c 16: LiÃªn káº¿t Approval Flow vá»›i Step Functions

Trong kiáº¿n trÃºc hoÃ n chá»‰nh, Step Functions sáº½ Ä‘Æ°a cÃ¡c finding má»©c High Severity vÃ o tráº¡ng thÃ¡i chá» phÃª duyá»‡t. Dashboard sáº½ cho phÃ©p SOC Analyst approve hoáº·c reject incident.

Luá»“ng approval tá»•ng quÃ¡t:

```text
Step Functions
â†’ Create Pending Incident in DynamoDB
â†’ SOC Analyst opens Dashboard
â†’ Analyst Approves or Rejects
â†’ Dashboard Lambda updates DynamoDB
â†’ Step Functions continues response path
```

Vá»›i mÃ´i trÆ°á»ng lab, pháº§n approval cÃ³ thá»ƒ Ä‘Æ°á»£c kiá»ƒm thá»­ báº±ng cÃ¡ch cáº­p nháº­t DynamoDB trÆ°á»›c. á»ž pháº§n tiáº¿p theo, cÃ¡c hÃ nh Ä‘á»™ng pháº£n á»©ng tháº­t nhÆ° thu tháº­p evidence, táº¡o snapshot vÃ  cÃ´ láº­p EC2 sáº½ Ä‘Æ°á»£c triá»ƒn khai.

---

#### Kiá»ƒm tra sau khi hoÃ n thÃ nh

Sau khi hoÃ n thÃ nh pháº§n nÃ y, kiá»ƒm tra láº¡i cÃ¡c má»¥c sau:

- [ ] DynamoDB table `CloudSOC-IncidentTable` Ä‘Ã£ Ä‘Æ°á»£c táº¡o.
- [ ] Sample incident Ä‘Ã£ Ä‘Æ°á»£c thÃªm vÃ o DynamoDB.
- [ ] Cognito User Pool `cloudsoc-analyst-user-pool` Ä‘Ã£ Ä‘Æ°á»£c táº¡o.
- [ ] SOC Analyst user Ä‘Ã£ Ä‘Æ°á»£c táº¡o.
- [ ] Lambda `cloudsoc-dashboard-api-lambda` Ä‘Ã£ Ä‘Æ°á»£c táº¡o.
- [ ] API Gateway `cloudsoc-dashboard-api` Ä‘Ã£ Ä‘Æ°á»£c táº¡o.
- [ ] API routes `/incidents`, `/approve`, `/reject` Ä‘Ã£ Ä‘Æ°á»£c cáº¥u hÃ¬nh.
- [ ] Amplify Hosting app `cloudsoc-soc-dashboard` Ä‘Ã£ Ä‘Æ°á»£c táº¡o.
- [ ] Dashboard cÃ³ thá»ƒ hiá»ƒn thá»‹ danh sÃ¡ch incident.
- [ ] SOC Analyst cÃ³ thá»ƒ approve hoáº·c reject incident.
- [ ] DynamoDB cáº­p nháº­t Ä‘Ãºng tráº¡ng thÃ¡i approval.

---

#### Káº¿t quáº£ sau khi hoÃ n thÃ nh

Sau khi hoÃ n thÃ nh pháº§n nÃ y, há»‡ thá»‘ng AWS CloudSOC cÃ³ dashboard cÆ¡ báº£n Ä‘á»ƒ SOC Analyst theo dÃµi vÃ  xá»­ lÃ½ incident.

CÃ¡c thÃ nh pháº§n Ä‘Ã£ sáºµn sÃ ng gá»“m:

```text
Amazon DynamoDB
Amazon Cognito
Amazon API Gateway
AWS Lambda
AWS Amplify Hosting
AWS Step Functions Approval Flow
```

Dashboard giÃºp bá»• sung yáº¿u tá»‘ con ngÆ°á»i vÃ o quy trÃ¬nh pháº£n á»©ng sá»± cá»‘. CÃ¡c incident má»©c Low hoáº·c Medium cÃ³ thá»ƒ chá»‰ gá»­i cáº£nh bÃ¡o, cÃ¡c incident má»©c Critical cÃ³ thá»ƒ tá»± Ä‘á»™ng pháº£n á»©ng, cÃ²n incident má»©c High cÃ³ thá»ƒ yÃªu cáº§u SOC Analyst phÃª duyá»‡t trÆ°á»›c khi thá»±c hiá»‡n hÃ nh Ä‘á»™ng cÃ´ láº­p.

---

#### TÃ³m táº¯t

Trong pháº§n nÃ y, chÃºng ta Ä‘Ã£ xÃ¢y dá»±ng lá»›p Dashboard and Approval Flow cho AWS CloudSOC. SOC Analyst cÃ³ thá»ƒ Ä‘Äƒng nháº­p dashboard, xem incident, phÃª duyá»‡t hoáº·c tá»« chá»‘i hÃ nh Ä‘á»™ng pháº£n á»©ng.

á»ž pháº§n tiáº¿p theo, chÃºng ta sáº½ triá»ƒn khai **Forensics, Snapshot and Isolation** Ä‘á»ƒ thu tháº­p báº±ng chá»©ng, táº¡o EBS Snapshot vÃ  cÃ´ láº­p EC2 báº±ng Security Group Isolation.