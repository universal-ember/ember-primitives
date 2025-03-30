import { click, findAll, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Rating } from 'ember-primitives';

import { rating as createTestHelper } from 'ember-primitives/test-support';

const star = '.ember-primitives__rating__item';
const selected = `[data-selected]`;
const readonly = `[data-readonly]`;

/**
 * NOTE: these tests directly touch the DOM because I have to test
 *       that the implementation of both the component and the test helpers
 *       do what I expect.
 *
 *       Consumers of this component should not interact with the DOM.
 *       It is private api.
 */
module('<Rating>', function (hooks) {
  setupRenderingTest(hooks);

  const rating = createTestHelper();

  module('edges', function () {
    test('does not allow negative values', async function (assert) {
      await render(<template><Rating /></template>);

      await assert.rejects(rating.select(-1), /Is the number \(-1\) correct/);
    });

    test('does not allow values over the maximum', async function (assert) {
      await render(<template><Rating /></template>);

      await assert.rejects(rating.select(6), /Is the number \(6\) correct/);
    });

    test('errors when wrong or incorrect thing rendered', async function (assert) {
      assert.throws(() => rating.value, /Could not find the root element/);
      await assert.rejects(rating.select(), /Could not find the root element/);
      assert.throws(() => rating.stars, /There are no stars/);
    });
  });

  module('examples', function () {
    test('consumer example', async function (assert) {
      await render(<template><Rating /></template>);

      assert.strictEqual(rating.value, 0);
      assert.strictEqual(rating.isReadonly, false);

      await rating.select(3);
      assert.strictEqual(rating.value, 3);
      assert.strictEqual(rating.stars, '★ ★ ★ ☆ ☆');

      // Toggle
      await rating.select(3);
      assert.strictEqual(rating.value, 0);
      assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆');
    });

    test('consumer example (multiple)', async function (assert) {
      await render(
        <template>
          <Rating data-test-first />
          <Rating data-test-second />
        </template>
      );

      const first = createTestHelper('[data-test-first]');
      const second = createTestHelper('[data-test-second]');

      assert.strictEqual(first.value, 0, 'first Rating has no selection');
      assert.strictEqual(second.value, 0, 'second Rating has no selection');

      await first.select(3);
      assert.strictEqual(first.value, 3, 'first Rating now has 3 stars');
      assert.strictEqual(second.value, 0, 'second Rating is still unchanged');

      await second.select(4);
      assert.strictEqual(second.value, 4, 'second Rating now has 4 stars');
      assert.strictEqual(first.value, 3, 'first Rating is still unchanged (at 3)');

      // Toggle First
      await first.select(3);
      assert.strictEqual(first.value, 0, 'first Rating is toggled from 3 to 0');
      assert.strictEqual(second.value, 4, 'second Rating is still unchanged (at 4)');

      // Toggle Second
      await second.select(4);
      assert.strictEqual(second.value, 0, 'second Rating is toggled from 4 to 0');
      assert.strictEqual(first.value, 0, 'first Rating is still unchanged (at 0)');
    });

    test('What not to do', async function (assert) {
      await render(<template><Rating /></template>);

      assert.dom(`[data-selected]`).doesNotExist();
      assert.dom(`[data-readonly]`).doesNotExist();

      await click(`[data-number="3"] input`);
      assert.dom(`[data-selected]`).exists({ count: 3 });

      // Toggle
      await click(`[data-number="3"] input`);
      assert.dom(`[data-selected]`).doesNotExist();
    });
  });

  test('defaults', async function (assert) {
    await render(<template><Rating /></template>);

    assert.dom(star).exists({ count: 5 });
    assert.dom(star + selected).doesNotExist();
    assert.dom(star + readonly).doesNotExist();
    assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆');

    await rating.select(3);
    assert.dom(star + selected).exists({ count: 3 });
    assert.strictEqual(rating.stars, '★ ★ ★ ☆ ☆');

    await rating.select(5);
    assert.dom(star + selected).exists({ count: 5 });
    assert.strictEqual(rating.stars, '★ ★ ★ ★ ★');

    await rating.select(1);
    assert.dom(star + selected).exists({ count: 1 });
    assert.strictEqual(rating.stars, '★ ☆ ☆ ☆ ☆');
  });

  test('toggles', async function (assert) {
    await render(<template><Rating /></template>);

    assert.dom(star).exists({ count: 5 });
    assert.dom(star + selected).doesNotExist();
    assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆');

    await rating.select(3);
    assert.dom(star + selected).exists({ count: 3 });
    assert.strictEqual(rating.stars, '★ ★ ★ ☆ ☆');

    await rating.select(3);
    assert.dom(star + selected).doesNotExist();
    assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆');
  });

  test('@icon (string)', async function (assert) {
    await render(<template><Rating @icon="x" /></template>);

    assert.dom(star).exists({ count: 5 });
    assert.dom(star + selected).doesNotExist();
    assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆');
    assert.strictEqual(rating.starTexts, 'x x x x x');

    await rating.select(3);
    assert.dom(star + selected).exists({ count: 3 });
    assert.strictEqual(rating.stars, '★ ★ ★ ☆ ☆');
    assert.strictEqual(rating.starTexts, 'x x x x x');

    await rating.select(3);
    assert.dom(star + selected).doesNotExist();
    assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆');
    assert.strictEqual(rating.starTexts, 'x x x x x');
  });

  test('@max=7 (number)', async function (assert) {
    await render(<template><Rating @max={{7}} /></template>);

    assert.dom(star).exists({ count: 7 });
    assert.dom(star + selected).doesNotExist();
    assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆ ☆ ☆');

    await rating.select(3);
    assert.dom(star + selected).exists({ count: 3 });
    assert.strictEqual(rating.stars, '★ ★ ★ ☆ ☆ ☆ ☆');

    await rating.select(7);
    assert.dom(star + selected).exists({ count: 7 });
    assert.strictEqual(rating.stars, '★ ★ ★ ★ ★ ★ ★');
  });

  test('@max=7 (string)', async function (assert) {
    await render(<template><Rating @max="7" /></template>);

    assert.dom(star).exists({ count: 7 });
    assert.dom(star + selected).doesNotExist();
    assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆ ☆ ☆');

    await rating.select(3);
    assert.dom(star + selected).exists({ count: 3 });
    assert.strictEqual(rating.stars, '★ ★ ★ ☆ ☆ ☆ ☆');

    await rating.select(7);
    assert.dom(star + selected).exists({ count: 7 });
    assert.strictEqual(rating.stars, '★ ★ ★ ★ ★ ★ ★');
  });

  test('@icon (component)', async function (assert) {
    const Icon = <template>
      <div ...attributes>
        {{#if @isSelected}}
          (x)
        {{else}}
          ()
        {{/if}}
      </div>
    </template>;

    await render(<template><Rating @icon={{Icon}} /></template>);

    assert.dom(star).exists({ count: 5 });
    assert.dom(star + selected).doesNotExist();
    assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆');
    assert.strictEqual(rating.starTexts, '() () () () ()');

    await rating.select(3);
    assert.dom(star + selected).exists({ count: 3 });
    assert.strictEqual(rating.stars, '★ ★ ★ ☆ ☆');
    assert.strictEqual(rating.starTexts, '(x) (x) (x) () ()');

    await rating.select(3);
    assert.dom(star + selected).doesNotExist();
    assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆');
    assert.strictEqual(rating.starTexts, '() () () () ()');
  });
});
