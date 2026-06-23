# Story: Configure and Launch SMS Campaign

## 1. User Story

As a **CRM Manager**,  
I want to configure and launch an SMS campaign using the existing campaign/template management capability with **SMS** as a new communication type,  
So that I can run personalized retention, reactivation and promotional SMS campaigns through a controlled CRM delivery pipeline.

---

## 2. Business Context

This Story supports the Epic **SMS Campaign Delivery Pipeline with SlimLink Short Links**.

The CRM already supports campaign/template creation for **Email**. The goal of this Story is not to build a separate campaign module from scratch, but to extend the existing campaign/template flow by introducing **SMS** as a new communication type with its own channel-specific rules.

SMS differs from Email in several important ways:

- SMS content is **plain text**, not HTML.
- SMS messages cannot contain images, banners or rich email components.
- SMS templates require character counting and, where applicable, segment estimation.
- SMS campaigns usually need a short, clear call-to-action and a link placeholder / campaign URL.
- SMS sending must respect SMS-specific consent, market restrictions and sender/channel availability.

Detailed SMS editor behavior, character counting rules, encoding rules, template restrictions and UI polishing may be implemented as separate Tasks or follow-up Stories. This Story focuses on the core business capability: enabling CRM Manager to create, validate and launch an SMS campaign from CRM.

---

## 3. User / Role

- **Primary role:** CRM Manager
- **Secondary roles:** Marketing & Retention Manager, Product Owner, Operations User
- **System actor:** CRM Campaign Management, Campaign Processing Service
- **Tenant / market / product limitations:** SMS campaign availability, sender settings, consent rules and communication restrictions may depend on tenant, brand, market, product and regulatory region.

---

## 4. Preconditions

- CRM campaign management functionality exists.
- CRM has existing template creation / editing functionality for Email.
- SMS channel is enabled for the relevant tenant / brand / market.
- CRM Manager has permission to create and launch campaigns.
- Audience / segment selection functionality is available.
- SMS sender configuration exists or is available through downstream delivery setup.
- Campaign URL / link configuration rules are defined at Epic or linked Story level.
- SMS consent and eligibility rules are available for downstream recipient preparation.

---

## 5. Postconditions

- CRM Manager can create a campaign with communication type `SMS`.
- SMS campaign stores selected audience, message text, campaign long URL and required metadata.
- System validates SMS-specific campaign configuration before launch.
- Campaign can be saved as Draft, launched immediately or scheduled if scheduling is supported.
- Valid launched campaign is passed to the recipient preparation step.
- Invalid campaign is not launched and CRM Manager receives clear validation feedback.
- Campaign creation and launch actions are logged and audited.

---

## 6. Main Flow

1. CRM Manager opens CRM Campaign Management.
2. CRM Manager creates a new campaign or selects the existing campaign creation flow.
3. CRM Manager selects **SMS** as the campaign communication type.
4. System displays SMS-specific campaign form / editor instead of Email HTML editor.
5. CRM Manager enters campaign name, description and business metadata where required.
6. CRM Manager selects target audience / segment.
7. CRM Manager creates or selects an SMS template.
8. CRM Manager enters SMS message text using plain text format.
9. System displays character count and basic SMS content guidance.
10. CRM Manager adds campaign long URL or link placeholder according to configured campaign flow.
11. System prevents unsupported Email-specific content such as images, HTML blocks or rich media from being used in SMS content.
12. CRM Manager reviews campaign preview and validation messages.
13. CRM Manager saves the campaign as Draft, launches it immediately or schedules it if scheduling is available.
14. System validates required fields, channel-specific rules, permissions and launch readiness.
15. System creates campaign launch request and passes it to downstream recipient preparation.
16. System updates campaign status according to the campaign lifecycle.
17. System logs and audits campaign creation / launch action.

---

## 7. Alternative Flows

### A1. CRM Manager saves SMS campaign as Draft

1. CRM Manager fills in part of SMS campaign configuration.
2. CRM Manager selects `Save as Draft`.
3. System stores campaign configuration without launching downstream processing.
4. Campaign status remains `Draft`.
5. CRM Manager can return later and complete the campaign.

### A2. CRM Manager uses an existing SMS template

