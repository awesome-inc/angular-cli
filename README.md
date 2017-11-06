# angular-cli

[![dockeri.co](http://dockeri.co/image/awesomeinc/angular-cli)](https://registry.hub.docker.com/awesomeinc/angular-cli/)

A Node image containing a global installation of @angular/cli to build Angular applications in a container.

## Usage

In the following see an example of usage within a [Docker multistage build](https://docs.docker.com/engine/userguide/eng-image/multistage-build/):

```
# First, build the project
FROM awesomeinc/angular-cli AS build-env

# Add proxy information
ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG NO_PROXY

COPY package.json /tmp/package.json

RUN cd /tmp && npm install
RUN mkdir -p /build && cp -a /tmp/node_modules /build/

WORKDIR /build
ADD ./ .

RUN ng build --prod

# Second, serve via Nginx
FROM nginx:1.13.2-alpine

COPY --from=build-env /build/dist/ /usr/share/nginx/html

COPY ./etc/nginx.conf /etc/nginx/nginx.conf
COPY ./etc/conf.d /etc/nginx/conf.d

EXPOSE 80

CMD nginx -g 'daemon off;'
```