# Task: Define Integration Error Handling and Status Mapping

## 1. Context

This Task supports the Story **Allocate Personalized Short Links and Send SMS Using Recipient Reference** under the Epic **SMS Campaign Delivery Pipeline with SlimLink Short Links**.

The SMS campaign pipeline depends on several integrations and asynchronous processing steps:

- Campaign Processing Service;
- Player Data Service / recipient reference resolution;
- SlimLink short link allocation;
- Message Broker / Queue;
- SMS Sender;
- SMS Router;
- CRM campaign status and reporting.

Without a clear error handling and status mapping model, the same technical failure may be interpreted differently by Product, Backend, QA, Operations and CRM users. This can lead to duplicated SMS sending, incorrect campaign statuses, unclear operational ownership and poor troubleshooting.

This Task defines a shared integration error model and status mapping approach without going into low-level API payload details. Detailed SlimLink fields, SMS Router payloads and provider-specific response codes should remain in linked API specifications or implementation Tasks.

---

## 2. Objective

Define how integration errors, partial failures, retries and downstream delivery statuses should be classified, handled and reflected in CRM campaign, batch and recipient statuses.

As a result:

- Dev teams have a clear implementation guideline for retryable and non-retryable failures.
- QA can prepare positive, negative and partial-failure test scenarios.
- Operations can understand which failures require investigation and which are automatically retried.
- CRM users see meaningful campaign-level statuses instead of raw technical errors.
- Duplicate SMS sending is prevented during retries and reprocessing.

---

## 3. Task Type

- [ ] Technical implementation
- [x] Analysis
- [x] Spike / Research
- [ ] Configuration
- [ ] Infrastructure / DevOps
- [ ] Data / Migration
- [x] API / Integration
- [x] QA / Test preparation
- [x] Documentation
- [x] Support / Operations
- [ ] Other:

---

## 4. Scope

### In Scope

- Define high-level integration error categories across SlimLink, SMS Sender and SMS Router.
- Define retryable vs non-retryable error classification.
- Define how record-level, batch-level and campaign-level failures should be handled.
- Define recipient, batch and campaign status mappings.
- Define status aggregation rules from recipient level to batch and campaign level.
- Define duplicate-prevention expectations during retry and reprocessing.
- Define operational visibility: logs, metrics, alerts and correlation identifiers.
- Define QA verification scenarios for error handling and status transitions.
- Identify linked implementation Tasks where detailed API codes and provider-specific mappings should be maintained.

### Out of Scope

- Implementation of retry mechanism.
- Implementation of SMS Router integration.
- Implementation of SlimLink API client.
- Detailed request / response payload design.
- Full provider-specific SMS delivery code mapping.
- Full UI design for campaign reporting.
- Full incident management process.
- Manual reprocessing UI.
- Click analytics integration.

---

## 5. Expected Output

- Integration error handling matrix is defined at logical level.
- Retryable and non-retryable categories are agreed.
- Recipient / batch / campaign status model is documented.
- Status aggregation rules are clear for MVP.
- Duplicate-prevention rules are linked to retry and reprocessing behavior.
- Logging, monitoring and alerting requirements are defined.
- QA team has clear verification scenarios.
- Follow-up implementation Tasks are identified where needed.

---

## 6. Technical Details

| Area | Details |
|---|---|
| Component / Service | Campaign Processing Service, SlimLink Integration Service, SMS Sender, SMS Router integration, Message Broker / Queue, CRM Reporting |
| Repository | CRM backend, integration service, SMS sender repository names TBD |
| Environment | Dev / QA / Staging / Production |
| Config changes | Retry policy, retry limit, backoff strategy, status mapping config if externalized, alert thresholds |
| DB changes | May require fields for recipient status, batch status, campaign status, error category, retry count, last error, correlationId |
| API changes | No new API contract is defined by this Task; detailed API changes belong to linked implementation Tasks |
| Event changes | Processing events should include safe status and error category, not raw provider errors or PII |
| Feature flag | Implementation should follow SMS campaign feature flag strategy where applicable |
| Monitoring | Metrics for integration errors, retries, partial failures, stuck statuses, duplicate-prevention events and status update lag |

---

## 7. Implementation Notes

### Recommended approach

Use a **normalized internal error and status model** between CRM and external/internal integration services.

The pipeline should not expose raw technical errors directly to CRM users. Instead, each integration failure should be mapped to:

- normalized error category;
- retry decision;
- recipient / batch / campaign status impact;
- operational action;
- user-facing status or message;
- QA scenario.

### Why this matters

The SMS pipeline contains both synchronous and asynchronous steps. A single campaign may have thousands or millions of recipients, where part of the batch can succeed and part can fail. Therefore, the system must avoid simplistic “all success / all failed” handling.

The target behavior should be:

