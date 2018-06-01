# 1. Build & test app
ARG CLI_VERSION
FROM awesomeinc/angular-cli:${CLI_VERSION:-latest} AS build-env

# Add proxy information
ARG http_proxy=
ARG https_proxy=
ARG no_proxy=

COPY package.json package-*.json yarn.loc* ./

RUN yarn

ADD ./ ./

RUN yarn test
RUN yarn e2e
RUN yarn build

# 2. Package runtime image (NGINX)
FROM nginx:1.14.0-alpine
COPY --from=build-env /usr/src/app/dist/myapp /usr/share/nginx/html
