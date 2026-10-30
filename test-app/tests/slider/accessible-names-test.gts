import { array } from '@ember/helper';
import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { screen } from '@testing-library/dom';
import { Slider } from 'ember-primitives';

module('<Slider /> accessible names', function (hooks) {
  setupRenderingTest(hooks);

  test('one thumb', async function (assert) {
    await render(<template><Slider @value={{1}} /></template>);

    assert.dom(screen.getByRole('slider', { name: 'Value' })).exists();
  });

  test('two thumbs', async function (assert) {
    await render(<template><Slider @value={{array 1 2}} /></template>);

    assert.dom(screen.getByRole('slider', { name: 'Minimum' })).exists();
    assert.dom(screen.getByRole('slider', { name: 'Maximum' })).exists();
  });

  test('more thumbs', async function (assert) {
    await render(<template><Slider @value={{array 1 2 3}} /></template>);

    assert.dom(screen.getByRole('slider', { name: 'Value 3' })).exists();
  });
});
