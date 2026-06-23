# Story: Configure and Launch SMS Campaign

## Краткое назначение

Сокращенная версия Story для интервью.  
Фокус: показать, как BSA описывает добавление нового типа рассылки **SMS** в уже существующий CRM campaign/template flow, где ранее был функционал для Email-шаблонов.

---

## 1. User Story

**As a CRM Manager,**  
I want to configure and launch an SMS campaign using the existing campaign/template management capability with SMS as a new communication type,  
**So that** I can run personalized retention, reactivation and promotional SMS campaigns through a controlled CRM delivery pipeline.

По-русски:

**Как CRM Manager,**  
я хочу создавать и запускать SMS-кампании через существующий механизм campaign/template management, добавив SMS как новый тип рассылки,  
**чтобы** быстро запускать retention / reactivation / promo-коммуникации через контролируемый CRM pipeline.

---

## 2. Business Context

В CRM уже есть функционал создания и наполнения шаблонов для **Email**.  
В этой Story мы не строим новый модуль с нуля, а расширяем существующий campaign/template flow новым типом рассылки — **SMS**.

Главная бизнес-ценность:

- CRM / Marketing команда получает новый канал коммуникации;
- запуск SMS-кампаний остается в привычном CRM flow;
- переиспользуются существующие сущности campaign/template/audience;
- SMS получает свои channel-specific правила;
- дальше кампания уходит в общий delivery pipeline.

---

## 3. Чем SMS отличается от Email

| Area | Email | SMS |
|---|---|---|
| Content format | HTML / rich content | Plain text |
| Images | Allowed | Not allowed |
| Editor | Rich editor | Text-oriented editor |
| Length control | Less strict | Character / segment counter needed |
| Main CTA | Button / banner / link | Short text + link placeholder |
| Delivery rules | Email-specific consent / deliverability | SMS consent / sender / market restrictions |

Важно: точные правила подсчета символов, encoding, segment calculation и UI-polishing можно вынести в отдельные Tasks / Stories. В этой Story фиксируем только business-level и story-level scope.

---

## 4. User / Role

| Role | Responsibility |
|---|---|
| CRM Manager | Создает, редактирует и запускает SMS campaign. |
| Marketing & Retention Manager | Использует SMS как канал retention / promo / reactivation. |
| Campaign Management Service | Хранит campaign configuration и запускает downstream processing. |
| Template Service | Хранит SMS template как отдельный template type. |
| Campaign Processing Service | Получает launch request и запускает следующий шаг pipeline. |

---

## 5. Preconditions

- В CRM уже есть campaign creation flow.
- В CRM уже есть template management для Email.
- Для tenant / market включен SMS channel.
- CRM Manager имеет права на создание и запуск кампании.
- Доступен выбор audience / segment.
- Определены базовые SMS-specific правила: plain text, link placement, character guidance.

---

## 6. Postconditions

- CRM Manager может создать campaign type = `SMS`.
- SMS campaign содержит audience, message text, campaign URL / link placeholder и required metadata.
- SMS-specific validation выполняется до запуска.
- Campaign можно сохранить как Draft или запустить.
- После успешного запуска campaign передается в recipient preparation.
- Email campaign/template flow не ломается.

---

## 7. Main Flow

1. CRM Manager открывает campaign creation flow.
2. Выбирает communication type = `SMS`.
3. System показывает SMS-specific форму вместо Email HTML editor.
4. CRM Manager указывает campaign name и выбирает audience / segment.
5. CRM Manager создает или выбирает SMS template.
6. Вводит plain text message.
7. System показывает character count / SMS content guidance.
8. CRM Manager добавляет campaign long URL или link placeholder, если кампания использует короткие ссылки.
9. System не позволяет использовать HTML, картинки и rich Email-блоки.
10. CRM Manager сохраняет Draft или запускает campaign.
11. System валидирует required fields и SMS-specific rules.
12. Валидная campaign передается в downstream recipient preparation.

---

## 8. Alternative Flows / Edge Cases

| Case | Expected Behavior |
|---|---|
| Save as Draft | Campaign сохраняется, downstream processing не стартует. |
| Missing audience / message text | Launch блокируется, пользователь видит validation error. |
| User tries to add image / HTML | System блокирует, потому что SMS = plain text only. |
| Text exceeds configured SMS limit | System показывает warning или блокирует запуск согласно rule. |
| SMS channel disabled for market | Campaign нельзя запустить для выбранного market / tenant. |
| Double click on Launch | System создает только один launch request. |
| Existing Email template selected | System не позволяет использовать HTML Email template напрямую как SMS. |

---

## 9. Functional Requirements

| FR ID | Requirement |
|---|---|
| FR-001 | System shall allow authorized CRM Manager to create campaign type `SMS`. |
| FR-002 | System shall reuse existing campaign/template management flow where possible. |
| FR-003 | System shall provide SMS plain text editor instead of Email HTML editor. |
| FR-004 | System shall display SMS character count / content guidance. |
| FR-005 | System shall block images, HTML blocks and rich media inside SMS body. |
| FR-006 | System shall allow audience / segment selection for SMS campaign. |
| FR-007 | System shall support campaign long URL / link placeholder where required. |
| FR-008 | System shall validate required SMS campaign fields before launch. |
| FR-009 | System shall allow Save as Draft. |
| FR-010 | System shall submit valid campaign to downstream recipient preparation. |
| FR-011 | System shall prevent duplicate launch request. |
| FR-012 | System shall log and audit campaign creation and launch actions. |

