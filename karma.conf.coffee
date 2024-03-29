# Karma configuration
# Generated on Mon Feb 03 2014 11:22:29 GMT+1100 (EST)
module.exports = (config) ->
  config.set

    # base path, that will be used to resolve files and exclude
    basePath: ""

    # frameworks to use
    frameworks: ["mocha", "chai"]

    # list of files / patterns to load in the browser
    files: [
      "source/lib/jquery/jquery-1.11.0.min.js"
      "source/lib/angularjs/angular.min.js"
      "source/lib/angularjs/angular-animate.min.js"
      "source/lib/angularjs/angular-route.min.js"
      "source/lib/angularjs/angular-mocks.js"
      "source/lib/angular-ui/ui-bootstrap-tpls-0.10.0.min.js"
      "source/frameworks/timeline-chap-links/timeline.js"
      "source/lib/sinon/*.js"
      "source/lib/chai/*.js"
      "source/lib/moment/*.js"
      "source/javascripts/**"
      "frontend_specs/**"
    ]

    # list of files to exclude
    exclude: [
      "source/javascripts/site.coffee"
    ]

    # test results reporter to use
    # possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'
    reporters: ["progress", "growl"]

    # web server port
    port: 9876

    # enable / disable colors in the output (reporters and logs)
    colors: true

    # level of logging
    # possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO

    # enable / disable watching file and executing tests whenever any file changes
    autoWatch: true

    # Start these browsers, currently available:
    # - Chrome
    # - ChromeCanary
    # - Firefox
    # - Opera (has to be installed with `npm install karma-opera-launcher`)
    # - Safari (only Mac; has to be installed with `npm install karma-safari-launcher`)
    # - PhantomJS
    # - IE (only Windows; has to be installed with `npm install karma-ie-launcher`)
    browsers: ["PhantomJS"]

    # If browser does not capture in given timeout [ms], kill it
    captureTimeout: 60000

    # Continuous Integration mode
    # if true, it capture browsers, run tests and exit
    singleRun: false
