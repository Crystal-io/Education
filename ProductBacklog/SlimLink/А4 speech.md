# SMS Campaign Delivery Pipeline — A4 interview cheat sheet

## 1. Project / Context
**Project:** end-to-end SMS Campaign Delivery Pipeline для CRM / Marketing & Retention.

**Коротко:** расширяли существующий campaign / template flow, где уже были Email-кампании, и добавляли новый канал — **SMS**.

**Суть задачи:** не просто “отправить SMS”, а построить контролируемый pipeline:
CRM campaign setup → recipient preparation → personalized short links → SMS Sender / Router → delivery statuses → error handling → monitoring → future scaling.

---

## 2. Business Requirement / Problem
**Business need:** Marketing & Retention команда должна запускать персонализированные SMS-кампании для retention / reactivation / promo.

**Проблема:** нужно связать несколько систем и сделать процесс надежным:
- CRM Campaign Management;
- Player Data Service;
- Campaign Processing Service;
- SlimLink;
- SMS Sender / Router;
- Monitoring / Reporting.

**Ключевые ограничения:** SMS consent, GDPR, PII, SlimLink limits, batching, retry, duplicate SMS, partial failures, status visibility.

---

## 3. Product Outcome
После реализации:
- CRM Manager запускает SMS-кампанию с audience, SMS template и campaign URL;
- система готовит eligible recipients;
- SlimLink назначает персональные short links;
- SMS отправляются через approved SMS Router;
- CRM показывает delivery status и click analytics;
- Operations видит failures, retries, stuck batches, correlation IDs.

---

## 4. High-Level Flow
```text
CRM Manager
  → Configure SMS campaign
  → Select audience + template + campaign URL
CRM System
  → Validate URL/domain + consent rules
Player Data Service
  → Prepare privacy-safe recipientRef / userHash
Campaign Processing
  → Split recipients into batches
  → Request / allocate short links via SlimLink
SMS Sender
  → Resolve phone only at trusted boundary
  → Send SMS through SMS Router
CRM / Reporting
  → Delivery status + click statistics + monitoring
```

---

## 5. Key System Decision
**Не протаскивать PII через весь pipeline.**

Вместо phone / name / email в промежуточных сервисах используется `recipientRef / userHash`.

**Why:**
- меньше compliance risk;
- безопаснее logs;
- проще batching и retry;
- четкая граница ответственности;
- SMS Sender резолвит phone только на последнем trusted boundary.

---

## 6. Epic Level
**Epic:** SMS Campaign Delivery Pipeline with SlimLink Short Links.

**В Epic фиксировал:**
- business goal / product outcome;
- MVP scope / out of scope;
- impacted systems;
- high-level FR / BR / NFR;
- integrations;
- risks / dependencies / open questions;
- child stories / tasks;
- DoR / DoD.

**Принцип:** Epic описывает business capability, а не API payloads. API fields, mappings, error codes — в linked Stories / Tasks / Confluence/API spec.

---

## 7. Main User / System Stories
1. **Configure and Launch SMS Campaign**  
   CRM Manager выбирает SMS campaign type, audience, template, campaign URL.

2. **Prepare Privacy-Safe Recipient Batches**  
   System готовит batches через `recipientRef / userHash`, без PII в pipeline.

3. **Allocate Personalized Short Links and Send SMS**  
   System получает personalized short links, отправляет SMS только для valid recipients.

4. **Handle SlimLink Failures and Partial Results**  
   Failed records не блокируют successful records; ошибки классифицируются.

5. **Prevent Duplicate SMS Sending**  
   Retry / reprocessing не должны привести к повторной отправке одному recipient.

6. **View Delivery Status / Click Statistics**  
   CRM Manager видит campaign result; Operations видит technical health.

---

## 8. Task-Level Decomposition
**Task 1 — Add SMS Campaign Type**
- расширить existing Email campaign/template flow;
- добавить SMS-specific validation;
- убрать Email-only controls: HTML/images etc.

**Task 2 — Define Privacy-Safe Batch Contract**
- определить fields: campaignId, batchId, recipientRef, userHash, locale, template variables;
- исключить PII;
- описать ownership и validation.

**Task 3 — Define Error Handling & Status Mapping**
- retryable / non-retryable errors;
- partial batch failures;
- mapping recipient / batch / campaign statuses;
- duplicate prevention;
- logs, metrics, alerts.

---

## 9. NFR / Risks
**NFR:** performance, scalability, reliability, security, compliance, observability.

**Главные риски:**
- SlimLink rate limits / API failures;
- duplicate SMS during retry;
- invalid URL/domain;
- partial batch failures;
- PII leakage;
- unclear click analytics mechanism;
- incorrect consent rules.

**Mitigation:** batching, throttling, retry policy, CRM-side duplicate prevention, URL/domain validation, audit trail, monitoring, pilot rollout.

---

## 10. SDLC Artifacts
**Discovery:** problem statement, stakeholders, impacted systems, risks, open questions.  
**Requirements:** Epic, FR/BR/NFR, scope, assumptions, acceptance criteria.  
**Solution:** integration overview, data flow, sequence diagram, decision log.  
**Backlog:** Epic → Stories → Tasks → Sub-tasks.  
**QA/UAT:** Given/When/Then AC, edge cases, regression areas, UAT checklist.  
**Release:** feature flag, pilot audience, deployment checklist, rollback notes.  
**Monitoring:** logs, metrics, alerts, failed batches, retry count, queue lag.

---

## 11. Final Interview Message
Мой подход — не просто написать требования, а создать понятную систему работы для команды.

Я начинаю с business goal и outcome, затем выявляю systems, data flows, constraints и risks. После этого структурирую backlog от Epic до Stories и Tasks, фиксирую acceptance criteria, business rules, edge cases, NFR, dependencies и QA focus.

В этом проекте я показал умение работать на стыке BA и SA: связал бизнес-ценность CRM-кампаний с интеграционным pipeline, privacy-safe data flow, error handling, retry logic, monitoring и delivery-ready backlog.

