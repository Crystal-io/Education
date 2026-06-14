# Backlog Management Standard

**Document type:** Mini-regulation / Backlog Operating Model  
**Area:** Jira, Confluence, Product Backlog, Sprint Backlog  
**Owner:** Lead Business-System Analyst  
**Audience:** Product Owner, BSA/SA, Delivery/Project Manager, Tech Lead, Developers, QA, UX/UI, Stakeholders  
**Version:** 1.0  
**Status:** Draft for team alignment  

---

## 1. Purpose

This document defines a common standard for managing backlog items, requirements, and project documentation.

The goal is to make Jira and Confluence work as one delivery system:

```text
Confluence = context, requirements, decisions, rules, knowledge
Jira        = execution, status, ownership, delivery tracking
```

The standard helps the team:

- create clear, testable, and development-ready backlog items;
- reduce rework caused by vague requirements;
- keep requirements traceable from business goal to implementation;
- improve sprint predictability;
- make backlog refinement systematic;
- avoid turning Jira into a task dump.

---

## 2. Scope

This standard covers:

- Product Backlog management;
- Sprint Backlog management;
- Jira hierarchy and issue types;
- Confluence documentation structure;
- Definition of Ready and Definition of Done;
- backlog refinement rules;
- templates for Jira Epic, Story, Task, and Sub-task;
- traceability between Confluence, Jira, design, API contracts, test cases, and releases.

This standard does **not** define:

- company-level portfolio governance;
- HR/process management outside product delivery;
- detailed engineering standards;
- release management policy beyond backlog-related checkpoints.

---

## 3. Core Principles

## 3.1. Jira is not a replacement for requirements documentation

Jira issue should be clear enough for delivery, but it should not become a huge unstructured document.

Use:

- **Confluence** for full requirements, business rules, SRS/FRD, API details, data models, access matrix, decision logs.
- **Jira** for actionable work items linked to the relevant documentation.

## 3.2. Every item should have a clear reason to exist

Each Epic, Story, or Task must answer:

```text
Why are we doing this?
Who needs it?
What should change?
How do we validate success?
```

## 3.3. Work should be sliced vertically where possible

Prefer user-value slices over technical-layer slices.

Good vertical slice:

```text
CRM Manager can create a basic customer segment using one condition and save it.
```

Weak horizontal slice:

```text
Create database table for segments.
```

Technical work can exist as Tasks/Sub-tasks, but user-facing Product Backlog Items should aim to deliver usable value.

## 3.4. Acceptance Criteria must be testable

Bad:

```text
System should work correctly.
```

Good:

```text
Given CRM Manager opens the Segment Builder,
When required fields are empty and user clicks Save,
Then system prevents saving and displays validation errors for each required field.
```

## 3.5. Definition of Ready protects the Sprint

A Story/Task should not enter Sprint Planning unless it is ready enough for estimation, development, and QA.

## 3.6. Definition of Done protects the Product

A completed issue is not just “code merged”. Done means the expected business/technical result is delivered, tested, documented, and accepted according to the relevant checklist.

---

## 4. Tool Responsibility Model

## 4.1. Confluence responsibility

Confluence stores stable or semi-stable product knowledge.

Recommended areas:

| Area | Content |
|---|---|
| Product Overview | Vision, goals, product scope, user groups, JTBD, CJM |
| Product Requirements | PRD, BRD, feature specs, functional requirements |
| System Requirements | SRS/FRD, system behavior, module requirements |
| Business Rules | Rules, formulas, decision tables, state machines |
| Access Control | Roles, permissions, access matrix |
| UX/UI | Figma links, user flows, UX notes, screen behavior |
| Architecture | C4, sequence diagrams, integration diagrams |
| API & Integrations | Swagger/OpenAPI, API contracts, webhooks, events, ICD |
| Data | ERD, data dictionary, field mapping, migration rules |
| NFR | Performance, security, logging, audit, scalability, availability |
| QA/UAT | Test strategy, UAT scenarios, test data, known regression areas |
| Release | Release notes, rollout plan, feature flags, rollback notes |
| Operations | Runbooks, monitoring, alerts, support instructions |
| Decisions | Decision log, ADR, trade-offs, meeting outcomes |
| Meetings | Discovery notes, refinement notes, sprint review notes |

## 4.2. Jira responsibility

Jira stores work items and delivery state.

Jira is used for:

- backlog ordering;
- sprint planning;
- status tracking;
- ownership;
- dependency tracking;
- estimation;
- development and QA workflow;
- release grouping;
- link to Confluence requirements;
- link to test cases, pull requests, commits, builds, deployments.

---

## 5. Jira Hierarchy

The agreed hierarchy:

```text
Epic
 ├── Story
 │    └── Sub-task
 └── Task
      └── Sub-task
```

## 5.1. Epic

Epic is a large business goal, product capability, or feature area that usually cannot be completed within one sprint.

Examples:

- Customer Segmentation
- Campaign Builder
- Notification Delivery Management
- Role-Based Access Control
- CRM Audit Log

## 5.2. Story

Story describes user-facing value.

Format:

```text
As a <role>,
I want <capability>,
So that <business/user value>.
```

Examples:

- As a CRM Manager, I want to create a customer segment, so that I can target users with relevant campaigns.
- As a Support Agent, I want to see customer communication history, so that I can resolve customer issues faster.

## 5.3. Task

