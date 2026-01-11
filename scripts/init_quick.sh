#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="${1:-.}"

mkdir -p "$BASE_DIR/Quick/templates" \
         "$BASE_DIR/Quick/checklists" \
         "$BASE_DIR/Quick/interview" \
         "$BASE_DIR/Quick/flows" \
         "$BASE_DIR/Quick/metrics" \
         "$BASE_DIR/Quick/ops" \
         "$BASE_DIR/Quick/declines" \
         "$BASE_DIR/DeepDive"

cat > "$BASE_DIR/Quick/README.md" <<'EOF'
# Quick (7h) — PSP Account Manager (Operations)

Цель: подготовка к HR/скринингу и первому интервью за ~7 часов.

## Как проходить
1) `interview/01-elevator-pitch.md` — выучи 2 версии
2) `flows/*` — проговори deposit/payout и точки отказов
3) `metrics/*` + `templates/*` — метрики, формулы, триаж
4) `declines/*` — причины declines + chargebacks
5) `ops/*` + `checklists/*` — инциденты и коммуникация
6) `interview/02-top-questions-answers.md` — отрепетируй ответы (2–3 минуты каждый)

## Definition of done (к завтра)
- Ты уверенно объясняешь deposit/payout flow и где искать проблему
- Ты называешь 6–8 ключевых метрик и что делать при их падении
- У тебя есть 2–3 кейса из опыта в формате STAR
EOF

cat > "$BASE_DIR/Quick/00-quick-plan-7h.md" <<'EOF'
# План Quick на 7 часов

## 0:00–0:45 — Позиционирование
- `interview/01-elevator-pitch.md`
- `interview/00-role-positioning.md`

## 0:45–2:00 — Payment flows (L2)
- `flows/01-deposit-flow-L2.md`
- `flows/02-payout-flow-L2.md`

## 2:00–3:15 — Declines / chargebacks
- `declines/01-decline-taxonomy.md`
- `declines/02-chargebacks-cheatsheet.md`
- `templates/decline-reason-matrix.md`

## 3:15–5:15 — Метрики и триаж
- `metrics/01-kpi-pack.md`
- `templates/metric-drop-triage-questions.md`
- `templates/provider-scorecard.md`

## 5:15–6:15 — Ops процессы + коммуникация
- `ops/01-incident-playbook.md`
- `ops/02-provider-comms.md`
- `checklists/incident-triage-checklist.md`

## 6:15–7:00 — Репетиция Q&A
- `interview/02-top-questions-answers.md`
- `interview/03-story-bank-STAR.md`
EOF

cat > "$BASE_DIR/Quick/interview/00-role-positioning.md" <<'EOF'
# Роль: PSP Account Manager (Operations) — позиционирование

## Что это за роль
Operations = стабильность и эффективность платежей в проде:
- депозиты/выводы работают
- метрики не деградируют (approval, conversion, SLA)
- провайдеры не "морозятся", у тебя контроль коммуникации и эскалации
- инциденты ведутся по playbook, есть постмортемы

## Чем отличается от BizDev
BizDev: подключение новых PSP, переговоры по контрактам, GEO expansion, pricing.
Ops: ежедневная эксплуатация, метрики, инциденты, качество маршрутизации, чарджи/фрод, коммуникация.

## Твоя сильная сторона (в 1 фразе)
"Я соединяю метрики, техническую диагностику и коммуникацию с PSP/внутренними командами, чтобы платежи работали стабильно."

## Твоя зона роста (корректно)
- "коммерческая часть контрактов — не мой фокус, но операционная часть платежей и метрики — сильная сторона."
EOF

cat > "$BASE_DIR/Quick/interview/01-elevator-pitch.md" <<'EOF'
# Elevator pitch (45–60 sec)

