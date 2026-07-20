---
title: "Event 1: AWS AI Day / FCAJ Meetup"
date: 2026-05-09
weight: 1
chapter: false
pre: " <b> 4.1. </b> "
---

### Event Information

* **Event Name:** AWS AI Day / FCAJ Meetup
* **Date:** May 9, 2026
* **Role:** Attendee

### Event Purpose

The event was organized to share practical knowledge about Artificial Intelligence, AWS cloud services, AI product development, serverless architecture, and modern software development methods using AI.

Through the sharing sessions, participants had the opportunity to learn how AI products can be designed, optimized, secured, and deployed using AWS services. The event also introduced modern development approaches such as Vibe Coding, Vibe Method, Multi-Agent AI, PRD-based planning, and structured software engineering workflows.

### Main Contents

#### AI Product Idea and Prompt Optimization Tool

One of the main topics of the event was about building an AI product that helps users optimize prompts and use AI more effectively.

The speaker introduced an idea for an AI tool similar to a “Proximizer”, which could support users by:

* Optimizing input prompts for AI.
* Separating different AI chat contexts to avoid confusing the model.
* Allowing users to use AI anywhere on the screen through shortcuts.
* Helping users quickly ask questions from selected text.

For example, when reading an article, a user could highlight a phrase such as “Who is Zelensky?” and ask AI immediately without opening a separate chat window.

This idea showed that a good AI product should not only focus on the model, but also on user experience and how users interact with AI in daily tasks.

#### Cost of Building an AI Product on AWS

The event also discussed the cost of building AI applications using AWS services.

AWS provides many services with Free Tier support. However, Amazon Bedrock does not use Free Tier credit in the same way as some other AWS services. The cost of using Amazon Bedrock depends on:

* Input tokens
* Output tokens
* The AI model being used

The speaker also explained that different models have different costs. Lighter models such as Haiku or Gemini-based models are usually cheaper than more powerful models.

The session emphasized the benefit of using serverless architecture. With serverless services, developers do not need to manage servers manually and only pay when the system is used. For a small application with around 100 users per day, the cost can still remain very low, and some parts of the system may stay within the AWS Free Tier.

#### EC2 vs Lambda

The event explained the difference between Amazon EC2 and AWS Lambda.

AWS Lambda is a serverless compute service. It only runs when there is a request or event, and it automatically stops after finishing the task. Lambda is suitable for lightweight tasks, small APIs, and event-driven processing. However, it has a maximum execution time limit of 15 minutes.

Amazon EC2 is a virtual server that runs continuously. It is charged based on the time the instance is running. EC2 is suitable for heavier backend systems, long-running processing, Redis, and larger applications that require more control over the environment.

In summary:

| AWS Lambda | Amazon EC2 |
| --- | --- |
| Serverless | Virtual server |
| Runs only when triggered | Runs continuously |
| Pay per request or execution time | Pay based on running time |
| Suitable for lightweight tasks | Suitable for heavier workloads |
| Automatically stops after execution | Must be manually stopped or managed |

This comparison helped me understand how to choose the right compute service depending on the workload.

#### AI Hallucination and Prompt Design

Another important topic was AI hallucination. Hallucination happens when an AI model generates incorrect, unsupported, or invented information.

The speaker explained that vague prompts can increase the chance of hallucination. Instead of only telling the AI what not to do, users should clearly tell the AI what it should do.

For example, instead of saying:

* “Do not make mistakes.”

It is better to say:

* “If you do not have enough information, answer that you do not know.”
* “Do not create information that is not provided.”
* “Only answer based on the given data.”

This part helped me understand that prompt design is very important when using AI. Clear instructions, rules, and boundaries can reduce hallucination and improve the quality of AI responses.

#### Security for AI Systems

The event also introduced several AWS services and security concepts that are useful when building AI systems.

Amazon WAF can be used to protect web applications by filtering malicious requests, blocking harmful IP addresses, and reducing attacks against the system.

Amazon Cognito can be used to manage user authentication. It helps handle login, user accounts, and password security without requiring developers to build the entire authentication system manually.

Amazon Bedrock Guardrails can help control AI behavior by filtering dangerous prompts or sensitive content. It can be used to reduce risks related to medical, legal, or harmful content.

The speaker also mentioned the importance of disclaimers. If an AI system provides information related to health, law, or other sensitive areas, the application should include proper warnings and limitations to avoid misunderstanding or legal risks.

#### UX/UI Ideas for AI Tools

The event emphasized that many users do not know how to write good prompts or clearly describe what they want from AI.

Because of this, a good AI tool should reduce the amount of thinking and manual work required from the user. The system can support users by:

* Suggesting prompts.
* Automatically improving prompts.
* Providing simple input forms.
* Reducing unnecessary user actions.

However, the speaker also explained that forcing users to fill in too many form fields may not be effective. Automatic prompt optimization can provide a smoother and more convenient user experience.