Task describes technical, analytical, operational, or delivery work that is not naturally expressed as a user story.

Examples:

- Create Kafka topic for segment update events.
- Prepare API contract for Campaign Service.
- Configure credentials for SendGrid integration.
- Perform spike for segment query performance.
- Create DB migration for audit log table.

## 5.4. Sub-task

Sub-task is an atomic execution step under a Story or Task.

Examples:

- Implement backend validation.
- Add unit tests.
- Create DB migration.
- Update Swagger.
- Prepare test data.
- Configure environment variable.

---

## 6. Product Backlog

## 6.1. Definition

Product Backlog is the ordered list of all known work required to improve or maintain the product.

It can contain:

- Epics;
- Stories;
- Tasks;
- Bugs, if used in project workflow;
- technical debt;
- spikes;
- improvements;
- compliance items;
- operational tasks.

## 6.2. Ownership

| Activity | Primary owner | Contributors |
|---|---|---|
| Backlog ordering | Product Owner | Lead BSA, stakeholders |
| Requirements quality | Lead BSA / BSA | PO, Tech Lead, QA |
| Technical feasibility | Tech Lead | Developers, Architect |
| Testability | QA Lead | BSA, Developers |
| Estimation | Delivery Team | PO/BSA for clarification |
| Documentation | Lead BSA / BSA | PO, QA, Dev, Architect |

## 6.3. Product Backlog rules

Each Product Backlog item should have:

- clear title;
- issue type;
- parent Epic, if applicable;
- business context or technical context;
- priority or ordering;
- owner;
- current status;
- links to relevant documentation;
- acceptance criteria or completion criteria;
- dependencies, if any.

## 6.4. Backlog ordering principles

Backlog should be ordered using a combination of:

- business value;
- risk reduction;
- customer impact;
- regulatory/compliance urgency;
- technical dependency;
- effort/complexity;
- time criticality;
- release target;
- team capacity.

Optional methods:

| Method | Best for |
|---|---|
| MoSCoW | Simple business prioritization |
| RICE | Product features with measurable reach/impact |
| WSJF | Complex backlog with cost of delay and job size |
| Risk-first | Unknown, risky, integration-heavy work |
| Dependency-first | Work that unlocks other teams or features |

---

## 7. Sprint Backlog

## 7.1. Definition

Sprint Backlog is the selected set of Product Backlog Items for the Sprint plus the plan for delivering them.

Sprint Backlog includes:

- Sprint Goal;
- selected Stories/Tasks;
- Sub-tasks created by the team;
- known risks and dependencies;
- delivery plan;
- ownership and status.

## 7.2. Sprint Backlog rules

A Story/Task can enter the Sprint only when:

- it meets Definition of Ready;
- it has been discussed with the delivery team;
- it is estimated or intentionally timeboxed;
- dependencies are known;
- QA understands how to validate it;
- scope is stable enough for the Sprint.

## 7.3. Changes during Sprint

Allowed:

- clarification of requirements without changing scope;
- splitting implementation into Sub-tasks;
- adding missing technical Sub-tasks;
- updating acceptance criteria if they clarify already agreed behavior;
- adding discovered edge cases if they are within the same scope.

Requires PO/BSA/Team agreement:

- changing business logic;
- adding new scope;
- replacing Sprint item;
- moving item out of Sprint;
- changing Sprint Goal;
- changing acceptance criteria in a way that changes expected outcome.

## 7.4. Spillover rules

If a Story/Task is not completed by the end of the Sprint:

- identify the reason;
- keep completed Sub-tasks closed;
- move incomplete work back to Product Backlog or next Sprint;
- update remaining work and risks;
- review whether the item was not ready, too large, blocked, or underestimated.

---

## 8. Backlog Lifecycle

Recommended lifecycle:

```text
New
 → Triage
 → Analysis
 → Ready for Refinement
 → In Refinement
 → Ready for Sprint
 → In Sprint
 → In Development
 → In QA
 → Ready for UAT / Review
 → Done
```

A simplified Jira workflow can be used, but the team should still understand the logical lifecycle.

## 8.1. Status definitions

| Status | Meaning | Exit criteria |
|---|---|---|
| New | Request created, not yet analyzed | Owner assigned, triage decision made |
| Triage | Initial review of value, urgency, duplicates | Accepted for analysis, rejected, or postponed |
| Analysis | BSA/SA clarifies scope, requirements, questions | Requirements are clear enough for refinement |
| Ready for Refinement | Item has basic context and draft AC | Team can discuss and estimate |
| In Refinement | Team clarifies, splits, estimates | Item meets DoR |
| Ready for Sprint | Item can be planned into Sprint | Selected during Sprint Planning |
| In Sprint | Item committed for current Sprint | Work started |
| In Development | Implementation in progress | Ready for QA |
| In QA | Testing in progress | Accepted or returned |
| Ready for UAT / Review | Ready for PO/business validation | Accepted by PO/business or returned |
| Done | Meets DoD | Closed |

---

## 9. Intake and Triage

## 9.1. Intake sources

New backlog items can come from:

- stakeholder request;
- product discovery;
- customer feedback;
- analytics;
- support cases;
- compliance needs;
- production incidents;
- technical debt;
- architecture roadmap;
- sprint review feedback;
- team retrospectives.

## 9.2. Minimum intake information

Before a request becomes a backlog item, capture:

