import { click, find, findAll, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Rating } from 'ember-primitives';

import { rating as createTestHelper } from 'ember-primitives/test-support';

import type { TOC } from '@ember/component/template-only';

interface IconSignature {
  Element: HTMLElement;
  Args: {
    isSelected: boolean;
    percentSelected: number;
    value: number;
    readonly: boolean;
  };
}

const label = '.ember-primitives__rating__label';
const star = '.ember-primitives__rating__item';
const selected = `[data-selected]`;
const readonly = `[data-readonly]`;
const checked = ` [checked]`;

/**
 * NOTE: these tests directly touch the DOM because I have to test
 *       that the implementation of both the component and the test helpers
 *       do what I expect.
 *
 *       Consumers of this component should not interact with the DOM.
 *       It is private api.
 */
module('<Rating>', function (hooks) {
  setupRenderingTest(hooks);

  const rating = createTestHelper();

  module('edges', function () {
    test('does not allow negative values', async function (assert) {
      await render(<template><Rating /></template>);

      await assert.rejects(rating.select(-1), /Is the number \(-1\) correct/);
    });

    test('does not allow values over the maximum', async function (assert) {
      await render(<template><Rating /></template>);

      await assert.rejects(rating.select(6), /Is the number \(6\) correct/);
    });

    test('errors when wrong or incorrect thing rendered', async function (assert) {
      assert.throws(() => rating.value, /Could not find the root element/);
      // @ts-expect-error
      await assert.rejects(rating.select(), /Could not find the root element/);
      assert.throws(() => rating.stars, /There are no stars/);
    });
  });

  module('examples', function () {
    test('consumer example', async function (assert) {
      await render(<template><Rating /></template>);

      assert.strictEqual(rating.value, 0);
      assert.false(rating.isReadonly);

      await rating.select(3);
      assert.strictEqual(rating.value, 3);
      assert.strictEqual(rating.stars, '★ ★ ★ ☆ ☆');

      // Toggle
      await rating.select(3);
      assert.strictEqual(rating.value, 0);
      assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆');
    });

    test('consumer example (multiple)', async function (assert) {
      await render(
        <template>
          <Rating data-test-first />
          <Rating data-test-second />
        </template>
      );

      const first = createTestHelper('[data-test-first]');
      const second = createTestHelper('[data-test-second]');

      assert.strictEqual(first.value, 0, 'first Rating has no selection');
      assert.strictEqual(second.value, 0, 'second Rating has no selection');

      await first.select(3);
      assert.strictEqual(first.value, 3, 'first Rating now has 3 stars');
      assert.strictEqual(second.value, 0, 'second Rating is still unchanged');

      await second.select(4);
      assert.strictEqual(second.value, 4, 'second Rating now has 4 stars');
      assert.strictEqual(first.value, 3, 'first Rating is still unchanged (at 3)');

      // Toggle First
      await first.select(3);
      assert.strictEqual(first.value, 0, 'first Rating is toggled from 3 to 0');
      assert.strictEqual(second.value, 4, 'second Rating is still unchanged (at 4)');

      // Toggle Second
      await second.select(4);
      assert.strictEqual(second.value, 0, 'second Rating is toggled from 4 to 0');
      assert.strictEqual(first.value, 0, 'first Rating is still unchanged (at 0)');
    });

    test('What not to do', async function (assert) {
      await render(<template><Rating /></template>);

      assert.dom(`[data-selected]`).doesNotExist();
      assert.dom(`[data-readonly]`).doesNotExist();

      await click(`[data-number="3"] input`);
      assert.dom(`[data-selected]`).exists({ count: 3 });

      // Toggle
      await click(`[data-number="3"] input`);
      assert.dom(`[data-selected]`).doesNotExist();
    });
  });

  test('defaults', async function (assert) {
    await render(<template><Rating /></template>);

    assert.dom(star).exists({ count: 5 });
    assert.dom('[name]').exists({ count: 5 });
    assert.dom('[type="radio"]').exists({ count: 5 });
    assert.dom('[readonly]').doesNotExist();
    assert.dom('[visually-hidden]').exists({ count: 5 });
    assert.dom('[aria-hidden]').exists({ count: 5 });

    assert.dom(star + selected).doesNotExist();
    assert.dom(star + checked).doesNotExist();
    assert.dom(star + readonly).doesNotExist('no checked radios');
    assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆');

    await rating.select(3);
    assert.dom(star + selected).exists({ count: 3 });
    assert.dom('input[value="3"]').isChecked('checked radio has 3 for value');
    assert.strictEqual(rating.stars, '★ ★ ★ ☆ ☆');

    await rating.select(5);
    assert.dom(star + selected).exists({ count: 5 });
    assert.dom('input[value="5"]').isChecked('checked radio has 5 for value');
    assert.strictEqual(rating.stars, '★ ★ ★ ★ ★');

    await rating.select(1);
    assert.dom(star + selected).exists({ count: 1 });
    assert.dom('input[value="1"]').isChecked('checked radio has 1 for value');
    assert.strictEqual(rating.stars, '★ ☆ ☆ ☆ ☆');
  });

  test('toggles', async function (assert) {
    await render(<template><Rating /></template>);

    assert.dom(star).exists({ count: 5 });
    assert.dom(star + selected).doesNotExist();
    assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆');

    await rating.select(3);
    assert.dom(star + selected).exists({ count: 3 });
    assert.strictEqual(rating.stars, '★ ★ ★ ☆ ☆');

    await rating.select(3);
    assert.dom(star + selected).doesNotExist();
    assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆');
  });

  test('@icon (string)', async function (assert) {
    await render(<template><Rating @icon="x" /></template>);

    assert.dom(star).exists({ count: 5 });
    assert.dom(star + selected).doesNotExist();
    assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆');
    assert.strictEqual(rating.starTexts, 'x x x x x');

    await rating.select(3);
    assert.dom(star + selected).exists({ count: 3 });
    assert.strictEqual(rating.stars, '★ ★ ★ ☆ ☆');
    assert.strictEqual(rating.starTexts, 'x x x x x');

    await rating.select(3);
    assert.dom(star + selected).doesNotExist();
    assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆');
    assert.strictEqual(rating.starTexts, 'x x x x x');
  });

  test('fractional (numbers)', async function (assert) {
    const step = (x: number | undefined) => assert.step(`${x}`);
    const Icon: TOC<IconSignature> = <template>{{step @percentSelected}}</template>;

    await render(<template><Rating @icon={{Icon}} /></template>);

    assert.verifySteps(['0', '0', '0', '0', '0']);

    await rating.select(2);

    assert.verifySteps(['100', '100', '0', '0', '0']);
  });

  test('fractional', async function (assert) {
    const Icon: TOC<IconSignature> = <template>{{@percentSelected}}</template>;

    await render(
      <template>
        <Rating as |rating|>
          <rating.Range step="0.25" />
          <rating.Stars @icon={{Icon}} />
        </Rating>
      </template>
    );

    await rating.select(2.5);
    assert.strictEqual(rating.value, 2.5);

    await rating.select(0.25);
    assert.strictEqual(rating.value, 0.25);
  });

  test('@max=7 (number)', async function (assert) {
    await render(<template><Rating @max={{7}} /></template>);

    assert.dom(star).exists({ count: 7 });
    assert.dom(star + selected).doesNotExist();
    assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆ ☆ ☆');

    await rating.select(3);
    assert.dom(star + selected).exists({ count: 3 });
    assert.strictEqual(rating.stars, '★ ★ ★ ☆ ☆ ☆ ☆');

    await rating.select(7);
    assert.dom(star + selected).exists({ count: 7 });
    assert.strictEqual(rating.stars, '★ ★ ★ ★ ★ ★ ★');
  });

  test('@max=7 (string)', async function (assert) {
    await render(<template><Rating @max={{7}} /></template>);

    assert.dom(star).exists({ count: 7 });
    assert.dom(star + selected).doesNotExist();
    assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆ ☆ ☆');

    await rating.select(3);
    assert.dom(star + selected).exists({ count: 3 });
    assert.strictEqual(rating.stars, '★ ★ ★ ☆ ☆ ☆ ☆');

    await rating.select(7);
    assert.dom(star + selected).exists({ count: 7 });
    assert.strictEqual(rating.stars, '★ ★ ★ ★ ★ ★ ★');
  });

  test('@icon (component)', async function (assert) {
    const Icon: TOC<IconSignature> = <template>
      <div ...attributes>
        {{#if @isSelected}}
          (x)
        {{else}}
          ()
        {{/if}}
      </div>
    </template>;

    await render(<template><Rating @icon={{Icon}} /></template>);

    assert.dom(star).exists({ count: 5 });
    assert.dom(star + selected).doesNotExist();
    assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆');
    assert.strictEqual(rating.starTexts, '() () () () ()');

    await rating.select(3);
    assert.dom(star + selected).exists({ count: 3 });
    assert.strictEqual(rating.stars, '★ ★ ★ ☆ ☆');
    assert.strictEqual(rating.starTexts, '(x) (x) (x) () ()');

    await rating.select(3);
    assert.dom(star + selected).doesNotExist();
    assert.strictEqual(rating.stars, '☆ ☆ ☆ ☆ ☆');
    assert.strictEqual(rating.starTexts, '() () () () ()');
  });

  test('@readonly={{true}}', async function (assert) {
    await render(<template><Rating @readonly={{true}} /></template>);

    assert.strictEqual(rating.value, 0);
    assert.true(rating.isReadonly, 'is readonly');
    assert.dom(label).doesNotExist();

    await rating.select(3);
    assert.strictEqual(rating.value, 0);
  });

  test('@interactive={{false}}', async function (assert) {
    await render(<template><Rating @interactive={{false}} /></template>);

    assert.strictEqual(rating.value, 0);
    assert.true(rating.isReadonly, 'is readonly');
    assert.strictEqual(rating.label, 'Rated 0 out of 5');

    await rating.select(3);
    assert.strictEqual(rating.value, 0);
  });

  test('<:label> (legend)', async function (assert) {
    await render(
      <template>
        <Rating>
          <:label>
            A Label!
          </:label>
        </Rating>
      </template>
    );

    assert.dom('legend').exists();
    assert.dom('legend').hasText('A Label!');
  });

  module('half-ratings', function () {
    test('@step={{0.5}} with @value={{3.5}}', async function (assert) {
      await render(<template><Rating @step={{0.5}} @value={{3.5}} /></template>);

      assert.strictEqual(rating.value, 3.5);
      assert.dom('[data-number="3"]').hasAttribute('data-percent-selected', '100');
      assert.dom('[data-number="4"]').hasAttribute('data-percent-selected', '50');
      assert.dom('[data-number="5"]').hasAttribute('data-percent-selected', '0');
    });

    test('@step={{0.5}} with string @iconHalf', async function (assert) {
      await render(
        <template><Rating @step={{0.5}} @value={{2.5}} @icon="★" @iconHalf="⯨" /></template>
      );

      assert.strictEqual(rating.value, 2.5);
      assert.strictEqual(rating.starTexts, '★ ★ ⯨ ★ ★');
    });

    test('@step={{0.5}} interactive selection', async function (assert) {
      await render(
        <template>
          <Rating @step={{0.5}} as |r|>
            <r.Range step="0.5" />
            <r.Stars />
          </Rating>
        </template>
      );

      await rating.select(3.5);
      assert.strictEqual(rating.value, 3.5);

      await rating.select(1.5);
      assert.strictEqual(rating.value, 1.5);

      // Toggle
      await rating.select(1.5);
      assert.strictEqual(rating.value, 0);
    });

    test('@step={{0.25}} quarter-star ratings', async function (assert) {
      await render(
        <template>
          <Rating @step={{0.25}} @value={{3.75}} as |r|>
            <r.Range step="0.25" />
            <r.Stars />
          </Rating>
        </template>
      );

      assert.strictEqual(rating.value, 3.75);
      assert.dom('[data-number="3"]').hasAttribute('data-percent-selected', '100');
      assert.dom('[data-number="4"]').hasAttribute('data-percent-selected', '75');
    });

    test('@step={{0.5}} with component icon uses percentSelected', async function (assert) {
      const Icon: TOC<IconSignature> = <template>
        <span data-test-percent={{@percentSelected}}>
          {{#if (lte @percentSelected 0)}}
            empty
          {{else if (lt @percentSelected 100)}}
            half
          {{else}}
            full
          {{/if}}
        </span>
      </template>;

      const lte = (a: number, b: number) => a <= b;
      const lt = (a: number, b: number) => a < b;

      await render(
        <template><Rating @step={{0.5}} @value={{2.5}} @icon={{Icon}} /></template>
      );

      assert.strictEqual(rating.value, 2.5);
      assert.strictEqual(rating.starTexts, 'full full half empty empty');

      const items = findAll('[data-test-percent]');

      assert.strictEqual(items[0]?.getAttribute('data-test-percent'), '100');
      assert.strictEqual(items[1]?.getAttribute('data-test-percent'), '100');
      assert.strictEqual(items[2]?.getAttribute('data-test-percent'), '50');
      assert.strictEqual(items[3]?.getAttribute('data-test-percent'), '0');
      assert.strictEqual(items[4]?.getAttribute('data-test-percent'), '0');
    });

    test('@step rounding handles floating point precision', async function (assert) {
      await render(
        <template>
          <Rating @step={{0.1}} @value={{3.3}} as |r|>
            <r.Range step="0.1" />
            <r.Stars />
          </Rating>
        </template>
      );

      assert.strictEqual(rating.value, 3.3);

      // Verify it rounds correctly
      await rating.select(2.15);

      // Should round to nearest 0.1 (either 2.1 or 2.2 depending on rounding behavior)
      const isCloseTo2_1 = Math.abs(rating.value - 2.1) < 0.01;
      const isCloseTo2_2 = Math.abs(rating.value - 2.2) < 0.01;
      const roundedCorrectly = isCloseTo2_1 ? true : isCloseTo2_2;

      assert.ok(roundedCorrectly, `Value ${rating.value} should be close to 2.1 or 2.2`);
    });

    test('@iconHalf without @step uses default whole stars', async function (assert) {
      await render(<template><Rating @iconHalf="⯨" @value={{3}} /></template>);

      assert.strictEqual(rating.value, 3);
      // No half stars should show with whole number value
      assert.strictEqual(rating.starTexts, '★ ★ ★ ★ ★');
    });

    test('half-rating with @onChange callback', async function (assert) {
      let capturedValue: number | undefined;
      const onChange = (value: number) => {
        capturedValue = value;
      };

      await render(
        <template>
          <Rating @step={{0.5}} @onChange={{onChange}} as |r|>
            <r.Range step="0.5" />
            <r.Stars />
          </Rating>
        </template>
      );

      await rating.select(4.5);
      assert.strictEqual(capturedValue, 4.5, 'onChange called with fractional value');
      assert.strictEqual(rating.value, 4.5);
    });

    test('@step={{0.5}} data attributes are correct', async function (assert) {
      await render(<template><Rating @step={{0.5}} @value={{3.5}} /></template>);

      const root = find('.ember-primitives__rating');

      assert.dom(root).hasAttribute('data-value', '3.5');

      // Check percent-selected for each star
      assert.dom('[data-number="1"]').hasAttribute('data-percent-selected', '100');
      assert.dom('[data-number="2"]').hasAttribute('data-percent-selected', '100');
      assert.dom('[data-number="3"]').hasAttribute('data-percent-selected', '100');
      assert.dom('[data-number="4"]').hasAttribute('data-percent-selected', '50');
      assert.dom('[data-number="5"]').hasAttribute('data-percent-selected', '0');

      // Check selected attribute
      assert.dom('[data-number="1"]').hasAttribute('data-selected', 'true');
      assert.dom('[data-number="2"]').hasAttribute('data-selected', 'true');
      assert.dom('[data-number="3"]').hasAttribute('data-selected', 'true');
      assert.dom('[data-number="4"]').hasAttribute('data-selected', 'false');
      assert.dom('[data-number="5"]').hasAttribute('data-selected', 'false');
    });

    test('@step={{0.5}} with @readonly', async function (assert) {
      await render(
        <template>
          <Rating @step={{0.5}} @value={{3.5}} @readonly={{true}} as |r|>
            <r.Range step="0.5" />
            <r.Stars />
          </Rating>
        </template>
      );

      assert.strictEqual(rating.value, 3.5);
      assert.true(rating.isReadonly);

      await rating.select(2.5);
      assert.strictEqual(rating.value, 3.5, 'value does not change when readonly');
    });
  });
});
