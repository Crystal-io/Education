# Epic: SMS Campaign Delivery Pipeline with SlimLink Short Links

## Краткое назначение документа

Сокращенная версия Epic для интервью.  
Фокус: показать, как BSA структурирует сложную CRM-интеграцию в рамках SDLC — от бизнес-цели и discovery до Jira-декомпозиции, NFR, рисков и delivery.

---

## 1. Summary

Реализовать end-to-end pipeline для запуска SMS-кампаний из CRM с персонализированными короткими ссылками SlimLink.

Epic покрывает:

- настройку и запуск SMS-кампании из CRM;
- подготовку eligible recipients;
- получение персональных коротких ссылок через SlimLink;
- отправку SMS через утвержденный SMS Router;
- отображение delivery status и click statistics.

---

## 2. Business Goal / Problem

CRM / Marketing & Retention команде нужен масштабируемый и контролируемый способ запускать SMS-кампании для retention, reactivation и promo-коммуникаций.

Основная проблема не в самой отправке SMS, а в том, что нужно:

- связать несколько систем: CRM, Player Info, SlimLink, SMS Router, monitoring/reporting;
- обрабатывать большие списки игроков без перегрузки внешних сервисов;
- выдавать каждому игроку уникальную короткую ссылку для tracking;
- исключить дублирующую отправку SMS при retry/reprocessing;
- обеспечить compliance, consent checks и прозрачность статусов кампании.

---

## 3. Product Outcome

После реализации Epic:

- CRM Manager может запустить SMS-кампанию с long URL и выбранной аудиторией;
- система фильтрует eligible players по данным игрока, номеру телефона и SMS consent;
- SlimLink назначает персональные короткие ссылки из hot cache;
- SMS отправляются через SMS Router только для валидных recipients;
- CRM Manager видит delivery status и доступную click analytics.

---

## 4. Business Value

| Value Area | Business Value |
|---|---|
| Campaign efficiency | CRM-команда быстрее запускает персонализированные SMS-кампании без ручной координации между командами. |
| Player engagement | Персональные короткие ссылки ведут игроков на нужные promo / reactivation pages. |
| Performance tracking | Delivery и click data позволяют оценивать эффективность кампаний. |
| Operational reliability | Batching, throttling и retry logic снижают риск ошибок и дублей. |
| Compliance & control | Consent checks, URL/domain validation и audit trail снижают regulatory и reputational risks. |

---

## 5. Epic-Level SlimLink Alignment

Важные решения, согласованные с SlimLink source of truth:

- SlimLink не генерирует ссылки “с нуля” в момент запроса, а назначает path из hot cache и возвращает короткую ссылку CRM.
- CRM должна отправлять recipients в controlled batches с учетом ограничений SlimLink.
- CRM отвечает за URL/domain validation до обращения в SlimLink, так как SlimLink не валидирует `long_url`.
- Повторное использование `external_id` на стороне SlimLink возвращает ошибку, поэтому duplicate prevention и retry logic должны контролироваться CRM.
- SlimLink хранит click analytics, но способ доставки этих данных в CRM должен быть отдельно согласован.

---

## 6. Scope

### In Scope

- SMS campaign launch flow из CRM.
- URL/domain validation до short link allocation.
- Recipient eligibility filtering: phone number, SMS consent, campaign audience.
- Batch processing и SlimLink short link allocation.
- SMS submission через SMS Router.
- Delivery status и click statistics на уровне кампании.
- Error handling, retries, audit и monitoring.

### Out of Scope

- Email / Push / Telegram campaigns.
- Full segmentation engine redesign.
- New SMS provider onboarding.
- Advanced A/B testing и attribution model.
- Полное описание API payloads внутри Epic.

---

## 7. High-Level Functional Requirements

