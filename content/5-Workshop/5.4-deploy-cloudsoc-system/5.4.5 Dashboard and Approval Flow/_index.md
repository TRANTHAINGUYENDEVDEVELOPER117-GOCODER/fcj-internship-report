---
title : "Dashboard and Approval Flow"
date : 2026-07-01
weight : 5
chapter : false
pre : " <b> 5.4.5. </b> "
---

#### Dashboard and Approval Flow

In this section, you will build the **Dashboard and Approval Flow** layer for the AWS CloudSOC system. The dashboard allows the SOC Analyst to view incidents, check severity levels, and approve or reject incident response actions.

In the previous sections, GuardDuty generated security findings, EventBridge captured the events, and Step Functions orchestrated the incident response workflow. In this section, you will add a management interface so that a human analyst can participate in handling **High Severity** findings.

---

#### Objectives

After completing this section, you will have:

+ A DynamoDB Incident Table to store incident information.
+ A Cognito User Pool to authenticate SOC Analysts.
+ An API Gateway to expose dashboard APIs.
+ A Dashboard API Lambda to process frontend requests.
+ Amplify Hosting to deploy the SOC dashboard frontend.
+ An Approval Flow that allows analysts to approve or reject incidents.
+ A dashboard layer ready to integrate with Step Functions and the incident response workflow.

---

#### Dashboard and Approval Architecture

The following diagram illustrates the Dashboard and Approval Flow architecture in the AWS CloudSOC system.

![Dashboard and Approval Architecture](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/dashboard-approval-architecture.png)

The main workflow is:

```text
SOC Analyst
→ Amplify Hosting Dashboard
→ Amazon Cognito Login
→ API Gateway
→ Dashboard API Lambda
→ DynamoDB Incident Table
→ Step Functions Approval Decision
```

In this architecture, the dashboard does not access DynamoDB or S3 directly. All frontend requests go through API Gateway and Lambda to enforce access control and centralize backend logic.

---

#### Recommended Configuration

| Component | Recommended Value |
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

#### Step 1: Create the DynamoDB Incident Table

DynamoDB is used to store incident information created by the CloudSOC workflow. Each incident has a unique `incidentId`.

Open **Amazon DynamoDB** and choose:

```text
Tables → Create table
```

Configure the table:

| Field | Value |
|---|---|
| Table name | `CloudSOC-IncidentTable` |
| Partition key | `incidentId` |
| Partition key type | String |
| Table settings | Default settings |
| Capacity mode | On-demand |

Expected result:

```text
The DynamoDB table CloudSOC-IncidentTable is created successfully.
```

![Create Incident Table](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/create-incident-table.png)

---

#### Step 2: Design the Incident Data Model

Each incident can use the following data structure:

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

Important fields:

| Field | Description |
|---|---|
| `incidentId` | Unique incident ID |
| `findingId` | GuardDuty finding ID |
| `severity` | Severity level |
| `resourceId` | EC2 Instance ID or related resource ID |
| `responseMode` | AlertOnly, ApprovalRequired, or AutoResponse |
| `approvalStatus` | Pending, Approved, or Rejected |
| `incidentStatus` | Open, InProgress, or Closed |

---

#### Step 3: Add a Sample Incident to DynamoDB

To test the dashboard before integrating the real response Lambda, you can manually add a sample incident.

Go to:

```text
DynamoDB → Tables → CloudSOC-IncidentTable → Explore table items
```

Choose:

```text
Create item
```

Add the following sample item:

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

Expected result:

```text
A sample incident with approvalStatus Pending is created in DynamoDB.
```

![Sample Incident Item](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/sample-incident-item.png)

---

#### Step 4: Create a Cognito User Pool

Amazon Cognito is used to authenticate SOC Analysts before they access the dashboard.

Open **Amazon Cognito** and choose:

```text
User pools → Create user pool
```

Recommended configuration:

| Field | Value |
|---|---|
| User pool name | `cloudsoc-analyst-user-pool` |
| Sign-in options | Email |
| MFA | Optional or No MFA for lab |
| User account recovery | Email |
| App client name | `cloudsoc-dashboard-client` |

Expected result:

```text
The Cognito User Pool is created successfully.
```

![Cognito User Pool](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/cognito-user-pool.png)

---

#### Step 5: Create a SOC Analyst User

In the Cognito User Pool, create a user for the SOC Analyst.

Go to:

```text
Cognito → User pools → cloudsoc-analyst-user-pool → Users → Create user
```

Enter the following information:

| Field | Example Value |
|---|---|
| Username | `soc-analyst` |
| Email | Your email address |
| Temporary password | Auto-generated or manually entered |

