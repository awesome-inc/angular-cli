# 1. Build & test app
FROM zenika/alpine-chrome:with-node AS base

# see
# - https://github.com/Zenika/alpine-chrome/blob/master/with-chromedriver/Dockerfile
# - https://github.com/Zenika/alpine-chrome/blob/master/with-node/Dockerfile
USER root
RUN apk add --no-cache chromium-chromedriver
USER chrome

FROM base AS build
WORKDIR /usr/src/app

COPY ["package*.json", "./"]
RUN npm ci

COPY ["./", "./"]
RUN npm run test
RUN npm run e2e
RUN npm run build

# 2. Package runtime image (NGINX)
FROM nginx:1.19.8-alpine
COPY --from=build /usr/src/app/dist/myapp /usr/share/nginx/html
