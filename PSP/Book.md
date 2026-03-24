# Senior Business System Analyst: Payments Domain
## Блок 1 — Authorization, Clearing, Settlement, Reconciliation, Tokenization, 3DS

---

**Для кого:** Business System Analyst

**Как использовать:** Каждый день — отдельная тема с теорией, практическими заметками и разделом «Вопросы к интервью». 

---

## Содержание

### День 1 — Authorization Flow & Card Payment Lifecycle
- 1.1 Участники транзакции
- 1.2 ISO 8583 — язык авторизации
- 1.3 Полный цикл авторизации
- 1.4 Online vs Offline Authorization
- 1.5 Pre-Authorization и специальные типы
- 1.6 Decline Handling как функциональное требование
- 1.7 Документирование как Senior BSA
- 1.8 Вопросы к интервью (6 вопросов)
- Практическое задание

### День 2 — Clearing & Settlement
- 2.1 Авторизация ≠ Деньги
- 2.2 Clearing: First Presentment, Batch vs Real-Time
- 2.3 Disputes: Chargeback, Reversal, Second Presentment
- 2.4 Settlement: Net vs Gross, Rolling Reserve
- 2.5 Interchange Fee и EU IFR
- 2.6 DCC и PSD2 disclosure
- 2.7 Late Presentment и типичные проблемы
- 2.8 Вопросы к интервью (6 вопросов)
- Практическое задание

### День 3 — Reconciliation, Tokenization & 3DS 2.x
- 3.1 Four-Way Reconciliation
- 3.2 Exception Management и Aging Buckets
- 3.3 Intraday Liquidity Reconciliation
- 3.4 Tokenization: EMV Spec, типы токенов, lifecycle
- 3.5 3DS 2.x: архитектура, frictionless vs challenge
- 3.6 SCA Exemptions в контексте 3DS
- 3.7 Reconciliation Data Dictionary
- 3.8 Вопросы к интервью (6 вопросов)
- Практическое задание

---

## Условные обозначения

> **BSA-заметка:** Практический совет по документированию или типичная ловушка

> **BSA-задача:** Конкретное deliverable, которое должен уметь создать Senior BSA

❓ **Вопрос к интервью:** Вопрос от опытного тимлида + развёрнутый ответ

📋 **Практическое задание:** Упражнение с конкретным ожидаемым результатом

---

*Продолжение: Блок 2 — Visa/MC Scheme Rules, PSD2, SCA, GDPR (Дни 4-6)*
# День 1. Authorization Flow & Card Payment Lifecycle

> **Цель дня:** Понять жизненный цикл карточной транзакции от момента tap/swipe до получения response code — и уметь задокументировать его как BSA.

---

## 1.1 Участники транзакции

Каждая карточная транзакция — это цепочка из пяти ролей. Ошибка в понимании хотя бы одной из них ведёт к неверным требованиям.

### Cardholder
Держатель карты. Инициирует транзакцию. С точки зрения BSA — источник данных (PAN, expiry, CVV2) и получатель результата (approved/declined).

### Merchant
Торговая точка. Принимает платёж через POS-терминал или payment page. Имеет **MID (Merchant ID)** и **TID (Terminal ID)** — оба обязательны в авторизационном запросе (ISO поля DE41, DE42).

### Acquirer (Эквайер)
Банк мерчанта. Получает транзакцию от мерчанта, маршрутизирует её в платёжную схему, несёт финансовый риск по мерчанту. Важно: эквайер отвечает за compliance мерчанта перед схемой.

### Payment Network (Схема)
Visa, Mastercard — операционный центр, устанавливающий правила, маршрутизирующий транзакции между эквайером и эмитентом, ведущий clearing и settlement.

### Issuer (Эмитент)
Банк держателя карты. Принимает финальное решение: approve или decline. Проверяет баланс, лимиты, fraud-правила, статус карты.

```
Cardholder → Merchant → Acquirer → Network → Issuer
                                              ↓
Cardholder ← Merchant ← Acquirer ← Network ← (decision)
```

> **BSA-заметка:** В функциональных требованиях всегда явно указывайте, какая сторона является **owner** каждого бизнес-правила. Например, лимит по карте — правило эмитента, а floor limit — правило эквайера/мерчанта.

---

## 1.2 ISO 8583 — язык авторизации

ISO 8583 — это стандарт финансовых транзакционных сообщений. Каждое сообщение состоит из **MTI** (Message Type Indicator) и набора **Data Elements (DE)**.

### MTI — тип сообщения

MTI — четырёхзначный код формата `VVVF`, где:
- **V** — версия (0 = 1987, 1 = 1993, 2 = 2003)
- **V** — класс (1 = Authorization, 2 = Financial, 4 = Reversal, 8 = Network)
- **V** — функция (0 = Request, 1 = Request Response, 2 = Advice, 3 = Advice Response)
- **F** — оригинатор (0 = Acquirer, 1 = Issuer)

| MTI | Значение |
|-----|----------|
| 0100 | Authorization Request (от эквайера к эмитенту) |
| 0110 | Authorization Response (от эмитента к эквайеру) |
| 0120 | Authorization Advice (подтверждение после одобрения) |
| 0400 | Reversal Request |
| 0410 | Reversal Response |

### Ключевые Data Elements

| DE | Название | Пример | Обязателен |
|----|----------|--------|-----------|
| DE2 | Primary Account Number (PAN) | 4111111111111111 | Да |
| DE3 | Processing Code | 000000 (purchase) | Да |
| DE4 | Transaction Amount | 000000010000 (€100.00) | Да |
| DE7 | Transmission Date & Time | 0315143022 | Да |
| DE11 | Systems Trace Audit Number (STAN) | 123456 | Да |
| DE12 | Local Transaction Time | 143022 | Да |
| DE22 | POS Entry Mode | 051 (chip+PIN) | Да |
| DE35 | Track 2 Equivalent Data | — | Условно |
| DE41 | Card Acceptor Terminal ID (TID) | TERM0001 | Да |
| DE42 | Card Acceptor ID (MID) | MERCH000000001 | Да |
| DE49 | Currency Code | 978 (EUR) | Да |
| DE55 | ICC Data (EMV) | ... | Для chip |

### DE22 — POS Entry Mode (важен для liability)

| Код | Значение |
|-----|----------|
| 010 | Manual (keyed) |
| 051 | Chip read |
| 071 | Contactless chip |
| 079 | Contactless magnetic stripe |
| 901 | E-commerce |

> **Почему это важно для BSA:** POS Entry Mode определяет **liability shift**. Если мерчант поддерживает chip, но транзакция прошла как magstripe (010) — liability за fraud остаётся у эквайера. Это должно быть задокументировано в требованиях к POS-интеграции.

---

## 1.3 Полный цикл авторизации

### Шаг 1: Card Present — инициация на терминале

1. Держатель карты вставляет/прикладывает карту
2. Терминал читает данные карты (chip / NFC / magstripe)
3. Терминал формирует **Authorization Request (0100)**
4. Запрос уходит к эквайеру через **payment gateway**

### Шаг 2: Routing через схему

Эквайер определяет схему (Visa/MC по BIN-таблице), формирует сообщение по схемному формату и отправляет в **Visa VisaNet / Mastercard Banknet**.

Схема:
- Валидирует формат сообщения
- Маршрутизирует к эмитенту по BIN
- Применяет stand-in rules (если эмитент недоступен)

### Шаг 3: Решение эмитента

Эмитент получает 0100, выполняет проверки:

1. Статус карты (active / blocked / expired)
2. Баланс / кредитный лимит
3. Velocity checks (количество транзакций за период)
4. Fraud rules (geolocation, MCC restrictions, amount thresholds)
5. 3DS / SCA статус (для e-commerce)

Возвращает **Authorization Response (0110)** с кодом ответа в **DE39**.

### Шаг 4: Response Codes (DE39)

