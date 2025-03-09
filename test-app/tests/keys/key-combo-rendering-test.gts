import { findAll,render  } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { KeyCombo } from 'ember-primitives';

module('Rendering | KeyCombo', function (hooks) {
  setupRenderingTest(hooks);

  function allTexts() {
    const kbds = findAll('kbd');

    return kbds.map((x) => x.textContent);
  }

  test('renders from an array', async function (assert) {
    const arr = ['ctrl', 'shift', 'a'];

    await render(<template><KeyCombo @keys={{arr}} /></template>);

    assert.dom('kbd').exists({ count: 3 });
    assert.deepEqual(allTexts(), ['ctrl', 'shift', 'a']);
  });

  test('renders from a string', async function (assert) {
    await render(<template><KeyCombo @keys="ctrl+shift+a" /></template>);

    assert.dom('kbd').exists({ count: 3 });
    assert.deepEqual(allTexts(), ['ctrl', 'shift', 'a']);
  });

  test('renders from a string: handles spaces', async function (assert) {
    await render(<template><KeyCombo @keys="ctrl + shift + a" /></template>);

    assert.dom('kbd').exists({ count: 3 });
    assert.deepEqual(allTexts(), ['ctrl', 'shift', 'a']);
  });
});
