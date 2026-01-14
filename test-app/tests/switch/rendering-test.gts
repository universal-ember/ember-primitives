import { click, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Switch } from 'ember-primitives/components/switch';

module('Switch', function (hooks) {
  setupRenderingTest(hooks);

  test('it yields only 3 things', async function (assert) {
    let keys: any = [];
    const capture = (obj: any) => (keys = Object.keys(obj));

    await render(
      <template>
        <Switch as |s|>
          {{! @glint-expect-error }}
          {{capture s}}
        </Switch>
      </template>
    );
    assert.deepEqual(keys, ['isChecked', 'Control', 'Label']);
  });

  test('togglin', async function (assert) {
    const capture = (x: boolean) => assert.step(String(x));

    await render(
      <template>
        <Switch as |s|>
          {{capture s.isChecked}}
          <s.Control />
          <s.Label>hi</s.Label>
        </Switch>
      </template>
    );

    assert.verifySteps(['false']);

    await click('[role=switch]');
    assert.verifySteps(['true']);

    await click('[role=switch]');
    assert.verifySteps(['false']);
  });
});
