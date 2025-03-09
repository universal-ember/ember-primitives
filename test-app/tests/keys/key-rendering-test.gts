import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Key } from 'ember-primitives';

module('Rendering | Key', function (hooks) {
  setupRenderingTest(hooks);

  test('renders content', async function (assert) {
    await render(
      <template>
        <Key>hi there</Key>
      </template>
    );

    assert.dom('kbd').hasText('hi there');
  });
});