```markdown
## Request
What is requested?

## Requester
Who requested it?

## Problem
What problem should be solved?

## Expected Value
What value or outcome is expected?

## Deadline / Time Criticality
Is there a fixed date or dependency?

## Affected Users / Systems
Who or what is affected?

## Links / Evidence
Support tickets, analytics, screenshots, documents, stakeholder notes.
```

## 9.3. Triage decisions

| Decision | Meaning |
|---|---|
| Accept for analysis | Item has potential value and should be analyzed |
| Reject | Not aligned, duplicate, invalid, or no value |
| Park | Potentially useful but not relevant now |
| Merge | Duplicate or part of another item |
| Convert | Request should become Epic/Story/Task/Sub-task |
| Escalate | Requires product/architecture/security decision |

---

## 10. Backlog Refinement

## 10.1. Purpose

Refinement prepares backlog items for future development.

Refinement is used to:

- clarify requirements;
- break down large items;
- identify dependencies;
- add acceptance criteria;
- discuss technical approach;
- identify risks;
- estimate effort;
- confirm readiness for Sprint Planning.

## 10.2. Cadence

For 2-week sprints:

| Event | Recommended cadence |
|---|---|
| Backlog refinement | 1–2 times per week |
| Pre-planning backlog check | 2–3 days before Sprint Planning |
| Backlog hygiene | Weekly |
| Epic review | Every 2–4 weeks |
| Documentation review | Once per sprint or before release |

## 10.3. Refinement participants

Required:

- Product Owner;
- Lead BSA / BSA;
- Tech Lead or senior developer;
- QA representative.

Optional:

- UX/UI;
- Architect;
- DevOps;
- Security;
- Data/BI;
- Support/Operations;
- external system owner.

## 10.4. Refinement input

Before refinement, BSA prepares:

- draft Story/Task;
- business context;
- acceptance criteria;
- relevant Confluence links;
- open questions;
- UX/API/data dependencies;
- proposed splitting;
- risks and assumptions.

## 10.5. Refinement output

After refinement, item should have:

- clarified scope;
- updated acceptance criteria;
- identified dependencies;
- known open questions;
- estimate or timebox;
- owner for follow-ups;
- readiness decision:
  - ready for Sprint;
  - needs more analysis;
  - split required;
  - blocked;
  - rejected/postponed.

## 10.6. Refinement checklist

```markdown
- Is business value clear?
- Is the user/system role clear?
- Is scope clear?
- Is out of scope clear?
- Are acceptance criteria testable?
- Are edge cases identified?
- Are permissions/access rules clear?
- Are logging/audit requirements clear?
- Are integration points known?
- Is data mapping clear?
- Are UX/UI assets available or not required?
- Are dependencies known?
- Are risks known?
- Can QA test this?
- Can Dev estimate this?
- Is the item small enough for one sprint?
```

---

## 11. Definition of Ready

## 11.1. General Definition of Ready

A Jira item is ready for Sprint Planning when:

```markdown
- Issue type is correct.
- Parent Epic is assigned, if applicable.
- Business or technical objective is clear.
- Scope and out of scope are clear enough.
- Acceptance criteria or completion criteria are defined.
- Required Confluence documentation is linked.
- UX/UI mockups are linked or explicitly not required.
- API/event/data contracts are linked or explicitly not required.
- Permissions/access rules are described or not applicable.
- Logging/audit requirements are described or not applicable.
- Main edge cases are described.
- Dependencies and blockers are identified.
- Open questions are resolved or non-blocking.
- QA can define test scenarios.
- Team can estimate the item.
```

## 11.2. Epic Definition of Ready

Epic is ready when:

```markdown
- Business goal is clear.
- Product outcome is clear.
- Success metrics are defined or intentionally marked as N/A.
- In Scope and Out of Scope are described.
- Stakeholders and owners are known.
- High-level requirements are documented.
- Main dependencies are identified.
- Main risks and assumptions are documented.
- Related Confluence page exists.
- Epic can be decomposed into Stories/Tasks.
```

## 11.3. Story Definition of Ready

Story is ready when:

```markdown
- User role is clear.
- User value is clear.
- Main flow is described.
- Alternative flows and edge cases are captured.
- Acceptance Criteria are testable.
- Business rules are documented or linked.
- Functional requirements are documented or linked.
- Permissions are defined.
- Logging/audit needs are defined.
- NFRs are described or marked N/A.
- UX/UI is attached or not required.
- Integration/data impact is clear.
- QA understands how to test.
- Story is small enough for one sprint.
```

## 11.4. Task Definition of Ready

Task is ready when:

```markdown
- Objective is clear.
- Context is clear.
- Expected output is defined.
- Technical scope is clear.
- Acceptance/completion criteria are defined.
- Required access/credentials are known.
- Dependencies are identified.
- Required documentation/specs are linked.
- Task is estimated or timeboxed.
```

## 11.5. Sub-task Definition of Ready

Sub-task is ready when:

```markdown
- Parent Story/Task is clear.
- Concrete action is defined.
- Owner can start work without additional analysis.
- Expected result is clear.
- Dependencies are known.
```

---

## 12. Definition of Done

## 12.1. General Definition of Done

An item is Done when:

```markdown
- All acceptance criteria are met.
- Implementation is completed.
- Code review is completed, if applicable.
- Required automated/manual tests passed.
- QA has validated the item.
- No critical/blocking defects remain.
- Documentation is updated, if required.
- Logging/monitoring is implemented, if required.
- Security/access rules are implemented, if required.
- Feature flag/rollout rules are configured, if required.
- PO/BSA accepted the result.
```

