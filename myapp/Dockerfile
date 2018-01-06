# 1. Build & test app
ARG CLI_VERSION
FROM awesomeinc/angular-cli:${CLI_VERSION:-latest} AS build-env

# Add proxy information
ARG http_proxy
ARG https_proxy
ARG no_proxy

RUN mkdir -p /build
WORKDIR /build 
COPY package.json package-lock.json yarn.lock ./

# RUN npm install
RUN yarn

ADD ./ ./

RUN ng test --single-run
RUN ng build --prod

# 2. Package runtime image (NGINX)
FROM nginx:1.13.2-alpine

COPY --from=build-env /build/dist/ /usr/share/nginx/html

# Customized nginx config
#COPY ./etc/nginx.conf /etc/nginx/nginx.conf
#COPY ./etc/conf.d /etc/nginx/conf.d

EXPOSE 80

CMD nginx -g 'daemon off;'