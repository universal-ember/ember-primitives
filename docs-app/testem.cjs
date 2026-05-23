'use strict';

if (typeof module !== 'undefined') {
  const { a11yMiddleware } = require('ember-a11y-testing/middleware');

  module.exports = {
    test_page: 'tests/index.html?hidepassed',
    cwd: 'dist',
    middleware: [a11yMiddleware],
    disable_watching: true,
    launch_in_ci: ['Chrome'],
    launch_in_dev: ['Chrome'],
    browser_start_timeout: 120,
    // The Pages a11y test walks every docs page and runs axe-core
    // three times per page (default/dark/light theme). On pages with
    // very large demos (IncrementalEach renders 20k rows) a single
    // axe audit can keep the browser CPU-bound for over two minutes
    // on the CI runner. Give the disconnect timeout enough headroom
    // that a slow audit isn't mistaken for a dead browser.
    browser_disconnect_timeout: 240,
    browser_args: {
      Chrome: {
        ci: [
          // --no-sandbox is needed when running Chrome inside a container
          process.env.CI ? '--no-sandbox' : null,
          '--headless=new',
          '--disable-dev-shm-usage',
          '--disable-software-rasterizer',
          '--mute-audio',
          '--remote-debugging-port=0',
          '--window-size=1440,900',
        ].filter(Boolean),
      },
    },
  };
}
