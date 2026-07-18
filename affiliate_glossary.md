## Примечание о конфиденциальности

Документ содержит только общепринятые отраслевые термины и типовые примеры. Он не описывает архитектуру, процессы, метрики, договорные условия, названия продуктов или организационную структуру конкретной компании.

---

## 0. Термины первой необходимости

| Термин | Кратко |
|---|---|
| **Affiliate / Partner** | Партнёр, который привлекает трафик на продукт рекламодателя |
| **Webmaster** | Вебмастер; в affiliate-домене часто общее название партнёра |
| **Advertiser** | Рекламодатель, которому партнёр приводит пользователей |
| **Offer** | Типовые условия для конкретного GEO, продукта и типа трафика |
| **Deal** | Индивидуальные условия конкретного партнёра |
| **GEO** | Страна или регион трафика |
| **Traffic Source** | Источник трафика: PPC, SEO, ASO, In-App, Push и т. д. |
| **Tracking Link** | Ссылка с идентификаторами партнёра, оффера и кампании |
| **Attribution** | Правило определения партнёра, которому засчитывается конверсия |
| **Postback / S2S Postback** | Серверное уведомление о регистрации, депозите или другой конверсии |
| **Conversion** | Целевое действие: регистрация, депозит, FTD и т. п. |
| **FTD** | Первый депозит пользователя |
| **QFTD** | FTD, прошедший правила квалификации |
| **CPA** | Фиксированная выплата за квалифицированное действие |
| **RevShare** | Процент партнёра от согласованного дохода |
| **Hybrid** | Комбинация CPA и RevShare |
| **Cap** | Лимит трафика или конверсий |
| **Hold** | Период ожидания перед подтверждением конверсии или комиссии |
| **GGR** | Игровой доход до вычетов |
| **NGR** | Игровой доход после предусмотренных вычетов |
| **Commission** | Вознаграждение партнёра |
| **Payout** | Выплата партнёру |
| **Adjustment** | Корректировка начислений |
| **Partner 360** | Карточка партнёра со статистикой, deals, выплатами и коммуникациями |
| **Admin** | Внутренний интерфейс управления партнёрской программой |
| **Partner Cabinet** | Внешний кабинет партнёра |
| **Reconciliation** | Сверка данных CRM, продукта, трекинга и финансов |
| **Source of Truth** | Система, данные которой считаются эталонными |
| **Audit Log** | История действий и изменений |

---

# 1. Участники и организационные роли

| Термин | Значение |
|---|---|
| **Affiliate / Affiliate Partner** | Физическое лицо, команда или компания, привлекающая пользователей |
| **Webmaster** | Общее название affiliate-партнёра; необязательно владеет сайтом |
| **Media Buyer** | Специалист, покупающий и оптимизирующий рекламный трафик |
| **Media Buying Team** | Команда медиабайеров, дизайнеров, аналитиков и техспециалистов |
| **Advertiser** | Компания или бренд, принимающий трафик и оплачивающий результат |
| **Operator** | Компания, управляющая gambling-продуктом и пользовательской платформой |
| **Affiliate Program** | Бизнес и система, связывающие рекламодателя и партнёров |
| **Affiliate Network** | Посредник, агрегирующий офферы разных рекламодателей |
| **Direct Advertiser** | Рекламодатель, работающий с партнёрами напрямую |
| **Sub-affiliate** | Субпартнёр, работающий через другого партнёра |
| **Affiliate Manager / AM** | Ведёт партнёров, согласовывает условия и контролирует трафик |
| **Account Manager** | Аккаунт-менеджер; иногда синоним Affiliate Manager |
| **Business Development / BD** | Ищет новых партнёров, GEO и коммерческие возможности |
| **Head of Affiliates** | Руководитель affiliate-направления |
| **Finance Manager** | Контролирует начисления, сверки и выплаты |
| **Antifraud Analyst** | Проверяет качество трафика и подозрительные паттерны |
| **Product Manager / PdM** | Определяет цели, метрики и roadmap продукта |
| **Product Owner / PO** | Управляет backlog и приоритетами |
| **Business Analyst / BA** | Анализирует процессы и описывает бизнес-требования |
| **System Analyst / SA** | Детализирует интеграции, данные и API |
| **Project Manager / PM** | Управляет сроками, рисками и координацией |
| **Delivery Manager / DM** | Отвечает за поставку результата командами разработки |
| **Quality Assurance / QA** | Проверяет соответствие реализации требованиям |
| **Frontend / FE** | Клиентская часть Admin или Partner Cabinet |
| **Backend / BE** | Серверная логика, расчёты и интеграции |
| **Business Unit / BU** | Организационная единица, отвечающая за направление бизнеса |
| **Core Team** | Команда базовой функциональности продукта |
| **Sub-product** | Отдельный продукт или функциональная область экосистемы |
| **Sub-team** | Команда конкретного сервиса или направления |
| **Delivery Branch** | Техническая ветка: разработка, архитектура, delivery |
| **Business Branch** | Продукт, аналитика и бизнес-заказчики |

