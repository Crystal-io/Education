# Task: Add SMS Campaign Type to Existing Campaign / Template Flow

## 1. Context

This Task supports the Story **Configure and Launch SMS Campaign** under the Epic **SMS Campaign Delivery Pipeline with SlimLink Short Links**.

The CRM already has campaign and template management functionality for **Email** campaigns. The goal is not to build a separate SMS campaign module from scratch, but to extend the existing campaign/template flow by adding **SMS** as a new communication type.

SMS has channel-specific constraints that differ from Email:

- SMS content is plain text, not HTML.
- Images, banners, attachments and rich email components are not supported.
- SMS message editing requires character count and basic segment awareness.
- SMS templates should support campaign URL / short-link placeholder usage.
- SMS launch must follow channel availability, permissions and validation rules.

Detailed SMS encoding, exact segment calculation, market-specific sender rules and advanced UI polishing may be handled in separate Tasks or follow-up Stories.

---

## 2. Objective

Enable the existing CRM campaign creation and template flow to support **SMS** as a new communication type, with SMS-specific editor mode, validation and launch readiness checks.

As a result:

- CRM Manager can select `SMS` when creating a campaign.
- CRM displays SMS-specific template/editor behavior.
- Email-specific HTML/rich content is not available for SMS.
- SMS campaign can be saved as Draft and submitted to downstream recipient preparation after validation.
- Existing campaign lifecycle, permissions, logging and audit mechanisms are reused where possible.

---

## 3. Task Type

- [x] Technical implementation
- [x] Analysis
- [ ] Spike / Research
- [x] Configuration
- [ ] Infrastructure / DevOps
- [ ] Data / Migration
- [ ] API / Integration
- [x] QA / Test preparation
- [x] Documentation
- [ ] Support / Operations
- [ ] Other:

---

## 4. Scope

### In Scope

- Add `SMS` as a supported campaign communication type where the SMS channel is enabled.
- Reuse the existing campaign creation and template management flow.
- Add SMS-specific editor mode based on plain text content.
- Hide or disable Email-specific HTML / image / rich content controls for SMS.
- Add basic character count display during SMS text editing.
- Add required-field validation for SMS campaign launch.
- Support SMS template creation / selection within the existing template model where applicable.
- Support campaign URL / short-link placeholder configuration at a high level.
- Add feature flag or configuration to control SMS campaign availability.
- Add logging / audit events for SMS campaign create, edit, validation failure and launch.
- Prepare QA scenarios for SMS-specific UI and validation behavior.

### Out of Scope

- Full redesign of the campaign module.
- Full replacement of the Email template editor.
- Exact SMS encoding and segment billing rules if they require separate business confirmation.
- SlimLink API payload implementation.
- Recipient batching and privacy-safe recipient reference generation.
- SMS Router integration.
- Delivery status reporting.
- Click analytics reporting.
- Advanced A/B testing, attribution or BI dashboards.

---

## 5. Expected Output

- `SMS` campaign type is available in the existing campaign creation flow where enabled.
- SMS editor is shown in plain text mode.
- Unsupported Email-specific content controls are hidden or disabled for SMS campaigns.
- Character count is visible while editing SMS content.
- SMS campaign validation rules are applied before launch.
- Valid SMS campaign can move to downstream recipient preparation.
- Invalid SMS campaign remains Draft / Validation Failed with clear user-facing errors.
- QA checklist / test cases cover main UI and validation scenarios.
- Related Story and documentation are updated.

---

## 6. Technical Details

| Area | Details |
|---|---|
| Component / Service | CRM Campaign Management, Template Management, Campaign UI, Campaign API / Backend validation |
| Repository | CRM frontend and CRM backend repositories, exact names TBD |
| Environment | Dev / QA / Staging / Production |
| Config changes | Add / update channel configuration for `SMS`; add feature flag if required |
| DB changes | Add or reuse communication type value `SMS`; confirm whether template/channel enum requires migration |
| API changes | Update internal campaign create/update/launch contracts if they use channel/type enum |
| Event changes | Existing campaign events should include communication type `SMS`; add SMS-specific events only if required |
| Feature flag | `sms_campaign_enabled` or equivalent tenant/market configuration |
| Monitoring | Track SMS campaign creation, validation failure and launch events |

---

## 7. Implementation Notes

- Reuse existing Email campaign flow where the structure is channel-agnostic: campaign name, owner, status, audience selection, draft/save/launch lifecycle.
- Do not reuse Email HTML editor directly for SMS content.
- SMS editor should be a simplified plain text editor.
- SMS content should not support images, attachments, banners, HTML blocks or rich email components.
- Character count should be visible near the SMS editor.
- Exact segment calculation and GSM/Unicode encoding logic should be confirmed separately if business wants billing-level accuracy.
- Existing permissions should be extended to cover SMS campaigns.
- Existing audit/logging model should include SMS campaign actions.
- Existing campaign lifecycle should be reused unless SMS requires a specific status transition.
- Launch action should be protected from double-click / repeated browser request to avoid duplicate downstream launch requests.

