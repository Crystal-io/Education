# Epic: SMS Campaign Delivery Pipeline with SlimLink Short Links

## 1. Summary

Implement an end-to-end SMS campaign delivery pipeline that allows CRM / Marketing & Retention users to launch SMS campaigns with personalized short links, process eligible recipients in controlled batches, send prepared messages through the approved SMS Router, and track delivery and click performance.

The Epic covers the business capability and delivery scope. Detailed API fields, request/response payloads, validation reason codes, and exact mapping rules are intentionally kept outside the Epic and should be maintained in linked Stories, Tasks, or the SlimLink API specification.

---

## 2. Business Goal / Problem

CRM / Marketing & Retention teams need a scalable and controlled way to launch personalized SMS campaigns for player engagement, reactivation, and promotional communication.

The current / target process requires coordination across several systems and teams:

- CRM / Marketing & Retention;
- Player Info / Player Profile;
- SlimLink;
- SMS Sender / SMS Router;
- Operations, Support, Compliance and technical platform teams.

The core business problem is not only sending SMS messages, but creating a reliable campaign delivery pipeline that can process large recipient lists, allocate personalized short links, respect external service constraints, avoid duplicate sends, and provide measurable campaign results.

---

## 3. Product Outcome

After this Epic is delivered:

- CRM Manager can configure and launch an SMS campaign with message content, selected audience and campaign long URL.
- System can prepare eligible recipients and allocate personalized short links through SlimLink in controlled batches.
- System can prepare and submit SMS messages with personalized short links to the approved SMS Router.
- CRM users can view campaign delivery results and available click performance data.
- Operations / Support users can monitor campaign processing, failed batches, retries and integration issues.

---

## 4. Source-of-Truth Alignment Notes

The following Epic-level decisions are aligned with the SlimLink integration specification and should replace earlier draft assumptions:

| Area | Epic-Level Position |
|---|---|
| Short link allocation model | SlimLink allocates short-link paths from its hot cache and returns resulting short URLs to CRM. It should not be described as generating each link from scratch during the CRM request. |
| Integration type | CRM uses a synchronous bulk integration with SlimLink during campaign preparation. |
| Batch processing | CRM must split recipients into batches compatible with SlimLink limits. |
| Service limits | CRM must respect SlimLink batch size, rate limits and availability constraints. |
| URL validation ownership | CRM is responsible for validating campaign URL rules before requesting short links, because SlimLink does not validate the long URL. |
| Domain control | Campaign domain configuration must be controlled to avoid sending unauthorized, broken or non-branded links. |
| Idempotency boundary | CRM must manage retry and duplicate-prevention logic; SlimLink should not be treated as a fully idempotent endpoint for reused recipient identifiers. |
| Click analytics | SlimLink stores click analytics; exact CRM consumption mechanism must be confirmed separately. |

---

## 5. Business Value

| Value Area | Description |
|---|---|
| Campaign efficiency | CRM team can launch personalized SMS campaigns faster and with less manual coordination. |
| Player engagement | Personalized short links route players to targeted promotional, reactivation or informational pages. |
| Performance tracking | Delivery and click data help evaluate campaign reach, engagement and effectiveness. |
| Operational reliability | Controlled batching, throttling, retry handling and CRM-side duplicate prevention reduce failed or duplicated SMS sends. |
| Compliance and control | Consent filtering, URL/domain checks, auditability and secure external integration reduce operational and reputational risk. |

---

## 6. Success Metrics / KPI