---

# 2. Основные бизнес-сущности CRM

| Термин | Значение |
|---|---|
| **Partner Account** | Учётная запись партнёра |
| **Master Account** | Главный аккаунт affiliate-команды или компании |
| **Sub-account** | Дополнительный аккаунт внутри организации партнёра |
| **Partner Profile** | Регистрационные и контактные данные партнёра |
| **Partner 360** | Единая карточка: контакты, deals, трафик, баланс, выплаты, риски |
| **Lead** | Потенциальный партнёр до завершения onboarding |
| **Application** | Заявка на регистрацию или подключение |
| **Onboarding** | Регистрация, проверка, согласование условий и активация |
| **Verification** | Проверка данных, источников трафика и реквизитов |
| **Partner Status** | New, Under Review, Active, Blocked, Dormant и т. д. |
| **Owner / Assignee** | Ответственный за партнёра, заявку или задачу |
| **Offer** | Типовые условия по продукту, GEO, source и модели оплаты |
| **Deal** | Индивидуальные коммерческие условия партнёра |
| **Custom Deal** | Deal с нестандартной ставкой, KPI, cap или hold |
| **Deal Version** | Версия условий, действующая в определённый период |
| **Effective Date** | Дата начала действия условий |
| **Expiration Date** | Дата окончания действия условий |
| **Campaign** | Группа трафика или рекламная кампания |
| **Creative** | Баннер, видео, текст, лендинг или приложение |
| **Promo Materials** | Промоматериалы для партнёров |
| **Tracking Link** | Ссылка для определения источника и владельца трафика |
| **Wallet** | Платёжный реквизит или логический кошелёк |
| **Balance** | Финансовый остаток партнёра |
| **Payout Request** | Запрос партнёра на выплату |
| **Dispute** | Спор по статистике, комиссии или выплате |
| **Ticket** | Запрос в поддержку или операционную команду |
| **Task** | Действие, назначенное сотруднику CRM |
| **Note** | Внутренняя заметка по партнёру |
| **Communication Log** | История писем, сообщений, звонков и договорённостей |
| **Tag** | Метка для классификации объектов |
| **Segment** | Группа партнёров с общими характеристиками |
| **Blacklist / Whitelist** | Запрещённые / разрешённые партнёры, площадки или источники |

---

# 3. Коммерческие модели и условия

| Термин | Расшифровка / значение |
|---|---|
| **CPA** | Cost per Action / Acquisition — фиксированная выплата за квалифицированное действие |
| **CPL** | Cost per Lead — оплата за лид или регистрацию |
| **CPC** | Cost per Click — оплата за клик |
| **CPM** | Cost per Mille — оплата за 1 000 показов |
| **CPI** | Cost per Install — оплата за установку приложения |
| **RevShare / RS** | Revenue Share — процент партнёра от согласованной базы дохода |
| **Hybrid** | Комбинация CPA и RevShare |
| **Flat Fee** | Фиксированная сумма за размещение или период |
| **Base Rate** | Базовая ставка оффера |
| **Custom Rate** | Индивидуальная ставка партнёра |
| **Tiered Rate** | Ступенчатая ставка, зависящая от объёма или качества |
| **Rate Grid** | Сетка ставок по GEO, source, продукту и KPI |
| **Cap** | Максимальный объём трафика или конверсий |
| **Daily / Monthly / Total Cap** | Лимит за день, месяц или весь период |
| **Soft Cap** | Мягкий лимит: превышение требует согласования |
| **Hard Cap** | Жёсткий лимит: сверх него конверсии могут не приниматься |
| **Overcap** | Трафик или конверсии сверх лимита |
| **KPI** | Key Performance Indicator — критерий качества или эффективности |
| **Qualification Rule** | Условия, при которых конверсия становится оплачиваемой |
| **Minimum Deposit** | Минимальная сумма депозита для квалификации |
| **Turnover Requirement** | Требование по минимальному игровому обороту |
| **Redeposit Requirement** | Требование повторного депозита |
| **Hold Period** | Период ожидания до подтверждения конверсии или комиссии |
| **Grace Period** | Дополнительное время для выполнения условия |
| **Commission** | Рассчитанное вознаграждение партнёра |
| **Negative Carryover** | Перенос отрицательного RevShare-баланса на следующий период |
| **No Negative Carryover** | Новый период начинается без прошлого отрицательного баланса |
| **Admin Fee** | Предусмотренный deal административный вычет |
| **Clawback** | Списание ранее начисленной комиссии после пересмотра данных |
| **Adjustment** | Добавление или списание суммы вне стандартного расчёта |
| **Retroactive Recalculation** | Перерасчёт прошлых периодов |

