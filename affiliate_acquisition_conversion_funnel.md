# Воронка привлечения и конверсии в Affiliate CRM

> **Назначение:** практическое описание acquisition funnel для Business Analyst, работающего с affiliate marketing, iGaming и партнёрской CRM.  
> Документ содержит только общепринятые отраслевые понятия и типовые примеры. Он не описывает процессы или архитектуру конкретной компании.

---

# 1. Что такое воронка привлечения

Воронка привлечения показывает путь пользователя от первого контакта с рекламой до действия, которое создаёт бизнес-ценность.

В упрощённом виде:

```text
Impression
→ Click
→ Visit
→ Registration
→ Verification
→ First Deposit
→ Qualified First Deposit
→ First Activity
→ Redeposit
→ Retention
```

Каждый переход между этапами:

- имеет собственные правила;
- фиксируется отдельным событием;
- может происходить в другой системе;
- может учитываться в другой момент времени;
- может быть пересмотрен после antifraud или reconciliation.

Поэтому funnel — это не только набор маркетинговых метрик. Это также цепочка бизнес-событий, статусов и финансовых последствий.

---

# 2. Основные участники процесса

| Участник | Роль |
|---|---|
| **Advertiser / Operator** | Принимает трафик и получает пользователей |
| **Affiliate Partner** | Привлекает пользователей |
| **Affiliate Manager** | Управляет партнёром и коммерческими условиями |
| **Tracking System** | Фиксирует клики и attribution |
| **Product Platform** | Фиксирует регистрации, депозиты и активность |
| **Antifraud** | Проверяет качество трафика и пользователей |
| **Affiliate CRM** | Объединяет данные, квалифицирует конверсии и считает комиссию |
| **Finance System** | Выполняет начисления и выплаты |
| **BI / DWH** | Формирует отчётность и аналитику |

---

# 3. Общая схема funnel

```text
Advertising Platform
        │
        ▼
   Impression
        │
        ▼
      Click
        │
        ▼
 Tracking Redirect
        │
        ▼
 Landing / App / Product
        │
        ▼
   Registration
        │
        ▼
 Verification / KYC
        │
        ▼
  First Deposit
        │
        ▼
 Qualification
        │
        ├── Rejected
        └── Approved
              │
              ▼
       Player Activity
              │
              ▼
          Redeposit
              │
              ▼
     Retention / Revenue
```

---

# 4. Этап 1 — Impression

## 4.1. Определение

**Impression** — факт показа рекламного материала пользователю.

Пример:

```text
Пользователю показали баннер в мобильном приложении.
```

## 4.2. Где фиксируется

Обычно impression фиксируется:

- в рекламной платформе;
- у publisher;
- в ad network;
- реже — во внутреннем tracking-контуре.

Affiliate CRM может не получать каждый impression, особенно если источником является внешняя рекламная платформа.

## 4.3. Основные атрибуты

```text
impression_id
timestamp
campaign_id
creative_id
placement_id
publisher_id
geo
device_type
os
browser
```

## 4.4. Метрика CTR

```text
CTR = Clicks / Impressions × 100%
```

## 4.5. Возможные проблемы

- один пользователь создаёт несколько impressions;
- рекламная платформа и affiliate-система считают impressions по-разному;
- viewable impression и технический impression могут отличаться;
- данные могут поступать с задержкой;
- часть источников не передаёт impression-level данные.

---

# 5. Этап 2 — Click

## 5.1. Определение

**Click** — переход пользователя по tracking link.

Это первый этап, который обычно однозначно связывается с affiliate-партнёром.

## 5.2. Что происходит при клике

```text
1. Пользователь нажимает рекламу.
2. Tracking system принимает запрос.
3. Создаётся click_id.
4. Сохраняются affiliate_id, offer_id и SubID.
5. Пользователь перенаправляется на landing page или product.
```

## 5.3. Пример tracking link

```text
https://tracking.example/click
    ?aff_id=12345
    &offer_id=678
    &campaign_id=summer_campaign
    &sub1=source
    &sub2=creative
    &sub3=audience
```

## 5.4. Основные атрибуты Click

```text
click_id
affiliate_id
offer_id
campaign_id
sub1...subN
timestamp
ip_address
user_agent
geo
device
landing_url
referrer
```

## 5.5. Click status

