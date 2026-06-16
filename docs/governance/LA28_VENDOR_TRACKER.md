# LA28 Vendor Tracker — Service Manifest

**Entity lane:** ACoolCITYHALLCONNECT (civic/government)
**Owner:** ACoolNERD
**Status:** Containerized, wired into the production stack, live-tested
**Governance Principle:** Rights → Disclosure → Proof

---

## 1. What this is

Tracks LA28 Olympics municipal vendor-portal registration status across three real
government procurement pathways:

- LA City Procurement (BBH Lemonade concession vendor)
- LA28.org Talent/Entertainment vendor portal
- LA County Supplier Portal

This existed in the repo as a standalone, uncontainerized script
(`services/la28-vendor-tracker/index.js`, no `package.json`, no `Dockerfile`, not in
`docker-compose.prod.yml`, not routed through Nginx) before this pass. It is now a
first-class service in the stack, same as every other ACool component.

## 2. What changed to make it real

- `services/la28-vendor-tracker/src/index.js` — moved into the standard `src/`
  layout, governed `/health` contract matching every other service
  (`{"ok","service","mode","governance","timestamp"}`), routes renamed to
  `/api/v1/la28/...` for consistency with the rest of the stack
- `services/la28-vendor-tracker/package.json` + generated `package-lock.json` —
  0 vulnerabilities
- `services/la28-vendor-tracker/Dockerfile` — same `node:20-alpine` two-stage build
  and Node-based healthcheck pattern as every other service
- `docker-compose.prod.yml` — new `la28-vendor-tracker` service on port 3800
- `nginx/conf.d/prod.conf` — new upstream + `la28.acool.ai` Host-header route (HTTP
  and HTTPS server blocks)
- `scripts/prod-smoke-test.sh` — added `la28.acool.ai/health` to the route list
  (now 10 routes, was 9)
- `services/acool-ecosystem-api/src/index.js` — added to `BRANDS` and `components`
  in `/api/v1/info`

## 3. Built to the 7-field law from day one

Unlike `talents`/`agencies`/etc., which predated the schema law and needed a
3-migration retrofit (see [ACoolSCHEMA_REGISTRY.md](ACoolSCHEMA_REGISTRY.md)), this
service is new — so every vendor record was written with the full shape from the
start: `id, entity ("ACoolCITYHALLCONNECT"), type ("vendor-portal"), name, status,
owner ("ACoolNERD"), updatedAt`, with all domain-specific fields (`url`,
`certifications_needed`, `costs`, `deadline`, etc.) nested under `metadata`.

## 4. Verified, not assumed

- `GET /health` via `la28.acool.ai` → `200`, governed JSON
- `GET /api/v1/la28/vendors` → 3 records, correct 7-field shape, `total_cost` sums
  correctly across `metadata.total_cost`
- `GET /api/v1/la28/vendors/:id` → single record fetch
- `PUT /api/v1/la28/vendors/:id` with `{"status":"in_progress"}` → updates `status`
  **and** bumps `updatedAt`, confirmed via response diff
- `GET /api/v1/la28/checklist` → static checklist, correct total
- Re-verified via a full `down -v --remove-orphans` → `up -d --build` cold cycle:
  all 16 containers healthy (was 15 before this service existed), `la28.acool.ai`
  healthy from a true empty-volume start, `prod-smoke-test.sh` 10/10

## 5. Known gap — stated plainly, not hidden

**This service is in-memory only.** Restarting the container resets every vendor's
`status` back to its hardcoded default (`not_registered`). Any status updates made
via `PUT /api/v1/la28/vendors/:id` do not survive a restart.

This was a deliberate choice for this pass, not an oversight: adding a
`civic_vendor_portals` Postgres table (same migration pattern as `000`-`003`) is the
obvious next step, but doing it before anyone confirmed the data needs to persist
would be the same mistake as scaffolding fake Meta Wearable API integration code —
motion without a confirmed requirement behind it. If persistence is needed, say so
and it's a same-shaped migration as the ones already proven this session.

Made with LOVE by ACoolNERD with ACoolAI
