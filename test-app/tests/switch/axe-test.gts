import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Switch } from 'ember-primitives/components/switch';

import { audit } from '../axe.ts';

module('<Switch> | axe', function (hooks) {
  setupRenderingTest(hooks);

  test('has no axe violations', async function (assert) {
    await render(
      <template>
        <Switch as |s|>
          <s.Control />
          <s.Label>Wifi</s.Label>
        </Switch>
      </template>
    );

    await audit(assert);
  });
});
