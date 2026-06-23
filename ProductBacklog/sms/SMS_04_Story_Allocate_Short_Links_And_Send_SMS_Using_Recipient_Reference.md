# Story: Allocate Personalized Short Links and Send SMS Using Recipient Reference

## 1. User Story

As the **CRM System**,  
I want to allocate personalized short links for privacy-safe recipient batches and submit SMS messages using recipient references,  
So that each eligible recipient receives the correct campaign SMS while personal data is resolved only at the final trusted sending boundary.

---

## 2. Business Context

This Story supports the Epic **SMS Campaign Delivery Pipeline with SlimLink Short Links**.

The CRM campaign is already configured and launched, and eligible recipient batches have already been prepared using privacy-safe recipient references (`recipientRef` / `userHash`). The goal of this Story is to continue the SMS pipeline without exposing direct personal data across CRM modules, queues, integration layers or logs.

The Story covers two connected delivery steps:

1. allocate personalized short links for prepared recipient references;
2. create and submit SMS sending jobs using the recipient reference instead of phone numbers or other direct personal data.

The final SMS Sender is the only component allowed to resolve `recipientRef` into the required contact data at the last responsible moment before SMS submission to the approved SMS Router.

This approach provides:

- **data minimization** across the CRM pipeline;
- reduced compliance exposure for intermediate services;
- lower payload size and lower processing overhead;
- safer logging, monitoring and retry behavior;
- clear separation between campaign processing and personal data ownership.

Detailed SlimLink request/response payloads, exact API fields, HTTP codes and error reason mapping are intentionally outside this Story and should be maintained in linked integration Tasks or API specification.

---

## 3. User / Role

- **Primary role:** CRM System / Campaign Processing Service
- **Secondary roles:** CRM Manager, Operations User, QA Engineer
- **System actors:** Campaign Processing Service, SlimLink Integration Service, Message Broker / Queue, SMS Sender, SMS Router, Player Data Service
- **Tenant / market limitations:** SMS availability, sender configuration, consent rules, recipient resolution rules and delivery restrictions may vary by tenant, brand, market and regulatory region.

---

## 4. Preconditions

- SMS campaign has been configured and launched from CRM.
- Campaign has valid SMS message text and campaign URL / link placeholder.
- URL/domain validation has already been completed by CRM before SlimLink processing.
- Eligible recipient batches have been prepared using privacy-safe `recipientRef` values.
- Recipient batches do not contain direct personal data such as phone number, name or email.
- SlimLink access, domain configuration and service limits are available to the integration layer.
- SMS Sender is authorized to resolve `recipientRef` through the approved Player Data / contact resolution boundary.
- SMS Router integration is available for downstream message submission.
- Retry, throttling and duplicate-prevention rules are configured or linked from implementation Tasks.

---

## 5. Postconditions

- Personalized short links are allocated for eligible recipient references where SlimLink processing succeeds.
- CRM stores the mapping between campaignId, batchId, recipientRef and short link assignment.
- Recipients with successful short link allocation are prepared for SMS sending.
- Recipients with failed short link allocation are not sent SMS with missing, invalid or placeholder links.
- SMS sending jobs contain only allowed non-PII processing data and recipient references.
- SMS Sender resolves personal contact data only at the final trusted sending boundary.
- SMS messages are submitted to the approved SMS Router only for valid and resolved recipients.
- Campaign, batch and recipient processing statuses are updated.
- Logs, audit events and monitoring metrics are created without exposing personal data.

---

## 6. Main Flow

1. Campaign Processing Service receives a prepared recipient batch containing `campaignId`, `batchId`, `recipientRef` values and campaign configuration reference.
2. System checks that the campaign is still active and eligible for downstream processing.
3. System verifies that the campaign message contains the required link placeholder / campaign URL reference.
4. System prepares a short link allocation request for the recipient batch using privacy-safe recipient identifiers.
5. System sends the batch to SlimLink through the approved integration boundary.
6. SlimLink allocates short links and returns record-level success / failure results.
7. System stores successful short link assignments against the related `recipientRef` and campaign context.
8. System records failed short link allocation results with error category and correlation data.
9. System creates SMS sending jobs only for recipients with successful short link assignment.
10. SMS sending job contains message template reference or rendered plain text, short URL, campaign context and `recipientRef`.
11. SMS sending job does not contain phone number, name, email or other direct personal data.
12. SMS Sender receives the sending job.
13. SMS Sender resolves `recipientRef` using the approved Player Data / contact resolution service.
14. SMS Sender performs final send-readiness checks, including current phone availability and send eligibility where required.
15. SMS Sender submits the SMS payload to the approved SMS Router.
16. System stores SMS submission status and updates recipient / campaign processing status.
17. System logs and audits critical steps with campaignId, batchId and correlationId.

