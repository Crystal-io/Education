# Интервью-шпаргалка: SDLC, Jira, backlog, бизнес-логика и FinTech experience

## Цель документа

Подготовить чёткие, спокойные и senior-level ответы на типовые вопросы технического интервью для Business / System Analyst роли.

Основная идея позиционирования:

> Я не просто “пишу требования”. Я помогаю превратить бизнес-идею или проблему в понятную, проверяемую и реализуемую системную задачу: уточняю бизнес-цель, анализирую ограничения, фиксирую логику, декомпозирую backlog, синхронизирую команды и сопровождаю delivery до UAT/release.

---

# 1. Где должна быть зафиксирована бизнес-логика — в API или документации?

## Короткий ответ

Бизнес-логика должна быть **реализована в системе**, **отражена в API-контрактах**, если влияет на взаимодействие систем, и **зафиксирована в документации** как источник понимания для бизнеса, разработки и QA.

API не должен быть единственным местом хранения бизнес-логики. API описывает контракт взаимодействия: какие данные принимает система, какие проверки выполняются на границе, какие статусы и ошибки возвращаются. Но полная бизнес-логика должна быть описана в требованиях / SRS / Confluence, особенно если она включает правила, ограничения, edge cases, роли, статусы, переходы и исключения.

## Более сильная формулировка для интервью

> Я бы разделил это на три уровня.  
> Первое — бизнес-логика должна быть описана в документации: SRS, functional specification, business rules, BPMN/UML flows. Это нужно, чтобы все участники одинаково понимали ожидаемое поведение системы.  
> Второе — часть этой логики должна быть отражена в API-контракте: обязательные поля, validation rules, error codes, статусы, идемпотентность, ограничения и ожидаемые response scenarios.  
> Третье — фактическая логика должна быть реализована в backend/domain layer и покрыта тестами.  
> Поэтому API — это не “место хранения бизнес-логики”, а интерфейс, через который эта логика проявляется для других систем.

## Пример

Если у нас есть логика авторизации:

- пользователь не может войти после 5 неудачных попыток;
- пароль должен соответствовать security policy;
- заблокированный пользователь не может получить access token;
- все попытки логируются.

Тогда:

| Где фиксируем | Что фиксируем |
|---|---|
| SRS / Confluence | полное бизнес-правило, роли, ограничения, статусы, edge cases |
| API contract / Swagger | endpoint, request/response, error codes: `INVALID_CREDENTIALS`, `USER_LOCKED`, `RATE_LIMITED` |
| Backend | фактическая проверка пароля, блокировка, rate limiting, token generation |
| QA test cases | positive/negative scenarios, lockout, invalid password, expired token |
| Monitoring/logs | failed login attempts, suspicious activity, audit events |

## Главное, что показать интервьюеру

> Документация — источник согласованного понимания.  
> API — контракт взаимодействия.  
> Backend — место реализации бизнес-логики.  
> Тесты и мониторинг — способ доказать, что логика работает правильно.

---

# 2. Как я приоритизирую задачи в backlog и как понимаю, что backlog качественный?

## Короткий ответ

Я приоритизирую backlog не только по “важности для бизнеса”, а по комбинации факторов: business value, urgency, risks, dependencies, effort, regulatory impact, customer impact и technical feasibility.

Качественный backlog — это backlog, где задачи понятны, приоритизированы, готовы к refinement/development, имеют acceptance criteria, owner, dependencies, понятный scope и не содержат хаотичных или дублирующихся items.

## Как приоритизирую

Обычно смотрю на несколько факторов:

| Фактор | Что проверяю |
|---|---|
| Business value | какую бизнес-проблему решаем, какой impact ожидается |
| Customer/User impact | сколько пользователей/клиентов затронуто |
| Urgency | есть ли deadline, legal/regulatory requirement, production issue |
| Risk reduction | снижает ли задача операционный, финансовый или compliance-риск |
| Dependencies | блокирует ли задача другие команды или релизы |
| Effort / complexity | насколько дорого и сложно реализовать |
| Technical feasibility | есть ли архитектурные ограничения |
| Revenue / cost impact | влияет ли на доход, conversion, retention, cost reduction |
| Operational impact | уменьшает ли ручную работу, support load, incidents |

## Формулировка для интервью

