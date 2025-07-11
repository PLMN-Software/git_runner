#!/bin/bash
set -e

echo "▶️ Starte GitHub Runner Setup..."

./config.sh \
  --url "$GITHUB_URL" \
  --token "$GITHUB_TOKEN" \
  --name "$RUNNER_NAME" \
  --labels "$RUNNER_LABELS" \
  --work "$RUNNER_WORKDIR" \
  --unattended \
  --replace

echo "✅ Runner registriert. Starte..."

# Starte den Runner (wird aktiv auf GitHub Events lauschen)
exec ./run.sh
