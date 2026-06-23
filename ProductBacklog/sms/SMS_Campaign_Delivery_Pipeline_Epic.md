# Epic: SMS Campaign Delivery Pipeline with Personalized Short Links

## 1. Summary

Implement an end-to-end SMS campaign delivery pipeline that allows CRM / Marketing & Retention users to launch SMS campaigns with personalized short links, process eligible recipients in batches, send messages through the approved SMS Router, and track delivery and click performance.

---

## 2. Business Goal / Problem

CRM / Marketing & Retention teams need a scalable and controlled way to launch personalized SMS campaigns for player engagement, reactivation, and promotional communication.

Current or existing campaign flow has several limitations:

- campaign preparation requires coordination between multiple systems and teams;
- personalized short links are needed for recipient-level tracking;
- external services have rate limits and operational constraints;
- campaign URLs must be validated before sending;
- delivery and click results should be visible for campaign performance analysis;
- the system must prevent duplicate SMS sending and support error handling for partial failures.

The Epic is needed to create a reliable, scalable and auditable SMS campaign delivery capability.

---

## 3. Product Outcome

After this Epic is delivered:

- CRM Manager can configure and launch SMS campaigns with a campaign long URL.
- System can prepare personalized short links for eligible recipients.
- System can process large recipient lists in batches without overloading downstream services.
- SMS messages are sent through the approved SMS Router.
- CRM Manager can view delivery status and short link click statistics.
- Operations / Support can investigate failed batches, retries and integration errors.

---

## 4. Business Value

| Value Area | Description |
|---|---|
| Campaign efficiency | CRM team can launch personalized SMS campaigns faster and with less manual coordination. |
| Player engagement | Personalized short links allow campaigns to drive players to targeted promotional or reactivation pages. |
| Performance tracking | Delivery and click statistics help evaluate campaign effectiveness. |
| Operational reliability | Batching, retry logic and idempotency reduce failed or duplicated SMS sends. |
| Compliance and control | URL validation, audit trail and GDPR-aware data handling reduce regulatory and reputational risks. |

---

## 5. Success Metrics / KPI

| Metric | Current Value | Target Value | Measurement Source |
|---|---:|---:|---|
| Campaign launch time | Manual / not standardized | Reduced and standardized launch flow | CRM campaign logs |
| SMS processing throughput | Not guaranteed | Supports large campaigns through batch processing | Pipeline metrics |
| Short link preparation success rate | N/A | ≥ 99% for valid campaigns | Slimlink integration logs |
| Duplicate SMS sends | Risk exists | 0 duplicates caused by retry/reprocessing | SMS pipeline logs |
| Delivery status coverage | Partial / not centralized | Status available per campaign | SMS Router callbacks / delivery events |
| Click tracking coverage | Not available / limited | Click stats available per campaign and recipient where supported | Slimlink analytics callback |

---

## 6. Stakeholders and Owners

| Role | Responsibility |
|---|---|
| Business Owner / CRM Lead | Defines campaign business goals and expected outcomes. |
| Product Owner | Owns product scope, priorities and release decisions. |
| Lead BSA / BSA | Drives discovery, requirements, process decomposition, Jira structure, acceptance criteria and cross-team alignment. |
| Tech Lead / Architect | Owns technical solution, integration approach and scalability decisions. |
| Backend Team | Implements campaign processing, batching, Slimlink integration and SMS Router integration. |
| QA Lead / QA Team | Validates functional flows, edge cases, integration behavior and regression scope. |
| Operations / Support | Monitors campaign pipeline health and investigates incidents. |
| Compliance / Legal | Validates GDPR, consent and communication-related constraints. |

---

## 7. Users / Roles Affected

| Role | Impact |
|---|---|
| CRM Manager | Configures and launches SMS campaigns, monitors campaign results. |
| Marketing & Retention Manager | Uses SMS campaigns for engagement, reactivation and promotions. |
| Operations User | Monitors pipeline health, errors, retries and failed batches. |
| Support User | Investigates player-level message delivery issues where access is allowed. |
| System Actor: CRM System | Prepares campaign data and initiates pipeline processing. |
| System Actor: Slimlink | Provides personalized short links and click tracking data. |
| System Actor: SMS Router | Sends SMS messages and returns delivery statuses. |

---

## 8. Scope

### In Scope

- SMS campaign launch flow from CRM.
- Campaign long URL input and validation.
- Allowed domain / URL whitelist check before campaign processing.
- Eligible player batch preparation.
- Personalized short link assignment via Slimlink.
- Batch processing with retry and idempotency rules.
- SMS message preparation and submission to SMS Router.
- Delivery status processing.
- Short link click statistics processing.
- Campaign-level delivery and click statistics.
- Logging, monitoring and audit events for critical pipeline steps.
- Error handling for retryable and non-retryable failures.