> Обычно я начинаю с бизнес-цели и impact. Если задача связана с revenue, compliance, критичным production issue или блокирует другие команды, она получает высокий приоритет. Затем смотрю на зависимости, effort и технические риски.  
> Если команда использует более формальный подход, можно применять MoSCoW, RICE или WSJF. Но даже без формальной модели я стараюсь объяснять приоритет через value, urgency, risk and effort.

## Как понимаю, что backlog качественный

Качественный backlog должен быть:

| Критерий | Что это значит |
|---|---|
| Prioritized | команда понимает, что делать сначала |
| Clear | задача понятна без долгих догадок |
| Testable | есть acceptance criteria |
| Valuable | понятно, зачем задача нужна бизнесу или системе |
| Sized | задача не слишком большая для sprint delivery |
| Refined | нет критичных open questions |
| Traceable | можно связать задачу с epic, requirement, business goal |
| Dependency-aware | зависимости видны и не всплывают в последний момент |
| Clean | нет дублей, мусора, устаревших задач |
| Ready for delivery | dev/QA понимают ожидаемое поведение |

## Definition of Ready для story

Перед тем как отдавать задачу в разработку, я проверяю:

- понятна бизнес-цель;
- описан scope;
- есть acceptance criteria;
- указаны affected systems;
- описаны основные business rules;
- указаны edge cases;
- понятны API/data changes, если есть;
- указаны dependencies;
- QA понимает, как тестировать;
- нет блокирующих open questions.

## Хорошая фраза

> Для меня качественный backlog — это не просто список задач. Это управляемый delivery pipeline, где каждая задача имеет понятную ценность, приоритет, scope, критерии приемки и технический контекст.

---

# 3. Какие issue types использую в Jira и зачем?

## Короткий ответ

Обычно использую Epic, Story, Task и Sub-task. Иногда дополнительно Bug и Spike, если это поддерживается процессом команды.

## Основные issue types

| Issue type | Для чего использую | Пример |
|---|---|---|
| Epic | крупная бизнес-инициатива или capability | `User Authentication` / `Payment Processing` / `CRM Campaign Management` |
| Story | пользовательское или системное поведение, дающее ценность | `As a user, I want to log in using email and password` |
| Task | техническая или аналитическая работа без самостоятельной user story | `Create auth API endpoint` / `Prepare data migration` |
| Sub-task | часть реализации внутри Story/Task | `Add FE validation`, `Implement password hashing`, `Prepare QA cases` |
| Bug | дефект в существующей функциональности | `User receives 500 error after invalid login` |
| Spike | исследование неопределённости | `Investigate OAuth provider integration options` |

## Как объяснять разницу

### Epic

Epic — это верхнеуровневая бизнес-инициатива или capability.

Пример:

> `EPIC: Authentication and Access Management`

Он может включать login, logout, password reset, session management, audit logging, role-based access.

### Story

Story описывает поведение с точки зрения пользователя или системы.

Пример:

> As a registered user, I want to log in with my email and password, so that I can access my account.

Story должна иметь acceptance criteria и быть достаточно маленькой для реализации в sprint.

### Task

Task использую, когда работа техническая или внутренняя и не имеет отдельной пользовательской ценности.

Пример:

- create DB migration;
- update API contract;
- configure logging;
- update Swagger;
- prepare monitoring dashboard.

### Sub-task

Sub-task — это часть работы внутри Story или Task, обычно для распределения между FE/BE/QA.

Пример:

Story: `User login with email and password`

Sub-tasks:

- BE: implement login endpoint;
- FE: create login form;
- QA: prepare test cases;
- DevOps: configure auth logs.

## Хорошая фраза

> Я стараюсь, чтобы Jira отражала delivery logic. Epic показывает бизнес-инициативу, Story — ценность и поведение, Task — техническую работу, Sub-task — конкретный кусок реализации. Это помогает сохранить traceability от бизнес-цели до реализации и тестирования.

---

# 4. Кто занимается разбивкой задач и ведением Jira?

## Короткий ответ

Это совместная ответственность, но роли разные:

- Product Owner отвечает за business priority и product backlog;
- BA/BSA помогает структурировать requirements, разбить scope на Epic/Stories, описать acceptance criteria и dependencies;
- Tech Lead / Developers помогают декомпозировать техническую часть;
- QA помогает формировать test scenarios и выявлять edge cases;
- Scrum Master / Delivery Manager следит за процессом, если такая роль есть.

