# Финальный interview pitch: самый интересный проект и мой подход к работе с backlog

## 0. Как я позиционирую этот проект

**Проект:** end-to-end SMS Campaign Delivery Pipeline для CRM / Marketing & Retention команды.

**Коротко:** мы расширяли существующий campaign / template flow, где уже были Email-кампании, и добавляли новый канал коммуникации — **SMS**. Задача была не просто “отправить SMS”, а построить контролируемый pipeline: от настройки кампании в CRM до подготовки получателей, персонализированных short links, безопасной отправки через SMS Sender / Router, статусов доставки, обработки ошибок и дальнейшего масштабирования.

**Почему проект интересный:** он находится на стыке business analysis и system analysis. С одной стороны — CRM Manager, шаблоны, UI, запуск кампании, бизнес-ценность. С другой — интеграции, privacy-safe batch processing, внешние ограничения SlimLink, SMS Router, retry / idempotency, monitoring, compliance и backlog decomposition.

---

## 1. Готовый ответ на вопрос: “Расскажите о самом интересном проекте”

Один из самых интересных проектов, над которым я работал, был связан с построением **SMS Campaign Delivery Pipeline** внутри CRM.

Бизнес-задача была в том, чтобы Marketing & Retention команда могла запускать персонализированные SMS-кампании: выбирать аудиторию, использовать SMS-шаблон, добавлять campaign URL, получать персональные короткие ссылки, отправлять сообщения через approved SMS Router и видеть результат кампании.

Для меня этот проект был интересен тем, что он требовал не просто описать одну фичу, а структурировать весь end-to-end процесс. Нужно было связать несколько систем: CRM Campaign Management, Player Data Service, Campaign Processing Service, SlimLink, SMS Sender / Router, monitoring и reporting. При этом важно было учесть ограничения внешних сервисов, batching, retry logic, защиту от duplicate SMS, consent rules, GDPR и минимизацию персональных данных.

Я начал с discovery: собрал бизнес-цель, stakeholders, impacted systems, основные ограничения и риски. После этого оформил Epic на уровне бизнес-способности: что именно должно измениться в продукте, какой MVP scope, какие системы затрагиваются, какие есть NFR, риски, dependencies и open questions.

Дальше я декомпозировал Epic в user stories. Для интервью я выделяю три ключевые story:

1. **Configure and Launch SMS Campaign** — расширение существующего Email campaign/template flow новым типом рассылки SMS.
2. **Prepare Privacy-Safe Recipient Batches** — подготовка batch получателей через `recipientRef / userHash`, чтобы не протаскивать PII через весь pipeline.
3. **Allocate Personalized Short Links and Send SMS Using Recipient Reference** — интеграционный flow, где short links назначаются на получателей, а SMS Sender резолвит персональные данные только на последнем trusted boundary.

После этого я разложил stories на tasks. Например, отдельно вынес добавление SMS campaign type в существующий campaign flow, отдельно — privacy-safe recipient batch contract, отдельно — integration error handling и status mapping. Это помогло команде не смешивать бизнес-ценность, UI-логику, интеграционные детали, compliance и error handling в одну большую неподъемную задачу.

Моя роль была в том, чтобы держать структуру: от идеи и бизнес-цели до понятного backlog в Jira, acceptance criteria, rules, dependencies, QA focus и документации в Confluence. Я старался не перегружать Epic API-level деталями, а выносил их в linked Stories, Tasks или API specification. В итоге команда получала traceability: от business outcome → Epic → Story → Task → acceptance criteria → testing / rollout.

---

## 2. Мой подход через стадии SDLC

## Stage 1. Discovery / Problem Framing

### Что я делал

На первом этапе я не начинал с полей API или экранов. Я начинал с вопроса: **какую бизнес-проблему мы решаем и зачем это нужно сейчас?**

