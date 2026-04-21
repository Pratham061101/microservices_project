#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-miniblue-lab}"

echo "[kind-up] creating cluster: ${CLUSTER_NAME}"

kind get clusters | grep -qx "${CLUSTER_NAME}" && {
  echo "[kind-up] cluster already exists: ${CLUSTER_NAME}"
  exit 0
}

kind create cluster --name "${CLUSTER_NAME}"

kubectl cluster-info
kubectl get nodes -o wide
echo "[kind-up] done."