| Metric | Current Value | Target Value | Measurement Source |
|---|---:|---:|---|
| Campaign launch time | Manual / not standardized | Standardized campaign launch flow | CRM campaign logs |
| Batch processing compliance | Not guaranteed | Campaign recipients are processed within agreed SlimLink limits | CRM integration logs |
| Short link allocation throughput | N/A | Large campaigns can be prepared within agreed performance targets | CRM / SlimLink integration metrics |
| SlimLink API availability | N/A | Meets agreed external service availability target | SlimLink SLA / monitoring |
| Duplicate SMS sends | Risk exists | 0 duplicate sends caused by retry or reprocessing logic | SMS pipeline logs |
| Short link allocation success rate | N/A | High success rate for valid recipient records | SlimLink response / CRM logs |
| Delivery status coverage | Partial / not centralized | Delivery status visible at campaign level | SMS Router callbacks / events |
| Click tracking availability | Not centralized | Click statistics available where SlimLink analytics integration is implemented | SlimLink analytics / reporting |

---

## 7. Stakeholders and Owners

| Role | Responsibility |
|---|---|
| Business Owner / CRM Lead | Defines campaign goals, target audience scenarios and expected business outcomes. |
| Product Owner | Owns MVP scope, priorities, release decision and trade-offs. |
| Lead BSA / BSA | Drives discovery, requirements decomposition, Jira structure, acceptance criteria, integration rules and cross-team alignment. |
| Tech Lead / Architect | Owns technical approach, integration design, scalability and resilience decisions. |
| Backend Team | Implements campaign processing, SlimLink integration, SMS Router integration, retries and monitoring. |
| QA Team | Validates main flows, negative scenarios, partial failures, retry behavior and regression scope. |
| Operations / Support | Monitors campaign pipeline health and investigates processing failures. |
| Compliance / Legal | Validates SMS consent, GDPR, data retention and communication-related restrictions. |

---

## 8. Users / Roles Affected

| Role | Impact |
|---|---|
| CRM Manager | Configures and launches SMS campaigns, monitors delivery and performance results. |
| Marketing & Retention Manager | Uses SMS campaigns to improve player engagement, retention and reactivation. |
| Operations User | Monitors pipeline health, SlimLink issues, failed batches, retries and stuck campaigns. |
| Support User | Investigates campaign delivery issues where access is permitted. |
| System Actor: CRM System | Prepares campaign data, validates business rules, calls SlimLink and initiates SMS delivery pipeline. |
| System Actor: SlimLink | Allocates personalized short links and stores link/click data. |
| System Actor: SMS Router | Sends prepared SMS messages and returns delivery status updates. |

---

## 9. Scope

### 9.1 In Scope

- SMS campaign launch flow from CRM with selected audience and long URL.
- CRM-side URL/domain checks before short link allocation.
- Recipient eligibility preparation based on player data, phone number availability and SMS consent.
- Controlled batch processing for SlimLink short link allocation.
- Handling of full and partial SlimLink failures at campaign / batch / recipient level.
- SMS payload preparation with personalized short URLs.
- SMS submission through the approved SMS Router.
- Delivery status processing and campaign-level reporting.
- Error handling, retries, throttling, logging, audit events and operational monitoring.

### 9.2 Out of Scope

- Email campaign delivery.
- Push notification campaign delivery.
- Telegram campaign delivery.
- Full segmentation engine redesign.
- New SMS provider onboarding.
- Advanced A/B testing and attribution model.
- Full BI platform replacement.
- SlimLink admin panel implementation.
- Detailed SlimLink API schema description inside the Epic.

---

## 10. High-Level Functional Requirements

| FR ID | Requirement |
|---|---|
| FR-001 | System shall allow CRM Manager to configure an SMS campaign with message text, audience and campaign long URL. |
| FR-002 | System shall allow CRM Manager to select or use an approved domain configuration for campaign short links. |
| FR-003 | System shall validate campaign URL/domain rules before requesting short links from SlimLink. |
| FR-004 | System shall prepare eligible recipients based on selected audience, phone number availability and SMS consent. |
| FR-005 | System shall split eligible recipients into SlimLink-compatible batches. |
| FR-006 | System shall allocate personalized short links for eligible recipients through SlimLink. |
| FR-007 | System shall store the relation between campaign recipient and allocated short URL. |
| FR-008 | System shall process successful and failed short link allocation results independently. |
| FR-009 | System shall prepare SMS payloads only for recipients with successfully allocated short links. |
| FR-010 | System shall submit prepared SMS payloads to SMS Router. |
| FR-011 | System shall process SMS delivery status updates. |
| FR-012 | System shall provide CRM Manager with campaign-level delivery status and available click statistics. |
| FR-013 | System shall provide Operations with failed batch visibility, error categories, retry status and correlation identifiers. |
| FR-014 | System shall prevent duplicate SMS sending during retries, reprocessing and partial failure recovery. |

