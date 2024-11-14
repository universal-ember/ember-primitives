'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');

const { maybeEmbroider } = require('@embroider/test-setup');

module.exports = async function (defaults) {
  const app = new EmberApp(defaults, {});

  return maybeEmbroider(app);
};
