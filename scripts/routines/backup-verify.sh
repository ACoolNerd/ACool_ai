#!/usr/bin/env bash
# ===== ACoolECOSYSTEM Routine: backup-verify =====
# Cadence: Daily (run after pg-backup.sh)
# Owner: Keith McPherson (ACoolNERD)
# Trigger: cron/launchd schedule, chained after pg-backup.sh
# Channel: stdout + scripts/routines/logs/backup-verify.log
# Escalation: missing/stale/corrupt backup exits 1 — wire to a notifier before
#             relying on this unattended.
# Audit event: backup.verify
# Success metric: latest backups/*.sql.gz is <26h old, non-empty, and
#             gzip-integrity-checks clean
# Pause/retirement condition: remove the cron/launchd entry.
#
# Rights -> Disclosure -> Proof
# Made with LOVE by ACoolNERD with ACoolAI
set -uo pipefail

cd "$(dirname "$0")/../.."
LOG_DIR="scripts/routines/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/backup-verify.log"
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

LATEST=$(ls -t backups/*.sql.gz 2>/dev/null | head -1)

if [ -z "$LATEST" ]; then
  echo "[$TS] backup.verify.FAILED — no backup files found in backups/" | tee -a "$LOG_FILE"
  exit 1
fi

AGE_HOURS=$(( ( $(date +%s) - $(stat -f %m "$LATEST" 2>/dev/null || stat -c %Y "$LATEST") ) / 3600 ))

if [ ! -s "$LATEST" ]; then
  echo "[$TS] backup.verify.FAILED — $LATEST is empty" | tee -a "$LOG_FILE"
  exit 1
fi

if ! gzip -t "$LATEST" 2>/dev/null; then
  echo "[$TS] backup.verify.FAILED — $LATEST failed gzip integrity check" | tee -a "$LOG_FILE"
  exit 1
fi

if [ "$AGE_HOURS" -gt 26 ]; then
  echo "[$TS] backup.verify.FAILED — newest backup $LATEST is ${AGE_HOURS}h old (>26h)" | tee -a "$LOG_FILE"
  exit 1
fi

echo "[$TS] backup.verify.OK — $LATEST is ${AGE_HOURS}h old, integrity OK" | tee -a "$LOG_FILE"
exit 0
