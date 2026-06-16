# VPS Beta Dispatch Runbook

**Status:** Documented, **not executed** — requires a real server and credentials
this session does not have. Local beta (`v1.0.0-beta.1`) is live and validated; this
is the next rung up.
**Owner:** Keith McPherson (ACoolNERD)
**Governance:** Rights → Disclosure → Proof

---

## 1. Provision the VPS

- Ubuntu 22.04 LTS, 4 vCPU / 8GB RAM minimum (12 containers + Postgres/Redis/MinIO)
- Open only ports 80/443 to the public internet; everything else stays behind
  Docker's internal network (matches the current compose file — no service besides
  `nginx` publishes a host port)
- Create a non-root deploy user; disable password SSH, key-only

```bash
ssh-copy-id deploy@<vps-ip>
ssh deploy@<vps-ip> "curl -fsSL https://get.docker.com | sh"
ssh deploy@<vps-ip> "sudo usermod -aG docker deploy"
```

## 2. Copy the repo and `.env` securely

**Never** commit `.env`; never `scp` it over a path that lands in a web-served
directory.

```bash
git clone https://github.com/ACoolNerd/ACool_ai.git
# on the VPS, in the repo root:
scp .env deploy@<vps-ip>:~/ACool_ai/.env   # from your Mac, not checked into git
ssh deploy@<vps-ip> "chmod 600 ~/ACool_ai/.env"
```

Rotate `POSTGRES_PASSWORD`, `REDIS_PASSWORD`, `MINIO_ROOT_PASSWORD`, `JWT_SECRET`,
`SESSION_SECRET` for the VPS — do not reuse local dev secrets in any environment
reachable from the public internet.

## 3. Run the prod stack

```bash
cd ~/ACool_ai
docker compose -f docker-compose.prod.yml --env-file .env up -d --build --remove-orphans
sleep 120
docker compose -f docker-compose.prod.yml --env-file .env ps
bash scripts/prod-smoke-test.sh
```

Same commands validated locally in this session — no changes needed for the VPS
target, which is the point of containerizing it.

## 4. Connect Cloudflare Tunnel (no exposed ports beyond what Cloudflare proxies)

```bash
curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared.deb
cloudflared tunnel login
cloudflared tunnel create acool-prod
cloudflared tunnel route dns acool-prod api.acool.ai
cloudflared tunnel route dns acool-prod dashboard.acool.ai
cloudflared tunnel route dns acool-prod skills.acool.ai
cloudflared tunnel route dns acool-prod academy.acool.ai
cloudflared tunnel route dns acool-prod fashion.acool.ai
cloudflared tunnel route dns acool-prod cityhall.acool.ai
cloudflared tunnel route dns acool-prod acoolnerd.acool.ai
```

Tunnel config (`~/.cloudflared/config.yml`) points all of the above at
`http://localhost:80` — nginx's existing Host-header routing (already proven in
`nginx/conf.d/prod.conf` and validated by `scripts/prod-smoke-test.sh`) does the rest.
No code changes are needed for this step; it's purely infra wiring.

## 5. Point real `acool.ai` subdomains

Handled by step 4's `tunnel route dns` calls if `acool.ai` is on Cloudflare DNS.
If not yet migrated to Cloudflare DNS, that migration is a prerequisite to this step.

## 6. Post-cutover

- Re-run [`scripts/routines/health-check.sh`](../../scripts/routines/health-check.sh),
  [`pg-backup.sh`](../../scripts/routines/pg-backup.sh), and
  [`backup-verify.sh`](../../scripts/routines/backup-verify.sh) on the VPS's own
  crontab — the local Mac crontab entries do not apply to the VPS
  (see [PRODUCTION_FIX_SUMMARY.md](../PRODUCTION_FIX_SUMMARY.md) for the local cadence
  reference to mirror)
- Ship `backups/*.sql.gz` off-host to MinIO/S3 — local-disk-only backups on the VPS
  don't survive VPS loss any more than they do locally

## What this runbook intentionally does not do

- Does not execute any of the above against a real server — no VPS IP, SSH key, or
  Cloudflare account was available in this session
- Does not invent placeholder credentials and call the job "done"

Made with LOVE by ACoolNERD with ACoolAI