---

## 7. Alternative Flows

### A1. SlimLink returns partial batch failures

1. SlimLink returns successful short links for part of the batch and failures for other records.
2. System stores successful short link assignments.
3. System does not create SMS sending jobs for failed records.
4. Failed records are marked with a business-readable error category.
5. Campaign or batch status becomes `Partially Failed` if threshold rules are met.
6. Operations can investigate failed records using correlationId / batchId without accessing direct personal data.

### A2. SlimLink is temporarily unavailable or rate-limited

1. Short link allocation request fails because of temporary unavailability or rate limit.
2. System applies configured retry / backoff policy.
3. System does not create SMS sending jobs until short links are successfully allocated.
4. Batch remains in `Pending Retry` or equivalent state.
5. Operations alert is triggered if retry threshold is exceeded.

### A3. Recipient reference cannot be resolved by SMS Sender

1. SMS Sender receives a job with `recipientRef`.
2. SMS Sender fails to resolve the recipient reference through the approved contact resolution boundary.
3. SMS is not submitted to SMS Router for this recipient.
4. Recipient status is set to `Failed` with reason `Recipient Reference Resolution Failed` or equivalent.
5. The failure is logged without exposing direct personal data.

### A4. Recipient becomes ineligible before final sending

1. SMS Sender resolves `recipientRef` but detects that the recipient is no longer eligible for SMS sending.
2. SMS Sender does not submit the message to SMS Router.
3. Recipient status is updated with the appropriate exclusion / failure reason.
4. Campaign metrics are updated.

### A5. Campaign is cancelled during processing

1. Campaign status changes to `Cancelled` while batches are still being processed.
2. System stops creating new short link allocation or SMS sending jobs.
3. Already created jobs are skipped or cancelled if not yet submitted to SMS Router.
4. Messages already accepted by SMS Router cannot be recalled.
5. Campaign status and audit trail reflect cancellation timing.

### A6. Retry is triggered for the same batch

1. System retries short link allocation or SMS sending after a retryable failure.
2. System checks existing short link assignments and SMS send states before repeating an action.
3. Already successfully sent recipients are not sent again.
4. Duplicate-prevention result is logged as an operational event.

### A7. Message template or link placeholder is invalid

1. System detects that message content cannot be prepared with the allocated short link.
2. SMS sending job is not created for affected recipients.
3. Batch or campaign is marked as failed according to severity.
4. CRM Manager / Operations receives a clear failure reason where permitted.

---

## 8. Edge Cases

| Case | Expected behavior |
|---|---|
| Batch contains duplicate recipient references | System deduplicates or rejects duplicates according to campaign rules. |
| Short link allocation succeeds but SMS job creation fails | Assignment is stored; job creation can be retried without requesting duplicate link allocation unless policy requires otherwise. |
| Short link allocation fails for one recipient | Other successful recipients continue processing. |
| SlimLink returns failure for reused recipient-level identifier | System treats it as reconciliation / duplicate-prevention issue, not as a normal successful retry. |
| Recipient reference expires before sending | SMS is not sent; recipient is marked failed. |
| SMS Sender cannot resolve phone number | SMS is not sent; failure is recorded. |
| Phone number exists but SMS consent is withdrawn before sending | SMS is not sent; final eligibility check blocks delivery. |
| Campaign is launched twice accidentally | System must prevent duplicate downstream processing for the same campaign launch. |
| Message contains missing short link placeholder | SMS job is not created until content is valid. |
| SMS Router accepts message but delivery status is delayed | Recipient remains in `Submitted` / `Pending Delivery Status` until update is received or timeout is reached. |
| Logs contain attempted PII values | Logging policy must mask / reject direct personal data. |

