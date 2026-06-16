#!/usr/bin/env bash
set -euo pipefail

run() {
  printf '\n==> %s\n' "$*"
  "$@"
}

run curl -i --fail-with-body http://localhost
run curl -i --fail-with-body -H "Host: api.acool.ai" http://localhost/health
run curl -i --fail-with-body -H "Host: api.acool.ai" http://localhost/api/v1/info
run curl -i --fail-with-body -H "Host: dashboard.acool.ai" http://localhost/health
run curl -i --fail-with-body -H "Host: skills.acool.ai" http://localhost/health
run curl -i --fail-with-body -H "Host: academy.acool.ai" http://localhost/health
run curl -i --fail-with-body -H "Host: fashion.acool.ai" http://localhost/health
run curl -i --fail-with-body -H "Host: cityhall.acool.ai" http://localhost/health
run curl -i --fail-with-body -H "Host: acoolnerd.acool.ai" http://localhost
