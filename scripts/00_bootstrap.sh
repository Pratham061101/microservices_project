#!/usr/bin/env bash
set -euo pipefail

echo "[bootstrap] starting..."

if ! command -v sudo >/dev/null 2>&1; then
  echo "[bootstrap] sudo not found; exiting"
  exit 1
fi

echo "[bootstrap] OS info:"
cat /etc/os-release || true

# Basic tools
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release git

# Docker (Engine)
if ! command -v docker >/dev/null 2>&1; then
  echo "[bootstrap] installing docker..."

  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo ${UBUNTU_CODENAME:-$VERSION_CODENAME}) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update -y
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
  echo "[bootstrap] docker already installed"
fi

sudo systemctl enable --now docker || true

# Allow current user to run docker without sudo (best effort)
if ! groups | grep -q "\bdocker\b"; then
  echo "[bootstrap] adding $USER to docker group"
  sudo usermod -aG docker "$USER" || true
  echo "[bootstrap] NOTE: you may need to log out/in for group change to apply"
fi

# kubectl
if ! command -v kubectl >/dev/null 2>&1; then
  echo "[bootstrap] installing kubectl (apt)..."
  sudo apt-get install -y kubectl
else
  echo "[bootstrap] kubectl already installed"
fi

# kind
if ! command -v kind >/dev/null 2>&1; then
  echo "[bootstrap] installing kind..."
  curl -Lo /tmp/kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
  chmod +x /tmp/kind
  sudo mv /tmp/kind /usr/local/bin/kind
else
  echo "[bootstrap] kind already installed"
fi

# helm
if ! command -v helm >/dev/null 2>&1; then
  echo "[bootstrap] installing helm..."
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
else
  echo "[bootstrap] helm already installed"
fi

echo "[bootstrap] versions:"
git --version || true
docker --version || true
kubectl version --client || true
kind version || true
helm version || true

echo "[bootstrap] done."