| Код | Значение | Действие мерчанта |
|-----|----------|-------------------|
| 00 | Approved | Завершить транзакцию |
| 01 | Refer to card issuer | Попросить позвонить в банк |
| 05 | Do not honour | Отказать |
| 12 | Invalid transaction | Ошибка данных |
| 14 | Invalid card number | Проверить PAN |
| 51 | Insufficient funds | Отказать, предложить другую карту |
| 54 | Expired card | Карта истекла |
| 57 | Transaction not permitted | Ограничение по MCC или типу транзакции |
| 61 | Exceeds withdrawal limit | Превышен дневной лимит |
| 62 | Restricted card | Географическое ограничение |
| 65 | Exceeds withdrawal frequency limit | Слишком много транзакций |
| 91 | Issuer unavailable | Попробовать позже / STIP |

---

## 1.4 Online vs Offline Authorization

### Online Authorization
Терминал отправляет запрос эмитенту в реальном времени. Стандартный режим для большинства транзакций.

**Когда используется:** всегда, кроме случаев ниже.

### Offline Authorization
Терминал принимает решение локально, без связи с эмитентом. Основан на **Floor Limit** — максимальной сумме для офлайн-решения.

**Когда используется:**
- Нет связи с эквайером
- Транзакция ниже floor limit
- Карта поддерживает offline data authentication (ODA)

**Риски для BSA:** Offline-транзакции накапливаются и отправляются в clearing позже. Если карта была заблокирована между offline-авторизацией и clearing — эмитент может отклонить при клиринге (Late Presentment).

### Stand-In Processing (STIP)

Когда эмитент недоступен (timeout > ~8 секунд), схема применяет **STIP** — принимает решение от имени эмитента на основе заранее заданных правил эмитента.

> **BSA-задача:** Требования к STIP-правилам — часть onboarding-документации эмитента в схеме. Необходимо явно документировать: какие типы транзакций разрешены в STIP, максимальные суммы, velocity limits.

---

## 1.5 Pre-Authorization и специальные типы

### Pre-Authorization (Pre-Auth)
Используется когда финальная сумма неизвестна в момент инициации.

**Сценарии:**
- Гостиница: check-in → pre-auth на предполагаемую сумму → check-out → completion (финальная сумма)
- Аренда автомобиля: pre-auth на депозит
- Автозаправка: pre-auth на $1 или фиксированную сумму → completion после заправки

**Жизненный цикл pre-auth:**

```
Pre-Auth Request (0100, DE3=000000) → Approved (hold на сумму)
    ↓
Completion / Incremental Auth → финальная сумма
    ↓ (если не завершён в срок)
Auto-reversal (Visa: 7 дней, MC: 30 дней)
```

### Incremental Authorization
Дополнительная авторизация поверх существующей pre-auth. Используется когда сумма вырастает (например, room service в гостинице).

### Partial Approval
Эмитент одобряет только часть запрошенной суммы. Терминал/приложение должно уметь обрабатывать частичное одобрение (DE6 — Cardholder Billing Amount, DE38 — Authorization Identification Response).

> **BSA-заметка:** Partial approval — отдельный functional requirement. Многие мерчанты его не поддерживают, что нарушает схемные правила. Необходимо явно включать в acceptance criteria.

---

## 1.6 Decline Handling как функциональное требование

Decline — не конец истории. BSA должен задокументировать обработку каждой группы отказов.

### Мягкие отказы (Soft Declines) — можно повторить

| Код | Причина | Действие системы |
|-----|---------|-----------------|
| 51 | Insufficient funds | Предложить меньшую сумму или другую карту |
| 61 | Exceeds limit | Информировать пользователя |
| 65 | Frequency limit | Retry через 24 часа |
| 91 | Issuer unavailable | Retry через 30-60 секунд |

### Жёсткие отказы (Hard Declines) — повтор запрещён

| Код | Причина | Действие системы |
|-----|---------|-----------------|
| 04, 07, 41, 43 | Pick up card / Fraud | Не повторять, уведомить службу безопасности |
| 14 | Invalid PAN | Запросить повторный ввод |
| 54 | Expired card | Запросить актуальную карту |
| 57 | Not permitted | Не повторять |

> **Критическая BSA-ошибка:** Документировать retry-логику без разделения на soft/hard declines. Повторная отправка hard decline — нарушение схемных правил и повод для штрафа.

---

## 1.7 Документирование как Senior BSA

### Sequence Diagram: Authorization Flow

```
Cardholder   Terminal    Gateway     Acquirer    Network     Issuer
    |            |           |           |           |          |
    |--tap/dip-->|           |           |           |          |
    |            |--0100---->|           |           |          |
    |            |           |--0100---->|           |          |
    |            |           |           |--0100---->|          |
    |            |           |           |           |--0100--->|
    |            |           |           |           |          |
    |            |           |           |           |<--0110---|
    |            |           |           |<--0110----|          |
    |            |           |<--0110----|           |          |
    |            |<--0110----|           |           |          |
    |<--result---|           |           |           |          |
```

### Шаблон Business Rule для Authorization

```
BR-AUTH-001: Retry Logic для Soft Declines

Условие: Response Code ∈ {51, 61, 65, 91}
Действие: Система разрешает не более 2 повторных попыток
Интервал: Минимум 60 секунд между попытками
Исключение: RC=91 — первый retry через 30 секунд
Ограничение: Запрещено изменять сумму между попытками без явного действия пользователя
Ответственная сторона: Acquiring system
Источник: Visa Core Rules §5.4 / MC Rules §4.7
```

---

## 1.8 Вопросы к интервью — День 1

---

### ❓ Q1: Объясни разницу между эквайером и процессором. Многие путают эти роли.

**Ответ:**

Эквайер — это **лицензированный участник схемы** (банк или небанковская организация с лицензией Visa/MC), который несёт финансовую и compliance-ответственность за мерчанта перед схемой. Именно эквайер подписывает Merchant Agreement, несёт chargeback-риск и платит схемные взносы.

Процессор — это **технический провайдер**, который обрабатывает транзакции от имени эквайера (или эмитента). Он может не иметь лицензии схемы напрямую.

На практике одна компания может совмещать обе роли (например, Worldpay — и эквайер, и процессор). Но различие важно для BSA: когда документируешь ответственность за compliance, chargeback response time, settlement — это всегда **эквайер**, даже если техническую работу делает процессор.

---

### ❓ Q2: Что такое STAN и зачем он нужен в авторизации?

**Ответ:**

STAN (Systems Trace Audit Number, DE11) — уникальный номер транзакции, присваиваемый эквайером/терминалом в момент формирования запроса. Он используется для **сопоставления запроса и ответа** (matching), а также для **reconciliation**.

Важные свойства STAN:
- Уникален в пределах суток на уровне эквайера
- Сохраняется в ответном сообщении (эмитент возвращает тот же STAN)
- Используется при reversal (отмена должна содержать STAN исходной транзакции)

Как BSA, я документирую STAN как **ключ для matching** в reconciliation-логике и как обязательное поле для audit trail. Потеря STAN = невозможность автоматически сопоставить транзакции при reconciliation.

---

### ❓ Q3: Мерчант говорит: «Нам нужно retry после любого decline». Как ты как BSA отреагируешь?

**Ответ:**

Это типичный запрос от product/бизнеса, который нужно сразу отложить и провести анализ.

Первое, что я делаю — **разделяю decline codes на soft и hard**. Retry после hard decline (04, 41, 43 — fraud/stolen card) — это прямое нарушение Visa Core Rules и MC Rules. Схема может наложить штраф или инициировать VDMP/VCMP compliance programme.

Второе — документирую **разрешённые retry правила по схемам**:
- Visa: не более 15 retry за 30 дней по одной карте/мерчанту, первый retry — не раньше чем через 24 часа (для отдельных кодов)
- MC: схожие ограничения, плюс Excessive Retry Programme с автоматическими штрафами

В итоге в functional spec я пишу два отдельных раздела: Soft Decline Retry Policy и Hard Decline Handling, с явной ссылкой на scheme rules как источник ограничений.

---

### ❓ Q4: Как POS Entry Mode влияет на бизнес-требования к терминалу?

**Ответ:**

