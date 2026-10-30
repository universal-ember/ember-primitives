import { click, render, resetOnerror, setupOnerror } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Menu } from 'ember-primitives';

module('Rendering | menu without tabster', function (hooks) {
  setupRenderingTest(hooks);
  hooks.afterEach(() => resetOnerror());

  test('opening names the missing setup', async function (assert) {
    setupOnerror((error: Error) => {
      assert.step(error.message.includes('setupTabster') ? 'names setupTabster' : error.message);
    });

    await render(
      <template>
        <Menu as |m|>
          <m.Trigger class="trigger">Trigger</m.Trigger>
          <m.Content as |c|>
            <c.Item>Item</c.Item>
          </m.Content>
        </Menu>
      </template>
    );

    await click('.trigger');

    assert.verifySteps(['names setupTabster']);
  });
});
