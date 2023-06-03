import { setApplication } from '@ember/test-helpers';
import * as QUnit from 'qunit';
import { setup } from 'qunit-dom';
import { start } from 'ember-qunit';

import Application from 'docs-app/app';
import config from 'docs-app/config/environment';

setApplication(Application.create(config.APP));

setup(QUnit.assert);

QUnit.config.urlConfig.push({
  id: 'debugA11yAudit',
  label: 'Log a11y violations',
});

(async function loadManifest() {
  let response = await fetch('/docs/manifest.json');
  let json = await response.json();
  let pages = json.list.flat();

  // The accessibility page deliberately
  // has violations for demonstration
  (window as any).__pages__ = pages.filter(
    (page: { path: string }) => !page.path.includes('accessibility')
  );
  start();
})();