POS Entry Mode (DE22) — это не просто технический параметр, это **определитель liability**. Scheme правила устанавливают: если мерчант не поддерживает chip (EMV) и транзакция прошла как magstripe, а потом оказалась мошеннической — **liability за chargeback остаётся у эквайера**, даже если карта была chip-enabled.

Как BSA, я включаю в требования к POS/gateway интеграции:
1. Обязательную поддержку EMV chip (contact + contactless)
2. Корректное заполнение DE22 в зависимости от способа считывания
3. Fallback-логику: chip fail → magstripe fallback должен быть задокументирован отдельно, с логированием причины fallback (ICC Fall-back в DE22=802 или аналог)
4. Для e-commerce: DE22=010 или 081 (credential-on-file)

Это напрямую влияет на chargeback rate мерчанта и его compliance status в схеме.

---

### ❓ Q5: Что такое floor limit и когда его использование рискованно?

**Ответ:**

Floor limit — максимальная сумма транзакции, для которой терминал может принять решение **без онлайн-авторизации** (offline approval). Устанавливается эквайером, иногда схемой.

Риски, которые я документирую в требованиях:

1. **Fraud exposure:** карта могла быть заблокирована после установки floor limit. Offline-одобренная транзакция будет отклонена при клиринге → **Late Presentment chargeback**.
2. **Contactless limits:** в EU под PSD2/SCA карты имеют свои cumulative offline limits (€150 суммарно или 5 транзакций подряд). Терминал обязан запросить онлайн-авторизацию с PIN при превышении. Это требование к POS должно быть явно задокументировано.
3. **Liability:** при offline-fraud liability всегда на стороне, которая не провела онлайн-авторизацию.

В современных платёжных системах floor limit стремится к нулю, кроме специфических use cases (транспорт, парковки).

---

### ❓ Q6: Опиши, что должен содержать functional spec для авторизационного flow. Какие разделы ты считаешь обязательными?

**Ответ:**

Структура, которую я использую:

**1. Context & Scope** — кто участники, какой канал (POS/e-com/MOTO), какие схемы, рынок (EU/UK/global).

**2. Happy Path Flow** — sequence diagram с указанием сообщений (MTI), ключевых DE-полей на каждом шаге, таймаутов.

**3. Business Rules** — каждое правило в формате: условие / действие / исключения / ответственная сторона / источник (scheme rule / regulatory requirement).

**4. Exception Flows** — отдельный flow для каждой группы: timeout, soft decline, hard decline, partial approval, fallback.

**5. Data Dictionary** — все поля, которые система создаёт/изменяет/хранит: тип данных, длина, обязательность, маппинг к ISO-полям.

**6. Non-Functional Requirements** — latency (авторизация < 3 секунды end-to-end), availability (99.95%+), logging requirements (audit trail для каждого DE39).

**7. Acceptance Criteria** — в формате Given/When/Then для каждого сценария: happy path, каждый тип decline, timeout, partial approval.

**8. Compliance Traceability** — ссылки на scheme rules / PSD2 / PCI DSS для каждого требования.

---

## 📋 Практическое задание — День 1

**Задача:** Напиши business rule для следующего сценария:

> Онлайн-мерчант принимает карточные платежи. Требуется задокументировать правила retry после decline с учётом Visa/MC scheme rules. Мерчант хочет автоматически повторять транзакцию каждые 5 минут в течение 24 часов.

**Что нужно сделать:**
1. Определить, какие response codes допускают retry, а какие — нет
2. Написать Business Rule в формате: Условие / Действие / Ограничение / Источник
3. Описать acceptance criteria в формате Given/When/Then для 2 сценариев
4. Указать, что именно в запросе мерчанта нарушает scheme rules

**Ожидаемый результат:** 1 страница документации, пригодная для включения в functional spec.
# День 2. Clearing & Settlement

> **Цель дня:** Понять, что происходит с транзакцией после авторизации — как она превращается в реальное движение денег, и как задокументировать это так, чтобы разработчики и compliance-команда говорили на одном языке.

---

## 2.1 Авторизация ≠ Деньги

Первое и важнейшее понимание: **авторизация — это только резервирование**. Деньги не движутся в момент approve. Деньги движутся через clearing и settlement.

```
Авторизация:  Hold на сумму на карте держателя
Clearing:     Финансовое требование мерчанта к эмитенту (через схему)
Settlement:   Реальное движение денег между банками
```

Временной разрыв между авторизацией и settlement — источник большинства reconciliation-проблем, которые BSA должен предусмотреть в требованиях заранее.

---

## 2.2 Clearing

### Что такое Clearing

Clearing — это процесс **обмена финансовыми данными** между эквайером и эмитентом через платёжную схему. По сути это «выставление счёта»: эквайер говорит эмитенту «держатель твоей карты купил у нашего мерчанта на €X — подтверди».

### First Presentment (TC05 / IPM)

Первичный клиринговый файл, который эквайер отправляет в схему. Содержит:
- Данные оригинальной авторизации (STAN, authorization code)
- Финальную сумму (может отличаться от авторизованной — tip, hotel folio)
- MCC мерчанта
- POS Entry Mode
- Дату транзакции

**Visa формат:** Base II (TC15 — авторизация + клиринг в одном, TC25 — только клиринг)
**Mastercard формат:** IPM (Integrated Processing Messages)

### Clearing Cycle

```
Day 0 (Transaction):  Авторизация → Hold на карте
Day 0-1 (Batch):      Мерчант формирует batch → отправляет эквайеру
Day 1 (Clearing):     Эквайер → Схема → Эмитент (financial data exchange)
Day 1-2 (Settlement): Реальное движение денег
```

### Batch Clearing vs Real-Time Clearing

| Параметр | Batch Clearing | Real-Time Clearing |
|----------|---------------|-------------------|
| Когда | 1-2 раза в сутки (cut-off) | Немедленно после транзакции |
| Используется | Традиционные POS, e-commerce | Instant payments (SEPA Instant) |
| Cut-off risk | Да — пропуск cut-off → задержка | Нет |
| Сложность реконсиляции | Средняя | Высокая (нет batch-ID) |

> **BSA-заметка:** Если в системе есть cut-off time, это обязательный NFR. Пример: «Транзакции, инициированные после 22:00 UTC, включаются в следующий клиринговый цикл». Отсутствие этого требования ведёт к settlement delays и жалобам мерчантов.

---

## 2.3 Disputes: Chargeback, Reversal, Second Presentment

### Reversal (Отмена авторизации)

Отмена происходит до клиринга. Высвобождает hold на карте.

**Типы:**
- **Void:** мерчант отменяет транзакцию до batch submission
- **Authorization Reversal:** отправляется 0400/0410 в схему, если транзакция авторизована, но не будет submitted в клиринг (например, товар не выдан)

> **Важно для BSA:** Схемные правила обязывают отправлять reversal, если авторизованная транзакция не будет клиринговаться в течение N дней. Visa: 7 дней для большинства, 30 дней для hotel/car rental. Несоблюдение → штраф.

### Chargeback

Chargeback — это право держателя карты или эмитента **оспорить транзакцию** и потребовать возврат средств через схему.

**Жизненный цикл chargeback:**

```
1. Cardholder жалуется → Issuer инициирует Chargeback
2. Схема уведомляет Acquirer
3. Acquirer: дебетует мерчанта, может подать Second Presentment
4. Second Presentment: эквайер оспаривает chargeback с доказательствами
5. При разногласии → Pre-Arbitration → Arbitration (Схема решает)
```

### Chargeback Reason Codes — Visa

