# Story: Назначить персональные короткие ссылки и отправить SMS через recipientRef

## Краткое назначение

Сокращенная версия Story для интервью.  
Фокус: показать, как система продолжает SMS pipeline после подготовки privacy-safe batches — назначает персональные короткие ссылки и передает SMS на отправку, не протаскивая персональные данные через весь CRM pipeline.

---

## 1. User Story

**As the CRM System**,  
I want to allocate personalized short links for prepared recipient batches and send SMS using recipient references,  
So that each eligible player receives the correct campaign SMS while personal data is resolved only at the final trusted sending boundary.

По-русски:

> Как CRM-система, я хочу назначить персональные короткие ссылки для подготовленных batch-ей и отправить SMS через `recipientRef`, чтобы каждый eligible player получил правильное сообщение, а персональные данные раскрывались только на финальном trusted boundary перед отправкой.

---

## 2. Контекст

Эта Story продолжает предыдущую Story про подготовку privacy-safe recipient batches.

На входе у нас уже есть:

- запущенная SMS campaign;
- подготовленные batches с `recipientRef / userHash`;
- message text / SMS template;
- campaign long URL;
- валидная URL/domain configuration;
- eligibility и SMS consent уже проверены на этапе подготовки batch.

Цель этой Story — провести recipient batch через две ключевые стадии:

1. назначить персональную короткую ссылку через SlimLink;
2. создать SMS sending job и передать его в Sender без phone number / name / email.

---

## 3. Главная идея решения

Лучший подход — **не передавать персональные данные через pipeline вообще**.

Вместо этого:

- CRM работает с `recipientRef`;
- SlimLink получает только безопасный recipient-level identifier и campaign URL context;
- CRM сохраняет связь `campaignId + batchId + recipientRef + shortUrl`;
- SMS job содержит `recipientRef`, short link и campaign context;
- финальный SMS Sender резолвит `recipientRef` в phone number только в trusted boundary;
- промежуточные сервисы, очереди, логи и monitoring не видят PII.

Это лучше, чем передавать encrypted PII через все модули, потому что даже зашифрованные данные всё равно создают нагрузку на key management, access control, logging policy и compliance.

---

## 4. Main Flow

1. Campaign Processing Service получает prepared batch с `recipientRef`.
2. Проверяет, что campaign активна и готова к downstream processing.
3. Отправляет batch в SlimLink для short link allocation.
4. SlimLink возвращает успешные и/или failed results.
5. CRM сохраняет mapping между `recipientRef` и short URL.
6. Для успешных recipients создается SMS sending job.
7. SMS job содержит `recipientRef`, campaign context, message text / template reference и short URL.
8. Phone number, name, email и другие PII в job не передаются.
9. SMS Sender получает job и резолвит `recipientRef` через Player Data Service.
10. Sender делает финальную проверку актуального contact state / eligibility.
11. Sender отправляет SMS через утвержденный SMS Router.
12. CRM обновляет статусы campaign / batch / recipient.

---

## 5. Business Rules

| BR ID | Rule |
|---|---|
| BR-001 | SMS нельзя отправлять, если для recipient не была успешно назначена short link. |
| BR-002 | SMS нельзя отправлять, если `recipientRef` не удалось резолвить на финальном sender boundary. |
| BR-003 | Phone number / name / email не должны передаваться через intermediate CRM modules, queues, SlimLink integration и monitoring. |
| BR-004 | Partial failures не должны блокировать успешных recipients. |
| BR-005 | Retry не должен приводить к повторной отправке SMS одному и тому же recipient. |
| BR-006 | Если recipient стал ineligible перед финальной отправкой, SMS не отправляется. |
| BR-007 | Operational investigation должна идти через safe identifiers и correlationId, а не через PII. |

---

## 6. Acceptance Criteria

### AC-001: Обработка batch без PII

Given prepared recipient batch contains `recipientRef`,  
When downstream processing starts,  
Then system processes the batch without phone numbers, names, emails or other direct PII.

### AC-002: Назначение коротких ссылок

