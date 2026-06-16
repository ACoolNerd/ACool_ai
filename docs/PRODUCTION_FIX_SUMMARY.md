# ACoolECOSYSTEM Production Fix Summary

## What Was Broken

The Docker-first production stack built, but the application tier could not stabilize because `acool-ecosystem-api` depended on a database schema that failed during Postgres initialization. Several Node services also had compose healthchecks that called `curl` even though the service images are based on `node:20-alpine`, where `curl` is not guaranteed.

## Root Cause

`database/001_talent_schema.sql` created `talents` before `agencies`, while `talents.agency_id` declared `REFERENCES agencies(id)`. Postgres stopped the init sequence with `relation "agencies" does not exist`.

The production Nginx config also needed local HTTP Host-header routes for validation and referenced certificate filenames that did not match the checked-in `nginx/ssl/cert.pem` and `nginx/ssl/key.pem` files.

## Files Changed

- `database/000_preflight_dependencies.sql`
- `database/migrations/000_preflight_dependencies.sql`
- `docker-compose.prod.yml`
- `nginx/conf.d/prod.conf`
- `services/acool-ecosystem-api/Dockerfile`
- `services/acool-ecosystem-api/src/index.js`
- `services/acool-router/Dockerfile`
- `services/acool-router/src/index.js`
- `services/acool-skills-api/Dockerfile`
- `services/acool-skills-api/src/index.js`
- `apps/acool-project/Dockerfile`
- `apps/acool-project/src/index.js`
- `apps/acool-academy/Dockerfile`
- `apps/acool-academy/src/index.js`
- `apps/gardy-portal/Dockerfile`
- `apps/gardy-portal/src/index.js`
- `apps/prompt-runtime/Dockerfile`
- `apps/prompt-runtime/src/index.js`
- `apps/skills-dashboard/Dockerfile`
- `apps/skills-dashboard/src/index.js`
- `scripts/prod-smoke-test.sh`
- `scripts/acool-prod-local-reset.sh`
- `docs/PRODUCTION_FIX_SUMMARY.md`

## Commands To Run

```bash
cd ~/acool-docker-universal-v5
docker compose -f docker-compose.prod.yml --env-file .env config > /tmp/acool-prod-compose.validated.yml
docker compose -f docker-compose.prod.yml --env-file .env down -v --remove-orphans
docker compose -f docker-compose.prod.yml --env-file .env up -d --build --remove-orphans
sleep 120
docker compose -f docker-compose.prod.yml --env-file .env ps
bash scripts/prod-smoke-test.sh
```

For a scoped local reset:

```bash
bash scripts/acool-prod-local-reset.sh
```

## Healthcheck Strategy

Node services use Node-based HTTP healthchecks against `/health`, avoiding `curl` in `node:20-alpine` containers. Timing is standardized at `interval: 30s`, `timeout: 10s`, `retries: 8`, and `start_period: 45s`.

Nginx uses `wget` against `http://127.0.0.1/` so its healthcheck does not fail on IPv6 `localhost` resolution inside the Alpine container.

Each service returns governed health JSON:

```json
{
  "ok": true,
  "service": "<service name>",
  "mode": "production",
  "governance": "Rights → Disclosure → Proof",
  "timestamp": "<ISO timestamp>"
}
```

## Database Migration Strategy

`database/migrations/000_preflight_dependencies.sql` is the canonical preflight dependency migration. It safely creates and repairs the parent `agencies` table before `database/001_talent_schema.sql` creates child tables with foreign keys.

Because the official Postgres image only executes root-level files in `/docker-entrypoint-initdb.d`, `database/000_preflight_dependencies.sql` loads the canonical migration with `\i /docker-entrypoint-initdb.d/migrations/000_preflight_dependencies.sql`.

No table drops, broad truncations, or unrelated Docker volume removals are part of this fix.

## Validation Results

Validated locally on June 16, 2026 with:

```bash
docker compose -f docker-compose.prod.yml --env-file .env config > /tmp/acool-prod-compose.validated.yml
docker compose -f docker-compose.prod.yml --env-file .env down -v --remove-orphans
docker compose -f docker-compose.prod.yml --env-file .env up -d --build --remove-orphans
bash scripts/prod-smoke-test.sh
```

