FROM node:20-slim

# Installiere benötigte Pakete
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      git \
      curl \
      unzip \
      ca-certificates \
      docker.io \
      jq \
      gosu \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis setzen
WORKDIR /runner

# Runner-Version definieren
ARG RUNNER_VERSION=2.326.0

# Runner herunterladen und entpacken
RUN curl -L -o actions-runner.tar.gz \
    https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf actions-runner.tar.gz && \
    rm actions-runner.tar.gz

# Abhängigkeiten für den Runner installieren
RUN ./bin/installdependencies.sh

# Jest installieren (global)
RUN npm install -g jest


# Wechsle zum neuen Benutzer

# Entrypoint-Skript kopieren
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh


# Benutzer anlegen, damit der Runner nicht als root läuft
RUN useradd -m runneruser && \
    chown -R runneruser:runneruser /runner

RUN groupadd docker || true
# Nach dem Erstellen von runneruser
RUN usermod -aG docker runneruser
RUN npm init

    
USER runneruser


# Entrypoint setzen
ENTRYPOINT ["/entrypoint.sh"]