---

## 8. API / Integration Details

- **System:** CRM Campaign Management
- **Endpoint / topic / event:** Existing internal campaign create/update/launch endpoints or events, exact names TBD
- **Contract link:** Related Story / internal API documentation
- **Request / response:** Add or support campaign type `SMS`; detailed payload changes are implementation-level and should be documented in linked API Task if needed
- **Error handling:** Return validation errors for missing/invalid SMS-specific fields
- **Retry:** Not applicable for UI validation; launch request must be protected from duplicate submission
- **Idempotency:** Launch action should not create multiple downstream requests for the same campaign/action
- **Timeout:** Use existing CRM campaign API timeout rules
- **Fallback:** If SMS channel is disabled or unavailable, hide SMS type or block launch with clear message

---

## 9. Data / DB Details

- **New table / field:** Not expected unless current model cannot support communication type `SMS`.
- **Changed table / field:** Campaign and template entities may need to support `communicationType = SMS` or equivalent enum value.
- **Migration:** Required only if communication type is stored as a strict enum or lookup table.
- **Backfill:** Not required for existing Email campaigns.
- **Data validation:** Existing Email templates must not be treated as valid SMS templates unless converted/adapted to plain text.
- **Rollback:** Disable SMS feature flag / channel configuration; do not affect existing Email campaigns.

---

## 10. Access / Credentials

- **Required access:** CRM Campaign Management configuration, Template Management configuration, feature flag / tenant setting access.
- **Secrets / credentials:** Not required for this Task.
- **Environment variables:** Feature flag / channel availability configuration if applicable.
- **Who provides access:** Product Owner / CRM Admin / DevOps depending on current setup.
- **Security notes:** Only authorized users should be able to create, edit and launch SMS campaigns.

---

## 11. Logging / Monitoring

| Area | Requirement |
|---|---|
| Logs to add/update | Campaign create/update/launch logs should include `communicationType = SMS`. |
| Metrics | SMS campaign created count, SMS validation failure count, SMS campaign launch count. |
| Alerts | Not required for this UI-level Task unless validation failures spike unexpectedly after release. |
| Dashboard | Existing campaign dashboard may be extended with SMS channel filter. |
| Correlation ID | Launch request should include requestId / correlationId where existing flow supports it. |
| Error visibility | User-facing validation errors should be clear and actionable. |

---

## 12. Security / Compliance

| Area | Requirement |
|---|---|
| Permission checks | Only authorized CRM users can create, edit and launch SMS campaigns. |
| Sensitive data | No player-level personal data is handled in this Task. |
| PII impact | No PII should be exposed in campaign template/editor flow. |
| Encryption / masking | Not applicable for SMS template content unless business treats content as sensitive. |
| Compliance notes | SMS campaign launch must later connect to consent and eligibility checks; this Task only enables channel configuration and campaign setup. |

---

## 13. Completion Criteria / Acceptance Criteria

### AC-001: SMS type is available where enabled

Given SMS channel is enabled for tenant / market,  
When CRM Manager opens campaign creation flow,  
Then `SMS` is available as communication type.

### AC-002: SMS type is hidden or blocked where disabled

Given SMS channel is disabled for tenant / market,  
When CRM Manager opens campaign creation flow or attempts to launch SMS campaign,  
Then SMS creation is not available or launch is blocked with clear explanation.

### AC-003: SMS editor uses plain text mode

Given CRM Manager selects `SMS`,  
When campaign editor is displayed,  
Then SMS content field supports plain text content,  
And Email-specific HTML/image/rich content controls are not available.

### AC-004: Character count is visible

Given CRM Manager edits SMS content,  
When text is entered or changed,  
Then system displays current character count.

### AC-005: Required field validation works

Given CRM Manager attempts to launch SMS campaign,  
When required campaign fields are missing or invalid,  
Then launch is blocked,  
And validation messages are displayed.

### AC-006: Valid SMS campaign can be submitted downstream

Given SMS campaign configuration is valid,  
When CRM Manager launches the campaign,  
Then system creates one downstream launch request for recipient preparation,  
And campaign status changes according to existing lifecycle rules.

### AC-007: Duplicate launch request is prevented

Given CRM Manager triggers launch action more than once,  
When the same campaign launch is already being processed,  
Then system does not create duplicate downstream launch requests.

---

## 14. Dependencies