```text
Received
→ Validated
→ Redirected
```

Альтернативные состояния:

```text
Rejected
Blocked
Duplicate
Bot Suspected
Geo Mismatch
Cap Reached
```

## 5.6. Возможные бизнес-правила

- блокировать клики из запрещённого GEO;
- не принимать трафик после достижения hard cap;
- помечать подозрительное количество кликов с одного IP;
- применять fallback offer;
- не создавать новый click_id при техническом retry;
- сохранять оригинальные SubID без изменения.

## 5.7. Основные риски

- click spam;
- bot traffic;
- потеря query parameters;
- некорректный redirect;
- превышение cap;
- дублирование click events;
- неверное определение GEO;
- невалидная tracking link.

---

# 6. Этап 3 — Visit / Session

## 6.1. Определение

**Visit** — фактическое открытие landing page или product.

Click и Visit не всегда равны.

Пример:

```text
Клик был зафиксирован,
но страница не загрузилась из-за ошибки сети.
```

## 6.2. Session

**Session** — период взаимодействия пользователя с продуктом.

Один click может привести:

- к нулю sessions;
- к одной session;
- к нескольким sessions;
- к регистрации через несколько дней.

## 6.3. Основные метрики

```text
Landing Conversion = Visits / Clicks
Bounce Rate = Single-page Visits / Visits
```

## 6.4. Возможные причины потерь

- медленная загрузка;
- недоступный landing;
- неправильная локализация;
- блокировка домена;
- несовместимость с устройством;
- пользователь передумал;
- ошибка deeplink;
- app не установилось.

---

# 7. Этап 4 — Registration

## 7.1. Определение

**Registration** — создание пользовательского аккаунта.

Регистрация обычно считается продуктовым событием и приходит в affiliate CRM из product platform или tracking integration.

## 7.2. Типовой процесс

```text
Click
→ Landing
→ Registration Form
→ Account Created
→ Attribution Lookup
→ Registration Linked to Affiliate
```

## 7.3. Ключевой вопрос

Главная задача системы:

> Какому партнёру засчитать регистрацию?

## 7.4. Возможные правила attribution

- Last Click;
- First Click;
- последний валидный affiliate click;
- click внутри attribution window;
- приоритет платного источника над organic;
- приоритет ранее закреплённого партнёра;
- исключение self-referral;
- исключение повторной регистрации.

## 7.5. Основные атрибуты Registration

```text
registration_id
player_id
registration_timestamp
click_id
affiliate_id
offer_id
campaign_id
geo
currency
language
device
registration_status
```

## 7.6. Registration status

```text
Created
→ Verified
→ Active
```

Альтернативные:

```text
Pending Verification
Duplicate
Rejected
Blocked
Fraud Suspected
```

## 7.7. Метрика Click2Reg

```text
Click2Reg = Registrations / Clicks × 100%
```

## 7.8. Возможные проблемы

- регистрация без click_id;
- click_id потерян между landing и product;
- один click связан с несколькими регистрациями;
- пользователь зарегистрирован ранее;
- несовпадение GEO;
- несоответствие времени между системами;
- регистрация пришла до click из-за задержки событий.

---

# 8. Этап 5 — Verification / KYC

## 8.1. Определение

Verification — проверка данных пользователя.

В зависимости от продукта используются:

- email verification;
- phone verification;
- identity verification;
- age verification;
- KYC;
- sanctions screening;
- payment method verification.

## 8.2. Зачем verification нужен в funnel

Регистрация не всегда создаёт ценность.

Пользователь может:

- указать вымышленные данные;
- создать duplicate account;
- находиться в запрещённом регионе;
- не пройти возрастную проверку;
- попасть под antifraud.

## 8.3. Статусы

```text
Not Started
→ In Progress
→ Verified
```

Альтернативные:

```text
Failed
Rejected
Expired
Manual Review
```

## 8.4. Метрика Verification Rate

```text
Verification Rate =
Verified Registrations / All Registrations × 100%
```

## 8.5. BA должен уточнить

- обязательна ли verification до депозита;
- какие проверки влияют на affiliate qualification;
- можно ли учитывать FTD до завершения KYC;
- что делать, если KYC отклонён позже;
- требуется ли перерасчёт комиссии.

---

# 9. Этап 6 — First Deposit

