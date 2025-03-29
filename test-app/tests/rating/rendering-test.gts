import { click, render } from '@ember/test-helpers';
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

  test('defaults', async function (assert) {
    await render(<template><Rating /></template>);

    assert.dom(star).exists({ count: 5 });
    assert.dom(star + selected).doesNotExist();
    assert.dom(star + readonly).doesNotExist();
    assert.dom(rating.stars).hasText('☆ ☆ ☆ ☆ ☆');

    await rating.select(3);
    assert.dom(star + selected).exists({ count: 3 });
    assert.dom().hasText('★ ★ ★ ☆ ☆');

    await rating.select(5);
    assert.dom(star + selected).exists({ count: 5 });
    assert.dom().hasText('★ ★ ★ ★ ★');

    await rating.select(1);
    assert.dom(star + selected).exists({ count: 1 });
    assert.dom().hasText('★ ☆ ☆ ☆ ☆');
  });

  test('toggles', async function (assert) {
    await render(<template><Rating /></template>);

    assert.dom(star).exists({ count: 5 });
    assert.dom(star + selected).doesNotExist();
    assert.dom().hasText('☆ ☆ ☆ ☆ ☆');

    await click(`${star}[data-number="3"]`);
    assert.dom(star + selected).exists({ count: 3 });
    assert.dom().hasText('★ ★ ★ ☆ ☆');

    await click(`${star}[data-number="3"]`);
    assert.dom(star + selected).doesNotExist();
    assert.dom().hasText('☆ ☆ ☆ ☆ ☆');
  });

  test('@icon (string)', async function (assert) {
    await render(<template><Rating @icon="x" /></template>);

    assert.dom(star).exists({ count: 5 });
    assert.dom(star + selected).doesNotExist();
    assert.dom().hasText('x x x x x');

    await click(`${star}[data-number="3"]`);
    assert.dom(star + selected).exists({ count: 3 });
    assert.dom().hasText('★ ★ ★ x x');

    await click(`${star}[data-number="3"]`);
    assert.dom(star + selected).doesNotExist();
    assert.dom().hasText('x x x x x');
  });

  test('@iconSelected (string)', async function (assert) {
    await render(<template><Rating @iconSelected="x" /></template>);

    assert.dom(star).exists({ count: 5 });
    assert.dom(star + selected).doesNotExist();
    assert.dom().hasText('☆ ☆ ☆ ☆ ☆');

    await click(`${star}[data-number="3"]`);
    assert.dom(star + selected).exists({ count: 3 });
    assert.dom().hasText('x x x ☆ ☆');

    await click(`${star}[data-number="3"]`);
    assert.dom(star + selected).doesNotExist();
    assert.dom().hasText('☆ ☆ ☆ ☆ ☆');
  });
});