This part helped me understand that building an AI product is not only about the backend or model, but also about designing a simple and useful experience for users.

#### Vibe Coding and Its Problems

The event also discussed the problem of traditional “Vibe Coding”.

Vibe Coding refers to the way many people use AI by continuously prompting the AI and expecting it to build an entire product automatically. Many users put all requirements into one large chat and hope that AI can generate the full application.

However, this approach can cause many problems:

* The AI forgets the original goal.
* The context becomes confusing.
* The generated code becomes messy.
* The project becomes difficult to deploy.
* The project becomes hard to maintain.
* Hallucination increases.

The main idea is that AI cannot remember and manage a large software project perfectly inside one long chat. Without structure, the project can easily fail.

#### Vibe Method

To solve the problems of Vibe Coding, the speaker introduced the idea of “Vibe Method”.

The main idea of Vibe Method is not to let AI do everything in one large chat. Instead, the project should be divided into smaller parts with clear context, clear responsibility, and a structured workflow.

This method is similar to real software engineering processes such as Agile, Scrum, and product development.

The general workflow is:

```text
Idea → PRD → Architecture → Epic → Story → Coding → Review → QA → Deploy
```

First, the idea is clarified. For example, if the user wants to build a music application, AI can help brainstorm features and ask questions to clarify requirements.

Then, the project is turned into a PRD, or Product Requirement Document. The PRD describes what the application does, its features, user flows, and product goals. It becomes the main source of truth for the project.

After that, the architecture is designed. AI can help choose the technology stack, frontend, backend, database, deployment method, and overall system design.

Finally, the large project is broken down into smaller tasks such as Epics, Stories, and Subtasks. This makes the project easier to manage, build, review, and maintain.

#### Multi-Agent AI

One of the most important ideas in the event was Multi-Agent AI.

Instead of using one AI model to handle everything, different AI agents can be assigned different roles, such as:

* Product Manager Agent
* Architect Agent
* Scrum Master Agent
* Developer Agent
* Code Review Agent
* QA Agent

Each agent focuses on a smaller part of the project. This helps reduce hallucination because the AI does not need to handle too much context at once.

For example, one agent can focus only on authentication, while another agent focuses only on payment or deployment. This separation makes the system easier to control and maintain.

#### Task Lifecycle and Human Role

The event also explained that tasks should have a clear lifecycle, such as:

* Draft
* Approved
* In Progress
* Review
* QA
* Done

AI agents should only work on tasks after they are approved. This helps prevent AI from changing the system without control.

The speaker emphasized that humans still play an important role. AI should not make every decision by itself. Humans must still review, approve, coordinate, and adjust requirements.

AI is a support tool, not a full replacement for human thinking.

### Lessons Learned

After joining this event, I learned several important lessons:

* Serverless architecture can help reduce cost when building small or medium AI applications.
* AWS Lambda is suitable for lightweight and event-driven workloads, while EC2 is better for heavier and long-running systems.
* Amazon Bedrock cost depends on input tokens, output tokens, and the selected AI model.
* AI hallucination can be reduced by using clear prompts, rules, and instructions.
* Security should be considered from the beginning when building AI systems.
* Services such as AWS WAF, Amazon Cognito, and Amazon Bedrock Guardrails can help improve the security of AI applications.
* Good UX/UI is important because many users do not know how to write effective prompts.
* Vibe Coding without structure can easily lead to messy code and failed projects.
* Vibe Method provides a better way to use AI in software development by using documents, architecture, task planning, and review.
* Multi-Agent AI can help divide responsibilities and manage large projects more effectively.
* Human review and approval are still necessary when using AI for software development.

### Application to My Work

The knowledge from this event can be applied to my AWS learning and project development in several ways:

* Use serverless services such as Lambda and API Gateway for lightweight backend APIs.
* Consider EC2 only when the workload is heavy or needs to run continuously.
* Apply better prompt design when using AI tools for learning and coding.
* Add authentication and security layers when designing AWS applications.
* Use Amazon Cognito for user login and account management.
* Use AWS WAF and Guardrails concepts when designing secure AI systems.
* Write clear project documents before asking AI to generate code.
* Break large features into smaller tasks before implementation.
* Apply PRD, architecture design, Epic, Story, Review, and QA steps when building projects.
* Use AI as an assistant, but still verify and control the final result manually.

### Event Experience

Participating in this event was a useful experience for me because it helped me understand both the technical and product sides of building AI applications.

The event showed that building an AI product is not only about calling an AI model. Developers also need to think about cost, security, user experience, prompt quality, architecture, and maintainability.

The sharing about Vibe Coding and Vibe Method was especially useful. It helped me realize that using AI without structure can create many problems, while using AI with clear documents and workflow can make development more effective.

Overall, this event helped me gain more knowledge about AWS, AI product development, serverless architecture, prompt engineering, AI security, and modern AI-assisted software development.

### Event Images

![Event 09/05](/images/event1.png)