---

## 9. Functional Requirements

| FR ID | Requirement |
|---|---|
| FR-001 | System shall process only prepared recipient batches created for an active SMS campaign. |
| FR-002 | System shall use privacy-safe recipient references for short link allocation and SMS sending jobs. |
| FR-003 | System shall not propagate phone numbers, names, emails or direct personal data through campaign processing, queues, SlimLink integration or monitoring layers. |
| FR-004 | System shall allocate personalized short links for each eligible recipient reference through SlimLink integration. |
| FR-005 | System shall respect configured SlimLink batching, throttling and retry constraints. |
| FR-006 | System shall store successful short link assignments linked to campaignId, batchId and recipientRef. |
| FR-007 | System shall store record-level short link allocation failures with error category and correlationId. |
| FR-008 | System shall create SMS sending jobs only for recipients with successful short link assignment. |
| FR-009 | System shall insert or bind the allocated short URL into SMS message content according to the approved template rule. |
| FR-010 | System shall not create SMS jobs where the message cannot be rendered with a valid short link. |
| FR-011 | System shall submit SMS jobs to the SMS Sender using recipientRef instead of direct contact data. |
| FR-012 | SMS Sender shall resolve recipientRef only through the approved Player Data / contact resolution boundary. |
| FR-013 | SMS Sender shall perform final eligibility and contact availability checks before SMS Router submission. |
| FR-014 | System shall prevent duplicate SMS sending during retries, reprocessing and repeated launch requests. |
| FR-015 | System shall process successful and failed recipients independently within the same batch. |
| FR-016 | System shall update campaign, batch and recipient statuses during allocation and sending. |
| FR-017 | System shall log critical processing steps with campaignId, batchId, recipientRef or safe internal reference and correlationId. |
| FR-018 | System shall not expose direct personal data in logs, queue messages, errors, dashboards or audit records. |
| FR-019 | System shall support operational investigation of failed batches and failed recipients through non-PII identifiers. |
| FR-020 | System shall publish delivery submission events or update records after SMS Router handoff. |

---

## 10. Business Rules

| BR ID | Rule |
|---|---|
| BR-001 | SMS must not be sent unless the recipient has a successfully allocated short link. |
| BR-002 | SMS must not be sent if recipientRef cannot be resolved by the authorized sender boundary. |
| BR-003 | Direct personal data must not be transferred through intermediate campaign processing modules. |
| BR-004 | Recipient references must be sufficient for traceability but not reversible by unauthorized services. |
| BR-005 | CRM must control recipient-level uniqueness to prevent duplicate link allocation and duplicate SMS sending. |
| BR-006 | Partial failures must not block successful recipients from continuing through the pipeline. |
| BR-007 | Reused external / recipient-level identifiers must be treated as duplicate or reconciliation events. |
| BR-008 | Retried processing must not create duplicate SMS submissions for already sent recipients. |
| BR-009 | Final SMS sending must use the current recipient contact state at the time of sending where required by compliance rules. |
| BR-010 | Recipients that become ineligible before final sending must be skipped. |
| BR-011 | Campaign cancellation must stop new downstream processing where technically possible. |
| BR-012 | Campaign status must reflect allocation and sending outcome: Processing, Partially Failed, Sent, Completed, Failed or Cancelled. |
| BR-013 | Operational users may investigate failed records using safe identifiers and correlation IDs. |
| BR-014 | Detailed API error mapping belongs to linked integration Tasks, not to the high-level Story description. |

---

## 11. Acceptance Criteria

### AC-001: Process privacy-safe recipient batch

Given a launched SMS campaign has prepared recipient batches with recipient references,  
When the allocation process starts,  
Then the system processes the batch using recipient references only,  
And no phone numbers, names, emails or direct personal data are included in intermediate processing payloads.

### AC-002: Allocate personalized short links

Given a valid recipient batch and valid campaign link configuration,  
When the system requests short link allocation,  
Then each successful recipient receives a personalized short URL assignment,  
And the assignment is stored against campaignId, batchId and recipientRef.

### AC-003: Do not send SMS without short link

Given short link allocation failed for a recipient,  
When the system prepares SMS sending jobs,  
Then no SMS sending job is created for that recipient,  
And the recipient is marked with an appropriate failure reason.

