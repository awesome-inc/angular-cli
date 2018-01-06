// Protractor configuration file, see link for more information
// https://github.com/angular/protractor/blob/master/lib/config.ts

const { SpecReporter } = require('jasmine-spec-reporter');
const isDocker = require('is-docker')();

exports.config = {
  allScriptsTimeout: 11000,
  specs: [
    './e2e/**/*.e2e-spec.ts'
  ],
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
  directConnect: true,
  baseUrl: 'http://localhost:4200/',
  framework: 'jasmine',
  jasmineNodeOpts: {
    showColors: true,
    defaultTimeoutInterval: 30000,
    print: function() {}
  },
  onPrepare() {
    require('ts-node').register({
      project: 'e2e/tsconfig.e2e.json'
    });
    jasmine.getEnv().addReporter(new SpecReporter({ spec: { displayStacktrace: true } }));
  }
};
