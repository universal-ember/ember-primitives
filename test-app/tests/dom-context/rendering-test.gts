import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { click, render, settled, setupOnerror } from '@ember/test-helpers';
import { module, skip, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Consume,Provide } from 'ember-primitives/dom-context';

import type { TOC } from '@ember/component/template-only';

module('Rendering | DOM Context', function (hooks) {
  setupRenderingTest(hooks);

  test('@data handles static object', async function (assert) {
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

  test('@key can be specified as a string', async function (assert) {
    const data = { static: true };
    const key = 'hello-there';

    let result: any;

    function capture(d: any) {
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

  test('multiple providers are independent', async function (assert) {
    class Incrementer {
      @tracked count = 2;
      doit = () => this.count++;
    }

    class Doubler {
      @tracked count = 2;
      doit = () => (this.count *= 2);
    }

    const step = (...x: unknown[]) => assert.step(x.join(':'));

    const Consumer: TOC<{ name: string }> = <template>
      <div data-name={{@name}}>
        <Consume @key="store" as |context|>
          {{! SAFETY: we can't get a specific type with string keys.
                      we can lie about types though with a wrapper component }}
          {{! @glint-expect-error}}
          {{step @name context.data.count}}
          {{! @glint-expect-error}}
          <button onclick={{context.data.doit}} type="button">do it</button>
        </Consume>
      </div>
    </template>;

    await render(
      <template>
        <Provide @data={{Incrementer}} @key="store">
          <Consumer @name="inc" />
        </Provide>

        <Provide @data={{Doubler}} @key="store">
          <Consumer @name="double" />
        </Provide>
      </template>
    );

    assert.verifySteps(['inc:2', 'double:2']);

    await click('[data-name="inc"] button');
    assert.verifySteps(['inc:3']);

    await click('[data-name="double"] button');
    assert.verifySteps(['double:4']);
  });

  test('@key example curried string with type', async function (assert) {
    class Incrementer {
      @tracked count = 2;
      doit = () => this.count++;
    }

    class Doubler {
      @tracked count = 2;
      doit = () => (this.count *= 2);
    }

    const step = (...x: unknown[]) => assert.step(x.join(':'));

    const StoreConsumer: TOC<{
      Blocks: {
        default: [store: { count: number; doit: () => void }];
      };
    }> = <template>
      <Consume @key="store" as |context|>
        {{! SAFETY: we specified the type in the signature }}
        {{! @glint-expect-error}}
        {{yield context.data}}
      </Consume>
    </template>;

    const Consumer: TOC<{ name: string }> = <template>
      <div data-name={{@name}}>
        <StoreConsumer as |store|>
          {{step @name store.count}}
          <button type="button" {{on "click" store.doit}}>do it</button>
        </StoreConsumer>
      </div>
    </template>;

    await render(
      <template>
        <Provide @data={{Incrementer}} @key="store">
          <Consumer @name="inc" />
        </Provide>

        <Provide @data={{Doubler}} @key="store">
          <Consumer @name="double" />
        </Provide>
      </template>
    );

    assert.verifySteps(['inc:2', 'double:2']);

    await click('[data-name="inc"] button');
    assert.verifySteps(['inc:3']);

    await click('[data-name="double"] button');
    assert.verifySteps(['double:4']);
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
            {{! @glint-expect-error}}
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
            {{! @glint-expect-error}}
            {{step "first" context.data.count}}
          </Consume>
          <Consume @key={{key}} as |context|>
            {{! @glint-expect-error}}
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

  test('@data can be a class', async function (assert) {
    class Data {
      @tracked count = 0;
      increment = () => this.count++;
    }

    const step = (...x: unknown[]) => assert.step(x.join(', '));

    await render(
      <template>
        <Provide @data={{Data}}>
          <Consume @key={{Data}} as |context|>
            {{step context.data.count}}

            <button onclick={{context.data.increment}} type="button">++</button>
          </Consume>
        </Provide>
      </template>
    );

    assert.verifySteps(['0']);

    await click('button');

    assert.verifySteps(['1']);
  });

  test('@data can be a function', async function (assert) {
    function data() {
      class Data {
        @tracked count = 0;
        increment = () => this.count++;
      }

      return new Data();
    }

    const step = (...x: unknown[]) => assert.step(x.join(', '));

    await render(
      <template>
        <Provide @data={{data}}>
          <Consume @key={{data}} as |context|>
            {{step context.data.count}}

            <button onclick={{context.data.increment}} type="button">++</button>
          </Consume>
        </Provide>
      </template>
    );

    assert.verifySteps(['0']);

    await click('button');

    assert.verifySteps(['1']);
  });
});