---

## 11. High-Level Business Rules

| BR ID | Rule |
|---|---|
| BR-001 | SMS campaign cannot be launched without valid message text, selected audience and campaign long URL. |
| BR-002 | CRM must validate campaign URL/domain rules before SlimLink short link allocation. |
| BR-003 | Only players with valid phone number and SMS consent can be included in SMS campaign processing. |
| BR-004 | Each eligible player should receive only one SMS per campaign unless an authorized reprocessing flow is used. |
| BR-005 | Each short link allocation request must use a unique recipient-level identifier controlled by CRM. |
| BR-006 | Reused recipient-level identifiers must be treated as reconciliation or configuration issues, not as normal successful retries. |
| BR-007 | Partial failures must not block successful recipients from further processing. |
| BR-008 | Recipients without successfully allocated short links must not receive SMS messages with missing, invalid or placeholder links. |
| BR-009 | Campaign status must reflect processing state: Draft, Scheduled, Processing, Partially Failed, Sent, Completed, Failed, Cancelled. |
| BR-010 | Access to campaign configuration, delivery results and click analytics must follow role-based permissions. |
| BR-011 | Audit trail must capture campaign launch, URL/domain selection, short link allocation, SMS submission and critical failures. |

---

## 12. High-Level Non-Functional Requirements

| Category | Requirement |
|---|---|
| Performance | Campaign processing must support large recipient lists through batching without blocking CRM UI. |
| SlimLink throughput | Integration must be designed around SlimLink high-volume link allocation targets. |
| Rate limiting | CRM must throttle SlimLink calls according to agreed service limits. |
| Availability | CRM must handle temporary SlimLink or SMS Router unavailability without losing campaign state. |
| Reliability | CRM-side retry and duplicate-prevention logic must prevent duplicate SMS sending. |
| Security | SlimLink credentials must be protected and requests must follow agreed access restrictions. |
| Compliance | Recipient eligibility must respect SMS consent, GDPR, regional communication rules and data minimization principles. |
| Observability | Key pipeline steps must be logged with campaign, batch and correlation identifiers. |
| Monitoring | Operational metrics must cover batch processing, SlimLink errors, retries, queue lag and SMS Router failures. |
| Data retention | CRM campaign data, delivery results and click data must follow agreed retention requirements. |
| Backward compatibility | Integration changes should avoid breaking active or scheduled campaign processing. |

---

## 13. Impacted Systems / Components

| System / Component | Impact |
|---|---|
| CRM Campaign Management | New / updated SMS campaign configuration and launch flow. |
| Player Info / Player Profile | Source of player identifiers, phone numbers, consent flags and eligibility attributes. |
| Campaign Processing Service | Recipient preparation, batching, SlimLink orchestration, status tracking and retry control. |
| Message Broker / Queue | Asynchronous recipient batch and message processing; exact technology follows architecture decision. |
| SlimLink | Short link allocation, domain mapping, link storage and click analytics storage. |
| SMS Sender / SMS Router | SMS payload delivery and delivery status response processing. |
| Analytics / Reporting | Delivery metrics, click statistics and campaign performance reporting. |
| Audit / Logging / Monitoring | New audit events, error logs, correlation IDs, dashboards and alerts. |

---

## 14. Integrations

