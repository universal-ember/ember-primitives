import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Progress } from 'ember-primitives';

module('<Progress />', function (hooks) {
  setupRenderingTest(hooks);

  test('it works', async function (assert) {
    await render(
      <template>
        <Progress @value={{0}} as |x|>
          <x.Indicator />
        </Progress>
      </template>
    );

    assert.dom('[data-state="empty"]').exists();
  });
});
