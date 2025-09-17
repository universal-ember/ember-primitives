/* eslint-disable @typescript-eslint/no-non-null-assertion */
import Component from '@glimmer/component';
import Controller from '@ember/controller';
import { assert as debugAssert } from '@ember/debug';
import { hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { LinkTo } from '@ember/routing';
import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';
import { click, find, settled, visit, waitUntil } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupApplicationTest } from 'ember-qunit';

import { scrollToHash, uiSettled } from 'ember-primitives/polyfill/anchor-hash-targets';

import { setupRouter } from './-helpers.ts';

import type RouterService from '@ember/routing/router-service';

module('anchor-hash-target', function (hooks) {
  setupApplicationTest(hooks);

  hooks.beforeEach(() => {
    location.hash = '';
  });
  hooks.afterEach(() => {
    location.hash = '';
  });

  // TODO: PR this to qunit-dom as assort.dom(element).isInView();
  //       assert.dom().isVisible does not check if the element is within the viewport
  function isVisible(element: null | Element, parent: Element) {
    if (!element) return false;

    const bounds = element.getBoundingClientRect();
    const parentBounds = parent.getBoundingClientRect();

    return (
      bounds.top >= parentBounds.top &&
      bounds.left >= parentBounds.left &&
      bounds.right <= parentBounds.right &&
      bounds.bottom <= parentBounds.bottom
    );
  }

  module('linking with hashes', function (_hooks) {
    test('in-page-links can be scrolled to with native anchors', async function (assert) {
      this.owner.register(
        'template:application',
        <template>
          <a id="first-link" href="#first">first</a>
          <a id="second-link" href="#second">first</a>

          <h1 id="first">first!</h1>
          <div style="height: 100vh;"></div>

          <h1 id="second">second!</h1>
          <div style="height: 100vh;"></div>
        </template>
      );

      await visit('/');

      const container = document.querySelector('#ember-testing-container');
      const first = find('#first');
      const second = find('#second');

      debugAssert(`Expected all test elements to exist`, container && first && second);

      assert.true(isVisible(first, container), 'first header is visible');
      assert.false(isVisible(second, container), 'second header is not visible');
      assert.equal(location.hash, '', 'initially, has no hash');

      await click('#second-link');

      assert.false(isVisible(first, container), 'first header is not visible');
      assert.true(isVisible(second, container), 'second header is visible');
      assert.equal(location.hash, '#second', 'clicked hash appears in URL');

      await click('#first-link');

      assert.true(isVisible(first, container), 'first header is visible');
      assert.false(isVisible(second, container), 'second header is not visible');
      assert.equal(location.hash, '#first', 'clicked hash appears in URL');
    });

    test('in-page-links can be scrolled to with custom links', async function (assert) {
      class TestApplication extends Component {
        handleClick = (event: MouseEvent) => {
          event.preventDefault();

          debugAssert(
            `Expected event to be from an anchor tag`,
            event.target instanceof HTMLAnchorElement
          );

          const [, hash] = event.target.href.split('#');

          scrollToHash(hash!);
        };

        <template>
          <a id="first-link" href="#first" {{on "click" this.handleClick}}>first</a>
          <a id="second-link" href="#second" {{on "click" this.handleClick}}>first</a>

          <h1 id="first">first!</h1>
          <div style="height: 100vh;"></div>

          <h1 id="second">second!</h1>
          <div style="height: 100vh;"></div>
        </template>
      }

      this.owner.register('template:application', TestApplication);

      await visit('/');

      const container = document.querySelector('#ember-testing-container');
      const first = find('#first');
      const second = find('#second');

      debugAssert(`Expected all test elements to exist`, container && first && second);

      assert.true(isVisible(first, container), 'first header is visible');
      assert.false(isVisible(second, container), 'second header is not visible');
      assert.equal(location.hash, '', 'initially, has no hash');

      await click('#second-link');
      await scrollSettled();

      assert.false(isVisible(first, container), 'first header is not visible');
      assert.true(isVisible(second, container), 'second header is visible');
      assert.equal(location.hash, '#second', 'clicked hash appears in URL');

      await click('#first-link');
      await scrollSettled();

      assert.true(isVisible(first, container), 'first header is visible');
      assert.false(isVisible(second, container), 'second header is not visible');
      assert.equal(location.hash, '#first', 'clicked hash appears in URL');
    });
  });

  module('with transitions', function (hooks) {
    setupRouter(hooks, {
      map: function () {
        this.route('foo');
        this.route('bar');
      },
    });

    test('transitioning only via query params does not break things', async function (assert) {
      class TestApplication extends Controller {
        queryParams = ['test'];
        test = false;
      }
      class Index extends Component {
        @service declare router: RouterService;

        <template>
          <out>
            qp:
            {{! @glint-expect-error }}
            {{this.router.currentRoute.queryParams.test}}
          </out>
        </template>
      }

      this.owner.register('controller:application', TestApplication);
      this.owner.register(
        'template:application',
        <template>
          <LinkTo id="foo" @query={{hash test="foo"}}>foo</LinkTo>
          <LinkTo id="default" @query={{hash test=false}}>default</LinkTo>
          {{outlet}}
        </template>
      );
      this.owner.register('template:index', Index);

      const router = this.owner.lookup('service:router');

      await visit('/');
      assert.dom('out').hasText('qp:');

      await click('#foo');
      assert.dom('out').hasText('qp: foo');

      await click('#default');
      assert.dom('out').hasText('qp:');

      router.transitionTo({ queryParams: { test: 'foo' } });
      await settled();
      assert.dom('out').hasText('qp: foo');

      router.transitionTo({ queryParams: { test: false } });
      await settled();
      assert.dom('out').hasText('qp: false');
    });

    test('cross-page-Llinks are properly scrolled to', async function (assert) {
      this.owner.register(
        'template:foo',
        <template>
          <h1 id="foo-first">first!</h1>
          <div style="height: 100vh;"></div>

          <h1 id="foo-second">second!</h1>
          <div style="height: 100vh;"></div>
        </template>
      );

      this.owner.register(
        'template:bar',
        <template>
          <h1 id="bar-first">first!</h1>
          <div style="height: 100vh;"></div>

          <h1 id="bar-second">second!</h1>
          <div style="height: 100vh;"></div>
        </template>
      );

      const router = this.owner.lookup('service:router');
      const container = document.querySelector('#ember-testing-container');

      debugAssert(`Expected all test elements to exist`, container);

      router.transitionTo('/foo');
      await uiSettled(this.owner);

      assert.true(isVisible(find('#foo-first'), container), 'first header is visible');
      assert.false(isVisible(find('#foo-second'), container), 'second header is not visible');
      assert.equal(location.hash, '', 'initially, has no hash');

      router.transitionTo('/bar#bar-second');
      await uiSettled(this.owner);
      await scrollSettled();

      assert.false(isVisible(find('#bar-first'), container), 'first header is not visible');
      assert.true(isVisible(find('#bar-second'), container), 'second header is visible');
      assert.equal(location.hash, '#bar-second', 'clicked hash appears in URL');

      router.transitionTo('/foo#foo-second');
      await uiSettled(this.owner);
      await scrollSettled();

      assert.false(isVisible(find('#foo-first'), container), 'first header is not visible');
      assert.true(isVisible(find('#foo-second'), container), 'second header is visible');
      assert.equal(location.hash, '#foo-second', 'clicked hash appears in URL');
    });
  });

  // https://github.com/CrowdStrike/ember-url-hash-polyfill/issues/118
  test('transition to route with loading sub state is properly handled', async function (assert) {
    this.owner.register(
      'template:application',
      <template>
        <h1 id="first">first!</h1>
        <div style="height: 100vh;"></div>

        <h1 id="second">second!</h1>
        <div style="height: 100vh;"></div>
      </template>
    );

    this.owner.register('template:application-loading', <template>Loading...</template>);

    class ApplicationRoute extends Route {
      model() {
        return new Promise(function (resolve) {
          // Keep the timeout > to addon/index.ts "MAX_TIMEOUT" to make this test accurate
          setTimeout(resolve, 4000);
        });
      }
    }

    this.owner.register('route:application', ApplicationRoute);

    await visit('/#second');
    await scrollSettled();

    const container = document.querySelector('#ember-testing-container');
    const first = find('#first');
    const second = find('#second');

    debugAssert(`Expected all test elements to exist`, container && first && second);

    await waitUntil(() => isVisible(second, container), {
      timeoutMessage: 'second header is visible',
    });

    assert.equal(location.hash, '#second', 'hash appears in URL');
  });
});

async function scrollSettled() {
  // wait for previous stuff to finish
  await settled();

  const timeout = 200; // ms;
  const start = new Date().getTime();

  await Promise.race([
    new Promise((resolve) => setTimeout(resolve, 1000)),
    // scrollIntoView does not trigger scroll events
    new Promise((resolve) => {
      const interval = setInterval(() => {
        const now = new Date().getTime();

        if (now - start >= timeout) {
          clearInterval(interval);

          return resolve(now);
        }
      }, 10);
    }),
  ]);

  await settled();
}
