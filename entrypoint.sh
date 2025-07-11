#!/bin/bash

set -e

: "${GITHUB_URL:?Fehlende Variable: GITHUB_URL}"
: "${GITHUB_TOKEN:?Fehlende Variable: GITHUB_TOKEN}"
: "${RUNNER_NAME:=frank-ci-runner}"
: "${RUNNER_LABELS:=self-hosted,ci}"
: "${RUNNER_WORKDIR:=_work}"

cd /runner

if [ ! -f ./config.sh ]; then
  echo "📥 Lade GitHub Runner..."
  curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/latest/download/actions-runner-linux-x64-2.316.0.tar.gz
  tar xzf actions-runner.tar.gz
  rm actions-runner.tar.gz
fi

./config.sh \
  --unattended \
  --url "$GITHUB_URL" \
  --token "$GITHUB_TOKEN" \
  --name "$RUNNER_NAME" \
  --labels "$RUNNER_LABELS" \
  --work "$RUNNER_WORKDIR"

echo "✅ Runner konfiguriert. Starte..."
exec ./run.sh
