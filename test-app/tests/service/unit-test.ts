// import { module, test } from 'qunit';
// import { setupTest } from 'ember-qunit';
//
// // import { service } from 'ember-primitives/service';
// import { link } from 'reactiveweb/link';

// module('service()', function (hooks) {
//   setupTest(hooks);
//
//   module('(old) string-based service lookup', function () {
//     test('implicit name', function (assert) {
//       class State {
//         foo = 2;
//       }
//       class Demo {
//         @service declare state: State;
//       }
//
//       const instance = link(new Demo(), this);
//
//       assert.ok(instance.state instanceof State);
//       assert.strictEqual(instance.state.foo, 2);
//     });
//
//     test('explicit name', function (assert) {
//       class State {
//         foo = 2;
//       }
//       class Demo {
//         @service('state') declare x: State;
//       }
//
//       const instance = link(new Demo(), this);
//
//       assert.ok(instance.state instanceof State);
//       assert.strictEqual(instance.state.foo, 2);
//     });
//
//     test('non-decorator', function (assert) {
//       class State {
//         foo = 2;
//       }
//       class Demo {
//         state = service(this, 'state');
//       }
//
//       const instance = link(new Demo(), this);
//
//       assert.ok(instance.state instanceof State);
//       assert.strictEqual(instance.state.foo, 2);
//     });
//   });
//
//   module('(new) explicit service usage', function () {
//     test('decorator', function (assert) {
//       class State {
//         foo = 2;
//       }
//       class Demo {
//         @service(State) declare state: State;
//       }
//
//       const instance = link(new Demo(), this);
//
//       assert.ok(instance.state instanceof State);
//       assert.strictEqual(instance.state.foo, 2);
//     });
//
//     test('non-decorator', function (assert) {
//       class State {
//         foo = 2;
//       }
//       class Demo {
//         state = service(this, State);
//       }
//
//       const instance = link(new Demo(), this);
//
//       assert.ok(instance.state instanceof State);
//       assert.strictEqual(instance.state.foo, 2);
//     });
//
//     test('non-decorator: lazily imported service', async function (assert) {
//       class State {
//         foo = 2;
//       }
//       class Demo {
//         state = service(this, async () => {
//           await Promise.resolve();
//
//           return new State();
//         });
//       }
//
//       const instance = link(new Demo(), this);
//
//       assert.notOk(instance.state instanceof State);
//       assert.ok(instance.state.isLoading);
//       await instance.state.promise;
//       assert.notOk(instance.state.isLoading);
//       assert.ok(instance.state.value instanceof State);
//       assert.strictEqual(instance.state.foo, 2);
//     });
//
//     test('decorator: lazily imported service', async function (assert) {
//       class State {
//         foo = 2;
//       }
//       class Demo {
//         @service(async () => {
//           await Promise.resolve();
//
//           return new State();
//         })
//         declare state: State;
//       }
//
//       const instance = link(new Demo(), this);
//
//       assert.notOk(instance.state instanceof State);
//       assert.ok(instance.state.isLoading);
//       await instance.state.promise;
//       assert.notOk(instance.state.isLoading);
//       assert.ok(instance.state.value instanceof State);
//       assert.strictEqual(instance.state.foo, 2);
//     });
//   });
// });
