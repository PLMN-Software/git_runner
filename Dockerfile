FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    ca-certificates \
    unzip \
    nodejs \
    npm \
    bash \
    && apt-get clean

WORKDIR /runner

COPY entrypoint.sh /entrypoint.sh
COPY deploy.sh /deploy.sh
RUN chmod +x /entrypoint.sh /deploy.sh

ENTRYPOINT ["/entrypoint.sh"]
