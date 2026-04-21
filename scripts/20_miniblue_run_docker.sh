#!/usr/bin/env bash
set -euo pipefail

IMAGE="${MINIBLUE_IMAGE:-moabukar/miniblue:latest}"

echo "[miniblue-docker] starting ${IMAGE} on ports 4566/4567..."

docker rm -f miniblue >/dev/null 2>&1 || true

docker run -d --name miniblue \
  -p 4566:4566 \
  -p 4567:4567 \
  "${IMAGE}"

echo "[miniblue-docker] container started."
docker ps --filter name=miniblue