- process successful recipients independently;
- isolate failed records;
- retry only retryable failures;
- prevent duplicate sends;
- keep campaign state transparent;
- provide enough information for Operations without exposing PII.

### Status levels

Statuses should be managed at three levels:

| Level | Purpose |
|---|---|
| Recipient status | Shows processing outcome for an individual recipient reference. |
| Batch status | Shows processing outcome for a batch of recipient references. |
| Campaign status | Shows aggregated business-facing state of the SMS campaign. |

---

## 8. API / Integration Details

- **System:** Campaign Processing Service ↔ SlimLink ↔ SMS Sender ↔ SMS Router
- **Endpoint / topic / event:** Exact endpoint / topic / event names TBD by implementation team
- **Contract link:** SlimLink API spec, SMS Router contract, Story 04, Confluence integration overview
- **Request / response:** This Task defines normalized logical behavior only; exact payloads belong to linked API / implementation Tasks
- **Error handling:** Raw integration errors must be mapped to normalized error categories
- **Retry:** Retry only temporary / recoverable errors according to configured retry policy
- **Idempotency:** Retry must not duplicate short link allocation records or SMS Router submissions
- **Timeout:** Timeouts should be treated as retryable until retry threshold is reached, unless operation outcome is unknown and requires reconciliation
- **Fallback:** Failed records remain isolated; successful recipients continue processing where safe

---

## 9. Data / DB Details

### Suggested Status Fields

| Entity | Suggested Field | Purpose |
|---|---|---|
| Campaign Recipient | `recipientStatus` | Current recipient-level processing status. |
| Campaign Recipient | `errorCategory` | Normalized failure category where applicable. |
| Campaign Recipient | `retryCount` | Number of retry attempts for the recipient or processing step. |
| Campaign Recipient | `lastErrorAt` | Last failure timestamp. |
| Campaign Recipient | `correlationId` | Traceability across logs and integrations. |
| Campaign Batch | `batchStatus` | Batch-level processing state. |
| Campaign Batch | `failedCount` / `successCount` | Aggregated batch result. |
| Campaign | `campaignStatus` | Business-facing campaign state. |
| Campaign | `statusUpdatedAt` | Last campaign status update. |

### Suggested Recipient Statuses

| Status | Meaning |
|---|---|
| `Prepared` | Recipient reference is ready for downstream processing. |
| `LinkAllocationPending` | Short link allocation is waiting / in progress. |
| `LinkAllocated` | Short link was successfully assigned. |
| `LinkAllocationFailed` | Short link could not be assigned. |
| `SendJobCreated` | SMS sending job was created. |
| `RecipientResolutionFailed` | Sender could not resolve recipient reference. |
| `SubmittedToRouter` | SMS was submitted to SMS Router. |
| `Delivered` | Delivery confirmation received. |
| `DeliveryFailed` | SMS delivery failed. |
| `Skipped` | Recipient was intentionally excluded from sending. |
| `DuplicatePrevented` | Processing was skipped to avoid duplicate send. |

### Suggested Batch Statuses

| Status | Meaning |
|---|---|
| `Pending` | Batch is created but not yet processed. |
| `Processing` | Batch processing is in progress. |
| `PendingRetry` | Batch is waiting for retry after temporary failure. |
| `PartiallyFailed` | Some records failed while others succeeded. |
| `Completed` | Batch processing completed successfully. |
| `Failed` | Batch failed and cannot continue automatically. |
| `Cancelled` | Batch stopped due to campaign cancellation. |

### Suggested Campaign Statuses

| Status | Meaning |
|---|---|
| `Draft` | Campaign is configured but not launched. |
| `Processing` | Campaign is being prepared / processed. |
| `PartiallyFailed` | Campaign has failed recipients or failed batches but also successful records. |
| `Sent` | Campaign messages were submitted to SMS Router. |
| `Completed` | Campaign reached final state based on delivery / processing rules. |
| `Failed` | Campaign cannot continue due to blocking failure. |
| `Cancelled` | Campaign was cancelled. |

---

## 10. Access / Credentials

- **Required access:** Access to SlimLink API specification, SMS Router status contract, CRM campaign status model and operations monitoring requirements.
- **Secrets / credentials:** Not required for this analysis Task.
- **Environment variables:** Not required for this analysis Task.
- **Who provides access:** Backend Lead, SMS Router owner, SlimLink integration owner, Product Owner, Operations.
- **Security notes:** Error messages, logs and dashboards must not expose phone numbers, names, emails, raw player profile data or sensitive provider payloads.

---

## 11. Logging / Monitoring

### Logs to Add / Update

