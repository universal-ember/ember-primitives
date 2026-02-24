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

  test('@onChange is called with (checked: boolean, event: Event)', async function (assert) {
    let calls: Array<[boolean, Event]> = [];
    const handleChange = (checked: boolean, event: Event) => calls.push([checked, event]);

    await render(
      <template>
        <Switch @onChange={{handleChange}} as |s|>
          <s.Control />
        </Switch>
      </template>
    );

    await click('[role=switch]');
    assert.strictEqual(calls.length, 1, 'onChange called once');
    assert.strictEqual(calls[0]![0], true, 'first arg is new checked state (true)');
    assert.ok(calls[0]![1] instanceof Event, 'second arg is an Event');
  });
});