### Out of Scope

- Email campaign delivery.
- Push notification campaign delivery.
- Telegram campaign delivery.
- Full marketing segmentation engine redesign.
- Manual SMS sending outside campaign flow.
- New external SMS provider onboarding.
- Advanced A/B testing.
- Advanced attribution model.
- Full BI dashboard replacement.

---

## 9. High-Level Functional Requirements

| FR ID | Requirement |
|---|---|
| FR-001 | System shall allow CRM Manager to configure an SMS campaign with message text and campaign long URL. |
| FR-002 | System shall validate the campaign long URL against allowed domains before campaign launch. |
| FR-003 | System shall identify eligible campaign recipients based on selected campaign audience. |
| FR-004 | System shall process campaign recipients in batches. |
| FR-005 | System shall request or assign personalized short links for eligible recipients through Slimlink. |
| FR-006 | System shall bind each short link to campaignId and playerId / external recipient identifier. |
| FR-007 | System shall prepare SMS payloads using approved message template and personalized short link. |
| FR-008 | System shall submit prepared SMS messages to SMS Router. |
| FR-009 | System shall process SMS delivery status updates from SMS Router. |
| FR-010 | System shall process short link click statistics from Slimlink callback or analytics endpoint. |
| FR-011 | System shall prevent duplicate SMS sending during retries or reprocessing. |
| FR-012 | System shall provide campaign-level delivery and click statistics to CRM Manager. |
| FR-013 | System shall log all critical pipeline steps with correlationId / campaignId / batchId. |
| FR-014 | System shall support investigation of failed batches and integration errors by authorized users. |

---

## 10. High-Level Business Rules

| BR ID | Rule |
|---|---|
| BR-001 | SMS campaign cannot be launched without valid message text, campaign long URL and selected audience. |
| BR-002 | Campaign long URL must belong to an allowed domain / whitelist. |
| BR-003 | Only eligible players with valid SMS consent can be included in SMS campaign processing. |
| BR-004 | Players without valid phone number must be excluded from SMS sending. |
| BR-005 | Each eligible recipient must receive only one SMS per campaign unless explicitly reprocessed by an authorized flow. |
| BR-006 | Retryable errors may be retried according to configured retry policy. |
| BR-007 | Non-retryable errors must not trigger automatic retry. |
| BR-008 | Duplicate callbacks from external systems must be handled idempotently. |
| BR-009 | Campaign status must reflect current processing state: Draft, Scheduled, Processing, Partially Failed, Sent, Completed, Failed, Cancelled. |
| BR-010 | Access to campaign results must follow role-based permissions. |

---

## 11. High-Level NFR

| Category | Requirement |
|---|---|
| Performance | Pipeline should support high-volume campaign processing through batching without blocking CRM UI. |
| Scalability | Batch size and processing rate must be configurable to respect downstream service limits. |
| Availability | Campaign processing should tolerate temporary external service degradation where possible. |
| Reliability | Retry and idempotency must prevent duplicate SMS sending. |
| Security | Sensitive player data must not be exposed in logs, callbacks or UI beyond authorized access. |
| Access Control | Only authorized CRM / Operations users can launch, monitor or investigate campaigns. |
| Compliance | SMS sending must respect GDPR, consent and regional communication rules. |
| Logging / Audit | Campaign launch, URL validation, batch processing, SMS submission and critical failures must be logged/audited. |
| Monitoring | Technical metrics must be available for throughput, failures, retries, queue lag and external service errors. |
| Data Retention | Campaign delivery and click data must follow defined retention policy. |

---

## 12. Impacted Systems / Components

| System / Component | Impact |
|---|---|
| CRM Campaign Management | New / updated campaign configuration and launch flow. |
| Player Info / Player Profile | Source of recipient eligibility, player identifiers, phone numbers and consent flags. |
| Campaign Processing Service | Batch preparation, orchestration, retry and idempotency logic. |
| Message Broker / Queue | Asynchronous processing of recipient batches and SMS preparation. |
| Slimlink | Personalized short link assignment and click tracking. |
| Domain / URL Validation Service | Validation of campaign long URL against allowed domain list. |
| SMS Sender / SMS Router | SMS message delivery and delivery status response processing. |
| Analytics / Reporting | Campaign delivery and click statistics. |
| Audit / Logging / Monitoring | New events, metrics, logs and dashboards. |

---

## 13. Integrations

