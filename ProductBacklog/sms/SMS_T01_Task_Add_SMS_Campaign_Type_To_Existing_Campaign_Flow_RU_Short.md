# Task: Добавить тип SMS в существующий flow кампаний / шаблонов

## 1. Контекст

В CRM уже есть функционал создания кампаний и шаблонов для **Email**.  
Задача — не строить новый SMS-модуль с нуля, а расширить существующий campaign/template flow и добавить новый communication type: **SMS**.

Это поддерживает Story: **Configure and Launch SMS Campaign**.

Ключевая идея для интервью:

> Я переиспользовал существующий Email campaign flow, но выделил SMS-specific ограничения: plain text, отсутствие HTML/картинок, character count, link placeholder и отдельные validation rules.

---

## 2. Цель

Дать CRM Manager возможность создавать и запускать SMS-кампании через существующий интерфейс кампаний, с учетом ограничений SMS-канала.

После выполнения Task:

- в campaign creation flow доступен тип `SMS`;
- открывается SMS-specific plain text editor;
- Email-specific элементы недоступны для SMS;
- отображается character count;
- SMS-кампания проходит базовую валидацию перед запуском;
- валидная кампания передается дальше в recipient preparation.

---

## 3. Тип задачи

- Technical implementation
- Analysis
- Configuration
- QA / Test preparation
- Documentation

---

## 4. Scope

### In Scope

- Добавить `SMS` как новый campaign communication type.
- Переиспользовать существующий campaign/template flow.
- Добавить SMS editor в режиме plain text.
- Скрыть / отключить HTML, images, rich content controls.
- Добавить character count.
- Добавить базовые validation rules для SMS campaign launch.
- Добавить feature flag / channel configuration для доступности SMS.
- Обновить logging / audit для SMS campaign actions.

### Out of Scope

- Полный redesign campaign module.
- SlimLink API implementation.
- Recipient batching.
- SMS Router integration.
- Delivery status / click analytics.
- Точная тарификационная логика SMS segments, если она требует отдельного согласования.

---

## 5. Expected Output

- CRM Manager может выбрать `SMS` при создании кампании.
- SMS content редактируется как plain text.
- Email HTML editor не используется для SMS.
- Character count отображается в редакторе.
- Невалидная SMS-кампания не запускается.
- Валидная SMS-кампания создает downstream launch request.
- Email flow не ломается регрессией.

---

## 6. Technical Details

| Area | Details |
|---|---|
| Component | CRM Campaign Management, Template Management, Campaign UI |
| Config | `sms_campaign_enabled` / channel availability |
| DB | Возможное добавление enum/value `SMS` |
| API | Возможное обновление internal campaign contract для `communicationType = SMS` |
| Feature flag | Да, желательно для controlled rollout |
| Monitoring | SMS campaign created / validation failed / launched |

---

## 7. Implementation Notes

- Используем общий campaign lifecycle: Draft → Validation → Launch → Processing.
- Не создаем отдельный SMS-модуль без необходимости.
- SMS editor должен быть проще Email editor: только plain text.
- HTML, картинки, баннеры, attachments — запрещены.
- Character count обязателен как базовая UX-подсказка.
- Segment calculation можно вынести в отдельную задачу, если нужна точность для billing.
- Launch action должен быть защищен от double-click / duplicate request.

---

## 8. Acceptance Criteria

### AC-001: SMS type доступен

**Given** SMS channel enabled,  
**When** CRM Manager создает кампанию,  
**Then** он может выбрать `SMS` как communication type.

### AC-002: SMS editor — plain text

**Given** выбран тип `SMS`,  
**When** открыт редактор шаблона,  
**Then** доступно только plain text поле,  
**And** HTML/images/rich blocks недоступны.

### AC-003: Character count отображается

**Given** CRM Manager вводит SMS text,  
**When** текст меняется,  
**Then** система показывает актуальный character count.

### AC-004: Validation blocks invalid launch

**Given** в SMS campaign отсутствуют обязательные данные,  
**When** CRM Manager нажимает Launch,  
**Then** запуск блокируется,  
**And** система показывает понятные ошибки.

### AC-005: Valid campaign идет дальше

**Given** SMS campaign валидна,  
**When** CRM Manager запускает кампанию,  
**Then** создается один downstream launch request для recipient preparation.

### AC-006: Duplicate launch prevention

**Given** пользователь нажимает Launch повторно,  
**When** запрос уже обрабатывается,  
**Then** система не создает дублирующий launch request.

---

## 9. Dependencies

| Dependency | Owner | Status |
|---|---|---|
| Existing Email campaign/template flow | CRM Team | Existing |
| SMS channel availability rules | Product Owner | Open |
| SMS content restrictions | BSA / Product / UX | Open |
| Character count / segment policy | BSA / Product | Open |
| Permission model | CRM / Security | Existing |

---

## 10. Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Email editor случайно переиспользуют для SMS | Невалидный SMS content | Отдельный plain text mode. |
| Segment logic не согласована | Неверные ожидания по длине/стоимости | В MVP оставить character count, segment logic вынести отдельно. |
| SMS доступен в неподдерживаемом market | Compliance / operational risk | Channel config / feature flag. |
| Изменения ломают Email flow | Regression risk | Regression tests по Email campaigns. |
| Duplicate launch request | Двойная обработка кампании | UI/backend duplicate prevention. |

---

## 11. Test / Verification Plan

- Проверить, что `SMS` доступен только где включен.
- Проверить plain text editor.
- Проверить, что HTML/images/rich content недоступны.
- Проверить character count.
- Проверить validation errors.
- Проверить save as Draft.
- Проверить launch valid campaign.
- Проверить защиту от duplicate launch.
- Проверить, что Email campaign flow не сломан.

---

## 12. Documentation Impact

- Обновить описание Campaign Management / Communication Channels.
- Обновить внутренний API contract, если добавляется `communicationType = SMS`.
- Добавить release notes по SMS campaign type.
- Детали SlimLink / SMS Router не описывать здесь — они относятся к отдельным Tasks / Stories.

---

## 13. Open Questions

| Question | Owner | Status |
|---|---|---|
| SMS включается для всех tenants или только selected markets? | Product Owner | Open |
| Нужно ли scheduling для SMS в MVP? | Product Owner | Open |
| Показываем только character count или еще segment estimate? | Product / BSA | Open |
| Нужна ли конвертация Email template → SMS plain text? | Product / UX | Open |

---

## 14. Definition of Done

- `SMS` campaign type доступен по feature/channel config.
- Plain text SMS editor реализован.
- Email-specific content недоступен для SMS.
- Character count работает.
- Validation rules работают.
- Draft / Launch flow работает.
- Duplicate launch prevention есть.
- Permissions, logs и audit проверены.
- Email regression пройден.
- Документация обновлена.

---

## 15. Interview Pitch

В этой Task я показал, что не всегда нужно строить новый модуль с нуля. В CRM уже был flow для Email campaigns и template management, поэтому я предложил расширить существующую модель новым communication type — SMS.

Ключевая аналитическая работа была в том, чтобы отделить общую campaign logic от channel-specific behavior. Общими остались campaign name, audience, draft/launch lifecycle, permissions и audit. А для SMS мы добавили ограничения: plain text вместо HTML, запрет картинок и rich content, character count, link placeholder и отдельные validation rules.

Такой подход снижает стоимость разработки, уменьшает риск дублирования логики и сохраняет единый user experience для CRM Manager.