| Категория | Код | Описание |
|-----------|-----|----------|
| 10.x Fraud | 10.1 | EMV Liability Shift — не использовался chip |
| 10.x Fraud | 10.2 | Card Not Present (CNP) fraud |
| 10.x Fraud | 10.3 | Other Fraud — Present |
| 10.x Fraud | 10.4 | Other Fraud — Absent |
| 10.x Fraud | 10.5 | Visa Fraud Monitoring |
| 11.x Auth | 11.1 | Card Recovery Bulletin |
| 11.x Auth | 11.2 | Declined Authorization |
| 11.x Auth | 11.3 | No Authorization |
| 12.x Processing | 12.1 | Late Presentment |
| 12.x Processing | 12.2 | Incorrect Transaction Code |
| 12.x Processing | 12.3 | Incorrect Currency |
| 12.x Processing | 12.4 | Incorrect Account Number |
| 12.x Processing | 12.5 | Incorrect Amount |
| 12.x Processing | 12.6 | Duplicate Processing / Paid by Other Means |
| 12.x Processing | 12.7 | Invalid Data |
| 13.x Consumer | 13.1 | Merchandise Not Received |
| 13.x Consumer | 13.2 | Cancelled Recurring Transaction |
| 13.x Consumer | 13.3 | Not as Described |
| 13.x Consumer | 13.4 | Counterfeit Merchandise |
| 13.x Consumer | 13.5 | Misrepresentation |
| 13.6 Consumer | 13.6 | Credit Not Processed |
| 13.x Consumer | 13.9 | Non-Receipt of Cash / Load |

### Chargeback SLA

| Событие | Visa | Mastercard |
|---------|------|-----------|
| Срок подачи chargeback эмитентом | 120 дней от даты транзакции или даты, когда стало известно | 120 дней |
| Срок Second Presentment эквайером | 30 дней | 45 дней |
| Pre-Arbitration | 30 дней | 45 дней |
| Arbitration Filing | 10 рабочих дней | 45 дней |

> **BSA-задача:** Chargeback SLA — это операционное требование к диспут-менеджмент системе. Необходимо явно документировать автоматические алерты за 14, 7 и 3 дня до дедлайна.

---

## 2.4 Settlement

### Что такое Settlement

Settlement — это **реальное движение денег** между банками-участниками через settlement bank (или через CLS для FX).

### Net Settlement (Нетто-расчёт)

Наиболее распространённый способ. Все транзакции за период суммируются, и каждый участник получает/платит **чистую разницу**.

```
Пример:
Эмитент А должен заплатить за карты = €1,000,000
Эквайер А должен получить за мерчантов = €800,000
Нетто позиция Банка А: -€200,000 (нетто должник)
```

**Преимущества:** минимальный объём движений денег, ликвидность.
**Недостатки:** при дефолте участника — риск цепной реакции.

### Gross Settlement (Брутто-расчёт)

Каждая транзакция рассчитывается отдельно. Используется в RTGS (Real-Time Gross Settlement) системах — TARGET2 в Европе.

### Settlement Bank

Центральный агент, через которого все участники держат счета для settlement. В EU — обычно ECB (через TARGET2) или крупный коммерческий банк.

### Settlement Timing

| Тип | Описание | Типичный рынок |
|-----|----------|---------------|
| Same-day (T+0) | Редко, только при ранней подаче batch | —  |
| Next-day (T+1) | Стандарт для многих EU-рынков | UK debit |
| Two-day (T+2) | Стандарт Visa/MC international | Большинство рынков |
| Delayed | Для high-risk мерчантов (rolling reserve) | Gaming, travel |

### Rolling Reserve

Эквайер удерживает часть settlement средств мерчанта в резерве как защиту от chargebacks. Типичные параметры: 5-10% в течение 180 дней.

> **BSA-заметка:** Rolling reserve — это отдельный функциональный модуль с требованиями к: расчёту суммы резерва, срокам удержания, условиям высвобождения, отчётности мерчанту. Часто забывается при проектировании merchant portal.

---

## 2.5 Interchange Fee

### Что такое Interchange

Interchange — комиссия, которую **эквайер платит эмитенту** за каждую транзакцию. Это компенсация эмитенту за риск и стоимость программы.

```
Cardholder оплачивает товар €100
Мерчант получает: €100 - MSC (Merchant Service Charge)
MSC = Interchange + Scheme Fee + Acquirer Margin
```

### EU Interchange Fee Regulation (IFR 2015/751)

В Европе interchange жёстко ограничен:

| Тип карты | Лимит |
|-----------|-------|
| Consumer Debit | 0.2% от суммы транзакции |
| Consumer Credit | 0.3% от суммы транзакции |
| Commercial cards | НЕ ограничены IFR |
| Three-party schemes (Amex, Diners) | НЕ ограничены (до достижения порога) |

> **Важно для BSA в EU:** При проектировании fee-расчётов необходимо учитывать категорию карты. Commercial card (business card) обрабатывается иначе — interchange не регулируется. Если система не умеет различать consumer/commercial — это compliance risk.

### DCC — Dynamic Currency Conversion

DCC позволяет держателю карты платить в валюте своей карты (а не локальной валюте мерчанта).

**Требования PSD2 (art. 45) к DCC:**
- Полное раскрытие обменного курса ДО транзакции
- Сравнение с референсным курсом ECB
- Явный выбор держателя карты (opt-in)
- Запрет на предустановленный выбор DCC

> **BSA-задача:** DCC disclosure — обязательный functional requirement для EU. Acceptance criteria: «Система отображает markup в % над ECB reference rate до подтверждения транзакции. Холд по транзакции размещается только после явного согласия держателя».

---

## 2.6 Late Presentment и типичные проблемы

### Late Presentment

Clearing-файл подан позже допустимого срока. Эмитент вправе выставить chargeback (RC 12.1).

| Схема | Максимальный срок presentment |
|-------|-------------------------------|
| Visa | 30 дней от даты транзакции |
| Mastercard | 30 дней |
| Hotel/Car Rental | До 30 дней после check-out |

### Дублированные транзакции (RC 12.6)

Мерчант отправил один и тот же batch дважды. Является типичной причиной chargeback.

**Защита:** уникальный ключ на уровне clearing-записи (STAN + TID + date + amount). Требование к системе: дедупликация на уровне batch processing.

### Amount Mismatch

Сумма в клиринге не совпадает с авторизованной. Допустимые расхождения:

| Тип мерчанта | Допустимое расхождение |
|--------------|----------------------|
| Ресторан (tip) | До 20% сверх авторизованной суммы |
| Гостиница | До 15% или фиксированная надбавка |
| Прочие | 0% (точное совпадение) |

---

## 2.7 Reconciliation Overview (Введение)

Детальная reconciliation — тема Дня 3. Здесь — базовое понимание.

**Reconciliation** — процесс сверки данных между несколькими системами для подтверждения, что каждая транзакция:
1. Авторизована
2. Клирингована
3. Рассчитана
4. Отражена в GL (General Ledger)

```
Уровни reconciliation:
1. Auth ↔ Clearing   (все авторизации дошли до клиринга?)
2. Clearing ↔ Settlement (всё что клирингалось — рассчиталось?)
3. Settlement ↔ GL   (банковская выписка = записи в GL?)
4. GL ↔ Merchant Statement (мерчант получил то, что ожидал?)
```

---

## 2.8 Вопросы к интервью — День 2

---

### ❓ Q1: Объясни разницу между авторизацией и settlement. Почему это важно для BSA?

**Ответ:**

Авторизация — это **право на транзакцию** (hold на карте, согласие эмитента). Settlement — это **исполнение финансового обязательства** (реальное движение денег между банками).

Для BSA это критически важно по нескольким причинам:

Во-первых, временной разрыв. Между авторизацией и settlement может пройти 1-2 дня (а для hotel/travel — до 30 дней). В этот период карточный hold есть, а деньги ещё не ушли. Это нужно учитывать в UX — показывать пользователю «pending» статус.

Во-вторых, суммы могут различаться. Авторизованная сумма — это «резерв», а клиринговая — финальная (tip, folio adjustment). Требование к системе: хранить обе суммы и обрабатывать расхождение.

В-третьих, reversal и refund — разные вещи. Reversal отменяет авторизацию (до клиринга). Refund — это клиринговая операция после settlement. Это два разных flow с разными правилами и разными ISO-транзакциями.

---

### ❓ Q2: Мерчант жалуется на высокий chargeback rate. Как ты подойдёшь к анализу как BSA?

