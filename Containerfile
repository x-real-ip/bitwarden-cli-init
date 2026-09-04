FROM node:alpine3.16

RUN npm install -g @bitwarden/cli \
    && apk add --no-cache \
    bash

ENTRYPOINT [ "/usr/local/bin/bw" ]