## 12.2. Epic Definition of Done

Epic is Done when:

```markdown
- All required child Stories/Tasks are Done.
- Epic-level acceptance criteria are met.
- Success metrics can be measured or tracking is configured.
- Required documentation is updated.
- UAT/business review is completed, if required.
- Release/rollout is completed or planned.
- Known follow-up items are created in backlog.
- PO/business owner accepts the Epic.
```

## 12.3. Story Definition of Done

Story is Done when:

```markdown
- All Acceptance Criteria pass.
- Business rules work as expected.
- Permissions work as expected.
- Validation messages are correct.
- Logging/audit requirements are implemented.
- UI behavior matches approved design, if applicable.
- API/integration behavior matches contract, if applicable.
- QA testing is completed.
- Regression impact is checked.
- Documentation/test cases are updated, if required.
```

## 12.4. Task Definition of Done

Task is Done when:

```markdown
- Expected technical/analytical result is delivered.
- Completion criteria are met.
- Required review is completed.
- Related Story/Epic is updated.
- Documentation/specification is updated, if required.
- No unresolved blocker remains.
```

## 12.5. Sub-task Definition of Done

Sub-task is Done when:

```markdown
- Specific action is completed.
- Parent issue can use the result.
- Relevant evidence is attached or linked, if needed.
- Owner has updated status/comment.
```

---

## 13. Requirements Placement Matrix

| Artifact / Requirement type | Primary place | Jira reference |
|---|---|---|
| Product vision | Confluence / Product Overview | Epic link |
| Roadmap | Confluence / Roadmap | Epic fixVersion/release |
| JTBD | Confluence / Discovery | Epic/Story link |
| CJM | Confluence / Discovery / UX | Epic/Story link |
| PRD | Confluence / Product Requirements | Epic link |
| BRD | Confluence / Business Requirements | Epic link |
| SRS / FRD | Confluence / System Requirements | Story/Task link |
| Functional Requirements | Confluence / Feature Spec | Story AC / FR section |
| Business Rules | Confluence / Business Rules | Story Business Rules section |
| Acceptance Criteria | Jira Story | Test cases link |
| NFR | Confluence / NFR catalog | Story/Task NFR section |
| API contract | Swagger/OpenAPI / Confluence | Story/Task integration section |
| Event schema | Schema registry / Confluence | Task/Story link |
| Data model | Confluence / Data | Task/Story data section |
| Access matrix | Confluence / Access Control | Story permissions section |
| Logging/audit rules | Confluence / NFR / Audit | Story/Task logging section |
| UX/UI | Figma + Confluence notes | Story UI section |
| Test cases | Test management tool / Confluence | Story/Task test link |
| Release notes | Confluence / Release | Epic/Version link |
| Decision log | Confluence / Decisions | Epic/Story/Task link |

---

## 14. Confluence Structure

Recommended project space structure:

```text
Project / Product Space
├── 00. Start Here
│   ├── Project Overview
│   ├── Team & Contacts
│   ├── Ways of Working
│   └── Glossary
│
├── 01. Product Overview
│   ├── Product Vision
│   ├── Product Goals
│   ├── Product Scope
│   ├── User Personas
│   ├── JTBD
│   ├── CJM
│   └── Roadmap
│
├── 02. Requirements
│   ├── PRD
│   ├── BRD
│   ├── Feature Specifications
│   ├── SRS / FRD
│   ├── Business Rules
│   ├── Acceptance Rules
│   └── Open Questions
│
├── 03. UX / UI
│   ├── User Flows
│   ├── Figma Links
│   ├── Screen Specifications
│   └── UI States
│
├── 04. Architecture & Integrations
│   ├── C4 Diagrams
│   ├── Sequence Diagrams
│   ├── API Contracts
│   ├── Webhooks / Events
│   ├── External Systems
│   └── Integration Decisions
│
├── 05. Data
│   ├── ERD
│   ├── Data Dictionary
│   ├── Field Mapping
│   ├── Migration Rules
│   └── Retention Rules
│
├── 06. Security, Access & NFR
│   ├── Access Matrix
│   ├── Authentication / Authorization
│   ├── Logging & Audit
│   ├── Performance
│   ├── Availability
│   ├── Compliance
│   └── Security Requirements
│
├── 07. QA / UAT
│   ├── Test Strategy
│   ├── Test Scenarios
│   ├── UAT Plan
│   ├── Regression Areas
│   └── Test Data
│
├── 08. Delivery
│   ├── Sprint Notes
│   ├── Release Notes
│   ├── Rollout Plans
│   ├── Feature Flags
│   └── Rollback Plans
│
├── 09. Operations
│   ├── Monitoring
│   ├── Alerts
│   ├── Runbooks
│   ├── Support Instructions
│   └── Incident Notes
│
└── 10. Decisions & Meetings
    ├── Decision Log
    ├── ADR
    ├── Discovery Notes
    ├── Refinement Notes
    └── Sprint Review Notes
```

---

## 15. Traceability Model

Each significant item should be traceable.

Recommended chain:

```text
Business Goal / PRD
 → Epic
 → Story / Task
 → Sub-task
 → Pull Request / Commit
 → Build / Deployment
 → Test Case
 → Release Note
 → Monitoring / Metric
```

## 15.1. Mandatory links

