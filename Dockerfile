ARG base=rastasheep/alpine-node-chromium:8-alpine
FROM ${base}

LABEL author=awesome-inc description="Angular-CLI Container"

ENV NPM_CONFIG_LOGLEVEL warn

ARG NG_CLI_VERSION=latest
RUN yarn global add @angular/cli@$NG_CLI_VERSION && rm -rf $(yarn cache dir)
