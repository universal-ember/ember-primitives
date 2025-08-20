import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

import { createStore } from 'ember-primitives/store';

module('Unit | createStore', function (hooks) {
  setupTest(hooks);

  test('it works', function (assert) {
    class Demo {
      two = 2;
    }

    const instance = createStore(this, Demo);

    assert.strictEqual(instance.two, 2);

    assert.strictEqual(createStore(this, Demo), instance, 'is the same instance');
  });

  test('can be lazy', function (assert) {
    class Demo {
      two = 2;

      constructor() {
        assert.step('created');
      }
    }
    class Host {
      get foo() {
        return createStore(this, Demo).two;
      }
    }

    const instance = new Host();

    assert.verifySteps([]);

    assert.strictEqual(instance.foo, 2);

    assert.verifySteps(['created']);
  });

  test('can use a functor', function (assert) {
    class Demo {
      declare num: number;
      constructor(num) {
        this.num = num;
      }
    }

    const instance = createStore(this, () => new Demo(3));

    assert.strictEqual(instance.num, 3);
  });

  test('different functors are cached separately', function (assert) {
    class Demo {
      declare num: number;
      constructor(num) {
        this.num = num;
      }
    }

    const instance3 = createStore(this, () => new Demo(3));
    const instance2 = createStore(this, () => new Demo(2));
    const instance2again = createStore(this, () => new Demo(2));

    assert.notStrictEqual(instance3.num, instance2.num, 'intatiated differently');
    assert.strictEqual(instance2again.num, instance2.num, 'contents *can* match tho');
    assert.notStrictEqual(
      instance2again,
      instance2,
      'instances do not match (because every arrow function is unique)'
    );
  });
});
