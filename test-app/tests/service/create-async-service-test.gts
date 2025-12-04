import { renderSettled } from '@ember/renderer';
import { render, settled } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { createAsyncService } from 'ember-primitives/service';

import type { Sample } from './sample.ts';

module('createAsyncService', function (hooks) {
  setupRenderingTest(hooks);

  test('is singleton', async function (assert) {
    let id = 0;

    class State {
      foo = ++id;

      constructor() {
        assert.step('created');
      }
    }

    let resolve: (v?: any) => any;
    let promise: Promise<State>;

    async function factory() {
      promise = new Promise((r) => {
        resolve = r;
      });
      await promise;

      return State;
    }

    const a = createAsyncService(this, factory);
    const b = createAsyncService(this, factory);

    render(
      <template>
        <out id="a">
          {{a.resolved.foo}}
        </out>

        <out id="b">
          {{b.resolved.foo}}
        </out>
      </template>
    );

    await renderSettled();

    assert.verifySteps([]);

    assert.dom('#a').hasNoText();
    assert.dom('#b').hasNoText();

    // @ts-expect-error
    resolve(null);
    // @ts-expect-error
    await promise;
    await settled();

    assert.verifySteps(['created']);
    assert.dom('#a').hasText('1');
    assert.dom('#b').hasText('1');
  });

  test('is singleton with await import', async function (assert) {
    async function factory() {
      const module = await import('./sample.ts');

      return module.Sample;
    }

    const a = createAsyncService(this, factory);
    const b = createAsyncService(this, factory);

    render(
      <template>
        <out id="a">
          {{a.resolved.foo}}
        </out>

        <out id="b">
          {{b.resolved.foo}}
        </out>
      </template>
    );

    await renderSettled();

    assert.verifySteps([]);

    assert.dom('#a').hasNoText();
    assert.dom('#b').hasNoText();

    await settled();

    assert.dom('#a').hasText('1');
    assert.dom('#b').hasText('1');
  });

  test('is singleton with await import and new', async function (assert) {
    async function factory(): Promise<() => Sample> {
      const module = await import('./sample.ts');

      return () => new module.Sample();
    }

    const a = createAsyncService(this, factory);
    const b = createAsyncService(this, factory);

    render(
      <template>
        <out id="a">
          {{a.resolved.foo}}
        </out>

        <out id="b">
          {{b.resolved.foo}}
        </out>
      </template>
    );

    await renderSettled();

    assert.verifySteps([]);

    assert.dom('#a').hasNoText();
    assert.dom('#b').hasNoText();

    await settled();

    assert.dom('#a').hasText('1');
    assert.dom('#b').hasText('1');
  });
});
