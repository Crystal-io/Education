# Epic: SMS Campaign Delivery Pipeline с персонализированными короткими ссылками

## 1. Summary / Краткое описание

Реализовать end-to-end pipeline для запуска SMS-кампаний из CRM с персонализированными короткими ссылками, batch processing, отправкой через SMS Router и отслеживанием delivery / click performance.

Ключевая идея Epic: дать CRM / Marketing & Retention команде управляемый, масштабируемый и контролируемый механизм запуска SMS-кампаний без ручной координации между несколькими сервисами.

---

## 2. Business Goal / Problem

- CRM / M&R команде нужен масштабируемый способ запускать персонализированные SMS-кампании.
- Текущий процесс зависит от нескольких систем и требует ручной координации.
- Для каждой ссылки нужна привязка к игроку, чтобы отслеживать клики и эффективность кампании.
- Внешние сервисы имеют ограничения по batch size, RPS / RPM и доступности.
- Система должна снижать риски дубликатов, ошибок доставки и compliance issues.

---

## 3. Product Outcome

После реализации Epic:

- CRM Manager может настроить и запустить SMS-кампанию с campaign long URL.
- Система подготавливает персонализированные short links для eligible recipients.
- Получатели обрабатываются batch-ами без перегрузки Slimlink и SMS Router.
- SMS отправляются через утвержденный SMS Router.
- CRM / Operations могут видеть статусы доставки, клики и ошибки pipeline.

---

## 4. Business Value

| Value Area | Business Value |
|---|---|
| Campaign efficiency | CRM-команда быстрее запускает кампании и меньше зависит от ручной координации. |
| Player engagement | Персонализированные ссылки ведут игроков на релевантные promo / reactivation pages. |
| Performance tracking | Delivery и click statistics позволяют оценивать эффективность кампаний. |
| Operational reliability | Batching, retry и idempotency снижают риск failed / duplicated sends. |
| Compliance and control | URL validation, audit и consent checks снижают regulatory / reputational risks. |

---

## 5. Success Metrics / KPI

| Metric | Target / Expected Result |
|---|---|
| Campaign launch time | Запуск кампании становится стандартизированным и менее ручным. |
| SMS processing throughput | Pipeline поддерживает high-volume campaigns через batch processing. |
| Short link preparation success rate | Высокий success rate для валидных кампаний. |
| Duplicate SMS sends | 0 дубликатов, вызванных retry / reprocessing. |
| Delivery & click tracking coverage | Delivery status и click stats доступны на уровне кампании. |

---

## 6. Stakeholders and Owners

| Role | Responsibility |
|---|---|
| Business Owner / CRM Lead | Определяет бизнес-цели кампаний и expected outcome. |
| Product Owner | Управляет scope, приоритетами и release decisions. |
| Lead BSA / BSA | Ведет discovery, requirements, Jira decomposition, AC и alignment между командами. |
| Tech Lead / Architect | Определяет technical solution, integration approach и scalability constraints. |
| QA / Operations / Compliance | Проверяют качество, мониторинг, ошибки, consent и GDPR constraints. |

---

## 7. Users / Roles Affected

| Role | Impact |
|---|---|
| CRM Manager | Настраивает и запускает SMS-кампании, смотрит результаты. |
| Marketing & Retention Manager | Использует кампании для engagement, reactivation и promotions. |
| Operations User | Мониторит pipeline health, failed batches, retries и integration errors. |
| System Actor: Slimlink | Предоставляет / назначает personalized short links и click statistics. |
| System Actor: SMS Router | Отправляет SMS и возвращает delivery statuses. |

---

## 8. Scope

### In Scope

- SMS campaign launch flow из CRM.
- Campaign long URL input и allowed domain / URL validation.
- Eligible recipient batch preparation.
- Personalized short link assignment через Slimlink.
- SMS sending, delivery tracking, click statistics, logging и error handling.

### Out of Scope

- Email / Push / Telegram campaigns.
- Full marketing segmentation engine redesign.
- New SMS provider onboarding.
- Advanced A/B testing и attribution model.
- Full BI dashboard replacement.

---

## 9. High-Level Functional Requirements

| FR ID | Requirement |
|---|---|
| FR-001 | System shall allow CRM Manager to configure SMS campaign with message text and campaign long URL. |
| FR-002 | System shall validate campaign URL against allowed domains before launch. |
| FR-003 | System shall identify eligible recipients and process them in batches. |
| FR-004 | System shall assign personalized short links and prepare SMS payloads. |
| FR-005 | System shall send SMS through SMS Router and provide delivery / click statistics. |

---

## 10. High-Level Business Rules

| BR ID | Rule |
|---|---|
| BR-001 | SMS campaign cannot be launched without message text, campaign long URL and selected audience. |
| BR-002 | Campaign URL must belong to allowed / whitelisted domain. |
| BR-003 | Only players with valid phone number and SMS consent can be included. |
| BR-004 | Each eligible player should receive only one SMS per campaign unless manual reprocessing is approved. |
| BR-005 | Retryable and non-retryable errors must be handled according to configured error policy. |

---

## 11. High-Level NFR

| Category | Requirement |
|---|---|
| Performance / Scalability | Pipeline must support high-volume campaigns through configurable batching and throttling. |
| Reliability | Retry and idempotency must prevent duplicate SMS sending. |
| Security | Sensitive player data must not be exposed in logs, callbacks or unauthorized UI. |
| Compliance | SMS sending must respect consent, GDPR and regional communication rules. |
| Monitoring / Audit | Critical actions, failures, retries and statuses must be logged and observable. |

---

## 12. Impacted Systems / Components

