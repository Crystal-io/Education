# Epic: SMS Campaign Delivery Pipeline with SlimLink Short Links

## 1. Summary

Implement an end-to-end SMS campaign delivery pipeline that allows CRM / Marketing & Retention users to launch SMS campaigns with personalized short links, process eligible recipients in controlled batches, send prepared messages through the approved SMS Router, and track delivery and click performance.

The Epic includes CRM campaign launch, recipient eligibility preparation, SlimLink bulk short link allocation, SMS message preparation, SMS Router submission, delivery status processing, click analytics consumption, logging, monitoring, auditability, and operational error handling.

---

## 2. Business Goal / Problem

CRM / Marketing & Retention teams need a scalable and controlled way to launch personalized SMS campaigns for player engagement, reactivation, and promotional communication.

Current or target campaign flow requires coordination across multiple services and teams:

- CRM / Marketing & Retention;
- Player Info / Player Profile;
- SlimLink;
- SMS Sender / SMS Router;
- domain configuration / URL validation ownership;
- Operations / Support / Compliance.

The main business problem is not only sending SMS messages, but preparing a reliable campaign pipeline that can safely process large recipient lists, assign personalized short links, respect SlimLink service limits, avoid duplicate sends, and provide measurable campaign results.

---

## 3. Product Outcome

After this Epic is delivered:

- CRM Manager can configure and launch an SMS campaign with message content, selected audience and campaign long URL.
- System can prepare eligible recipients and request personalized short links from SlimLink in bulk batches.
- SlimLink allocates short link paths from its hot cache and returns short URLs to CRM synchronously via `POST /api/links/bulk`.
- System can prepare and submit SMS messages with personalized short links to the approved SMS Router.
- CRM / Operations users can monitor campaign processing, delivery results, failed records, and available click statistics.

---

## 4. Source-of-Truth Alignment Notes

The following decisions are aligned with the SlimLink integration specification and should replace earlier draft assumptions:

| Area | Updated Project Position |
|---|---|
| Short link creation model | SlimLink does not generate links from scratch during the request. It takes a short-link path from the hot cache, appends it to the selected domain, stores the mapping, and returns the resulting short URL. |
| API interaction | CRM calls SlimLink synchronously using `POST /api/links/bulk`. |
| Batch size | Maximum request batch size is 1000 links. |
| Performance target | SlimLink should support preparation of 100,000 links in no more than 1 minute. Current stated peak is 107,000 links in 80 seconds. |
| Rate limiting | CRM must throttle requests according to SlimLink tariff limits. Current contract mentions `5 RPS` and `120 RPM`; CRM should apply the strictest effective limit unless clarified. |
| Availability | SlimLink API availability target is not lower than 99.9% per month. |
| `external_id` behavior | Reusing an already used `external_id` returns an error. CRM must not rely on SlimLink as an idempotent “same request returns same result” endpoint. |
| Long URL validation | SlimLink does not validate `long_url`. CRM must validate required campaign URL rules before calling SlimLink. |
| Domain validation | SlimLink validates whether the provided domain identifier exists/configured on SlimLink side. CRM should require explicit branded domain selection for campaign safety. |
| Click analytics | SlimLink stores analytical data for up to 3 years. Exact CRM consumption mechanism for click statistics must be confirmed separately. |

---

## 5. Business Value

| Value Area | Description |
|---|---|
| Campaign efficiency | CRM team can launch personalized SMS campaigns faster with less manual coordination between systems and teams. |
| Player engagement | Personalized short links allow campaigns to route players to targeted promotional, reactivation, or informational pages. |
| Performance tracking | Delivery and click data help evaluate campaign reach, engagement and effectiveness. |
| Operational reliability | Controlled batching, throttling, retry handling and CRM-side idempotency reduce failed or duplicated SMS sends. |
| Compliance and control | Consent filtering, URL/domain checks, audit trail and secure SlimLink access reduce operational and reputational risk. |

---

## 6. Success Metrics / KPI

| Metric | Current Value | Target Value | Measurement Source |
|---|---:|---:|---|
| Campaign launch time | Manual / not standardized | Standardized campaign launch flow | CRM campaign logs |
| SlimLink batch size compliance | Not guaranteed | No SlimLink request exceeds 1000 records | CRM integration logs |
| SlimLink throughput capability | N/A | 100,000 links prepared within 1 minute where service limits allow | SlimLink / CRM integration metrics |
| SlimLink API availability | N/A | Not lower than 99.9% monthly | SlimLink SLA / monitoring |
| Duplicate SMS sends | Risk exists | 0 duplicates caused by retry/reprocessing logic | SMS pipeline logs |
| Short link assignment success rate | N/A | ≥ 99% for valid recipient records | SlimLink response logs |
| Delivery status coverage | Partial / not centralized | Delivery status visible per campaign | SMS Router callbacks / events |
| Click tracking availability | Not centralized | Click statistics available where SlimLink analytics integration is implemented | SlimLink analytics / reporting |

