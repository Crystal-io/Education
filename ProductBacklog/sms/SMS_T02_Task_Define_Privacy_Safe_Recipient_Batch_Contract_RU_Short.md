# Task: Define privacy-safe recipient batch contract

## 1. Контекст

Задача поддерживает Story: **Prepare Privacy-Safe Recipient Batches**.

Суть: при подготовке SMS-рассылки не нужно протаскивать телефон, имя, email или другие персональные данные через все CRM-модули. Это повышает compliance-риск, усложняет логирование, доступы, мониторинг и расследование инцидентов.

Вместо этого pipeline должен работать с безопасной ссылкой на получателя: `recipientRef` / `userHash`, которую готовит сервис пользовательских данных.

Ключевая формулировка для интервью:

> Я предложил не передавать PII через весь SMS pipeline. Вместо этого Player Data Service готовит privacy-safe recipient reference, промежуточные сервисы работают только с этим reference, а финальный SMS Sender резолвит телефон только на последнем шаге перед отправкой.

---

## 2. Цель

Определить контракт batch-подготовки получателей так, чтобы CRM могла обрабатывать большие SMS-аудитории без лишнего распространения персональных данных.

После выполнения Task:

- batch содержит `recipientRef / userHash`, а не телефон;
- Campaign Processing не работает с PII;
- Player Data Service остается источником player data, phone и consent;
- SMS Sender резолвит телефон только в контролируемой зоне;
- логи, retry и monitoring не раскрывают персональные данные.

---

## 3. Тип задачи

- Analysis
- Spike / Research
- Data / Migration
- API / Integration
- QA / Test preparation
- Documentation
- Support / Operations

---

## 4. Выбранный подход

### Лучший вариант: opaque recipient reference

Используем технический идентификатор `recipientRef / userHash`, подготовленный Player Data Service.

Он должен быть:

- непрозрачным для промежуточных сервисов;
- не должен содержать телефон, email или имя;
- не должен быть простым hash от телефона;
- должен быть пригоден для batch processing, retry и reconciliation;
- должен резолвиться в телефон только авторизованным SMS Sender.

### Почему не raw PII

Raw PII через pipeline — плохой вариант, потому что:

- растет GDPR / compliance exposure;
- сложнее контролировать доступы;
- выше риск утечки через логи, очереди, мониторинг;
- каждый новый сервис в pipeline получает лишние данные.

### Почему не encrypted PII как основной вариант

Encrypted PII лучше, чем raw PII, но всё равно хуже, чем reference:

- encrypted PII всё еще считается sensitive data;
- появляется key management для многих сервисов;
- возрастает сложность troubleshooting;
- промежуточные сервисы всё равно тащат данные, которые им не нужны.

---

## 5. Scope

### In Scope

- Определить recipient batch contract.
- Разделить allowed и prohibited data.
- Зафиксировать, что batch работает с `recipientRef / userHash`.
- Определить boundary между Campaign Processing, Player Data Service и SMS Sender.
- Описать retry / duplicate prevention через reference.
- Описать logging / audit / monitoring без PII.
- Подготовить AC и QA focus.

### Out of Scope

- Реализация Player Data Service.
- Реализация SMS Sender resolution.
- Полный encryption / key management design.
- SlimLink API details.
- SMS Router payload details.
- UI изменения.
- Delivery status / click analytics.

---

## 6. Expected Output

- Согласован privacy-safe подход для recipient batch.
- Промежуточные сервисы не получают телефон и другие PII.
- Player Data Service отвечает за формирование `recipientRef`.
- SMS Sender отвечает за финальное получение телефона перед отправкой.
- QA понимает, как проверять отсутствие PII в batch, logs и events.

---

## 7. Data Contract — high level

### Можно передавать в batch

| Data | Purpose |
|---|---|
| `campaignId` | Связь с кампанией. |
| `batchId` | Batch processing / retry. |
| `recipientRef / userHash` | Безопасная ссылка на получателя. |
| `tenantId / brandId` | Routing / permissions. |
| `market / language` | Если нужно для обработки. |
| `eligibilityStatus` | Статус eligibility без PII. |
| `exclusionReasonCode` | Причина исключения без раскрытия данных. |
| processing status | Pending / Prepared / Failed / Sent. |

