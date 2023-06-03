import { findAll, settled, visit, waitUntil } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupApplicationTest } from 'ember-qunit';

import { colorScheme } from 'ember-primitives/color-scheme';

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

module('Application | Pages', function (hooks) {
  setupApplicationTest(hooks);

  test('Visit each page in the nav', async function (assert) {
    await visit('/');
    await waitUntil(() => findAll('nav a').length !== 0);

    let links = findAll('nav a');

    // the a11y page deliberately has violations on it
    links = links.filter((link) => !link.href.includes('accessibility'));

    assert.expect(links.length * 3);

    for (let link of links) {
      if (!('href' in link)) continue;

      let url = new URL(link.href);

      await visit(url.pathname);
      await checkA11y(assert, link.href, 'default');

      colorScheme.update('dark');
      await checkA11y(assert, link.href, 'dark');

      colorScheme.update('light');
      await checkA11y(assert, link.href, 'light');
    }
  });
});
