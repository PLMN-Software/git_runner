#!/bin/bash

set -e

echo "🔍 Starte Jest-Tests..."

npm ci
npm test

if [ $? -eq 0 ]; then
  echo "✅ Tests erfolgreich – kopiere Code in Zielcontainer..."

  : "${DEST_CONTAINER:?Fehlende Variable: DEST_CONTAINER}"
  : "${DEST_PATH:=/app}"

  docker exec "$DEST_CONTAINER" mkdir -p "$DEST_PATH"
  docker cp . "$DEST_CONTAINER":"$DEST_PATH"

  echo "✅ Deployment abgeschlossen"
else
  echo "❌ Tests fehlgeschlagen – kein Deployment"
  exit 1
fi
