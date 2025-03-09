import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { anchorTo } from 'ember-primitives/floating-ui';

import { addDataAttributes, findElement, resetTestingContainerDimensions } from './test-helpers';

module('floating-ui | anchorTo', function (hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function () {
    resetTestingContainerDimensions();
  });

  test('it renders', async function (assert) {
    await render(
      <template>
        <div id="reference">Reference</div>
        <div {{anchorTo "#reference"}}></div>
      </template>
    );

    assert.ok(true);
  });

  module('@placement', function () {
    const middleware = [addDataAttributes()];

    test('has default value', async function (assert) {
      await render(
        <template>
          <div id="velcro-reference">Velcro reference</div>
          <div id="velcro" {{anchorTo "#velcro-reference" middleware=middleware}}>Velcro</div>
        </template>
      );

      assert.dom('#velcro ').hasAttribute('data-placement', 'bottom');
    });

    test('has named argument value', async function (assert) {
      await render(
        <template>
          <div id="velcro-reference">Velcro reference</div>
          <div
            id="velcro"
            {{anchorTo "#velcro-reference" placement="bottom-start" middleware=middleware}}
          >Velcro</div>
        </template>
      );

      assert.dom('#velcro ').hasAttribute('data-placement', 'bottom-start');
    });
  });

  module('@strategy', function () {
    const middleware = [addDataAttributes()];

    test('has default value', async function (assert) {
      await render(
        <template>
          <div id="velcro-reference">Velcro reference</div>
          <div id="velcro" {{anchorTo "#velcro-reference" middleware=middleware}}>Velcro</div>
        </template>
      );

      assert.dom('#velcro ').hasAttribute('data-strategy', 'fixed');
    });

    test('has named argument value', async function (assert) {
      await render(
        <template>
          <div id="velcro-reference">Velcro reference</div>
          <div
            id="velcro"
            {{anchorTo "#velcro-reference" strategy="absolute" middleware=middleware}}
          >Velcro</div>
        </template>
      );

      assert.dom('#velcro ').hasAttribute('data-strategy', 'absolute');
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
            <div>
              <div id="velcro-reference">Velcro reference</div>
              <div id="velcro1" {{anchorTo "#velcro-reference"}}>Velcro</div>
            </div>
            <div>
              <div>velcroReference</div>
              <div
                id="velcro2"
                {{anchorTo
                  "#velcro-reference"
                  offsetOptions=offsetDistance
                  placement="bottom-start"
                }}
              >Velcro</div>
            </div>
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
          <div>
            <div id="velcro-reference">Velcro reference</div>
            <div id="velcro1" {{anchorTo "#velcro-reference"}}>Velcro</div>
          </div>
          <div>
            <div id="velcro-reference2">velcroReference</div>
            <div
              id="velcro2"
              {{anchorTo "#velcro-reference2" offsetOptions=offsetOptions}}
            >Velcro</div>
          </div>
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