1. CRM Manager selects an existing SMS template.
2. System loads SMS plain text content into the SMS editor.
3. CRM Manager updates content if needed.
4. System revalidates SMS content and campaign configuration.

### A3. Required campaign data is missing

1. CRM Manager attempts to launch campaign with missing required data.
2. System blocks launch.
3. System highlights missing or invalid fields.
4. Campaign remains in `Draft` or `Validation Failed` state depending on existing status model.

### A4. SMS content contains unsupported Email-specific elements

1. CRM Manager attempts to insert or reuse content with HTML, images or rich media.
2. System blocks unsupported content or removes it according to agreed UX behavior.
3. System shows clear message that SMS supports plain text only.
4. Campaign cannot be launched until SMS content is valid.

### A5. SMS content exceeds configured limits

1. CRM Manager enters message text exceeding configured SMS content threshold.
2. System displays warning or blocks launch depending on configured business rule.
3. CRM Manager updates content or confirms allowed behavior if confirmation is supported.

### A6. Selected audience is unavailable or empty

1. CRM Manager selects an unavailable, deleted or empty audience.
2. System blocks launch or asks CRM Manager to choose another audience.
3. Campaign remains in Draft / Validation Failed state.

### A7. SMS channel is disabled for selected tenant / market

1. CRM Manager selects SMS campaign type for a market where SMS is disabled.
2. System shows availability restriction.
3. Campaign cannot be launched for this market.

### A8. Campaign launch request is accepted but downstream processing starts asynchronously

1. CRM Manager launches a valid SMS campaign.
2. System accepts the launch request.
3. Campaign status changes to `Processing` or equivalent state.
4. Recipient preparation and downstream pipeline continue asynchronously.

---

## 8. Edge Cases

| Case | Expected behavior |
|---|---|
| CRM Manager switches from Email to SMS during campaign creation | System should warn that Email-specific content may be lost or unsupported. |
| Existing Email template is selected for SMS | System should not allow direct use of HTML Email template as SMS content without conversion / plain text adaptation. |
| SMS text is empty or contains only spaces | Launch is blocked. |
| Message contains image, HTML tag or rich media component | Content is rejected or removed according to agreed UX behavior. |
| Message contains special characters / emoji | System updates character count / segment estimation according to configured rules. |
| Link placeholder is missing where campaign URL is required | Launch is blocked or warning is shown depending on campaign type. |
| Audience is changed after content validation | System revalidates campaign launch readiness. |
| Campaign is edited after scheduling | System follows existing edit / reschedule rules. |
| User lacks launch permission | Launch action is blocked; user can only view or edit according to permissions. |
| Campaign is launched twice due to double-click or browser retry | System must create only one launch request. |

---

## 9. Functional Requirements

| FR ID | Requirement |
|---|---|
| FR-001 | System shall allow authorized CRM Manager to create a campaign with communication type `SMS`. |
| FR-002 | System shall reuse existing campaign/template management where applicable instead of creating a separate unrelated SMS module. |
| FR-003 | System shall provide SMS-specific editor behavior based on plain text content. |
| FR-004 | System shall not allow Email-specific HTML blocks, images, banners or rich media components in SMS content. |
| FR-005 | System shall display SMS character count and basic content guidance while CRM Manager edits SMS text. |
| FR-006 | System shall allow CRM Manager to create or select an SMS template. |
| FR-007 | System shall allow CRM Manager to select target audience / segment for SMS campaign. |
| FR-008 | System shall allow CRM Manager to configure campaign long URL or required link placement according to campaign rules. |
| FR-009 | System shall validate required SMS campaign fields before launch. |
| FR-010 | System shall validate that selected SMS channel is available for tenant / market / brand. |
| FR-011 | System shall allow CRM Manager to save SMS campaign as Draft. |
| FR-012 | System shall allow CRM Manager to launch valid SMS campaign immediately. |
| FR-013 | System shall support campaign scheduling if scheduling is part of the existing campaign capability. |
| FR-014 | System shall create a downstream launch request for recipient preparation after successful validation. |
| FR-015 | System shall update campaign status according to campaign lifecycle. |
| FR-016 | System shall prevent duplicate launch request creation caused by repeated user action or browser retry. |
| FR-017 | System shall log and audit campaign creation, edit, validation failure and launch actions. |

---

## 10. Business Rules

