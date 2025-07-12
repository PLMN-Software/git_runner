#!/bin/bash
set -e

echo "▶️ Starte GitHub Runner Setup..."

#./config.sh --url "$GITHUB_URL" --token "$GITHUB_TOKEN" --name "$RUNNER_NAME" --unattended
./config.sh --url https://github.com/PLMN-Software --token AD4MM37NSZ4GBTTLICIY5P3IOHTT2 --name "PLMN-dev-001" --unattended


echo "✅ Runner registriert. Starte..."

# Starte den Runner (wird aktiv auf GitHub Events lauschen)
exec ./run.sh