## Формулировка для интервью

> Обычно первичную структуру backlog я формирую вместе с Product Owner. Мы определяем Epic, scope, business value и основные user/system stories. После этого я выношу задачи на refinement с developers, QA и иногда architect.  
> На refinement мы уточняем технические зависимости, делим слишком большие stories, добавляем technical tasks или sub-tasks, уточняем acceptance criteria и open questions.  
> То есть BA/BSA не должен в одиночку “нарезать” техническую реализацию за разработчиков, но он должен обеспечить, чтобы бизнес-смысл, scope, требования и критерии приемки были понятны и связаны с delivery.

## Как это выглядит на практике

| Роль | Ответственность |
|---|---|
| Product Owner | приоритет, roadmap, business value |
| BA/BSA | требования, scope, AC, business rules, decomposition на Story level |
| Tech Lead | техническое решение, technical tasks, dependencies |
| Developers | оценка, implementation details, sub-tasks |
| QA | test scenarios, edge cases, test coverage |
| Scrum Master / Delivery Manager | процесс, sprint hygiene, ceremonies |

## Хорошая фраза

> Я могу вести Jira с точки зрения аналитики и delivery readiness: создавать и уточнять Epics/Stories/AC, связывать требования, следить за open questions и dependencies. Но техническую декомпозицию всегда валидирую с developers или tech lead, чтобы не подменять инженерное решение аналитическим предположением.

---

# 5. Пример фичи: какие задачи идут на Backend, какие на Frontend  
## Пример: авторизация через login/password

## Контекст

Фича: пользователь может войти в систему с помощью email/login и password.

Business goal:

> Дать пользователю безопасный доступ к личному кабинету / системе, защитить аккаунт от несанкционированного доступа и обеспечить auditability login events.

## Epic

`EPIC: User Authentication`

## User Story

> As a registered user,  
> I want to log in using my email and password,  
> so that I can securely access my account.

## Acceptance Criteria

1. Пользователь может ввести email/login и password.
2. Система валидирует обязательность полей.
3. При корректных данных пользователь успешно авторизуется.
4. При некорректных данных система показывает безопасное сообщение об ошибке.
5. После N неуспешных попыток применяется rate limiting или временная блокировка.
6. Заблокированный/деактивированный пользователь не может войти.
7. Успешные и неуспешные попытки логируются.
8. Access/session token создаётся только после успешной проверки credentials.
9. Сессия истекает согласно security policy.

---

## Backend tasks

| Backend task | Что включает |
|---|---|
| Implement login API endpoint | `POST /auth/login` |
| Validate request | обязательные поля, формат email/login |
| Check user credentials | поиск пользователя, проверка password hash |
| Implement password hashing verification | bcrypt/argon2 или другой утверждённый механизм |
| Generate session/token | JWT/session ID/refresh token — в зависимости от архитектуры |
| Handle inactive/blocked users | отдельные business rules и error codes |
| Implement failed login attempt counter | защита от brute force |
| Add rate limiting / lockout logic | лимит попыток, временная блокировка |
| Define error codes | `INVALID_CREDENTIALS`, `USER_LOCKED`, `RATE_LIMITED` |
| Add audit logging | successful/failed login attempts |
| Update API contract | Swagger/OpenAPI |
| Add unit/integration tests | positive, negative, edge cases |

## Frontend tasks

| Frontend task | Что включает |
|---|---|
| Create login form | поля login/email и password |
| Add client-side validation | required fields, email format |
| Implement submit action | вызов `POST /auth/login` |
| Handle loading state | disable button, spinner |
| Handle API errors | показать понятное сообщение пользователю |
| Handle successful login | redirect to dashboard/account |
| Handle locked/rate-limited state | показать корректное сообщение |
| Implement password visibility toggle | если предусмотрено UX |
| Add “Forgot password?” link | если входит в scope |
| Store auth state safely | в зависимости от выбранной схемы: cookie/session/token |
| Add FE tests | form validation, error handling, success path |

## QA tasks

| QA task | Что включает |
|---|---|
| Prepare test scenarios | positive/negative/login lockout |
| Validate API contract | request/response/error codes |
| Validate UI behaviour | errors, loading, redirect |
| Security-focused checks | brute force, blocked user, expired session |
| Regression testing | logout, session, protected pages |

## Пример Jira-структуры

