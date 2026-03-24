Сначала собирается базовый lifecycle платежа, затем на него наслаиваются authentication, security, scheme rules и regulatory requirements.

---

# DAY 1

## Блок 1. Базовая карта участников

### Шаг 1. Зафиксировать участников процесса
Нужно выписать и запомнить роли всех основных участников card payment flow:
- Cardholder / Customer
- Merchant
- PSP / Payment Gateway
- Acquirer
- Card Scheme (Visa / Mastercard)
- Issuer

### Шаг 2. Зафиксировать ответственность каждого участника
Нужно понимать роль каждого:
- Merchant инициирует прием платежа на своей стороне.
- PSP / Gateway передает и маршрутизирует платежный запрос.
- Acquirer обслуживает merchant со стороны эквайринга.
- Card Scheme передает сообщения между acquirer и issuer.
- Issuer принимает решение по карте и средствам клиента.

### Результат блока
После этого блока должна быть собрана простая схема участников и их роли в одном end-to-end flow.

---

## Блок 2. Core payment lifecycle

### Шаг 3. Изучить полный lifecycle платежа
Нужно выучить 4 базовых стадии:
1. Authorization
2. Clearing
3. Settlement
4. Reconciliation

### Шаг 4. Зафиксировать смысл каждой стадии
- **Authorization** — issuer проверяет карту, баланс, ограничения и принимает решение approve / decline.
- **Clearing** — transaction details передаются для дальнейшей финансовой обработки.
- **Settlement** — реальные денежные средства переводятся между участниками.
- **Reconciliation** — стороны сверяют свои записи, суммы, статусы и расхождения.

### Шаг 5. Зафиксировать правильную логику flow
Нужно усвоить следующие утверждения:
- Authorization не означает окончательное движение денег.
- Settlement означает фактическое финансовое завершение операции.
- Clearing идет после authorization и подготавливает settlement.
- Reconciliation закрывает операционный и финансовый контур сверкой.

### Результат блока
После этого блока должна быть готова краткая устная формулировка полного payment lifecycle.

---

## Блок 3. Authorization как ключевая стадия

### Шаг 6. Углубить понимание authorization
Нужно зафиксировать, что authorization — это основная decision-point стадия.

### Шаг 7. Заучить, что происходит внутри authorization
В рамках authorization issuer:
- проверяет валидность карты;
- проверяет доступность средств или кредитного лимита;
- проверяет ограничения и fraud signals;
- возвращает approve или decline.

### Шаг 8. Зафиксировать бизнес-смысл authorization hold
Нужно понимать, что при успешной authorization часто создается hold / reservation, а не финальное списание.

### Шаг 9. Зафиксировать связь authorization с последующими стадиями
Authorization дает разрешение на дальнейшую финансовую обработку, но не заменяет clearing и settlement.

### Результат блока
После этого блока должно быть понятное объяснение разницы между approval, hold и final funds movement.

---

## Блок 4. 3DS как authentication layer

### Шаг 10. Изучить место 3DS в payment flow
Нужно зафиксировать, что 3DS не живет отдельно от платежа, а встраивается в card-not-present authorization flow.

### Шаг 11. Зафиксировать назначение 3DS
3DS нужен для дополнительной аутентификации cardholder и для выполнения требований SCA в европейской среде.

### Шаг 12. Заучить два базовых сценария 3DS
- **Frictionless flow** — проверка проходит без дополнительного действия клиента.
- **Challenge flow** — клиент проходит дополнительную проверку.

### Шаг 13. Зафиксировать ключевых участников 3DS
- Merchant / PSP инициирует 3DS flow
- Directory Server участвует в маршрутизации
- ACS выполняет authentication со стороны issuer

### Шаг 14. Зафиксировать бизнес-результат 3DS
3DS влияет на risk handling, customer journey и liability distribution.

### Результат блока
После этого блока должно быть четкое понимание, что 3DS — это authentication layer перед или внутри authorization decision flow.

---

# DAY 2

## Блок 5. Tokenization как security layer

### Шаг 15. Изучить идею tokenization
Нужно зафиксировать, что tokenization заменяет чувствительные card data безопасным surrogate value.

### Шаг 16. Зафиксировать бизнес-ценность tokenization
Tokenization:
- снижает риск компрометации PAN;
- уменьшает exposure чувствительных данных;
- поддерживает recurring payments и saved card scenarios;
- помогает строить более безопасную payment architecture.

### Шаг 17. Разделить виды tokenization
Нужно понимать различие:
- **Merchant token** — внутренний токен merchant / PSP среды;
- **Network token** — токен на уровне card scheme ecosystem.

### Шаг 18. Зафиксировать место tokenization в системе
Tokenization относится к security and data protection layer и влияет на storage, transmission и reuse of payment credentials.

### Результат блока
После этого блока должно быть простое объяснение, как tokenization помогает бизнесу и архитектуре.

---

## Блок 6. Scheme rules: Visa / Mastercard

### Шаг 19. Зафиксировать назначение scheme rules
Scheme rules задают обязательные правила работы участников card ecosystem.

### Шаг 20. Изучить, что именно регулируют scheme rules
Нужно понимать, что scheme rules определяют:
- правила authorization;
- сроки и требования к clearing;
- правила settlement;
- dispute / chargeback mechanics;
- refund handling;
- обязанности merchant, acquirer и issuer.

