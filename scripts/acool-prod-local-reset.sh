#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

printf 'ACoolECOSYSTEM local production reset\n'
printf 'Scope: this compose project only (%s)\n' "$(pwd)"
printf 'Action: docker compose -f docker-compose.prod.yml --env-file .env down -v --remove-orphans\n'
printf 'Safety: not running docker system prune --volumes\n\n'

docker compose -f docker-compose.prod.yml --env-file .env down -v --remove-orphans