### AC-004: Continue processing after partial SlimLink failure

Given SlimLink returns successful and failed records in the same batch,  
When the CRM processes the response,  
Then successful recipients continue to SMS sending,  
And failed recipients are marked as failed without blocking the entire batch unless configured threshold is exceeded.

### AC-005: Send SMS using recipient reference

Given a recipient has a successful short link assignment,  
When the SMS sending job is created,  
Then the job contains recipientRef and allowed campaign data,  
And does not contain direct contact data.

### AC-006: Resolve recipient reference only at final sending boundary

Given SMS Sender receives a sending job with recipientRef,  
When SMS Sender prepares the SMS Router request,  
Then it resolves recipientRef through the approved Player Data / contact resolution service,  
And submits SMS only if the recipient is still send-eligible.

### AC-007: Prevent duplicate SMS sending on retry

Given a retry is triggered for a previously processed recipient,  
When the system checks processing state,  
Then the system does not submit another SMS if the recipient has already been sent or accepted by SMS Router.

### AC-008: Handle unresolved recipient reference

Given SMS Sender cannot resolve recipientRef,  
When it attempts to prepare SMS for sending,  
Then SMS is not submitted to SMS Router,  
And recipient status is updated with a non-PII failure reason.

### AC-009: Respect campaign cancellation

Given campaign is cancelled during downstream processing,  
When new allocation or sending jobs are about to be created,  
Then system stops creating new jobs where technically possible,  
And already accepted SMS Router submissions are not recalled.

### AC-010: Logging and audit do not expose PII

Given allocation and sending steps are executed,  
When logs, audit records and metrics are created,  
Then they include campaignId, batchId and correlationId,  
And they do not include direct personal data.

---

## 12. Validation Rules

| Field / Object | Rule | Error message |
|---|---|---|
| Campaign | Campaign must be active and eligible for processing. | Campaign is not available for SMS processing. |
| Recipient batch | Batch must contain at least one recipientRef. | Recipient batch is empty. |
| Recipient reference | Must be present and valid according to reference format. | Recipient reference is invalid. |
| Campaign link configuration | Validated before short link allocation. | Campaign link configuration is invalid. |
| Short link assignment | SMS job can be created only when short URL is available. | Short link was not allocated for recipient. |
| Message content | Must support short link insertion or binding. | SMS message cannot be prepared with short link. |
| Sender resolution | recipientRef must be resolvable by SMS Sender. | Recipient reference cannot be resolved. |
| Send eligibility | Recipient must be send-eligible at final send check. | Recipient is not eligible for SMS sending. |
| Processing state | Duplicate send for same campaign recipient is not allowed. | SMS has already been submitted for this recipient. |

---

## 13. Permissions / Access Control

| Role | View | Create | Edit | Delete | Approve | Export |
|---|---:|---:|---:|---:|---:|---:|
| CRM Manager | Yes | Campaign only | Campaign only | No | Launch if permitted | Aggregated results only |
| Marketing & Retention Manager | Yes | Campaign only | Campaign only | No | Depending on permissions | Aggregated results only |
| Operations User | Yes | No | No | No | No | Limited operational export if permitted |
| Support User | Limited | No | No | No | No | No |
| Backend / System Service | System access | Yes | Yes | No | N/A | N/A |
| Compliance / Audit User | Audit view | No | No | No | No | Audit export if permitted |

### Permission failure behavior

- Unauthorized user cannot trigger reprocessing or view restricted operational details.
- Operational records should expose safe identifiers only unless elevated investigation access is explicitly granted.
- Direct personal data must not be visible in campaign pipeline screens by default.

---

## 14. Logging Requirements