## 9.1. Определение

**FTD — First-Time Deposit** — первый успешный депозит пользователя.

Это один из основных conversion events в affiliate-программах.

## 9.2. Важно

FTD и QFTD — разные понятия.

```text
FTD = факт первого успешного депозита.

QFTD = первый депозит,
который выполнил условия квалификации.
```

## 9.3. Типовой процесс

```text
User initiates deposit
→ Payment processing
→ Deposit completed
→ Product emits event
→ CRM receives deposit
→ CRM checks whether it is the first successful deposit
```

## 9.4. Основные атрибуты

```text
deposit_id
player_id
amount
currency
base_currency_amount
payment_method
status
created_at
completed_at
is_first_deposit
```

## 9.5. Deposit status

```text
Created
→ Processing
→ Completed
```

Альтернативные:

```text
Failed
Cancelled
Expired
Reversed
Chargeback
```

## 9.6. Что считается успешным депозитом

Это должно быть формально определено.

Возможные варианты:

- payment status = Completed;
- средства фактически зачислены;
- депозит не был reversal;
- депозит не был chargeback;
- сумма выше минимальной;
- валюта входит в допустимый список.

## 9.7. Метрика Reg2Dep

```text
Reg2Dep = FTD / Registrations × 100%
```

## 9.8. Возможные проблемы

- несколько депозитов завершились одновременно;
- payment provider прислал duplicate callback;
- депозит отменён после начисления;
- разные валюты;
- депозит меньше qualification threshold;
- пользователь уже делал депозит на другом продукте;
- ошибочно определён first deposit.

---

# 10. Этап 7 — Qualified FTD

## 10.1. Определение

**Qualified FTD / QFTD** — первый депозит, который выполнил все условия оплаты партнёру.

## 10.2. Возможные правила квалификации

```text
FTD amount >= Minimum Deposit
AND KYC status = Verified
AND player is not duplicate
AND traffic source is allowed
AND GEO matches Deal
AND no fraud flag
AND turnover requirement completed
AND redeposit requirement completed
```

Не все правила обязательно используются одновременно.

## 10.3. Qualification window

Это период, в течение которого пользователь должен выполнить требования.

Пример:

```text
FTD совершен 1 августа.
Пользователь должен выполнить turnover до 15 августа.
```

## 10.4. Статусная модель conversion

```text
Received
→ Pending
→ Under Validation
→ Qualified
→ Approved
→ Payable
```

Альтернативные состояния:

```text
Rejected
Duplicate
Fraud
Expired
Cancelled
Adjusted
```

## 10.5. Причины отклонения

```text
MIN_DEPOSIT_NOT_REACHED
INVALID_GEO
DUPLICATE_PLAYER
FORBIDDEN_SOURCE
KYC_FAILED
FRAUD_DETECTED
TURNOVER_NOT_REACHED
REDEPOSIT_NOT_COMPLETED
CAP_EXCEEDED
ATTRIBUTION_EXPIRED
```

## 10.6. Approval Rate

```text
Approval Rate =
Approved Conversions / All Received Conversions × 100%
```

## 10.7. Rejection Rate

```text
Rejection Rate =
Rejected Conversions / All Received Conversions × 100%
```

## 10.8. Важные вопросы для BA

1. Когда начинается qualification window?
2. Какой timestamp используется?
3. В какой валюте проверяется minimum deposit?
4. Какой exchange rate применяется?
5. Может ли rejected conversion стать approved?
6. Может ли approved conversion быть отозвана?
7. Как влияет изменение deal?
8. Как отправляется postback при смене статуса?
9. Нужно ли пересчитывать прошлые периоды?

---

# 11. Этап 8 — First Activity

## 11.1. Определение

После депозита пользователь должен начать пользоваться продуктом.

Это может быть:

- первая ставка;
- первая игровая сессия;
- первый completed bet;
- первый turnover;
- первая покупка;
- первое использование услуги.

## 11.2. Зачем учитывать activity

Депозит без дальнейшей активности может означать:

- низкое качество трафика;
- техническую проблему;
- incentive abuse;
- bonus abuse;
- ошибочную или случайную конверсию.

## 11.3. Метрики

```text
Activation Rate =
Activated Users / FTD Users × 100%

Average Time to First Activity =
Average(first_activity_at − ftd_at)
```