---

## 7. Stakeholders and Owners

| Role | Responsibility |
|---|---|
| Business Owner / CRM Lead | Defines campaign goals, audience usage scenarios and expected business outcomes. |
| Product Owner | Owns MVP scope, priorities, release decision and trade-offs. |
| Lead BSA / BSA | Drives discovery, requirements decomposition, Jira structure, acceptance criteria, integration rules and cross-team alignment. |
| Tech Lead / Architect | Owns technical approach, integration design, scalability and resilience decisions. |
| Backend Team | Implements campaign processing, SlimLink integration, SMS Router integration, retry and monitoring logic. |
| QA Team | Validates happy path, negative scenarios, partial failures, retry behavior and regression scope. |
| Operations / Support | Monitors campaign pipeline health and investigates processing failures. |
| Compliance / Legal | Validates SMS consent, GDPR, data retention and communication-related restrictions. |

---

## 8. Users / Roles Affected

| Role | Impact |
|---|---|
| CRM Manager | Configures and launches SMS campaigns, monitors delivery and performance results. |
| Marketing & Retention Manager | Uses SMS campaigns to improve player engagement, retention and reactivation. |
| Operations User | Monitors pipeline health, SlimLink errors, failed batches, retries and stuck campaigns. |
| Support User | Investigates campaign delivery issues where access is permitted. |
| System Actor: CRM System | Prepares campaign data, validates business rules, calls SlimLink, and initiates message delivery pipeline. |
| System Actor: SlimLink | Allocates short link paths from hot cache, stores long-to-short URL mapping, and returns short link results. |
| System Actor: SMS Router | Sends prepared SMS messages and returns delivery status updates. |

---

## 9. Scope

### 9.1 In Scope

- SMS campaign launch flow from CRM with long URL and selected audience.
- CRM-side campaign URL validation and explicit domain selection.
- Recipient eligibility preparation based on player data, phone number availability and SMS consent.
- Bulk request to SlimLink via `POST /api/links/bulk` with up to 1000 records per request.
- Handling of SlimLink success and failed records inside a mixed batch response.
- SMS payload preparation using approved message text and personalized short URL.
- Submission of prepared SMS messages to SMS Router.
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

---

## 10. High-Level Functional Requirements

| FR ID | Requirement |
|---|---|
| FR-001 | System shall allow CRM Manager to configure an SMS campaign with message text, audience and campaign long URL. |
| FR-002 | System shall require explicit domain selection / domain external identifier for branded campaign short links. |
| FR-003 | System shall validate campaign URL rules before sending records to SlimLink, because SlimLink does not validate `long_url`. |
| FR-004 | System shall prepare eligible recipients based on selected audience, phone number availability and SMS consent. |
| FR-005 | System shall split eligible recipients into SlimLink-compatible batches of no more than 1000 records. |
| FR-006 | System shall call SlimLink `POST /api/links/bulk` using Bearer Token authorization. |
| FR-007 | System shall send `external_id`, `long_url`, `domain_external_id`, and optional metadata such as `title`, `expired_at`, and `team` where applicable. |
| FR-008 | System shall store mapping between CRM recipient/campaign identifiers and SlimLink response fields: SlimLink link `id`, `url`, `status`, `reason`, and expiration date. |
| FR-009 | System shall treat record-level SlimLink `status = 1` as successful short link allocation. |
| FR-010 | System shall treat record-level SlimLink `status = 2` as failed short link allocation and store `reason` for investigation. |
| FR-011 | System shall classify SlimLink HTTP errors: `400`, `401`, `403`, `404`, `429`, `500` and apply appropriate handling. |
| FR-012 | System shall prevent duplicate SMS sending during retries, reprocessing and partial batch failures. |
| FR-013 | System shall prepare SMS payloads only for recipients with successfully assigned short links. |
| FR-014 | System shall submit prepared SMS payloads to SMS Router and process delivery status updates. |
| FR-015 | System shall provide CRM Manager with campaign-level delivery status and available click statistics. |
| FR-016 | System shall provide Operations with failed batch visibility, error reasons, retry status and correlation identifiers. |

---

## 11. High-Level Business Rules

