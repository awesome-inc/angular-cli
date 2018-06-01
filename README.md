# angular-cli

[![Build status](https://travis-ci.org/awesome-inc/angular-cli.svg?branch=master)](https://travis-ci.org/awesome-inc/angular-cli/)
[![GitHub issues](https://img.shields.io/github/issues/awesome-inc/angular-cli.svg "GitHub issues")](https://github.com/awesome-inc/angular-cli)
[![GitHub stars](https://img.shields.io/github/stars/awesome-inc/angular-cli.svg "GitHub stars")](https://github.com/awesome-inc/angular-cli)

A Node image containing a global installation of [@angular/cli](https://github.com/angular/angular-cli) to build [Angular](https://angular.io/) applications in a container.

[![dockeri.co](http://dockeri.co/image/awesomeinc/angular-cli)](https://hub.docker.com/r/awesomeinc/angular-cli/)

## Usage

A usage example is given in [./myapp/Dockerfile](./myapp/Dockerfile).

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
