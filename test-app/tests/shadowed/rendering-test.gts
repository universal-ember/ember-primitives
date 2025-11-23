import { find, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Shadowed } from 'ember-primitives';

import { findInFirstShadow } from 'ember-primitives/test-support';

module('Rendering | <Shadowed>', function (hooks) {
  setupRenderingTest(hooks);

  test('it works', async function (assert) {
    await render(
      <template>
        out of shadow

        <Shadowed data-shadow>
          in shadow
        </Shadowed>
      </template>
    );

    assert.dom().hasText('out of shadow');
    assert.dom().doesNotContainText('in shadow');
    // assort.dom forgot that ShadowDom is a thing
    // assert.dom(find('[data-shadow]')?.shadowRoot).hasText('in shadow');
    assert.dom(findInFirstShadow('*')).containsText('in shadow');
  });
});