| Integration | Interaction | Sync / Async | Notes |
|---|---|---|---|
| CRM → Campaign Processing Service | Launch campaign and submit campaign configuration | Sync | Validates input and creates campaign processing request. |
| Campaign Processing Service → Player Info | Get eligible recipients and required player data | Sync / Async | Depends on current architecture and audience size. |
| Campaign Processing Service → SlimLink | Bulk short link allocation | Sync | Must respect SlimLink limits, security requirements and error handling rules. |
| Campaign Processing Service → Message Broker | Publish recipient/message processing jobs | Async | Used for scalability and resilience; exact broker is architecture-dependent. |
| Campaign Processing Service → SMS Router | Submit prepared SMS payloads | Sync / Async | Depends on SMS Router contract. |
| SMS Router → Campaign Processing Service | Return delivery status updates | Async callback / event | Must be processed idempotently. |
| SlimLink → CRM Reporting | Provide click analytics | TBD | SlimLink stores analytics; retrieval mechanism must be confirmed. |

---

## 15. Data Impact

### 15.1 New / Changed Data Objects

| Object | Description |
|---|---|
| Campaign | Stores SMS campaign metadata, configuration, selected domain, launch status and owner. |
| Campaign Recipient | Stores recipient-level processing state, player reference, phone availability, consent result and SMS status. |
| Campaign Batch | Stores batch-level processing status, SlimLink batch reference, retries and failures. |
| Short Link Assignment | Stores relation between campaign recipient and allocated short URL. |
| Delivery Status | Stores SMS delivery status per recipient/message. |
| Click Statistic | Stores imported or aggregated SlimLink click data where analytics integration is implemented. |
| Audit Event | Stores critical campaign actions and integration processing events. |

### 15.2 Reporting / Analytics Impact

- Campaign delivery dashboard should show sent, delivered, failed, pending and partially failed counts.
- Campaign click dashboard should show total clicks, unique clicks and click-through rate where data is available.
- Operations dashboard should show failed batches, retry count, external service errors and processing lag.

---

## 16. UX / UI Impact

| Area | Expected Change |
|---|---|
| Campaign creation form | Add or update SMS campaign long URL and approved domain selection. |
| Campaign validation | Show clear validation errors before launch where URL/domain/message/audience is invalid. |
| Campaign status page | Show Processing, Partially Failed, Completed, Failed and Cancelled states. |
| Campaign results page | Show delivery counts and available click statistics. |
| Operations view | Show failed batches, retry status and correlation IDs. |

---

## 17. Dependencies

| Dependency | Type | Owner | Status |
|---|---|---|---|
| SlimLink integration contract | External / Integration | SlimLink / Backend | Defined in source specification; final implementation details should be linked. |
| SlimLink credentials and access setup | Security / Access | SlimLink Admin / CRM Backend | Required before integration test. |
| SlimLink IP whitelist / network access | Security / Network | SlimLink / DevOps | Required if whitelist is configured. |
| SlimLink domain configuration | Business / Integration | CRM / SlimLink Admin | Required before branded link creation. |
| Player eligibility rules | Business / Data | CRM / Player Info | To be confirmed. |
| SMS consent rules by region | Compliance | Compliance / CRM | To be confirmed. |
| SMS Router delivery contract | Internal / Integration | SMS Router Team | To be confirmed. |
| Message broker capacity | Technical | Platform / Backend | To be confirmed. |
| Monitoring dashboard | Technical / Ops | DevOps / Operations | To be configured. |

---

## 18. Risks

