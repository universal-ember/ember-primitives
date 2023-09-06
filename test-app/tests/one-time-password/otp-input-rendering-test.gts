import { fillIn, findAll, focus, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { OTPInput } from 'ember-primitives';

import { fillOTP } from 'ember-primitives/test-support';

function getInputs() {
  let inputs = findAll('[data-primitives-code-segment]');

  return inputs as HTMLInputElement[];
}

function readValue() {
  return getInputs()
    .map((input) => input.value)
    .join('');
}

module('Rendering | <OTPInput>', function (hooks) {
  setupRenderingTest(hooks);

  test('@length: default number of inputs is 6', async function (assert) {
    await render(<template><OTPInput /></template>);

    assert.dom('input').exists({ count: 6 });
  });

  test('@length={{4}}', async function (assert) {
    await render(<template><OTPInput @length={{4}} /></template>);

    assert.dom('input').exists({ count: 4 });
  });

  test('@onChange is called (and debounced)', async function (assert) {
    let step = ({ code, complete }: { code: string; complete: boolean }) =>
      assert.step(`${code}:${complete}`);

    await render(<template><OTPInput @onChange={{step}} /></template>);

    assert.strictEqual(readValue(), '');

    await fillOTP('1');

    assert.verifySteps(['1:false']);

    await fillOTP('12');

    assert.verifySteps(['12:false']);

    await fillOTP('123456');

    assert.verifySteps(['123456:true']);
  });

  test('individually typing in each field focuses the next', async function (assert) {
    await render(<template><OTPInput /></template>);

    assert.strictEqual(readValue(), '');

    let inputs = getInputs() as [
      HTMLInputElement,
      HTMLInputElement,
      HTMLInputElement,
      HTMLInputElement,
    ];

    for (let input of inputs) {
      assert.notEqual(document.activeElement, input);
    }

    await focus(inputs[0]);
    assert.strictEqual(document.activeElement, inputs[0]);

    await fillIn(inputs[0], '0');
    assert.strictEqual(document.activeElement, inputs[1]);

    await fillIn(inputs[1], '0');
    assert.strictEqual(document.activeElement, inputs[2]);

    await fillIn(inputs[2], '0');
    assert.strictEqual(document.activeElement, inputs[3]);
  });
});
