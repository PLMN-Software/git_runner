#!/bin/bash
set -e

echo "🚀 Starte GitHub Actions Runner..."

# Prüfen ob bereits konfiguriert
if [ ! -f .runner ]; then
  echo "🔧 Konfiguriere Runner für $REPO_URL..."
  ./config.sh \
    --url "$REPO_URL" \
    --token "$RUNNER_TOKEN" \
    --name "$RUNNER_NAME" \
    --labels "$RUNNER_LABELS" \
    --unattended \
    --replace
  touch .runner
fi

echo "✅ Runner bereit. Warte auf Jobs..."
exec ./run.sh
