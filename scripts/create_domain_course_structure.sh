#!/usr/bin/env bash
set -euo pipefail

# === CONFIG ===
# Option A: run from repo root and set relative path:
TARGET_DIR="Domain"

# Option B: or pass a custom path as first arg:
# ./create_domain_course_structure.sh /full/path/to/PSP-Operations/Domain
if [[ "${1:-}" != "" ]]; then
  TARGET_DIR="$1"
fi

# === STRUCTURE ===
DIRS=(
  "$TARGET_DIR/day-1/cases"
  "$TARGET_DIR/day-2/cases"
  "$TARGET_DIR/checklists"
)

FILES=(
  "$TARGET_DIR/README.md"

  "$TARGET_DIR/day-1/01-domain-strategy-and-creation.md"
  "$TARGET_DIR/day-1/02-email-infrastructure-and-dns.md"
  "$TARGET_DIR/day-1/03-domain-warming.md"
  "$TARGET_DIR/day-1/cases/case-1-domain-setup-mistakes.md"
  "$TARGET_DIR/day-1/cases/case-2-warmup-failure.md"

  "$TARGET_DIR/day-2/04-metrics-and-monitoring.md"
  "$TARGET_DIR/day-2/05-incident-and-reputation-control.md"
  "$TARGET_DIR/day-2/06-retention-and-sending-strategy.md"
  "$TARGET_DIR/day-2/cases/case-3-metrics-degradation.md"
  "$TARGET_DIR/day-2/cases/case-4-igaming-recovery.md"

  "$TARGET_DIR/checklists/domain-creation-checklist.md"
  "$TARGET_DIR/checklists/dns-auth-checklist.md"
  "$TARGET_DIR/checklists/daily-monitoring-checklist.md"
  "$TARGET_DIR/checklists/incident-response.md"
)

echo "Creating structure in: $TARGET_DIR"

# Create directories
for d in "${DIRS[@]}"; do
  mkdir -p "$d"
done

# Create files (do not overwrite existing)
for f in "${FILES[@]}"; do
  if [[ -e "$f" ]]; then
    echo "SKIP (exists): $f"
  else
    mkdir -p "$(dirname "$f")"
    touch "$f"
    echo "CREATE: $f"
  fi
done

# Seed README if empty
README="$TARGET_DIR/README.md"
if [[ ! -s "$README" ]]; then
  cat > "$README" <<'EOF'
# Email Deliverability / Domain Warming – 2-Day практикум (iGaming)

## Structure
- `day-1/` — Domain strategy, domain creation, DNS/auth, инфраструктура, warming
- `day-2/` — Метрики, мониторинг, инциденты, recovery, связь с retention
- `checklists/` — Ежедневные чек-листы и runbooks
- `cases/` — Реальные кейсы и разборы

## How to use
1. Проходи модули по порядку
2. После каждого модуля заполняй артефакт/шаблон
3. Кейсы — как практику “на собесе/в работе”
EOF
  echo "SEED: $README"
else
  echo "README not empty — left as is."
fi

echo "Done."
