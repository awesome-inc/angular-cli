FROM node:9.3.0-alpine

LABEL author=awesome-inc description="Angular-CLI Container"

ENV NPM_CONFIG_LOGLEVEL warn

# install angular-cli as node user
RUN chown -R node:node /usr/local/lib/node_modules \
  && chown -R node:node /usr/local/bin

ARG DOCKER_TAG
ENV ANGULAR_CLI_VERSION ${DOCKER_TAG:-latest}

USER node
RUN echo Installing angular/cli@${ANGULAR_CLI_VERSION}... && \
  npm install -g @angular/cli@${ANGULAR_CLI_VERSION}

# set npm as default package manager for root
USER root
RUN ng set --global packageManager=npm

USER root