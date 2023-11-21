import Route from '@ember/routing/route';
import { click, visit } from '@ember/test-helpers';
import { hbs } from 'ember-cli-htmlbars';
import { module, test } from 'qunit';
import { setupApplicationTest } from 'ember-qunit';

import { getRouter, setupRouting } from 'ember-primitives/test-support';

module('@properLinks', function (hooks) {
  setupApplicationTest(hooks);

  let assertVisit: (href: string) => Promise<void>;
  let assertCurrentURL: (href: string) => Promise<void>;

  hooks.beforeEach(function (assert) {
    assertCurrentURL = async (href: string) => {
      let router = getRouter(this.owner);

      assert.strictEqual(router.currentURL, href);
    };

    assertVisit = async (href: string) => {
      await click(`[href="${href}"]`);

      assertCurrentURL(href);
    };

    window.onbeforeunload = alert;
  });

  test('it works', async function (assert) {
    setupRouting(this.owner, function () {
      this.route('foo');
      this.route('bar');
    });

    this.owner.register(
      'template:application',
      hbs`
        <a href="/foo">Foo</a>
        <a href="/bar">Bar</a>
      `
    );

    await visit('/');

    assert.dom('a').exists({ count: 2 });

    let router = getRouter(this.owner);

    assert.strictEqual(router.currentURL, '/');

    await assertVisit('/foo');
    await assertVisit('/bar');
  });

  test('it works with nested paths', async function (assert) {
    setupRouting(this.owner, function () {
      this.route('foo', function () {
        this.route('foo-foo');
      });
      this.route('bar');
    });

    this.owner.register(
      'template:application',
      hbs`
        <a href="/foo">Foo</a>
        <a href="/foo/foo-foo">Foo Foo</a>
        <a href="/bar">Bar</a>
      `
    );

    await visit('/');

    assert.dom('a').exists({ count: 3 });

    let router = getRouter(this.owner);

    assert.strictEqual(router.currentURL, '/');

    await click('[href="/foo/foo-foo"]');

    assert.strictEqual(router.currentURL, '/foo/foo-foo');

    await click('[href="/bar"]');

    assert.strictEqual(router.currentURL, '/bar');
  });

  test('it works with a custom rootURL', async function (assert) {
    setupRouting(
      this.owner,
      function () {
        this.route('foo');
        this.route('bar');
      },
      { rootURL: '/the-root' }
    );

    this.owner.register(
      'template:application',
      hbs`
        <a href="/the-root/foo">Foo</a>
        <a href="/the-root/bar">Bar</a>
      `
    );

    await visit('/');

    assert.dom('a').exists({ count: 2 });

    let router = getRouter(this.owner);

    assert.strictEqual(router.currentURL, '/');

    await click('[href="/the-root/foo"]');

    assert.strictEqual(router.currentURL, '/foo');

    await click('[href="/the-root/bar"]');

    assert.strictEqual(router.currentURL, '/bar');
  });

  test('it works with query params', async function (assert) {
    setupRouting(this.owner, function () {
      this.route('foo');
      this.route('bar');
    });

    this.owner.register(
      'template:application',
      hbs`
        <a href="/foo?greeting='hello%20there'">Foo</a>
        <a href="/foo?greeting='general%20kenobi'">Foo</a>
        <a href="/bar">Bar</a>
      `
    );

    this.owner.register(
      'route:foo',
      class FooRoute extends Route {
        queryParams = { greeting: { refreshModel: true } };
      }
    );

    await visit('/');

    assert.dom('a').exists({ count: 3 });

    assertCurrentURL('/');
    await assertVisit("/foo?greeting='hello%20there'");
    await assertVisit('/bar');
    await assertVisit("/foo?greeting='general%20kenobi'");
  });
});
