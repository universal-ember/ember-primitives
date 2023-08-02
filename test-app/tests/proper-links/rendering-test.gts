/** eslint-disable ember/no-shadow-route-definition */
import Router from '@ember/routing/router';
import { click, visit } from '@ember/test-helpers';
import { hbs } from 'ember-cli-htmlbars';
import { module, test } from 'qunit';
import { setupApplicationTest } from 'ember-qunit';

import { properLinks } from 'ember-primitives/proper-links';

import type Owner from '@ember/owner';
import type RouterService from '@ember/routing/router-service';

function setupRouting(
  owner: Owner,
  map: Parameters<(typeof Router)['map']>[0],
  options?: { rootURL: string }
) {
  @properLinks
  class TestRouter extends Router {
    rootURL = options?.rootURL ?? '/';
  }

  TestRouter.map(map);

  owner.register('router:main', TestRouter);

  // eslint-disable-next-line ember/no-private-routing-service
  let iKnowWhatIMDoing = owner.lookup('router:main');

  // We need a public testing API for this sort of stuff
  (iKnowWhatIMDoing as any).setupRouter();
}

function getRouter(owner: Owner) {
  return owner.lookup('service:router') as RouterService;
}

module('@properLinks', function (hooks) {
  setupApplicationTest(hooks);

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

    await click('[href="/foo"]');

    assert.strictEqual(router.currentURL, '/foo');

    await click('[href="/bar"]');

    assert.strictEqual(router.currentURL, '/bar');
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
    await this.pauseTest();

    assert.dom('a').exists({ count: 2 });

    let router = getRouter(this.owner);

    assert.strictEqual(router.currentURL, '/');

    await click('[href="/the-root/foo"]');

    assert.strictEqual(router.currentURL, '/foo');

    await click('[href="/the-root/bar"]');

    assert.strictEqual(router.currentURL, '/bar');
  });
});
