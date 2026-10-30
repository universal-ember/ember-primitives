import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Rating } from 'ember-primitives';

module('<Rating> range', function (hooks) {
  setupRenderingTest(hooks);

  test('uses the scale of the rating', async function (assert) {
    await render(
      <template>
        <Rating @step={{0.5}} @value={{3.5}} as |r|>
          <r.Range aria-label="Rating" />
        </Rating>
      </template>
    );

    assert.dom('input[type="range"]').hasAttribute('min', '0');
    assert.dom('input[type="range"]').hasAttribute('step', '0.5');
    assert.dom('input[type="range"]').hasAttribute('max', '5');
    assert.dom('input[type="range"]').hasValue('3.5');
  });
});