| Jira issue type | Mandatory links |
|---|---|
| Epic | PRD/Feature Spec, roadmap/milestone if applicable |
| Story | Epic, requirement/spec page, design/API/data links if applicable |
| Task | Epic or related Story, technical spec if applicable |
| Sub-task | Parent Story/Task |

## 15.2. Recommended link types

| Link type | Meaning |
|---|---|
| relates to | Generic relation |
| blocks | This item blocks another |
| is blocked by | This item cannot progress |
| implements | Technical item implements functional item |
| depends on | Dependency without hard blocker |
| duplicates | Duplicate item |
| caused by | Useful for bugs/incidents |

---

## 16. Jira Field Standards

Recommended fields:

| Field | Epic | Story | Task | Sub-task |
|---|---:|---:|---:|---:|
| Summary | Required | Required | Required | Required |
| Description | Required | Required | Required | Required |
| Parent / Epic Link | N/A | Required | Required if applicable | Required |
| Priority | Required | Required | Required | Optional |
| Component | Required | Required | Required | Optional |
| Labels | Recommended | Recommended | Recommended | Optional |
| Fix Version | If release-bound | If release-bound | If release-bound | Optional |
| Assignee | Optional before Sprint | Optional before Sprint | Optional before Sprint | Recommended |
| Story Points | Optional | Required for sprint | Optional/timebox | Usually not |
| Due Date | Only if real deadline | Only if real deadline | Only if real deadline | Rarely |
| Linked Confluence | Required | Required if requirements exist | Required if specs exist | Optional |
| Acceptance Criteria | Epic-level DoD | Required | Required/Completion Criteria | Minimal |

---

## 17. Naming Conventions

## 17.1. Epic naming

Pattern:

```text
<Noun / Capability>
```

Examples:

```text
Customer Segmentation
Campaign Builder
Notification Delivery Management
CRM Audit Log
Role-Based Access Control
```

Avoid:

```text
Implement segmentation
Work on campaign module
CRM improvements
```

## 17.2. Story naming

Pattern:

```text
<Role> can <action> <object>
```

Examples:

```text
CRM Manager can create a customer segment
Support Agent can view customer communication history
Admin can assign permissions to CRM roles
```

## 17.3. Task naming

Pattern:

```text
<Verb> <technical/action object>
```

Examples:

```text
Create Kafka topic for segment updates
Prepare API contract for Segment Service
Configure SendGrid credentials for staging
Create DB migration for audit log
```

## 17.4. Sub-task naming

Pattern:

```text
<Specific action>
```

Examples:

```text
Add backend validation for required fields
Update Swagger response model
Prepare test data for segment creation
Add unit tests for permission check
```

---

## 18. Functional Requirements vs Acceptance Criteria vs Business Rules

## 18.1. Functional Requirement

Describes what the system must do.

Example:

```text
System shall allow CRM Manager to create a customer segment using selected customer attributes.
```

## 18.2. Acceptance Criteria

Describes how we validate that the story is implemented correctly.

Example:

```gherkin
Given CRM Manager has permission to manage segments
When CRM Manager creates a segment with valid conditions
Then system saves the segment and displays it in the segment list
```

## 18.3. Business Rule

Describes stable business logic or policy.

Example:

```text
A customer can belong to multiple segments.
A segment name must be unique within one tenant.
Archived segments cannot be used for new campaigns.
```

## 18.4. Practical rule

| Item | Should be in |
|---|---|
| Stable logic reused across features | Confluence Business Rules |
| Story-specific behavior | Jira Story AC |
| Detailed system behavior | Confluence SRS/FRD |
| Developer implementation notes | Jira Task or technical spec |

---

## 19. Logging, Audit, and Access Rules

## 19.1. Where to document

| Requirement | Main location | Jira location |
|---|---|---|
| Global logging standard | Confluence / NFR / Logging | Link from Story/Task |
| Feature-specific logging | Feature spec / Story | Story Logging section |
| Audit events | Confluence / Audit matrix | Story/Task Logging section |
| Access matrix | Confluence / Access Control | Story Permissions section |
| Role-specific behavior | Feature spec | Story AC / Permissions section |

## 19.2. Logging minimum

For important business actions, define:

```markdown
- Event name
- Trigger
- Log level
- Actor/userId
- tenantId
- entityId
- action
- timestamp
- requestId/correlationId
- old value / new value if applicable
- result: success/failure
- error code/message if failed
```

## 19.3. Audit minimum

For auditable actions, define:

```markdown
- Who performed the action?
- What was changed?
- When was it changed?
- From where was it changed?
- What was the previous value?
- What is the new value?
- Can the audit record be viewed/exported?
- Who has access to audit records?
```

## 19.4. Access minimum

For role-based features, define:

```markdown
- Who can view?
- Who can create?
- Who can edit?
- Who can delete?
- Who can approve?
- Who can export?
- What happens if permission is missing?
- Are permissions tenant-specific?
- Are permissions inherited?
```

---

## 20. Estimation Rules

## 20.1. Estimation approaches

| Approach | Usage |
|---|---|
| Story Points | Stories and delivery complexity |
| Timebox | Spikes, research, investigation |
| Hours | Sub-tasks if team uses hourly breakdown |
| T-shirt size | Early estimation for Epics |

## 20.2. Estimation checklist

Before estimation, team should understand:

