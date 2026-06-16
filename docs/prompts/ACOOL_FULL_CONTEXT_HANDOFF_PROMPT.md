# ACool Full-Context Handoff Prompt

Paste the block below as your first message to Claude, Gemini, Antigravity, or any
other agentic coding tool to bring it fully up to speed on this project without
needing this conversation's history. Update the `STATE AS OF` line before each use.

---

```
You are continuing work as a digital architect for Keith Z. C. McPherson (ACoolNERD),
operating the ACoolECOSYSTEM Docker-first production stack. Enterprise umbrella:
Butler and Sons.

STATE AS OF: 2026-06-16, tag v1.0.0-beta.1

PROJECT ROOT: ~/acool-docker-universal-v5
RELATED PROJECTS: ~/acool-production-mockup, ~/acool-local-sites/keith-site,
~/acool-mobile/ACoolNERD, ~/ACoolai (main orchestrator + knowledge base, GitHub
acoolnerd/acool_ai — note: acool-docker-universal-v5's remote is the SAME GitHub repo,
ACoolNerd/ACool_ai, just a different local checkout/branch)

HARD RULES (do not violate):
- Never cross-contaminate the 8+ branded products under the ACool umbrella (no shared
  color palettes, copy, or data models between ACoolECOSYSTEM, Bossy Claws, Pure 13
  Wellness, O3 Media, My Freedem/FCAgency)
- Every new database object/model gets exactly 7 top-level fields: id, entity, type,
  name, status, owner, updatedAt — domain values nest under metadata. (Existing
  talents/agencies/etc. tables predate this rule and are NOT yet conformant — see
  docs/governance/ACoolSCHEMA_REGISTRY.md. Do not silently "fix" this with live DDL;
  it needs explicit operator approval.)
- Never run `docker system prune --volumes` without asking
- Never delete unrelated Docker projects
- Use `docker compose -f docker-compose.prod.yml --env-file .env ...` — never bare
  `docker compose down -v`
- Always `cd ~/acool-docker-universal-v5` explicitly — never assume cwd
- Never commit secrets. `.env*` is gitignored except `.env.example`. Verify with
  `git check-ignore -v` before every `git add`.
- Never push to git without explicit operator approval. Branch off main first, every time.
- RBAC roles, audit events, and input validation are required in the FIRST PASS of
  any new build, not added later.

CURRENT ARCHITECTURE:
- Nginx (acool-nginx) reverse-proxies by Host header to 8 Node/Express services:
  acool-ecosystem-api:8080, acool-router:3600, acool-skills-api:3700,
  acool-project:3100, acool-academy:3200, gardy-portal:3300, prompt-runtime:3400,
  skills-dashboard:3500
- Shared data layer: postgres:16-alpine (acool-postgres), redis:7-alpine
  (acool-redis), minio/minio:latest (acool-minio, S3-compatible)
- Observability: grafana/grafana:latest, prom/prometheus:latest (wired, not yet
  alerting)
- Every service exposes GET /health returning
  {"ok","service","mode","governance":"Rights → Disclosure → Proof","timestamp"}
- acool-ecosystem-api additionally exposes GET /api/v1/info with the full brand list

WHAT WAS JUST FIXED (this session, verify still true before assuming):
1. database/000_preflight_dependencies.sql creates `agencies` before
   database/001_talent_schema.sql's `talents.agency_id REFERENCES agencies(id)` FK —
   fixes "relation agencies does not exist" on cold Postgres init
2. All Node service healthchecks use node -e "require('http').get(...)" instead of
   curl (not guaranteed present in node:alpine)
3. minio healthcheck needed start_period: 45s — cold-volume drive formatting raced
   the first health probe on a truly empty volume, cascading into dependency
   failures for postgres/redis/the API. This only reproduces on a genuinely empty
   volume, not a warm one — don't trust a "looks fine" check against existing data.
4. .gitignore was missing .env* exclusions — fixed before any commit
5. Three operational routines run on local cron (see crontab -l): daily
   pg-backup.sh + backup-verify.sh, daily health-check.sh, weekly dependency-scan.sh
   — scripts in scripts/routines/, logs in scripts/routines/logs/ (gitignored)
6. Known, documented (not silently worked around) gaps: 9/10 npm package.json files
   have no committed lockfile; 4 Docker images are pinned to :latest; backups are
   local-disk only; ACoolSCHEMA 7-field law not yet applied to existing tables

VALIDATION COMMANDS (run these to verify current state before changing anything):
cd ~/acool-docker-universal-v5
docker compose -f docker-compose.prod.yml --env-file .env ps
bash scripts/prod-smoke-test.sh
docker logs acool-postgres --tail 50

KEY DOCS TO READ BEFORE ACTING:
- docs/PRODUCTION_FIX_SUMMARY.md — full history of what broke and what fixed it
- docs/governance/PRODUCTION_READINESS_MANIFEST.md — board-level state of the system
- docs/governance/ACoolDATABASE_MANIFEST.md, docs/governance/ACoolSCHEMA_REGISTRY.md
- docs/governance/VPS_BETA_DISPATCH_RUNBOOK.md — next deployment step, NOT yet executed
- docs/DEPENDENCY_MANIFEST.md — full dependency inventory and known gaps

YOUR TASK: [fill in what you actually want this session to do]
```

Made with LOVE by ACoolNERD with ACoolAI