Для SMS pipeline проблема была шире, чем “добавить отправку SMS”. Нужно было дать CRM / Marketing & Retention команде масштабируемый и контролируемый способ запускать персонализированные SMS-кампании, не перегружая внешние сервисы и не создавая compliance risk.

### Что я выяснял

- Кто основной пользователь: CRM Manager / Marketing & Retention Manager.
- Какой бизнес-результат нужен: запуск персонализированных SMS-кампаний, рост engagement / reactivation, измеримость delivery и clicks.
- Какие системы участвуют: CRM, Player Data, Campaign Processing, SlimLink, SMS Sender / Router, reporting, monitoring.
- Какие ограничения есть: SMS consent, GDPR, PII, limits внешних сервисов, batching, retry, duplicate sending.
- Что уже есть в системе: existing campaign/template flow для Email.
- Что нужно добавить: новый communication type `SMS`, SMS-specific validation и downstream pipeline.

### Артефакты

| Artifact | Где | Что содержит |
|---|---|---|
| Discovery notes | Confluence / working notes | Бизнес-контекст, stakeholders, systems, constraints, assumptions. |
| Problem statement | Confluence / Epic summary | Почему задача нужна и какую проблему решает. |
| Stakeholder / impacted systems map | Confluence | CRM, Player Data, SlimLink, SMS Sender, SMS Router, Operations, Compliance. |
| Open questions list | Jira Epic / Confluence | Вопросы по eligibility, consent, campaign scheduling, status mapping, analytics. |
| Risk list | Jira Epic | Rate limits, duplicate SMS, partial failures, invalid URL/domain, PII exposure. |

### Как это звучит на интервью

> Я стараюсь начинать не с решения, а с framing: кто пользователь, какая бизнес-цель, какие ограничения, какие системы затрагиваются и где основные риски. В этом проекте я быстро понял, что задача не в кнопке “Send SMS”, а в построении controlled campaign delivery pipeline.

---

## Stage 2. Requirements Analysis / Epic Level

### Что я делал

После discovery я оформил Epic как high-level business capability. На уровне Epic я держал фокус на продуктовой цели, scope, NFR, impacted systems, risks и child issues. Детальные payloads, API fields и error reason codes я сознательно не помещал в Epic, чтобы не перегружать его технической детализацией.

### Главный Epic

**SMS_01_Epic.md** — полная версия Epic на английском.  
**SMS_01_Epic_RU.md** — короткая русская версия для интервью.

### Что покрывает Epic

- Business goal / problem.
- Product outcome.
- Business value.
- Scope: In Scope / Out of Scope.
- High-level functional requirements.
- High-level business rules.
- NFR: scalability, reliability, security, compliance, observability.
- Impacted systems.
- Integrations.
- Risks and mitigations.
- MVP / Post-MVP split.
- Child Stories and Tasks.
- Definition of Ready / Definition of Done.

### Артефакты

| Artifact | Где | Что содержит |
|---|---|---|
| Epic | Jira | Business capability, product outcome, scope, requirements, risks, child issues. |
| Epic RU short | Personal interview pack | Короткая версия для рассказа на собеседовании. |
| Jira / Confluence split | Epic / Confluence | Что хранится в Jira, а что в Confluence. |
| DoR / DoD | Jira Epic | Критерии готовности и завершения Epic. |

### Как это звучит на интервью

> На уровне Epic я описывал не API, а бизнес-способность: CRM-команда должна уметь запускать SMS-кампании с персонализированными short links. В Epic я фиксировал scope, impacted systems, NFR, risks и декомпозицию на child issues. Детали API я выносил в linked tasks или API spec.

---

## Stage 3. Solution Analysis / High-Level Design

### Что я делал

После Epic я переходил к solution-level описанию: как системы взаимодействуют между собой и где проходят границы ответственности.

Ключевые решения:

- CRM отвечает за настройку и запуск кампании.
- Player Data Service отвечает за персональные данные, consent и подготовку privacy-safe recipient reference.
- Campaign Processing работает с `recipientRef`, а не с phone number / email / name.
- SlimLink отвечает за short link allocation.
- SMS Sender резолвит recipient reference только на финальном trusted boundary.
- SMS Router выполняет фактическую отправку и возвращает статусы.

