#!/bin/bash

#!/bin/bash
set -e

# GID-Fix für Docker-Socket
DOCKER_SOCK="/var/run/docker.sock"
if [ -S "$DOCKER_SOCK" ]; then
  DOCKER_GID=$(stat -c '%g' $DOCKER_SOCK)
  if ! getent group docker | grep -q ":$DOCKER_GID:"; then
    groupadd -for -g "$DOCKER_GID" docker
  fi
  usermod -aG docker runneruser
fi

# Jetzt zu runneruser wechseln:
exec gosu runneruser /runner/entrypoint-user.sh


echo "▶️ Starte GitHub Runner Setup..."

# Stelle sicher, dass die Umgebungsvariablen gesetzt sind
: "${GITHUB_PAT:?GITHUB_PAT nicht gesetzt}"
: "${GITHUB_ORG:?GITHUB_ORG nicht gesetzt}"
: "${RUNNER_NAME:=self-hosted-runner}"
: "${RUNNER_LABELS:=ci}"
: "${RUNNER_WORKDIR:=_work}"

# Prüfen, ob der Runner bereits registriert ist
if [ ! -f ".runner" ]; then
  echo "📦 Lade Runner-Token..."

  RUNNER_TOKEN=$(curl -s \
    -X POST \
    -H "Authorization: token ${GITHUB_PAT}" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://api.github.com/orgs/${GITHUB_ORG}/actions/runners/registration-token" \
    | jq -r .token)

  echo "🔧 Konfiguriere Runner..."
  ./config.sh \
    --url "https://github.com/${GITHUB_ORG}" \
    --token "${RUNNER_TOKEN}" \
    --name "${RUNNER_NAME}" \
    --labels "${RUNNER_LABELS}" \
    --work "${RUNNER_WORKDIR}" \
    --unattended \
    --replace

  touch .runner
else
  echo "✅ Runner bereits konfiguriert. Starte direkt..."
fi

exec ./run.sh
