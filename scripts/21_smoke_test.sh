#!/usr/bin/env bash
set -euo pipefail

echo "[smoke] checking miniblue ports..."

curl -sS --max-time 2 http://localhost:4566/ >/dev/null || {
  echo "[smoke] FAILED: cannot reach http://localhost:4566"
  exit 1
}

echo "[smoke] OK: http://localhost:4566 reachable"
