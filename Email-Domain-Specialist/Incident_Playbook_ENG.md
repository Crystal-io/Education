# Email Deliverability Incident Playbook   
## Subdomain Overheating (Reputation Degradation)

### Context
- Issue: subdomain reputation overheating
- Symptoms: spam foldering, open rate drop, deferrals, complaints
- Scope: Promo / Retention / Technical streams
- Goal: stabilize reputation without long-term damage

---

## 🔥 Priority Matrix — What to Adjust and When

| Priority | Area | What to Do First | Immediate Actions | What NOT to Do |
|--------|------|-----------------|------------------|---------------|
| **1** | **Volume & Velocity** | Reduce sending volume immediately | • Cut volume by **30–70%**<br>• Remove spikes, smooth hourly rate<br>• Pause **Promo** stream first | ❌ Do not keep volumes “to collect more data”<br>❌ Do not ramp further |
| **2** | **Audience / Segmentation** | Leave only engaged users | • Send only to users active in **last 7–30 days**<br>• Disable winback/reactivation<br>• Exclude cold lists | ❌ Do not send to full DB<br>❌ Do not “test” on cold users |
| **3** | **Content** | Simplify and neutralize | • Reduce links & images<br>• Avoid aggressive CTA<br>• Prefer light HTML / plain text | ❌ Do not change subject every hour<br>❌ Do not add urgency triggers |
| **4** | **Stream Isolation** | Protect clean streams | • Pause Promo before Retention<br>• Never touch Technical if clean<br>• Verify no cross-stream leakage | ❌ Do not mix streams on same domain<br>❌ Do not move promo to tx-domain |
| **5** | **DMARC Enforcement** | Temporarily soften policy if blocking | • `p=reject → quarantine`<br>• `quarantine → none`<br>• Or reduce `pct` | ❌ Do not enable strict alignment<br>❌ Do not rely on DMARC to “fix” reputation |
| **6** | **DKIM / SPF Health Check** | Verify nothing is broken | • Ensure DKIM = PASS<br>• Check selector still exists<br>• Verify alignment unchanged | ❌ Do not rotate keys mid-incident<br>❌ Do not edit SPF blindly |
| **7** | **DNS / Infrastructure** | Observe, don’t experiment | • Monitor only if auth fails<br>• Log analysis (4xx vs 5xx) | ❌ Do not add/remove ESPs<br>❌ Do not change DNS as a guess |

---

## Key Principles

- Reputation issues are caused by **behavior**, not DNS
- DNS (SPF/DKIM/DMARC) = **safety & control**, not acceleration
- Fast reaction = volume + audience, not configuration
- Promo stream is sacrificed first to save overall reputation

---

## Interview-Ready Summary

> “When a subdomain overheats, I immediately reduce volume and restrict the audience.  
> DNS and DMARC are control layers, not levers for recovery.  
> Reputation is restored only by correcting sending behavior.”

---

## Notes
- Always monitor:
  - ESP reputation alerts
  - Google Postmaster Tools
  - Spam complaints & deferrals
  - DMARC RUA reports
- Recovery usually takes **days**, not hours

