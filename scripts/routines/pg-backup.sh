#!/usr/bin/env bash
# ===== ACoolECOSYSTEM Routine: pg-backup =====
# Cadence: Daily
# Owner: Keith McPherson (ACoolNERD)
# Trigger: cron/launchd schedule, or manual `bash scripts/routines/pg-backup.sh`
# Channel: stdout + scripts/routines/logs/pg-backup.log
# Escalation: non-zero exit — wire to a notifier before relying on this unattended.
# Audit event: backup.create
# Success metric: a new, non-empty dump file appears in backups/ each run
# Pause/retirement condition: remove the cron/launchd entry.
#
# This writes to a LOCAL backups/ directory (gitignored). Shipping these to
# MinIO/S3 off-host storage is a remaining production step — see
# docs/governance/ACoolDATABASE_MANIFEST.md §6. A local-only backup does not
# protect against host loss; treat this as the first rung, not the whole ladder.
#
# Rights -> Disclosure -> Proof
# Made with LOVE by ACoolNERD with ACoolAI
set -euo pipefail

cd "$(dirname "$0")/../.."
[ -f .env ] && set -a && source .env && set +a

LOG_DIR="scripts/routines/logs"
mkdir -p "$LOG_DIR" backups
LOG_FILE="$LOG_DIR/pg-backup.log"
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
OUT="backups/acool-postgres-${TS//[:]/-}.sql.gz"

echo "[$TS] backup.create.start" >> "$LOG_FILE"

docker exec acool-postgres pg_dump -U "${POSTGRES_USER:-acool}" -d "${POSTGRES_DB:-acool}" \
  | gzip > "$OUT"

if [ -s "$OUT" ]; then
  echo "[$TS] backup.create — wrote $OUT ($(du -h "$OUT" | cut -f1))" | tee -a "$LOG_FILE"
  exit 0
else
  echo "[$TS] backup.create.FAILED — $OUT is empty or missing" | tee -a "$LOG_FILE"
  rm -f "$OUT"
  exit 1
fi