| FR ID | Requirement |
|---|---|
| FR-001 | System shall allow CRM Manager to configure and launch SMS campaign with audience, message text and long URL. |
| FR-002 | System shall validate campaign URL/domain rules before requesting short links from SlimLink. |
| FR-003 | System shall prepare eligible recipients based on player data, phone number and SMS consent. |
| FR-004 | System shall process recipients in SlimLink-compatible batches. |
| FR-005 | System shall allocate personalized short links via SlimLink and store recipient-to-link mapping. |
| FR-006 | System shall send SMS only for recipients with successfully allocated short links. |
| FR-007 | System shall process delivery statuses from SMS Router. |
| FR-008 | System shall show campaign-level delivery status and available click statistics. |

---

## 8. High-Level Business Rules

| BR ID | Rule |
|---|---|
| BR-001 | Campaign cannot be launched without message text, audience and valid long URL. |
| BR-002 | Only players with valid phone number and SMS consent can be included. |
| BR-003 | Each recipient should receive only one SMS per campaign unless authorized reprocessing is used. |
| BR-004 | Recipients without successfully allocated short links must not receive SMS. |
| BR-005 | Partial SlimLink failures must not block successful recipients from further processing. |
| BR-006 | Campaign status must reflect actual processing state: Draft, Processing, Partially Failed, Completed, Failed, Cancelled. |

---

## 9. High-Level NFR

| Category | Requirement |
|---|---|
| Performance | Pipeline must support high-volume SMS campaigns through batching. |
| Scalability | CRM must respect SlimLink batch and rate limits and support gradual scale-up. |
| Reliability | CRM-side retry and duplicate-prevention logic must prevent duplicate SMS sends. |
| Availability | Temporary SlimLink / SMS Router issues must not cause campaign state loss. |
| Security | SlimLink credentials must be securely stored; access may be restricted by IP whitelist. |
| Compliance | Processing must respect SMS consent, GDPR and regional communication rules. |
| Observability | Logs and metrics must include campaignId, batchId and correlationId. |

---

## 10. Impacted Systems

| System | Impact |
|---|---|
| CRM Campaign Management | New / updated SMS campaign launch flow. |
| Player Info | Source of player identifiers, phone numbers and consent flags. |
| Campaign Processing Service | Eligibility filtering, batching, SlimLink orchestration and retry control. |
| SlimLink | Short link allocation and click analytics storage. |
| SMS Router | SMS delivery and delivery status processing. |
| Monitoring / Reporting | Campaign metrics, failures, retries and operational visibility. |

---

## 11. Integrations

| Integration | Type | Purpose |
|---|---|---|
| CRM → Campaign Processing Service | Sync | Launch campaign and create processing request. |
| Campaign Processing → Player Info | Sync / Async | Retrieve eligible recipients and required player data. |
| Campaign Processing → SlimLink | Sync bulk | Allocate personalized short links in controlled batches. |
| Campaign Processing → Queue / Broker | Async | Process large recipient lists reliably. |
| Campaign Processing → SMS Router | Sync / Async | Submit prepared SMS payloads. |
| SMS Router → CRM | Async callback / event | Return delivery statuses. |
| SlimLink → CRM Reporting | TBD | Provide click analytics when integration mechanism is confirmed. |

---

## 12. Main Risks

| Risk | Impact | Mitigation |
|---|---|---|
| SlimLink limits are exceeded | Campaign delay / failures | Configurable batching, throttling, retry policy. |
| Duplicate SMS sending | Bad user experience / complaints | CRM-side duplicate prevention before SMS Router submission. |
| Invalid URL or domain | Broken / non-compliant links sent to players | CRM-side URL/domain validation before SlimLink request. |
| Partial batch failures | Incorrect campaign status / lost recipients | Record-level outcome processing and Partially Failed status. |
| Click analytics mechanism unclear | Reporting gap | Clarify callback/API/export approach before committing MVP scope. |
| Consent rules applied incorrectly | Compliance risk | Compliance review and eligibility test cases. |

---

## 13. Jira / Confluence Split