| Risk | Probability | Impact | Mitigation |
|---|---|---|---|
| SlimLink service limits are exceeded | Medium | High | Apply configurable batching, throttling and retry policy. |
| Duplicate SMS messages are sent during retry | Medium | High | Use CRM-side duplicate-prevention and send-state checks before SMS Router submission. |
| Recipient-level identifier is reused | Medium | Medium | Generate controlled unique identifiers and handle reuse as reconciliation. |
| Invalid long URL is processed | Medium | Medium | Validate campaign URL in CRM before SlimLink request. |
| Domain is not configured or not approved | Medium | High | Pre-validate domain mapping and block campaign launch if configuration is missing. |
| Mixed success/failure batch result is mishandled | Medium | High | Process record-level outcomes independently and preserve successful recipients. |
| SlimLink unavailable or degraded | Medium | High | Retry with backoff, alert Operations and keep campaign in Processing / Partially Failed state. |
| Access or IP whitelist misconfiguration blocks CRM | Medium | High | Include access verification in deployment checklist. |
| Click analytics retrieval is not defined | Medium | Medium | Clarify analytics integration mechanism before committing click reporting scope. |
| GDPR / consent rules are applied incorrectly | Low / Medium | High | Include compliance review and eligibility tests before release. |

---

## 19. Assumptions

- CRM campaign audience is selected before SlimLink processing starts.
- Player Info provides player identifier, phone number availability and consent data.
- SlimLink company, CRM user, access credentials and domain configuration are created before production use.
- SlimLink allocates short-link paths from hot cache rather than generating all links from scratch during the request.
- CRM controls recipient-level uniqueness and duplicate-prevention logic.
- SMS messages are submitted only after successful short link allocation for the recipient.
- Delivery status is available from SMS Router.
- Click analytics are stored by SlimLink, but CRM retrieval method is still to be clarified.
- Exact message broker technology is an implementation decision and should not be hardcoded in the Epic unless already confirmed.

---

## 20. Rollout / Release Strategy

- Release behind feature flag for selected CRM users / markets.
- Start with pilot campaign using limited audience size.
- Verify SlimLink access, domain configuration, batch processing and SMS Router delivery.
- Validate URL checks, short link allocation, SMS submission and campaign status reporting.
- Monitor SlimLink errors, batch failures, retry count, queue lag and SMS delivery status coverage.
- Gradually increase audience size after successful pilot.
- Rollback strategy: disable new campaign launches; already accepted SMS messages cannot be recalled from SMS Router.

---

## 21. Analytics / Monitoring

### 21.1 Business Events

| Event | Purpose |
|---|---|
| `sms_campaign_created` | Track campaign creation. |
| `sms_campaign_launched` | Track campaign launch. |
| `sms_recipient_batch_created` | Track recipient batch preparation. |
| `short_link_allocation_completed` | Track successful short link allocation. |
| `short_link_allocation_failed` | Track failed short link allocation. |
| `sms_sent_to_router` | Track SMS Router submission. |
| `sms_delivery_status_updated` | Track delivery result. |
| `short_link_clicked` | Track engagement if click data is imported from SlimLink. |
| `sms_campaign_completed` | Track campaign completion. |

### 21.2 Technical Metrics

| Metric | Purpose |
|---|---|
| SlimLink request rate | Ensure CRM does not exceed effective service limits. |
| SlimLink batch size | Ensure batches stay within agreed limits. |
| SlimLink success / failure count | Monitor integration health and data quality. |
| Batch processing rate | Monitor campaign throughput. |
| Batch failure rate | Detect processing issues. |
| Retry count | Detect instability or downstream failures. |
| Queue lag | Detect backlog and scaling problems. |
| SMS Router error rate | Monitor delivery integration issues. |
| Duplicate prevention count | Detect avoided duplicate sends / idempotency protection events. |

### 21.3 Alerts

- High SlimLink error rate.
- SlimLink access errors.
- SlimLink rate limit threshold exceeded.
- High SMS Router failure rate.
- Queue lag above threshold.
- Campaign stuck in Processing status.
- Failed batch count above threshold.
- Unexpected growth of duplicate / reused identifier issues.

---

## 22. Jira / Confluence Documentation Split

