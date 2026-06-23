# Task: Define integration error handling and status mapping

## 1. Контекст

Задача поддерживает Story: **Allocate Personalized Short Links and Send SMS Using Recipient Reference**.

В SMS pipeline есть несколько интеграционных точек:

- Campaign Processing Service;
- SlimLink;
- Message Broker / Queue;
- SMS Sender;
- SMS Router;
- CRM campaign reporting.

Если не описать error handling и status mapping заранее, команда быстро упрется в вопросы:

- что делать при частичном успехе batch;
- какие ошибки retryable, а какие нет;
- когда campaign считать `Partially Failed`, а когда `Failed`;
- как не отправить SMS повторно при retry;
- какие ошибки показывать CRM Manager, а какие только Operations.

Ключевая формулировка для интервью:

> Я отдельно вынес Task на integration error handling и status mapping, потому что для production pipeline недостаточно описать happy path. Нужно заранее определить, как система ведет себя при partial failures, retries, rate limits, delayed statuses и unknown outcomes.

---

## 2. Цель

Определить единый подход к обработке интеграционных ошибок и маппингу статусов на трех уровнях:

- recipient;
- batch;
- campaign.

После выполнения Task команда должна понимать:

- какие ошибки повторяем автоматически;
- какие ошибки считаем бизнес-валидацией или конфигурационной проблемой;
- как обрабатываем частичный успех;
- как обновляем campaign status;
- как предотвращаем duplicate SMS sending.

---

## 3. Тип задачи

- Analysis
- Spike / Research
- API / Integration
- QA / Test preparation
- Documentation
- Support / Operations

---

## 4. Scope

### In Scope

- Error categories для SlimLink, SMS Sender и SMS Router.
- Retryable / non-retryable classification.
- Recipient / batch / campaign status mapping.
- Partial failure handling.
- Duplicate prevention при retry / reprocessing.
- Logging, monitoring, alerts и correlationId.
- QA scenarios для negative / partial / retry cases.

### Out of Scope

- Реализация retry mechanism.
- Реализация SlimLink API client.
- Реализация SMS Router integration.
- Детальные API payloads.
- Provider-specific SMS codes.
- UI delivery dashboard.
- Manual reprocessing UI.

---

## 5. Expected Output

- Согласована error handling matrix.
- Ошибки разделены на retryable и non-retryable.
- Описаны статусы recipient / batch / campaign.
- Описаны правила aggregation: recipient → batch → campaign.
- Зафиксированы duplicate-prevention правила.
- QA понимает, какие сценарии тестировать.
- Operations понимает, какие ошибки требуют ручного расследования.

---

## 6. Основная идея

### Не показываем сырые технические ошибки бизнесу

Raw provider errors не должны напрямую попадать в CRM UI. Они должны быть преобразованы в понятные внутренние категории:

- temporary integration failure;
- validation / configuration error;
- rate limit;
- duplicate / reconciliation issue;
- recipient resolution failure;
- delivery rejected;
- unknown outcome;
- manual investigation required.

### Три уровня статусов

| Level | Зачем нужен |
|---|---|
| Recipient status | Понимать судьбу конкретного recipientRef. |
| Batch status | Понимать результат обработки batch. |
| Campaign status | Показать бизнесу понятное состояние кампании. |

---

## 7. Пример status model

### Recipient statuses

| Status | Meaning |
|---|---|
| `Prepared` | Recipient готов к обработке. |
| `LinkAllocated` | Короткая ссылка успешно назначена. |
| `LinkAllocationFailed` | Ссылку не удалось назначить. |
| `SendJobCreated` | Job на отправку SMS создан. |
| `RecipientResolutionFailed` | Sender не смог резолвить recipientRef. |
| `SubmittedToRouter` | SMS передана в SMS Router. |
| `Delivered` | Получено подтверждение доставки. |
| `DeliveryFailed` | Доставка неуспешна. |
| `Skipped` | Recipient исключен осознанно. |
| `DuplicatePrevented` | Повторная отправка предотвращена. |

### Batch statuses

| Status | Meaning |
|---|---|
| `Processing` | Batch обрабатывается. |
| `PendingRetry` | Ожидает retry. |
| `PartiallyFailed` | Часть записей упала, часть успешна. |
| `Completed` | Batch успешно завершен. |
| `Failed` | Batch не может продолжить обработку. |
| `Cancelled` | Batch остановлен из-за отмены кампании. |

### Campaign statuses

| Status | Meaning |
|---|---|
| `Draft` | Кампания еще не запущена. |
| `Processing` | Кампания обрабатывается. |
| `PartiallyFailed` | Есть успешные и failed recipients. |
| `Sent` | SMS переданы в Router. |
| `Completed` | Кампания дошла до финального состояния. |
| `Failed` | Кампания не может продолжиться. |
| `Cancelled` | Кампания отменена. |

