import { skip, module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';
import { render, setupOnerror } from '@ember/test-helpers';

import { Provide, Consume } from 'ember-primitives/dom-context';

module('Rendering | DOM Context', function (hooks) {
  setupRenderingTest(hooks);

  test('handles static object', async function (assert) {
    const key = { static: true };

    let result: any;

    function capture(data: typeof key) {
      result = data;
    }

    await render(
      <template>
        <Provide @data={{key}}>
          <Consume @key={{key}} as |context|>
            {{capture context.data}}
          </Consume>
        </Provide>
      </template>
    );

    assert.deepEqual(result, key);
  });

  test('can use string keys', async function (assert) {
    const data = { static: true };
    const key = 'hello-there';

    let result: any;

    function capture(d: typeof data) {
      result = d;
    }

    await render(
      <template>
        <Provide @data={{data}} @key={{key}}>
          <Consume @key={{key}} as |context|>
            {{capture context.data}}
          </Consume>
        </Provide>
      </template>
    );

    assert.deepEqual(result, data);
  });

  /**
   * We currently can't test when we deliberately crash rendering.
   *
   * rendering tries to _re-render_, which fails, because we deliberately
   * crashed on initial render
   */
  skip('consume cannot access provide in a different tree', async function (assert) {
    const data1 = { one: true };
    const data2 = { two: true };

    let result: any;

    function capture(d: any) {
      result = d;
    }

    setupOnerror((error) => {
      assert.ok(error?.message?.includes('Could not find provided context'));
    });

    await render(
      <template>
        <Provide @data={{data1}} />

        <Provide @data={{data2}}>
          <Consume @key={{data1}} as |context|>
            {{capture context.data}}
          </Consume>
        </Provide>
      </template>
    );
  });
});
