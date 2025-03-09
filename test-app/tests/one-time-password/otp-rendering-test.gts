/* global out */
import { click, find, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { OTP } from 'ember-primitives';

import { fillOTP } from 'ember-primitives/test-support';

function getInputs() {
  const inputs = find('fieldset')?.querySelectorAll('input');

  if (!inputs) return [];

  return [...inputs] as HTMLInputElement[];
}

function readValue() {
  return getInputs()
    .map((input) => input.value)
    .join('');
}

module('Rendering | <OTP>', function (hooks) {
  setupRenderingTest(hooks);

  test('@length can be adjusted', async function (assert) {
    const step = ({ code }: { code: string }) => assert.step(code);

    await render(
      <template>
        <OTP @length={{4}} @onSubmit={{step}} as |x|>
          <x.Input />
          <x.Submit>submit</x.Submit>
        </OTP>
      </template>
    );

    assert.dom('input').exists({ count: 4 });

    await fillOTP('1234');
    await click('button');

    assert.verifySteps(['1234']);
  });

  test('@length={{6}} is the default', async function (assert) {
    const step = ({ code }: { code: string }) => assert.step(code);

    await render(
      <template>
        <OTP @length={{6}} @onSubmit={{step}} as |x|>
          <x.Input />
          <x.Submit>submit</x.Submit>
        </OTP>
      </template>
    );

    assert.dom('input').exists({ count: 6 });

    await fillOTP('123456');
    await click('button');

    assert.verifySteps(['123456']);
  });

  test(`The Input's <Fields> can be used`, async function (assert) {
    const step = ({ code }: { code: string }) => assert.step(code);

    await render(
      <template>
        <OTP @onSubmit={{step}} as |x|>
          <x.Input as |Fields|>
            <out>my extra info</out>
            <Fields />
          </x.Input>
          <x.Submit>submit</x.Submit>
        </OTP>
      </template>
    );

    assert.dom('out').exists();
    assert.dom('input').exists({ count: 6 });
  });

  test('@autoSubmit works', async function (assert) {
    const step = ({ code }: { code: string }) => assert.step(code);

    await render(
      <template>
        <OTP @autoSubmit={{true}} @onSubmit={{step}} as |x|>
          <x.Input />
          <x.Submit>submit</x.Submit>
        </OTP>
      </template>
    );

    await fillOTP('123456');

    assert.verifySteps(['123456']);
  });

  test('@autoSubmit with incomplete input does submit', async function (assert) {
    const step = ({ code }: { code: string }) => assert.step(code);

    await render(
      <template>
        <OTP @autoSubmit={{true}} @onSubmit={{step}} as |x|>
          <x.Input />
          <x.Submit>submit</x.Submit>
        </OTP>
      </template>
    );

    await fillOTP('123');

    assert.verifySteps([]);
  });

  test('@autoSubmit={{false}} is the default', async function (assert) {
    const step = ({ code }: { code: string }) => assert.step(code);

    await render(
      <template>
        <OTP @autoSubmit={{false}} @onSubmit={{step}} as |x|>
          <x.Input />
          <x.Submit>submit</x.Submit>
        </OTP>
      </template>
    );

    await fillOTP('123456');

    assert.verifySteps([], 'submit was not triggered');

    await click('button');

    assert.verifySteps(['123456']);
  });

  test('<Reset> clears the inputs', async function (assert) {
    const step = ({ code }: { code: string }) => assert.step(code);

    await render(
      <template>
        <OTP @onSubmit={{step}} as |x|>
          <x.Input />
          <x.Reset>reset</x.Reset>
        </OTP>
      </template>
    );

    await fillOTP('123456');

    assert.strictEqual(readValue(), '123456');

    await click('button');

    assert.strictEqual(readValue(), '');

    assert.verifySteps([], 'no submit occurred');
  });
});