### Почему это важно

Такой подход показывает системное мышление: я не просто описываю поля, а думаю о data ownership, compliance, performance, retry behavior, observability и supportability.

### Артефакты

| Artifact | Где | Что содержит |
|---|---|---|
| High-level integration overview | Confluence | CRM → Player Data → Campaign Processing → SlimLink → SMS Sender → SMS Router. |
| Data flow | Confluence / diagram | Какие данные куда передаются, где PII запрещены, где происходит resolution. |
| Sequence diagram | Confluence | Последовательность шагов от campaign launch до SMS sending. |
| Decision log | Confluence | Почему выбран `recipientRef / userHash`, а не raw PII / encrypted PII through pipeline. |
| NFR / constraints section | Confluence / Epic | Batching, rate limits, retry, monitoring, security, compliance. |

### Как это звучит на интервью

> Самое важное архитектурное решение было не протаскивать персональные данные через все CRM-модули. Вместо этого Player Data Service готовит privacy-safe recipient reference, а финальный SMS Sender резолвит телефон только на последнем trusted boundary. Это снижает compliance risk, уменьшает payload и делает логи безопаснее.

---

## Stage 4. Backlog Decomposition / User Stories

### Что я делал

Дальше я декомпозировал Epic на value slices. Для интервью я выбрал не все возможные stories, а самые показательные — те, которые демонстрируют business-facing, compliance и integration thinking.

### Основные stories

| Story | Файл | Что демонстрирует |
|---|---|---|
| Configure and Launch SMS Campaign | `SMS_02_Story_Configure_And_Launch_Campaign.md` | Business flow, UI, reuse existing Email campaign/template functionality, SMS-specific constraints. |
| Prepare Privacy-Safe Recipient Batches | `SMS_03_Story_Prepare_Privacy_Safe_Recipient_Batches.md` | Data minimization, PII protection, consent, recipientRef / userHash, batch preparation. |
| Allocate Short Links and Send SMS Using Recipient Reference | `SMS_04_Story_Allocate_Short_Links_And_Send_SMS_Using_Recipient_Reference.md` | Integration flow, SlimLink boundary, SMS Sender, retry, duplicate prevention, final data resolution. |

### Что входит в каждую Story

- User Story: role, action, business value.
- Business Context.
- Preconditions / Postconditions.
- Main Flow.
- Alternative Flows.
- Edge Cases.
- Functional Requirements.
- Business Rules.
- Acceptance Criteria in Given / When / Then format.
- Validation Rules.
- Permissions.
- Logging / Audit.
- Integration Points.
- Data Requirements.
- UI / UX, если применимо.
- NFR.
- QA Focus.
- Dependencies / Open Questions.
- Story DoR / DoD.

### Как это звучит на интервью

> Я не делал одну огромную story “SMS campaign”. Я разделил ее на value slices. Отдельно — запуск кампании и UI, отдельно — подготовка безопасных batch-ей получателей, отдельно — short link allocation и SMS sending. Так каждая story была понятной, тестируемой и помещалась в sprint-level delivery.

---

## Stage 5. Task-Level Detailing

### Что я делал

После stories я переходил на уровень tasks. Для меня task — это уже не “пользователь хочет”, а конкретная работа для разработки, анализа, интеграции, QA, DevOps или документации.

### Основные tasks

| Task | Файл | Что демонстрирует |
|---|---|---|
| Add SMS Campaign Type to Existing Campaign / Template Flow | `SMS_T01_Task_Add_SMS_Campaign_Type_To_Existing_Campaign_Flow.md` | Как расширить существующий Email flow новым SMS channel, не строя всё с нуля. |
| Define Privacy-Safe Recipient Batch Contract | `SMS_T02_Task_Define_Privacy_Safe_Recipient_Batch_Contract.md` | Как описать data contract без PII, с clear ownership и compliance boundary. |
| Define Integration Error Handling and Status Mapping | `SMS_T03_Task_Define_Integration_Error_Handling_And_Status_Mapping.md` | Как подготовить production-ready behavior: retry, non-retry, partial failures, statuses, monitoring. |

