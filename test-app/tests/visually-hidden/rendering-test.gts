import { click, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { VisuallyHidden } from 'ember-primitives';

module('Rendering | <VisuallyHidden>', function (hooks) {
  setupRenderingTest(hooks);

  test('it works', async function (assert) {
    await render(
      <template>
        <VisuallyHidden>
          this is visually hidden, but still rendered
        </VisuallyHidden>
      </template>
    );

    assert.dom('span').hasStyle({
      width: '1px',
      margin: '-1px',
      clip: `rect(0px, 0px, 0px, 0px)`,
    });
  });
});
