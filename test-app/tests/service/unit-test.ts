import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';
import { service } from 'ember-primitives/service';

module('service()', function (hooks) {
  setupTest(hooks);

  module('(old) string-based service lookup', function () {
    test('implicit name', function (assert) {
      class State {
        foo = 2;
      }
      class Demo {
        @service state;
      }
    });

    test('explicit name', function (assert) {
      class State {
        foo = 2;
      }
      class Demo {
        @service('state') x;
      }
    });

    test('non-decorator', function (assert) {
      class State {
        foo = 2;
      }
      class Demo {
        state = service(this, 'state');
      }
    });
  });

  module('(new) explicit service usage', function () {
    test('decorator', function (assert) {
      class State {
        foo = 2;
      }
      class Demo {
        @service(State) state;
      }
    });

    test('non-decorator', function (assert) {
      class State {
        foo = 2;
      }
      class Demo {
        state = service(this, State);
      }
    });

    test('non-decorator: lazily imported service', function (assert) {
      class State {
        foo = 2;
      }
      class Demo {
        state = service(this, async () => {
          await Promise.resolve();

          return new State();
        });
      }
    });

    test('decorator: lazily imported service', function (assert) {
      class State {
        foo = 2;
      }
      class Demo {
        @service(async () => {
          await Promise.resolve();

          return new State();
        })
        state;
      }
    });
  });
});