### Что входит в Task

- Context.
- Objective.
- Task Type.
- Scope: In Scope / Out of Scope.
- Expected Output.
- Technical Details.
- Implementation Notes.
- API / Integration Details.
- Data / DB Details.
- Access / Credentials.
- Logging / Monitoring.
- Security / Compliance.
- Completion Criteria / Acceptance Criteria.
- Dependencies.
- Risks.
- Test / Verification Plan.
- Documentation Impact.
- Open Questions.
- Task DoR / DoD.

### Как это звучит на интервью

> На уровне Story я описывал ценность и поведение системы, а на уровне Task — конкретную работу для команды. Например, SMS campaign type — это UI/template extension task; privacy-safe batch contract — analysis/API/data task; error handling and status mapping — integration/QA/operations task. Так backlog был структурирован не только по бизнес-ценности, но и по типу инженерной работы.

---

## Stage 6. Refinement / Alignment with Dev, QA, PO

### Что я делал

На refinement я помогал команде превратить требования в понятную delivery-ready работу:

- объяснял business context;
- уточнял scope;
- выносил спорные вопросы в open questions;
- разделял MVP и Post-MVP;
- уточнял acceptance criteria;
- проверял, что dev / QA одинаково понимают edge cases;
- фиксировал dependencies и blockers;
- помогал оценивать, можно ли story брать в sprint.

### Типичные вопросы, которые я поднимал proactively

- Что произойдет, если часть batch успешно обработалась, а часть нет?
- Где именно можно хранить PII, а где нельзя?
- Должна ли CRM разрешать fallback на default SlimLink domain?
- Что считать retryable error, а что non-retryable?
- Как не отправить SMS повторно при retry?
- Какие статусы нужны CRM Manager, а какие — только Operations?
- Что должно попасть в MVP, а что можно оставить на next iteration?

### Артефакты

| Artifact | Где | Что содержит |
|---|---|---|
| Refinement notes | Jira comments / Confluence | Решения, вопросы, clarifications. |
| Open questions | Jira Story / Epic | Вопросы с owner и статусом. |
| Updated AC | Jira Story | Testable acceptance criteria. |
| Split tasks / subtasks | Jira | Конкретная работа для dev / QA / DevOps. |
| Dependencies list | Jira | Внешние сервисы, access, credentials, API contracts. |

### Как это звучит на интервью

> Моя задача на refinement — не просто “заполнить Jira”, а убрать неоднозначность до начала разработки. Я стараюсь заранее найти места, где команда может по-разному понять requirement: статусы, retry, permissions, partial failures, PII, monitoring. Это снижает количество переделок в sprint.

---

## Stage 7. Development Support

### Что я делал

Во время разработки я поддерживал команду:

- отвечал на уточняющие вопросы;
- обновлял requirements при изменении договоренностей;
- следил, чтобы scope не расползался;
- помогал принимать trade-offs;
- проверял, что implementation не противоречит business rules;
- поддерживал traceability между Epic, Story, Task и Confluence.

### Артефакты

| Artifact | Где | Что содержит |
|---|---|---|
| Updated Jira issues | Jira | Актуальные AC, rules, scope, comments. |
| Decision log updates | Confluence | Почему принято конкретное решение. |
| Clarification comments | Jira / Slack / Confluence | Ответы на вопросы dev / QA. |
| Change notes | Jira / Confluence | Что изменилось и почему. |

### Как это звучит на интервью

> Я не считаю документацию статичной. Во время разработки я поддерживаю ее живой: если меняется решение, я обновляю Story / Task / Confluence, чтобы команда работала с актуальной версией, а не с устными договоренностями.

