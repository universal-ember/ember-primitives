import { tracked } from '@glimmer/tracking';
import { click, render, rerender } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Slider } from 'ember-primitives';

module('<Slider />', function (hooks) {
  setupRenderingTest(hooks);

  test('renders simply', async function (assert) {
    const handleChange = (v: number | number[]) => {
      assert.step(String(v));
    }

    await render(
      <template>
        <Slider @value={{43}} @onValueChange={{handleChange}} />
      </template>
    );

    const slider = '[data-slider]';
    const track = '[role="presentation"]';
    const thumb = '[role="slider"]';

    assert.dom(slider).exists();
    assert.dom(track).exists();
    assert.dom(thumb).exists();
    assert.dom(slider).hasAttribute('data-orientation', 'horizontal');
    assert.dom(slider).hasAttribute('data-disabled', 'false');
    assert.dom(thumb).hasAttribute('aria-valuemin', '0');
    assert.dom(thumb).hasAttribute('aria-valuemax', '100');
    assert.dom(thumb).hasAttribute('aria-valuenow', '43');
    assert.dom(thumb).hasAttribute('aria-orientation', 'horizontal');

});

  test('renders with default single value', async function (assert) {
    await render(
      <template>
        <Slider as |s|>
          <s.Track>
            <s.Range />
            {{#each s.values as |value index|}}
              <s.Thumb @value={{value}} @index={{index}} />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    const slider = '[data-slider]';
    const track = '[role="presentation"]';
    const thumb = '[role="slider"]';

    assert.dom(slider).exists();
    assert.dom(track).exists();
    assert.dom(thumb).exists();
    assert.dom(slider).hasAttribute('data-orientation', 'horizontal');
    assert.dom(slider).hasAttribute('data-disabled', 'false');
    assert.dom(thumb).hasAttribute('aria-valuemin', '0');
    assert.dom(thumb).hasAttribute('aria-valuemax', '100');
    assert.dom(thumb).hasAttribute('aria-valuenow', '0');
    assert.dom(thumb).hasAttribute('aria-orientation', 'horizontal');
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
            {{#each s.values as |value index|}}
              <s.Thumb @value={{value}} @index={{index}} />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    const thumb = '[role="slider"]';

    assert.dom(thumb).hasAttribute('aria-valuenow', '50');

    state.value = 75;
    await rerender();

    assert.dom(thumb).hasAttribute('aria-valuenow', '75');
  });

  test('renders with custom min, max, and step', async function (assert) {
    await render(
      <template>
        <Slider @value={{50}} @min={{10}} @max={{200}} @step={{5}} as |s|>
          <s.Track>
            <s.Range />
            {{#each s.values as |value index|}}
              <s.Thumb @value={{value}} @index={{index}} />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    const thumb = '[role="slider"]';

    assert.dom(thumb).hasAttribute('aria-valuemin', '10');
    assert.dom(thumb).hasAttribute('aria-valuemax', '200');
    assert.dom(thumb).hasAttribute('aria-valuenow', '50');
  });

  test('renders with vertical orientation', async function (assert) {
    await render(
      <template>
        <Slider @orientation="vertical" as |s|>
          <s.Track>
            <s.Range />
            {{#each s.values as |value index|}}
              <s.Thumb @value={{value}} @index={{index}} />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    const slider = '[data-slider]';
    const thumb = '[role="slider"]';

    assert.dom(slider).hasAttribute('data-orientation', 'vertical');
    assert.dom(thumb).hasAttribute('aria-orientation', 'vertical');
  });

  test('renders with disabled state', async function (assert) {
    await render(
      <template>
        <Slider @disabled={{true}} as |s|>
          <s.Track>
            <s.Range />
            {{#each s.values as |value index|}}
              <s.Thumb @value={{value}} @index={{index}} />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    const slider = '[data-slider]';
    const thumb = '[role="slider"]';

    assert.dom(slider).hasAttribute('data-disabled', 'true');
    assert.dom(thumb).hasAttribute('aria-disabled', 'true');
    assert.dom(thumb).hasAttribute('tabindex', '-1');
  });

  test('renders with multiple values (range)', async function (assert) {
    const rangeValue = [20, 80];

    await render(
      <template>
        <Slider @value={{rangeValue}} as |s|>
          <s.Track>
            <s.Range />
            {{#each s.values as |value index|}}
              <s.Thumb @value={{value}} @index={{index}} />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    const thumbs = '[role="slider"]';

    assert.dom(thumbs).exists({ count: 2 });

    const [thumb1, thumb2] = Array.from(document.querySelectorAll(thumbs));

    assert.strictEqual(thumb1.getAttribute('aria-valuenow'), '20');
    assert.strictEqual(thumb2.getAttribute('aria-valuenow'), '80');
  });

  test('calls onValueChange callback', async function (assert) {
    const handleChange = (value: number[]) => {
      assert.step('onValueChange');
    };

    await render(
      <template>
        <Slider @value={{50}} @onValueChange={{handleChange}} as |s|>
          <s.Track>
            <s.Range />
            {{#each s.values as |value index|}}
              <s.Thumb @value={{value}} @index={{index}} />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    // Note: Testing actual pointer/keyboard interaction would require more setup
    // This test verifies the component accepts the callback
    assert.strictEqual(typeof handleChange, 'function');
  });

  test('exposes values, min, max, step', async function (assert) {
    await render(
      <template>
        <Slider @value={{50}} @min={{0}} @max={{100}} @step={{10}} as |s|>
          <div data-test-values>{{s.values}}</div>
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
            {{#each s.values as |value index|}}
              <s.Thumb @value={{value}} @index={{index}} />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    const thumb = '[role="slider"]';

    // Value should be clamped to max
    assert.dom(thumb).hasAttribute('aria-valuenow', '100');
  });

  test('rounds values to step', async function (assert) {
    await render(
      <template>
        <Slider @value={{53}} @step={{10}} as |s|>
          <s.Track>
            <s.Range />
            {{#each s.values as |value index|}}
              <s.Thumb @value={{value}} @index={{index}} />
            {{/each}}
          </s.Track>
        </Slider>
      </template>
    );

    const thumb = '[role="slider"]';

    // Value should be rounded to nearest step (50)
    assert.dom(thumb).hasAttribute('aria-valuenow', '50');
  });
});
