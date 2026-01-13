# Email Deliverability — Domain Warm-up Configuration

## Context
- Stage: **Soft / Gentle Warm-up**
- Streams: **Promo / Retention / Technical**
- Architecture: **separate subdomains per stream**
- ESP: `esp.com`
- Goal: build sender reputation with minimal risk

---

## 🟥 Promo — `promo.example.com`
*Mass campaigns, highest risk stream*

### SPF

| Parameter | Value |
|--------|-------|
| DNS name | `promo.example.com` |
| TXT Value | `v=spf1 include:esp.com ~all` |

---

### DKIM

| Parameter | Value |
|--------|-------|
| Selector | `s1` |
| DNS name | `s1._domainkey.promo.example.com` |
| TXT Value | `v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A...` |
| DKIM-Signature (email header) | `d=promo.example.com; s=s1;` |

---

### DMARC

| Parameter | Value |
|--------|-------|
| DNS name | `_dmarc.promo.example.com` |
| TXT Value | `v=DMARC1; p=none; rua=mailto:dmarc@example.com;` |

---

## 🟩 Retention — `life.example.com`
*Triggers, winback, higher engagement audience*

### SPF

| Parameter | Value |
|--------|-------|
| DNS name | `life.example.com` |
| TXT Value | `v=spf1 include:esp.com ~all` |

---

### DKIM

| Parameter | Value |
|--------|-------|
| Selector | `s1` |
| DNS name | `s1._domainkey.life.example.com` |
| TXT Value | `v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A...` |
| DKIM-Signature (email header) | `d=life.example.com; s=s1;` |

---

### DMARC

| Parameter | Value |
|--------|-------|
| DNS name | `_dmarc.life.example.com` |
| TXT Value | `v=DMARC1; p=none; rua=mailto:dmarc@example.com;` |

---

## 🟦 Technical — `tx.example.com`
*System & transactional emails, cleanest stream*

### SPF

| Parameter | Value |
|--------|-------|
| DNS name | `tx.example.com` |
| TXT Value | `v=spf1 include:esp.com ~all` |

---

### DKIM

| Parameter | Value |
|--------|-------|
| Selector | `s1` |
| DNS name | `s1._domainkey.tx.example.com` |
| TXT Value | `v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A...` |
| DKIM-Signature (email header) | `d=tx.example.com; s=s1;` |

---

### DMARC

| Parameter | Value |
|--------|-------|
| DNS name | `_dmarc.tx.example.com` |
| TXT Value | `v=DMARC1; p=none; rua=mailto:dmarc@example.com;` |

---

## Notes & Rationale

- Each stream uses a **dedicated subdomain** to isolate reputation
- SPF uses `~all` to avoid hard blocking during warm-up
- DKIM is **mandatory** and aligned with `From` domain
- DMARC is configured in **monitoring-only mode (`p=none`)**
- DMARC is defined **per subdomain**, not centrally

> This setup allows independent warm-up, clean diagnostics via RUA reports,
> and safe transition to stricter policies after stabilization.
