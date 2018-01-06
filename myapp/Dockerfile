# 1. Build & test app
ARG CLI_VERSION
FROM awesomeinc/angular-cli:${CLI_VERSION:-latest} AS build-env

# Add proxy information, sufficient for npm
ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG NO_PROXY

COPY package.json /tmp/package.json
# for npm
COPY package-lock.json /tmp/package-lock.json
# for yarn
# ADD yarn.lock /tmp/yarn.lock

RUN cd /tmp && npm install
RUN mkdir -p /build && cp -a /tmp/node_modules /build/

WORKDIR /build
ADD ./ .

# package
RUN ng build --prod

# 2. Package runtime image (NGINX)
FROM nginx:1.13.2-alpine

COPY --from=build-env /build/dist/ /usr/share/nginx/html

# Customized nginx config
#COPY ./etc/nginx.conf /etc/nginx/nginx.conf
#COPY ./etc/conf.d /etc/nginx/conf.d

EXPOSE 80

CMD nginx -g 'daemon off;'