---

## 10. Business Rules

| BR ID | Rule |
|---|---|
| BR-001 | SMS campaign must have campaign type `SMS`. |
| BR-002 | SMS body supports plain text only. |
| BR-003 | Campaign cannot be launched without audience and message text. |
| BR-004 | Images, banners, attachments and HTML blocks are not allowed. |
| BR-005 | Campaign URL / link placeholder is required if campaign uses personalized short links. |
| BR-006 | SMS campaign can be launched only where SMS channel is enabled. |
| BR-007 | Only authorized users can launch SMS campaigns. |
| BR-008 | Existing Email template flow must continue working after SMS type is added. |

---

## 11. Acceptance Criteria

### AC-001: SMS campaign type is available

**Given** CRM Manager has permission to create campaigns,  
**When** campaign creation flow is opened,  
**Then** SMS is available as communication type where SMS channel is enabled.

### AC-002: SMS uses plain text editor

**Given** CRM Manager selects SMS campaign type,  
**When** message editor is displayed,  
**Then** system shows plain text SMS editor,  
**And** does not show Email HTML / image components.

### AC-003: Character count is shown

**Given** CRM Manager enters SMS text,  
**When** text is changed,  
**Then** system displays character count / SMS content guidance.

### AC-004: Unsupported content is blocked

**Given** CRM Manager tries to add image, HTML or rich media,  
**When** content is inserted,  
**Then** system blocks it and explains that SMS supports plain text only.

### AC-005: Required fields are validated

**Given** SMS campaign has missing audience, text or required URL/link configuration,  
**When** CRM Manager clicks Launch,  
**Then** launch is blocked and validation errors are shown.

### AC-006: Valid campaign is launched

**Given** SMS campaign configuration is valid,  
**When** CRM Manager clicks Launch,  
**Then** campaign is accepted and passed to recipient preparation.

### AC-007: Duplicate launch is prevented

**Given** CRM Manager clicks Launch twice or request is retried,  
**When** system receives duplicate launch request,  
**Then** only one downstream launch request is created.

### AC-008: Email flow is not affected

**Given** existing Email campaign/template functionality works,  
**When** SMS type is added,  
**Then** Email campaign creation and Email template editing continue working as before.

---

## 12. NFR / Quality Attributes

| Category | Requirement |
|---|---|
| Usability | CRM Manager should clearly see SMS-specific limitations in the UI. |
| Reliability | Duplicate launch requests must not start duplicate downstream processing. |
| Security | Permissions and tenant / market restrictions must be enforced. |
| Compliance | SMS flow must support consent and regional restrictions in downstream eligibility step. |
| Observability | Campaign creation and launch must be logged with campaignId and correlationId. |
| Backward Compatibility | Existing Email campaign/template flow must not break. |

---

## 13. Out of Scope

- Детальный алгоритм подсчета SMS segments / encoding.
- Полный редизайн template editor.
- HTML-to-SMS conversion engine.
- MMS / rich media support.
- Recipient eligibility preparation.
- SlimLink short link allocation.
- SMS Router delivery integration.
- Delivery status dashboard.
- Click statistics reporting.

---

## 14. Tasks / Follow-up Stories

| Item | Why separate |
|---|---|
| SMS character and segment counter | Это отдельная technical/UI task с encoding rules. |
| SMS plain text editor restrictions | Можно оформить как UI/validation task. |
| Link placeholder behavior | Может быть отдельная task, если есть разные campaign types. |
| SMS channel permissions by tenant/market | Configuration / access-control task. |
| Regression testing for Email templates | QA task, чтобы не сломать существующий Email flow. |

---

## 15. Interview Pitch — 1–2 минуты

В этой Story я описывал не новый модуль с нуля, а расширение существующего CRM campaign/template flow. В системе уже были Email-шаблоны, поэтому задача была добавить новый communication type — SMS — и аккуратно выделить его отличия.

Главные отличия SMS от Email: это plain text вместо HTML, отсутствие картинок и rich content, необходимость character count / segment guidance, более короткий CTA и link placeholder. При этом я не стал перегружать Story техническими деталями подсчета символов или encoding — такие вещи лучше выносить в отдельные Tasks.

На уровне Story я зафиксировал основной пользовательский сценарий: CRM Manager выбирает SMS campaign type, выбирает audience, создает или использует SMS template, вводит plain text message, видит базовые SMS ограничения, сохраняет Draft или запускает campaign. Перед запуском система валидирует required fields, SMS channel availability и запрещает Email-specific content.

Бизнес-ценность в том, что Marketing & Retention команда получает новый канал коммуникации внутри привычного CRM flow, а команда разработки не плодит отдельный модуль, а расширяет существующую campaign/template архитектуру с учетом SMS-specific правил.
