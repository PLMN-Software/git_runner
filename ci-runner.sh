#!/bin/bash

echo "🔧 CI-Runner startet..."

# .env laden
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo "❌ .env Datei fehlt!"
  exit 1
fi

# Repo-Ordner vorbereiten
rm -rf repo
mkdir repo
cd repo

# Git-Repo klonen
echo "📥 Cloning from $REPO_URL (branch: $BRANCH)"
git clone -b "$BRANCH" https://$GIT_USER:$GIT_TOKEN@${REPO_URL#https://} .

if [ $? -ne 0 ]; then
  echo "❌ Git Clone fehlgeschlagen"
  exit 1
fi

# Dependencies installieren
echo "📦 npm install läuft..."
npm ci

# Tests ausführen
echo "🧪 Starte Jest Tests..."
npm test

if [ $? -ne 0 ]; then
  echo "❌ Tests fehlgeschlagen – Deployment abgebrochen"
  exit 1
fi

# Deployment in Webserver-Container
echo "📤 Tests erfolgreich – Deploy nach $DEST_CONTAINER:$DEST_PATH"
docker cp . "$DEST_CONTAINER":"$DEST_PATH"
docker exec "$DEST_CONTAINER" npm run restart || echo "ℹ️ Kein restart-script definiert"

echo "✅ Alles erledigt!"