| BR ID | Rule |
|---|---|
| BR-001 | SMS campaign cannot be launched without valid message text, selected audience and campaign long URL. |
| BR-002 | CRM must validate campaign URL rules before SlimLink call; SlimLink does not validate `long_url`. |
| BR-003 | CRM must provide a valid domain configuration for branded campaign links; if default SlimLink domain is technically supported, its use must be explicitly allowed by business decision. |
| BR-004 | Only players with valid phone number and SMS consent can be included in SMS campaign processing. |
| BR-005 | Each eligible player should receive only one SMS per campaign unless an authorized reprocessing flow is used. |
| BR-006 | Each SlimLink request record must have a unique `external_id` within the CRM company context. |
| BR-007 | Reusing an already used `external_id` must be treated as a non-retryable error or reconciliation case, not as a normal successful idempotent retry. |
| BR-008 | SlimLink record-level failures must not block successful records in the same batch from being processed further. |
| BR-009 | Recipients without successfully assigned short links must not be sent SMS messages containing missing, invalid or placeholder links. |
| BR-010 | Campaign status must reflect processing state: Draft, Scheduled, Processing, Partially Failed, Sent, Completed, Failed, Cancelled. |
| BR-011 | Access to campaign configuration, delivery results and click analytics must follow role-based permissions. |
| BR-012 | Audit trail must capture campaign launch, URL/domain selection, SlimLink request batch, SMS submission and critical failures. |

---

## 12. SlimLink Integration Requirements

### 12.1 Integration Overview

CRM sends a bulk request to SlimLink during campaign preparation. Each request record contains a long URL and domain identifier selected/configured for the campaign.

SlimLink:

1. receives the bulk request;
2. checks API access and IP whitelist rules;
3. takes a short-link path from its hot cache;
4. appends the path to the selected domain;
5. stores mapping between long URL and short link path;
6. returns the resulting short URL to CRM in the response.

### 12.2 Endpoint

| Parameter | Value |
|---|---|
| Method | `POST` |
| Endpoint | `/api/links/bulk` |
| Format | JSON |
| Authorization | `Authorization: Bearer <api token>` |
| Required headers | `Accept: application/json` |
| Max batch size | 1000 records |

### 12.3 Request Fields

| Field | Type | Required | Max | Description |
|---|---|---:|---:|---|
| `external_id` | `string \| null` | Yes | 255 | CRM-generated record identifier. Must be unique on SlimLink side within the company context. |
| `long_url` | `string` | Yes | 1000 | Destination URL. SlimLink does not validate this URL; CRM must validate it before request. |
| `domain_external_id` | `string UUID` / TBD | Recommended as mandatory for MVP | TBD | CRM domain ID configured as `domain_external_id` in SlimLink. Exact API type and optionality require final contract confirmation. |
| `title` | `string` | No | 255 | Optional link title. If provided, must follow SlimLink validation rules. |
| `expired_at` | `string \| null` | No | — | Optional link redirect expiration date. Must be parseable as ISO 8601-compatible date/time. |
| `team` | `string \| null` | No | 255 | Optional client team name / campaign ownership metadata. |

> Note: the source specification contains conflicting details for `domain_external_id` type and optionality: examples use UUID string, while another table describes it as optional integer with default `slim.link` domain fallback. For this Epic, MVP should require explicit CRM domain configuration to avoid accidental use of a default domain. Final type/optionality should be clarified in the API contract task.

### 12.4 Example Request

```json
[
  {
    "long_url": "https://example.com/promo/1",
    "domain_external_id": "f34fb1a7-3418-4705-a9e9-61e9175661ca",
    "title": "promo_sms_1",
    "expired_at": "2025-02-12T02:10:00+03:00",
    "external_id": "campaign123_player456",
    "team": "Team Asia"
  }
]
```

### 12.5 Response Fields

| Field | Type | Description |
|---|---|---|
| `message` | `string` | General request result message. |
| `data.batch_id` | `string` | SlimLink batch identifier. |
| `data.short_links[].external_id` | `string \| null` | CRM-generated record identifier returned for mapping. |
| `data.short_links[].id` | `string UUID` | SlimLink short link identifier. |
| `data.short_links[].url` | `string` | Resulting short URL: selected domain + generated/cached path. |
| `data.short_links[].status` | `int` | Record status: `1 = success`, `2 = failed`. |
| `data.short_links[].reason` | `string` | Failure reason when `status = 2`. |
| `data.short_links[].expired_at` / `expiredAt` | `string \| null` | Expiration date/time. Field naming must be normalized in the CRM mapping. |
| `error_code` | `string \| null` | General error code if applicable. |

