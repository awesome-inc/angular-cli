ARG base=rastasheep/alpine-node-chromium:8-alpine
FROM ${base}

# cf.: 
# - https://docs.docker.com/docker-cloud/builds/advanced/#environment-variables-for-building-and-testing
# - https://medium.com/microscaling-systems/labelling-automated-builds-on-docker-hub-f3d073fb8e1
# - https://docs.docker.com/docker-cloud/builds/advanced/#override-build-test-or-push-commands
ARG BUILD_DATE
ARG VCS_REF
ARG DOCKER_TAG

# cf.: http://label-schema.org/rc1/
LABEL author="Awesome Incremented"\ 
  org.label-schema.build-date="${BUILD_DATE}" \
  org.label-schema.name="awesomeinc/angular-cli" \
  org.label-schema.description="An image for building angular applications" \
  org.label-schema.usage="https://github.com/awesome-inc/angular-cli/blob/master/README.md" \
  org.label-schema.url="https://hub.docker.com/r/awesomeinc/angular-cli" \
  org.label-schema.vcs-url="https://github.com/awesome-inc/angular-cli" \
  org.label-schema.vcs-ref="${VCS_REF}" \
  org.label-schema.vendor="Awesome Inc" \
  org.label-schema.version="${DOCKER_TAG}" \
  org.label-schema.schema-version="1.0" \
  org.label-schema.docker.cmd="docker run awesomeinc/angular-cli:${DOCKER_TAG}"
# TODO: even more labels...


ENV NPM_CONFIG_LOGLEVEL warn

ARG NG_CLI_VERSION=latest
RUN yarn global add @angular/cli@$NG_CLI_VERSION && rm -rf $(yarn cache dir)
