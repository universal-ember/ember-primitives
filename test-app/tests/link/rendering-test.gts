import { array } from '@ember/helper';
import { click, visit } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupApplicationTest } from 'ember-qunit';

import Link from 'ember-primitives/components/link';
import Route from 'ember-route-template';

import { setupRouting } from 'ember-primitives/test-support';

module('<Link />', function (hooks) {
  setupApplicationTest(hooks);

  test('[data-active] works', async function (assert) {
    setupRouting(this.owner, function () {
      this.route('foo');
      this.route('bar');
    });

    this.owner.register(
      'template:application', Route(
        <template>
          <Link @href="/foo">Foo</Link>
          <Link @href="/bar">Bar</Link>
          <Link @href="/">Home</Link>
        </template>
      )
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
      'template:application', Route(
        <template>
          <Link @href="/foo/a">a</Link>
          <Link @href="/foo/b">b</Link>
          <Link @href="/foo">Foo Home</Link>
          <Link @href="/foo" @activeOnSubPaths={{true}} data-test-subpath>Foo Home Active On Subpaths</Link>
        </template>
      )
    );

    await visit('/');

    assert.dom('a').exists({ count: 4 });
    assert.dom('[data-active]').exists({ count: 0 });

    await click('a[href="/foo"]');

    assert.dom('[data-active]').exists({ count: 2 });
    assert.dom('[data-active]').hasText('Foo Home');
    assert.dom('[data-test-subpath][data-active]').exists();

    await click('a[href="/foo/a"]');

    assert.dom('[data-active]').exists({ count: 2 });
    assert.dom('[data-active]').hasText('a');
    assert.dom('[data-test-subpath][data-active]').exists();

    await click('a[href="/foo/b"]');

    assert.dom('[data-active]').exists({ count: 2 });
    assert.dom('[data-active]').hasText('b');
    assert.dom('[data-test-subpath][data-active]').exists();

    await click('a[href="/foo"]');

    assert.dom('[data-active]').exists({ count: 2 });
    assert.dom('[data-active]').hasText('Foo Home');
    assert.dom('[data-test-subpath][data-active]').exists();
  });

  test('[data-active] with a custom rootURL', async function (assert) {
    setupRouting(
      this.owner,
      function () {
        this.route('foo');
        this.route('bar');
      },
      { rootURL: '/some-root' }
    );

    this.owner.register(
      'template:application', Route(
        <template>
          <Link @href="/some-root/foo">Foo</Link>
          <Link @href="/some-root/bar">Bar</Link>
          <Link @href="/some-root/">Home</Link>
        </template>
      )
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
      'template:application', Route(
        <template>
          <Link id="one" @href="/foo?hello=2&there=3" @includeActiveQueryParams={{true}}>One</Link>
          <Link id="two" @href="/foo?hello=1&there=4" @includeActiveQueryParams={{true}}>Two</Link>
        </template>
      )
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
      'template:application', Route(
        <template>
          <Link id="one" @href="/foo?hello=2&there=3" @includeActiveQueryParams={{array "hello"}}>One</Link>
          <Link id="two" @href="/foo?hello=1&there=3" @includeActiveQueryParams={{array "hello"}}>Two</Link>
        </template>
      )
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

  test('[data-active] work with some params and activeOnSubPaths', async function (assert) {
    setupRouting(this.owner, function () {
      this.route('foo', function () {
        this.route('bar');
      });
      this.route('bar');
    });

    this.owner.register(
      'template:application', Route(
        <template>
          <Link id="one" @href="/foo?hello=2&there=3" @includeActiveQueryParams={{array "hello"}} @activeOnSubPaths={{true}} data-test-subpath>One</Link>
          <Link id="one-child" @href="/foo/bar?hello=2&there=3" @includeActiveQueryParams={{array "hello"}} data-test-child>One Child</Link>
          <Link id="two" @href="/foo?hello=1&there=3" @includeActiveQueryParams={{array "hello"}}>Two</Link>
          <Link id="two-child" @href="/foo/bar?hello=1&there=3" @includeActiveQueryParams={{array "hello"}}>Two Child</Link>
        </template>
      )
    );

    await visit('/');

    assert.dom('a').exists({ count: 4 });
    assert.dom('[data-active]').exists({ count: 0 });

    await click('#one');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('One');

    await click('#one-child');

    assert.dom('[data-active]').exists({ count: 2 });
    assert.dom('[data-active][data-test-child]').exists({ count: 1 });
    assert.dom('[data-active][data-test-subpath]').exists({ count: 1 });

    await click('#two');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('Two');

    await click('#two-child');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('Two Child');

    await click('#one');

    assert.dom('[data-active]').exists({ count: 1 });
    assert.dom('[data-active]').hasText('One');
  });

  test('[data-active] work with dynamic segments', async function (assert) {
    setupRouting(this.owner, function () {
      this.route('foo', { path: '/foo/:id' });
    });

    this.owner.register(
      'template:application', Route(
        <template>
          <Link id="one" @href="/foo/1">One</Link>
          <Link id="two" @href="/foo/2">Two</Link>
        </template>
      )
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