Final `docker compose ps` showed Postgres, Redis, MinIO, ACoolECOSYSTEM API, ACool Router, Skills API, Skills Dashboard, ACoolPROJECT, ACoolACADEMY, Gardy Portal, Prompt Runtime, and Nginx healthy. The smoke script returned HTTP 200 for all required Host-header routes, including `api.acool.ai /health`, `api.acool.ai /api/v1/info`, `dashboard.acool.ai /health`, `skills.acool.ai /health`, `academy.acool.ai /health`, `fashion.acool.ai /health`, `cityhall.acool.ai /health`, and `acoolnerd.acool.ai /`.

## Addendum (2026-06-16, second pass): Cold-Start MinIO Fix

Re-running the full `down -v --remove-orphans` → `up -d --build` cycle against a
**truly empty volume** (not the warm one from the first pass) surfaced a real,
previously-undetected bug: `acool-minio` formats its drive on first boot, which can
take longer than its healthcheck's first probe window. Because the `minio`
healthcheck had no `start_period`, Postgres/Redis/the API briefly failed their
`depends_on: condition: service_healthy` wait with `dependency minio failed to start`.

**Fix:** added `start_period: 45s` to the `minio` healthcheck in
`docker-compose.prod.yml`, matching the same field already used on the Node services.
Re-ran the cold cycle twice after the fix — both times every service reached
`(healthy)` with no dependency errors, and the smoke test passed 9/9.

This is the kind of failure that only shows up on a genuinely cold volume; the first
validation pass (above) ran against containers that already had initialized volumes,
which is why it didn't catch this.

## Addendum (2026-06-16): Secret Hygiene Fix

`.gitignore` did not exclude `.env*` files, which meant `.env`, `.env.prod`, and
timestamped `.env.*.backup.*` files were untracked-but-stageable. Fixed before any
`git add`:

- Added `.env`, `.env.*` (with `!.env.example` carve-out), `*.pem`, `*.key`, and
  `secrets/` to `.gitignore`
- Added `docker-compose.prod.yml.backup.*` and the `/tmp` validated-config artifact
  to `.gitignore` (build-time scratch files, not source)
- Generated `.env.example` from `.env.prod` with all values replaced by `CHANGE_ME` —
  safe to commit, documents every required variable name with no real values

## Governance Additions (2026-06-16)

Two new governed components were registered under `docs/governance/`:

- [`ACoolDATABASE_MANIFEST.md`](governance/ACoolDATABASE_MANIFEST.md) — RBAC roles,
  audit events, and migration-ordering rules for the Postgres data layer
- [`ACoolSCHEMA_REGISTRY.md`](governance/ACoolSCHEMA_REGISTRY.md) — the canonical
  7-field object model ([`schema/acool.schema.json`](../schema/acool.schema.json))
  and an **honest compliance gap report**: the existing `talents`/`agencies`/etc.
  tables predate this rule and are not yet conformant. A non-destructive remediation
  path is documented but intentionally not executed without explicit approval, since
  it touches live table DDL.

`ACoolOSINT` was checked and confirmed to live entirely in the separate `~/ACoolai`
repository (`ACoolKnowledgeBase/09_ACoolOSINT`) — it is correctly firewalled and
nothing from it was imported into this stack.

## Remaining Production Steps

1. ~~Push repo~~ — done this pass, see commit/PR below
2. Provision Ubuntu VPS
3. Copy `.env` securely
4. Run docker compose prod
5. Connect Cloudflare Tunnel
6. Point real `acool.ai` subdomains
7. Address the ACoolSCHEMA compliance gap (§ACoolSCHEMA_REGISTRY.md) before onboarding
   real talent/agency data, with explicit operator approval for any DDL change
8. Automate Postgres backups to MinIO/S3 (see ACoolDATABASE_MANIFEST.md §6) before
   go-live

## Governance

Rights → Disclosure → Proof

Made with LOVE by ACoolNERD with ACoolAI
