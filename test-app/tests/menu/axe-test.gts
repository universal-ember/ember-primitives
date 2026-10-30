import { click, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Menu } from 'ember-primitives';

import { setupTabster } from 'ember-primitives/test-support';

import { audit } from '../axe.ts';

module('<Menu> | axe', function (hooks) {
  setupRenderingTest(hooks);
  setupTabster(hooks);

  test('has no axe violations when open', async function (assert) {
    await render(
      <template>
        <Menu as |m|>
          <m.Trigger class="trigger">Actions</m.Trigger>
          <m.Content aria-label="Actions" as |c|>
            <c.Item>One</c.Item>
            <c.Separator />
            <c.Item>Two</c.Item>
          </m.Content>
        </Menu>
      </template>
    );

    await click('.trigger');
    await audit(assert);
  });
});