| BR ID | Rule |
|---|---|
| BR-001 | SMS campaign must have communication type `SMS`. |
| BR-002 | SMS content must be plain text only. |
| BR-003 | SMS campaign cannot be launched without campaign name, selected audience and message text. |
| BR-004 | Campaign long URL / link placement is required when the SMS campaign is configured to use personalized short links. |
| BR-005 | Email HTML templates cannot be used directly as SMS templates. |
| BR-006 | Images, banners, attachments and rich media blocks are not allowed in SMS body. |
| BR-007 | SMS campaign launch must be blocked if SMS channel is disabled for selected tenant / market / brand. |
| BR-008 | Only authorized users can launch SMS campaigns. |
| BR-009 | Draft campaign can be edited before launch. |
| BR-010 | Launched campaign should not be freely edited if downstream processing has already started; existing campaign lifecycle rules apply. |
| BR-011 | Repeated click / retry on launch action must not create duplicate campaign launch requests. |
| BR-012 | SMS-specific detailed restrictions such as exact character limit, segment calculation and encoding behavior are defined in linked Tasks / channel configuration. |

---

## 11. Acceptance Criteria

### AC-001: SMS campaign type is available

**Given** CRM Manager has permission to create campaigns,  
**When** CRM Manager opens campaign creation flow,  
**Then** SMS is available as a campaign communication type where SMS channel is enabled.

### AC-002: SMS editor uses plain text mode

**Given** CRM Manager creates SMS campaign,  
**When** the message editor is displayed,  
**Then** the editor supports plain text SMS content,  
**And** does not display Email-specific HTML / image editing components.

### AC-003: Character count is visible

**Given** CRM Manager edits SMS message text,  
**When** text is entered or updated,  
**Then** system displays character count and basic SMS content guidance according to configured SMS rules.

### AC-004: Unsupported Email content is not allowed

**Given** CRM Manager tries to insert image, HTML block or rich media into SMS content,  
**When** the content is added,  
**Then** system rejects unsupported content or prevents its insertion,  
**And** shows clear user-friendly explanation.

### AC-005: Campaign can be saved as Draft

**Given** CRM Manager configures SMS campaign,  
**When** CRM Manager selects `Save as Draft`,  
**Then** system saves campaign configuration,  
**And** no downstream recipient preparation is started.

### AC-006: Required fields are validated before launch

**Given** SMS campaign has missing required data,  
**When** CRM Manager attempts to launch the campaign,  
**Then** launch is blocked,  
**And** system highlights missing or invalid fields.

### AC-007: Valid SMS campaign can be launched

**Given** SMS campaign has valid audience, message text, required URL/link configuration and channel availability,  
**When** CRM Manager launches the campaign,  
**Then** system accepts launch request,  
**And** campaign is passed to downstream recipient preparation.

### AC-008: Launch action is protected from duplicates

**Given** CRM Manager clicks launch more than once or browser retries the request,  
**When** duplicate launch request is received,  
**Then** system creates only one campaign launch request,  
**And** campaign is not processed twice.

### AC-009: Existing Email functionality is not broken

**Given** existing Email campaign and template functionality is available,  
**When** SMS campaign type is introduced,  
**Then** existing Email campaign creation and Email template editing continue to work as before.

### AC-010: Launch action is auditable

**Given** CRM Manager launches SMS campaign,  
**When** campaign launch is accepted or rejected,  
**Then** system records audit event with user, campaign, action, timestamp and result.

---

## 12. Validation Rules

| Field / Object | Rule | Error message |
|---|---|---|
| Campaign type | Must be `SMS` for this flow | Invalid campaign type. |
| Campaign name | Required | Campaign name is required. |
| Audience / segment | Required and available | Select a valid audience. |
| SMS message text | Required, plain text only | SMS message text is required. |
| SMS message text | Must not contain unsupported rich content | SMS supports plain text only. |
| Campaign URL / link placement | Required where personalized short links are enabled | Campaign URL or link placeholder is required. |
| SMS channel availability | Must be enabled for selected tenant / market / brand | SMS channel is not available for selected market. |
| User permission | User must have launch permission | You do not have permission to launch SMS campaigns. |
| Campaign status | Must allow launch | Campaign cannot be launched from current status. |

---

## 13. Permissions / Access Control

