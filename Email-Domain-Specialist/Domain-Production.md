# Email Deliverability — Production Domain Configuration 

## Context
- Stage: **Production / Fully Warmed Domains**
- Streams: **Promo / Retention / Technical**
- Architecture: **separate subdomains per stream**
- ESP: `esp.com`
- Goal: maximum deliverability, brand protection, stable reputation

---

## 🟥 Promo — `promo.example.com`
*Mass campaigns, highest risk stream*

### SPF

| Parameter | Value |
|--------|-------|
| DNS name | `promo.example.com` |
| TXT Value | `v=spf1 include:esp.com -all` |

---

### DKIM

| Parameter | Value |
|--------|-------|
| Selector | `s2` |
| DNS name | `s2._domainkey.promo.example.com` |
| TXT Value | `v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A...` |
| DKIM-Signature (email header) | `d=promo.example.com; s=s2;` |

> ℹ️ Старый selector (`s1`) может быть оставлен временно для rollback

---

### DMARC

| Parameter | Value |
|--------|-------|
| DNS name | `_dmarc.promo.example.com` |
| TXT Value | `v=DMARC1; p=quarantine; pct=100; rua=mailto:dmarc@example.com;` |

---

## 🟩 Retention — `life.example.com`
*Triggers, winback, highly engaged users*

### SPF

| Parameter | Value |
|--------|-------|
| DNS name | `life.example.com` |
| TXT Value | `v=spf1 include:esp.com -all` |

---

### DKIM

| Parameter | Value |
|--------|-------|
| Selector | `s2` |
| DNS name | `s2._domainkey.life.example.com` |
| TXT Value | `v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A...` |
| DKIM-Signature (email header) | `d=life.example.com; s=s2;` |

---

### DMARC

| Parameter | Value |
|--------|-------|
| DNS name | `_dmarc.life.example.com` |
| TXT Value | `v=DMARC1; p=reject; rua=mailto:dmarc@example.com;` |

---

## 🟦 Technical — `tx.example.com`
*System & transactional emails, cleanest and most trusted stream*

### SPF

| Parameter | Value |
|--------|-------|
| DNS name | `tx.example.com` |
| TXT Value | `v=spf1 include:esp.com -all` |

---

### DKIM

| Parameter | Value |
|--------|-------|
| Selector | `s2` |
| DNS name | `s2._domainkey.tx.example.com` |
| TXT Value | `v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A...` |
| DKIM-Signature (email header) | `d=tx.example.com; s=s2;` |

---

### DMARC

| Parameter | Value |
|--------|-------|
| DNS name | `_dmarc.tx.example.com` |
| TXT Value | `v=DMARC1; p=reject; rua=mailto:dmarc@example.com;` |

---

## Key Production Principles

- SPF uses `-all` — **only known sources allowed**
- DKIM uses a **new selector (`s2`)** after warm-up
- DKIM alignment with `From` is mandatory
- DMARC enforcement varies by stream:
  - **Promo** → `quarantine`
  - **Retention** → `reject`
  - **Technical** → `reject`
- DMARC is configured **per subdomain** for full control

---

## Transition Notes (Warm-up → Production)

- Replace SPF `~all` → `-all`
- Introduce new DKIM selector (`s2`)
- Keep old selector temporarily for safety
- Gradually increase DMARC strictness:
  - `none` → `quarantine` → `reject`
- Continuously monitor RUA reports

> This configuration represents a mature, production-grade
> email deliverability setup suitable for high-volume iGaming platforms.
