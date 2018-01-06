# angular-cli

[![dockeri.co](http://dockeri.co/image/awesomeinc/angular-cli)](https://hub.docker.com/r/awesomeinc/angular-cli/)

A Node image containing a global installation of [@angular/cli](https://github.com/angular/angular-cli) to build [Angular](https://angular.io/) applications in a container.

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
So you should add it as dev dependency in your `package.json` like this

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
        '--remote-debugging-port=9222',
        '--window-size=800,600'
      ] : []
    }
  },
```

As of now, there still seems to be a bug [angular/protractor/issues/4601](https://github.com/angular/protractor/issues/4601) 
which cannot be easily worked around. The error message goes something like this

```console
webpack: Compiled successfully.
[10:52:54] I/file_manager - creating folder /build/node_modules/webdriver-manager/selenium
[10:52:57] I/update - chromedriver: unzipping chromedriver_2.34.zip
[10:52:57] I/update - chromedriver: setting permissions to 0755 for /build/node_modules/webdriver-manager/selenium/chromedriver_2.34
[10:52:57] I/launcher - Running 1 instances of WebDriver
[10:52:57] I/direct - Using ChromeDriver directly...
[10:52:57] E/launcher - spawn /build/node_modules/webdriver-manager/selenium/chromedriver_2.34 ENOENT
[10:52:57] E/launcher - Error: spawn /build/node_modules/webdriver-manager/selenium/chromedriver_2.34 ENOENT
    at _errnoException (util.js:1019:11)
    at Process.ChildProcess._handle.onexit (internal/child_process.js:192:19)
    at onErrorNT (internal/child_process.js:374:16)
    at _combinedTickCallback (internal/process/next_tick.js:138:11)
    at process._tickCallback (internal/process/next_tick.js:180:9)
[10:52:57] E/launcher - Process exited with error code 199
error Command failed with exit code 199.
info Visit https://yarnpkg.com/en/docs/cli/run for documentation about this command.
ERROR: Service 'myapp' failed to build: The command '/bin/sh -c yarn run e2e' returned a non-zero code: 1
```

This is addressed in [issues/5](https://github.com/awesome-inc/angular-cli/issues/5)