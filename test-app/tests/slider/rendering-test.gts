import { tracked } from '@glimmer/tracking';
import { fillIn, render, rerender } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Slider } from 'ember-primitives';

const slider = '.ember-primitives__slider';
const track = '.ember-primitives__slider__track';
const thumbInput = '.ember-primitives__slider__thumb-input';
const thumb = '.ember-primitives__slider__thumb';

module('<Slider />', function (hooks) {
  setupRenderingTest(hooks);

  test('renders simply (without a block)', async function (assert) {
    await render(<template><Slider @value={{43}} /></template>);

    assert.dom(slider).exists();
    assert.dom(track).exists();
    assert.dom(thumbInput).exists({ count: 1 });
    assert.dom(thumb).exists({ count: 1 });
    assert.dom(slider).hasAttribute('data-orientation', 'horizontal');
    assert.dom(slider).doesNotHaveAttribute('data-disabled');
    assert.dom(slider).doesNotHaveAttribute('data-multi');
    assert.dom(thumbInput).hasAttribute('min', '0');
    assert.dom(thumbInput).hasAttribute('max', '100');
    assert.dom(thumbInput).hasValue('43');
    assert.dom(thumbInput).hasAria('label', 'Value');
    assert.dom(thumb).hasAttribute('style', 'left: 43%');
  });

  test('renders with default single value', async function (assert) {
    await render(
      <template>
        <Slider as |s|>
          <s.Track>
            <s.Range />
            {{#each s.thumbs as |t|}}
              <s.Thumb @thumb={{t}} aria-label="Value" />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    assert.dom(slider).exists();
    assert.dom(track).exists();
    assert.dom(thumbInput).exists({ count: 1 });
    assert.dom(thumb).exists({ count: 1 });
    assert.dom(thumbInput).hasAttribute('min', '0');
    assert.dom(thumbInput).hasAttribute('max', '100');
    assert.dom(thumbInput).hasValue('0');
  });

  test('renders with a custom value', async function (assert) {
    class State {
      @tracked value = 50;
    }

    const state = new State();

    await render(
      <template>
        <Slider @value={{state.value}} as |s|>
          <s.Track>
            <s.Range />
            {{#each s.thumbs as |t|}}
              <s.Thumb @thumb={{t}} aria-label="Value" />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    assert.dom(thumbInput).hasValue('50');
    assert.dom(thumb).hasAttribute('style', 'left: 50%');

    state.value = 75;
    await rerender();

    assert.dom(thumbInput).hasValue('75');
    assert.dom(thumb).hasAttribute('style', 'left: 75%');
  });

  test('renders with custom min, max, and step', async function (assert) {
    await render(
      <template>
        <Slider @value={{50}} @min={{10}} @max={{200}} @step={{5}} as |s|>
          <s.Track>
            <s.Range />
            {{#each s.thumbs as |t|}}
              <s.Thumb @thumb={{t}} aria-label="Value" />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    assert.dom(thumbInput).hasAttribute('min', '10');
    assert.dom(thumbInput).hasAttribute('max', '200');
    assert.dom(thumbInput).hasAttribute('step', '5');
    assert.dom(thumbInput).hasValue('50');
  });

  test('renders with vertical orientation', async function (assert) {
    await render(
      <template>
        <Slider @value={{40}} @orientation="vertical" as |s|>
          <s.Track>
            <s.Range />
            {{#each s.thumbs as |t|}}
              <s.Thumb @thumb={{t}} aria-label="Value" />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    assert.dom(slider).hasAttribute('data-orientation', 'vertical');
    assert.dom(thumb).hasAttribute('style', 'bottom: 40%');
  });

  test('renders with disabled state', async function (assert) {
    await render(
      <template>
        <Slider @disabled={{true}} as |s|>
          <s.Track>
            <s.Range />
            {{#each s.thumbs as |t|}}
              <s.Thumb @thumb={{t}} aria-label="Value" />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    assert.dom(slider).hasAttribute('data-disabled');
    assert.dom(thumbInput).isDisabled();
    assert.dom(thumb).hasAttribute('data-disabled');
  });

  test('renders with multiple values (range)', async function (assert) {
    const rangeValue = [20, 80];

    await render(
      <template>
        <Slider @value={{rangeValue}} as |s|>
          <s.Track>
            <s.Range />
            {{#each s.thumbs as |t|}}
              <s.Thumb @thumb={{t}} aria-label="Value" />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    assert.dom(slider).hasAttribute('data-multi');
    assert.dom(thumbInput).exists({ count: 2 });
    assert.dom(thumb).exists({ count: 2 });

    const [input1, input2] = document.querySelectorAll<HTMLInputElement>(thumbInput);

    assert.strictEqual(input1?.value, '20');
    assert.strictEqual(input2?.value, '80');
  });

  test('calls onValueChange and onValueCommit when a thumb moves', async function (assert) {
    class State {
      @tracked value = 50;
    }

    const state = new State();

    const handleChange = (value: number | number[]) => {
      assert.step(`change:${value}`);
      state.value = value as number;
    };

    const handleCommit = (value: number | number[]) => {
      assert.step(`commit:${value}`);
    };

    await render(
      <template>
        <Slider
          @value={{state.value}}
          @onValueChange={{handleChange}}
          @onValueCommit={{handleCommit}}
          as |s|
        >
          <s.Track>
            <s.Range />
            {{#each s.thumbs as |t|}}
              <s.Thumb @thumb={{t}} aria-label="Value" />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    await fillIn(thumbInput, '60');

    // fillIn fires `input` and then `change`
    assert.verifySteps(['change:60', 'change:60', 'commit:60']);
    assert.strictEqual(state.value, 60);
  });

  test('thumbs cannot cross each other', async function (assert) {
    class State {
      @tracked value = [20, 80];
    }

    const state = new State();

    const handleChange = (value: number | number[]) => {
      state.value = value as number[];
    };

    await render(
      <template>
        <Slider @value={{state.value}} @onValueChange={{handleChange}} as |s|>
          <s.Track>
            <s.Range />
            {{#each s.thumbs as |t|}}
              <s.Thumb @thumb={{t}} aria-label="Value" />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    const firstInput = document.querySelector<HTMLInputElement>(thumbInput);

    assert.ok(firstInput, 'first thumb input exists');

    // try to drag the lower thumb past the upper thumb
    await fillIn(firstInput as HTMLInputElement, '95');

    assert.deepEqual(state.value, [80, 80], 'lower thumb is constrained by the upper thumb');
  });

  test('supports discrete tick values via an array @step', async function (assert) {
    const ticks = [0, 10, 20, 30, 40, 50];

    class State {
      @tracked value = 20;
    }

    const state = new State();

    const handleChange = (value: number | number[]) => {
      state.value = value as number;
    };

    await render(
      <template>
        <Slider @value={{state.value}} @step={{ticks}} @onValueChange={{handleChange}} as |s|>
          <s.Track>
            <s.Range />
            {{#each s.thumbs as |t|}}
              <s.Thumb @thumb={{t}} aria-label="Value" />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    // internally, the input works on tick indices
    assert.dom(thumbInput).hasAttribute('min', '0');
    assert.dom(thumbInput).hasAttribute('max', '5');
    assert.dom(thumbInput).hasAttribute('step', '1');
    assert.dom(thumbInput).hasValue('2');

    // moving to index 4 emits the tick value (40)
    await fillIn(thumbInput, '4');

    assert.strictEqual(state.value, 40);
  });

  test('exposes values, min, max, step', async function (assert) {
    await render(
      <template>
        <Slider @value={{50}} @min={{0}} @max={{100}} @step={{10}} as |s|>
          <div data-test-values>
            {{#each s.values as |value|}}{{value}}{{/each}}
          </div>
          <div data-test-min>{{s.min}}</div>
          <div data-test-max>{{s.max}}</div>
          <div data-test-step>{{s.step}}</div>
        </Slider>
      </template>
    );

    assert.dom('[data-test-values]').hasText('50');
    assert.dom('[data-test-min]').hasText('0');
    assert.dom('[data-test-max]').hasText('100');
    assert.dom('[data-test-step]').hasText('10');
  });

  test('clamps values within min and max', async function (assert) {
    await render(
      <template>
        <Slider @value={{150}} @min={{0}} @max={{100}} as |s|>
          <s.Track>
            <s.Range />
            {{#each s.thumbs as |t|}}
              <s.Thumb @thumb={{t}} aria-label="Value" />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    // Value should be clamped to max
    assert.dom(thumbInput).hasValue('100');
  });

  test('rounds values to step', async function (assert) {
    await render(
      <template>
        <Slider @value={{53}} @step={{10}} as |s|>
          <s.Track>
            <s.Range />
            {{#each s.thumbs as |t|}}
              <s.Thumb @thumb={{t}} aria-label="Value" />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    // Value should be rounded to nearest step (50)
    assert.dom(thumbInput).hasValue('50');
  });
});