## Версия A — максимально Ops
Я работаю на стыке payments и техкоманд: держу платежные потоки стабильными и предсказуемыми.
Моя сильная сторона — работа с метриками (approval rate, declines, SLA, chargebacks) и быстрый triage: я умею определить, где именно ломается цепочка депозита/вывода — на стороне PSP, маршрутизации, 3DS, антифрода или бизнес-логики — и довести проблему до решения вместе с провайдерами и разработчиками.
У меня бэкграунд системного анализа и интеграций, поэтому я одинаково комфортно общаюсь с PSP/банками и с инженерами.
Именно поэтому роль PSP Account Manager (Operations) для меня — логичное продолжение: операционное управление платежами + техническая диагностика + коммуникация.

## Версия B — более бизнесовая
Мой профиль — payments operations в high-load среде.
Я помогаю улучшать и защищать выручку через стабильность платежей: слежу за ключевыми KPI (approval, conversion, payout success, chargebacks), быстро нахожу корневые причины деградаций и выстраиваю понятную коммуникацию с PSP и внутренними командами.
За счет системного подхода я не "наблюдаю цифры", а превращаю их в конкретные действия: настройка роутинга, корректировки флоу, эскалации провайдерам, контроль SLA.
EOF

cat > "$BASE_DIR/Quick/flows/01-deposit-flow-L2.md" <<'EOF'
# Deposit flow (L2) + точки контроля

## Типовой flow
1) Клиент выбирает метод оплаты в cashier
2) Система формирует payment intent / order
3) Routing выбирает PSP (или каскад)
4) Redirect / SDK / APM flow (зависит от метода)
5) PSP → acquirer → issuer (авторизация)
6) 3DS/SCA (если требуется)
7) Ответ (sync) + webhook/callback (async подтверждение)
8) Запись в ledger / баланс / отображение статуса в кабинете

## Где чаще всего ломается (и что смотреть)
- До PSP: ошибки в request, signature, amount/currency, merchant config → логи gateway, request/response
- На PSP: timeouts, provider outage, PSP rules → provider status page + correlation IDs
- Acquirer/issuer: declines codes → decline reason mapping + geo/bank patterns
- 3DS: friction, timeout, challenge fail → 3DS step metrics + device/browser issues
- Webhooks: не дошли/дубли → webhook logs, idempotency keys, retry policy

## What to ask internally
- Что менялось последние 24–48ч (routing, risk rules, 3DS настройки, UI кассы)?
- Один PSP или несколько? Один GEO или все?
- Это step-level drop или общий?
EOF

cat > "$BASE_DIR/Quick/flows/02-payout-flow-L2.md" <<'EOF'
# Payout flow (L2) + точки контроля

## Типовой flow
1) Клиент инициирует вывод (cashier)
2) Pre-checks: KYC, AML, лимиты, баланс, risk flags
3) Создается payout request → routing выбирает провайдера
4) Отправка в PSP/провайдера
5) Асинхронные статусы: pending → processing → completed / failed / reversed
6) Ledger update + уведомление клиента

## Где ломается
- KYC/AML gate: "stuck" из-за compliance → причины hold + SLA на ручные проверки
- Provider latency/outage → timeout rate, provider incident
- Bank details/format → validation errors
- Status mismatch: provider says success, у нас pending → reconciliation checks, webhook delivery

## Что важно в Ops
- SLA по выплатам (time-to-complete)
- процент stuck payouts
- причины отказов/отмен
EOF

cat > "$BASE_DIR/Quick/declines/01-decline-taxonomy.md" <<'EOF'
# Declines taxonomy (быстро)

## Уровни причин
1) Merchant / Integration
- invalid signature, bad request, amount/currency mismatch, duplicate
2) PSP layer
- provider rules, limits, risk policies, routing misconfig, outage
3) Acquirer / Issuer
- do not honor, insufficient funds, card restrictions, geo restrictions
4) 3DS/SCA
- friction, challenge failed, timeout, device/browser issues
5) Fraud/AML
- velocity checks, blacklists, suspicious patterns

## Soft vs Hard
- Soft: можно повторить/перезапустить (timeouts, do not honor, network issues)
- Hard: требует изменения параметров/метода (invalid card, stolen, permanent restrictions)
EOF

cat > "$BASE_DIR/Quick/declines/02-chargebacks-cheatsheet.md" <<'EOF'
# Chargebacks cheatsheet