**Ответ:**

Я начинаю с **классификации chargeback по reason codes**, потому что причина определяет решение.

Если доминируют 10.x (Fraud) — проблема в fraud prevention: нет 3DS, нет velocity checks, нет device fingerprinting. Решение на стороне fraud tools, не процессинга.

Если доминируют 13.1 (Merchandise Not Received) или 13.3 (Not as Described) — проблема в операционной части мерчанта, не в платёжной системе. Но BSA может помочь с dispute evidence automation.

Если доминируют 11.2/11.3 (No Authorization / Declined Auth) — системная проблема: мерчант клирингует транзакции без действующей авторизации, либо авторизации истекают. Это требование к auth-clearing matching логике.

Если доминируют 12.1 (Late Presentment) — операционная проблема: batch submission после cut-off. Требование к мониторингу batch timing.

Для каждой категории я пишу отдельные remediation requirements с measurable acceptance criteria. Chargeback rate — это **lagging indicator**, поэтому в требованиях нужны leading indicators (мониторинг fraud score, Auth-to-Clear rate, batch timing alerts).

---

### ❓ Q3: Что такое rolling reserve и какие требования к системе из этого вытекают?

**Ответ:**

Rolling reserve — это механизм риск-управления эквайера. Часть settlement средств мерчанта удерживается в резерве (обычно 5-10% на 90-180 дней) для покрытия возможных chargebacks.

Из этого вытекают несколько функциональных требований:

**Расчёт резерва:** система должна автоматически вычислять сумму удержания по каждому settlement batch: `reserve_amount = batch_net_amount × reserve_rate`. Это правило должно быть параметризуемым — разные мерчанты имеют разные rates.

**Tracking и rollover:** каждое удержание должно быть привязано к дате — через 180 дней оно «освобождается» и включается в следующий settlement мерчанту. Требование к системе: очередь удержаний с датами rollover.

**Мерчант-отчётность:** мерчант должен видеть в portal: текущую сумму резерва, дату следующего rollover, историю удержаний и высвобождений. Это UI/reporting requirement.

**Корректировки:** если reserve_balance > outstanding_chargebacks на момент закрытия аккаунта — излишек должен быть возвращён. Требование к offboarding flow.

---

### ❓ Q4: Что такое interchange и почему EU IFR важен при проектировании платёжной системы?

**Ответ:**

Interchange — это комиссия, которую эквайер платит эмитенту за каждую транзакцию. Это не «прибыль» никакой стороны напрямую — это transfer pricing в платёжной экосистеме, компенсирующий эмитенту стоимость credit risk, fraud management, rewards programme.

EU Interchange Fee Regulation 2015/751 ограничивает interchange для потребительских карт: 0.2% для дебетовых, 0.3% для кредитных. Это напрямую влияет на BSA-задачи в нескольких местах:

**Fee calculation engine:** система должна применять правильную interchange категорию. Для этого нужно определить тип карты (consumer vs commercial) по BIN. Если BIN lookup неверно классифицирует карту — мерчант либо переплачивает, либо недоплачивает.

**Commercial cards:** на них IFR не распространяется. Interchange может быть значительно выше. Требование: отдельная категория в fee engine с возможностью применения uncapped rates.

**Reporting:** EU IFR требует раскрытия interchange информации в merchant statements. Это regulatory requirement к merchant reporting module.

**DCC disclosure:** PSD2 art.45 требует показывать markup над ECB rate при DCC — это отдельное UI/flow требование.

---

### ❓ Q5: Опиши, как бы ты написал acceptance criteria для settlement reconciliation feature.

**Ответ:**

Я использую формат Given/When/Then с явным указанием данных и граничных условий.

```
Feature: Settlement Reconciliation

Scenario 1: Happy Path — всё сошлось
Given: Settlement file от схемы содержит 1000 записей на сумму €50,000
And: В clearing database 1000 matching записей (по STAN + TID + date)
When: Reconciliation job запускается в 06:00 UTC
Then: Статус всех 1000 записей = "Reconciled"
And: Net settlement amount = €50,000 (±€0.01 tolerance)
And: Reconciliation report сгенерирован и отправлен на email операционной команды

Scenario 2: Unmatched item
Given: Settlement file содержит запись с STAN=123456, которой нет в clearing DB
When: Reconciliation job запускается
Then: Запись помечается как "Unmatched — Settlement side"
And: Алерт отправлен operations team в течение 15 минут
And: Запись добавлена в Exception Queue для ручной обработки

Scenario 3: Amount Mismatch
Given: Clearing запись на €100.00 matched с settlement записью на €99.99
When: Reconciliation job запускается
Then: Если расхождение ≤ €0.01 — помечается как "Reconciled with tolerance"
If расхождение > €0.01 — помечается как "Amount Mismatch Exception"
And: Exception report содержит обе суммы, разницу и источник расхождения
```

---

### ❓ Q6: Чем отличается refund от reversal? Почему это разные процессы с разными требованиями?

**Ответ:**

Это одно из ключевых понятий, которое часто путают.

**Reversal** — отмена авторизации **до** того, как транзакция ушла в клиринг. Технически это сообщение 0400 (Reversal Request). Результат: hold с карты снимается немедленно (или в течение нескольких часов). Деньги никуда не двигались — их и не нужно возвращать.

**Refund (Credit)** — это отдельная клиринговая операция **после** settlement. Мерчант инициирует credit transaction, которая проходит через clearing → settlement в обратном направлении. Срок зачисления: 1-5 рабочих дней в зависимости от банка держателя.

Требования к системе принципиально разные:
- Reversal: должен быть отправлен в схему немедленно, содержать original STAN, есть deadline (обычно в тот же день или до batch cut-off)
- Refund: создаётся как новая транзакция, не привязана к original auth через ISO-протокол (только через внутренний order reference), имеет отдельный reconciliation flow

Частая ошибка в требованиях — описывать один "cancel/refund" flow без разделения. Это приводит к тому, что система пытается сделать reversal на уже клирингованную транзакцию (невозможно) или делает refund на то, что можно было просто зареверсировать (задержка для держателя карты).

---

## 📋 Практическое задание — День 2

**Задача:** У тебя есть следующий сценарий:

> Онлайн-мерчант продаёт travel-пакеты. Клиент бронирует тур за €3,000 сегодня, поездка через 60 дней. Мерчант хочет авторизовать и клирингнуть сразу. Также мерчант принимает карты из других стран — клиенты из США хотят платить в USD.

**Что нужно сделать:**
1. Определить проблемы в описанном сценарии с точки зрения scheme rules
2. Предложить корректный auth → clearing timing для travel-мерчанта
3. Написать requirements для DCC feature с учётом PSD2 art. 45
4. Описать, какие данные нужно хранить для reconciliation этого типа транзакций

**Ожидаемый результат:** Issue list + 3 functional requirements с acceptance criteria.
# День 3. Reconciliation, Tokenization & 3DS 2.x

> **Цель дня:** Освоить три темы, которые отличают senior-уровень от middle: production-ready reconciliation (не «сравнить файлы», а full exception management), tokenization как архитектурное решение, и 3DS как смычок между безопасностью и UX.

---

## 3.1 Four-Way Reconciliation

### Зачем нужна четырёхсторонняя сверка

Двусторонней сверки (например, auth vs clearing) недостаточно. Деньги могут быть «потеряны» на любом переходе. Senior BSA проектирует reconciliation как систему из четырёх уровней.

```
УРОВЕНЬ 1:  Authorization DB  ←→  Clearing DB
УРОВЕНЬ 2:  Clearing DB       ←→  Settlement File (от схемы)
УРОВЕНЬ 3:  Settlement File   ←→  Bank Statement (SWIFT MT940 / SEPA CAMT.053)
УРОВЕНЬ 4:  Bank Statement    ←→  General Ledger (GL)
```

### Matching Rules — правила сопоставления

Каждый уровень использует свой matching key:

| Переход | Matching Key | Примечание |
|---------|-------------|-----------|
| Auth ↔ Clearing | STAN + TID + Date | STAN уникален в пределах дня и TID |
| Clearing ↔ Settlement | ARN (Acquirer Reference Number) | Глобально уникален для каждой транзакции |
| Settlement ↔ Bank | Settlement Batch ID + Amount | Нетто-сумма по batch |
| Bank ↔ GL | Bank Transaction Reference | Зависит от ERP системы |

### ARN — Acquirer Reference Number

ARN — критически важный идентификатор. Это **глобально уникальный номер**, присваиваемый каждой клиринговой транзакции. Формат:

```
Visa ARN: 15 цифр
Mastercard: Отдельный Reference Number в IPM
```

ARN — основной ключ для cross-level reconciliation. Если в системе нет хранения ARN — full reconciliation невозможна. Это обязательное поле в data dictionary.

---

## 3.2 Exception Management

### Типы исключений

| Тип | Описание | Вероятная причина |
|-----|----------|-----------------|
| **Auth без Clearing** | Авторизация есть, клиринга нет | Мерчант не сдал batch / timeout |
| **Clearing без Auth** | Клиринг есть, авторизации нет | Late auth, force-post, STIP |
| **Settlement без Clearing** | Settlement file содержит запись без клиринга | Ошибка схемы (редко) |
| **Amount Mismatch** | Суммы на разных уровнях не совпадают | Tip adjustment, currency rounding |
| **Duplicate** | Та же транзакция присутствует дважды | Double batch submission |
| **Unmatched Reversal** | Reversal без matching оригинала | Reversal на уже клирингованную транзакцию |

### Aging Buckets

Исключения не обрабатываются мгновенно. BSA должен запроектировать **aging buckets** — категории по сроку «жизни» исключения:

| Bucket | Срок | Действие |
|--------|------|---------|
| Fresh | 0-1 день | Автоматический retry matching |
| Aging | 2-5 дней | Алерт операционной команде |
| Stale | 6-14 дней | Эскалация, ручная обработка |
| Write-off candidate | >30 дней | Финансовый анализ, списание |

### Write-off Policy

Не все исключения можно разрешить технически. BSA должен задокументировать **threshold для write-off**:

```
Бизнес-правило: Исключение типа "Amount Mismatch" с разницей ≤ €0.05
может быть auto-written-off после 7 дней без резолюции.
Исключения с разницей > €0.05 требуют ручного одобрения Finance.
```

---

## 3.3 Intraday Liquidity Reconciliation

### Проблема

В реальном времени (RTGS, SEPA Instant) settlement происходит непрерывно. Организация должна знать свою **liquidity position** в любой момент, а не только после дневного cut-off.

### Intraday Cash Flow

```
Начало дня: Opening Balance (из вчерашнего закрытия)
В течение дня: +Settlements In (входящие) / -Settlements Out (исходящие)
Конец дня: Closing Balance = Opening + In - Out
```

### Требования к системе

1. **Real-time position feed:** каждый settlement event обновляет внутренний position counter
2. **Threshold alerts:** алерт при падении balance ниже X (liquidity floor)
3. **Intraday reconciliation report:** сверка internal position с MT942 (intraday bank statement)
4. **Forecasting:** прогноз position на конец дня на основе ожидаемых settlements

---

## 3.4 Tokenization

### Зачем нужна токенизация

Токенизация заменяет чувствительные данные карты (PAN) на **токен** — суррогатный идентификатор, бесполезный для злоумышленника без доступа к token vault.

**Два главных мотива:**
1. **Безопасность:** если токен украден — он не может быть использован вне контекста
2. **PCI DSS scope reduction:** система, хранящая только токены (не PAN), выходит из части PCI DSS требований

### Участники EMV Payment Tokenisation Ecosystem

**Token Service Provider (TSP):** центральный орган, управляющий token vault. Это схема (Visa Token Service, Mastercard Digital Enablement Service) или сертифицированный third-party (например, банк).

**Token Requestor (TR):** сторона, запрашивающая токен. Например: Apple Pay (TR ID = Apple), Google Pay, мерчант для Card-on-File.

**Token Vault:** защищённое хранилище маппинга PAN ↔ Token. Недоступно напрямую.

**Issuer:** участвует в provisioning (подтверждает, что карта действительна, верифицирует держателя).

### Типы токенов

| Тип | Кто запрашивает | Где используется | Scope |
|-----|-----------------|-----------------|-------|
| **Device Token** | Apple Pay / Google Pay | Конкретный девайс | Привязан к device + merchant domain |
| **CoF Token (Card-on-File)** | Мерчант | Повторные платежи | Привязан к мерчанту |
| **Network Token** | Эквайер / PSP | Широкое использование | Управляется схемой |

### Token Lifecycle

```
1. PROVISIONING:
   TR запрашивает токен → TSP проверяет PAN у эмитента → 
   Эмитент подтверждает / запрашивает ID&V (верификацию держателя) →
   TSP создаёт токен, сохраняет в vault → возвращает TR

2. ACTIVATION:
   Токен активируется только после успешной ID&V
   (OTP на телефон, in-app verification, биометрия)

3. ИСПОЛЬЗОВАНИЕ:
   TR подставляет токен вместо PAN в транзакцию →
   Gateway/Acquirer передаёт токен в схему →
   Схема de-tokenizes → эмитент видит оригинальный PAN

4. LIFECYCLE EVENTS:
   SUSPEND: временная блокировка (потеря телефона)
   RESUME: восстановление
   DELETE: постоянное удаление (при продаже телефона)
   
5. TOKEN REPLENISHMENT:
   Токены имеют cryptogram (TAVV) — одноразовый код для каждой транзакции.
   При исчерпании — автоматическое обновление через UCAF/AAV mechanism
```

### De-tokenization

Когда токен приходит в транзакции, схема (TSP) заменяет его PAN до передачи эмитенту. Эмитент **не видит токен** — он видит оригинальный PAN.

Исключение: некоторые эмитенты получают и PAN, и токен для analytics (Token Assurance Level).

### PAN → Token в контексте PCI DSS

| Сценарий | PCI DSS Scope |
|----------|--------------|
| Хранение PAN | CDE (Cardholder Data Environment) — full scope |
| Хранение токена (без PAN) | Reduced scope — токен не считается CHD |
| Хранение токена + де-токенизация на стороне | Full scope (система видит PAN в процессе) |

> **BSA-заметка:** Если в требованиях написано «система хранит card details» — это автоматически тянет full PCI DSS audit. Правильная формулировка: «Система хранит network token, полученный через TSP. Оригинальный PAN не хранится и не логируется».

---

## 3.5 3DS 2.x — архитектура и flows

### История и мотивация

3D Secure (3DS) — протокол дополнительной аутентификации держателя карты при e-commerce транзакциях.

- **3DS 1.0:** перенаправление в iframe/popup → плохой UX → abandonment 15-25%
- **3DS 2.x:** data-rich authentication, поддержка mobile SDK, frictionless flow → abandonment <5%

PSD2 SCA требует применения 3DS (или эквивалентного протокола) для большинства e-commerce транзакций в ЕС.

### Участники 3DS 2.x

**3DS Server (3DSS):** компонент на стороне эквайера/мерчанта. Собирает данные транзакции и устройства, инициирует 3DS flow.

**Directory Server (DS):** компонент схемы (Visa — Visa DS, MC — Mastercard DS). Маршрутизирует запросы к нужному ACS, хранит данные схемы.

**Access Control Server (ACS):** компонент эмитента. Принимает финальное решение о frictionless или challenge.

**3DS SDK:** компонент мобильного приложения мерчанта. Собирает device data, обеспечивает in-app challenge flow без browser redirect.

```
3DS Server (Merchant/Acquirer) → Directory Server (Scheme) → ACS (Issuer)
```

### Два режима аутентификации

#### Frictionless Flow (бесшовный)
ACS принимает решение автоматически на основе данных транзакции. Держатель карты ничего не делает.

