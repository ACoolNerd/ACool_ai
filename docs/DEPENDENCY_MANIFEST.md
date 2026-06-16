# ACoolECOSYSTEM — Dependency Manifest

**Generated:** 2026-06-16 · **Status:** v1.0.0-beta.1
**Governance:** Rights → Disclosure → Proof

This is a factual inventory, not a sales sheet. Gaps are listed as gaps.

---

## 1. Infrastructure (Docker images)

| Image | Used by | Pinned? |
|---|---|---|
| `node:20-alpine` | All 9 custom services/apps/workers (build stage) | ✅ major+minor pinned |
| `postgres:16-alpine` | Database | ✅ major pinned |
| `redis:7-alpine` | Cache/queue | ✅ major pinned |
| `minio/minio:latest` | S3-compatible object storage | ❌ `latest` — **risk: unpinned** |
| `minio/mc:latest` | Bucket bootstrap (`acool-create-buckets`) | ❌ `latest` — **risk: unpinned** |
| `nginx:1.27-alpine` | Reverse proxy / Host-header routing | ✅ pinned |
| `grafana/grafana:latest` | Monitoring dashboard | ❌ `latest` — **risk: unpinned** |
| `prom/prometheus:latest` | Metrics | ❌ `latest` — **risk: unpinned** |

**Recommendation before production cutover:** pin the four `:latest` images to
specific digests or version tags. An unannounced upstream change to any of these
can break a production deploy with no warning — this is the single highest-leverage
hardening step left on the infra side.

## 2. Application dependencies (npm)

### Root app (`/`) — React/Vite frontend
| Package | Version | Audit status |
|---|---|---|
| react, react-dom | ^19.2.5 | clean |
| react-router-dom | ^7.14.2 | **was 2 high-severity (DoS, CSRF) — fixed via `npm audit fix` this session, now 0** |
| chokidar | ^5.0.0 | clean |
| vite, eslint, @vitejs/plugin-react, etc. (dev) | — | clean |

### `services/acool-ecosystem-api`
express, pg, redis, dotenv, cors, helmet, morgan, uuid, axios — **no `package-lock.json` committed, not yet audited**

### `services/acool-router`
express, http-proxy, dotenv, cors, morgan — **no lockfile, not yet audited**

### `services/acool-skills-api`
express, dotenv, cors, morgan — **no lockfile, not yet audited**

### `apps/acool-academy`, `apps/acool-project`, `apps/gardy-portal`, `apps/prompt-runtime`, `apps/skills-dashboard`
express, dotenv, cors, morgan (each) — **no lockfile, not yet audited**

### `workers/acool-worker`
redis, pg, dotenv — **no lockfile, not yet audited**

## 3. Known Gap — Lockfile Coverage

**9 of 10 package.json files in this repo have no committed `package-lock.json`.**
This means:

- `npm audit` cannot run against them without `npm install` first (which this session
  intentionally did not do unattended across 9 directories — installing without
  reviewing what gets pulled in is exactly the kind of supply-chain risk a lockfile
  exists to prevent)
- Builds are not fully reproducible — `npm install` inside each `Dockerfile` build
  stage can resolve different transitive versions on different days

**Remediation (do before board demo, low risk, no live-system impact):**
```bash
for d in services/*/ apps/*/ workers/*/; do (cd "$d" && npm install --package-lock-only); done
```
This generates lockfiles without installing `node_modules` into the repo. Not run in
this session — it's a build-time/CI concern, not a runtime production blocker, and is
better reviewed deliberately than run as a side effect of an unrelated task.

## 4. Dependency Scan Automation

[`scripts/routines/dependency-scan.sh`](../scripts/routines/dependency-scan.sh) runs
weekly (Sundays 09:00, local cron — see `crontab -l`) and explicitly reports the
lockfile gap above rather than silently skipping those directories.

## 5. External Service Dependencies (not npm/Docker, but real dependencies)

| Dependency | Used for | Status |
|---|---|---|
| Cloudflare (DNS + Tunnel) | Public routing for `acool.ai` subdomains | Not yet connected — see [VPS_BETA_DISPATCH_RUNBOOK.md](governance/VPS_BETA_DISPATCH_RUNBOOK.md) |
| GitHub (`ACoolNerd/ACool_ai`) | Source of truth, CI surface | Connected; 1 Dependabot finding existed pre-session (root react-router, now fixed in this branch) |
| MinIO (self-hosted) | Object storage, future backup destination | Running locally; off-host backup shipping not yet wired |

Made with LOVE by ACoolNERD with ACoolAI
