import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { FloatingUI } from 'ember-primitives/floating-ui';

import { resetTestingContainerDimensions } from './test-helpers';

module('Integration | Component | velcro (strict mode)', function (hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function () {
    resetTestingContainerDimensions();
  });

  test('it renders', async function (assert) {
    await render(<template>
      <FloatingUI as |velcro|>
        <div id="hook" {{velcro.hook}} style="width: 200px; height: 40px">
          {{velcro.data.rects.reference.width}}
          {{velcro.data.rects.reference.height}}
        </div>
        <div id="loop" {{velcro.loop}} style="width: 200px; height: 400px">
          {{velcro.data.rects.floating.width}}
          {{velcro.data.rects.floating.height}}
        </div>
      </FloatingUI>
    </template>);

    assert.dom('#hook').hasText('200 40', 'reference element has expected dimensions');
    assert.dom('#loop').hasText('200 400', 'floating element has expected dimensions');
    assert.dom('#loop').hasAttribute('style');
    assert.dom('#loop').hasStyle({
      position: 'fixed',
      top: '40px',
      left: '0px',
    });
  });
});
