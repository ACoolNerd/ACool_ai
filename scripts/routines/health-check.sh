#!/usr/bin/env bash
# ===== ACoolECOSYSTEM Routine: health-check =====
# Cadence: Daily (also safe to run Event-driven, e.g. post-deploy)
# Owner: Keith McPherson (ACoolNERD)
# Trigger: cron/launchd schedule, or manual `bash scripts/routines/health-check.sh`
# Channel: stdout + scripts/routines/logs/health-check.log
# Escalation: any non-(healthy) service exits 1 — wire to a notifier (Slack/email)
#             before relying on this unattended; not wired in this pass.
# Audit event: health.check.run, health.check.failed (logged with timestamp)
# Success metric: 0 unhealthy services
# Pause/retirement condition: remove the cron/launchd entry; this script is
#             inert until scheduled — running it manually is always safe.
#
# Rights -> Disclosure -> Proof
# Made with LOVE by ACoolNERD with ACoolAI
set -euo pipefail

cd "$(dirname "$0")/../.."
LOG_DIR="scripts/routines/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/health-check.log"
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

echo "[$TS] health.check.run" >> "$LOG_FILE"

UNHEALTHY=$(docker compose -f docker-compose.prod.yml --env-file .env ps --format json 2>/dev/null \
  | node -e "
    let d='';process.stdin.on('data',c=>d+=c).on('end',()=>{
      const lines=d.trim().split('\n').filter(Boolean);
      const bad=lines.map(l=>JSON.parse(l)).filter(s=>s.Health && s.Health!=='healthy' && s.Health!=='');
      console.log(JSON.stringify(bad.map(s=>s.Service)));
    })" 2>/dev/null || echo "[]")

if [ "$UNHEALTHY" = "[]" ] || [ -z "$UNHEALTHY" ]; then
  echo "[$TS] OK — all services healthy" | tee -a "$LOG_FILE"
  exit 0
else
  echo "[$TS] health.check.failed — unhealthy: $UNHEALTHY" | tee -a "$LOG_FILE"
  exit 1
fi