| Event | Trigger | Level | Required fields |
|---|---|---|---|
| `short_link_allocation_started` | Batch sent for link allocation | Info | campaignId, batchId, batchSize, correlationId |
| `short_link_allocation_completed` | Batch allocation completed | Info | campaignId, batchId, successCount, failedCount, correlationId |
| `short_link_allocation_failed` | Batch-level allocation failure | Error / Warning | campaignId, batchId, errorCategory, retryable, correlationId |
| `sms_job_created` | SMS sending job created | Info | campaignId, batchId, recipientRef or safe messageRef, correlationId |
| `sms_job_skipped` | SMS job not created or not sent | Warning | campaignId, batchId, reasonCode, correlationId |
| `recipient_ref_resolution_failed` | Sender cannot resolve recipientRef | Warning / Error | campaignId, safe messageRef, reasonCode, correlationId |
| `sms_submitted_to_router` | SMS sent to SMS Router | Info | campaignId, safe messageRef, routerMessageRef, correlationId |
| `duplicate_send_prevented` | Duplicate processing detected | Warning | campaignId, safe messageRef, previousStatus, correlationId |

Required common fields:

- `campaignId`
- `batchId`, where applicable
- `safeRecipientRef` / `messageRef`, where applicable
- `action`
- `timestamp`
- `requestId` / `correlationId`
- `result`
- `errorCode` / `errorCategory` if failed

Direct personal data must not be logged.

---

## 15. Audit Requirements

- **Should this action be auditable?** Yes
- **Audit event names:**
  - `SMS_SHORT_LINK_ALLOCATION_STARTED`
  - `SMS_SHORT_LINK_ALLOCATION_COMPLETED`
  - `SMS_SENDING_JOB_CREATED`
  - `SMS_SUBMITTED_TO_ROUTER`
  - `SMS_RECIPIENT_SKIPPED`
  - `SMS_DUPLICATE_SEND_PREVENTED`
- **Old/new values required?** Status changes and processing decisions only; no direct personal data.
- **Who can view audit record?** Authorized Operations, Compliance, Audit and selected technical support roles.
- **Retention period:** According to campaign audit and compliance retention policy.

---

## 16. Integration Points

| System | Interaction | Sync / Async | Contract link |
|---|---|---|---|
| Campaign Processing Service | Orchestrates allocation and sending job creation | Internal | Linked architecture / Story |
| SlimLink | Allocates short links for recipient batch | Sync bulk | Linked SlimLink API spec / Task |
| Message Broker / Queue | Carries downstream allocation / sending events | Async | Linked event contract |
| SMS Sender | Resolves recipientRef and prepares final SMS submission | Async / Internal | Linked Sender contract |
| Player Data Service | Resolves recipientRef at trusted boundary | Sync / Internal | Linked data access contract |
| SMS Router | Accepts final SMS payload for delivery | Sync / Async | Linked SMS Router contract |
| Monitoring / Logging | Receives processing metrics and logs | Async | Linked observability spec |

---

## 17. API / Event Details

Detailed API fields and request/response payloads are not duplicated in this Story. They must be maintained in linked integration Tasks / API specifications.

### Conceptual events / actions

- `short_link_allocation_requested`
- `short_link_allocation_completed`
- `short_link_allocation_failed`
- `sms_sending_job_created`
- `sms_sending_job_skipped`
- `sms_submitted_to_router`
- `sms_submission_failed`

### Idempotency

- Allocation and sending must be idempotent from CRM pipeline perspective.
- Repeated processing for the same campaign recipient must not result in duplicate SMS sending.
- Existing successful link assignment should be reused or reconciled according to agreed implementation rules.
- Already submitted SMS Router message must not be submitted again during retry.

### Retry behavior

- Retryable integration failures are retried with configured backoff.
- Non-retryable validation or recipient-resolution failures are marked failed.
- Retry policy must respect external service limits and campaign cancellation state.

---

## 18. Data Requirements

| Field / Object | Type | Required | Source | Notes |
|---|---|---:|---|---|
| campaignId | Identifier | Yes | CRM Campaign | Used for traceability. |
| batchId | Identifier | Yes | Campaign Processing | Used for batch-level processing. |
| recipientRef | Opaque reference / hash | Yes | Player Data Service | No direct personal data. |
| shortLinkId | Identifier | Yes for successful allocation | SlimLink | Stored for reconciliation. |
| shortUrl | URL | Yes for SMS sending | SlimLink | Inserted / bound into SMS content. |
| messageRef | Identifier | Yes | SMS Sender / CRM | Safe internal message reference. |
| allocationStatus | Enum | Yes | Campaign Processing | Success / Failed / Retry Pending. |
| sendStatus | Enum | Yes | SMS Sender / SMS Router | Prepared / Submitted / Failed / Skipped. |
| reasonCode | Enum / String | Conditional | Processing Services | Must not expose PII. |
| correlationId | Identifier | Yes | System | Used across logs and tracing. |