| Log Event | Trigger | Required Fields |
|---|---|---|
| `short_link_allocation_failed` | SlimLink record or batch failure | campaignId, batchId, recipientRef if record-level, errorCategory, retryable, correlationId |
| `sms_send_job_failed` | SMS job creation or sender handoff failure | campaignId, batchId, recipientRef, errorCategory, correlationId |
| `recipient_resolution_failed` | SMS Sender cannot resolve recipientRef | campaignId, recipientRef, errorCategory, correlationId |
| `sms_router_submission_failed` | SMS Router submission failed | campaignId, recipientRef, routerErrorCategory, retryable, correlationId |
| `duplicate_sms_prevented` | Retry / reprocessing detects already processed recipient | campaignId, recipientRef, previousStatus, correlationId |
| `campaign_status_updated` | Campaign status changes | campaignId, oldStatus, newStatus, reason, correlationId |

### Metrics

- SlimLink request failure rate.
- SlimLink record-level failure count.
- Rate limit / throttling count.
- SMS Sender resolution failure rate.
- SMS Router submission failure rate.
- Retry count by error category.
- Duplicate-prevention count.
- Campaigns stuck in Processing / PendingRetry.
- Status update lag.

### Alerts

- High SlimLink failure rate.
- High SMS Router submission failure rate.
- High recipient resolution failure rate.
- Retry threshold exceeded.
- Campaign stuck in Processing longer than threshold.
- Unexpected growth in duplicate-prevention events.

### Dashboard

Operations dashboard should allow investigation by:

- campaignId;
- batchId;
- safe recipient reference;
- error category;
- retry status;
- current campaign / batch / recipient status;
- correlationId.

---

## 12. Security / Compliance

| Area | Requirement |
|---|---|
| Permission checks | Only authorized users should see operational failure details. |
| Sensitive data | Raw PII must not be shown in error logs, dashboards or status events. |
| PII impact | Error handling must use recipientRef and non-PII metadata only. |
| Encryption / masking | Any provider-specific sensitive payloads must be masked or omitted from logs. |
| Compliance notes | Status and error visibility must follow data minimization and least-privilege principles. |

---

## 13. Completion Criteria / Acceptance Criteria

### AC-001: Normalized error categories are defined

**Given** the SMS campaign pipeline has multiple integration points,  
**When** SlimLink, SMS Sender or SMS Router returns an error,  
**Then** the error can be mapped to a normalized internal error category.

### AC-002: Retryable and non-retryable failures are separated

**Given** an integration failure occurs,  
**When** the system evaluates the failure,  
**Then** the failure is classified as retryable, non-retryable, duplicate / reconciliation, or requires manual investigation.

### AC-003: Partial failures do not block successful recipients

**Given** a batch contains both successful and failed records,  
**When** the batch result is processed,  
**Then** successful recipients continue through the pipeline,  
**And** failed recipients are isolated with error category and status.

### AC-004: Status mapping is defined at recipient, batch and campaign level

**Given** recipient-level processing results are available,  
**When** batch and campaign statuses are updated,  
**Then** statuses are aggregated according to documented mapping rules.

### AC-005: Duplicate SMS sending is prevented during retries

**Given** retry or reprocessing is triggered,  
**When** a recipient already has a final sent / submitted state,  
**Then** SMS is not submitted again,  
**And** duplicate-prevention event is logged.

### AC-006: Operations can investigate failures without PII

**Given** an integration failure occurs,  
**When** Operations investigates the issue,  
**Then** they can use campaignId, batchId, recipientRef, error category and correlationId,  
**And** no direct personal data is required.

### AC-007: QA scenarios are available

**Given** the error handling model is defined,  
**When** QA prepares test cases,  
**Then** positive, negative, retry, partial failure and duplicate-prevention scenarios are covered.

---

## 14. Dependencies

| Dependency | Owner | Status |
|---|---|---|
| SlimLink API specification and error behavior | SlimLink / Backend | Available / to be confirmed for final mapping |
| SMS Router status contract | SMS Router Team | Open |
| Campaign / recipient status model | CRM Backend / Product | To be confirmed |
| Retry and throttling implementation strategy | Backend / Architect | Open |
| Operations monitoring requirements | Operations / DevOps | Open |
| Privacy-safe recipient reference contract | Player Data / SMS Sender | In progress / linked Task |

---

## 15. Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Raw provider errors are exposed to CRM users | Confusing UI and potential sensitive-data leakage | Normalize errors and mask raw details. |
| Retry policy is too broad | Duplicate SMS or unnecessary external load | Separate retryable and non-retryable categories. |
| Retry policy is too strict | Recoverable recipients fail unnecessarily | Allow controlled retry with thresholds and alerts. |
| Partial failures are treated as full campaign failure | Successful recipients may be blocked | Process record-level outcomes independently. |
| Status aggregation is unclear | CRM users see incorrect campaign status | Define recipient → batch → campaign mapping. |
| SMS Router statuses are not aligned with CRM statuses | Reporting becomes misleading | Create provider-to-CRM mapping with SMS Router owner. |
| Unknown operation outcome after timeout | Risk of duplicate action on retry | Use reconciliation / state check before repeated send. |
| Logs contain PII or raw payloads | Compliance and security risk | Enforce safe logging and masking rules. |

