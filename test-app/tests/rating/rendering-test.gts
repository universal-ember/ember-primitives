import { click, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Rating } from 'ember-primitives';

const star = '.ember-primitives__rating__icon';
const selected = `[data-selected]`;
const readonly = `[data-readonly]`;

module('<Rating>', function (hooks) {
  setupRenderingTest(hooks);

  test('defaults', async function (assert) {
    await render(<template><Rating /></template>);

    assert.dom(star).exists({ count: 5 });
    assert.dom(star + selected).doesNotExist();
    assert.dom(star + readonly).doesNotExist();
    assert.dom().hasText('☆ ☆ ☆ ☆ ☆');

    await click(`${star}[data-number="3"]`);
    assert.dom(star + selected).exists({ count: 3 });
    assert.dom().hasText('★ ★ ★ ☆ ☆');

    await click(`${star}[data-number="5"]`);
    assert.dom(star + selected).exists({ count: 5 });
    assert.dom().hasText('★ ★ ★ ★ ★');

    await click(`${star}[data-number="1"]`);
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
