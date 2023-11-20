import { settled } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { colorScheme, getColorScheme, localPreference, prefers, removeColorScheme,setColorScheme, sync} from 'ember-primitives/color-scheme';

module('color-scheme', function (hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function () {
    colorScheme.update('');
    localPreference.delete();
    sync();
  })

  test('colorScheme', async function (assert) {
    colorScheme.update('dark');
    assert.strictEqual(colorScheme.current, 'dark');
    colorScheme.update('light');
    assert.strictEqual(colorScheme.current, 'light');
  });

  test('colorScheme on/off update', async function (assert) {
    let callback = (theme: string) => assert.step(theme);

    colorScheme.on.update(callback);

    assert.verifySteps([]);

    colorScheme.update('dark');
    await settled();
    assert.verifySteps(['dark']);

    colorScheme.update('light')
    await settled();
    assert.verifySteps(['light']);

    colorScheme.off.update(callback);
    colorScheme.update('dark')
    await settled();
    assert.verifySteps([]);
  });


  test('get/set/remove ColorScheme', function (assert) {
    setColorScheme('synthwave');
    assert.strictEqual(getColorScheme(), 'synthwave');

    setColorScheme('dark');
    assert.strictEqual(getColorScheme(), 'dark');

    removeColorScheme();
    assert.strictEqual(getColorScheme(), '');
  });

  test('get/set/remove ColorScheme on an element', function (assert) {
    let el = document.createElement('div');

    assert.strictEqual(getColorScheme(el), '');

    setColorScheme(el, 'synthwave');
    assert.strictEqual(getColorScheme(el), 'synthwave');

    setColorScheme(el, 'dark');
    assert.strictEqual(getColorScheme(el), 'dark');

    removeColorScheme(el);
    assert.strictEqual(getColorScheme(el), '');
  })

  test('localPreference', function (assert) {
    assert.strictEqual(typeof localPreference.isSet(), 'boolean');

    localPreference.update('dark');

    assert.true(localPreference.isSet());
    assert.strictEqual(localPreference.read(), 'dark');

    localPreference.delete();
    assert.false(localPreference.isSet())
  });

  test('prefers', function (assert) {
    // this is only set via browser, so these tests are kinda silly
    assert.strictEqual(typeof prefers.dark(), 'boolean');
    assert.strictEqual(typeof prefers.light(), 'boolean');
    assert.strictEqual(typeof prefers.custom('synthwave'), 'boolean');
    assert.strictEqual(typeof prefers.none(), 'boolean');
  })

  test('sync', function (assert) {
    localPreference.delete();
    colorScheme.update('');

    assert.notOk(colorScheme.current);

    sync();

    assert.ok(colorScheme.current);
  });
});