---

## Stage 8. QA / UAT / Acceptance

### Что я делал

Я заранее думал о тестируемости требований. Acceptance Criteria писал так, чтобы QA мог строить test cases, а PO / business мог понять, что именно будет принято.

### Примеры QA focus

| Area | Что проверяем |
|---|---|
| SMS campaign creation | SMS доступен как новый campaign type, Email controls не показываются для SMS. |
| SMS template validation | Plain text only, no image / HTML components, character count visible. |
| Recipient batch preparation | В batch нет phone number / name / email, только recipientRef и технические поля. |
| Consent / eligibility | Неeligible users исключаются до отправки. |
| SlimLink integration | Successful / failed short link allocation обрабатывается корректно. |
| SMS sending | SMS отправляются только получателям с successful short link. |
| Duplicate prevention | Retry не приводит к повторной отправке одному recipient. |
| Status mapping | Recipient / batch / campaign statuses агрегируются корректно. |
| Logging / audit | В логах нет PII, есть campaignId, batchId, correlationId. |

### Артефакты

| Artifact | Где | Что содержит |
|---|---|---|
| Acceptance Criteria | Jira Story / Task | Given / When / Then scenarios. |
| QA Focus section | Jira Story / Task | Positive, negative, regression scenarios. |
| UAT checklist | Jira / Confluence | Что проверяет business / PO перед acceptance. |
| Defect clarification | Jira comments | Как трактовать найденные проблемы. |

### Как это звучит на интервью

> Я стараюсь писать требования так, чтобы они были testable. Для меня хорошая Story — это не только “что реализовать”, но и “как понять, что это работает”. Поэтому я заранее фиксирую AC, edge cases, negative scenarios и regression impact.

---

## Stage 9. Release / Rollout

### Что я делал

Для такой функциональности важен controlled rollout. SMS-кампании могут затрагивать большое количество пользователей, поэтому нельзя просто включить всё сразу для всех рынков.

### Подход к rollout

- Feature flag для SMS channel.
- Pilot для ограниченного market / tenant / audience size.
- Проверка access / credentials / domain configuration.
- Постепенное увеличение audience size.
- Monitoring ошибок, queue lag, failed batches, delivery statuses.
- Rollback: отключить новые SMS campaign launches, понимая, что уже принятые SMS нельзя “отозвать”.

### Артефакты

| Artifact | Где | Что содержит |
|---|---|---|
| Rollout plan | Confluence / Release notes | Feature flag, pilot, markets, validation steps. |
| Deployment checklist | Jira / Confluence | Access, credentials, config, monitoring, dependencies. |
| Rollback notes | Confluence | Что можно откатить, а что уже ушло во внешний SMS Router. |
| Release notes | Jira / Confluence | Что включено в релиз, known limitations, follow-up items. |

### Как это звучит на интервью

> Для SMS особенно важен controlled rollout, потому что ошибка может привести к массовой некорректной коммуникации. Поэтому я фиксировал feature flag, pilot audience, monitoring и rollback behavior заранее, а не после инцидента.

---

## Stage 10. Monitoring / Feedback / Improvement

### Что я делал

После delivery важно не просто считать задачу Done, а понять, работает ли решение в реальных условиях.

### Что отслеживать

- Campaign launch success / failure.
- Batch processing time.
- SlimLink success / failure rate.
- Retry count.
- Duplicate prevention events.
- SMS Router error rate.
- Delivery status coverage.
- Campaign stuck in Processing.
- Click statistics, если analytics integration включен.

### Артефакты

| Artifact | Где | Что содержит |
|---|---|---|
| Monitoring requirements | Epic / Task / Confluence | Метрики, logs, alerts, dashboard expectations. |
| Operations notes | Confluence | Как support / ops расследует failed campaign. |
| Follow-up backlog | Jira | Post-MVP stories: delivery dashboard, click analytics, audit trail, reprocessing. |
| Improvement items | Jira | Что улучшить после pilot / UAT / production feedback. |

