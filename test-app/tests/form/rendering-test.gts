import { click, fillIn, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Form } from 'ember-primitives';
import { cell } from 'ember-resources';

module('<Form />', function (hooks) {
  setupRenderingTest(hooks);

  test('input works', async function (assert) {
    const data = cell<any>({});
    const update = (x: any) => (data.current = x);

    await render(<template>
      <Form @onChange={{update}}>
        <label>first
          <input name="first" />
        </label>
      </Form>
    </template>);

    assert.dom('input').hasValue('');
    assert.notOk(data.current.first);

    await fillIn('input', 'hello');

    assert.strictEqual(data.current.first, 'hello');
  });

  test('submit works', async function (assert) {
    const data = cell<any>({});
    const update = (x: any) => (data.current = x);

    await render(<template>
      <Form @onChange={{update}}>
        <label>first
          <input name="first" value="from-dom" />
        </label>
        <button type="submit">submit</button>
      </Form>
    </template>);

    assert.notOk(data.current.first);

    await click('button');

    assert.strictEqual(data.current.first, 'from-dom');
  });
});