### 12.6 Record-Level Failure Reasons

| Reason | Field | Meaning | CRM Handling |
|---|---|---|---|
| `long_url is required` | `long_url` | Required field is missing. | Non-retryable; fix request generation. |
| `long_url must not exceed 1000 characters` | `long_url` | URL length exceeds limit. | Non-retryable; validate before request. |
| `Domain not found` | `domain_id` / `domain_external_id` | Domain ID was provided but not found, or default domain was not found. | Non-retryable until domain configuration is fixed. |
| `Title must be between 4 and 255 characters. Got $length characters` | `title` | Title length is invalid. | Non-retryable; validate before request. |
| `Title can only contain Latin letters, numbers, spaces, and '_', '-', ':', '.'` | `title` | Title contains unsupported characters. | Non-retryable; validate before request. |
| `external_id must be a string` | `external_id` | Invalid type. | Non-retryable; fix request generation. |
| `external_id must not exceed 255 characters` | `external_id` | Identifier is too long. | Non-retryable; validate before request. |
| `Incorrect date format` | `expired_at` | Expiration date is not parseable. | Non-retryable; use ISO 8601-compatible format. |
| `Date expired` | `expired_at` | Expiration date is in the past. | Non-retryable; fix campaign configuration. |
| `The external_id is already used in your company` | `external_id` | The identifier is not unique. | Reconciliation case; do not blindly retry with the same `external_id`. |

### 12.7 HTTP Response Handling

| HTTP Code | Meaning | CRM Handling |
|---:|---|---|
| `200 OK` | Request successfully processed. | Parse `short_links` and process record-level statuses. |
| `201 Created` | Resource successfully created. | Treat as successful if response body matches contract. |
| `400 Bad Request` | Validation errors. | Non-retryable; store error and fix request generation or campaign data. |
| `401 Unauthorized` | Missing or invalid Authorization header/token. | Non-retryable until credentials are fixed; alert Operations. |
| `403 Forbidden` | Token is valid but access denied or IP is not whitelisted. | Non-retryable until access/IP whitelist is fixed; alert Operations. |
| `404 Not Found` | Endpoint or resource not found. | Non-retryable until integration configuration is fixed. |
| `429 Too Many Requests` | Rate limit exceeded. | Retryable with backoff/throttling; reduce request rate. |
| `500 Internal Server Error` | SlimLink server-side problem. | Retryable with backoff; alert if threshold exceeded. |

### 12.8 Authentication and Access Control

- CRM uses a long-lived Bearer Token generated in SlimLink admin panel.
- SlimLink company and CRM user must exist before integration is enabled.
- If SlimLink IP whitelist is not empty, requests are accepted only from trusted CRM IP addresses.
- Failed authorization attempts must be logged on SlimLink side.
- CRM must store API token securely and avoid exposing it in logs, UI or error messages.

### 12.9 SlimLink Data Storage and Analytics

SlimLink is responsible for storing link and click data according to the integration specification:

- hot cache: up to 4 million short links per domain;
- automatic generation of new cached links when the available amount reaches the 1 million threshold;
- expected volume: 60 million new links per month with +50% yearly growth;
- analytics storage period: up to 3 years;
- stored analytics attributes may include creation/click timestamp, IP, User Agent data, OS, browser, device format, device model, city, country, and referral source.

CRM reporting scope must be aligned with the actual analytics retrieval mechanism agreed with SlimLink.

---

## 13. High-Level Non-Functional Requirements

| Category | Requirement |
|---|---|
| Performance | CRM must process recipient batches without blocking campaign UI and must respect SlimLink max batch size of 1000 records. |
| SlimLink throughput | SlimLink integration target is 100,000 links prepared in no more than 1 minute where tariff limits and infrastructure allow. |
| Rate limiting | CRM must throttle SlimLink calls according to effective rate limits, currently stated as 5 RPS and 120 RPM. |
| Availability | SlimLink API availability target is not lower than 99.9% per month. CRM should degrade gracefully when SlimLink is unavailable. |
| Reliability | CRM must prevent duplicate SMS sending even if SlimLink, message broker or SMS Router retries occur. |
| Security | Bearer Token must be protected; requests should come only from approved IPs where whitelist is configured. |
| Compliance | Recipient eligibility must respect SMS consent, GDPR, regional communication rules and data minimization principles. |
| Observability | CRM must log campaignId, batchId, external_id, correlationId, HTTP status, SlimLink reason and SMS Router result where applicable. |
| Data retention | CRM must align campaign delivery/click data retention with compliance requirements and SlimLink analytics storage limits. |
| Backward compatibility | API changes should be backward compatible or versioned to avoid breaking active campaign processing. |