---

# 4. Воронка привлечения и конверсии

| Термин | Значение |
|---|---|
| **Impression** | Показ рекламы |
| **Click** | Переход по рекламной ссылке |
| **Visit / Session** | Посещение сайта или пользовательская сессия |
| **Registration / Reg** | Создание пользовательского аккаунта |
| **Verified Registration** | Регистрация, прошедшая необходимые проверки |
| **Deposit** | Внесение средств пользователем |
| **FTD** | First-Time Deposit — первый депозит |
| **QFTD / Qualified FTD** | FTD, выполнивший правила квалификации |
| **NDC** | New Depositing Customer — новый депозитный клиент |
| **Redeposit** | Повторный депозит |
| **Depositor** | Пользователь, совершивший депозит |
| **Active Player** | Пользователь, выполнивший критерии активности за период |
| **Conversion** | Целевое действие, засчитываемое в статистике |
| **Conversion Type** | Registration, FTD, QFTD, Redeposit и т. д. |
| **Conversion Status** | Pending, Approved, Rejected, Cancelled и т. д. |
| **Pending Conversion** | Конверсия ожидает проверки или окончания hold |
| **Approved Conversion** | Подтверждённая конверсия |
| **Rejected Conversion** | Отклонённая конверсия |
| **Funnel** | Цепочка этапов от рекламы до ценного действия |
| **Drop-off** | Потеря пользователей между этапами |
| **Cohort** | Группа пользователей с общим периодом или признаком привлечения |
| **Retention** | Доля пользователей, продолжающих активность |
| **Churn** | Прекращение активности |
| **Reactivation** | Возврат ранее неактивного пользователя |
| **Cross-sell** | Перевод пользователя между продуктами, например Casino → Sportsbook |

---

# 5. Метрики affiliate-маркетинга

| Метрика | Формула / смысл |
|---|---|
| **CTR** | Click-Through Rate = Clicks / Impressions |
| **Click2Reg / C2R** | Registrations / Clicks |
| **Reg2Dep / R2D** | FTD / Registrations |
| **Dep2Redep** | Redepositors / FTD |
| **CR** | Conversion Rate — доля конверсий от выбранной базы |
| **Approval Rate** | Approved Conversions / All Conversions |
| **Rejection Rate** | Rejected Conversions / All Conversions |
| **EPC** | Earnings per Click = Commission / Clicks |
| **eCPA** | Effective CPA = фактические затраты / конверсии |
| **CAC** | Customer Acquisition Cost |
| **ARPU** | Average Revenue per User |
| **ARPPU** | Average Revenue per Paying User |
| **LTV** | Lifetime Value |
| **ROI** | Return on Investment |
| **ROAS** | Return on Ad Spend |
| **FTD Rate** | Доля FTD относительно регистраций или кликов |
| **Redeposit Rate** | Доля пользователей с повторным депозитом |
| **Fraud Rate** | Доля fraud-конверсий |
| **Chargeback Rate** | Доля возвратов платежей |
| **Payout Accuracy** | Доля выплат без ошибок и корректировок |
| **Time to Approve** | Время от конверсии до подтверждения |
| **Time to Payout** | Время от готовности суммы до выплаты |

---

# 6. Игровые и финансовые показатели

| Термин | Значение |
|---|---|
| **Casino** | Игровая вертикаль: slots, live casino и др. |
| **Sportsbook / Betting** | Вертикаль спортивных ставок |
| **Bet / Stake** | Ставка / размер ставки |
| **Turnover** | Суммарный объём ставок |
| **Win** | Выигрыш пользователя |
| **GGR** | Gross Gaming Revenue; упрощённо: ставки минус выигрыши |
| **NGR** | Net Gaming Revenue; GGR после согласованных вычетов |
| **Bonus Cost** | Стоимость использованных бонусов |
| **Payment Fee** | Комиссии платёжных систем |
| **Chargeback** | Принудительный возврат карточного платежа |
| **Refund** | Возврат средств пользователю |
| **Tax Deduction** | Налоговый вычет из расчётной базы |
| **Platform Fee** | Платформенный или сервисный вычет |
| **Net Revenue Base** | База, от которой рассчитывается RevShare |
| **Player LTV** | Доходность пользователя за жизненный цикл |
| **Average Deposit** | Средняя сумма депозита |
| **Deposit Frequency** | Частота депозитов |
| **Betting Margin** | Доля дохода оператора от betting turnover |
| **RTP** | Return to Player — теоретический процент возврата игроку |
| **Wagering Requirement** | Условие отыгрыша бонуса |
| **Bonus Abuse** | Злоупотребление бонусной системой |

> Формулу **NGR** необходимо фиксировать отдельно для каждого продукта и deal: набор вычетов может различаться.

---

# 7. Источники и форматы трафика