```markdown
- What should be delivered?
- What is in scope?
- What is out of scope?
- What are the main risks?
- Are there unknowns?
- Are external systems involved?
- Is UI involved?
- Is data migration involved?
- Is security review needed?
- Is testing complexity clear?
```

## 20.3. Spike rule

Use Spike when the team cannot estimate due to uncertainty.

Spike must have:

```markdown
- Research question
- Timebox
- Expected output
- Decision to be made
- Link to resulting documentation
```

---

## 21. Splitting Rules

## 21.1. Split by workflow step

Example:

```text
Create segment
Edit segment
Archive segment
View segment history
```

## 21.2. Split by user role

Example:

```text
Admin can manage all segments
CRM Manager can manage own segments
Support Agent can view segments only
```

## 21.3. Split by business rule complexity

Example:

```text
Create segment with one condition
Create segment with AND conditions
Create segment with AND/OR groups
Create dynamic segment recalculation
```

## 21.4. Split by channel/integration

Example:

```text
Send campaign via Email
Send campaign via SMS
Send campaign via Telegram
Send campaign via Push
```

## 21.5. Split by happy path and edge cases

Example:

```text
Create segment - happy path
Handle duplicate segment name
Handle invalid segment criteria
Handle external scoring service unavailable
```

## 21.6. Avoid splitting only by technical layer

Avoid:

```text
Create DB
Create API
Create UI
```

Better:

```text
CRM Manager can create a basic segment
```

Technical work can be Sub-tasks under the Story.

---

## 22. Backlog Quality Metrics

Recommended metrics:

| Metric | Why it matters |
|---|---|
| % Stories meeting DoR before Sprint Planning | Measures backlog readiness |
| Number of scope changes during Sprint | Measures requirement stability |
| Number of returned items from Dev/QA to Analysis | Shows clarity issues |
| Number of blocked Sprint items | Shows dependency management quality |
| Carryover rate | Shows planning and slicing quality |
| Defects caused by missed requirements | Shows requirement quality |
| Average age of backlog items | Shows backlog hygiene |
| Number of duplicate/obsolete items | Shows backlog cleanliness |
| % items linked to Confluence | Shows traceability |
| % Stories with AC | Shows testability |

---

## 23. Backlog Hygiene Rules

Weekly backlog hygiene should include:

```markdown
- Remove or close duplicates.
- Update stale items.
- Reorder top backlog.
- Archive obsolete items.
- Merge overlapping items.
- Split oversized items.
- Add missing links to Confluence.
- Check that top backlog meets DoR.
- Review blocked items.
- Review items without Epic.
- Review items without priority.
```

---

## 24. Common Anti-patterns

| Anti-pattern | Problem | Fix |
|---|---|---|
| Jira as documentation dump | Hard to read, no structure | Keep full docs in Confluence, link from Jira |
| Story without user value | Team delivers tasks, not outcomes | Rewrite as user/system capability |
| AC missing or vague | QA cannot validate | Use testable Given/When/Then |
| No out of scope | Scope creep | Add explicit Out of Scope |
| Technical tasks pretending to be stories | Wrong planning and value tracking | Use Task or Sub-task |
| Huge stories | Carryover and delays | Split vertically |
| No permissions specified | Security gaps | Add access matrix/permissions block |
| No logging/audit specified | Hard to investigate incidents | Add logging/audit section |
| No links to design/API | Devs guess implementation | Link Figma/Swagger/spec |
| Sprint starts with open questions | Delays and rework | Enforce DoR |

---

# Appendix A. Jira Epic Template

```markdown
# Epic: <Epic Name>

## 1. Summary
Short description of the business/product capability.

## 2. Business Goal / Problem
What business problem are we solving?
Why is this Epic important now?

## 3. Product Outcome
What should change in the product after this Epic is delivered?

## 4. Business Value
- Expected value:
- Impacted metric:
- Expected business/user benefit:
- Cost of delay, if applicable:

## 5. Success Metrics / KPI
| Metric | Current value | Target value | Measurement source |
|---|---:|---:|---|
| | | | |

## 6. Stakeholders and Owners
| Role | Name | Responsibility |
|---|---|---|
| Business Owner | | |
| Product Owner | | |
| Lead BSA / BSA | | |
| Tech Lead | | |
| QA Lead | | |
| UX/UI | | |
| Architect | | |

## 7. Users / Roles Affected
- Role 1:
- Role 2:
- System actor:

## 8. Scope
### In Scope
- ...

### Out of Scope
- ...

## 9. High-Level Functional Requirements
| FR ID | Requirement |
|---|---|
| FR-001 | |
| FR-002 | |

## 10. High-Level Business Rules
| BR ID | Rule |
|---|---|
| BR-001 | |
| BR-002 | |

## 11. High-Level NFR
| Category | Requirement |
|---|---|
| Performance | |
| Security | |
| Access Control | |
| Logging / Audit | |
| Availability | |
| Scalability | |
| Compliance | |
| Data Retention | |

## 12. Impacted Systems / Components
| System / Component | Impact |
|---|---|
| | |

## 13. Integrations
| System | Interaction | Sync/Async | Notes |
|---|---|---|---|
| | | | |

## 14. Data Impact
- New entities:
- Changed entities:
- Migration required:
- Reporting/analytics impact:

## 15. UX/UI Impact
- Figma link:
- User flow:
- Screens affected:

## 16. Dependencies
| Dependency | Type | Owner | Status |
|---|---|---|---|
| | | | |

## 17. Risks
| Risk | Probability | Impact | Mitigation |
|---|---|---|---|
| | | | |

## 18. Assumptions
- ...

## 19. Rollout / Release Strategy
- Target release:
- Feature flag:
- Pilot group:
- Migration:
- Backward compatibility:
- Rollback:

## 20. Analytics / Monitoring
- Business events:
- Technical metrics:
- Dashboard:
- Alerts:

## 21. Linked Documentation
- PRD:
- SRS / FRD:
- UX/UI:
- API spec:
- Data model:
- Access matrix:
- NFR:
- Decision log:

## 22. Child Issues
- Stories:
- Tasks:
- Spikes:
- Technical debt:

## 23. Open Questions
| Question | Owner | Due date | Status |
|---|---|---|---|
| | | | |

## 24. Epic Definition of Ready
- [ ] Business goal is clear
- [ ] Product outcome is clear
- [ ] Success metrics are defined or marked N/A
- [ ] In Scope / Out of Scope are defined
- [ ] Stakeholders are identified
- [ ] High-level requirements are documented
- [ ] Main dependencies are identified
- [ ] Main risks are documented
- [ ] Related Confluence page is linked
- [ ] Epic can be decomposed into Stories/Tasks

## 25. Epic Definition of Done
- [ ] Required child Stories/Tasks are Done
- [ ] Epic-level acceptance criteria are met
- [ ] Required documentation is updated
- [ ] Monitoring/analytics is configured if applicable
- [ ] UAT/business review is completed if required
- [ ] Release/rollout is completed or planned
- [ ] Follow-up items are created if needed
- [ ] PO/business owner accepted result
```

