import { assert as debugAssert } from '@ember/debug';
import { fn } from '@ember/helper';
import { click, find, focus, render, triggerKeyEvent, waitUntil } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Menu, PortalTargets } from 'ember-primitives';

import type { SetupService } from 'ember-primitives';

module('Rendering | menu', function (hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(async function () {
    let primitivesService = this.owner.lookup('service:ember-primitives/setup') as SetupService;

    primitivesService.setup();
  });

  // due to the way tabster works, we have to wait a bit for the focus to be correctly set
  function waitForFocus(selector: string) {
    return waitUntil(
      function () {
        return document.activeElement === find(selector);
      },
      { timeout: 2000 }
    );
  }

  test('can be opened/closed using the trigger and has correct aria attributes', async function (assert) {
    await render(
      <template>
        <PortalTargets />

        <Menu as |m|>
          <m.Trigger class="trigger">
            Trigger
          </m.Trigger>

          <m.Content class="content" as |c|>
            <c.Item>Item 1</c.Item>
            <c.Item>Item 2</c.Item>
            <c.Separator />
            <c.Item>Item 3</c.Item>
          </m.Content>
        </Menu>
      </template>
    );

    assert.dom('.trigger').exists({ count: 1 });
    assert.dom('.trigger').hasTagName('button');
    assert.dom('.trigger').doesNotHaveAttribute('aria-controls');
    assert.dom('.trigger').hasAttribute('aria-haspopup', 'menu');
    assert.dom('.trigger').hasAttribute('aria-expanded', 'false');
    assert.dom('.trigger').hasText('Trigger');
    assert.dom('.content').doesNotExist();

    await click('.trigger');

    assert.dom('.content').exists({ count: 1 });

    let content = find('.content');

    debugAssert(`There must be a content element with id set`, content?.id);

    assert.dom('.trigger').hasAttribute('aria-controls', content.id);
    assert.dom('.trigger').hasAttribute('aria-haspopup', 'menu');
    assert.dom('.trigger').hasAttribute('aria-expanded', 'true');
    assert.dom('.content').hasAttribute('role', 'menu');
    assert.dom('[role="menuitem"]').exists({ count: 3 });
    assert.dom('[role="menuitem"]:nth-of-type(1)').hasText('Item 1');
    assert.dom('[role="menuitem"]:nth-of-type(2)').hasText('Item 2');
    assert.dom('[role="menuitem"]:nth-of-type(3)').hasText('Item 3');
    assert.dom('[role="separator"]').exists({ count: 1 });
    assert.dom('[role="menuitem"]:nth-of-type(1)').isFocused();

    await click('.trigger');

    assert.dom('.trigger').doesNotHaveAttribute('aria-controls');
    assert.dom('.trigger').hasAttribute('aria-expanded', 'false');
    assert.dom('.content').doesNotExist();

    assert.dom('.trigger').isFocused();
  });

  test('keyboard navigation works', async function (assert) {
    await render(
      <template>
        <PortalTargets />

        <Menu as |m|>
          <m.Trigger class="trigger">
            Trigger
          </m.Trigger>

          <m.Content class="content" as |c|>
            <c.Item>Item 1</c.Item>
            <c.Item>Item 2</c.Item>
            <c.Separator />
            <c.Item>Item 3</c.Item>
          </m.Content>
        </Menu>
      </template>
    );

    await focus('.trigger');

    assert.dom('.trigger').isFocused();

    // the natural triggerKeyEvent doesn't work because
    // we never attached a keydown event. Because the element is a button
    // the browser automatically triggers the click event for us.
    // For that reason, we're using the click helper in our tests and
    // trust that the browser also triggers the click on enter/space
    // await triggerKeyEvent('.trigger', 'keydown', 'Enter');
    assert.dom('.trigger').hasTagName('button');
    await click('.trigger');

    assert.dom('.content').exists({ count: 1 });
    debugAssert(`Cannot use triggerKeyEvent with no activeElement`, document.activeElement);

    assert.dom('[role="menuitem"]:nth-of-type(1)').isFocused();

    await triggerKeyEvent(document.activeElement, 'keydown', 'ArrowDown');

    assert.dom('[role="menuitem"]:nth-of-type(2)').isFocused();

    await triggerKeyEvent(document.activeElement, 'keydown', 'ArrowRight');

    assert.dom('[role="menuitem"]:nth-of-type(3)').isFocused();

    await triggerKeyEvent(document.activeElement, 'keydown', 'ArrowDown');

    assert.dom('[role="menuitem"]:nth-of-type(1)').isFocused();

    await triggerKeyEvent(document.activeElement, 'keydown', 'Escape');

    assert.dom('.content').doesNotExist();

    await waitForFocus('.trigger');

    assert.dom('.trigger').isFocused();
  });

  test('keyboard selection works', async function (assert) {
    function select(value: string) {
      assert.step(value);
    }

    await render(
      <template>
        <PortalTargets />

        <Menu as |m|>
          <m.Trigger class="trigger">
            Trigger
          </m.Trigger>

          <m.Content class="content" as |c|>
            <c.Item @onSelect={{fn select "1"}}>Item 1</c.Item>
            <c.Item @onSelect={{fn select "2"}}>Item 2</c.Item>
            <c.Separator />
            <c.Item @onSelect={{fn select "3"}}>Item 3</c.Item>
          </m.Content>
        </Menu>
      </template>
    );

    await focus('.trigger');

    assert.dom('.trigger').isFocused();

    // the natural triggerKeyEvent doesn't work because
    // we never attached a keydown event. Because the element is a button
    // the browser automatically triggers the click event for us.
    // For that reason, we're using the click helper in our tests and
    // trust that the browser also triggers the click on enter/space
    // await triggerKeyEvent('.trigger', 'keydown', 'Enter');
    assert.dom('.trigger').hasTagName('button');
    await click('.trigger');

    assert.dom('.content').exists({ count: 1 });

    assert.dom('[role="menuitem"]:nth-of-type(1)').isFocused();

    // using click here for the same reason as above
    await click('[role="menuitem"]:nth-of-type(1)');

    assert.dom('.content').doesNotExist();

    assert.verifySteps(['1']);

    await waitForFocus('.trigger');

    assert.dom('.trigger').isFocused();
  });

  test('clicking outside closes the content', async function (assert) {
    await render(
      <template>
        <PortalTargets />

        <div id="outside-element"></div>

        <Menu as |m|>
          <m.Trigger class="trigger">
            Trigger
          </m.Trigger>

          <m.Content class="content" as |c|>
            <c.Item>Item 1</c.Item>
            <c.Item>Item 2</c.Item>
            <c.Separator />
            <c.Item>Item 3</c.Item>
          </m.Content>
        </Menu>
      </template>
    );

    await click('.trigger');

    assert.dom('.content').exists({ count: 1 });

    await click('#outside-element');

    assert.dom('.content').doesNotExist();

    await waitForFocus('.trigger');

    assert.dom('.trigger').isFocused();
  });
});
