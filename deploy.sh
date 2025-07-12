#!/bin/bash

set -euo pipefail

trap 'echo "💥 Deployment fehlgeschlagen!"; exit 1' ERR

echo "🔍 Starte Jest-Tests..."

npm ci
npm test

echo "✅ Tests erfolgreich – kopiere Code in Zielcontainer..."

: "${DEST_CONTAINER:?Fehlende Variable: DEST_CONTAINER}"
: "${DEST_PATH:=/app}"

# Nur das nötigste kopieren: Beispiel, falls du einen Build-Ordner hast
if [ -d "dist" ]; then
  docker exec "$DEST_CONTAINER" mkdir -p "$DEST_PATH"
  docker cp dist/. "$DEST_CONTAINER":"$DEST_PATH"
  echo "✅ Nur 'dist' Ordner wurde deployed."
else
  docker exec "$DEST_CONTAINER" mkdir -p "$DEST_PATH"
  docker cp . "$DEST_CONTAINER":"$DEST_PATH"
  echo "⚠️  Kein 'dist'-Ordner gefunden, gesamtes Verzeichnis deployed."
fi

echo "🎉 Deployment abgeschlossen"
