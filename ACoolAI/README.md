# ACoolAI

## Purpose

ACoolAI governs the AI runtime boundary, prompt runtime, routing layer, and ACoolECOSYSTEM service intelligence.

## Runtime Assets

- Main API: `services/acool-ecosystem-api`
- Router: `services/acool-router`
- Skills API: `services/acool-skills-api`
- Prompt Runtime: `apps/prompt-runtime`
- Nginx ingress: `nginx/conf.d/prod.conf`
- Smoke test: `scripts/prod-smoke-test.sh`

## Health Contract

Every governed service must expose:

```json
{
  "ok": true,
  "service": "<service name>",
  "mode": "production",
  "governance": "Rights → Disclosure → Proof",
  "timestamp": "<ISO timestamp>"
}
```

## API Info Contract

`GET /api/v1/info` must include:

- `app`
- `service`
- `version`
- `components`
- `governance`
- `brands`
- `status`

## AI Boundary Rules

- Do not commit secrets.
- Do not print `.env` values.
- Use the Docker-first production stack only.
- Keep ACoolAI runtime logic separate from unrelated ventures.
- Keep evidence and prompt material draft-only until Keith explicitly approves publication.