## Что это
Chargeback = клиент оспорил транзакцию через банк, деньги могут быть списаны обратно + штрафы.

## Основные драйверы
- Fraud (card not present)
- Customer dispute (не узнает мерчанта, недоволен сервисом)
- Processing errors (двойные списания, некорректный refund)
- Subscription/recurring issues

## Ops что делать
- Следить за chargeback rate по PSP/GEO/методу
- Требовать у PSP reason codes + evidence requirements
- Совместно с продуктом: descriptor, refund policy, support, anti-fraud rules
- Уметь объяснить "как снизить" (не обещая магию)
EOF

cat > "$BASE_DIR/Quick/metrics/01-kpi-pack.md" <<'EOF'
# KPI pack — что должен знать на интервью

## Must-have (назвать и объяснить)
- Approval rate = approved / total attempts (уточнять: attempts или valid attempts)
- Conversion rate по кассе = success / sessions (или по шагам)
- Decline rate + breakdown по codes
- Chargeback rate (обычно на 1k транзакций или % от sales)
- Payout success rate + payout SLA (time-to-complete)
- Timeout rate / latency (p95/p99)
- Provider availability (uptime) + incident count

## Как отвечать на "метрика упала?"
Формат: scope → сегментация → гипотезы → проверки → действия → коммуникация.
EOF

cat > "$BASE_DIR/Quick/templates/metric-drop-triage-questions.md" <<'EOF'
# Metric drop triage — 15 вопросов

1) Что именно упало: approval, conversion, payout success, latency?
2) С какого времени (точка начала)?
3) Один PSP или несколько?
4) Один метод оплаты или все?
5) Один GEO/валюта/банк или широкая проблема?
6) Есть ли релизы/изменения последние 24–48ч?
7) Что в логах gateway: 4xx/5xx, timeouts, signature?
8) Что говорит PSP: incident? изменения правил? лимитов?
9) Какие топ decline codes выросли?
10) Есть ли рост 3DS challenge/timeout?
11) Изменились ли antifraud/AML правила?
12) Есть ли рост дубликатов / retries?
13) Webhooks приходят? не задваиваются?
14) Это проблема upstream (issuer/acquirer) или integration?
15) Что можно быстро сделать как mitigation? (fallback PSP, отключить метод, увеличить timeout, rollback routing rule)
EOF

cat > "$BASE_DIR/Quick/templates/provider-scorecard.md" <<'EOF'
# Provider scorecard (weekly/monthly)

## 1) Объем и доля
- Total transactions, Total volume
- Share by GEO/method

## 2) Качество
- Approval rate + top declines
- Conversion funnel (если доступно)
- Timeout/latency (p95)
- Webhook delivery reliability

## 3) Риски
- Chargeback rate + dispute reasons
- Fraud signals (если есть)
- Compliance holds (payout)

## 4) SLA/Инциденты
- Uptime
- # incidents + total downtime
- Mean time to recover (MTTR)
- Provider response SLA (support)

## 5) Action plan
- 3–5 пунктов: что меняем/проверяем/эскалируем
EOF

cat > "$BASE_DIR/Quick/templates/decline-reason-matrix.md" <<'EOF'
# Decline reason matrix (шаблон)

| Symptom/Code | Layer | Typical cause | Where to check | Action |
|---|---|---|---|---|
| Timeout | PSP/Gateway | provider latency/outage | gateway logs, PSP status | fallback PSP, increase timeout, escalate |
| Do not honor | Issuer | bank rejects w/o details | PSP response codes | сегментация GEO/bank, 3DS policy, alternative method |
| Invalid signature | Merchant | wrong signing / keys | gateway request logs | fix integration keys/signing |
| 3DS challenge fail | 3DS | user friction/timeout | 3DS metrics, device data | adjust 3DS rules, UX tips |
| Duplicate | Merchant/Gateway | retries w/o idempotency | idempotency logs | enforce idempotency, dedupe |
EOF

cat > "$BASE_DIR/Quick/ops/01-incident-playbook.md" <<'EOF'
# Incident playbook (payments)