| Термин | Значение |
|---|---|
| **Traffic Source** | Канал или платформа, откуда приходит пользователь |
| **PPC** | Pay-Per-Click; платный рекламный трафик |
| **SEO** | Search Engine Optimization; органический поисковый трафик |
| **ASO** | App Store Optimization; продвижение приложений в сторах |
| **In-App Traffic** | Трафик из мобильных приложений |
| **Native Advertising** | Реклама, визуально встроенная в контент площадки |
| **Push Traffic** | Трафик из push-уведомлений |
| **Pop Traffic** | Pop-up / pop-under реклама |
| **Display Traffic** | Баннерная реклама |
| **Email Traffic** | Трафик из email-рассылок |
| **Social Traffic** | Трафик из социальных сетей |
| **Influencer / Streamer Traffic** | Трафик от блогеров и стримеров |
| **Referral Traffic** | Переходы по ссылкам с других сайтов |
| **Organic / Paid Traffic** | Неплатный / покупной трафик |
| **Brand / Non-brand Traffic** | Трафик по брендовым / общим запросам |
| **Incentivized Traffic** | Мотивированный трафик с наградой пользователю за действие |
| **Restricted / Forbidden Traffic** | Ограниченный / запрещённый тип трафика |
| **Source** | Источник трафика верхнего уровня |
| **Placement** | Конкретное место показа рекламы |
| **Publisher** | Владелец рекламной площадки |
| **Campaign / Ad Set / Ad** | Кампания / группа объявлений / объявление |
| **Landing Page / LP** | Целевая страница |
| **Pre-lander** | Промежуточная страница перед лендингом |
| **Deeplink** | Ссылка на конкретный раздел сайта или приложения |
| **WebView** | Веб-страница внутри мобильного приложения |
| **Native App** | Нативное мобильное приложение |
| **APK** | Установочный пакет Android |
| **PWA** | Progressive Web App |
| **Localization** | Адаптация контента под язык и рынок |
| **GEO** | Страна или регион трафика |
| **Cloaking** | Сокрытие реального рекламного контента от модерации; часто запрещено |
| **Doorway** | Страница, созданная для перенаправления поискового трафика |
| **Creative Fatigue** | Падение эффективности объявления из-за частого показа |

---

# 8. Tracking и атрибуция

| Термин | Значение |
|---|---|
| **Tracking** | Сбор и связывание кликов, пользователей и конверсий |
| **Tracking Link** | Ссылка с техническими параметрами идентификации |
| **Redirect** | Перенаправление через tracking-сервис |
| **Click ID** | Уникальный идентификатор клика |
| **Session ID** | Идентификатор сессии |
| **Affiliate ID / aff_id** | Идентификатор партнёра |
| **Offer ID** | Идентификатор оффера |
| **Campaign ID** | Идентификатор кампании |
| **SubID / sub1…subN** | Параметры детализации трафика партнёром |
| **UTM Parameters** | source, medium, campaign и другие параметры URL |
| **Macro / Token** | Шаблонный параметр, автоматически подставляемый системой |
| **Attribution** | Определение владельца конверсии |
| **Attribution Model** | Набор правил атрибуции |
| **First Click / Last Click** | Конверсия присваивается первому / последнему источнику |
| **Attribution Window** | Срок после клика, в течение которого засчитывается конверсия |
| **Cookie Attribution** | Атрибуция по cookie |
| **Server-side Attribution** | Атрибуция на серверной стороне |
| **Device Fingerprint** | Набор признаков устройства для идентификации |
| **Cross-device Attribution** | Связывание действий пользователя на разных устройствах |
| **S2S** | Server-to-Server взаимодействие |
| **Postback** | Серверное уведомление о конверсии |
| **Global / Offer Postback** | Postback для всех офферов / конкретного оффера |
| **Callback** | Обратный вызов; близкое к webhook/postback понятие |
| **Webhook** | HTTP-уведомление о событии |
| **Tracking / Conversion Pixel** | Pixel для фиксации показа или конверсии |
| **Event** | Факт: click, registration, deposit и т. д. |
| **Event Timestamp** | Время возникновения события |
| **Processing Timestamp** | Время обработки события |
| **Deduplication** | Исключение повторной обработки события |
| **Idempotency** | Повтор запроса не создаёт повторного бизнес-результата |
| **Lost Attribution** | Не удалось определить партнёра конверсии |
| **Organic Attribution** | Конверсия не отнесена к платному партнёру |
| **Reattribution** | Повторное определение источника пользователя |
| **Postback Log** | Журнал отправки postback-запросов |
| **Retry** | Повторная попытка доставки |
| **Delivery Status** | Статус доставки postback/webhook |
| **HTTP Status Code** | Код результата HTTP-запроса |
| **Timeout** | Превышение времени ожидания |
| **Fallback** | Резервный сценарий |

### Пример tracking link

