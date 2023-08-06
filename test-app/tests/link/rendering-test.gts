import { click, visit } from '@ember/test-helpers';
import { hbs } from 'ember-cli-htmlbars';
import { module, test } from 'qunit';
import { setupApplicationTest } from 'ember-qunit';

import { setupRouting } from 'ember-primitives/test-support';


module('<Link />', function (hooks) {
  setupApplicationTest(hooks);

  test('[data-active] it works', async function (assert) {
    setupRouting(this.owner, function() {
      this.route('foo');
      this.route('bar');
    });

    this.owner.register('template:application', hbs`
      <Link @href="/foo">Foo</Link>
      <Link @href="/bar">Bar</Link>
      <Link @href="/">Home</Link>
    `);

    await visit('/');

    assert.dom('a').exists({ count: 3 });
    assert.dom('[data-active]').exists({ count: 0 });

    await click('a[href="/foo"]');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('Foo');

    await click('a[href="/bar"]');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('Bar');

    await click('a[href="/"]');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('Home');
  });

  // texst('it works with nested paths', async function (assert) {
  // });

  // texst('it works with a custom rootURL', async function (assert) {
  // });

  // texst('it works with query params', async function (assert) {
  // });
});