```text
EPIC: User Authentication

  STORY: User login with email and password
    SUB-TASK BE: Implement POST /auth/login endpoint
    SUB-TASK BE: Add failed login attempt counter
    SUB-TASK BE: Add audit logging for login attempts
    SUB-TASK FE: Create login form
    SUB-TASK FE: Implement API integration and error handling
    SUB-TASK QA: Prepare and execute login test cases

  STORY: Login attempt protection
    SUB-TASK BE: Implement rate limiting
    SUB-TASK BE: Implement temporary lockout
    SUB-TASK QA: Test brute-force protection scenarios
```

## Что важно сказать на интервью

> Я не делю задачи только по FE/BE. Сначала я фиксирую expected behaviour и acceptance criteria на уровне Story. Потом вместе с team/tech lead мы декомпозируем реализацию: backend отвечает за API, security, validation, tokens, business rules and logs; frontend — за форму, UX states, client validation and error handling; QA — за positive/negative scenarios and regression.

---

# 6. С какими системами операционного дня банка, системами учета финансовых компаний, системами эмиссии карт и системами учета операций крипто-биржи мне приходилось работать?

## Главный принцип ответа

Здесь важно не overclaim. Лучше звучать честно и системно:

> Прямого ownership именно над card issuing processor или crypto exchange ledger у меня не было. Но у меня был релевантный опыт с транзакционными FinTech/Banking системами: digital banking, payments, payment-related integrations, AML/regulatory reporting, KYC, payment aggregator, reconciliation/data consistency, микросервисы для финансовой платформы. Поэтому я понимаю природу таких систем: транзакции, статусы, учет, сверка, audit trail, интеграции, ошибки и регуляторные ограничения.

## Структурированный ответ

### 1. Банковский операционный контур / операционный день банка

> В банке я работал не как владелец core banking / операционного дня, но взаимодействовал с банковскими системами и процессами вокруг digital banking, payment-related flows, PSD2/open banking, web/mobile banking changes, integrations with government services and AML reporting.  
> То есть мой опыт был на стороне business/system analysis для банковских каналов и интеграций, где важно учитывать core banking dependencies, regulatory requirements, auditability, data consistency and release control.

Что можно упомянуть:

- web/mobile banking enhancements;
- payment-related flows;
- PSD2/open banking;
- integrations with government/government-related platforms;
- AML reporting integration;
- regulatory reporting;
- UAT/release validation in regulated banking environment.

### 2. Системы учета финансовых компаний

> В VIA SMS Group я работал с финансовой платформой, где были платежи, займы, инвестиционные/регуляторные сценарии, KYC и payment processing. Моя зона была связана с микросервисами, которые обрабатывали customer verification, payments, payment aggregation, email/IMAP communication и данные для последующих финансовых операций.  
> Там был важен не только API flow, но и корректность данных между системами: статусы, суммы, валюты, transaction references, consistency, reconciliation awareness and controlled rollout.

Что можно упомянуть:

- payment aggregator;
- inbound/outbound payments;
- repayment / payment processing;
- KYC / Trulioo;
- MiFID II investor questionnaire;
- IMAP communication service;
- data consistency between services;
- migration from monolith to microservices.

### 3. Системы эмиссии карт

> Прямого production experience с card issuing system или card processor у меня не было. Но я работал с payment-related systems and PSP/banking integrations, где есть близкие аналитические паттерны: transaction lifecycle, statuses, error handling, idempotency, reconciliation, audit trail, regulatory constraints.  
> Если задача будет связана с issuing, мне важно будет быстро погрузиться в specific domain concepts: card lifecycle, authorization, clearing, settlement, chargebacks, limits, cardholder data, PCI DSS and processor integration.

Такой ответ честный и не слабый. Он показывает зрелость.

### 4. Система учета операций крипто-биржи

> Прямого опыта работы с production ledger крипто-биржи у меня не было. Но у меня есть опыт с транзакционными финансовыми системами и payment orchestration design, где похожая логика: операции имеют статусы, источники данных, внешние провайдеры, callbacks/webhooks, retries, reconciliation, audit logs, failure handling and balance-related risks.  
> Поэтому я бы не позиционировал себя как crypto exchange accounting expert, но как BSA/SA, который понимает transaction processing and integration-heavy financial systems.

## Сильная итоговая формулировка