```text
?aff_id=12345
&offer_id=678
&campaign_id=summer_br
&sub1=facebook
&sub2=creative_12
&sub3=audience_25_40
&click_id={generated_click_id}
```

---

# 9. Финансы, баланс и выплаты

| Термин | Значение |
|---|---|
| **Commission Calculation** | Расчёт вознаграждения партнёра |
| **Accrual** | Начисление суммы |
| **Ledger** | Журнал финансовых проводок |
| **Ledger Entry** | Отдельная запись в ledger |
| **Transaction** | Финансовая операция |
| **Pending Balance** | Сумма ожидает проверки или окончания hold |
| **Approved Balance** | Подтверждённая сумма |
| **Available Balance** | Сумма доступна к выплате |
| **Reserved Balance** | Сумма зарезервирована под payout |
| **Paid / Negative Balance** | Выплаченный / отрицательный остаток |
| **Payout** | Выплата партнёру |
| **Auto / Manual Payout** | Автоматическая / ручная выплата |
| **Payout Threshold** | Минимальная сумма выплаты |
| **Payment Schedule** | График выплат: weekly, biweekly, monthly |
| **Payment Period** | Расчётный период |
| **Settlement** | Финальное закрытие обязательств за период |
| **Reconciliation** | Сверка рассчитанных и фактических данных |
| **Invoice** | Счёт или финансовый документ |
| **Payment Method** | Способ выплаты |
| **Bank Transfer** | Банковский перевод |
| **Crypto Payout** | Выплата в криптовалюте |
| **USDT** | Стейблкоин, часто используемый для расчётов |
| **Wallet Address** | Адрес криптокошелька |
| **Network** | Блокчейн-сеть: TRC20, ERC20 и т. д. |
| **Exchange / FX Rate** | Валютный курс |
| **Base Currency** | Базовая валюта расчёта |
| **Settlement Currency** | Валюта фактического расчёта |
| **Payment Fee** | Комиссия за перевод |
| **Payout Status** | Requested, Approved, Processing, Paid и т. д. |
| **Rollback** | Откат операции |
| **Returned Payout** | Возвращённая выплата |
| **Outstanding Amount** | Непогашенная сумма обязательств |
| **Financial Period Close** | Закрытие расчётного периода |
| **Four-eyes Principle** | Подтверждение критической операции двумя сотрудниками |

### Типовой payout lifecycle

```text
Draft
→ Requested
→ Under Review
→ Approved
→ Reserved
→ Processing
→ Paid

Альтернативные:
Rejected
Cancelled
Failed
Returned
Adjusted
```

---

# 10. Antifraud, риски и compliance

| Термин | Значение |
|---|---|
| **Fraud** | Намеренное получение выгоды с нарушением правил |
| **Traffic Fraud** | Фальсификация кликов, лидов или конверсий |
| **Fake Lead** | Искусственная или несуществующая регистрация |
| **Bot Traffic** | Автоматизированный трафик без реальных пользователей |
| **Click Spam** | Массовая генерация кликов ради ложной атрибуции |
| **Cookie Stuffing** | Установка affiliate-cookie без реального перехода |
| **Self-referral** | Партнёр приводит сам себя или связанные аккаунты |
| **Multi-accounting** | Несколько аккаунтов одного лица |
| **Duplicate Account / Conversion** | Дублирующий аккаунт / повторная конверсия |
| **Bonus Abuse** | Злоупотребление бонусной системой |
| **Chargeback Fraud** | Мошенническое использование возврата платежа |
| **Proxy / VPN Traffic** | Трафик с сокрытием фактического местоположения |
| **Device Farm** | Массовое использование устройств для генерации действий |
| **Incentive Abuse** | Злоупотребление мотивированным трафиком |
| **Fraud Score** | Числовая оценка риска |
| **Risk Flag / Risk Level** | Признак / уровень риска |
| **Manual Review** | Ручная проверка кейса |
| **Traffic Validation** | Проверка соответствия трафика правилам |
| **Quality Check** | Проверка качества пользователей и активности |
| **Reject Reason** | Причина отклонения конверсии |
| **Block / Suspension** | Блокировка / временная приостановка партнёра |
| **KYC** | Know Your Customer — проверка физического лица |
| **KYB** | Know Your Business — проверка компании |
| **AML** | Anti-Money Laundering |
| **Sanctions Screening** | Проверка по санкционным спискам |
| **PEP** | Politically Exposed Person |
| **SoF / SoW** | Source of Funds / Source of Wealth |
| **Responsible Gaming / RG** | Меры ответственной игры |
| **Self-exclusion** | Самоисключение пользователя |
| **Marketing Consent** | Согласие на маркетинговые коммуникации |
| **GDPR** | Регламент ЕС о защите персональных данных |
| **Data Retention** | Срок хранения данных |
| **Data Minimization** | Хранение только необходимых данных |
| **PII** | Personally Identifiable Information |
| **Sensitive Data** | Данные с повышенными требованиями защиты |