---

## 19. UI / UX

This Story is mostly backend / system processing.

UI impact is limited to status visibility where already supported by Campaign Management:

- campaign status may move to `Processing`, `Partially Failed`, `Sent`, `Completed`, `Failed` or `Cancelled`;
- CRM Manager may see aggregated counts: prepared, short link allocated, sent, failed, skipped;
- Operations may see batch-level processing details and correlation IDs;
- direct personal data must not be displayed in operational views by default.

Detailed delivery reporting is covered by a separate / follow-up Story.

---

## 20. Notifications / Communication

| Trigger | Channel | Recipient | Purpose |
|---|---|---|---|
| Batch allocation fails above threshold | Monitoring / Alert | Operations | Investigate SlimLink or pipeline issue. |
| SMS sending failures exceed threshold | Monitoring / Alert | Operations | Investigate Sender / SMS Router issue. |
| Campaign becomes Partially Failed | CRM UI / Internal notification if supported | CRM Manager / Operations | Inform that only part of campaign was processed. |
| Campaign is cancelled during processing | CRM UI / Audit | CRM Manager / Operations | Confirm cancellation impact. |

No player-facing notification is generated by this Story except the SMS itself.

---

## 21. Non-Functional Requirements

| Category | Requirement |
|---|---|
| Performance | System must process short link allocation and SMS job creation in batches without blocking CRM UI. |
| Scalability | Batch processing must support large campaigns and respect downstream service limits. |
| Reliability | Retry and duplicate-prevention logic must avoid duplicate SMS sending. |
| Security | Personal data must be resolved only by authorized final sending boundary. |
| Compliance | Pipeline must follow data minimization and SMS consent principles. |
| Availability | Temporary SlimLink, Sender or SMS Router issues must not corrupt campaign state. |
| Observability | Logs and metrics must support troubleshooting through safe identifiers and correlation IDs. |
| Data retention | Processing records, assignments and delivery references must follow campaign retention policy. |
| Backward compatibility | Changes must not break existing Email campaign/template flows. |

---

## 22. Analytics

- **Business event:** `sms_campaign_recipient_ready_to_send`
- **Business event:** `sms_message_submitted`
- **Business event:** `sms_message_skipped`
- **Business event:** `short_link_allocation_failed`
- **Properties:** campaignId, tenantId, batchId, status, reasonCategory, channel, market, templateId, correlationId
- **Funnel / metric affected:** SMS campaign reach, processed recipients, failed recipients, delivery funnel, campaign completion rate
- **Dashboard / report impact:** Aggregated metrics can support future delivery status dashboard and operations monitoring.

---

## 23. Dependencies

| Dependency | Type | Owner | Status |
|---|---|---|---|
| Prepared recipient batches with recipientRef | Upstream Story | CRM / Player Data | Required |
| Campaign URL / domain validation | Upstream Story / Task | CRM | Required |
| SlimLink integration contract | Integration | SlimLink / Backend | Required |
| SlimLink access and service limits | Integration / Security | SlimLink / DevOps | Required |
| SMS Sender recipientRef resolution contract | Internal Integration | SMS Sender / Player Data | Required |
| SMS Router delivery contract | Internal Integration | SMS Router Team | Required |
| Message broker event contracts | Technical | Platform / Backend | Required |
| Error handling matrix | Analysis / Task | BSA / Backend / QA | Required |
| Monitoring dashboard | Operations | DevOps / Operations | Required for production readiness |

---

## 24. Test Notes / QA Focus

### Positive scenarios

- Successful short link allocation for all recipients in batch.
- Successful SMS job creation using recipientRef.
- Successful recipientRef resolution by SMS Sender.
- Successful SMS Router submission.
- Campaign / batch status updates correctly.

### Negative scenarios

- SlimLink partial failure.
- SlimLink unavailable or rate-limited.
- Invalid or expired recipientRef.
- RecipientRef cannot be resolved.
- Recipient loses SMS consent before final sending.
- Duplicate retry attempts.
- Campaign cancelled during processing.
- Missing short link placeholder.

