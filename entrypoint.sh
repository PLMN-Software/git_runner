#!/bin/bash
set -e

echo "🛠️  Root-Setup: Passe Docker-Gruppe und Rechte an…"

DOCKER_SOCK="/var/run/docker.sock"
if [ -S "$DOCKER_SOCK" ]; then
  DOCKER_GID=$(stat -c '%g' $DOCKER_SOCK)
  if ! getent group docker | grep -q ":$DOCKER_GID:"; then
    groupadd -for -g "$DOCKER_GID" docker
  fi
  usermod -aG docker runneruser
fi

echo "🔄 Wechsle jetzt zu runneruser…"
exec gosu runneruser /entrypoint-user.sh


