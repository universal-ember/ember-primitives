import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { ToggleGroup } from 'ember-primitives';

import { setupTabster } from 'ember-primitives/test-support';

import { audit } from '../axe.ts';

module('<ToggleGroup> | axe', function (hooks) {
  setupRenderingTest(hooks);
  setupTabster(hooks);

  test('has no axe violations', async function (assert) {
    await render(
      <template>
        <ToggleGroup aria-label="Alignment" as |t|>
          <t.Item @value="left">Left</t.Item>
          <t.Item @value="right">Right</t.Item>
        </ToggleGroup>
      </template>
    );

    await audit(assert);
  });
});