```
1. 3DSS собирает device data (browser info, IP, timezone, screen size...)
2. AReq (Authentication Request) → DS → ACS
3. ACS анализирует данные (ML risk model)
4. ACS решает: риск низкий → frictionless
5. ARes (Authentication Response): transStatus = "Y" (authenticated)
6. CAVV/AAV генерируется → передаётся в authorization
```

#### Challenge Flow (с подтверждением)
ACS требует взаимодействия с держателем карты.

```
1. AReq → DS → ACS
2. ACS решает: нужен challenge
3. ARes: transStatus = "C" (challenge required)
4. CReq (Challenge Request): держатель вводит OTP / биометрия / вопрос
5. CRes (Challenge Response): transStatus = "Y" или "N"
```

### ECI — Electronic Commerce Indicator

ECI — код, передаваемый в авторизацию, показывающий результат 3DS аутентификации.

| ECI | Схема | Значение |
|-----|-------|----------|
| 05 | Visa | Успешная аутентификация (full) |
| 06 | Visa | Попытка аутентификации (attempt) |
| 07 | Visa | Без аутентификации |
| 02 | MC | Успешная аутентификация |
| 01 | MC | Попытка аутентификации |
| 00 | MC | Без аутентификации |

### CAVV / AAV — Cardholder Authentication Verification Value

Криптографическое значение, подтверждающее успешную аутентификацию. Генерируется ACS, передаётся в авторизацию (DE55 или отдельное поле). Эмитент верифицирует CAVV при авторизации.

### Liability Shift

Одна из важнейших причин внедрения 3DS — **перенос ответственности за fraud**:

| Сценарий | Liability |
|----------|----------|
| 3DS пройден (ECI=05/02) | Эмитент несёт liability за fraud chargeback |
| 3DS attempt (ECI=06/01) | Эмитент несёт liability за fraud chargeback |
| 3DS не применён | Эквайер/мерчант несёт liability |
| 3DS failed (transStatus=N) | Эмитент несёт liability |
| ACS недоступен | Attempt — liability shift применяется |

> **BSA-заметка:** Liability shift — это бизнес-кейс для внедрения 3DS, не технический. В требованиях нужно явно документировать: для каких транзакций 3DS обязателен (в EU — все CNP), и что система должна делать при ACS timeout (attempt flow).

---

## 3.6 SCA Exemptions в контексте 3DS

PSD2 RTS on SCA определяет случаи, когда SCA не требуется. Это напрямую влияет на 3DS flow.

### Transaction Risk Analysis (TRA)

Эмитент или эквайер может применить TRA exemption, если:
- Fraud rate ниже установленного порога
- Сумма транзакции не превышает TRA threshold

| Fraud Rate PSP | Max Transaction Amount для TRA |
|---------------|-------------------------------|
| ≤ 0.13% | €100 |
| ≤ 0.06% | €250 |
| ≤ 0.01% | €500 |

### Low Value Exemption

Транзакции ≤ €30 освобождены от SCA, **при условии**:
- Не более 5 последовательных exempted транзакций на карту
- Суммарно не более €100 с момента последней SCA

**Важно:** это cumulative limit, система обязана отслеживать счётчик по каждой карте.

### Merchant Initiated Transactions (MIT)

Транзакции, инициированные мерчантом без участия держателя (subscription, installment, unscheduled CoF). SCA не требуется, но первая транзакция в серии должна пройти SCA.

**Требование к системе:** хранить ссылку на initial SCA transaction для каждой MIT серии. Поле в ISO: DE48 / UCAF network reference.

### Trusted Beneficiary (Merchant Whitelisting)

Держатель карты может добавить мерчанта в whitelist через интерфейс банка. Последующие транзакции у этого мерчанта освобождены от SCA.

**Требование:** механизм передачи whitelist-статуса от эмитента к схеме, и проверка 3DSS перед запросом SCA.

### Decision Tree: Какой Flow Применять

```
CNP транзакция получена
    ↓
Проверить: применимы ли исключения?
    ├── Low Value (≤€30) + счётчик не исчерпан → Request Exemption
    ├── TRA (сумма ≤ threshold + fraud rate ≤ limit) → Request Exemption
    ├── MIT → No SCA, attach original transaction reference
    ├── Recurring (fixed amount/interval) → No SCA after first
    └── Нет исключений → Full 3DS Flow
         ↓
     3DS Result = frictionless/challenge
         ↓
     CAVV + ECI передаются в Authorization
```

---

## 3.7 Документирование: Reconciliation Data Dictionary

Пример data dictionary для reconciliation-записи (обязательный артефакт senior BSA):

| Поле | Тип | Длина | Источник | Обязательно | Описание |
|------|-----|-------|----------|------------|----------|
| transaction_id | UUID | 36 | Internal | Да | Внутренний ID |
| stan | VARCHAR | 6 | DE11 | Да | Systems Trace Audit Number |
| arn | VARCHAR | 23 | Scheme | Да | Acquirer Reference Number |
| auth_amount | DECIMAL | 12,2 | DE4 | Да | Авторизованная сумма |
| clear_amount | DECIMAL | 12,2 | Clearing file | Да | Клиринговая сумма |
| settlement_amount | DECIMAL | 12,2 | Settlement file | Да | Settlement сумма |
| auth_currency | CHAR | 3 | DE49 | Да | ISO 4217 currency code |
| settlement_currency | CHAR | 3 | Settlement file | Да | Валюта settlement |
| auth_datetime | TIMESTAMP | — | DE7+DE12 | Да | UTC timestamp авторизации |
| clearing_date | DATE | — | Clearing file | Да | Дата clearing batch |
| settlement_date | DATE | — | Settlement file | Да | Дата settlement |
| recon_status | ENUM | — | Internal | Да | RECONCILED / UNMATCHED / EXCEPTION |
| exception_type | VARCHAR | 50 | Internal | Нет | Тип исключения |
| exception_age_days | INT | — | Computed | Нет | Дней с момента создания исключения |

---

## 3.8 Вопросы к интервью — День 3

---

### ❓ Q1: Как ты проектируешь reconciliation систему для платёжного процессора? С чего начинаешь?

**Ответ:**

Я начинаю с **data flow mapping** — прежде чем думать о matching logic, нужно понять, какие данные откуда приходят и в каком формате.

Шаг 1: Инвентаризация источников данных. Authorization DB (internal), Clearing files (Base II/IPM от схем), Settlement files (MT940, CAMT.053, scheme settlement reports), Bank statements, GL entries. Каждый источник имеет свой формат, encoding, cut-off time и SLA доставки.

Шаг 2: Определение matching keys на каждом переходе. Как я описал — STAN для auth↔clearing, ARN для clearing↔settlement, batch ID для settlement↔bank. ARN — ключевое поле, его обязательно нужно сохранять с момента clearing.

Шаг 3: Exception taxonomy. Не все несоответствия — ошибки. Amount mismatch на €0.01 — это FX rounding, не проблема. Amount mismatch на €100 — это серьёзно. Я документирую tolerance rules и action по каждому типу.

Шаг 4: SLA и escalation. Каждый тип исключения должен иметь: время до первого алерта, escalation path, максимальное время резолюции до write-off.

Шаг 5: Reporting. Operations dashboard с real-time метриками: reconciliation rate (%), open exceptions count, average resolution time, aging distribution.

---

### ❓ Q2: Объясни разницу между network token и CoF token. Когда использовать каждый?

**Ответ:**

**CoF token (Card-on-File)** — токен, созданный и управляемый самим мерчантом или его PSP. Мерчант хранит токен вместо PAN для повторных платежей. Вне контекста мерчанта этот токен бесполезен.

Используется когда: мерчант хочет хранить «карту» клиента для повторных покупок (subscription, one-click checkout). Прост во внедрении, но не снижает fraud в самой транзакции.

**Network token** — токен, управляемый платёжной схемой (Visa Token Service / MDES). Схема маппирует токен к PAN, и этот маппинг актуализируется автоматически (например, при перевыпуске карты — токен остаётся тот же, PAN меняется).

Ключевые преимущества network token:
- Автоматическое обновление при перевыпуске карты → нет failed payments
- Криптограмма (TAVV) в каждой транзакции → снижение CNP fraud
- Более высокий authorization rate (эмитент доверяет scheme-managed токену)

