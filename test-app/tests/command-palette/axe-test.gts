import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { CommandPalette } from 'ember-primitives';

import { setupTabster } from 'ember-primitives/test-support';

import { audit } from '../axe.ts';

module('<CommandPalette> | axe', function (hooks) {
  setupRenderingTest(hooks);
  setupTabster(hooks);

  test('has no axe violations', async function (assert) {
    const items = ['One', 'Two'];

    await render(<template><CommandPalette @items={{items}} /></template>);

    await audit(assert);
  });
});
