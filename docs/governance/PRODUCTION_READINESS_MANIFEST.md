# ACoolECOSYSTEM — Production Readiness Manifest
### Board / Advisor / Investor Briefing — v1.0.0-beta.1

**Operator:** Keith Z. C. McPherson (ACoolNERD), HNIC
**Enterprise umbrella:** Butler and Sons
**Date:** 2026-06-16
**Governance Principle:** Rights → Disclosure → Proof

---

## 1. What this is

ACoolECOSYSTEM is a Docker-first, multi-service production stack hosting eight
distinct branded products (ACoolPROJECT, ACoolACADEMY, Gardy Portal, Prompt Runtime,
Skills Dashboard, ACool Router, ACool Skills API, plus the ACoolECOSYSTEM API itself)
behind a single Nginx reverse proxy, on a governed Postgres/Redis/MinIO data layer.

It is currently tagged **`v1.0.0-beta.1`** — validated end-to-end on a clean,
from-scratch local environment, not yet on public infrastructure.

## 2. What's actually proven (not claimed — proven, this session)

| Capability | Evidence |
|---|---|
| Stack survives a full cold start | Two consecutive `down -v --remove-orphans` → `up -d --build` cycles against an empty volume, zero errors |
| Database schema integrity | `agencies`/`talents` FK dependency ordering fixed and verified via `\dt` + zero Postgres log errors |
| All 12 containers report healthy | `docker compose ps` — Postgres, Redis, MinIO, 8 app services, Nginx |
| Public-facing routing works | 9/9 Host-header routes return `200 OK` via [`scripts/prod-smoke-test.sh`](../../scripts/prod-smoke-test.sh) |
| No secrets in version control | `.gitignore` hardened, `.env.example` sanitized, verified with `git check-ignore -v` before every commit |
| Known frontend vulnerability fixed | 2 high-severity react-router CVEs → 0, via `npm audit fix` |
| Automated operational routines running | Health check (daily), dependency scan (weekly), Postgres backup + verification (daily) — all real cron jobs, not slideware |

## 3. What's explicitly NOT yet true (said plainly, because a board finds out anyway)

| Gap | Why it matters | Path to close |
|---|---|---|
| Not deployed to any public server | Currently local-Mac-only | [VPS_BETA_DISPATCH_RUNBOOK.md](VPS_BETA_DISPATCH_RUNBOOK.md) — needs a provisioned VPS + Cloudflare account |
| ~~9 of 10 npm packages have no lockfile~~ — **closed** | Lockfiles generated and committed for all 9 backend services; 0 vulnerabilities across all 10 `package.json` files | [DEPENDENCY_MANIFEST.md](../DEPENDENCY_MANIFEST.md) §3 |
| 4 Docker images pinned to `:latest` | An upstream change can break prod with zero warning | [DEPENDENCY_MANIFEST.md](../DEPENDENCY_MANIFEST.md) §1 |
| 4 of 9 tables use a non-`name` label column | `content`/`calendar_events`/`raci_matrix`/`workforce` use `title`/`task_name`/`project_name`; `entity`/`owner`/`type`/`status` are now present on all 9 tables | [ACoolSCHEMA_REGISTRY.md](ACoolSCHEMA_REGISTRY.md) §3-4 — API-boundary normalization, not a column rename |
| Backups are local-disk only | A VPS/host loss takes the backups with it | Ship to MinIO/S3 off-host — not yet wired |
| No real alerting on routine failures | Cron jobs log to file; nothing pages anyone yet | Needs a channel decision (Slack/email/PagerDuty) — infra exists, notifier doesn't |

This table is the honest version of "remaining risk." Presenting gaps you already
found and already have a documented path to close is a stronger investor signal than
presenting a system with no visible seams.

## 4. Architecture (one paragraph, board-level)

A single Nginx reverse proxy routes by HTTP Host header to eight independently
deployable Node/Express services, all sharing one governed Postgres instance (with
foreign-key-correct schema migrations) and one Redis cache. MinIO provides
S3-compatible object storage for future media/asset needs. Every service exposes a
standardized `/health` endpoint returning governed JSON
(`{"ok","service","mode","governance","timestamp"}`), and the flagship API additionally
exposes `/api/v1/info` enumerating every brand under the ACool umbrella. Grafana +
Prometheus are wired for observability but not yet alerting anyone.

## 5. The Operating System Prompt (what governs this in production)

The actual production posture is enforced not by code comments but by the operator's
standing instructions to any AI agent (human or model) touching this system. The
canonical version lives at `/Users/acoolnerd/CLAUDE.md` on the operator's machine and
is reproduced/adapted for portability in
[`docs/prompts/ACOOL_FULL_CONTEXT_HANDOFF_PROMPT.md`](../prompts/ACOOL_FULL_CONTEXT_HANDOFF_PROMPT.md).
Its load-bearing rules, summarized for a non-technical board:

- **Entity Firewall** — eight branded products, one shared infrastructure, zero
  cross-contamination of code, color palettes, or data models between them
- **7-Field Schema Law** — every new data object gets the same governed shape
  (`id, entity, type, name, status, owner, updatedAt` + domain `metadata`)
- **Governance-first** — RBAC roles, audit events, and validated input are required
  in the *first pass* of any new build, not bolted on later
- **No secrets in logs, code, or version control** — enforced mechanically
  (`.gitignore`, `check-ignore` verification before every commit) and procedurally
- **No destructive infrastructure command runs without explicit operator approval**
  — every `down -v`, every schema `ALTER`, every push to `main` required a direct ask
  this session, and got one

## 6. Dependencies

Full inventory: [`docs/DEPENDENCY_MANIFEST.md`](../DEPENDENCY_MANIFEST.md). Headline:
8 production Docker images, 10 npm dependency trees, 0 known unpatched high/critical
vulnerabilities in anything audited so far, with a documented (not hidden) gap in
lockfile coverage across the backend services.

## 7. Path to General Availability

1. Pin the four `:latest` Docker images (low effort, high leverage)
2. Generate lockfiles for the 9 backend services (low effort)
3. Provision VPS + Cloudflare Tunnel per the beta runbook (needs infra spend decision)
4. Ship Postgres backups off-host
5. Wire a real alert channel for the three automated routines
6. Close the ACoolSCHEMA compliance gap with operator-approved, tested DDL
7. Re-run this exact validation cycle against the VPS target before flipping DNS

## 8. The Ask

This manifest exists so the board is evaluating the *actual* state of the system —
proven capabilities, named gaps, and a dated path to close them — rather than a demo
that happens to work on the day of the meeting. Item 3 above (VPS + Cloudflare) is
the one item on this list that requires capital or infrastructure access beyond what
local development provides.

Made with LOVE by ACoolNERD with ACoolAI