---

## 16. Test / Verification Plan

### How to Verify

- Review the error matrix with Backend, QA, Operations and Product.
- Validate that each relevant integration failure maps to an error category and status impact.
- Validate retry decision for each error category.
- Validate campaign status aggregation with sample batches.
- Validate duplicate-prevention scenarios.
- Validate that logs and monitoring data do not expose PII.

### Test Data

- Campaign with all recipients successful.
- Campaign with SlimLink partial failures.
- Campaign with SlimLink temporary failure / rate limit.
- Campaign with recipient reference resolution failure.
- Campaign with SMS Router rejection.
- Campaign with delayed delivery status.
- Campaign retry after unknown timeout.
- Campaign with duplicate recipient / duplicate reprocessing attempt.

### Environments

- Dev for contract review and early integration tests.
- QA for negative and regression scenarios.
- Staging for end-to-end integration validation.

### Regression Areas

- Existing email campaign flow must not be affected.
- Existing campaign status model must remain backward compatible where required.
- Existing reporting dashboards must not show incorrect status after SMS changes.
- Logging and monitoring changes must not expose PII.

### Expected Evidence

- Approved error handling matrix.
- Approved status mapping table.
- QA test cases or checklist.
- Sample logs / metrics showing safe identifiers.
- Updated Confluence / Jira documentation links.

---

## 17. Documentation Impact

- **Confluence page to update:** SMS Campaign Delivery Pipeline integration overview.
- **Swagger / OpenAPI:** Detailed API-level error codes remain in SlimLink / SMS Router API specs.
- **Runbook:** Add operational guidance for failed batches, retry thresholds and stuck campaigns.
- **Release notes:** Mention SMS integration failure handling and campaign status behavior if visible to CRM users.
- **Not required because:** This Task does not define low-level API payloads or provider-specific implementation.

---

## 18. Open Questions

| Question | Owner | Due date | Status |
|---|---|---|---|
| What exact SMS Router statuses must be mapped for MVP? | SMS Router Team / BSA | TBD | Open |
| Should `Sent` mean submitted to Router or accepted by Router? | Product Owner / SMS Router Team | TBD | Open |
| What threshold turns campaign status into `PartiallyFailed` vs `Failed`? | Product Owner / Operations | TBD | Open |
| Should retry thresholds differ for SlimLink, Sender and SMS Router failures? | Backend / Architect | TBD | Open |
| Which failure details are visible to CRM Manager vs Operations? | Product Owner / Compliance | TBD | Open |
| How should unknown outcome after timeout be reconciled? | Backend / Architect | TBD | Open |
| What is the target SLA for delivery status synchronization? | Product Owner / Operations | TBD | Open |

---

## 19. Links

- **Parent Epic:** SMS_01_Epic.md
- **Related Story:** SMS_04_Story_Allocate_Short_Links_And_Send_SMS_Using_Recipient_Reference.md
- **Related Task:** SMS_T02_Task_Define_Privacy_Safe_Recipient_Batch_Contract.md
- **Confluence:** SMS Campaign Delivery Pipeline integration overview — TBD
- **API spec:** SlimLink API specification / SMS Router contract — TBD
- **Pull request:** N/A for analysis Task
- **Test cases:** QA test suite / checklist — TBD

---

## 20. Task Definition of Ready

- [ ] Objective is clear.
- [ ] Context is clear.
- [ ] Expected output is defined.
- [ ] Technical scope is clear.
- [ ] Completion criteria are defined.
- [ ] Required access / contracts are known or requested.
- [ ] Dependencies are identified.
- [ ] Related Story and Epic are linked.
- [ ] Task is estimated or timeboxed.

---

## 21. Task Definition of Done

- [ ] Normalized error categories are documented.
- [ ] Retryable / non-retryable classification is documented.
- [ ] Recipient, batch and campaign status mapping is documented.
- [ ] Partial failure behavior is defined.
- [ ] Duplicate-prevention expectations are defined.
- [ ] Logging and monitoring requirements are defined.
- [ ] QA verification scenarios are documented.
- [ ] Open questions and follow-up implementation Tasks are created where needed.
- [ ] Related Story / Epic documentation is updated.
- [ ] Required review with Backend, QA, Product and Operations is completed.

---

## Interview Note

This Task is useful to present as a senior BSA / System Analyst example because it shows that requirements were not limited to the happy path. The task translates real production risks — partial failures, retries, rate limits, unknown outcomes, delayed delivery statuses and duplicate SMS prevention — into a structured error model, status mapping and testable acceptance criteria.