### Как это звучит на интервью

> Для меня SDLC не заканчивается на merge или release. Я смотрю на monitoring, supportability и feedback loop. Если бизнес запустил кампанию, ему нужно понимать не только факт отправки, но и reach, failed deliveries, retries, click engagement и причины ошибок.

---

# 3. Как я структурировал backlog

## Backlog hierarchy

```text
Epic
  → User Stories
      → Tasks
          → Sub-tasks
```

## Как я разделял уровни

| Уровень | Что описывает | Пример из проекта |
|---|---|---|
| Epic | Business capability и end-to-end outcome | SMS Campaign Delivery Pipeline with SlimLink Short Links |
| Story | User / system value slice | Configure and Launch SMS Campaign |
| Task | Конкретная работа для dev / QA / analysis / integration | Define Privacy-Safe Recipient Batch Contract |
| Sub-task | Маленькое исполняемое действие | Add config flag, update validation, add metric, update Swagger |
| Confluence | Stable documentation | Integration overview, sequence diagram, decision log, NFR, API links |

## Главный принцип

Я не смешивал всё в одном документе:

- Epic — для бизнес-цели, scope, systems, risks, NFR.
- Story — для value slice, flow, business rules, AC.
- Task — для технической / аналитической / интеграционной работы.
- Confluence — для стабильных диаграмм, решений, API references, NFR и cross-cutting documentation.

### Как это звучит на интервью

> Я стараюсь держать backlog clean and traceable. Epic отвечает на вопрос “зачем и какой outcome”, Story — “какую ценность получает пользователь или система”, Task — “какую конкретную работу нужно сделать команде”, а Confluence хранит стабильный контекст, diagrams и decisions.

---

# 4. Что именно показывает этот проект обо мне как о BSA / System Analyst

| Компетенция | Как проявилась в проекте |
|---|---|
| Structured thinking | Разложил сложную интеграцию на Epic → Stories → Tasks → AC → QA focus. |
| Business analysis | Начал с business goal, CRM users, campaign outcome, metrics and value. |
| System analysis | Определил impacted systems, integration boundaries, data flow, error handling. |
| Backlog ownership | Подготовил Jira-level artifacts: Epic, Stories, Tasks, DoR / DoD. |
| Proactivity | Заранее поднял вопросы по PII, consent, duplicate sending, rate limits, partial failures. |
| Communication | Разделил сложные technical details на понятные business / dev / QA layers. |
| Compliance thinking | Предложил privacy-safe recipient references вместо передачи PII через весь pipeline. |
| Delivery mindset | Думал не только о требованиях, но и о rollout, monitoring, supportability and future improvements. |

---

# 5. Короткий pitch на 60–90 секунд

Самый интересный проект, который я бы выделил, — это SMS Campaign Delivery Pipeline внутри CRM.

Задача была не просто добавить отправку SMS, а построить end-to-end процесс для Marketing & Retention команды: от настройки кампании и SMS-шаблона до подготовки получателей, персонализированных коротких ссылок, отправки через SMS Router и дальнейшего tracking.

Я начал с discovery: определил бизнес-цель, пользователей, affected systems, ограничения и риски. Затем оформил Epic, где зафиксировал scope, NFR, integrations, risks, MVP и child issues. После этого разложил Epic на stories: launch SMS campaign, prepare privacy-safe recipient batches, allocate short links and send SMS using recipient reference.

Самое важное системное решение было не протаскивать персональные данные через весь pipeline. Вместо этого Player Data Service готовил `recipientRef / userHash`, а финальный SMS Sender резолвил телефон только на последнем trusted boundary. Это снижало compliance risk и упрощало обработку batch-ей, логирование и retry.

Дальше я детализировал stories в tasks: добавление SMS как нового campaign type в существующий Email flow, описание privacy-safe batch contract и error handling / status mapping. Так backlog стал прозрачным: от бизнес-идеи до implementation-ready задач, acceptance criteria, QA scenarios и rollout.