---

# Appendix B. Jira Story Template

```markdown
# Story: <Story Name>

## 1. User Story
As a <role>,
I want <capability/action>,
So that <business/user value>.

## 2. Business Context
Why is this Story needed?
What problem does it solve?
How does it support the Epic goal?

## 3. User / Role
- Primary role:
- Secondary roles:
- System actor, if applicable:
- Tenant/market/product limitations:

## 4. Preconditions
- ...
- ...

## 5. Postconditions
- ...
- ...

## 6. Main Flow
1. ...
2. ...
3. ...

## 7. Alternative Flows
### A1. <Alternative flow name>
1. ...
2. ...

### A2. <Alternative flow name>
1. ...
2. ...

## 8. Edge Cases
| Case | Expected behavior |
|---|---|
| | |

## 9. Functional Requirements
| FR ID | Requirement |
|---|---|
| FR-001 | System shall ... |
| FR-002 | System shall ... |

## 10. Business Rules
| BR ID | Rule |
|---|---|
| BR-001 | |
| BR-002 | |

## 11. Acceptance Criteria
### AC-001: <Name>
Given ...
When ...
Then ...

### AC-002: <Name>
Given ...
When ...
Then ...

## 12. Validation Rules
| Field / Object | Rule | Error message |
|---|---|---|
| | | |

## 13. Permissions / Access Control
| Role | View | Create | Edit | Delete | Approve | Export |
|---|---|---|---|---|---|---|
| Admin | | | | | | |
| Manager | | | | | | |
| Agent | | | | | | |

### Permission failure behavior
- ...

## 14. Logging Requirements
| Event | Trigger | Level | Required fields |
|---|---|---|---|
| | | | |

Required common fields:
- userId
- tenantId
- entityId
- action
- timestamp
- requestId/correlationId
- result
- errorCode/errorMessage if failed

## 15. Audit Requirements
- Should this action be auditable? Yes/No
- Audit event name:
- Old/new values required? Yes/No
- Who can view audit record?
- Retention period:

## 16. Integration Points
| System | Interaction | Sync/Async | Contract link |
|---|---|---|---|
| | | | |

## 17. API / Event Details
- Endpoint:
- Method:
- Request:
- Response:
- Error codes:
- Event name:
- Event payload:
- Idempotency:
- Retry behavior:

## 18. Data Requirements
| Field | Type | Required | Source | Notes |
|---|---|---|---|---|
| | | | | |

## 19. UI/UX
- Figma link:
- Screens:
- Components:
- UI states:
  - Default:
  - Loading:
  - Empty:
  - Error:
  - Success:
  - Disabled:

## 20. Notifications / Communication
- Trigger:
- Channel:
- Template:
- Recipient:
- Localization:
- Retry/failure behavior:

## 21. Non-Functional Requirements
| Category | Requirement |
|---|---|
| Performance | |
| Security | |
| Availability | |
| Scalability | |
| Localization | |
| Accessibility | |
| Compliance | |
| Data retention | |

## 22. Analytics
- Business event:
- Properties:
- Funnel/metric affected:
- Dashboard/report impact:

## 23. Dependencies
| Dependency | Type | Owner | Status |
|---|---|---|---|
| | | | |

## 24. Test Notes / QA Focus
- Positive scenarios:
- Negative scenarios:
- Regression areas:
- Test data:
- Environments:
- Test case links:

## 25. Open Questions
| Question | Owner | Due date | Status |
|---|---|---|---|
| | | | |

## 26. Out of Scope
- ...

## 27. Links
- Epic:
- Confluence requirement:
- Figma:
- API spec:
- Data model:
- Access matrix:
- Test cases:
- Related issues:

## 28. Story Definition of Ready
- [ ] User role and value are clear
- [ ] Scope is clear
- [ ] Main flow is described
- [ ] Alternative flows / edge cases are described
- [ ] Acceptance Criteria are testable
- [ ] Business rules are documented or linked
- [ ] Functional requirements are documented or linked
- [ ] Permissions are defined
- [ ] Logging/audit requirements are defined or marked N/A
- [ ] NFRs are defined or marked N/A
- [ ] UX/UI is attached or not required
- [ ] Integration/data impact is clear
- [ ] Dependencies are known
- [ ] QA understands how to test
- [ ] Story is estimated
- [ ] Story is small enough for one sprint

## 29. Story Definition of Done
- [ ] All Acceptance Criteria pass
- [ ] Business rules work as expected
- [ ] Permissions work as expected
- [ ] Validation messages are correct
- [ ] Logging/audit requirements are implemented
- [ ] UI behavior matches approved design if applicable
- [ ] API/integration behavior matches contract if applicable
- [ ] QA testing is completed
- [ ] Regression impact is checked
- [ ] Documentation/test cases are updated if required
- [ ] PO/BSA accepted the Story
```