| System | Interaction | Sync / Async | Notes |
|---|---|---|---|
| CRM → Campaign Processing Service | Launch campaign and submit campaign configuration | Sync | Validates input and creates campaign processing request. |
| Campaign Processing Service → Player Info | Get eligible recipients and required player data | Sync / Async | Depends on existing architecture and audience size. |
| Campaign Processing Service → Domain Service | Validate campaign long URL | Sync | Blocks campaign launch if URL is not allowed. |
| Campaign Processing Service → Slimlink | Request / assign personalized short links | Sync | Must respect batch size and rate limits. |
| Campaign Processing Service → Message Broker | Publish recipient batches for processing | Async | Used for scalability and resilience. |
| Campaign Processing Service → SMS Router | Submit prepared SMS payloads | Sync / Async | Depends on router contract. |
| SMS Router → Campaign Processing Service | Return delivery status updates | Async callback / event | Must be processed idempotently. |
| Slimlink → Campaign Processing Service | Return click statistics | Async callback / analytics pull | Used for campaign performance reporting. |

---

## 14. Data Impact

### New / Changed Data Objects

| Object | Description |
|---|---|
| Campaign | Stores SMS campaign metadata, status and configuration. |
| Campaign Recipient | Stores recipient-level processing status. |
| Campaign Batch | Stores batch-level processing status, retries and errors. |
| Short Link Assignment | Stores mapping between campaignId, playerId / extId and short URL. |
| Delivery Status | Stores SMS delivery status per recipient/message. |
| Click Statistic | Stores short link click events or aggregated click metrics. |
| Audit Event | Stores critical campaign actions and processing events. |

### Reporting / Analytics Impact

- Campaign delivery dashboard should show sent, delivered, failed, pending and partially failed counts.
- Campaign click dashboard should show total clicks, unique clicks and click-through rate where data is available.
- Operations dashboard should show failed batches, retry count, external service errors and processing lag.

---

## 15. UX / UI Impact

| Area | Expected Change |
|---|---|
| Campaign creation form | Add or update SMS campaign long URL field. |
| Campaign validation | Show validation errors for invalid or non-allowed URLs. |
| Campaign status page | Show processing status and delivery summary. |
| Campaign analytics page | Show delivery and click statistics. |
| Error visibility | Show user-friendly campaign failure reason where applicable. |

---

## 16. Dependencies

| Dependency | Type | Owner | Status |
|---|---|---|---|
| Slimlink API contract | External / Integration | Slimlink / Backend | To be confirmed |
| SMS Router delivery contract | Internal / Integration | SMS Router Team | To be confirmed |
| Player eligibility rules | Business / Data | CRM / Player Info | To be confirmed |
| Consent rules by region | Compliance | Compliance / Legal | To be confirmed |
| Allowed domain list | Business / Security | CRM / Security / Domain Service | To be confirmed |
| Message broker capacity | Technical | Platform / Backend | To be confirmed |
| Monitoring dashboard | Technical / Ops | DevOps / Operations | To be confirmed |

---

## 17. Risks

| Risk | Probability | Impact | Mitigation |
|---|---|---|---|
| Slimlink rate limits are exceeded | Medium | High | Configurable batching, throttling and retry policy. |
| Duplicate SMS messages are sent during retry | Medium | High | Idempotency key based on campaignId + playerId / extId. |
| Invalid or non-approved URL is sent to players | Medium | High | Allowed domain validation before campaign processing. |
| SMS Router partial failures are not visible | Medium | Medium | Store delivery status and batch-level errors. |
| External callbacks are duplicated or delayed | High | Medium | Idempotent callback processing and status reconciliation. |
| Large campaign overloads downstream services | Medium | High | Asynchronous batch processing and queue-based throttling. |
| GDPR / consent rules are not applied correctly | Low / Medium | High | Eligibility filtering and compliance review before release. |
| Business expects real-time results, but processing is asynchronous | Medium | Medium | Set clear UI statuses and expectations for pending/processing states. |

---

## 18. Assumptions

- SMS campaign recipients are selected before pipeline processing starts.
- Player Info contains required player identifiers, phone number and consent data.
- Slimlink can provide or assign personalized short links in batch mode.
- SMS Router is the approved system for SMS delivery.
- Delivery status is available from SMS Router.
- Click statistics are available from Slimlink either via callback or analytics endpoint.
- Campaign processing is asynchronous for large recipient lists.
- Final implementation may use the existing message broker or target scalable queue solution depending on architecture decision.

---

## 19. Rollout / Release Strategy

- Release behind feature flag for selected CRM users / markets.
- Start with pilot campaign for limited audience size.
- Validate URL checks, Slimlink integration, SMS Router delivery and reporting.
- Monitor error rate, retry count, queue lag and delivery status coverage.
- Gradually increase audience size after successful pilot.
- Rollback strategy: disable feature flag and stop new campaign launches; already submitted SMS messages cannot be recalled once accepted by SMS Router.

---

## 20. Analytics / Monitoring

### Business Events