---

# 11. CRM и операционные процессы

| Термин | Значение |
|---|---|
| **Admin Panel / Admin** | Внутренний интерфейс уполномоченных сотрудников |
| **Partner Cabinet / Portal** | Пользовательский интерфейс партнёра |
| **Dashboard** | Сводный экран показателей |
| **Report** | Отчёт с заданным набором данных |
| **Widget** | Информационный блок интерфейса |
| **Filter** | Условие отбора данных |
| **Saved Filter / View** | Сохранённый набор фильтров и колонок |
| **Bulk Action** | Массовое действие над объектами |
| **Export / Import** | Выгрузка / загрузка данных |
| **Approval Workflow** | Процесс согласования операции или изменения |
| **Maker-Checker** | Один сотрудник создаёт, другой подтверждает |
| **Assignment Rule** | Правило назначения партнёра или задачи |
| **Routing Rule** | Правило направления кейса в команду |
| **Escalation** | Передача проблемы на более высокий уровень |
| **SLA** | Согласованный уровень и срок сервиса |
| **Breach** | Нарушение SLA |
| **Notification / Reminder** | Уведомление / напоминание |
| **Inbox / Queue** | Очередь входящих задач или объектов |
| **Case Management** | Управление обращениями и расследованиями |
| **Audit Log** | История действий и изменений |
| **Change History** | История изменения конкретного объекта |
| **RBAC** | Role-Based Access Control |
| **Role / Permission** | Набор прав / отдельное разрешение |
| **Scope of Access** | Область данных, доступная пользователю |
| **Data Masking** | Скрытие чувствительных полей |
| **Impersonation** | Вход от лица партнёра для диагностики; требует аудита |
| **Feature Flag** | Управляемое включение функции |
| **Configuration** | Настройки поведения системы |
| **Reference Data** | GEO, валюты, статусы и другие справочные данные |
| **Dictionary** | Управляемый справочник значений |
| **Localization / i18n** | Поддержка разных языков и форматов |
| **Tenant** | Изолированный логический контур |
| **Multi-tenant** | Одна платформа обслуживает несколько контуров |
| **White Label / WL** | Отдельный бренд или конфигурация общей платформы |

---

# 12. Технические термины и интеграции

| Термин | Значение |
|---|---|
| **API** | Application Programming Interface |
| **Endpoint** | Конкретная API-операция |
| **Request / Response** | Запрос / ответ сервиса |
| **Payload** | Передаваемые данные |
| **HTTP Method** | GET, POST, PUT, PATCH, DELETE |
| **Authentication** | Проверка личности вызывающей стороны |
| **Authorization** | Проверка прав на действие |
| **API Key** | Ключ доступа к API |
| **OAuth 2.0** | Протокол делегированной авторизации |
| **JWT** | JSON Web Token |
| **Webhook** | HTTP-уведомление о событии |
| **Postback Service** | Сервис отправки affiliate-postback |
| **Synchronous Integration** | Интеграция с ожиданием ответа |
| **Asynchronous Integration** | Интеграция без блокирующего ожидания |
| **Event-driven Architecture** | Архитектура, основанная на событиях |
| **Message Broker** | Посредник для передачи сообщений |
| **Kafka / RabbitMQ** | Платформа событий / брокер сообщений |
| **Topic / Queue** | Канал событий / очередь сообщений |
| **Producer / Consumer** | Публикующий / читающий события сервис |
| **Consumer Group** | Группа consumers, совместно обрабатывающих topic |
| **Schema** | Структура данных или сообщения |
| **Schema Registry** | Хранилище версий схем |
| **Idempotency Key** | Ключ защиты от повторного бизнес-результата |
| **Deduplication Key** | Ключ определения дубликата |
| **Retry Policy / Backoff** | Повторные попытки / увеличение интервала между ними |
| **DLQ** | Dead Letter Queue — очередь необработанных сообщений |
| **Timeout** | Ограничение времени ожидания |
| **Rate Limit / Throttling** | Ограничение / снижение скорости запросов |
| **Latency** | Задержка обработки |
| **Throughput** | Пропускная способность |
| **Availability** | Доступность сервиса |
| **Scalability** | Масштабируемость |
| **High Load** | Высокая нагрузка |
| **Failover** | Переключение на резервный компонент |
| **Circuit Breaker** | Защита от каскадных отказов |
| **Batch Processing** | Пакетная обработка |
| **Real-time / Near Real-time** | Мгновенная / почти мгновенная обработка |
| **ETL / ELT** | Подходы к извлечению, загрузке и преобразованию данных |
| **DWH** | Data Warehouse |
| **Data Lake** | Хранилище исходных данных |
| **BI** | Business Intelligence |
| **OLTP / OLAP** | Операционная / аналитическая обработка данных |
| **Source of Truth / SoT** | Эталонный источник данных |
| **Data Lineage** | Путь происхождения и преобразования данных |
| **Data Quality / DQ** | Качество данных |
| **Monitoring / Logging / Tracing** | Наблюдение / журналы / трассировка запросов |
| **Correlation ID** | Общий идентификатор запроса в разных сервисах |
| **Alert / Incident** | Сигнал о проблеме / нарушение работы |
| **RCA** | Root Cause Analysis |
| **SLA / SLO / SLI** | Соглашение / цель / показатель уровня сервиса |

