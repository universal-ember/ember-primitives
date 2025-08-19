import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

import { createSingleton } from 'ember-primitives/singleton';

module('Unit | createSingleton', function (hooks) {
  setupTest(hooks);

  class Demo {
    two = 2;
  }

  test('it works', function (assert) {
    const instance = createSingleton(this, Demo);

    assert.strictEqual(instance.two, 2);

    assert.strictEqual(createSingleton(this, Demo), instance);
  });
});
