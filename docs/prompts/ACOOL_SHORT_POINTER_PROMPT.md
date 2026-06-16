# ACool Short Pointer Prompt

Use this version when the other tool can actually read files in this repo (it's
opened in the IDE/workspace, or you can paste file contents on request). It's faster
and won't drift out of date the way a fully inlined prompt will.

---

```
You're working in ~/acool-docker-universal-v5 (GitHub: ACoolNerd/ACool_ai), the
Docker-first production stack for ACoolECOSYSTEM, operated by Keith McPherson
(ACoolNERD). Current tag: v1.0.0-beta.1.

Before doing anything, read these in order:
1. /Users/acoolnerd/CLAUDE.md — hard governance rules (entity firewall, 7-field
   schema law, no-secrets, approval-before-push/destructive-commands)
2. docs/PRODUCTION_FIX_SUMMARY.md — what's been fixed and how
3. docs/governance/PRODUCTION_READINESS_MANIFEST.md — current state, proven vs. gap
4. docs/DEPENDENCY_MANIFEST.md — dependency inventory and known gaps

Then verify current reality (don't trust the docs blindly — re-check):
  cd ~/acool-docker-universal-v5 && docker compose -f docker-compose.prod.yml --env-file .env ps
  bash scripts/prod-smoke-test.sh

Then: [fill in your actual task]

Hard rules that apply no matter what the task is: never commit .env*/secrets, never
push without explicit approval, never run destructive Docker commands
(`down -v`, `system prune --volumes`) without asking, always scope compose commands
to `-f docker-compose.prod.yml --env-file .env`.
```

Made with LOVE by ACoolNERD with ACoolAI
