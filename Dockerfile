FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y curl unzip sudo git && \
    useradd -m runner && \
    mkdir /actions-runner && \
    chown runner:runner /actions-runner

WORKDIR /actions-runner

RUN curl -O -L https://github.com/actions/runner/releases/download/v2.314.1/actions-runner-linux-x64-2.314.1.tar.gz && \
    tar xzf actions-runner-linux-x64-2.314.1.tar.gz && \
    rm actions-runner-linux-x64-2.314.1.tar.gz

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
