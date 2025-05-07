/**
 * Tests originally from:
 * - https://github.com/ef4/ember-set-body-class/blob/master/tests/acceptance/test-bleed-test.js
 * - https://github.com/ef4/ember-set-body-class/blob/master/tests/acceptance/index-test.js
 */
import { click, fillIn, render, settled, visit } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupApplicationTest, setupRenderingTest } from 'ember-qunit';

import { bodyClass } from 'ember-primitives/helpers/body-class';
import { cell } from 'ember-resources';

module('bodyClass | CSS class bleeding between tests', function (hooks) {
  setupRenderingTest(hooks);

  test('sets a class', async function (assert) {
    assert.dom(document.body).hasNoClass('foo');

    await render(<template>{{bodyClass "foo"}}</template>);
    assert.dom(document.body).hasClass('foo');
  });

  test('ensures that the class is not set anymore', async function (assert) {
    assert.dom(document.body).hasNoClass('foo');
  });

  test('adds and removes the class when the helper is unrendered', async function (assert) {
    const show = cell(true);

    assert.dom(document.body).hasNoClass('foo');
    await render(
      <template>
        {{#if show.current}}
          {{bodyClass "foo"}}
        {{/if}}
      </template>
    );
    assert.dom(document.body).hasClass('foo');

    show.current = false;
    await settled();
    assert.dom(document.body).hasNoClass('foo');

    show.current = true;
    await settled();
    assert.dom(document.body).hasClass('foo');
  });

  test('the class value is reactive', async function (assert) {
    const show = cell('foo');

    assert.dom(document.body).hasNoClass('foo');
    assert.dom(document.body).hasNoClass('bar');
    assert.dom(document.body).hasNoClass('bax');

    await render(<template>{{bodyClass show.current}}</template>);
    assert.dom(document.body).hasClass('foo');

    show.current = 'bar';
    await settled();
    assert.dom(document.body).hasNoClass('foo');
    assert.dom(document.body).hasClass('bar');

    show.current = 'bax';
    await settled();
    assert.dom(document.body).hasNoClass('foo');
    assert.dom(document.body).hasNoClass('bar');
    assert.dom(document.body).hasClass('bax');
  });

  test('two helpers try to add the same class', async function (assert) {
    const show = cell(true);

    assert.dom(document.body).hasNoClass('foo');
    await render(
      <template>
        {{bodyClass "foo"}}

        {{#if show.current}}
          {{bodyClass "foo"}}
        {{/if}}
      </template>
    );
    assert.dom(document.body).hasClass('foo');

    show.current = false;
    await settled();
    assert.dom(document.body).hasClass('foo');

    show.current = true;
    await settled();
    assert.dom(document.body).hasClass('foo');
  });

  /**
   * However, we can't possibly know the difference between colliding class names.
   * Like, if you already have foo, and then use {{bodyClass "foo"}} and that gets unrendered,
   * the original foo class will be removed
   */
  module('existing body class', function (hooks) {
    const preExisting = 'test-body-class-foo';

    hooks.beforeEach(function () {
      document.body.classList.add(preExisting);
    });

    hooks.afterEach(function () {
      document.body.classList.remove(preExisting);
    });

    test('existing body classes are not messed with', async function (assert) {
      assert.dom(document.body).hasNoClass('foo');
      assert.dom(document.body).hasClass(preExisting);

      await render(<template>{{bodyClass "foo"}}</template>);
      assert.dom(document.body).hasClass('foo');
      assert.dom(document.body).hasClass(preExisting);
    });

    test('using bodyClass with the pre-existing class removes the pre-existing class', async function (assert) {
      const show = cell(true);

      assert.dom(document.body).hasClass(preExisting);
      await render(
        <template>
          {{#if show.current}}
            {{bodyClass preExisting}}
          {{/if}}
        </template>
      );
      assert.dom(document.body).hasClass(preExisting);

      show.current = false;
      await settled();
      /**
       * IMPORTANT: original class removed
       */
      assert.dom(document.body).hasNoClass(preExisting);

      show.current = true;
      await settled();
      assert.dom(document.body).hasClass(preExisting);
    });
  });
});