| Artifact | Location | Purpose |
|---|---|---|
| Epic | Jira | High-level business capability, scope, impacted systems, risks, NFR and child issue structure. |
| Story | Jira | Business/system value slice with user story, flow, AC, rules, dependencies and QA focus. |
| Task | Jira | Technical, analysis, configuration, integration, DevOps, QA or documentation work item. |
| Sub-task | Jira | Small executable action inside Story/Task, such as creating topic, adding config, updating credentials or adding metric. |
| Stable integration overview | Confluence | Source of truth for diagrams, integration map, decision log and cross-cutting NFR. |
| Detailed API / mapping | Linked Task or Confluence page | Detailed SlimLink payloads, fields, error codes and examples live outside the Epic and are linked where needed. |

---

## 23. Child Issues

### 23.1 MVP Stories

| # | Story | User Story | Purpose | Priority |
|---:|---|---|---|---|
| 1 | Configure and launch SMS campaign | As a CRM Manager, I want to configure and launch an SMS campaign with message text, selected audience and campaign long URL, so that I can run personalized retention campaigns and drive players to the correct promotional or reactivation page. | Main business-value slice. | High |
| 2 | Validate campaign URL and domain configuration | As a CRM Manager, I want the system to validate campaign URL and domain configuration before launch, so that players do not receive broken, unauthorized or non-compliant links. | Prevents bad campaign data before downstream processing. | High |
| 3 | Prepare eligible player batches | As the CRM System, I want to prepare eligible player batches for SMS campaign processing, so that only valid recipients with SMS consent and phone numbers are sent to SlimLink and SMS Router. | Eligibility and data preparation slice. | High |
| 4 | Allocate personalized short links via SlimLink | As the CRM System, I want to allocate personalized short links through SlimLink in controlled batches, so that each eligible recipient receives a unique short URL and campaign engagement can be tracked per recipient. | Core SlimLink integration slice. | High |
| 5 | Process SlimLink failures and partial batch results | As an Operations User, I want the system to capture SlimLink failed records and error categories, so that partial failures can be investigated without blocking successful recipients. | Error handling and operational reliability slice. | High |
| 6 | Send prepared SMS messages through SMS Router | As the CRM System, I want to send prepared SMS messages through the approved SMS Router, so that campaign messages are delivered through the controlled delivery channel with trackable delivery status. | Delivery slice. | High |
| 7 | Prevent duplicate SMS sending | As a CRM Manager, I want the system to prevent duplicate SMS sending during retries or reprocessing, so that players are not spammed and campaign trust is preserved. | Reliability / idempotency slice. | High |
| 8 | View SMS campaign delivery status | As a CRM Manager, I want to view SMS campaign delivery status, so that I can understand campaign reach, identify failed deliveries and decide whether follow-up action is needed. | Business reporting slice. | Medium |
| 9 | View short link click statistics | As a CRM Manager, I want to view short link click statistics, so that I can measure campaign engagement and evaluate campaign effectiveness. | Campaign analytics slice; retrieval mechanism depends on SlimLink analytics integration. | Medium |

### 23.2 Post-MVP Stories

| # | Story | User Story | Purpose | Priority |
|---:|---|---|---|---|
| 10 | Monitor SMS pipeline health | As an Operations User, I want to monitor SMS pipeline health, so that I can detect SlimLink, broker and SMS Router issues before campaigns are significantly affected. | Operational visibility slice. | Medium |
| 11 | Access campaign audit trail | As an Authorized User, I want to access campaign audit trail, so that critical campaign actions and integration events can be reviewed for investigation and compliance. | Audit and compliance slice. | Medium |
| 12 | Reprocess failed recipients | As an Operations User, I want to reprocess failed recipients through a controlled flow, so that recoverable campaign failures can be fixed without resending SMS to successful recipients. | Controlled recovery slice. | Later |

---

## 24. Tasks / Spikes