---

# 6. Pitch на 3–5 минут

Наиболее интересным проектом я бы назвал **SMS Campaign Delivery Pipeline** для CRM / Marketing & Retention команды.

Изначальная бизнес-потребность была в том, чтобы команда могла запускать персонализированные SMS-кампании для reactivation, retention и promotional communication. Но при анализе стало понятно, что это не просто новая кнопка в CRM. Нужно было построить надежный end-to-end pipeline, который связывает несколько систем: CRM Campaign Management, Player Data Service, Campaign Processing, SlimLink, SMS Sender / Router и reporting / monitoring.

Я начал с discovery и problem framing. Выяснил, кто основной пользователь, какой бизнес-outcome ожидается, какие системы затронуты, какие ограничения есть по SMS consent, GDPR, PII, внешним лимитам SlimLink, retry и duplicate sending. Также было важно, что в CRM уже существовал функционал создания campaign / template для Email, поэтому мы не строили новый модуль с нуля, а расширяли существующий flow новым communication type — SMS.

На уровне Epic я описал business goal, product outcome, scope, impacted systems, high-level requirements, NFR, risks, dependencies и child issues. Я сознательно не помещал в Epic API payloads и низкоуровневые поля, потому что Epic должен показывать бизнес-способность и delivery scope. Детали API и error mapping я выносил в Stories, Tasks или Confluence/API specification.

Дальше я разложил Epic на несколько ключевых stories. Первая — **Configure and Launch SMS Campaign**. Она покрывала business-facing часть: CRM Manager выбирает SMS как тип кампании, заполняет plain text message, видит character counter, не использует HTML/image controls как в Email, выбирает audience и campaign URL.

Вторая story — **Prepare Privacy-Safe Recipient Batches**. Это была важная системная часть. Я предложил не передавать phone numbers, names или emails через весь pipeline. Вместо этого Player Data Service готовит `recipientRef / userHash`, а промежуточные сервисы работают только с техническим reference. Финальный SMS Sender резолвит телефон только на последнем trusted boundary перед отправкой. Это снижает compliance risk, уменьшает payload и делает логи безопаснее.

Третья story — **Allocate Personalized Short Links and Send SMS Using Recipient Reference**. Она покрывала интеграционный flow: short links назначаются для prepared recipient references, успешные записи идут дальше в SMS sending, failed records не должны приводить к SMS с пустой или некорректной ссылкой. На этом уровне мы также фиксировали retry behavior, duplicate prevention и статус обработки.

Затем я перешел к task-level детализации. Например, отдельная task — добавить SMS campaign type в существующий campaign/template flow. Другая task — определить privacy-safe recipient batch contract. Третья — описать integration error handling и status mapping: какие ошибки retryable, какие non-retryable, как partial failures влияют на recipient, batch и campaign status, как избежать duplicate SMS при retry.

В итоге я получил структурированный backlog: Epic → Stories → Tasks → Acceptance Criteria → QA focus → rollout and monitoring. Это помогло команде видеть не только “что разработать”, но и зачем, в каком scope, какие риски, как тестировать и как поддерживать после release.

Для меня этот проект хорошо показывает мой подход как BSA/System Analyst: я начинаю с бизнес-цели, быстро выявляю ограничения и риски, структурирую требования, разделяю уровни документации, держу backlog понятным для PO, dev, QA и operations, и сопровождаю процесс от идеи до реализации и дальнейших улучшений.

---

# 7. Если попросят показать работу с backlog

Можно ответить так:

Я структурировал backlog в несколько уровней.

На верхнем уровне был Epic — **SMS Campaign Delivery Pipeline**. В нем я зафиксировал business goal, product outcome, MVP scope, NFR, impacted systems, integrations, risks, dependencies и child issues.

Дальше я выделил user/system stories, каждая из которых представляла отдельный value slice:

