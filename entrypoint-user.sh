#!/bin/bash
set -e

echo "▶️ Starte GitHub Runner Setup..."

: "${GITHUB_PAT:?GITHUB_PAT nicht gesetzt}"
: "${GITHUB_ORG:?GITHUB_ORG nicht gesetzt}"
: "${RUNNER_NAME:=self-hosted-runner}"
: "${RUNNER_LABELS:=ci}"
: "${RUNNER_WORKDIR:=_work}"

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
