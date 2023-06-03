import { setApplication } from '@ember/test-helpers';
import * as QUnit from 'qunit';
import { setup } from 'qunit-dom';
import { start } from 'ember-qunit';
import {
  setupGlobalA11yHooks,
  DEFAULT_A11Y_TEST_HELPER_NAMES,
} from 'ember-a11y-testing';

import Application from 'docs-app/app';
import config from 'docs-app/config/environment';

setApplication(Application.create(config.APP));

setupGlobalA11yHooks(() => true, {
  // visit, click, + render tab, etc
  helpers: [...DEFAULT_A11Y_TEST_HELPER_NAMES, 'render', 'tab'],
});
setup(QUnit.assert);

start();