| Event | Purpose |
|---|---|
| sms_campaign_created | Track campaign creation. |
| sms_campaign_launched | Track campaign launch. |
| sms_recipient_processed | Track recipient-level processing. |
| sms_sent_to_router | Track SMS submission. |
| sms_delivery_status_updated | Track delivery result. |
| short_link_clicked | Track player engagement. |
| sms_campaign_completed | Track campaign completion. |

### Technical Metrics

| Metric | Purpose |
|---|---|
| Batch processing rate | Monitor throughput. |
| Batch failure rate | Detect processing issues. |
| Slimlink error rate | Monitor external link service reliability. |
| SMS Router error rate | Monitor delivery integration issues. |
| Retry count | Detect instability or downstream failures. |
| Queue lag | Detect backlog and scaling problems. |
| Duplicate callback count | Detect callback/idempotency issues. |

### Alerts

- High Slimlink error rate.
- High SMS Router failure rate.
- Queue lag above threshold.
- Retry count above threshold.
- Campaign stuck in Processing status.
- Callback processing failures.

---

## 21. Linked Documentation

| Document | Location |
|---|---|
| Business Requirements / Product Requirements | Confluence link |
| System / Integration Requirements | Confluence link or linked Jira Stories / Tasks |
| Sequence Diagram | Confluence / diagram link |
| Data Flow Diagram | Confluence / diagram link |
| API Contract: Slimlink | Swagger / Confluence link |
| API Contract: SMS Router | Swagger / Confluence link |
| Error Matrix | Confluence / Story link |
| NFR / Monitoring Requirements | Confluence / Epic / Story links |
| Decision Log | Confluence link |
| Test Cases | Test management tool / Jira link |

---

## 22. Child Issues

| Issue Type | Title | Priority | Scope |
|---|---|---|---|
| Story | CRM Manager can configure and launch SMS campaign with campaign long URL | High | MVP |
| Story | System can validate campaign URL against allowed domain list | High | MVP |
| Story | System can prepare eligible player batches for SMS campaign processing | High | MVP |
| Story | System can assign personalized short links to campaign recipients via Slimlink | High | MVP |
| Story | System can send prepared SMS messages through SMS Router | High | MVP |
| Story | System can handle retryable and non-retryable SMS pipeline errors | High | MVP |
| Story | CRM Manager can view SMS campaign delivery status | Medium | MVP |
| Story | CRM Manager can view short link click statistics | Medium | MVP |
| Story | Operations user can monitor SMS pipeline health | Medium | Post-MVP |
| Story | Authorized user can access SMS campaign audit trail | Medium | Post-MVP |
| Task | Define Slimlink API contract and error matrix | High | MVP |
| Task | Define SMS Router payload and delivery status mapping | High | MVP |
| Task | Configure pipeline monitoring dashboard | Medium | MVP / Post-MVP |
| Spike | Confirm service limits and scaling strategy for high-volume campaigns | High | MVP |

---

## 23. Open Questions

| Question | Owner | Status |
|---|---|---|
| What is the final maximum campaign audience size for MVP? | Product Owner / CRM Lead | Open |
| Should campaign launch be immediate only, or should scheduling be supported in MVP? | Product Owner | Open |
| What exact player eligibility and SMS consent rules apply per region? | Compliance / CRM | Open |
| What is the final Slimlink batch size and rate limit for production? | Slimlink / Backend | Open |
| Does Slimlink return short links synchronously or provide async batch completion? | Slimlink / Backend | Open |
| What SMS Router statuses should be mapped to CRM campaign statuses? | SMS Router Team / BSA | Open |
| What data retention period applies to delivery and click statistics? | Compliance / Data Owner | Open |
| Should failed recipients be manually reprocessed from UI in MVP? | Product Owner / Operations | Open |

---

## 24. Epic Definition of Ready

- Business goal is clear.
- Product outcome is defined.
- In Scope / Out of Scope are agreed.
- Main stakeholders are identified.
- MVP and Post-MVP scope are separated.
- High-level functional requirements are documented.
- High-level NFR are documented.
- Main integrations are identified.
- Key dependencies and risks are documented.
- Child Stories are identified.
- Open questions have owners.
- Epic is linked to relevant Confluence / Jira documentation.

---

## 25. Epic Definition of Done

- MVP child Stories are delivered and accepted.
- CRM Manager can launch SMS campaign with campaign long URL.
- Campaign URL validation works as expected.
- Eligible recipients are processed in batches.
- Personalized short links are assigned to recipients.
- SMS messages are sent through SMS Router.
- Delivery statuses are processed and visible.
- Short link click statistics are processed and visible where supported.
- Retry and idempotency rules prevent duplicate SMS sending.
- Critical logs, audit events and monitoring metrics are implemented.
- QA testing and regression testing are completed.
- UAT / business review is completed.
- Documentation and linked Jira artifacts are updated.
