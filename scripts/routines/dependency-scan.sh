#!/usr/bin/env bash
# ===== ACoolECOSYSTEM Routine: dependency-scan =====
# Cadence: Weekly
# Owner: Keith McPherson (ACoolNERD)
# Trigger: cron/launchd schedule, or manual `bash scripts/routines/dependency-scan.sh`
# Channel: stdout + scripts/routines/logs/dependency-scan.log
# Escalation: any "high" or "critical" finding exits 1 — wire to a notifier
#             before relying on this unattended; not wired in this pass.
# Audit event: dependency.scan.run, dependency.scan.findings
# Success metric: 0 high/critical vulnerabilities across all package.json dirs
# Pause/retirement condition: remove the cron/launchd entry.
#
# KNOWN GAP (documented, not silently worked around): the 9 backend
# services/apps/workers under services/, apps/, workers/ do not have
# committed package-lock.json files, so `npm audit` cannot run against them
# without `npm install` first. This script audits the root app (which does
# have a lockfile) and explicitly reports the gap for the rest rather than
# claiming a false "all clear."
#
# Rights -> Disclosure -> Proof
# Made with LOVE by ACoolNERD with ACoolAI
set -uo pipefail

cd "$(dirname "$0")/../.."
LOG_DIR="scripts/routines/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/dependency-scan.log"
TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
FAIL=0

echo "[$TS] dependency.scan.run" >> "$LOG_FILE"

echo "=== root app (has package-lock.json) ===" | tee -a "$LOG_FILE"
if npm audit --omit=dev 2>&1 | tee -a "$LOG_FILE" | grep -qE "high severity|critical severity"; then
  FAIL=1
fi

echo "" | tee -a "$LOG_FILE"
echo "=== backend services/apps/workers (lockfile gap) ===" | tee -a "$LOG_FILE"
for d in services/*/ apps/*/ workers/*/; do
  if [ -f "$d/package.json" ] && [ ! -f "$d/package-lock.json" ]; then
    echo "  GAP: $d has package.json but no package-lock.json — npm audit cannot run without npm install" | tee -a "$LOG_FILE"
  elif [ -f "$d/package-lock.json" ]; then
    echo "  --- $d ---" | tee -a "$LOG_FILE"
    (cd "$d" && npm audit --omit=dev 2>&1 | tail -5) | tee -a "$LOG_FILE"
  fi
done

if [ "$FAIL" = "1" ]; then
  echo "[$TS] dependency.scan.findings — high/critical found in root app" | tee -a "$LOG_FILE"
  exit 1
fi
echo "[$TS] dependency.scan.findings — root app clean; lockfile gap remains open" | tee -a "$LOG_FILE"
exit 0
