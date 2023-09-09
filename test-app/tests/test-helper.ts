import { currentRouteName, currentURL, getSettledState, setApplication } from '@ember/test-helpers';
import { getPendingWaiterState } from '@ember/test-waiters';
import * as QUnit from 'qunit';
import { setup as setupExtras } from 'qunit-assertions-extra';
import { setup } from 'qunit-dom';
import { start } from 'ember-qunit';

import Application from 'test-app/app';
import config from 'test-app/config/environment';

setApplication(Application.create(config.APP));

setup(QUnit.assert);
setupExtras(QUnit.assert);

Object.assign(window, { getSettledState, getPendingWaiterState, currentURL, currentRouteName });

start();