---

# Appendix C. Jira Task Template

```markdown
# Task: <Task Name>

## 1. Context
Why is this Task needed?
Which Epic/Story/initiative does it support?

## 2. Objective
What should be achieved as a result of this Task?

## 3. Task Type
- [ ] Technical implementation
- [ ] Analysis
- [ ] Spike / Research
- [ ] Configuration
- [ ] Infrastructure / DevOps
- [ ] Data / Migration
- [ ] API / Integration
- [ ] QA / Test preparation
- [ ] Documentation
- [ ] Support / Operations
- [ ] Other:

## 4. Scope
### In Scope
- ...

### Out of Scope
- ...

## 5. Expected Output
- ...
- ...

## 6. Technical Details
| Area | Details |
|---|---|
| Component / Service | |
| Repository | |
| Environment | |
| Config changes | |
| DB changes | |
| API changes | |
| Event changes | |
| Feature flag | |
| Monitoring | |

## 7. Implementation Notes
- ...

## 8. API / Integration Details
- System:
- Endpoint/topic/event:
- Contract link:
- Request/response:
- Error handling:
- Retry:
- Idempotency:
- Timeout:
- Fallback:

## 9. Data / DB Details
- New table/field:
- Changed table/field:
- Migration:
- Backfill:
- Data validation:
- Rollback:

## 10. Access / Credentials
- Required access:
- Secrets/credentials:
- Environment variables:
- Who provides access:
- Security notes:

## 11. Logging / Monitoring
- Logs to add/update:
- Metrics:
- Alerts:
- Dashboard:
- Correlation ID:
- Error visibility:

## 12. Security / Compliance
- Permission checks:
- Sensitive data:
- PII impact:
- Encryption/masking:
- Compliance notes:

## 13. Completion Criteria / Acceptance Criteria
- ...
- ...
- ...

## 14. Dependencies
| Dependency | Owner | Status |
|---|---|---|
| | | |

## 15. Risks
| Risk | Impact | Mitigation |
|---|---|---|
| | | |

## 16. Test / Verification Plan
- How to verify:
- Test data:
- Environments:
- Regression areas:
- Expected evidence:

## 17. Documentation Impact
- Confluence page to update:
- Swagger/OpenAPI:
- Runbook:
- Release notes:
- Not required because:

## 18. Open Questions
| Question | Owner | Due date | Status |
|---|---|---|---|
| | | | |

## 19. Links
- Parent Epic:
- Related Story:
- Confluence:
- API spec:
- Pull request:
- Test cases:

## 20. Task Definition of Ready
- [ ] Objective is clear
- [ ] Context is clear
- [ ] Expected output is defined
- [ ] Technical scope is clear
- [ ] Completion criteria are defined
- [ ] Required access/credentials are known
- [ ] Dependencies are identified
- [ ] Required documentation/specs are linked
- [ ] Task is estimated or timeboxed

## 21. Task Definition of Done
- [ ] Expected result is delivered
- [ ] Completion criteria are met
- [ ] Required review is completed
- [ ] Verification/testing is completed
- [ ] Related Story/Epic is updated
- [ ] Documentation/specification is updated if required
- [ ] No unresolved blocker remains
```

---

# Appendix D. Jira Sub-task Template

```markdown
# Sub-task: <Sub-task Name>

## 1. Parent Issue
- Parent Story/Task:
- Parent goal:

## 2. Action
What exactly should be done?

## 3. Expected Result
What should exist or change after this Sub-task is completed?

## 4. Scope
### In Scope
- ...

### Out of Scope
- ...

## 5. Implementation / Work Notes
- ...

## 6. Dependencies
- ...

## 7. Verification
How can the assignee or reviewer confirm that this Sub-task is complete?

## 8. Evidence / Links
- Pull request:
- Commit:
- Screenshot:
- Config:
- Test result:
- Documentation:

## 9. Estimate
- Hours:
- Story points, if used:

## 10. Sub-task Definition of Ready
- [ ] Parent issue is clear
- [ ] Action is specific
- [ ] Expected result is clear
- [ ] Owner can start without additional analysis
- [ ] Dependencies are known

## 11. Sub-task Definition of Done
- [ ] Specific action is completed
- [ ] Result is usable for parent issue
- [ ] Evidence is attached or linked, if needed
- [ ] Parent issue is updated if needed
```