---

## 14. Impacted Systems / Components

| System / Component | Impact |
|---|---|
| CRM Campaign Management | New / updated SMS campaign configuration and launch flow. |
| Player Info / Player Profile | Source of player identifiers, phone numbers, consent flags and eligibility attributes. |
| Campaign Processing Service | Recipient preparation, batching, SlimLink orchestration, status tracking and retry control. |
| Message Broker / Queue | Asynchronous recipient batch and message processing; exact technology should follow architecture decision. |
| SlimLink | Bulk short link allocation, domain mapping, link storage and click analytics storage. |
| SMS Sender / SMS Router | SMS payload delivery and delivery status response processing. |
| Analytics / Reporting | Delivery metrics, click statistics and campaign performance reporting. |
| Audit / Logging / Monitoring | New audit events, error logs, correlation IDs, dashboards and alerts. |

---

## 15. Integrations

| Integration | Interaction | Sync / Async | Notes |
|---|---|---|---|
| CRM → Campaign Processing Service | Launch campaign and submit campaign configuration | Sync | Validates input and creates campaign processing request. |
| Campaign Processing Service → Player Info | Get eligible recipients and required player data | Sync / Async | Depends on current architecture and audience size. |
| Campaign Processing Service → SlimLink | Bulk short link allocation via `POST /api/links/bulk` | Sync | Must respect batch size, token auth, IP whitelist and rate limits. |
| Campaign Processing Service → Message Broker | Publish recipient/message processing jobs | Async | Used for scalability and resilience; exact broker is architecture-dependent. |
| Campaign Processing Service → SMS Router | Submit prepared SMS payloads | Sync / Async | Depends on SMS Router contract. |
| SMS Router → Campaign Processing Service | Return delivery status updates | Async callback / event | Must be processed idempotently. |
| SlimLink → CRM Reporting | Provide click analytics | TBD | SlimLink stores analytics; retrieval mechanism must be confirmed. |

---

## 16. Data Impact

### 16.1 New / Changed Data Objects

| Object | Description |
|---|---|
| Campaign | Stores SMS campaign metadata, configuration, selected domain, launch status and owner. |
| Campaign Recipient | Stores recipient-level processing state, playerId, phone reference, consent result and SMS status. |
| Campaign Batch | Stores batch-level processing status, SlimLink batch id, retries and failures. |
| Short Link Assignment | Stores CRM `external_id`, SlimLink link `id`, short URL, status, reason and expiration date. |
| Delivery Status | Stores SMS delivery status per recipient/message. |
| Click Statistic | Stores imported or aggregated SlimLink click data where analytics integration is implemented. |
| Audit Event | Stores critical campaign actions and integration processing events. |

### 16.2 Data Mapping Highlights

| CRM Field | SlimLink Field | Notes |
|---|---|---|
| Campaign recipient unique key | `external_id` | Must be unique in SlimLink company context. Suggested format: campaignId + playerId / recipientId. |
| Campaign long URL | `long_url` | Max 1000 characters. CRM validates before request. |
| Selected domain ID | `domain_external_id` | Must map to domain configured in SlimLink. Type/optionality must be confirmed. |
| Campaign/team ownership | `team` | Optional metadata where supported. |
| Link expiration | `expired_at` | Optional; use ISO 8601-compatible date/time. |
| SlimLink short URL | `url` | Used in SMS payload. |
| SlimLink result | `status`, `reason` | Used for recipient-level processing decision. |

---

## 17. UX / UI Impact

| Area | Expected Change |
|---|---|
| Campaign creation form | Add SMS campaign long URL and selected domain configuration. |
| Campaign validation | Show clear validation errors before campaign launch where URL/domain/message/audience is invalid. |
| Campaign status page | Show Processing, Partially Failed, Completed, Failed and Cancelled states. |
| Campaign results page | Show delivery counts and available click statistics. |
| Operations view | Show failed batches, SlimLink reasons, retry status and correlation IDs. |

---

## 18. Dependencies

