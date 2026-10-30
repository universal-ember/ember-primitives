import { array } from '@ember/helper';
import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Slider } from 'ember-primitives';

import { audit } from '../axe.ts';

module('<Slider> | axe', function (hooks) {
  setupRenderingTest(hooks);

  test('has no axe violations', async function (assert) {
    await render(<template><Slider @value={{array 20 80}} /></template>);

    await audit(assert);
  });
});
