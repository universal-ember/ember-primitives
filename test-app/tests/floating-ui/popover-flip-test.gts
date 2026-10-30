import { assert as debugAssert } from '@ember/debug';
import { hash } from '@ember/helper';
import { render, settled } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Popover } from 'ember-primitives';

import { findElement, resetTestingContainerDimensions } from './test-helpers';

/**
 * #ember-testing has a transform, which makes it the containing block
 * for fixed elements. The body is what is relative to the viewport.
 */
const body = document.body;

/**
 * computePosition is async, and test waiters do not track it.
 */
async function positioned() {
  await new Promise(requestAnimationFrame);
  await new Promise(requestAnimationFrame);
  await settled();
}

async function scrollTo(selector: string, top: number) {
  const element = findElement(selector);

  await new Promise((resolve) => {
    element.addEventListener('scroll', resolve, { once: true });
    element.scrollTop = top;
  });
  await positioned();
}

function rectOf(selector: string) {
  const element = body.querySelector(selector);

  debugAssert(`Could not find element with '${selector}'`, element);

  return element.getBoundingClientRect();
}

function side() {
  const content = rectOf('#content');
  const anchor = rectOf('#anchor');

  if (content.bottom <= anchor.top) return 'above';
  if (content.top >= anchor.bottom) return 'below';

  return 'overlap';
}

module('<Popover> flipping', function (hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function () {
    resetTestingContainerDimensions();
  });

  test('stays in place when nothing overflows', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <Popover @placement="top" as |p|>
            <div
              id="anchor"
              style="position: fixed; top: 200px; left: 200px; width: 100px; height: 20px;"
              {{p.reference}}
            ></div>
            <p.Content
              id="content"
              style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
            >content</p.Content>
          </Popover>
        {{/in-element}}
      </template>
    );
    await positioned();

    assert.strictEqual(side(), 'above');
  });

  test('flips when the popover overflows the viewport', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <Popover @placement="top" as |p|>
            <div
              id="anchor"
              style="position: fixed; top: 4px; left: 200px; width: 100px; height: 20px;"
              {{p.reference}}
            ></div>
            <p.Content
              id="content"
              style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
            >content</p.Content>
          </Popover>
        {{/in-element}}
      </template>
    );
    await positioned();

    assert.strictEqual(side(), 'below');
  });

  test('flips when a scroll container clips the anchor', async function (assert) {
    await render(
      <template>
        <div
          id="scroller"
          style="position: fixed; top: 200px; left: 200px; width: 200px; height: 100px; overflow: auto;"
        >
          <div style="height: 100px;"></div>
          <Popover @placement="top" as |p|>
            <div id="anchor" style="width: 100px; height: 40px;" {{p.reference}}></div>
            <p.Content
              id="content"
              style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
            >content</p.Content>
          </Popover>
          <div style="height: 200px;"></div>
        </div>
      </template>
    );
    await positioned();

    assert.strictEqual(side(), 'above', 'the anchor is not clipped yet');

    await scrollTo('#scroller', 110);

    assert.strictEqual(side(), 'below', 'the anchor is clipped at the top');
  });

  test('elementContext can opt out of the anchor check', async function (assert) {
    await render(
      <template>
        <div
          id="scroller"
          style="position: fixed; top: 200px; left: 200px; width: 200px; height: 100px; overflow: auto;"
        >
          <div style="height: 100px;"></div>
          <Popover @placement="top" @flipOptions={{hash elementContext="floating"}} as |p|>
            <div id="anchor" style="width: 100px; height: 40px;" {{p.reference}}></div>
            <p.Content
              id="content"
              style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
            >content</p.Content>
          </Popover>
          <div style="height: 200px;"></div>
        </div>
      </template>
    );
    await positioned();

    await scrollTo('#scroller', 110);

    assert.strictEqual(side(), 'above');
  });

  test('elementContext can opt out of the popover check', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <Popover @placement="top" @flipOptions={{hash elementContext="reference"}} as |p|>
            <div
              id="anchor"
              style="position: fixed; top: 4px; left: 200px; width: 100px; height: 20px;"
              {{p.reference}}
            ></div>
            <p.Content
              id="content"
              style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
            >content</p.Content>
          </Popover>
        {{/in-element}}
      </template>
    );
    await positioned();

    assert.strictEqual(side(), 'above');
  });
});
