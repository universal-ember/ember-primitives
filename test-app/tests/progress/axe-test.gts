import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Progress } from 'ember-primitives';

import { audit } from '../axe.ts';

module('<Progress> | axe', function (hooks) {
  setupRenderingTest(hooks);

  test('has no axe violations', async function (assert) {
    await render(<template><Progress @value={{40}} aria-label="Upload" /></template>);

    await audit(assert);
  });
});