---

# 12. Этап 9 — Redeposit

## 12.1. Определение

**Redeposit** — второй или последующий успешный депозит пользователя.

## 12.2. Почему redeposit важен

Redeposit показывает, что пользователь:

- получил ценность от продукта;
- вернулся;
- не был одноразовым;
- потенциально имеет более высокий LTV.

## 12.3. Варианты определения

Нужно формально уточнить:

- любой второй депозит;
- второй депозит в течение N дней;
- депозит выше минимальной суммы;
- депозит после первой активности;
- депозит без учёта отменённых платежей.

## 12.4. Метрика Dep2Redep

```text
Dep2Redep =
Users with Redeposit / Users with FTD × 100%
```

## 12.5. Redeposit window

Примеры:

```text
Redeposit within 7 days
Redeposit within 14 days
Redeposit within 30 days
```

Разные окна дают разные результаты и не должны смешиваться в одном отчёте.

---

# 13. Этап 10 — Retention

## 13.1. Определение

Retention показывает, какая доля привлечённых пользователей продолжает активность через определённое время.

## 13.2. Примеры

```text
D1 Retention
D7 Retention
D30 Retention
M1 Retention
M3 Retention
```

## 13.3. Формула

```text
D30 Retention =
Users active on Day 30 / Users in original cohort × 100%
```

## 13.4. Cohort

Cohort может формироваться по:

- registration date;
- FTD date;
- partner;
- GEO;
- campaign;
- traffic source;
- offer;
- creative.

## 13.5. Важное ограничение

Нельзя сравнивать retention двух групп, если:

- используются разные cohort dates;
- разное определение active user;
- разные GEO;
- разные продукты;
- разные observation windows.

---

# 14. Полная funnel-таблица

| Этап | Бизнес-событие | Возможный Source of Truth | Основная метрика |
|---|---|---|---|
| Impression | Реклама показана | Ad Platform | CTR |
| Click | Пользователь нажал ссылку | Tracking System | Click volume |
| Visit | Landing открыт | Web Analytics | Visit rate |
| Registration | Аккаунт создан | Product Platform | Click2Reg |
| Verification | Пользователь проверен | KYC / Product | Verification Rate |
| FTD | Первый депозит завершён | Payments / Product | Reg2Dep |
| QFTD | FTD прошёл правила | Affiliate CRM | Approval Rate |
| First Activity | Пользователь начал пользоваться продуктом | Product Platform | Activation Rate |
| Redeposit | Повторный депозит | Payments / Product | Dep2Redep |
| Retention | Пользователь остаётся активным | DWH / BI | D7, D30, M1 |
| Revenue | Пользователь создаёт доход | Finance / Product | GGR, NGR, LTV |

---

# 15. Funnel как набор событий

Пример event model:

```json
{
  "event_id": "evt-123",
  "event_type": "FIRST_DEPOSIT_COMPLETED",
  "occurred_at": "2026-08-01T10:30:00Z",
  "received_at": "2026-08-01T10:30:04Z",
  "player_id": "plr-456",
  "click_id": "clk-789",
  "affiliate_id": "aff-001",
  "offer_id": "off-002",
  "campaign_id": "cmp-003",
  "amount": 50,
  "currency": "EUR",
  "source_system": "payment-platform",
  "schema_version": 1
}
```

## Обязательные свойства события

- уникальный `event_id`;
- бизнес-время `occurred_at`;
- техническое время `received_at`;
- source system;
- schema version;
- correlation identifiers;
- idempotency;
- возможность повторной обработки.

---

# 16. Attribution и funnel

## 16.1. Задача attribution

Определить, какому партнёру принадлежит registration, FTD или другая conversion.

## 16.2. Типовые модели

### Last Click

```text
Conversion получает последний валидный affiliate click.
```

### First Click

```text
Conversion получает первый валидный affiliate click.
```

### Fixed Ownership

```text
После первой регистрации пользователь навсегда закрепляется за партнёром.
```

### Reattribution

```text
Пользователь может быть перепривязан после истечения attribution window.
```

## 16.3. Attribution window

```text
click_at <= conversion_at <= click_at + attribution_window
```

## 16.4. Конфликтный пример

