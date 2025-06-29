import { module, test } from 'qunit';

import { castToBoolean } from 'ember-primitives/qp';

module('qp | castToBoolean', function (hooks) {
  const scenarios = [
    ['0', false],
    ['false', false],
    ['f', false],
    ['null', false],
    ['off', false],
    ['undefined', false],
    ['no', false],
    ['1', true],
    ['true', true],
    ['on', true],
    ['x', true],
    ['bep', true],
    ['yes', true],
  ] as const;

  for (const [input, expected] of scenarios) {
    test(`test: ${input}`, async function (assert) {
      assert.strictEqual(castToBoolean(input), expected, `Expect ${input} to be ${expected}`);
    });
  }
});