Expected result:

```text
The SOC Analyst user is created and can sign in to the dashboard.
```

![Cognito Analyst User](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/cognito-analyst-user.png)

---

#### Step 6: Create an IAM Role for the Dashboard Lambda

The Dashboard API Lambda needs permission to read and update the DynamoDB Incident Table. In later integration steps, this Lambda may also need permission to call Step Functions.

Open **IAM** and choose:

```text
Roles → Create role
```

Configure the role:

| Field | Value |
|---|---|
| Trusted entity type | AWS service |
| Use case | Lambda |

Set the role name:

```text
CloudSOC-Dashboard-Lambda-Role
```

Attach the following permissions:

+ `AWSLambdaBasicExecutionRole`
+ Read/write permission for the DynamoDB table `CloudSOC-IncidentTable`
+ Step Functions permission if approval callback is required

Sample DynamoDB policy:

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

Sample Step Functions policy:

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

Expected result:

```text
The IAM Role CloudSOC-Dashboard-Lambda-Role is created successfully.
```

![Dashboard Lambda Role](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/dashboard-lambda-role.png)

---

#### Step 7: Create the Dashboard API Lambda

Open **AWS Lambda** and choose:

```text
Create function
```

Configure the function:

| Field | Value |
|---|---|
| Function name | `cloudsoc-dashboard-api-lambda` |
| Runtime | Python 3.12 |
| Architecture | x86_64 |
| Execution role | `CloudSOC-Dashboard-Lambda-Role` |

This Lambda handles the main dashboard APIs:

| Method | Path | Purpose |
|---|---|---|
| GET | `/incidents` | Get incident list |
| GET | `/incidents/{incidentId}` | Get incident details |
| POST | `/incidents/{incidentId}/approve` | Approve incident |
| POST | `/incidents/{incidentId}/reject` | Reject incident |

Expected result:

```text
The Lambda function cloudsoc-dashboard-api-lambda is created successfully.
```

![Create Dashboard Lambda](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/create-dashboard-lambda.png)

---

#### Step 8: Configure Lambda Environment Variables

In the Lambda function, open:

```text
Configuration → Environment variables
```

Add the following environment variables:

| Key | Value |
|---|---|
| `INCIDENT_TABLE` | `CloudSOC-IncidentTable` |
| `REGION` | `ap-southeast-1` |

Expected result:

```text
The Lambda function can read the DynamoDB table name from environment variables.
```

---

#### Step 9: Create API Gateway

Open **Amazon API Gateway** and choose:

```text
Create API
```

Choose:

```text
HTTP API → Build
```

Configure the API:

| Field | Value |
|---|---|
| API name | `cloudsoc-dashboard-api` |
| Integration | Lambda |
| Lambda function | `cloudsoc-dashboard-api-lambda` |
| Stage | `$default` |

Expected result:

```text
The API Gateway HTTP API is created and connected to the Dashboard Lambda.
```

![Create Dashboard API](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/create-dashboard-api.png)

---

#### Step 10: Create API Routes

In API Gateway, create the following routes:

| Method | Route |
|---|---|
| GET | `/incidents` |
| GET | `/incidents/{incidentId}` |
| POST | `/incidents/{incidentId}/approve` |
| POST | `/incidents/{incidentId}/reject` |

All routes point to the Lambda function:

```text
cloudsoc-dashboard-api-lambda
```

Expected result:

```text
The dashboard API routes are created successfully.
```

![API Gateway Routes](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/api-gateway-routes.png)

---

#### Step 11: Configure Cognito Authorizer for API Gateway

To protect the dashboard API, create a Cognito Authorizer in API Gateway.

Go to:

```text
API Gateway → cloudsoc-dashboard-api → Authorization → Create authorizer
```

Configure the authorizer:

| Field | Value |
|---|---|
| Authorizer type | JWT |
| Identity source | `$request.header.Authorization` |
| Issuer URL | Cognito User Pool issuer URL |
| Audience | Cognito App Client ID |

Attach this authorizer to the following routes:

```text
GET /incidents
GET /incidents/{incidentId}
POST /incidents/{incidentId}/approve
POST /incidents/{incidentId}/reject
```

Expected result:

```text
The Dashboard API is protected by a Cognito JWT Authorizer.
```

![API Gateway Cognito Authorizer](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/api-gateway-cognito-authorizer.png)

> **Note:** For a lab environment, you can test the API without an authorizer first, then enable the Cognito Authorizer to complete the security configuration.

---

#### Step 12: Create Amplify Hosting for the Dashboard

AWS Amplify Hosting is used to deploy the web dashboard for the SOC Analyst.