```text
1 августа — клик партнёра A
3 августа — клик партнёра B
5 августа — регистрация
7 августа — FTD
```

В зависимости от правил владелец conversion может быть:

- партнёр A;
- партнёр B;
- источник регистрации;
- ранее закреплённый партнёр;
- organic.

## 16.5. BA должен зафиксировать

- модель attribution;
- окно attribution;
- правило повторных кликов;
- правило повторной регистрации;
- правило cross-device;
- правило organic;
- правило reattribution;
- source of truth;
- допустимость ручной коррекции.

---

# 17. Cap и funnel

## 17.1. Что может ограничиваться

- clicks;
- registrations;
- FTD;
- QFTD;
- дневной объём;
- месячный объём;
- объём по GEO;
- объём по traffic source.

## 17.2. Hard Cap

После достижения лимита:

- новые клики блокируются;
- применяется fallback offer;
- новые conversions не оплачиваются;
- partner получает уведомление.

## 17.3. Soft Cap

После достижения лимита:

- трафик продолжает приниматься;
- менеджер получает alert;
- требуется дополнительное согласование;
- может применяться другая ставка.

## 17.4. Важный вопрос

Cap проверяется по:

- click date;
- registration date;
- FTD date;
- approval date;
- payout period?

Это критично для расчётов.

---

# 18. Как funnel связан с commission

## 18.1. CPA

```text
CPA Commission =
Qualified Conversions × CPA Rate
```

## 18.2. RevShare

```text
RevShare Commission =
Revenue Base × RevShare %
```

## 18.3. Hybrid

```text
Hybrid Commission =
Qualified Conversions × CPA Rate
+ Revenue Base × RevShare %
```

## 18.4. Финансовое следствие

Изменение статуса:

```text
Pending → Approved
```

может привести к:

```text
Commission Accrual
→ Balance Increase
→ Payout Eligibility
```

Изменение:

```text
Approved → Rejected
```

может привести к:

```text
Clawback
→ Negative Adjustment
→ Balance Decrease
```

---

# 19. Основные funnel-метрики

| Метрика | Формула |
|---|---|
| CTR | Clicks / Impressions |
| Visit Rate | Visits / Clicks |
| Click2Reg | Registrations / Clicks |
| Verification Rate | Verified Registrations / Registrations |
| Reg2Dep | FTD / Registrations |
| FTD Approval Rate | QFTD / FTD |
| Activation Rate | Activated Users / FTD |
| Dep2Redep | Redepositors / FTD |
| D7 Retention | Active D7 / Cohort |
| D30 Retention | Active D30 / Cohort |
| EPC | Partner Earnings / Clicks |
| eCPA | Cost / Qualified Conversions |
| CAC | Acquisition Cost / New Customers |
| LTV | Expected Lifetime Revenue per User |
| ROI | (Revenue − Cost) / Cost |

---

# 20. Пример funnel

Исходные данные:

```text
Impressions: 1 000 000
Clicks: 20 000
Registrations: 4 000
Verified Registrations: 3 200
FTD: 1 000
QFTD: 800
Redepositors: 300
```

Расчёт:

```text
CTR = 20 000 / 1 000 000 = 2%

Click2Reg = 4 000 / 20 000 = 20%

Verification Rate = 3 200 / 4 000 = 80%

Reg2Dep = 1 000 / 4 000 = 25%

FTD Approval Rate = 800 / 1 000 = 80%

Dep2Redep = 300 / 1 000 = 30%
```

## Интерпретация

- низкий CTR может указывать на слабый creative;
- низкий Click2Reg — на проблему landing или несоответствие ожиданий;
- низкий Verification Rate — на плохое качество лидов;
- низкий Reg2Dep — на payment или onboarding friction;
- низкий Approval Rate — на fraud, KPI или некорректный traffic source;
- низкий Dep2Redep — на слабое качество пользователей или продукта.

---

# 21. Где возникают расхождения данных

Типовой пример:

```text
Tracking System: 1 050 FTD
Product Platform: 1 000 FTD
Affiliate CRM: 980 FTD
Finance: 800 payable conversions
```

Это не обязательно ошибка.

Возможные причины:

- разные определения FTD;
- разные временные зоны;
- задержка событий;
- duplicate events;
- rejected traffic;
- qualification rules;
- cap;
- fraud;
- разные отчётные периоды;
- recalculation;
- conversion status changed later.