**Device token (Apple Pay / Google Pay)** — частный случай network token с привязкой к конкретному устройству и биометрической верификацией.

Как BSA, при проектировании subscription payments я документирую: использование network token (а не CoF) как preferred approach, с fallback на CoF при отсутствии TSP интеграции.

---

### ❓ Q3: Продакт-менеджер хочет отключить 3DS для всех транзакций, чтобы снизить friction. Как ты отреагируешь?

**Ответ:**

Это сигнал для немедленного alignment-митинга с участием product, compliance и risk.

Первое, что я делаю — **разграничиваю техническую возможность и регуляторный мандат**. В EU PSD2/SCA делает 3DS (или эквивалентный SCA-механизм) **обязательным** для большинства CNP транзакций. «Отключить 3DS» = нарушение регуляторного требования. Штрафы от регулятора + потеря лицензии PSP/эмитента.

Второе — объясняю **экономику liability**. Без 3DS (ECI=07/00) вся ответственность за fraud chargebacks — на мерчанте/эквайере. При fraud rate 0.1% на €10M оборота — это €10,000 в месяц дополнительных потерь плюс риск VDMP/VCMP compliance programme.

Третье — предлагаю **правильное решение**: не отключать 3DS, а максимизировать использование exemptions. TRA exemption, low-value exemption, trusted beneficiary — при грамотной реализации можно добиться frictionless flow для 70-85% транзакций. Это снижает friction без regulatory risk.

В функциональных требованиях я документирую: «Система должна применять наиболее подходящее SCA exemption перед инициацией full 3DS challenge, в соответствии с PSD2 RTS art. 10-18».

---

### ❓ Q4: Что происходит, когда ACS недоступен во время 3DS flow? Как это задокументировать?

**Ответ:**

Это operationally important edge case, который часто пропускают в требованиях.

Когда ACS недоступен (timeout), 3DS Server получает ответ со статусом "U" (Unable to authenticate) или timeout. В этом случае:

**Attempt flow:** схема считает, что была предпринята попытка аутентификации. ECI выставляется в 06 (Visa) или 01 (MC) — «attempt». Транзакция продолжается без SCA.

**Ключевое:** ECI=06/01 даёт **liability shift к эмитенту**, даже без реальной аутентификации. Эмитент несёт ответственность, что стимулирует его поддерживать ACS в рабочем состоянии.

Требования к системе:
1. Timeout threshold: если нет ответа от DS/ACS за N секунд (обычно 10-15 сек) — переход к attempt flow
2. Logging: обязательно логировать ACS unavailability event с timestamp и transStatus="U" для последующего анализа и dispute resolution
3. Attempt CAVV: схема выдаёт суррогатный CAVV для attempt flow — его нужно сохранять и передавать в authorization
4. Monitoring: если ACS unavailability rate > X% — алерт, т.к. это признак системной проблемы со стороны эмитента

Без документирования этого edge case разработчики либо прерывают транзакцию (loss of revenue) либо пропускают без ECI (loss of liability protection).

---

### ❓ Q5: Тебя просят написать требования к SCA exemption engine. Что это за компонент и как его спроектировать?

**Ответ:**

SCA Exemption Engine — это компонент, который перед инициацией 3DS проверяет, применимо ли освобождение от SCA, и принимает решение: запрашивать exemption или проводить full 3DS.

**Входные данные для engine:**
- Сумма транзакции
- Тип транзакции (MIT / recurring / one-off)
- История по карте: счётчик low-value транзакций, сумма с последней SCA
- TRA score (от fraud engine)
- Fraud rate PSP (для TRA threshold)
- Whitelist статус мерчанта у данного эмитента

**Логика решения (приоритет сверху вниз):**

```
1. MIT / Recurring → No SCA (attach original reference)
2. Low Value (≤€30) AND counter < 5 AND cumulative < €100 → Request Low Value Exemption
3. TRA (amount ≤ threshold per fraud rate) → Request TRA Exemption
4. Trusted Beneficiary → Request Whitelisting Exemption
5. No exemption applies → Full 3DS
```

**Важный нюанс:** эмитент может **отклонить exemption** и потребовать SCA даже если эквайер запросил exemption. В этом случае система должна корректно перейти к 3DS challenge flow. Требование: «При получении Soft Decline с reason "SCA Required" система инициирует 3DS flow для той же транзакции».

**Требования к данным:**
- Счётчик low-value транзакций: хранить per-card, сбрасывать при SCA событии
- Аудит trail: каждое решение engine логировать с reason code и applied exemption

---

### ❓ Q6: Что такое "Soft Decline" в контексте PSD2 SCA и как это влияет на authorization flow?

**Ответ:**

Soft Decline в контексте SCA — это специфический response code эмитента (Visa: 65, MC: специальный sub-code в DE48), означающий: «Я готов одобрить транзакцию, но сначала нужна SCA».

Это **новый тип decline**, введённый с PSD2. До PSD2 decline означал финальный отказ. Теперь Soft Decline — это приглашение повторить транзакцию с SCA.

**Flow при Soft Decline:**
```
1. Транзакция отправлена без SCA (с exemption request)
2. Эмитент возвращает: RC=65 "Exceeds withdrawal limit" (Visa) / специальный SCA код
3. Merchant/PSP распознаёт SCA Soft Decline
4. Инициирует 3DS flow для той же транзакции
5. После успешной 3DS аутентификации — повторная авторизация с CAVV
6. Эмитент одобряет
```

**Требования к системе:**
1. Различать SCA Soft Decline (RC 65 c определённым sub-code) от обычного RC 65 (limit exceeded)
2. При SCA Soft Decline: не показывать пользователю «отказ», а перенаправлять на 3DS challenge
3. После 3DS: повторять авторизацию без изменения суммы, с тем же order ID
4. Логировать цепочку: original_auth_id → soft_decline → 3ds_auth_id → final_auth_id

Без явного документирования этого flow система либо показывает пользователю false decline (потеря конверсии), либо делает retry без SCA (повторный soft decline → infinite loop).

---

## 3.9 Связующая тема: Сквозной сценарий

Рассмотрим, как все три темы дня 3 связаны в одном сценарии:

> **Сценарий:** Клиент оплачивает подписку €45/мес. токенизированной картой на e-commerce платформе.

### Tokenization Layer
- Мерчант хранит network token (не PAN)
- При каждой повторной транзакции использует этот токен
- При перевыпуске карты — токен автоматически актуализируется через TSP

### 3DS / SCA Layer
- Первый платёж: full 3DS с SCA (устанавливает MIT reference)
- Последующие: MIT exemption → no SCA, attach initial SCA reference
- Если эмитент запрашивает re-authentication → soft decline → 3DS challenge

### Reconciliation Layer
- Каждый MIT платёж проходит clearing с MIT indicator
- ARN записывается для каждой транзакции в серии
- Reconciliation: matching по ARN, не по PAN (PAN не хранится)
- Exception: если токен de-activated и транзакция declined → separate exception type "Token Invalid"

---

## 📋 Практическое задание — День 3

**Задача:** Спроектируй reconciliation requirements для следующего сценария:

> Платёжный процессор обрабатывает 500,000 транзакций в день. Settlement от Visa приходит один раз в сутки в 06:00 UTC. Settlement от Mastercard — дважды в сутки (06:00 и 18:00 UTC). Bank statement (CAMT.053) приходит в 07:00 UTC. Средний daily volume: €20M.

**Что нужно сделать:**
1. Определить все источники данных и их SLA
2. Описать matching logic для каждого перехода
3. Написать exception taxonomy с tolerance rules
4. Создать data dictionary для reconciliation record (минимум 10 полей)
5. Написать acceptance criteria для двух сценариев: happy path и amount mismatch

**Дополнительно (для senior уровня):**
6. Какие мониторинг-метрики ты добавишь в operations dashboard?
7. Как изменится архитектура reconciliation при переходе на SEPA Instant (real-time settlement)?