### Нельзя передавать в batch

| Data | Why not |
|---|---|
| phone number | Нужен только final sender. |
| full name | Не нужен для pipeline. |
| email | Не нужен для SMS pipeline. |
| date of birth | Не нужен для обработки кампании. |
| raw player profile | Нарушает data minimization. |
| detailed consent evidence | Должно оставаться в source system. |

---

## 8. Acceptance Criteria

### AC-001: Batch не содержит PII

**Given** recipient batch contract is defined,  
**When** Campaign Processing receives batch,  
**Then** batch contains `recipientRef / userHash`, campaignId, batchId and technical metadata,  
**And** does not contain phone, name, email or raw player profile.

### AC-002: Player Data Service готовит reference

**Given** campaign audience is selected,  
**When** eligible recipients are prepared,  
**Then** Player Data Service returns privacy-safe recipient references.

### AC-003: SMS Sender резолвит телефон только в конце

**Given** SMS is ready to be sent,  
**When** SMS Sender receives recipientRef,  
**Then** it resolves phone number inside authorized sender boundary only.

### AC-004: Logs are PII-safe

**Given** batch processing or failure occurs,  
**When** logs / events are created,  
**Then** they contain campaignId, batchId, recipientRef and safe reason codes,  
**And** no phone number or other PII is logged.

### AC-005: Retry работает через reference

**Given** batch processing is retried,  
**When** the same recipient is processed again,  
**Then** system uses campaignId + batchId + recipientRef for retry / reconciliation.

---

## 9. Dependencies

| Dependency | Owner | Status |
|---|---|---|
| Player Data Service contract | Player Data Team | Open |
| SMS Sender resolution capability | SMS Sender Team | Open |
| SMS consent rules | Compliance / CRM | Open |
| Recipient processing state model | CRM Backend | Open |
| Access model for reference resolution | Security / DevOps | Open |

---

## 10. Risks

| Risk | Impact | Mitigation |
|---|---|---|
| В batch добавят raw PII “для удобства” | Compliance risk | Явно запретить PII в contract. |
| userHash сделают простым hash от телефона | Re-identification risk | Использовать opaque reference / scoped HMAC, а не простой hash. |
| Слишком много сервисов смогут резолвить reference | Access risk | Разрешить resolution только SMS Sender / Player Data boundary. |
| Reference нестабилен для retry | Ошибки reconciliation | Зафиксировать campaign/batch scope и idempotency rules. |
| Логи случайно содержат телефон | Data leakage | PII-safe logging rules + QA checks. |

---

## 11. Test / Verification Plan

- Проверить, что batch не содержит phone/name/email/raw profile.
- Проверить, что для eligible recipients есть `recipientRef`.
- Проверить, что excluded recipients имеют safe reason codes.
- Проверить, что Campaign Processing работает без PII.
- Проверить, что SMS Sender может резолвить reference при наличии доступа.
- Проверить, что unresolved recipient не отправляется.
- Проверить retry по campaignId + batchId + recipientRef.
- Проверить logs/events/audit на отсутствие PII.

---

## 12. Interview Pitch — 1–2 минуты

В этой Task я фокусировался на том, как безопасно собрать batch получателей для SMS-кампании. Первичная идея могла быть простой: передавать по pipeline телефон и другие данные игрока. Но это плохой вариант с точки зрения compliance, логов, доступов и нагрузки на сервисы.

Я предложил использовать privacy-safe recipient reference: сервис пользовательских данных формирует `recipientRef / userHash`, а промежуточные сервисы работают только с этим reference, campaignId, batchId и техническими статусами. Телефон резолвится только финальным SMS Sender на последнем шаге перед отправкой.

Такой подход снижает PII exposure, упрощает контроль доступов, делает retry и monitoring безопаснее, и хорошо соответствует принципам data minimization и least privilege.

---

## 13. Task Definition of Done

Task считается выполненной, когда:

- recipient batch contract согласован;
- allowed / prohibited data определены;
- PII не передается через intermediate pipeline;
- Player Data Service и SMS Sender boundaries понятны;
- AC и QA сценарии описаны;
- риски и open questions зафиксированы;
- related Story / Epic / documentation updated.
