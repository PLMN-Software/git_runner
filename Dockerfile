FROM node:20-alpine

RUN apk add --no-cache git bash

WORKDIR /ci

COPY ci-runner.sh /usr/local/bin/ci-runner
RUN chmod +x /usr/local/bin/ci-runner

ENTRYPOINT ["ci-runner"]