Given recipient batch is valid,  
When system requests short link allocation,  
Then successful recipients receive personalized short URLs,  
And CRM stores mapping between campaignId, batchId, recipientRef and shortUrl.

### AC-003: Не отправлять SMS без short link

Given short link allocation failed for a recipient,  
When SMS jobs are created,  
Then no SMS job is created for this recipient.

### AC-004: Partial failure не блокирует batch

Given SlimLink returns mixed success and failed records,  
When CRM processes the result,  
Then successful recipients continue to SMS sending,  
And failed recipients are marked with a failure reason.

### AC-005: Отправка через recipientRef

Given SMS job is created for a successful recipient,  
When job is passed to SMS Sender,  
Then it contains `recipientRef` and safe campaign data,  
And does not contain direct contact data.

### AC-006: Резолвинг только на финальном boundary

Given SMS Sender receives job with `recipientRef`,  
When it prepares SMS for Router,  
Then it resolves `recipientRef` through authorized Player Data / contact resolution service.

### AC-007: Защита от дублей

Given retry or reprocessing is triggered,  
When recipient was already sent or accepted by SMS Router,  
Then system must not submit duplicate SMS.

---

## 7. Риски и решения

| Risk | Impact | Mitigation |
|---|---|---|
| SlimLink partial failure | Часть recipients не получит short link | Record-level processing: успешные идут дальше, failed фиксируются отдельно. |
| Duplicate SMS during retry | Жалобы игроков, репутационный риск | Send-state check перед SMS Router submission. |
| recipientRef cannot be resolved | SMS не может быть отправлено | Mark recipient as failed, log safe reason, no SMS submission. |
| PII leakage in logs / queues | Compliance risk | Запрещаем PII в intermediate payloads, logs, monitoring. |
| Consent changes before sending | Нельзя отправить SMS | Финальный eligibility check на стороне Sender. |

---

## 8. Out of Scope

В эту Story не включаем:

- детальное описание SlimLink API payloads;
- детальный mapping SMS Router statuses;
- delivery status dashboard;
- click analytics;
- manual reprocessing UI;
- rich SMS / MMS;
- новые SMS-провайдеры.

Детали API, error mapping и retry policy лучше выносить в отдельные Tasks.

---

## 9. Interview Pitch — 1–2 минуты

В этой Story я показывал, как мы безопасно продолжаем SMS pipeline после подготовки eligible recipients.

Ключевое решение было не протаскивать персональные данные через весь CRM pipeline. Вместо phone number, name или email мы используем `recipientRef / userHash`, который был подготовлен сервисом пользовательских данных. Campaign Processing Service работает только с этим reference, SlimLink назначает короткую ссылку на уровне recipient reference, а CRM сохраняет mapping между campaignId, batchId, recipientRef и short URL.

После этого система создает SMS sending job, но в job не кладет phone number. Финальный SMS Sender получает `recipientRef`, резолвит его через trusted Player Data boundary, делает последнюю проверку актуального contact state и consent, и только затем отправляет SMS через SMS Router.

Такой подход дает сразу несколько преимуществ: меньше PII в системе, проще compliance, меньше риск утечек через логи и очереди, меньше payload между сервисами, и при этом сохраняется traceability через campaignId, batchId, recipientRef и correlationId.

Отдельно я бы не перегружал Story деталями SlimLink API. На уровне Story достаточно описать value, flow, business rules, acceptance criteria, retry / duplicate prevention и privacy boundary. Детальные payloads, HTTP codes и error mapping я бы вынес в отдельные implementation Tasks или API spec.

---

## 10. Короткая формулировка для собеседования

> The key design decision was to avoid passing personal data through the whole CRM pipeline. We used a privacy-safe recipient reference prepared by the Player Data Service. CRM used this reference to allocate a personalized short link and create an SMS job. The final SMS Sender resolved the recipient reference only at the trusted sending boundary, performed final eligibility checks and submitted the SMS through the approved Router. This reduced compliance exposure, protected PII and still allowed full traceability for campaign processing.