| Dependency | Type | Owner | Status |
|---|---|---|---|
| SlimLink API contract | External / Integration | SlimLink / Backend | Partially defined; final clarifications needed. |
| SlimLink Bearer Token | Security / Access | SlimLink Admin / CRM Backend | Required before integration test. |
| SlimLink IP whitelist | Security / Network | SlimLink / DevOps | Required if whitelist is configured. |
| SlimLink domain configuration | Business / Integration | CRM / SlimLink Admin | Required before branded link creation. |
| Player eligibility rules | Business / Data | CRM / Player Info | To be confirmed. |
| SMS consent rules by region | Compliance | Compliance / CRM | To be confirmed. |
| SMS Router delivery contract | Internal / Integration | SMS Router Team | To be confirmed. |
| Message broker capacity | Technical | Platform / Backend | To be confirmed. |
| Monitoring dashboard | Technical / Ops | DevOps / Operations | To be configured. |

---

## 19. Risks

| Risk | Probability | Impact | Mitigation |
|---|---|---|---|
| SlimLink rate limits are exceeded | Medium | High | Apply configurable throttling, batch scheduling and backoff for `429`. |
| Duplicate SMS messages are sent during retry | Medium | High | Use CRM-side idempotency and send-state checks before SMS Router submission. |
| `external_id` reuse creates SlimLink errors | Medium | Medium | Generate deterministic unique IDs and handle reuse as reconciliation, not blind retry. |
| Invalid long URL is sent to SlimLink | Medium | Medium | Validate campaign URL in CRM before SlimLink request. |
| Domain is not configured in SlimLink | Medium | High | Pre-validate domain mapping and block campaign launch if configuration is missing. |
| Mixed SlimLink batch response is mishandled | Medium | High | Process record-level statuses independently and do not discard successful records. |
| SlimLink unavailable or returns 5xx | Medium | High | Retry with backoff, alert Operations, and keep campaign in Processing / Partially Failed state. |
| IP whitelist misconfiguration blocks CRM access | Medium | High | Include IP whitelist verification in deployment checklist. |
| Click analytics retrieval is not defined | Medium | Medium | Clarify analytics integration mechanism before committing click reporting scope. |
| GDPR / consent rules are applied incorrectly | Low / Medium | High | Include compliance review and eligibility tests before release. |

---

## 20. Assumptions

- CRM campaign audience is selected before SlimLink processing starts.
- Player Info provides player identifier, phone number availability and consent data.
- SlimLink company, CRM user, Bearer Token and domain configuration are created before production use.
- CRM sends short link requests to SlimLink synchronously using `POST /api/links/bulk`.
- SlimLink allocates short-link paths from hot cache instead of generating links from scratch during request processing.
- CRM must generate unique `external_id` values for every short link request record.
- SMS messages are submitted only after successful short link allocation for the recipient.
- Delivery status is available from SMS Router.
- Click analytics are stored by SlimLink, but CRM retrieval method is still to be clarified.
- Exact message broker technology is an implementation decision and should not be hardcoded in the Epic unless already confirmed.

---

## 21. Rollout / Release Strategy

- Release behind feature flag for selected CRM users / markets.
- Start with pilot campaign using limited audience size.
- Verify SlimLink access: Bearer Token, IP whitelist, domain mapping and batch contract.
- Validate URL checks, short link allocation, SMS Router delivery and campaign status reporting.
- Monitor SlimLink errors, `429` rate limit responses, batch failures, retry count, queue lag and SMS delivery status coverage.
- Gradually increase audience size after successful pilot.
- Rollback strategy: disable new campaign launches; already accepted SMS messages cannot be recalled from SMS Router.

---

## 22. Analytics / Monitoring

### 22.1 Business Events

| Event | Purpose |
|---|---|
| `sms_campaign_created` | Track campaign creation. |
| `sms_campaign_launched` | Track campaign launch. |
| `sms_recipient_batch_created` | Track recipient batch preparation. |
| `slimlink_bulk_request_sent` | Track SlimLink request submission. |
| `slimlink_short_link_assigned` | Track successful short link allocation. |
| `slimlink_short_link_failed` | Track record-level short link failure. |
| `sms_sent_to_router` | Track SMS Router submission. |
| `sms_delivery_status_updated` | Track delivery result. |
| `short_link_clicked` | Track engagement if click data is imported from SlimLink. |
| `sms_campaign_completed` | Track campaign completion. |

### 22.2 Technical Metrics

| Metric | Purpose |
|---|---|
| SlimLink request rate | Ensure CRM does not exceed effective rate limits. |
| SlimLink batch size | Ensure no batch exceeds 1000 records. |
| SlimLink success / failure count | Monitor integration health and data quality. |
| SlimLink HTTP error rate | Detect `4xx`, `429`, and `5xx` issues. |
| Batch processing rate | Monitor campaign throughput. |
| Batch failure rate | Detect processing issues. |
| Retry count | Detect instability or downstream failures. |
| Queue lag | Detect backlog and scaling problems. |
| SMS Router error rate | Monitor delivery integration issues. |
| Duplicate prevention count | Detect avoided duplicate sends / idempotency protection events. |

