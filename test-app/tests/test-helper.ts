import 'qunit-theme-ember/qunit.css';

import {
  currentRouteName,
  currentURL,
  getSettledState,
  pauseTest,
  setApplication,
} from '@ember/test-helpers';
import { getPendingWaiterState } from '@ember/test-waiters';
import * as QUnit from 'qunit';
import { setup as setupExtras } from 'qunit-assertions-extra';
import { setup } from 'qunit-dom';
import { start as qunitStart } from 'ember-qunit';

import Application from 'test-app/app';
import config from 'test-app/config/environment';

Object.assign(window, {
  getSettledState,
  getPendingWaiterState,
  currentURL,
  currentRouteName,
  pauseTest,
});

export function start() {
  setApplication(Application.create(config.APP));

  setup(QUnit.assert);
  setupExtras(QUnit.assert);

  qunitStart();
}