---

# 22. Reconciliation funnel

## 22.1. Что сверять

```text
Clicks
Registrations
FTD
QFTD
Revenue
Commission
Balance
Payout
```

## 22.2. Ключ сверки

Обычно требуется один или несколько идентификаторов:

```text
event_id
click_id
player_id
deposit_id
conversion_id
commission_id
payout_id
```

## 22.3. Типы расхождений

| Тип | Пример |
|---|---|
| Missing Event | FTD есть в product, но нет в CRM |
| Duplicate Event | Один депозит создан дважды |
| Attribution Mismatch | Разные affiliate_id |
| Status Mismatch | Approved в CRM, Rejected в antifraud |
| Amount Mismatch | Разная сумма после FX conversion |
| Period Mismatch | Событие попало в разные отчётные дни |

---

# 23. Event time и processing time

Важно различать:

```text
occurred_at — когда событие произошло;
received_at — когда система его получила;
processed_at — когда система его обработала;
approved_at — когда событие подтвердили;
paid_at — когда комиссия была выплачена.
```

Пример:

```text
FTD произошёл 31 августа в 23:59.
Система получила событие 1 сентября в 00:02.
```

Нужно определить, в какой период попадёт conversion:

- по occurred_at;
- по received_at;
- по approved_at.

---

# 24. Late-arriving events

**Late-arriving event** — событие, пришедшее с задержкой.

Пример:

```text
Registration произошло 1 августа,
но событие поступило 3 августа.
```

Система должна определить:

- допускается ли поздняя обработка;
- нужно ли пересчитать отчёты;
- нужно ли изменить commission;
- нужно ли повторно отправить postback;
- можно ли менять закрытый период.

---

# 25. Duplicate events и idempotency

## 25.1. Причины duplicate events

- retry от source system;
- network timeout;
- повторный callback;
- повторная публикация Kafka message;
- ручной replay.

## 25.2. Бизнес-опасность

Без idempotency система может:

- дважды создать conversion;
- дважды начислить commission;
- дважды увеличить balance;
- дважды отправить postback.

## 25.3. Возможное правило

```text
Если event_id уже обработан,
повторный event не должен создавать новый бизнес-результат.
```

---

# 26. Статусная модель funnel

```text
Click
  ↓
Registration
  ↓
FTD
  ↓
Pending Qualification
  ↓
Under Validation
  ↓
Approved
  ↓
Payable
  ↓
Paid
```

Альтернативные ветки:

```text
Rejected
Duplicate
Fraud
Expired
Cancelled
Adjusted
Clawed Back
```

Для каждого статуса следует определить:

- entry condition;
- exit condition;
- allowed transitions;
- responsible system;
- side effects;
- notifications;
- audit requirements.

---

# 27. Пример state transition table

| From | To | Условие | Side Effect |
|---|---|---|---|
| Received | Pending | Событие принято | Создать conversion |
| Pending | Under Validation | Начата проверка | Зафиксировать validation start |
| Under Validation | Approved | Все правила выполнены | Начислить commission |
| Under Validation | Rejected | Нарушено правило | Сохранить reject reason |
| Approved | Payable | Завершён hold | Перевести сумму в available balance |
| Approved | Rejected | Fraud обнаружен позже | Создать clawback |
| Payable | Paid | Выплата завершена | Закрыть обязательство |

---

# 28. Типовые уведомления

Система может уведомлять:

- partner о достижении cap;
- affiliate manager о падении conversion rate;
- antifraud о подозрительном паттерне;
- finance о доступном payout;
- product team о росте payment failures;
- support о lost attribution;
- analyst о data discrepancy.

---

# 29. Мониторинг funnel

## 29.1. Операционные показатели

```text
Events per minute
Processing latency
Failed events
Postback failure rate
Duplicate rate
Lost attribution rate
Data lag
```

## 29.2. Бизнес-показатели

```text
Clicks
Registrations
FTD
QFTD
Approval Rate
Redeposit Rate
Revenue
Commission
ROI
```

## 29.3. Alert-примеры

```text
Reg2Dep упал более чем на 30% за час.
Postback failure rate превышает 5%.
Lost attribution rate превышает 2%.
Количество FTD равно нулю для активного GEO.
Approval Rate резко снизился.
```