| Role | View | Create | Edit | Delete | Approve | Launch | Export |
|---|---|---|---|---|---|---|---|
| Admin | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| CRM Manager | Yes | Yes | Yes | No | If applicable | Yes | If allowed |
| Marketing Manager | Yes | Yes | Yes | No | If applicable | If allowed | If allowed |
| Operations User | Yes | No | No | No | No | No | If allowed |
| Support User | Limited | No | No | No | No | No | No |

### Permission failure behavior

- User without create permission cannot create SMS campaign.
- User without launch permission can save draft if edit permission is allowed, but cannot launch.
- Restricted tenant / market users cannot launch SMS campaigns outside their access scope.
- Permission failures must not reveal unauthorized campaign or audience data.

---

## 14. Logging Requirements

| Event | Trigger | Level | Required fields |
|---|---|---|---|
| `sms_campaign_draft_created` | SMS campaign draft is saved | Info | userId, tenantId, campaignId, action, timestamp, result, correlationId |
| `sms_campaign_validation_failed` | Launch validation fails | Warn | userId, tenantId, campaignId, validationCode, timestamp, correlationId |
| `sms_campaign_launch_requested` | CRM Manager clicks Launch | Info | userId, tenantId, campaignId, action, timestamp, correlationId |
| `sms_campaign_launch_accepted` | Launch request is accepted | Info | userId, tenantId, campaignId, timestamp, correlationId |
| `sms_campaign_launch_rejected` | Launch request is rejected | Warn | userId, tenantId, campaignId, reasonCode, timestamp, correlationId |
| `sms_campaign_duplicate_launch_prevented` | Duplicate launch request is detected | Warn | userId, tenantId, campaignId, requestId, timestamp, correlationId |

Required common fields:

- userId
- tenantId
- campaignId
- action
- timestamp
- requestId / correlationId
- result
- errorCode / errorMessage if failed

---

## 15. Audit Requirements

- **Should this action be auditable?** Yes
- **Audit event names:**
  - `SMS Campaign Created`
  - `SMS Campaign Updated`
  - `SMS Campaign Validation Failed`
  - `SMS Campaign Launched`
  - `SMS Campaign Launch Rejected`
- **Old/new values required?** Yes, for critical configuration changes such as audience, message text, URL/link configuration, schedule and status.
- **Who can view audit record?** Authorized CRM Admin, Operations, Compliance and selected Support roles.
- **Retention period:** According to campaign audit and compliance retention policy.

---

## 16. Integration Points

| System | Interaction | Sync / Async | Contract link |
|---|---|---|---|
| CRM UI → Campaign Management Service | Create / update / launch SMS campaign | Sync | Linked API / Story documentation |
| Campaign Management Service → Template Service | Create / retrieve SMS template | Sync | Existing template service contract |
| Campaign Management Service → Audience / Segment Service | Validate selected audience reference | Sync | Existing audience service contract |
| Campaign Management Service → Campaign Processing Service | Submit valid SMS campaign for recipient preparation | Async / Sync handoff | Linked processing contract |
| Campaign Management Service → Audit / Logging | Record critical campaign actions | Async | Audit event specification |

---

## 17. API / Event Details

Detailed payloads are intentionally not defined in this Story and should be kept in linked Tasks / API specs where required.

### High-Level Event

- **Event name:** `sms_campaign_launch_requested`
- **Purpose:** Notify downstream processing that a valid SMS campaign is ready for recipient preparation.
- **Required business identifiers:** campaignId, tenantId, audience reference, SMS template reference, campaign URL / link configuration reference, launch mode, correlationId.
- **Idempotency:** campaignId + launch attempt / requestId should prevent duplicate launch processing.
- **Retry behavior:** downstream handoff may be retried without creating duplicate campaign processing.

---

## 18. Data Requirements

