import '@nullvoxpopuli/primitives/switch';

import { click, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';


module('Rendering | <primitive-switch>', function (hooks) {
  setupRenderingTest(hooks);

  test('it works', async function (assert) {
    const handleChange = (value: unknown) => assert.step(`Change:${value}`);

    await render(
      <template>
        <primitive-switch>
          <primitive-switch-label>

          </primitive-switch-label>
          <primitive-switch-control>

          </primitive-switch-control>
        </primitive-switch>
      </template>
    );

    await this.pauseTest();
    assert.dom('label').exists();
  });
});
