import { skip, module, test } from 'qunit';
import { tracked } from '@glimmer/tracking';
import { setupRenderingTest } from 'ember-qunit';
import { render, settled, setupOnerror } from '@ember/test-helpers';

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

  test('with the same key, we can nest providers', async function (assert) {
    const key = 'hello-there';

    let result: any;

    function capture(d: any) {
      result = d;
    }

    await render(
      <template>
        <Provide @data={{Object name="outer"}} @key={{key}}>
          <Provide @data={{Object name="inner"}} @key={{key}}>
            <Consume @key={{key}} as |context|>
              {{capture context.data}}
            </Consume>
          </Provide>
        </Provide>
      </template>
    );

    assert.deepEqual(result, { name: 'inner' });
  });

  test('changes to reactive data are fine-grainedly available to the consumer', async function (assert) {
    const key = 'hello-there';

    class Data {
      @tracked count = 0;
    }

    const data = new Data();

    const step = (x: unknown) => assert.step(String(x));

    await render(
      <template>
        <Provide @data={{data}} @key={{key}}>
          <Consume @key={{key}} as |context|>
            {{step context.data}}
            {{step context.data.count}}
          </Consume>
        </Provide>
      </template>
    );

    assert.verifySteps(['[object Object]', '0']);

    data.count++;
    await settled();

    assert.verifySteps(['1']);
  });

  test('multiple consumers can see and react to the same change', async function (assert) {
    const key = 'hello-there';

    class Data {
      @tracked count = 0;
    }

    const data = new Data();

    const step = (...x: unknown[]) => assert.step(x.join(', '));

    await render(
      <template>
        <Provide @data={{data}} @key={{key}}>
          <Consume @key={{key}} as |context|>
            {{step "first" context.data.count}}
          </Consume>
          <Consume @key={{key}} as |context|>
            {{step "second" context.data.count}}
          </Consume>
        </Provide>
      </template>
    );

    assert.verifySteps(['first, 0', 'second, 0']);

    data.count++;
    await settled();

    assert.verifySteps(['first, 1', 'second, 1']);
  });
});