### Regression areas

- Existing Email campaign flow.
- Existing template management.
- Existing SMS Router integration, if already used elsewhere.
- Logging / audit / monitoring behavior.
- Access control for operational views.

### Test data

- Campaign with valid audience and SMS consent.
- Batch with mixed valid and invalid recipient references.
- Batch with duplicate recipient references.
- Batch with partial SlimLink failures.
- Recipient with withdrawn consent before final sending.
- Campaign cancelled during batch processing.

### Environments

- Integration / staging environment with SlimLink test access.
- SMS Sender / SMS Router test environment or mock.
- Player Data Service test dataset with safe generated recipient references.

---

## 25. Open Questions

| Question | Owner | Due date | Status |
|---|---|---|---|
| Should existing successful short link assignment be reused on retry or should retry be blocked and manually reconciled? | BSA / Backend / Architect | TBD | Open |
| What is the final TTL / lifecycle for recipientRef during campaign processing? | Player Data / Security | TBD | Open |
| Which component owns final recipient eligibility re-check before SMS Router submission? | SMS Sender / Player Data / Compliance | TBD | Open |
| What threshold moves batch or campaign to Partially Failed? | Product Owner / Operations | TBD | Open |
| Which error categories are visible to CRM Manager versus Operations? | Product Owner / Compliance | TBD | Open |
| Is delivery status processing part of MVP or a separate follow-up Story? | Product Owner | TBD | Open |

---

## 26. Out of Scope

- Detailed SlimLink API payload fields and examples.
- Full SlimLink admin panel setup.
- Detailed SMS Router payload mapping.
- Full delivery status dashboard.
- Click analytics reporting.
- Manual failed recipient reprocessing UI.
- New SMS provider onboarding.
- Email / Push / Telegram campaign delivery.
- Rich SMS / MMS support.

---

## 27. Links

- Epic: `SMS_01_Epic.md`
- Related Story: `SMS_02_Story_Configure_And_Launch_Campaign.md`
- Related Story: `SMS_03_Story_Prepare_Privacy_Safe_Recipient_Batches.md`
- Confluence requirement: TBD
- SlimLink API spec: linked integration specification / Task
- SMS Sender contract: TBD
- SMS Router contract: TBD
- Data model: TBD
- Access matrix: TBD
- Test cases: TBD
- Related issues: TBD

---

## 28. Story Definition of Ready

- [ ] User role and value are clear.
- [ ] Scope is clear.
- [ ] Upstream recipient batch preparation is completed or defined.
- [ ] Main flow is described.
- [ ] Alternative flows / edge cases are described.
- [ ] Acceptance Criteria are testable.
- [ ] Business rules are documented or linked.
- [ ] Functional requirements are documented or linked.
- [ ] Permissions are defined.
- [ ] Logging / audit requirements are defined.
- [ ] NFRs are defined.
- [ ] Integration boundaries are clear.
- [ ] Detailed SlimLink and SMS Router specs are linked, not duplicated.
- [ ] Dependencies are known.
- [ ] QA understands how to test.
- [ ] Story is estimated.
- [ ] Story is small enough for one sprint or split into implementation Tasks if needed.

---

## 29. Story Definition of Done

- [ ] Prepared recipient batches can be processed using recipientRef.
- [ ] Short links are allocated for eligible recipients through SlimLink integration.
- [ ] Successful short link assignments are stored and linked to safe recipient references.
- [ ] Failed short link allocation records are handled without blocking successful recipients.
- [ ] SMS jobs are created only for recipients with successfully allocated short links.
- [ ] SMS jobs do not contain direct personal data.
- [ ] SMS Sender resolves recipientRef only at the approved final sending boundary.
- [ ] Final send-readiness / eligibility check is applied where required.
- [ ] SMS messages are submitted to SMS Router without duplicate submissions during retry.
- [ ] Campaign, batch and recipient statuses are updated correctly.
- [ ] Logging, audit and monitoring requirements are implemented without PII exposure.
- [ ] QA testing and regression testing are completed.
- [ ] Documentation / linked Tasks are updated if required.
- [ ] PO / BSA accepted the Story.
