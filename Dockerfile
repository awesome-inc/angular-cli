FROM node:8.6-alpine

LABEL author=awesome-inc description="Angular-CLI Container"

ENV NPM_CONFIG_LOGLEVEL warn
ENV NODE_ENV production
RUN npm i -g @angular/cli