> Если кратко: прямой опыт у меня был с banking digital channels, payment-related integrations, AML/regulatory reporting, KYC, payment aggregator and financial microservices. Прямого ownership над card issuing processor или crypto exchange ledger не было, но у меня есть релевантная база в transaction lifecycle, API integrations, reconciliation awareness, statuses, auditability and failure scenarios.

---

# 7. Пример задачи в FinTech продукте, где балансировал между бизнес-целями и техническими ограничениями

## Лучший пример: Payment Aggregator / VIA SMS

## Короткий ответ

> В VIA SMS Group я работал над payment aggregator / payment processing microservice в рамках перехода от монолита к микросервисной архитектуре. Бизнесу нужно было унифицировать обработку платежей из разных стран и источников, снизить ручную работу и повысить прозрачность payment flows. Технически же были ограничения: существующий монолит, разные форматы данных, разные страны, зависимости от внешних систем, необходимость сохранить стабильность текущих платежных процессов и не нарушить финансовую отчетность.

## Структурированный ответ по STAR

### Situation

Компания переходила от монолитной архитектуры к микросервисной. Один из доменов — платежи и финансовые операции. Нужно было выделить и описать payment-related service / aggregator, который работал с платежами из нескольких регионов и передавал данные дальше по цепочке.

### Task

Моя задача как System Analyst была:

- собрать требования от бизнеса и технических команд;
- описать end-to-end payment flow;
- определить границы сервиса;
- описать API contracts / data mappings;
- учесть разные валюты, статусы, references, ошибки;
- обеспечить понятность для dev/QA;
- поддержать delivery, UAT and rollout.

### Action

Что я сделал:

1. Сначала уточнил бизнес-цель: какие операции должны быть автоматизированы, какие pain points есть в текущем процессе, какие страны/платежные сценарии входят в scope.
2. Разделил требования на MVP и future improvements.
3. Описал payment lifecycle: получение операции, валидация, конвертация/нормализация данных, передача дальше, обработка ошибок.
4. Подготовил requirements и data mappings: суммы, валюты, transaction IDs, statuses, timestamps, references.
5. Согласовал с разработчиками технические ограничения: что можно вынести из монолита сейчас, а что лучше оставить на следующую итерацию.
6. Для QA подготовил acceptance criteria и сценарии проверки: successful flow, invalid data, duplicate transaction, missing reference, integration failure.
7. Во время реализации участвовал в clarification sessions и помогал закрывать open questions.

### Result

> В итоге мы смогли описать и подготовить к реализации более управляемый payment flow, где бизнес получил прозрачность и основу для дальнейшей автоматизации, а разработка — понятные границы сервиса, контракты и проверяемые сценарии. Главный trade-off был в том, что мы не пытались сразу “идеально переписать” весь процесс, а выделили реалистичный MVP, который снижал риски миграции и позволял двигаться итеративно.

## Сильная формулировка для интервью

> Для меня это был хороший пример баланса между business value and technical feasibility. Бизнес хотел быстрее получить унификацию и прозрачность платежей, но технически нельзя было резко разорвать зависимости с монолитом. Поэтому я помог сформировать MVP scope, где мы закрывали ключевые payment scenarios, сохраняли backward compatibility and data consistency, а более сложные improvements оставляли на следующие итерации.

## Альтернативный пример: KYC / Trulioo

Можно использовать, если вакансия больше про compliance/onboarding.

> В KYC-проекте бизнес хотел ускорить customer verification и унифицировать процесс для нескольких стран. Технические ограничения были связаны с разными наборами данных по странам, vendor API, обработкой verification results, error handling and fallback scenarios. Я помог описать country-specific rules, API mapping, decision statuses, negative scenarios and UAT checks. Компромисс был в том, чтобы не пытаться сразу покрыть все edge cases идеально, а запустить стабильный MVP для ключевых стран и расширять правила итеративно.

---

# 8. Почему я сейчас в поиске работы?

## Короткий ответ

> Я завершил предыдущий основной этап работы в iGaming-проекте и сейчас ищу долгосрочную product/system analyst роль, где смогу применить свой опыт в FinTech, payments, integrations, CRM/platform systems and full SDLC ownership. Сейчас для меня важно найти команду и продукт, где я смогу не просто закрывать отдельные задачи, а участвовать в развитии системы, backlog, integrations and delivery quality.

## Более естественная версия