---

## 8. Пример error handling matrix

| Error type | Retry? | System behavior |
|---|---|---|
| SlimLink temporary unavailable | Yes | Retry with backoff, batch remains `PendingRetry`. |
| SlimLink rate limit | Yes, controlled | Throttle requests, retry later. |
| Invalid domain / configuration | No | Mark affected records / batch as failed, require configuration fix. |
| Duplicate external / recipient identifier | No / reconciliation | Do not treat as normal success; check existing state. |
| SMS Sender cannot resolve recipientRef | No / investigation | Do not send SMS, mark recipient failed. |
| SMS Router temporary failure | Yes | Retry if SMS was not accepted. |
| SMS Router rejects message | No | Mark delivery failed with normalized reason. |
| Timeout with unknown outcome | Reconciliation first | Check state before retry to avoid duplicate SMS. |

---

## 9. Acceptance Criteria

### AC-001: Error categories defined

**Given** integration failure occurs,  
**When** the error is processed,  
**Then** it is mapped to normalized internal error category.

### AC-002: Retryable vs non-retryable

**Given** an error category is defined,  
**When** system evaluates it,  
**Then** it knows whether to retry, stop, skip, or send to manual investigation.

### AC-003: Partial failures supported

**Given** batch has both success and failed records,  
**When** result is processed,  
**Then** successful recipients continue,  
**And** failed recipients are isolated with error category.

### AC-004: Status mapping defined

**Given** recipient statuses are updated,  
**When** batch and campaign status are recalculated,  
**Then** aggregation follows documented rules.

### AC-005: Duplicate SMS prevented

**Given** retry or reprocessing starts,  
**When** recipient already has submitted / sent state,  
**Then** SMS is not sent again.

### AC-006: Operations can investigate without PII

**Given** failure occurred,  
**When** Operations investigates,  
**Then** they use campaignId, batchId, recipientRef, error category and correlationId,  
**And** no phone number / name / email is required.

---

## 10. Logging / Monitoring

Нужно логировать и мониторить:

- SlimLink failure rate;
- SMS Router failure rate;
- recipient resolution failures;
- retry count;
- campaigns stuck in Processing;
- duplicate prevention events;
- status update lag.

Все логи должны содержать:

- campaignId;
- batchId;
- recipientRef, если record-level;
- errorCategory;
- retryable flag;
- correlationId.

Без phone, name, email и raw player profile.

---

## 11. Risks

| Risk | Mitigation |
|---|---|
| Retry приведет к duplicate SMS | Проверять текущий recipient send state перед повторной отправкой. |
| Частичный failure заблокирует всю кампанию | Обрабатывать record-level outcomes отдельно. |
| CRM Manager увидит слишком техническую ошибку | Маппить raw errors в business-readable categories. |
| Operations не сможет расследовать проблему | Использовать campaignId, batchId, recipientRef и correlationId. |
| Provider status не совпадает с CRM status | Согласовать SMS Router → CRM status mapping. |
| Logs раскроют PII | Запретить phone/name/email/raw payload в logs/events. |

---

## 12. QA Focus

QA должна проверить:

- happy path;
- SlimLink partial failure;
- SlimLink rate limit;
- SMS Sender recipientRef resolution failure;
- SMS Router rejection;
- timeout / unknown outcome;
- retry без повторной отправки;
- campaign status aggregation;
- отсутствие PII в logs / events.

---

## 13. Interview Pitch — 1 минута

Для этой интеграции я отдельно описал Task по error handling и status mapping. Причина в том, что SMS pipeline — это не только happy path: там есть SlimLink, очереди, Sender, SMS Router, partial failures, retries и delayed statuses.

Я предложил нормализовать все технические ошибки в понятные internal error categories и определить поведение для каждой категории: retry, no retry, skip, reconciliation или manual investigation. Отдельно описал статусы на трех уровнях: recipient, batch и campaign.

Самое важное — мы не должны блокировать всю кампанию из-за нескольких failed recipients и не должны отправлять SMS повторно при retry. Поэтому successful records продолжают обработку, failed records изолируются, а перед повторной отправкой система проверяет текущий send state.

Такой Task помогает backend, QA и Operations одинаково понимать поведение системы в production-сценариях, а бизнес получает понятные campaign statuses вместо сырых технических ошибок.

---

## 14. Definition of Done

- Error categories documented.
- Retryable / non-retryable logic documented.
- Recipient / batch / campaign statuses defined.
- Partial failure behavior defined.
- Duplicate prevention behavior defined.
- Logging / monitoring requirements defined.
- QA scenarios prepared.
- Open questions for SMS Router / SlimLink mapping captured.