| Field / Object | Type | Required | Source | Notes |
|---|---|---|---|---|
| campaignId | UUID / string | Yes | CRM | Unique campaign identifier. |
| campaignType | Enum | Yes | CRM | Must be `SMS`. |
| campaignName | String | Yes | CRM Manager | Human-readable campaign name. |
| audienceRef | String | Yes | Audience / Segment Service | Reference to selected audience, not recipient list itself. |
| smsTemplateId | String | Optional / Required by flow | Template Service | SMS template reference if template is used. |
| smsText | String | Yes | CRM Manager / Template | Plain text SMS content. |
| campaignLongUrl | String | Conditional | CRM Manager | Required when campaign uses personalized short links. |
| linkPlaceholder | String | Conditional | CRM / Template | Required if message text must explicitly contain link placement. |
| launchMode | Enum | Yes | CRM | Draft / immediate / scheduled. |
| scheduleAt | DateTime | Conditional | CRM Manager | Required for scheduled launch if supported. |
| status | Enum | Yes | CRM | Draft, Scheduled, Processing, Validation Failed, etc. |
| createdBy / updatedBy | User ID | Yes | CRM | Audit and ownership. |

---

## 19. UI / UX

- Existing campaign creation flow should be reused where possible.
- Communication type selector should include `SMS` where enabled.
- SMS editor should be plain-text oriented, not HTML-oriented.
- Character count / segment guidance should be visible during editing.
- Unsupported Email content controls should be hidden or disabled for SMS.
- Preview should show how SMS text will approximately look to recipient.
- Validation messages should be clear and action-oriented.
- Launch action should show clear state transition: Draft → Processing / Scheduled.

### UI States

- **Default:** Empty SMS campaign form.
- **Loading:** Audience/template data is loading.
- **Draft saved:** Campaign saved without downstream processing.
- **Validation error:** Required or invalid fields are highlighted.
- **Ready to launch:** All required configuration is valid.
- **Launch submitted:** Campaign is accepted for downstream processing.
- **Disabled:** SMS channel unavailable or user lacks permission.

---

## 20. Notifications / Communication

- No player-facing SMS is sent as part of this Story directly; this Story only creates and launches the campaign into the delivery pipeline.
- CRM Manager may receive UI confirmation when campaign is saved, scheduled or launched.
- Operations notification may be triggered only if campaign launch handoff fails.
- Actual SMS delivery is handled by downstream Stories / services.

---

## 21. Non-Functional Requirements

| Category | Requirement |
|---|---|
| Usability | CRM Manager should understand SMS-specific limitations directly in the campaign form. |
| Performance | Opening and editing SMS campaign form should not be slower than existing campaign creation flow under normal load. |
| Reliability | Duplicate launch requests must not create duplicate downstream processing. |
| Security | User permissions and tenant / market access restrictions must be enforced. |
| Compliance | Launch flow must support SMS consent and regional restrictions through downstream eligibility preparation. |
| Observability | Campaign creation and launch must be traceable with campaignId and correlationId. |
| Backward compatibility | Existing Email campaign and template functionality must not be broken by SMS type introduction. |
| Accessibility | SMS campaign form should follow existing CRM accessibility standards where applicable. |

---

## 22. Analytics

- **Business event:** `sms_campaign_created`
- **Business event:** `sms_campaign_saved_as_draft`
- **Business event:** `sms_campaign_launch_requested`
- **Business event:** `sms_campaign_launch_validation_failed`
- **Business event:** `sms_campaign_scheduled` if scheduling is supported

### Properties

- campaignId
- tenantId
- channel = SMS
- audienceRef
- launchMode
- validationResult
- createdByRole

### Funnel / metric affected

- Campaign creation funnel.
- Draft-to-launch conversion.
- Campaign launch time.
- Validation failure rate.
- SMS channel adoption.

---

## 23. Dependencies

| Dependency | Type | Owner | Status |
|---|---|---|---|
| Existing campaign creation flow | Product / Technical | CRM Team | Existing |
| Existing template management | Product / Technical | CRM / Template Team | Existing |
| SMS channel availability rules | Business / Configuration | Product Owner / CRM Admin | To be confirmed |
| SMS content validation rules | Product / Technical | BSA / Tech Lead / QA | To be defined in linked Task |
| Audience / Segment service | Data / Integration | Audience Team | Existing / To be confirmed |
| Campaign Processing Service handoff | Integration | Backend Team | To be confirmed |
| Permission model | Security / Product | CRM Admin / Security | Existing / To be updated |
| UI design for SMS editor | UX / Product | UX/UI | To be prepared |

---

## 24. Test Notes / QA Focus