> Сейчас я в поиске, потому что предыдущий основной проектный этап завершился, и я хочу перейти в более долгосрочную продуктовую роль. За последние годы я работал с FinTech, banking, iGaming CRM, integrations and microservices, и понял, что мне наиболее интересны роли, где есть сложная система, понятная бизнес-ценность и возможность влиять на качество решений на всём SDLC — от discovery до release validation.

## Если спрашивают: “Почему ушли с прошлого места?”

> Проектный этап, в котором я активно участвовал, был завершён, и я решил искать следующий вызов в роли Business/System Analyst. Для меня важно развиваться в направлении FinTech/payments/platform products, где мой опыт с integrations, API, transactional flows, backlog and documentation будет максимально полезен.

## Если нужно звучать более уверенно

> Я не ищу просто “любую работу”. Я ищу роль, где мой опыт будет действительно применим: complex product/platform environment, integrations, API, payments or CRM flows, clear ownership across SDLC and collaboration with product and engineering teams.

## Чего лучше не говорить

| Не говорить | Почему |
|---|---|
| “Ищу, потому что закончилась работа” | звучит пассивно |
| “Хочу стабильность” | нормально, но слабо как основной ответ |
| “Мне не нравилась прошлая компания” | рискованный сигнал |
| “Хочу больше денег” | можно обсуждать позже, но не как мотивация |
| “Не знаю, просто ищу” | слабый senior-сигнал |

## Самая безопасная финальная версия

> Я сейчас в поиске, потому что хочу перейти в долгосрочную product/system analyst роль после завершения предыдущего проектного этапа. Мне интересны продукты с сильной системной частью: FinTech, payments, integrations, CRM/platform systems. Я хочу использовать свой опыт не только в documentation, но и в discovery, solution shaping, backlog management, UAT and release validation.

---

# Быстрая версия всех ответов для повторения перед интервью

## 1. Где фиксируется бизнес-логика?

> В документации фиксируется полная бизнес-логика и правила. В API-контракте отражается та часть логики, которая влияет на взаимодействие систем: validation, statuses, errors, required fields. Реализуется логика в backend/domain layer и подтверждается тестами.

## 2. Как приоритизирую backlog?

> По business value, urgency, customer impact, regulatory/compliance impact, dependencies, risks, effort and technical feasibility. Хороший backlog — это понятный, приоритизированный, testable и ready-for-development список задач с clear scope, acceptance criteria and dependencies.

## 3. Какие issue types использую?

> Epic — крупная бизнес-инициатива. Story — пользовательское или системное поведение с ценностью и AC. Task — техническая работа. Sub-task — часть реализации. Дополнительно Bug для дефектов и Spike для исследования неопределённости.

## 4. Кто ведёт Jira?

> PO отвечает за priority and business value. BA/BSA структурирует requirements, Epics/Stories, AC and dependencies. Tech Lead/Developers помогают с technical decomposition. QA добавляет test scenarios. Ведение Jira — совместная ответственность, но BA часто поддерживает delivery readiness и чистоту требований.

## 5. Пример FE/BE задач для login/password

> Backend: login API, password verification, token/session, rate limiting, error codes, audit logs, tests. Frontend: login form, validation, API call, loading/error states, redirect, safe auth state handling. QA: positive/negative/security/regression scenarios.

## 6. С какими финансовыми системами работал?

> Прямой опыт — banking digital channels, payment-related integrations, AML/regulatory reporting, KYC, payment aggregator, financial microservices. Прямого ownership над card issuing processor или crypto exchange ledger не было, но есть релевантный опыт с transaction lifecycle, statuses, reconciliation awareness, API integrations, auditability and failure scenarios.

## 7. Пример баланса business/tech

> В payment aggregator проекте бизнес хотел унифицировать и автоматизировать payment flows, но технически были ограничения монолита, разные страны, форматы данных и зависимости. Я помог выделить MVP, описать payment lifecycle, API/data mappings, statuses, errors, edge cases and UAT scenarios, чтобы дать бизнес-ценность без чрезмерного риска миграции.

## 8. Почему в поиске?

> Я завершил предыдущий основной проектный этап и ищу долгосрочную product/system analyst роль в сложной системной среде: FinTech, payments, integrations, CRM/platform systems. Хочу применять опыт на всём SDLC — от discovery and solution shaping до backlog, UAT and release validation.