---

# 13. Аналитика и отчётность

| Термин | Значение |
|---|---|
| **Operational Report** | Операционный отчёт для ежедневной работы |
| **Management Report** | Отчёт для руководства |
| **Traffic Report** | Отчёт по кликам, регистрациям и конверсиям |
| **Finance Report** | Отчёт по начислениям, балансам и выплатам |
| **Fraud Report** | Отчёт по отклонённым и подозрительным данным |
| **Cohort Analysis** | Анализ групп пользователей во времени |
| **Funnel Analysis** | Анализ конверсии между этапами |
| **Variance** | Расхождение ожидаемого и фактического значения |
| **Data Discrepancy** | Расхождение данных между системами |
| **Drill-down** | Переход от агрегата к деталям |
| **Aggregation** | Объединение данных в суммарные показатели |
| **Dimension** | Разрез: GEO, partner, source, campaign |
| **Measure** | Числовой показатель: clicks, FTD, GGR |
| **Granularity** | Уровень детализации данных |
| **Snapshot** | Снимок состояния данных на момент времени |
| **Metric Definition** | Формальное описание расчёта метрики |
| **Dashboard Freshness** | Актуальность данных дашборда |
| **Data Lag** | Задержка появления данных |
| **Tableau** | BI-инструмент визуализации |
| **Heatmap** | Карта активности пользователей в интерфейсе |
| **Feature Usage / Adoption** | Частота использования / доля освоивших функцию |

---

# 14. Термины продуктовой разработки

| Термин | Значение |
|---|---|
| **SDLC** | Software Development Life Cycle |
| **Discovery** | Исследование проблемы, потребностей и вариантов решения |
| **Initiative** | Крупная бизнес-инициатива |
| **Epic** | Крупный функциональный блок |
| **User Story / US** | Пользовательская история |
| **Use Case / UC** | Сценарий взаимодействия с системой |
| **Acceptance Criteria / AC** | Проверяемые критерии приёмки |
| **Business Rule / BR** | Бизнес-правило |
| **NFR** | Non-functional Requirement |
| **BRD / PRD / SRS** | Документы бизнес-, продуктовых и системных требований |
| **Scope / Out of Scope** | Что входит / не входит в решение |
| **Dependency** | Зависимость |
| **Constraint** | Ограничение |
| **Assumption** | Допущение |
| **Risk** | Риск |
| **Backlog** | Упорядоченный список работ |
| **Roadmap** | План развития продукта |
| **Sprint** | Итерация разработки |
| **Refinement / Grooming** | Уточнение и подготовка backlog |
| **Sprint Planning** | Планирование спринта |
| **Daily** | Ежедневная синхронизация |
| **Demo / Review** | Демонстрация результата |
| **Retrospective** | Обсуждение улучшений процесса |
| **DoR** | Definition of Ready |
| **DoD** | Definition of Done |
| **UAT** | User Acceptance Testing |
| **MVP** | Minimum Viable Product |
| **PoC** | Proof of Concept |
| **Prototype / Wireframe** | Прототип / упрощённый макет |
| **BPMN** | Нотация бизнес-процессов |
| **UML** | Набор нотаций моделирования |
| **Sequence Diagram** | Диаграмма последовательности |
| **State Machine** | Статусная модель и переходы |
| **ERD** | Entity Relationship Diagram |
| **RACI** | Responsible, Accountable, Consulted, Informed |
| **MoSCoW** | Must, Should, Could, Won’t |
| **RICE** | Reach, Impact, Confidence, Effort |
| **WSJF** | Weighted Shortest Job First |
| **Impact Analysis** | Анализ влияния изменения |
| **Gap Analysis** | Сравнение As-Is и To-Be |
| **As-Is / To-Be** | Текущее / целевое состояние |

---

# 15. Типовые статусные модели

## 15.1. Partner lifecycle

```text
New
→ Under Review
→ Contacted
→ Negotiation
→ Approved
→ Active

Дополнительные:
Rejected
Dormant
Suspended
Blocked
Closed
Reactivation
```

## 15.2. Conversion lifecycle

```text
Received
→ Pending
→ Under Validation
→ Qualified
→ Approved
→ Payable

Альтернативные:
Rejected
Duplicate
Fraud
Cancelled
Expired
Adjusted
```

## 15.3. Deal lifecycle

