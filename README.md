# angular-cli

A docker build example for building [Angular](https://angular.io/) applications in a container.

**Deprecation Notice!**

[![Docker build](https://img.shields.io/docker/build/awesomeinc/angular-cli.svg?logo=docker)](https://hub.docker.com/r/awesomeinc/angular-cli/builds/)
[![Docker automated](https://img.shields.io/docker/automated/awesomeinc/angular-cli.svg?logo=docker)](https://travis-ci.org/awesome-inc/angular-cli/)
[![Docker stars](https://img.shields.io/docker/stars/awesomeinc/angular-cli.svg)](https://travis-ci.org/awesome-inc/angular-cli/)
[![Docker pulls](https://img.shields.io/docker/pulls/awesomeinc/angular-cli.svg?logo=docker)](https://travis-ci.org/awesome-inc/angular-cli/)

[![Build status](https://img.shields.io/travis/awesome-inc/angular-cli.svg?logo=travis)](https://travis-ci.org/awesome-inc/angular-cli/)
[![GitHub issues](https://img.shields.io/github/issues/awesome-inc/angular-cli.svg?logo=github "GitHub issues")](https://github.com/awesome-inc/angular-cli)
[![GitHub stars](https://img.shields.io/github/stars/awesome-inc/angular-cli.svg?logo=github "GitHub stars")](https://github.com/awesome-inc/angular-cli)

## Usage

A usage example is given in [./myapp/Dockerfile](./myapp/Dockerfile).

## Build

Current build example using `docker-compose`

```shell
$ docker-compose build myapp
Building myapp
failed to get console mode for stdout: The handle is invalid.
[+] Building 366.0s (19/19) FINISHED
 => [internal] load build definition from Dockerfile                       0.0s
 => => transferring dockerfile: 642B                                       0.0s
 => [internal] load .dockerignore                                          0.0s
 => => transferring context: 35B                                           0.0s
 => [internal] load metadata for docker.io/library/nginx:1.19.8-alpine     2.1s
 => [internal] load metadata for docker.io/zenika/alpine-chrome:with-node  2.1s
 => [auth] library/nginx:pull token for registry-1.docker.io               0.0s
 => [auth] zenika/alpine-chrome:pull token for registry-1.docker.io        0.0s
 => [internal] load build context                                          0.1s
 => => transferring context: 2.02kB                                        0.0s
 => CACHED [stage-2 1/2] FROM docker.io/library/nginx:1.19.8-alpine@sha25  0.0s
 => CACHED [base 1/2] FROM docker.io/zenika/alpine-chrome:with-node@sha25  0.0s
 => [base 2/2] RUN apk add --no-cache chromium-chromedriver                3.1s
 => [build 1/7] WORKDIR /usr/src/app                                       0.1s
 => [build 2/7] COPY [package*.json, ./]                                   0.1s
 => [build 3/7] RUN npm ci                                                69.6s
 => [build 4/7] COPY [./, ./]                                              0.1s
 => [build 5/7] RUN npm run test                                         125.1s
 => [build 6/7] RUN npm run e2e                                           60.7s
 => [build 7/7] RUN npm run build                                        104.7s
 => [stage-2 2/2] COPY --from=build /usr/src/app/dist/myapp /usr/share/ng  0.1s
 => exporting to image                                                     0.1s
 => => exporting layers                                                    0.0s
 => => writing image sha256:7fa8d665ae622b564778ee2bc1eb0e4956b2c55901139  0.0s
 => => naming to docker.io/library/angular-cli_myapp                       0.0s
Successfully built 7fa8d665ae622b564778ee2bc1eb0e4956b2c5590113978649309163e822a43a
```

### Unit Testing (Karma)

To make the usual `ng test` work inside docker the relevant tweak is to use
a custom launcher that adds some headless parameters when starting chromium.

Add the following to your `karma.conf.js`

```js
const isDocker = require('is-docker')();
...
    // cf.: https://hackernoon.com/running-karma-tests-with-headless-chrome-inside-docker-ae4aceb06ed3
    browsers: isDocker ? ['ChromeDocker'] : ['Chrome'],
    customLaunchers: {
      ChromeDocker: {
        base: 'ChromeHeadless',
        flags: [
          '--headless',
          '--disable-gpu',
          '--no-sandbox',
          '--remote-debugging-port=9222',
          '--window-size=800,600'
        ]
      }
    },

```

We used [is-docker](https://www.npmjs.com/package/is-docker) to detect whether we are running inside Docker.
So you should add it as development dependency in your `package.json` like this

```json
    "is-docker": "^1.1.0"
```

### End-To-End Testing (Protractor)

For `ng e2e` tweak your `protractor.conf.js` like this

```js
const isDocker = require('is-docker')();
...
  capabilities: {
    'browserName': 'chrome',

    // Run tests in a headless Chrome
    // https://github.com/angular/protractor/blob/master/docs/browser-setup.md#using-headless-chrome
    chromeOptions: {
      args: isDocker ? [
        // IMPORTANT: Required flag for running Chrome in unprivileged Docker,
        // see https://github.com/karma-runner/karma-chrome-launcher/issues/125#issuecomment-312668593
        '--headless',
        '--disable-gpu',
        '--no-sandbox',
        '--window-size=800,600'
      ] : []
    }
  },
  // Use pre-installed chromedriver (alpine)
  chromeDriver: isDocker ? '/usr/bin/chromedriver' : null,
```
