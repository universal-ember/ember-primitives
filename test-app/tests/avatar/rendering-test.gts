import { renderSettled } from '@ember/renderer';
import { getRootElement, render, waitUntil } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Avatar } from 'ember-primitives';

module('<Avatar />', function (hooks) {
  setupRenderingTest(hooks);

  test('with correct image paths, the image loads', async function (assert) {
    await render(
      <template>
        <Avatar @src="https://avatars.githubusercontent.com/u/199018?v=4" as |a|>
          <a.Image />
          <a.Fallback>NVP</a.Fallback>
        </Avatar>
      </template>
    );

    assert.dom('img').exists();
    assert.dom().doesNotContainText('NVP');
  });

  test('with a broken path, the Fallback is used', async function (assert) {
    await render(
      <template>
        <Avatar @src="https://fake.uri" as |a|>
          <a.Image />
          <a.Fallback>NVP</a.Fallback>
        </Avatar>
      </template>
    );

    assert.dom('img').doesNotExist();
    assert.dom().containsText('NVP');
  });

  test('the fallback can be delayed', async function (assert) {
    render(
      <template>
        <Avatar @src="https://fake.uri" as |a|>
          <a.Image />
          <a.Fallback @delayMs={{150}}>NVP</a.Fallback>
        </Avatar>
      </template>
    );

    await renderSettled();
    assert.dom('img').doesNotExist();
    assert.dom().doesNotContainText('NVP');
    await waitUntil(() => getRootElement().textContent?.includes('NVP'));
    assert.dom().containsText('NVP');
  });
});
