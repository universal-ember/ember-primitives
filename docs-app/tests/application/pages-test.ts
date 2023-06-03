import { findAll, settled, visit, waitUntil } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupApplicationTest } from 'ember-qunit';

import { colorScheme } from 'ember-primitives/color-scheme';
import { remoteData } from 'ember-resources/util/remote-data';

import { a11yAudit } from 'ember-a11y-testing/test-support';

/**
 * a11yAudit halts tests, this gets around that
 */
async function checkA11y(assert: Assert, path: string, theme: string) {
  await settled();

  try {
    await a11yAudit();
    assert.ok(
      true,
      `no a11y errors found for ${path} using the ${theme} theme`
    );
  } catch (e) {
    assert.ok(
      false,
      `no a11y errors found for ${path} using the ${theme} theme` +
        `\n\n` +
        e.message
    );
  }
}

// eslint-disable-next-line qunit/no-async-module-callbacks
module('Application | Pages', function (hooks) {
  setupApplicationTest(hooks);

  for (let page of window.__pages__) {
    test(`${page.path}`, async function (assert) {
      assert.expect(3);

      let path = page.path.replace('.md', '');

      await visit(path);
      await waitUntil(() => findAll('nav a').length !== 0);
      await checkA11y(assert, path, 'default');

      colorScheme.update('dark');
      await checkA11y(assert, path, 'dark');

      colorScheme.update('light');
      await checkA11y(assert, path, 'light');
    });
  }
});
