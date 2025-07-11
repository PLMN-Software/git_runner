FROM node:20-slim

# Minimale Pakete installieren
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      git \
      curl \
      unzip \
      ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis für den Runner
WORKDIR /runner

# Aktuelle Runner-Version herunterladen und entpacken
RUN curl -L https://github.com/actions/runner/releases/latest/download/actions-runner-linux-x64-2.317.0.tar.gz \
    -o actions-runner.tar.gz && \
    tar xzf actions-runner.tar.gz && \
    rm actions-runner.tar.gz

# Runner-Abhängigkeiten installieren
RUN ./bin/installdependencies.sh

# Jest installieren
RUN npm install -g jest

# Entrypoint-Skript einfügen
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
