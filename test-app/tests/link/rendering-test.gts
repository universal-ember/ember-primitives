import { click, visit } from '@ember/test-helpers';
import { hbs } from 'ember-cli-htmlbars';
import { module, test } from 'qunit';
import { setupApplicationTest } from 'ember-qunit';

import { setupRouting } from 'ember-primitives/test-support';

module('<Link />', function (hooks) {
  setupApplicationTest(hooks);

  test('[data-active] works', async function (assert) {
    setupRouting(this.owner, function () {
      this.route('foo');
      this.route('bar');
    });

    this.owner.register(
      'template:application',
      hbs`
      <Link @href="/foo">Foo</Link>
      <Link @href="/bar">Bar</Link>
      <Link @href="/">Home</Link>
    `,
    );

    await visit('/');

    assert.dom('a').exists({ count: 3 });
    assert.dom('[data-active]').exists({ count: 1 });

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

  test('[data-active] works with nested paths', async function (assert) {
    setupRouting(this.owner, function () {
      this.route('foo', function () {
        this.route('a');
        this.route('b');
      });
    });

    this.owner.register(
      'template:application',
      hbs`
      <Link @href="/foo/a">a</Link>
      <Link @href="/foo/b">b</Link>
      <Link @href="/foo">Foo Home</Link>
    `,
    );

    await visit('/');

    assert.dom('a').exists({ count: 3 });
    assert.dom('[data-active]').exists({ count: 0 });

    await click('a[href="/foo"]');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('Foo Home');

    await click('a[href="/foo/a"]');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('a');

    await click('a[href="/foo/b"]');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('b');

    await click('a[href="/foo"]');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('Foo Home');
  });

  test('[data-active] with a custom rootURL', async function (assert) {
    setupRouting(
      this.owner,
      function () {
        this.route('foo');
        this.route('bar');
      },
      { rootURL: '/some-root' },
    );

    this.owner.register(
      'template:application',
      hbs`
      <Link @href="/some-root/foo">Foo</Link>
      <Link @href="/some-root/bar">Bar</Link>
      <Link @href="/some-root/">Home</Link>
    `,
    );

    await visit('/');

    assert.dom('a').exists({ count: 3 });
    assert.dom('[data-active]').exists({ count: 1 });

    await click('a[href="/some-root/foo"]');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('Foo');

    await click('a[href="/some-root/bar"]');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('Bar');

    await click('a[href="/some-root/"]');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('Home');
  });

  test('[data-active] work with all query params', async function (assert) {
    setupRouting(this.owner, function () {
      this.route('foo');
      this.route('bar');
    });

    this.owner.register(
      'template:application',
      hbs`
      <Link id="one" @href="/foo?hello=2&there=3" @includeActiveQueryParams={{true}}>One</Link>
      <Link id="two" @href="/foo?hello=1&there=4" @includeActiveQueryParams={{true}}>Two</Link>
    `,
    );

    await visit('/');

    assert.dom('a').exists({ count: 2 });
    assert.dom('[data-active]').exists({ count: 0 });

    await click('#one');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('One');

    await click('#two');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('Two');

    await click('#one');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('One');
  });

  test('[data-active] work with some query params', async function (assert) {
    setupRouting(this.owner, function () {
      this.route('foo');
      this.route('bar');
    });

    this.owner.register(
      'template:application',
      hbs`
      <Link id="one" @href="/foo?hello=2&there=3" @includeActiveQueryParams={{array "hello"}}>One</Link>
      <Link id="two" @href="/foo?hello=1&there=3" @includeActiveQueryParams={{array "hello"}}>Two</Link>
    `,
    );

    await visit('/');

    assert.dom('a').exists({ count: 2 });
    assert.dom('[data-active]').exists({ count: 0 });

    await click('#one');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('One');

    await click('#two');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('Two');

    await click('#one');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('One');
  });

  test('[data-active] work with dynamic segments', async function (assert) {
    setupRouting(this.owner, function () {
      this.route('foo', { path: '/foo/:id' });
    });

    this.owner.register(
      'template:application',
      hbs`
      <Link id="one" @href="/foo/1">One</Link>
      <Link id="two" @href="/foo/2">Two</Link>
    `,
    );

    await visit('/');

    assert.dom('a').exists({ count: 2 });
    assert.dom('[data-active]').exists({ count: 0 });

    await click('#one');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('One');

    await click('#two');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('Two');

    await click('#one');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('One');
  });
});
