# 04. Payment Metrics: от цифр к управляемым решениям

## Цель главы

Эта глава объясняет, какие метрики реально важны в платежных операциях, как они рассчитываются,
что именно они показывают и как PSP Account Manager (Operations) использует их для принятия решений.

После прочтения ты должен:
- понимать ключевые платежные метрики и их формулы;
- различать leading и lagging indicators;
- видеть причинно-следственные связи между метриками;
- уметь объяснять деградации метрик через lifecycle платежа;
- использовать метрики как инструмент управления, а не отчётности.

---

## 1. Роль метрик в платежных операциях

Метрики в платежах нужны не для красивых дашбордов, а для ответов на вопросы:
1. Работают ли платежи стабильно?
2. Где мы теряем деньги?
3. Что делать прямо сейчас?

Метрика сама по себе не является проблемой. Проблемой является отклонение метрики от baseline.

---

## 2. Классификация платежных метрик

Все платежные метрики можно разделить на четыре группы:
1. Conversion & Revenue metrics
2. Approval & Decline metrics
3. Reliability & Performance metrics
4. Risk & Cost metrics

---

## 3. Approval Rate

### 3.1. Определение

Approval Rate — доля платежных попыток, завершившихся одобрением.

### 3.2. Формула

Approval Rate = Approved Transactions / Valid Payment Attempts

Где:
- Approved Transactions — платежи со статусом success / approved;
- Valid Payment Attempts — попытки, корректно дошедшие до PSP (без технических ошибок).

Частая ошибка — считать approval от всех кликов, включая failures.

### 3.3. Влияние

Approval Rate напрямую влияет на выручку, отражает качество routing и работу PSP.

---

## 4. Conversion Rate

Conversion Rate — доля пользователей, дошедших от выбора метода до успешного платежа.

Типовой funnel:
1. Open cashier
2. Select payment method
3. Redirect / SDK
4. 3DS / Authentication
5. Payment result

Conversion может падать даже при стабильном approval.

---

## 5. Decline Rate

Decline Rate = Declined Transactions / Valid Payment Attempts

Важно анализировать не только общий процент, но и распределение decline codes.

---

## 6. Failure Rate

Failure Rate = Technical Failures / All Payment Attempts

Рост failure rate — повод для немедленного triage.

---

## 7. Latency & Timeouts

Ключевые метрики:
- Average latency
- p95 / p99 latency
- Timeout rate

Рост p99 часто является ранним индикатором инцидента.

---

## 8. Payout Metrics

### 8.1. Payout Success Rate
Completed Payouts / Initiated Payouts

### 8.2. Time-to-Complete
Время от инициации payout до финального статуса.

### 8.3. Stuck Payout Rate
Доля payout'ов в pending дольше SLA.

---

## 9. Risk & Cost Metrics

- Chargeback Rate
- Fraud Rate
- PSP Fees & Cost per Transaction

Высокая конверсия при высоком cost может быть невыгодной.

---

## 10. Leading vs Lagging Indicators

Leading:
- latency p95/p99
- timeout rate
- pending growth

Lagging:
- approval rate
- revenue
- chargebacks

Зрелый Ops реагирует на leading indicators.

---

## 11. Типовой алгоритм работы с метриками

1. Детекция отклонения
2. Сегментация
3. Формирование гипотез
4. Проверка
5. Mitigation
6. Контроль эффекта

---

## 12. Key takeaways

- Метрики — язык Ops.
- Важна динамика, а не абсолют.
- Каждая метрика связана с lifecycle.
- Хороший Ops знает, что делать при изменении цифр.
