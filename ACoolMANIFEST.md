# ACoolECOSYSTEM Manifest

## Overview

This repo is the Docker-first local production stack and manifest workspace for ACoolECOSYSTEM. It now carries four governed operating lanes:

- `ACoolDATABASE`: database inventory, persistence, local production reset rules, and data governance.
- `ACoolSCHEMA`: 7-field object law, schema registry, validation posture, and parent-child dependency rules.
- `ACoolOSINT`: source logs, evidence intake, NAICS case-study references, and confidence controls.
- `ACoolAI`: AI runtime, prompt/runtime boundaries, service health, and governed automation notes.

## Operating Rule

Rights → Disclosure → Proof

Made with LOVE by ACoolNERD with ACoolAI

## Current Proof

The Docker production stack was validated locally through Nginx Host-header routes. Required health endpoints returned HTTP 200 and governed JSON for ACoolECOSYSTEM API, ACool Router, ACool Skills API, ACool Skills Dashboard, ACoolACADEMY, FashionbyKukanaana, ACoolCITYHALLCONNECT, and ACoolNERD.

## Manifest Index

- [ACoolDATABASE](ACoolDATABASE/README.md)
- [ACoolSCHEMA](ACoolSCHEMA/README.md)
- [ACoolOSINT](ACoolOSINT/README.md)
- [ACoolAI](ACoolAI/README.md)
- [Manifest Index](docs/ACoolMANIFEST/ACool_ECOSYSTEM_MANIFEST_INDEX.md)
- [NAICS Evidence Log](docs/ACoolMANIFEST/ACool_NAICS_EVIDENCE_LOG.md)
- [RACI and Separation of Duties](docs/ACoolMANIFEST/ACool_RACI_SEPARATION_OF_DUTIES.md)
- [Delivery Manifest](docs/ACoolMANIFEST/ACool_DELIVERY_MANIFEST.md)

## Not Performed (as of original authoring, 2026-06-16 ~03:55)

- No Git push.
- No commit.
- No secret publication.
- No global Docker prune.
- No unrelated Docker project deletion.
- No external publication of the Deloitte sample PDFs.

## Addendum — 2026-06-16, later session (tag v1.0.0-beta.1)

A follow-on session extended this manifest set with deeper governance documents and
shipped them:

- [`docs/governance/ACoolDATABASE_MANIFEST.md`](docs/governance/ACoolDATABASE_MANIFEST.md) — RBAC roles, audit events, backup gap (deeper companion to `ACoolDATABASE/README.md`)
- [`docs/governance/ACoolSCHEMA_REGISTRY.md`](docs/governance/ACoolSCHEMA_REGISTRY.md) — honest 7-field compliance gap report (deeper companion to `ACoolSCHEMA/README.md`)
- [`docs/governance/PRODUCTION_READINESS_MANIFEST.md`](docs/governance/PRODUCTION_READINESS_MANIFEST.md) — board/investor briefing
- [`docs/governance/VPS_BETA_DISPATCH_RUNBOOK.md`](docs/governance/VPS_BETA_DISPATCH_RUNBOOK.md) — documented, not executed (no VPS credentials available)
- [`docs/DEPENDENCY_MANIFEST.md`](docs/DEPENDENCY_MANIFEST.md) — full dependency inventory
- [`docs/prompts/`](docs/prompts/) — portable cross-platform context-handoff prompts
- `scripts/routines/` — health-check, dependency-scan, pg-backup, backup-verify, wired to local cron

This pass **did** commit and push (branch `fix/db-migration-order-healthchecks-governance`,
PR [#2](https://github.com/ACoolNerd/ACool_ai/pull/2)), with explicit operator approval
each time, after hardening `.gitignore` to exclude `.env*` first. Still true: no global
Docker prune, no unrelated project touched, no secrets committed.

## Addendum — 2026-06-16, same-day follow-up (5th pass)

- Closed the ACoolSCHEMA 7-field law gap end to end (PRs
  [#4](https://github.com/ACoolNerd/ACool_ai/pull/4),
  [#5](https://github.com/ACoolNerd/ACool_ai/pull/5),
  [#6](https://github.com/ACoolNerd/ACool_ai/pull/6)) — all 9 tables now carry
  `metadata`/`entity`/`owner`/`type`/`status`, and the 4 tables with a non-`name`
  label column get a normalized `name` at the API boundary.
- Added OpenGraph + schema.org tags to all 8 public pages
  ([PR #7](https://github.com/ACoolNerd/ACool_ai/pull/7)).
- Containerized and wired in `services/la28-vendor-tracker` — previously a
  standalone, undeployed script with no `package.json`/`Dockerfile`/compose
  entry/Nginx route. Now a real service under the ACoolCITYHALLCONNECT civic lane,
  built to the 7-field law from day one. See
  [`docs/governance/LA28_VENDOR_TRACKER.md`](docs/governance/LA28_VENDOR_TRACKER.md).
  Verified live (curl through Nginx) and via a full cold
  `down -v --remove-orphans` → `up -d --build` cycle: 16/16 containers healthy,
  `prod-smoke-test.sh` 10/10 (was 9/9 before this service existed).