Open **AWS Amplify** and choose:

```text
Create new app
```

Choose the deployment method:

```text
Deploy without Git provider
```

Set the app name:

```text
cloudsoc-soc-dashboard
```

Expected result:

```text
The Amplify app cloudsoc-soc-dashboard is created successfully.
```

![Amplify Hosting Dashboard](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/amplify-hosting-dashboard.png)

---

#### Step 13: Dashboard UI Functions

The dashboard should provide the following basic functions:

| Function | Description |
|---|---|
| Login | SOC Analyst signs in using Cognito |
| Incident List | Display incident list |
| Incident Detail | View finding details |
| Approve | Approve incident response |
| Reject | Reject incident response |
| Status Tracking | Track incident status |

The dashboard can display the following columns:

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

Expected result:

```text
The SOC Analyst can view the incident list from the dashboard.
```

![Dashboard Incidents List](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/dashboard-incidents-list.png)

---

#### Step 14: Approval Action

When the SOC Analyst chooses **Approve**, the frontend calls the API:

```text
POST /incidents/{incidentId}/approve
```

The Lambda function updates DynamoDB:

```text
approvalStatus = Approved
incidentStatus = InProgress
```

When the SOC Analyst chooses **Reject**, the frontend calls the API:

```text
POST /incidents/{incidentId}/reject
```

The Lambda function updates DynamoDB:

```text
approvalStatus = Rejected
incidentStatus = Closed
```

Expected result:

```text
The SOC Analyst can approve or reject an incident from the dashboard.
```

![Dashboard Approval Action](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/dashboard-approval-action.png)

---

#### Step 15: Verify DynamoDB After Approval

After approving or rejecting an incident, return to DynamoDB and verify the item.

Go to:

```text
DynamoDB → Tables → CloudSOC-IncidentTable → Explore table items
```

Check the following fields:

```text
approvalStatus
incidentStatus
updatedAt
```

Expected result after approval:

```text
approvalStatus = Approved
incidentStatus = InProgress
```

Expected result after rejection:

```text
approvalStatus = Rejected
incidentStatus = Closed
```

![DynamoDB Approval Updated](/images/5-Workshop/5.4-Deploy-Cloudsoc-System/5.4.5-Dashboard-And-Approval-Flow/dynamodb-approval-updated.png)

---

#### Step 16: Connect the Approval Flow with Step Functions

In the complete architecture, Step Functions sends High Severity findings into a pending approval state. The dashboard allows the SOC Analyst to approve or reject the incident.

The general approval flow is:

```text
Step Functions
→ Create Pending Incident in DynamoDB
→ SOC Analyst opens Dashboard
→ Analyst Approves or Rejects
→ Dashboard Lambda updates DynamoDB
→ Step Functions continues the response path
```

For the lab environment, the approval flow can be tested by updating DynamoDB first. In the next section, real response actions such as evidence collection, EBS snapshot creation, and EC2 isolation will be implemented.

---

#### Completion Checklist

After completing this section, verify the following items:

- [ ] DynamoDB table `CloudSOC-IncidentTable` is created.
- [ ] A sample incident is added to DynamoDB.
- [ ] Cognito User Pool `cloudsoc-analyst-user-pool` is created.
- [ ] SOC Analyst user is created.
- [ ] Lambda function `cloudsoc-dashboard-api-lambda` is created.
- [ ] API Gateway `cloudsoc-dashboard-api` is created.
- [ ] API routes `/incidents`, `/approve`, and `/reject` are configured.
- [ ] Amplify Hosting app `cloudsoc-soc-dashboard` is created.
- [ ] The dashboard can display the incident list.
- [ ] The SOC Analyst can approve or reject an incident.
- [ ] DynamoDB updates the approval status correctly.

---

#### Completion Result

After completing this section, the AWS CloudSOC system has a basic dashboard for SOC Analysts to monitor and handle incidents.

The following components are now ready:

```text
Amazon DynamoDB
Amazon Cognito
Amazon API Gateway
AWS Lambda
AWS Amplify Hosting
AWS Step Functions Approval Flow
```

The dashboard adds human decision-making to the incident response process. Low or Medium severity incidents can follow an alert-only path, Critical incidents can trigger automated response, and High severity incidents can require SOC Analyst approval before isolation actions are executed.

---

#### Summary

In this section, you built the Dashboard and Approval Flow layer for AWS CloudSOC. The SOC Analyst can sign in to the dashboard, view incidents, and approve or reject response actions.

In the next section, you will implement **Forensics, Snapshot and Isolation** to collect evidence, create EBS Snapshots, and isolate EC2 using Security Group isolation.