| Artifact | Location | Purpose |
|---|---|---|
| Epic | Jira | Business capability, scope, systems, risks, NFR, child issues. |
| Story | Jira | Value slice with user story, flow, AC, rules and QA focus. |
| Task | Jira | Technical / integration / configuration / analysis work. |
| Sub-task | Jira | Small executable step: config, access, topic, metric, Swagger update. |
| Stable documentation | Confluence | Diagrams, integration overview, decision log, cross-cutting NFR. |
| API details | Linked Story / Task / Confluence | Payloads, fields, error codes, mappings, examples. |

---

## 14. MVP Child Stories

| # | Story | User Story |
|---:|---|---|
| 1 | Configure and launch SMS campaign | As a CRM Manager, I want to launch SMS campaign with audience, message and long URL, so that I can run personalized retention campaigns. |
| 2 | Validate campaign URL and domain | As a CRM Manager, I want the system to validate URL/domain before launch, so that players do not receive broken or unauthorized links. |
| 3 | Prepare eligible player batches | As the CRM System, I want to prepare eligible recipients, so that only players with valid phone and SMS consent are processed. |
| 4 | Allocate short links via SlimLink | As the CRM System, I want to allocate personalized short links in batches, so that campaign engagement can be tracked per recipient. |
| 5 | Handle SlimLink failures | As an Operations User, I want to see failed records and error categories, so that partial failures can be investigated safely. |
| 6 | Send SMS through SMS Router | As the CRM System, I want to send prepared SMS messages through SMS Router, so that delivery is performed through the approved channel. |
| 7 | Prevent duplicate SMS sending | As a CRM Manager, I want duplicate SMS sending to be prevented, so that players are not spammed during retries. |
| 8 | View delivery status | As a CRM Manager, I want to view delivery status, so that I can evaluate campaign reach and failed deliveries. |
| 9 | View click statistics | As a CRM Manager, I want to view click statistics, so that I can measure campaign engagement. |

---

## 15. Epic Definition of Ready

Epic is ready when:

- business goal, product outcome and MVP scope are agreed;
- impacted systems and stakeholders are identified;
- SlimLink constraints are reflected at Epic level;
- main risks, dependencies and open questions have owners;
- child Stories / Tasks / Spikes are created or identified;
- detailed API spec is linked, not duplicated inside Epic.

---

## 16. Epic Definition of Done

Epic is done when:

- CRM Manager can launch SMS campaign with long URL and selected audience;
- URL/domain validation works before SlimLink processing;
- eligible recipients are processed in batches;
- short links are allocated and stored per recipient;
- SMS are sent only for valid recipients with successful short links;
- delivery statuses and available click statistics are visible;
- duplicate prevention, logging, audit and monitoring are implemented;
- QA, regression testing and UAT/business review are completed.

---

## 17. Interview Pitch — 2–3 минуты

На проекте я работал над Epic для end-to-end SMS campaign delivery pipeline. Бизнес-задача была в том, чтобы CRM / Marketing & Retention команда могла запускать персонализированные SMS-кампании с короткими ссылками, отслеживать доставку и клики, и при этом не перегружать внешние сервисы.

Я начал с discovery: определил stakeholders, impacted systems и ограничения — CRM, Player Info, SlimLink, SMS Router, consent/compliance и operations. Дальше разложил процесс на high-level flow: выбор аудитории, URL/domain validation, подготовка eligible recipients, batch processing, SlimLink short link allocation, SMS sending, delivery status и click analytics.

Особое внимание было на системных рисках: rate limits SlimLink, partial failures, duplicate SMS during retries, consent rules, monitoring и audit trail. На уровне Epic я оставил business goal, scope, NFR, integrations, risks и child issues, а API payloads, fields и error mappings вынес в linked Stories / Tasks / Confluence, чтобы не перегружать Epic техническими деталями.

В Jira я декомпозировал Epic на user/system stories: launch campaign, validate URL/domain, prepare eligible batches, allocate short links via SlimLink, handle failures, send SMS through Router, prevent duplicates, view delivery status and click statistics. Так команда получила понятный delivery backlog, а требования остались traceable от бизнес-цели до реализации и тестирования.