### 22.3 Alerts

- High SlimLink error rate.
- SlimLink `401` / `403` access errors.
- SlimLink `429` rate limit threshold exceeded.
- High SMS Router failure rate.
- Queue lag above threshold.
- Campaign stuck in Processing status.
- Failed batch count above threshold.
- Unexpected growth of `external_id already used` errors.

---

## 23. Jira / Confluence Documentation Split

| Artifact | Location | Purpose |
|---|---|---|
| Epic | Jira | High-level business capability, scope, impacted systems, risks, NFR and child issue structure. |
| Story | Jira | Business/system value slice with user story, flow, AC, rules, dependencies and QA focus. |
| Task | Jira | Technical, analysis, configuration, integration, DevOps, QA or documentation work item. |
| Sub-task | Jira | Small executable action inside Story/Task, such as creating topic, adding config, updating credentials or adding metric. |
| Stable integration overview | Confluence | Source of truth for diagrams, integration map, API contract summary, decision log and cross-cutting NFR. |
| Detailed API / mapping | Jira Task or Confluence | Depends on team practice; should be linked from relevant Story/Task to avoid duplication. |

---

## 24. Child Issues

### 24.1 MVP Stories

| # | Story | User Story | Purpose | Priority |
|---:|---|---|---|---|
| 1 | Configure and launch SMS campaign | As a CRM Manager, I want to configure and launch an SMS campaign with message text, selected audience and campaign long URL, so that I can run personalized retention campaigns and drive players to the correct promotional or reactivation page. | Main business-value slice. | High |
| 2 | Validate campaign URL and domain configuration | As a CRM Manager, I want the system to validate campaign URL and domain configuration before launch, so that players do not receive broken, unauthorized or non-compliant links. | Prevents bad campaign data before downstream processing. | High |
| 3 | Prepare eligible player batches | As the CRM System, I want to prepare eligible player batches for SMS campaign processing, so that only valid recipients with SMS consent and phone numbers are sent to SlimLink and SMS Router. | Eligibility and data preparation slice. | High |
| 4 | Assign personalized short links via SlimLink | As the CRM System, I want to request personalized short links from SlimLink in controlled batches, so that each eligible recipient receives a unique short URL and campaign engagement can be tracked per recipient. | Core SlimLink integration slice. | High |
| 5 | Process SlimLink failures and partial batch results | As an Operations User, I want the system to capture SlimLink failed records and reasons, so that partial failures can be investigated without blocking successful recipients. | Error handling and operational reliability slice. | High |
| 6 | Send prepared SMS messages through SMS Router | As the CRM System, I want to send prepared SMS messages through the approved SMS Router, so that campaign messages are delivered through the controlled delivery channel with trackable delivery status. | Delivery slice. | High |
| 7 | Prevent duplicate SMS sending | As a CRM Manager, I want the system to prevent duplicate SMS sending during retries or reprocessing, so that players are not spammed and campaign trust is preserved. | Reliability / idempotency slice. | High |
| 8 | View SMS campaign delivery status | As a CRM Manager, I want to view SMS campaign delivery status, so that I can understand campaign reach, identify failed deliveries and decide whether follow-up action is needed. | Business reporting slice. | Medium |
| 9 | View short link click statistics | As a CRM Manager, I want to view short link click statistics, so that I can measure campaign engagement and evaluate campaign effectiveness. | Campaign analytics slice; retrieval mechanism depends on SlimLink analytics integration. | Medium |

### 24.2 Post-MVP Stories

| # | Story | User Story | Purpose | Priority |
|---:|---|---|---|---|
| 10 | Monitor SMS pipeline health | As an Operations User, I want to monitor SMS pipeline health, so that I can detect SlimLink, broker and SMS Router issues before campaigns are significantly affected. | Operational visibility slice. | Medium |
| 11 | Access campaign audit trail | As an Authorized User, I want to access campaign audit trail, so that critical campaign actions and integration events can be reviewed for investigation and compliance. | Audit and compliance slice. | Medium |
| 12 | Reprocess failed recipients | As an Operations User, I want to reprocess failed recipients through a controlled flow, so that recoverable campaign failures can be fixed without resending SMS to successful recipients. | Controlled recovery slice. | Later |

---

## 25. Tasks / Spikes

