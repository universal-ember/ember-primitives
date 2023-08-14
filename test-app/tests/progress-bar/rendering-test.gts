import { tracked } from '@glimmer/tracking';
import { render, rerender } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { ProgressBar } from 'ember-primitives';

module('<ProgressBar />', function (hooks) {
  setupRenderingTest(hooks);

  test('with a value', async function (assert) {
    class State {
      @tracked value = 0;
    }

    let state = new State();

    await render(
      <template>
        <ProgressBar @value={{state.value}} as |x|>
          <div id="value">{{x.value}}</div>
          <div id="percent">{{x.percent}}</div>
          <div id="negativePercent">{{x.negativePercent}}</div>
          <x.Indicator />
        </ProgressBar>
      </template>
    );

    let progressBar = '[role="progressbar"]';
    let indicator = `${progressBar} > [data-state]`;

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

    let state = new State();

    await render(
      <template>
        <ProgressBar @value={{state.value}} @max={{state.max}} as |x|>
          <div id="value">{{x.value}}</div>
          <div id="percent">{{x.percent}}</div>
          <div id="negativePercent">{{x.negativePercent}}</div>
          <x.Indicator />
        </ProgressBar>
      </template>
    );

    let progressBar = '[role="progressbar"]';
    let indicator = `${progressBar} > [data-state]`;

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

  test('with a max, changing with same value', async function (assert) {
    class State {
      @tracked value = 0;
      @tracked max = 1000;
    }

    let state = new State();

    await render(
      <template>
        <ProgressBar @value={{state.value}} @max={{state.max}} as |x|>
          <div id="value">{{x.value}}</div>
          <div id="percent">{{x.percent}}</div>
          <div id="negativePercent">{{x.negativePercent}}</div>
          <x.Indicator />
        </ProgressBar>
      </template>
    );

    let progressBar = '[role="progressbar"]';
    let indicator = `${progressBar} > [data-state]`;

    assert.dom(progressBar).exists();
    assert.dom(indicator).exists();
    assert.dom(progressBar).hasAria('valuemin', '0');
    assert.dom(progressBar).hasAria('valuemax', '1000');
    assert.dom(progressBar).hasAria('valuenow', '0');
    assert.dom(progressBar).hasAria('valuetext', '0%');
    assert.dom(indicator).hasAttribute('data-max', '1000');
    assert.dom(indicator).hasAttribute('data-value', '0');
    assert.dom(indicator).hasAttribute('data-state', 'loading');

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

    state.max = 150;
    await rerender();

    assert.dom(progressBar).hasAria('valuemin', '0');
    assert.dom(progressBar).hasAria('valuemax', '150');
    assert.dom(progressBar).hasAria('valuenow', '100');
    assert.dom(progressBar).hasAria('valuetext', '67%');
    assert.dom(indicator).hasAttribute('data-max', '150');
    assert.dom(indicator).hasAttribute('data-value', '100');
    assert.dom(indicator).hasAttribute('data-state', 'loading');
  });
});
