import { tracked } from '@glimmer/tracking';
import { render, rerender } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Progress } from 'ember-primitives';

module('<Progress />', function (hooks) {
  setupRenderingTest(hooks);

  test('with a value', async function (assert) {
    class State {
      @tracked value = 0;
    }

    const state = new State();

    await render(
      <template>
        <Progress @value={{state.value}} as |x|>
          <div id="value">{{x.value}}</div>
          <div id="percent">{{x.percent}}</div>
          <x.Indicator />
        </Progress>
      </template>
    );

    const progressBar = '[role="progressbar"]';
    const indicator = `${progressBar} > [data-state]`;

    assert.dom(progressBar).exists();
    assert.dom(indicator).exists();
    assert.dom(progressBar).hasAria('valuemin', '0');
    assert.dom(progressBar).hasAria('valuemax', '100');
    assert.dom(progressBar).hasAria('valuenow', '0');
    assert.dom(progressBar).hasAria('valuetext', '0%');
    assert.dom(indicator).hasAttribute('data-max', '100');
    assert.dom(indicator).hasAttribute('data-value', '0');
    assert.dom(indicator).hasAttribute('data-state', 'loading');

    state.value = 50;
    await rerender();

    assert.dom(progressBar).hasAria('valuemin', '0');
    assert.dom(progressBar).hasAria('valuemax', '100');
    assert.dom(progressBar).hasAria('valuenow', '50');
    assert.dom(progressBar).hasAria('valuetext', '50%');
    assert.dom(indicator).hasAttribute('data-max', '100');
    assert.dom(indicator).hasAttribute('data-value', '50');
    assert.dom(indicator).hasAttribute('data-state', 'loading');

    state.value = 100;
    await rerender();

    assert.dom(progressBar).hasAria('valuemin', '0');
    assert.dom(progressBar).hasAria('valuemax', '100');
    assert.dom(progressBar).hasAria('valuenow', '100');
    assert.dom(progressBar).hasAria('valuetext', '100%');
    assert.dom(indicator).hasAttribute('data-max', '100');
    assert.dom(indicator).hasAttribute('data-value', '100');
    assert.dom(indicator).hasAttribute('data-state', 'complete');
  });

  test('with a max, value changing', async function (assert) {
    class State {
      @tracked value = 0;
      @tracked max = 1000;
    }

    const state = new State();

    await render(
      <template>
        <Progress @value={{state.value}} @max={{state.max}} as |x|>
          <div id="value">{{x.value}}</div>
          <div id="percent">{{x.percent}}</div>
          <x.Indicator />
        </Progress>
      </template>
    );

    const progressBar = '[role="progressbar"]';
    const indicator = `${progressBar} > [data-state]`;

    assert.dom(progressBar).exists();
    assert.dom(indicator).exists();
    assert.dom(progressBar).hasAria('valuemin', '0');
    assert.dom(progressBar).hasAria('valuemax', '1000');
    assert.dom(progressBar).hasAria('valuenow', '0');
    assert.dom(progressBar).hasAria('valuetext', '0%');
    assert.dom(indicator).hasAttribute('data-max', '1000');
    assert.dom(indicator).hasAttribute('data-value', '0');
    assert.dom(indicator).hasAttribute('data-state', 'loading');

    state.value = 50;
    await rerender();

    assert.dom(progressBar).hasAria('valuemin', '0');
    assert.dom(progressBar).hasAria('valuemax', '1000');
    assert.dom(progressBar).hasAria('valuenow', '50');
    assert.dom(progressBar).hasAria('valuetext', '5%');
    assert.dom(indicator).hasAttribute('data-max', '1000');
    assert.dom(indicator).hasAttribute('data-value', '50');
    assert.dom(indicator).hasAttribute('data-state', 'loading');

    state.value = 100;
    await rerender();

    assert.dom(progressBar).hasAria('valuemin', '0');
    assert.dom(progressBar).hasAria('valuemax', '1000');
    assert.dom(progressBar).hasAria('valuenow', '100');
    assert.dom(progressBar).hasAria('valuetext', '10%');
    assert.dom(indicator).hasAttribute('data-max', '1000');
    assert.dom(indicator).hasAttribute('data-value', '100');
    assert.dom(indicator).hasAttribute('data-state', 'loading');
  });

  test('with a max, changing with a value', async function (assert) {
    class State {
      @tracked value = 0;
      @tracked max = 1000;
    }

    const state = new State();

    await render(
      <template>
        <Progress @value={{state.value}} @max={{state.max}} as |x|>
          <div id="value">{{x.value}}</div>
          <div id="percent">{{x.percent}}</div>
          <x.Indicator />
        </Progress>
      </template>
    );

    const progressBar = '[role="progressbar"]';
    const indicator = `${progressBar} > [data-state]`;

    assert.dom(progressBar).exists();
    assert.dom(indicator).exists();
    assert.dom(progressBar).hasAria('valuemin', '0');
    assert.dom(progressBar).hasAria('valuemax', '1000');
    assert.dom(progressBar).hasAria('valuenow', '0');
    assert.dom(progressBar).hasAria('valuetext', '0%');
    assert.dom(indicator).hasAttribute('data-max', '1000');
    assert.dom(indicator).hasAttribute('data-value', '0');
    assert.dom(indicator).hasAttribute('data-state', 'loading');
    assert.dom('#value').hasText('0');
    assert.dom('#percent').hasText('0');

    state.max = 10;
    state.value = 100;
    await rerender();

    assert.dom(progressBar).hasAria('valuemin', '0');
    assert.dom(progressBar).hasAria('valuemax', '10');
    assert.dom(progressBar).hasAria('valuenow', '10');
    assert.dom(progressBar).hasAria('valuetext', '100%');
    assert.dom(indicator).hasAttribute('data-max', '10');
    assert.dom(indicator).hasAttribute('data-value', '10');
    assert.dom(indicator).hasAttribute('data-state', 'complete');
    assert.dom('#value').hasText('10');
    assert.dom('#percent').hasText('100');

    state.max = 150;
    await rerender();

    assert.dom(progressBar).hasAria('valuemin', '0');
    assert.dom(progressBar).hasAria('valuemax', '150');
    assert.dom(progressBar).hasAria('valuenow', '100');
    assert.dom(progressBar).hasAria('valuetext', '67%');
    assert.dom(indicator).hasAttribute('data-max', '150');
    assert.dom(indicator).hasAttribute('data-value', '100');
    assert.dom(indicator).hasAttribute('data-state', 'loading');
    assert.dom('#value').hasText('100');
    assert.dom('#percent').hasText('66.67');
  });

  for (const value of [
    undefined,
    null,
    'string',
    '1',
    NaN,
    Infinity,
    -Infinity,
    -100,
    -1,
    ['array'],
    {},
    Math.sqrt(-1),
  ] as number[] /* lies for TS */) {
    test(`invalid value of ${value} is passed`, async function (assert) {
      await render(
        <template>
          <Progress @value={{value}} as |x|>
            <div id="value">{{x.value}}</div>
            <div id="percent">{{x.percent}}</div>
            <x.Indicator />
          </Progress>
        </template>
      );

      const progressBar = '[role="progressbar"]';
      const indicator = `${progressBar} > [data-state]`;

      assert.dom(progressBar).exists();
      assert.dom(indicator).exists();
      assert.dom(progressBar).hasAria('valuemin', '0');
      assert.dom(progressBar).hasAria('valuemax', '100');
      assert.dom(progressBar).hasAria('valuenow', '0');
      assert.dom(progressBar).hasAria('valuetext', '0%');
      assert.dom(indicator).hasAttribute('data-max', '100');
      assert.dom(indicator).hasAttribute('data-value', '0');
      assert.dom(indicator).hasAttribute('data-state', 'loading');
      assert.dom('#value').hasText('0');
      assert.dom('#percent').hasText('0');
    });

    test(`invalid max of ${value} is passed`, async function (assert) {
      await render(
        <template>
          <Progress @value={{10}} @max={{value}} as |x|>
            <div id="value">{{x.value}}</div>
            <div id="percent">{{x.percent}}</div>
            <x.Indicator />
          </Progress>
        </template>
      );

      const progressBar = '[role="progressbar"]';
      const indicator = `${progressBar} > [data-state]`;

      assert.dom(progressBar).exists();
      assert.dom(indicator).exists();
      assert.dom(progressBar).hasAria('valuemin', '0');
      assert.dom(progressBar).hasAria('valuemax', '100');
      assert.dom(progressBar).hasAria('valuenow', '10');
      assert.dom(progressBar).hasAria('valuetext', '10%');
      assert.dom(indicator).hasAttribute('data-max', '100');
      assert.dom(indicator).hasAttribute('data-value', '10');
      assert.dom(indicator).hasAttribute('data-state', 'loading');
      assert.dom('#value').hasText('10');
      assert.dom('#percent').hasText('10');
    });
  }
});