### Шаг 21. Зафиксировать практический смысл scheme rules для аналитика
Scheme rules влияют на:
- business requirements;
- status model;
- timeout windows;
- refund scenarios;
- dispute handling;
- integration contracts и operational constraints.

### Результат блока
После этого блока должно быть понимание, что Visa / Mastercard rules — это не теория, а реальные ограничения на систему и процессы.

---

## Блок 7. PSD2 и SCA

### Шаг 22. Изучить PSD2 как regulatory framework
Нужно зафиксировать, что PSD2 регулирует платежную среду в Европе и задает требования к security, access и protection of payment users.

### Шаг 23. Зафиксировать место SCA внутри PSD2
SCA — это практический security requirement, который требует strong customer authentication в определенных сценариях.

### Шаг 24. Заучить смысл SCA
SCA строится на принципе использования как минимум двух факторов из разных категорий authentication.

### Шаг 25. Зафиксировать связь SCA и 3DS
В e-commerce card payments 3DS часто используется как основной механизм реализации SCA.

### Шаг 26. Зафиксировать business impact SCA
SCA влияет на:
- checkout UX;
- conversion;
- fraud prevention;
- authentication logic;
- exemption handling.

### Результат блока
После этого блока должно быть понятное объяснение, почему 3DS и SCA постоянно упоминаются вместе.

---

## Блок 8. GDPR в платежном контексте

### Шаг 27. Изучить GDPR как data regulation layer
Нужно зафиксировать, что GDPR регулирует обработку personal data и накладывает ограничения на сбор, хранение, передачу и использование данных.

### Шаг 28. Зафиксировать практический смысл GDPR для payment systems
GDPR влияет на:
- data collection;
- data minimization;
- retention rules;
- consent and lawful basis;
- masking и logging practices;
- access to customer data.

### Шаг 29. Зафиксировать BA perspective
Для аналитика GDPR означает необходимость отражать data handling constraints в функциональных и нефункциональных требованиях.

### Результат блока
После этого блока должно быть понимание, что GDPR — это не отдельная юридическая тема, а часть требований к системе.

---

# DAY 3 / FINAL CONSOLIDATION

## Блок 9. Сборка единой end-to-end картины

### Шаг 30. Собрать единый сценарий в правильной последовательности
Нужно уметь проговаривать flow так:
1. Customer initiates card payment on merchant side
2. Merchant sends request via PSP / gateway
3. 3DS may be triggered for authentication / SCA
4. Authorization request goes through acquirer and scheme to issuer
5. Issuer approves or declines transaction
6. Approved transaction moves into clearing
7. Settlement moves actual funds
8. Reconciliation validates records and balances across parties
9. Tokenization protects credentials across the flow
10. Scheme rules and regulations constrain how the flow is implemented

### Шаг 31. Зафиксировать layered view
Нужно видеть всю тему слоями:
- **Core lifecycle**: authorization, clearing, settlement, reconciliation
- **Authentication layer**: 3DS
- **Security layer**: tokenization
- **Scheme governance layer**: Visa / Mastercard rules
- **Regulatory layer**: PSD2, SCA, GDPR

### Результат блока
После этого блока должна быть собрана целостная mental model, которую можно рассказывать на интервью без скачков между темами.

---

## Блок 10. Минимальный артефакт для закрепления

### Шаг 32. Подготовить короткую шпаргалку на 1 экран
Нужно оформить для себя один компактный summary:
- кто участники;
- какие стадии платежа;
- где стоит 3DS;
- зачем tokenization;
- как влияют Visa / Mastercard rules;
- как встраиваются PSD2 / SCA / GDPR.

### Шаг 33. Подготовить короткое устное объяснение
Нужно заучить короткую формулировку на 30–60 секунд:

> Card payment flow starts with authorization, where issuer decides whether to approve or decline the transaction. For e-commerce flows, 3DS may be used as an authentication layer to support SCA. After approval, the transaction proceeds through clearing and then settlement, where funds are actually transferred. Reconciliation is used to verify records and balances across all parties. Tokenization protects card credentials, while Visa and Mastercard scheme rules and European regulations such as PSD2, SCA, and GDPR define the constraints under which the whole flow must operate.

### Результат блока
После этого блока должна быть готова короткая и уверенная речь для интервью.

---

# Финальный чек-лист готовности

## База
- [ ] Участники card payment flow зафиксированы
- [ ] Полный lifecycle payment понятен и проговаривается без ошибок
- [ ] Разница между authorization, clearing, settlement и reconciliation закреплена

## Authentication / Security
- [ ] 3DS понятен как authentication layer
- [ ] Tokenization понятен как security layer

## Rules / Regulation
- [ ] Visa / Mastercard scheme rules воспринимаются как operational constraints
- [ ] PSD2 и SCA понятны как regulatory requirements
- [ ] GDPR воспринимается как data handling requirement

## Interview readiness
- [ ] Есть краткое end-to-end объяснение платежа
- [ ] Есть layered view всей темы
- [ ] Есть короткая шпаргалка для повторения перед интервью

---

# Как пользоваться этой шпаргалкой
1. Сначала пройти блоки по порядку.
2. После каждого блока сделать короткий устный пересказ.
3. В конце каждого дня собрать весь flow с начала до конца.
4. Перед интервью повторить только блок 9, блок 10 и финальный чек-лист.
