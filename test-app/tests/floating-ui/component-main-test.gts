import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { modifier } from 'ember-modifier';
import { FloatingUI } from 'ember-primitives/floating-ui';

import { findElement, resetTestingContainerDimensions } from './test-helpers';

module('floating-ui | component (main)', function (hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function () {
    resetTestingContainerDimensions();
  });

  test('it renders', async function (assert) {
    await render(
      <template>
        <FloatingUI as |reference floating|>
          <div id="hook" {{reference}} style="width: 200px; height: 40px"></div>
          <div id="loop" {{floating}} style="width: 200px; height: 20px"></div>
        </FloatingUI>
      </template>
    );

    const hook = findElement('#hook').getBoundingClientRect();
    const loop = findElement('#loop').getBoundingClientRect();

    assert.dom('#loop').hasStyle({ position: 'fixed' });
    assert.strictEqual(loop.top, hook.bottom, 'the floating element is below its reference');
    assert.strictEqual(
      loop.left + loop.width / 2,
      hook.left + hook.width / 2,
      'the floating element is centered on its reference'
    );
  });

  test('it renders with setReference', async function (assert) {
    const hookModifier = modifier(
      (
        element: HTMLElement | SVGElement,
        [setReference]: [(element: HTMLElement | SVGElement) => void]
      ) => {
        setReference(element);
      }
    );

    await render(
      <template>
        <FloatingUI as |reference floating util|>
          <div
            id="hook"
            {{hookModifier util.setReference}}
            style="width: 200px; height: 40px"
          ></div>
          <div id="loop" {{floating}} style="width: 200px; height: 20px"></div>
        </FloatingUI>
      </template>
    );

    const hook = findElement('#hook').getBoundingClientRect();
    const loop = findElement('#loop').getBoundingClientRect();

    assert.dom('#loop').hasStyle({ position: 'fixed' });
    assert.strictEqual(loop.top, hook.bottom, 'the floating element is below its reference');
    assert.strictEqual(
      loop.left + loop.width / 2,
      hook.left + hook.width / 2,
      'the floating element is centered on its reference'
    );
  });

  module('@placement', function () {
    test('has default value', async function (assert) {
      await render(
        <template>
          <FloatingUI as |reference floating|>
            <div {{reference}}>velcroReference</div>
            <div id="loop" {{floating}}></div>
          </FloatingUI>
        </template>
      );

      assert.dom('#loop').hasAttribute('data-placement', 'bottom');
    });

    test('has argument value', async function (assert) {
      await render(
        <template>
          <FloatingUI @placement="bottom-start" as |reference floating|>
            <div {{reference}}>velcroReference</div>
            <div id="loop" {{floating}}></div>
          </FloatingUI>
        </template>
      );

      assert.dom('#loop').hasAttribute('data-placement', 'bottom-start');
    });
  });

  module('@strategy', function () {
    test('has default value', async function (assert) {
      await render(
        <template>
          <FloatingUI as |reference floating|>
            <div {{reference}}>velcroReference</div>
            <div id="loop" {{floating}}></div>
          </FloatingUI>
        </template>
      );

      assert.dom('#loop').hasStyle({ position: 'fixed' });
    });

    test('has argument value', async function (assert) {
      await render(
        <template>
          <FloatingUI @strategy="absolute" as |reference floating|>
            <div {{reference}}>velcroReference</div>
            <div id="loop" {{floating}}></div>
          </FloatingUI>
        </template>
      );

      assert.dom('#loop').hasStyle({ position: 'absolute' });
    });
  });

  module('@offsetOptions', function () {
    test('can pass in distance', async function (assert) {
      const offsetDistance = 10;

      await render(
        <template>
          {{! render 2 Velcro's side by side, pass one a distance offset and compare the top values }}
          {{! template-lint-disable no-inline-styles }}
          <div style="display: flex">
            <FloatingUI @placement="bottom-start" as |reference floating|>
              <div {{reference}}>velcroReference</div>
              <div id="velcro1" {{floating}}>Velcro</div>
            </FloatingUI>
            <FloatingUI
              @offsetOptions={{offsetDistance}}
              @placement="bottom-start"
              as |reference floating|
            >
              <div {{reference}}>velcroReference</div>
              <div id="velcro2" {{floating}}>Velcro</div>
            </FloatingUI>
          </div>
        </template>
      );

      const velcro1 = findElement('#velcro1');
      const velcro2 = findElement('#velcro2');

      assert.strictEqual(
        velcro1.getBoundingClientRect().top + offsetDistance,
        velcro2.getBoundingClientRect().top
      );
    });

    test('can pass in skidding', async function (assert) {
      const offsetSkidding = 10;

      const offsetOptions = { crossAxis: offsetSkidding };

      await render(
        <template>
          {{! render 2 Velcro's atop the other, pass one a skidding offset and compare the left values }}
          <FloatingUI as |reference floating|>
            <div {{reference}}>velcroReference</div>
            <div id="velcro1" {{floating}}>Velcro</div>
          </FloatingUI>
          <FloatingUI @offsetOptions={{offsetOptions}} as |reference floating|>
            <div {{reference}}>velcroReference</div>
            <div id="velcro2" {{floating}}>Velcro</div>
          </FloatingUI>
        </template>
      );

      const velcro1 = findElement('#velcro1');
      const velcro2 = findElement('#velcro2');

      assert.strictEqual(
        velcro1.getBoundingClientRect().left + offsetSkidding,
        velcro2.getBoundingClientRect().left
      );
    });
  });
});
