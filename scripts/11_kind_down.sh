#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-miniblue-lab}"

echo "[kind-down] deleting cluster: ${CLUSTER_NAME}"
kind delete cluster --name "${CLUSTER_NAME}" || true
echo "[kind-down] done."