| Dependency | Owner | Status |
|---|---|---|
| Existing campaign/template management flow | CRM Team | Existing |
| SMS channel availability rules | Product Owner / CRM Lead | To be confirmed |
| SMS-specific content restrictions | Product Owner / BSA / UX | To be confirmed |
| Character count / segment policy | Product Owner / BSA | Basic count in scope; detailed segment logic TBD |
| Campaign lifecycle rules | CRM Team | Existing / to be reused |
| Permission model | CRM Team / Security | Existing / to be extended if needed |
| Related Story: Configure and Launch SMS Campaign | BSA / Product Owner | Defined |

---

## 15. Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Email editor is reused without SMS restrictions | Invalid SMS content may be created | Use dedicated plain text mode for SMS. |
| Exact SMS segment calculation is not confirmed | Incorrect user expectations or cost estimation | Keep basic character count in this Task; create separate Task for billing-accurate segment calculation if needed. |
| SMS type becomes available in unsupported market | Compliance / operational issue | Control availability by tenant/market/channel configuration. |
| Existing Email campaign flow is broken by channel changes | Regression impact | Use feature flag and run regression tests for Email campaigns. |
| Duplicate launch request is created | Downstream duplicate processing | Add UI protection and backend duplicate-prevention for launch request. |
| Users try to reuse Email templates directly | Poor content quality / invalid SMS | Block direct use or require plain text adaptation. |

---

## 16. Test / Verification Plan

- Verify SMS type is visible only when enabled.
- Verify SMS type is hidden or blocked when disabled.
- Verify SMS editor does not show Email HTML/image/rich content controls.
- Verify plain text SMS content can be entered and saved.
- Verify character count updates when text changes.
- Verify missing required fields block launch.
- Verify valid SMS campaign can be saved as Draft.
- Verify valid SMS campaign can be launched and passed to recipient preparation.
- Verify repeated launch action does not create duplicate downstream request.
- Verify existing Email campaign creation and template editing are not broken.
- Verify permission restrictions for create/edit/launch.
- Verify audit/log records are created for SMS campaign actions.

### Test Data

- Tenant / market with SMS enabled.
- Tenant / market with SMS disabled.
- User with campaign create/edit/launch permissions.
- User without launch permission.
- Valid SMS template content.
- Invalid SMS content containing HTML / image-like content.
- Campaign with valid and invalid audience configuration.

### Expected Evidence

- Screenshots of SMS campaign type and SMS editor.
- Validation screenshots.
- API/log evidence that launch request is created once.
- QA test run results.
- Regression confirmation for Email campaign flow.

---

## 17. Documentation Impact

- **Confluence page to update:** Campaign Management / Communication Channels overview.
- **Swagger / OpenAPI:** Update internal campaign API docs if communication type enum changes.
- **Runbook:** Not required for this Task unless SMS channel enablement requires operational steps.
- **Release notes:** Mention SMS campaign type availability and limitations.
- **Not required because:** Detailed SlimLink and SMS Router integration docs are covered by separate Stories / Tasks.

---

## 18. Open Questions

| Question | Owner | Due date | Status |
|---|---|---|---|
| Should SMS be available for all tenants or only selected brands/markets? | Product Owner | TBD | Open |
| Should campaign scheduling be available for SMS in MVP if it exists for Email? | Product Owner | TBD | Open |
| Should SMS editor show only character count or also estimated SMS segments? | Product Owner / BSA | TBD | Open |
| Should existing Email templates be convertible to SMS plain text templates? | Product Owner / UX | TBD | Open |
| Should SMS templates support localization in MVP? | Product Owner | TBD | Open |
| What exact user-facing message should be shown when SMS channel is disabled? | UX / BSA | TBD | Open |

---

## 19. Links

- **Parent Epic:** SMS_01_Epic.md
- **Related Story:** SMS_02_Story_Configure_And_Launch_Campaign.md
- **Confluence:** Campaign Management / Communication Channels overview — TBD
- **API spec:** Internal Campaign API — TBD if changed
- **Pull request:** TBD
- **Test cases:** TBD

---

## 20. Task Definition of Ready

- [x] Objective is clear
- [x] Context is clear
- [x] Expected output is defined
- [x] Technical scope is clear
- [x] Completion criteria are defined
- [ ] Required access/credentials are known
- [x] Dependencies are identified
- [x] Required documentation/specs are linked or listed
- [ ] Task is estimated or timeboxed

---

## 21. Task Definition of Done

- [ ] `SMS` campaign type is implemented or configured where enabled
- [ ] SMS editor plain text mode is available
- [ ] Email-specific rich content controls are not available for SMS
- [ ] Character count is visible during SMS editing
- [ ] SMS required-field validation works
- [ ] Valid SMS campaign can be saved as Draft
- [ ] Valid SMS campaign can be launched and passed downstream
- [ ] Duplicate launch request prevention is implemented
- [ ] Permissions are verified
- [ ] Logs / audit events are updated
- [ ] Email campaign regression is checked
- [ ] QA verification is completed
- [ ] Related Story / documentation is updated if required
- [ ] No unresolved blocker remains
