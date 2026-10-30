import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { screen } from '@testing-library/dom';
import { Rating } from 'ember-primitives';

module('<Rating> accessible names', function (hooks) {
  setupRenderingTest(hooks);

  test('each radio is named by its value', async function (assert) {
    await render(<template><Rating /></template>);

    for (const name of ['1 star', '2 star', '3 star', '4 star', '5 star']) {
      assert.dom(screen.getByRole('radio', { name })).exists();
    }
  });

  test('the <:label> block names the group', async function (assert) {
    await render(
      <template>
        <Rating>
          <:label>Rate me</:label>
        </Rating>
      </template>
    );

    assert.dom(screen.getByRole('group', { name: 'Rate me' })).exists();
  });

  test('a rating that is not interactive summarizes itself', async function (assert) {
    await render(<template><Rating @value={{2}} @interactive={{false}} /></template>);

    assert.dom('.ember-primitives__rating__label').hasText('Rated 2 out of 5');
  });
});