---

# 30. Диагностика проблем по этапам

| Симптом | Возможные причины |
|---|---|
| Много impressions, мало clicks | Слабый creative, неверная аудитория |
| Много clicks, мало visits | Ошибка redirect, медленный landing |
| Много visits, мало registrations | Плохой UX, локализация, недоверие |
| Много registrations, мало FTD | Payment friction, слабый onboarding |
| Много FTD, мало QFTD | Fraud, KPI, invalid GEO, duplicate |
| Много QFTD, мало redeposit | Низкое качество трафика или продукта |
| Высокий revenue, низкий commission | Ошибка RevShare base или attribution |
| Разные цифры в отчётах | Timezone, status, delay, definition mismatch |

---

# 31. Требования к отчёту funnel

Отчёт должен явно показывать:

- период;
- timezone;
- date basis;
- attribution model;
- cohort basis;
- filters;
- statuses included;
- source systems;
- freshness;
- metric definitions;
- currency;
- exchange rate;
- excluded traffic.

## Пример заголовка отчёта

```text
Period: 01.08.2026–31.08.2026
Timezone: UTC
Date basis: FTD occurred_at
Attribution: Last valid click
Currency: EUR
QFTD status: Approved + Payable
Data freshness: 15 minutes
```

---

# 32. BA checklist для задачи по funnel

## 32.1. Определение события

- Как называется событие?
- Где оно возникает?
- Какая система является Source of Truth?
- Как определяется уникальность?
- Какие обязательные поля?

## 32.2. Attribution

- Как определяется affiliate?
- Какое attribution window?
- Возможна ли reattribution?
- Что делать при отсутствии click_id?

## 32.3. Статусы

- Какие статусы существуют?
- Какие переходы допустимы?
- Возможен ли rollback?
- Кто меняет статус?

## 32.4. Qualification

- Какие правила?
- Какой evaluation order?
- Какие reject reasons?
- Есть ли manual review?

## 32.5. Финансы

- Когда начисляется commission?
- Когда сумма становится payable?
- Как создаётся clawback?
- Какой период расчёта?

## 32.6. Отчётность

- Какой timestamp используется?
- Какая timezone?
- Какие статусы входят в метрику?
- Как обрабатываются late events?

## 32.7. Интеграции

- Sync или async?
- Как работает retry?
- Есть ли idempotency?
- Есть ли DLQ?
- Как мониторятся ошибки?

---

# 33. Acceptance Criteria — пример

```gherkin
Scenario: Qualify a first deposit

Given a player is attributed to an active affiliate deal
And the player's first successful deposit amount is at least 20 EUR
And the player's GEO matches the deal GEO
And the traffic source is allowed
And the player is not marked as duplicate or fraud
When the qualification process is completed
Then the conversion status shall be changed to Approved
And the applicable CPA commission shall be created
And the conversion shall be included in the partner report
And an approved conversion postback shall be sent.
```

```gherkin
Scenario: Reject a duplicated first deposit event

Given an event with the same event_id has already been processed
When the same event is received again
Then no additional conversion shall be created
And no additional commission shall be accrued
And the repeated event shall be recorded as a duplicate.
```

---

# 34. BPMN-level процесс

```text
Partner sends traffic
        ↓
Tracking system records click
        ↓
Product creates registration
        ↓
Attribution resolved?
   ┌────┴────┐
  No        Yes
  ↓          ↓
Organic /   Affiliate linked
Manual      ↓
Review      First Deposit
             ↓
       Qualification rules
        ┌────┴────┐
      Fail       Pass
       ↓           ↓
    Rejected    Approved
                    ↓
             Commission accrual
                    ↓
                  Hold
                    ↓
                 Payable
```

---

# 35. Главные выводы

1. Funnel — это одновременно маркетинговая, продуктовая, техническая и финансовая цепочка.
2. FTD ещё не означает payable conversion.
3. Attribution определяет владельца conversion.
4. Qualification определяет, должна ли conversion оплачиваться.
5. Один и тот же показатель может отличаться между системами из-за разных определений и временных правил.
6. Любое изменение funnel необходимо проверять до уровня commission, balance, payout и reconciliation.
7. Для каждой метрики должны быть формально описаны формула, statuses, timestamp и Source of Truth.