```text
Draft
→ Pending Approval
→ Approved
→ Scheduled
→ Active
→ Expired

Альтернативные:
Rejected
Cancelled
Suspended
Replaced
```

## 15.4. Postback delivery

```text
Created
→ Queued
→ Sending
→ Delivered

Альтернативные:
Retry Scheduled
Failed
Expired
Cancelled
```

---

# 16. Мини-шпаргалка по формулам

```text
CTR = Clicks / Impressions

Click2Reg = Registrations / Clicks

Reg2Dep = FTD / Registrations

Approval Rate = Approved Conversions / All Conversions

CPA Commission = Qualified Conversions × CPA Rate

RevShare Commission = Revenue Base × RevShare %

Hybrid Commission =
    Qualified Conversions × CPA Rate
    + Revenue Base × RevShare %

EPC = Partner Commission / Clicks

ROI = (Revenue − Cost) / Cost
```

---

# 17. Вопросы, которые BA должен задавать

## При изменении Offer / Deal

1. Для какого партнёра, GEO, продукта и traffic source действует изменение?
2. С какой даты применяется новая версия?
3. К какой дате привязывается ставка: `click date`, `registration date`, `FTD date` или `approval date`?
4. Что произойдёт с уже полученными, но не подтверждёнными конверсиями?
5. Требуется ли ретроактивный перерасчёт?
6. Кто должен согласовать изменение?
7. Как изменение отразится в Partner Cabinet, отчётах и payout?

## При изменении квалификации FTD

1. Как определяется первый депозит?
2. Какой минимальный депозит?
3. Требуется ли KYC, turnover или redeposit?
4. Какой qualification window?
5. Какие fraud-причины исключают FTD?
6. Может ли ранее отклонённый FTD стать approved?
7. Нужно ли отправлять postback при смене статуса?

## При изменении payout

1. Из какого balance списывается сумма?
2. Когда сумма резервируется?
3. Возможна ли отмена после резервирования?
4. Кто подтверждает выплату?
5. Как обрабатывается ошибка платёжного провайдера?
6. Как учитываются payment fee и FX rate?
7. Какая система является Source of Truth?
8. Как обеспечиваются audit и idempotency?

---

# 18. Термины, вероятно релевантные структуре Product Partners

| Термин | Практический смысл |
|---|---|
| **Product Partners** | Партнёрская программа и соответствующий business unit |
| **Partner Cabinet / Partner Portal** | Внешняя часть для вебмастеров и affiliate-команд |
| **Admin** | Внутренний интерфейс управления партнёрами и аналитикой |
| **Promo Delivery** | Доставка промоматериалов, ссылок и приложений |
| **Application Services** | Сервисы native apps, WebView и других application-решений |
| **Postback Services** | Сервисы доставки конверсионных событий партнёрам |
| **Traffic Services** | Сервисы маршрутизации, трекинга и технической поддержки трафика |
| **Loyalty Shop** | Loyalty/shop-контур для партнёров |
| **Loyalty Points** | Внутренняя loyalty-валюта партнёрской экосистемы |
| **Quest** | Задание партнёру с проверкой и вознаграждением |

---

# 18. Критические различия, которые нельзя смешивать

| Не путать | Разница |
|---|---|
| **Offer vs Deal** | Offer — типовые условия; Deal — условия конкретного партнёра |
| **FTD vs QFTD** | FTD — первый депозит; QFTD — FTD, прошедший квалификацию |
| **Click Date vs Conversion Date** | Дата клика и дата действия могут относиться к разным периодам |
| **GGR vs NGR** | GGR — до вычетов; NGR — после согласованных вычетов |
| **Pending vs Available Balance** | Pending ещё нельзя выплатить; Available можно |
| **Postback vs Webhook** | Технически близки; postback чаще используется в affiliate tracking |
| **Partner CRM vs Player CRM** | Первая управляет партнёрами; вторая — жизненным циклом игроков |
| **Traffic Source vs Campaign** | Source — канал; Campaign — конкретная рекламная активность |
| **Fraud vs Low-quality Traffic** | Fraud — нарушение; низкое качество может быть честным |
| **Adjustment vs Recalculation** | Adjustment — отдельная проводка; recalculation — повторный расчёт |
| **Admin vs Partner Cabinet** | Admin — внутренний интерфейс; Cabinet — интерфейс партнёра |
| **Tracking vs Financial Data** | Tracking фиксирует события; finance определяет обязательства |

---

# 19. Рабочее правило для аналитика

Для любой задачи в affiliate CRM полезно пройти цепочку:

```text
Partner
→ Offer / Deal
→ Traffic
→ Attribution
→ Conversion
→ Qualification
→ Commission
→ Balance
→ Payout
→ Reconciliation
→ Audit
```

Если изменение затрагивает один этап, почти всегда нужно проверить его влияние на все последующие.
