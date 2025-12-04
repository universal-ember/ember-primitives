import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

import { createService } from 'ember-primitives/service';

module('createService', function (hooks) {
  setupTest(hooks);

  test('class is singleton', function (assert) {
    let id = 0;

    class State {
      foo = ++id;

      constructor() {
        assert.step('created');
      }
    }

    const a = createService(this, State);

    assert.verifySteps(['created']);

    const b = createService(this, State);

    assert.verifySteps([]);
    assert.strictEqual(a.foo, b.foo);
    assert.strictEqual(a.foo, 1);
  });

  test('function is singleton', function (assert) {
    let id = 0;

    class State {
      foo = ++id;

      constructor() {
        assert.step('created');
      }
    }

    const make = () => new State();

    const a = createService(this, make);

    assert.verifySteps(['created']);

    const b = createService(this, make);

    assert.verifySteps([]);
    assert.strictEqual(a.foo, b.foo);
    assert.strictEqual(a.foo, 1);
  });
});
