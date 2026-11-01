import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { FloatingUI } from 'ember-primitives/floating-ui';

import { resetTestingContainerDimensions } from './test-helpers';

module('floating-ui (strict mode)', function (hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function () {
    resetTestingContainerDimensions();
  });

  test('it renders', async function (assert) {
    await render(
      <template>
        <FloatingUI as |reference floating|>
          <div id="hook" {{reference}} style="width: 200px; height: 40px"></div>
          <div id="loop" {{floating}} style="width: 200px; height: 400px"></div>
        </FloatingUI>
      </template>
    );

    assert.dom('#loop').hasStyle({ position: 'fixed' });
  });
});