| Issue Type | Title | Purpose | Priority |
|---|---|---|---|
| Task | Finalize SlimLink API contract and field mapping | Confirm endpoint, request/response schema, field names, `domain_external_id` type, `expired_at` format and response naming. | High |
| Task | Configure SlimLink credentials and IP whitelist | Prepare Bearer Token storage, trusted IPs and access verification. | High |
| Task | Define CRM `external_id` generation strategy | Ensure uniqueness and support reconciliation without duplicate SMS sending. | High |
| Task | Implement SlimLink rate limiting and throttling | Respect 1000 batch size, effective RPS/RPM limits and `429` handling. | High |
| Task | Define SlimLink error matrix | Map record-level reasons and HTTP codes to retry/non-retry/reconciliation behavior. | High |
| Task | Define SMS Router payload and delivery status mapping | Align prepared SMS payload and delivery statuses with CRM campaign statuses. | High |
| Task | Configure campaign monitoring dashboard | Add SlimLink, queue, batch and SMS Router metrics. | Medium |
| Spike | Confirm click analytics retrieval from SlimLink | Determine whether CRM receives click data through callback, API pull, export or reporting integration. | High |
| Spike | Confirm message broker strategy | Decide whether current broker is reused or target scalable broker is introduced. | Medium |

---

## 26. Open Questions

| Question | Owner | Status |
|---|---|---|
| What is the final maximum campaign audience size for MVP? | Product Owner / CRM Lead | Open |
| Should campaign launch support scheduling in MVP, or only immediate launch? | Product Owner | Open |
| What exact player eligibility and SMS consent rules apply per region? | Compliance / CRM | Open |
| Should CRM require explicit `domain_external_id`, or allow fallback to default `slim.link` domain? | Product Owner / Security / CRM | Open |
| What is the final type and requiredness of `domain_external_id`? | SlimLink / Backend / BSA | Open |
| Should response field be normalized as `expired_at` or `expiredAt` in CRM mapping? | SlimLink / Backend / BSA | Open |
| Are both `5 RPS` and `120 RPM` limits applied simultaneously, and which limit is strictest for production? | SlimLink / Backend | Open |
| What is the exact click analytics retrieval mechanism from SlimLink? | SlimLink / Backend / Analytics | Open |
| What SMS Router statuses should be mapped to CRM campaign statuses? | SMS Router Team / BSA | Open |
| What data retention period applies in CRM for delivery and click statistics? | Compliance / Data Owner | Open |
| Should failed recipients be manually reprocessed from UI in MVP? | Product Owner / Operations | Open |

---

## 27. Epic Definition of Ready

- Business goal and product outcome are clear.
- MVP and Post-MVP scope are separated.
- Main stakeholders and impacted systems are identified.
- SlimLink API contract is linked and reviewed as source of truth.
- High-level functional requirements and business rules are documented.
- SlimLink NFR and constraints are reflected: batch size, throughput, availability, rate limits, auth and IP whitelist.
- Main risks, dependencies and open questions have owners.
- Child Stories and key Tasks / Spikes are identified.
- Jira issues are linked to supporting Confluence / API documentation where applicable.

---

## 28. Epic Definition of Done

- MVP child Stories are delivered and accepted.
- CRM Manager can configure and launch SMS campaign with long URL and selected domain.
- CRM validates campaign URL/domain configuration before SlimLink request.
- Eligible recipients are processed in SlimLink-compatible batches.
- CRM calls SlimLink `POST /api/links/bulk` securely using Bearer Token and trusted IPs where required.
- Short links are assigned to successful recipients and stored with SlimLink identifiers.
- SlimLink record-level failures and HTTP errors are handled according to agreed error matrix.
- Prepared SMS messages are sent through SMS Router only for valid recipients with successful short links.
- Delivery statuses are processed and visible in CRM.
- Click statistics are visible if the SlimLink analytics retrieval mechanism is included in MVP.
- CRM-side idempotency prevents duplicate SMS sending during retry/reprocessing scenarios.
- Critical logs, audit events, correlation IDs and monitoring metrics are implemented.
- QA, regression testing and UAT/business review are completed.
- Documentation and linked Jira artifacts are updated.

---

## 29. Interview Positioning Summary

This Epic demonstrates how a BSA can structure a technically complex CRM integration within SDLC:

- start from business goal and campaign outcome;
- identify stakeholders, systems, dependencies and constraints;
- clarify source-of-truth API contract with SlimLink;
- translate business needs into Epic, Stories, Tasks and acceptance criteria;
- define functional requirements, NFR, data mapping, error handling and monitoring;
- align multiple teams around a scalable and auditable delivery pipeline.
