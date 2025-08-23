import { render, setupOnerror } from '@ember/test-helpers';
import { module, skip, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Portal, PORTALS, PortalTargets } from 'ember-primitives';

module('Rendering | <Portal>', function (hooks) {
  setupRenderingTest(hooks);

  /**
   * We used to throw when there was no matching portal target.
   * But it's not safe to do so anymore.
   *
   * This is because we now support Reactive <PortalTarget>s
   * which can pop in and pop out at any time.
   */
  skip('errors without an existing portal target', async function (assert) {
    setupOnerror((error) => {
      assert.matches(error.message, /Could not find element by the given name: `does-not-exist`/);
    });

    await render(
      <template>
        <Portal @to="does-not-exist">
          content
        </Portal>
      </template>
    );
  });

  test('renders in to a portal target', async function (assert) {
    await render(
      <template>
        <PortalTargets />
        <Portal @to={{PORTALS.popover}}>
          content
        </Portal>
      </template>
    );

    assert.dom(`[data-portal-name="${PORTALS.popover}"]`).hasText('content');
  });

  test('Portals can nest with nested targets', async function (assert) {
    await render(
      <template>
        <PortalTargets />

        main content

        <div class="first-outer">
          <Portal @to={{PORTALS.popover}}>
            <div class="first">
              <PortalTargets />
              first layer

              <div class="second-outer">
                <Portal @to={{PORTALS.popover}}>
                  <div class="second">
                    <PortalTargets />
                    second layer

                    <div class="third-outer">
                      <Portal @to={{PORTALS.tooltip}}>
                        <div class="third">
                          tooltip / third layer
                        </div>
                      </Portal>
                    </div>
                  </div>
                </Portal>
              </div>

            </div>
          </Portal>
        </div>
      </template>
    );

    assert.dom().containsText('main content');
    assert.dom().containsText('first layer');
    assert.dom().containsText('second layer');
    assert.dom().containsText('tooltip / third layer');

    assert.dom('.third-outer').doesNotContainText('tooltip / third layer');
    assert.dom('.second-outer').doesNotContainText('second layer');
    assert.dom('.first-outer').doesNotContainText('first layer');
  });

  module('@append', function () {
    test('true appends', async function (assert) {
      await render(
        <template>
          <PortalTargets />
          <Portal @to={{PORTALS.popover}}>
            one
          </Portal>
          <Portal @to={{PORTALS.popover}} @append={{true}}>
            two
          </Portal>
        </template>
      );

      assert.dom().hasText('one two');
    });

    test('true appends, but a third without append will replace', async function (assert) {
      await render(
        <template>
          <PortalTargets />
          <Portal @to={{PORTALS.popover}}>
            one
          </Portal>
          <Portal @to={{PORTALS.popover}} @append={{true}}>
            two
          </Portal>
          <Portal @to={{PORTALS.popover}}>
            three
          </Portal>
        </template>
      );

      assert.dom().hasText('three');
    });
  });

  module('@to is an element', function () {
    test('element then Portal', async function (assert) {
      const element = document.createElement('output');

      await render(
        <template>
          {{element}}
          <Portal @to={{element}}>
            content here
          </Portal>
        </template>
      );

      assert.dom('output').hasText('content here');
    });

    test('Portal then element', async function (assert) {
      const element = document.createElement('output');

      await render(
        <template>
          <Portal @to={{element}}>
            content here
          </Portal>
          {{element}}
        </template>
      );

      assert.dom('output').hasText('content here');
    });
  });
});