| Issue Type | Title | Purpose | Priority |
|---|---|---|---|
| Task | Finalize SlimLink integration contract | Confirm implementation-level details and link them from relevant Stories/Tasks. | High |
| Task | Configure SlimLink credentials and access | Prepare secure credential storage, trusted network access and access verification. | High |
| Task | Define CRM recipient-level identifier strategy | Ensure uniqueness, traceability and safe reconciliation without duplicate SMS sending. | High |
| Task | Implement SlimLink throttling and retry policy | Respect agreed service limits and handle temporary failures safely. | High |
| Task | Define SlimLink error handling matrix | Map failures to retry, non-retry, reconciliation and operational actions. | High |
| Task | Define SMS Router delivery status mapping | Align SMS Router statuses with CRM campaign and recipient statuses. | High |
| Task | Configure campaign monitoring dashboard | Add SlimLink, queue, batch and SMS Router metrics. | Medium |
| Spike | Confirm click analytics retrieval from SlimLink | Determine whether CRM receives click data through callback, API pull, export or reporting integration. | High |
| Spike | Confirm message broker strategy | Decide whether current broker is reused or target scalable broker is introduced. | Medium |

---

## 25. Open Questions

| Question | Owner | Status |
|---|---|---|
| What is the final maximum campaign audience size for MVP? | Product Owner / CRM Lead | Open |
| Should campaign launch support scheduling in MVP, or only immediate launch? | Product Owner | Open |
| What exact player eligibility and SMS consent rules apply per region? | Compliance / CRM | Open |
| Should CRM require explicit branded domain configuration, or allow fallback to default SlimLink domain? | Product Owner / Security / CRM | Open |
| Which SlimLink service limits are strict for production and how should throttling be configured? | SlimLink / Backend | Open |
| What is the exact click analytics retrieval mechanism from SlimLink? | SlimLink / Backend / Analytics | Open |
| What SMS Router statuses should be mapped to CRM campaign statuses? | SMS Router Team / BSA | Open |
| What data retention period applies in CRM for delivery and click statistics? | Compliance / Data Owner | Open |
| Should failed recipients be manually reprocessed from UI in MVP? | Product Owner / Operations | Open |

---

## 26. Epic Definition of Ready

- Business goal and product outcome are clear.
- MVP and Post-MVP scope are separated.
- Main stakeholders and impacted systems are identified.
- SlimLink source-of-truth specification is linked and reviewed.
- High-level functional requirements and business rules are documented.
- SlimLink constraints are reflected at Epic level: batch processing, service limits, availability, security and URL validation ownership.
- Main risks, dependencies and open questions have owners.
- Child Stories and key Tasks / Spikes are identified.
- Jira issues are linked to supporting Confluence / API documentation where applicable.

---

## 27. Epic Definition of Done

- MVP child Stories are delivered and accepted.
- CRM Manager can configure and launch SMS campaign with long URL and selected domain.
- CRM validates campaign URL/domain configuration before SlimLink short link allocation.
- Eligible recipients are processed in SlimLink-compatible batches.
- SlimLink short links are allocated for successful recipients and stored in CRM.
- SlimLink partial failures and integration errors are handled according to agreed error matrix.
- Prepared SMS messages are sent through SMS Router only for valid recipients with successful short links.
- Delivery statuses are processed and visible in CRM.
- Click statistics are visible if the SlimLink analytics retrieval mechanism is included in MVP.
- CRM-side duplicate prevention protects players from repeated SMS during retry/reprocessing scenarios.
- Critical logs, audit events, correlation IDs and monitoring metrics are implemented.
- QA, regression testing and UAT/business review are completed.
- Documentation and linked Jira artifacts are updated.

---

## 28. Interview Positioning Summary

This Epic demonstrates how a BSA can structure a technically complex CRM integration within SDLC:

- start from business goal and campaign outcome;
- identify stakeholders, systems, dependencies and constraints;
- align the Epic with the SlimLink source-of-truth specification without overloading Jira with API-level details;
- translate business needs into Epic, Stories, Tasks and acceptance criteria;
- define high-level functional requirements, NFR, risks, rollout, monitoring and operational support;
- keep detailed API payloads, field mappings and error codes in linked Stories/Tasks or Confluence documentation.