- CRM Manager can configure and launch SMS campaign;
- System can prepare privacy-safe recipient batches;
- System can allocate personalized short links and send SMS using recipient reference.

После этого stories были разложены на tasks. Например:

- Add SMS campaign type to existing campaign/template flow;
- Define privacy-safe recipient batch contract;
- Define integration error handling and status mapping.

Так я разделил разные типы работы: UI/business flow, data/compliance contract, integration behavior, QA scenarios и operational monitoring. Это помогло не создавать одну огромную размыtую задачу, а подготовить backlog, с которым реально удобно работать в sprint delivery.

---

# 8. Если попросят “а что именно было самым сложным?”

Самое сложное было не в SMS как канале, а в том, чтобы **правильно провести границы ответственности между системами**.

Например, было важно решить:

- где хранится и обрабатывается PII;
- как передавать получателей через pipeline без phone numbers;
- как учитывать consent;
- как работать с partial failures;
- как не отправить SMS повторно при retry;
- как сделать статусы понятными для бизнеса, а не только для разработчиков;
- какие детали держать в Jira, а какие — в Confluence/API spec.

Самым ценным решением было использование privacy-safe `recipientRef / userHash` вместо передачи персональных данных через весь pipeline.

---

# 9. Если попросят “какие артефакты ты подготовил?”

## Confluence-level artifacts

| Artifact | Purpose |
|---|---|
| Project / Solution Overview | Общий контекст проекта, цель, systems, high-level flow. |
| Integration Map | Карта взаимодействия CRM, Player Data, SlimLink, SMS Sender, SMS Router. |
| Sequence Diagram | Последовательность действий от campaign launch до SMS delivery. |
| Decision Log | Зафиксированные решения: privacy-safe references, no API details in Epic, MVP split. |
| NFR / Constraints | Performance, batching, retry, security, compliance, observability. |
| API Specification Links | Детальные payloads, fields, status codes, error mappings. |

## Jira-level artifacts

| Artifact | Purpose |
|---|---|
| Epic | Business capability, scope, NFR, risks, child issues. |
| User Stories | Value slices with flows, AC, rules, permissions, QA focus. |
| Tasks | Implementation / analysis / integration / QA work items. |
| Sub-tasks | Small executable actions for dev / QA / DevOps. |
| DoR / DoD | Readiness and completion criteria. |
| Acceptance Criteria | Testable Given / When / Then scenarios. |

---

# 10. Финальная формулировка про мой подход

Мой подход — это не просто “написать требования”, а **создать понятную систему работы для команды**.

Я начинаю с business goal и user outcome, затем выявляю affected systems, data flows, constraints и risks. После этого структурирую backlog от Epic до Stories и Tasks, фиксирую acceptance criteria, business rules, edge cases, NFR, dependencies и QA focus.

Мне важно, чтобы документация была не формальной, а рабочей: чтобы PO видел scope и value, разработчики понимали implementation boundaries, QA мог писать тесты, Operations понимали monitoring and failure scenarios, а бизнес мог принять результат.

---

# 11. Ключевые фразы для интервью

- “Я стараюсь начинать не с полей и экранов, а с бизнес-цели и outcome.”
- “Epic у меня описывает business capability, а не API payloads.”
- “Stories я режу как value slices, чтобы каждая была понятной, тестируемой и deliverable.”
- “Tasks нужны, чтобы перевести story в конкретную работу для dev / QA / integration / documentation.”
- “Я стараюсь заранее выявлять риски: PII, consent, retry, partial failures, duplicate sending, status mapping.”
- “Для меня backlog — это не список задач, а traceability от бизнес-идеи до реализации и проверки.”
- “Я не храню все детали в Jira. Stable context, diagrams и decision log лучше держать в Confluence, а Jira использовать для delivery.”
- “Хорошая документация должна помогать команде быстрее и точнее разрабатывать, а не просто существовать ради процесса.”