## 1) Detect
- Alert: approval down / timeouts up / provider errors up
- Confirm with dashboard + logs (scope)

## 2) Triage (15–30 min)
- Segment: PSP / method / GEO / time window
- Identify top errors/codes
- Decide severity (SEV1/2/3)

## 3) Mitigate (быстрые действия)
- Enable fallback PSP / change routing weight
- Disable failing method temporarily
- Adjust timeouts/retries (осторожно)
- Rollback last change if obvious correlation

## 4) Communicate
- Internal: status + ETA next update
- Provider: correlation IDs, timestamps, samples, impact metrics

## 5) Resolve + Postmortem
- Root cause
- Prevent recurrence (monitoring, alerts, playbooks, tests)
EOF

cat > "$BASE_DIR/Quick/ops/02-provider-comms.md" <<'EOF'
# Provider comms templates

## A) Инцидент / деградация
Тема: [SEV-?] Payment degradation — {PSP} — {method} — started {time UTC}

Привет!
Наблюдаем деградацию:
- Start: {timestamp}
- Impact: approval {x}% → {y}%, timeouts +{n}%
- GEO/method: {geo}, {method}
- Samples: {correlation IDs / order IDs}

Подскажите, есть ли инцидент или изменения на вашей стороне? 
Нужны: текущий статус, ETA, рекомендации, и лог/trace по указанным ID.

## B) Запрос по declines
Тема: Increase in issuer declines — request for breakdown

Привет!
Выросли declines по коду {code} с {x}% до {y}% начиная с {time}.
Можно ли дать breakdown по банкам/issuer и возможные причины? 
Есть ли рекомендации по 3DS/risk настройкам?
EOF

cat > "$BASE_DIR/Quick/checklists/incident-triage-checklist.md" <<'EOF'
# Incident triage checklist (коротко)

- [ ] Зафиксировать время начала
- [ ] Определить scope: PSP / method / GEO
- [ ] Снять 3 метрики: approval, timeouts/latency, top decline codes
- [ ] Проверить последние изменения (routing/risk/release)
- [ ] Проверить webhooks delivery + duplicates
- [ ] Принять mitigation: fallback / disable / rollback
- [ ] Оповестить внутренние команды (следующее обновление через 30 мин)
- [ ] Написать PSP с примерами (IDs + timestamps)
- [ ] После стабилизации — короткий postmortem
EOF

cat > "$BASE_DIR/Quick/interview/02-top-questions-answers.md" <<'EOF'
# Top questions (HR + hiring) — ответы по структуре

## 1) Что делаете, если упал approval rate?
- Scope: где/когда/насколько
- Сегментация: PSP/method/GEO/bank
- Проверки: top decline codes, timeouts, 3DS, изменения, логи
- Mitigation: fallback PSP / routing weights / disable method
- Коммуникация: внутренние + PSP (IDs, timestamps)
- Postmortem: root cause + prevention

## 2) Как вы работаете с PSP ежедневно?
- weekly scorecard, регулярные sync calls
- escalation paths, SLA по ответам
- контроль изменений/лимитов/правил
- совместные RCA и action items

## 3) Как объясняете сложные штуки не-тех людям?
- 1 слайд: симптом → влияние на деньги → план действий → ETA → риски
- без терминов, но с цифрами

## 4) Пример инцидента из опыта (STAR)
S: ...
T: ...
A: triage → mitigation → comms → fix
R: метрика восстановлена, добавили мониторинг/алерты

(вставь 2–3 истории в `03-story-bank-STAR.md`)
EOF

cat > "$BASE_DIR/Quick/interview/03-story-bank-STAR.md" <<'EOF'
# Story bank (STAR) — заготовки

## Story 1 — integration instability / outages
S:
T:
A:
R: (цифры/скорость восстановления/что улучшили)

## Story 2 — declines/approval optimization
S:
T:
A:
R:

## Story 3 — async/webhooks/idempotency issue
S:
T:
A:
R:
EOF

echo "✅ Quick + DeepDive created and Quick filled with content."
echo "Next: commit & push these files to GitHub."
