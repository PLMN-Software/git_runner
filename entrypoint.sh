#!/bin/bash
set -e

DOCKER_SOCK="/var/run/docker.sock"
if [ -S "$DOCKER_SOCK" ]; then
  DOCKER_GID=$(stat -c '%g' $DOCKER_SOCK)
  if getent group docker; then
    # Ändere GID der bestehenden docker-Gruppe auf Host-GID!
    groupmod -g "$DOCKER_GID" docker
  else
    groupadd -g "$DOCKER_GID" docker
  fi
  usermod -aG docker runneruser
fi

# Rest wie gehabt...
echo "🔄 Wechsle jetzt zu runneruser…"
exec gosu runneruser /entrypoint-user.sh