- Positive scenario: create valid SMS campaign and launch it.
- Positive scenario: save SMS campaign as Draft.
- Positive scenario: reuse existing SMS template.
- Negative scenario: launch without audience.
- Negative scenario: launch without message text.
- Negative scenario: insert unsupported HTML / image content.
- Negative scenario: user without launch permission attempts launch.
- Regression: existing Email campaign creation still works.
- Regression: existing Email template editing still works.
- Regression: campaign status lifecycle remains consistent.
- Integration check: downstream recipient preparation receives one valid launch request.
- Idempotency check: repeated launch click does not create duplicate processing.

### Test data

- Tenant with SMS enabled.
- Tenant with SMS disabled.
- User with launch permission.
- User without launch permission.
- Valid audience reference.
- Empty / unavailable audience reference.
- Plain text SMS template.
- Existing Email template with HTML content.

---

## 25. Open Questions

| Question | Owner | Due date | Status |
|---|---|---|---|
| Should SMS campaign scheduling be included in MVP or only immediate launch? | Product Owner | TBD | Open |
| Should SMS template be mandatory, or can CRM Manager type message text directly? | Product Owner / CRM Lead | TBD | Open |
| Should SMS character limit block launch or only show warning? | Product Owner / Tech Lead | TBD | Open |
| What exact SMS encoding / segment calculation rules should be used? | Tech Lead / SMS Provider Team | TBD | Open |
| Should link placeholder be mandatory for all SlimLink-enabled SMS campaigns? | Product Owner / BSA | TBD | Open |
| Should Email templates be convertible to SMS plain text, or blocked completely? | Product Owner / UX | TBD | Open |
| Which markets / tenants should have SMS channel enabled in MVP? | Product Owner / CRM Lead | TBD | Open |

---

## 26. Out of Scope

- Detailed SMS character segmentation algorithm.
- Full SMS template editor redesign.
- HTML-to-SMS template conversion engine.
- MMS / rich media SMS support.
- Email campaign changes unrelated to adding SMS type.
- Recipient eligibility preparation.
- SlimLink short link allocation.
- SMS Router delivery integration.
- Delivery status dashboard.
- Click statistics reporting.
- Advanced A/B testing or campaign attribution.

---

## 27. Links

- **Epic:** SMS Campaign Delivery Pipeline with SlimLink Short Links
- **Related Story:** Prepare Privacy-Safe Recipient Batches
- **Related Story:** Allocate Personalized Short Links via SlimLink
- **Related Story:** Send SMS Using Recipient Reference
- **Confluence requirement:** TBD
- **Figma:** TBD
- **API spec:** TBD
- **Data model:** TBD
- **Access matrix:** TBD
- **Test cases:** TBD
- **Related issues:** TBD

---

## 28. Story Definition of Ready

- [ ] User role and business value are clear.
- [ ] SMS as a new communication type is agreed.
- [ ] In Scope / Out of Scope are clear.
- [ ] Main flow is described.
- [ ] Alternative flows and edge cases are described.
- [ ] Acceptance Criteria are testable.
- [ ] High-level SMS-specific rules are documented.
- [ ] Detailed SMS editor / character-count tasks are identified separately if needed.
- [ ] Permissions are defined or linked.
- [ ] UX/UI design is attached or marked as not required for current phase.
- [ ] Downstream handoff to recipient preparation is clear.
- [ ] QA understands regression scope for existing Email functionality.
- [ ] Story is estimated.
- [ ] Story is small enough for one sprint or decomposed into smaller delivery items.

---

## 29. Story Definition of Done

- [ ] SMS campaign type is available for authorized users where enabled.
- [ ] CRM Manager can create SMS campaign using existing campaign flow.
- [ ] SMS editor supports plain text content.
- [ ] Unsupported Email content is not available or is rejected for SMS.
- [ ] Character count / SMS content guidance is visible.
- [ ] Required fields are validated before launch.
- [ ] Campaign can be saved as Draft.
- [ ] Valid campaign can be launched or scheduled according to agreed MVP scope.
- [ ] Downstream recipient preparation receives one valid launch request.
- [ ] Duplicate launch requests are prevented.
- [ ] Permissions work as expected.
- [ ] Logs and audit events are created.
- [ ] Existing Email campaign/template functionality passes regression checks.
- [ ] QA testing is completed.
- [ ] Documentation / linked Jira tasks are updated if required.
- [ ] PO / BSA accepted the Story.