| System / Component | Impact |
|---|---|
| CRM Campaign Management | New / updated campaign launch flow. |
| Player Info / Player Profile | Source of player identifiers, phone numbers and consent data. |
| Campaign Processing Service | Batch preparation, orchestration, retry and idempotency logic. |
| Slimlink | Personalized short link assignment and click tracking. |
| SMS Router / Sender | SMS delivery and delivery status processing. |

---

## 13. Integrations

| Integration | Type | Purpose |
|---|---|---|
| CRM → Campaign Processing Service | Sync | Launch campaign and submit campaign configuration. |
| Campaign Processing Service → Player Info | Sync / Async | Get eligible recipients and required player data. |
| Campaign Processing Service → Slimlink | Sync / Batch | Assign personalized short links with rate-limit control. |
| Campaign Processing Service → SMS Router | Sync / Async | Submit prepared SMS payloads for delivery. |
| SMS Router / Slimlink → Campaign Processing Service | Async callback / event | Return delivery statuses and click statistics. |

---

## 14. Data Impact

| Object | Description |
|---|---|
| Campaign | Stores campaign metadata, URL, status and configuration. |
| Campaign Recipient | Stores recipient-level processing and delivery status. |
| Campaign Batch | Stores batch-level processing status, retries and errors. |
| Short Link Assignment | Stores mapping between campaignId, playerId / extId and short URL. |
| Click / Delivery Statistics | Stores delivery result and click performance data. |

---

## 15. UX / UI Impact

| Area | Expected Change |
|---|---|
| Campaign creation form | Add / update SMS campaign long URL field. |
| Campaign validation | Show clear error if URL is invalid or not allowed. |
| Campaign status page | Show processing, sent, delivered, failed and pending statuses. |
| Campaign analytics page | Show delivery and click statistics. |
| Error visibility | Show user-friendly failure reason where applicable. |

---

## 16. Dependencies

| Dependency | Owner / Area |
|---|---|
| Slimlink API contract and rate limits | Slimlink / Backend |
| SMS Router payload and delivery status contract | SMS Router Team |
| Player eligibility and consent rules | CRM / Compliance / Player Info |
| Allowed domain list | CRM / Security / Domain Service |
| Monitoring and alerting setup | DevOps / Operations |

---

## 17. Risks

| Risk | Mitigation |
|---|---|
| Slimlink rate limits are exceeded | Configurable batching, throttling and retry policy. |
| Duplicate SMS messages are sent during retry | Idempotency key based on campaignId + playerId / extId. |
| Invalid / non-approved URL is sent to players | Allowed domain / URL whitelist validation before launch. |
| Large campaign overloads downstream services | Async batch processing and queue-based throttling. |
| GDPR / consent rules are applied incorrectly | Eligibility filtering and compliance review before release. |

---

## 18. Assumptions

- Recipients are selected before pipeline processing starts.
- Player Info contains playerId, phone number and consent flags.
- Slimlink supports batch-based short link assignment.
- SMS Router is the approved delivery channel.
- Campaign processing is asynchronous for large recipient lists.

---

## 19. Rollout / Release Strategy

- Release behind feature flag for selected CRM users / markets.
- Start with limited pilot campaign.
- Validate URL checks, Slimlink integration, SMS delivery and reporting.
- Monitor errors, retries, queue lag and delivery status coverage.
- Gradually increase audience size after successful pilot.

---

## 20. Analytics / Monitoring

| Metric / Event | Purpose |
|---|---|
| sms_campaign_launched | Track campaign launch. |
| sms_sent_to_router | Track SMS submission. |
| sms_delivery_status_updated | Track delivery result. |
| short_link_clicked | Track player engagement. |
| queue_lag / retry_count / error_rate | Monitor pipeline stability and external service issues. |

---

## 21. Linked Documentation

| Document | Location |
|---|---|
| Business / Product Requirements | Confluence or Epic link. |
| System / Integration Requirements | Jira Stories / Tasks + Confluence overview. |
| Sequence Diagram / Data Flow | Confluence / diagram link. |
| API Contracts: Slimlink and SMS Router | Swagger / Confluence / Jira link. |
| Error Matrix / Decision Log | Confluence or linked Jira artifact. |

---

## 22. Child Issues

| Issue Type | Title | Scope |
|---|---|---|
| Story | CRM Manager can configure and launch SMS campaign with campaign long URL, so that personalized retention campaigns can be launched from CRM. | MVP |
| Story | System can validate campaign URL against allowed domain list, so that unauthorized or non-compliant links are not sent to players. | MVP |
| Story | System can assign personalized short links to recipients, so that clicks can be tracked per player / campaign. | MVP |
| Story | System can send prepared SMS messages through SMS Router, so that campaign messages are delivered via approved channel. | MVP |
| Story | CRM Manager can view delivery and click statistics, so that campaign performance can be evaluated. | MVP |

---

## 23. Open Questions

| Question | Owner |
|---|---|
| What is the maximum campaign audience size for MVP? | Product Owner / CRM Lead |
| Should campaign scheduling be supported in MVP? | Product Owner |
| What exact consent rules apply per region? | Compliance / CRM |
| What are final Slimlink batch size and rate limits? | Slimlink / Backend |
| Which SMS Router statuses should be mapped to CRM campaign statuses? | SMS Router Team / BSA |

---

## 24. Epic Definition of Ready

- Business goal and product outcome are clear.
- In Scope / Out of Scope are agreed.
- Main integrations, dependencies and risks are identified.
- MVP child Stories are defined.
- Open questions have owners.

---

## 25. Epic Definition of Done

- MVP child Stories are delivered and accepted.
- CRM Manager can launch SMS campaign with campaign long URL.
- Recipients are processed in batches, short links are assigned, and SMS messages are sent via SMS Router.
- Delivery statuses and click statistics are visible where supported.
- Retry, idempotency, logging, monitoring and compliance checks are implemented.
