import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { OTPInput } from 'ember-primitives';

import { audit } from '../axe.ts';

module('<OTPInput> | axe', function (hooks) {
  setupRenderingTest(hooks);

  test('has no axe violations', async function (assert) {
    await render(<template><OTPInput aria-label="Code" /></template>);

    await audit(assert);
  });
});
