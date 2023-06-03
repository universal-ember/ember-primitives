import { findAll, visit } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupApplicationTest } from 'ember-qunit';

module('Application | Pages', function (hooks) {
  setupApplicationTest(hooks);

  test('Visit each page in the nav', async function (assert) {
    await visit('/');

    let links = findAll('nav a');

    assert.expect(links.length);

    for (let link of links) {
      await visit(link.href);
      assert.ok(true, `no a11y errors found for ${link.href}`);
    }
  });
});
