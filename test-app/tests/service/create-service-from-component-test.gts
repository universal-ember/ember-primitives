import Component from '@glimmer/component';
import { getOwner } from '@ember/owner';
import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { createService } from 'ember-primitives/service';

module('createService (rendering)', function (hooks) {
  setupRenderingTest(hooks);

  test('using a context and an owner, should still only create one service if the context has the owner set to the same owner', async function (assert) {
    let id = 0;

    class State {
      foo = ++id;

      constructor() {
        assert.step('created');
      }
    }

    class Foo extends Component {
      a = createService(this, State);
      get b() {
        return createService(getOwner(this), State);
      }
      <template>{{this.a.foo}} {{this.b.foo}}</template>
    }

    await render(<template><Foo /></template>);

    assert.verifySteps(['created']);
    assert.verifySteps([]);
  });
});
