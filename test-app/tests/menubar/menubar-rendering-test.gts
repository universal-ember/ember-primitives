import { assert as debugAssert } from '@ember/debug';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import {
  click,
  find,
  findAll,
  focus,
  render,
  triggerKeyEvent,
  waitUntil,
} from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { MenuBar, PortalTargets } from 'ember-primitives';

import { setupTabster } from 'ember-primitives/test-support';

module('Rendering | menubar', function (hooks) {
  setupRenderingTest(hooks);
  setupTabster(hooks);

  // due to the way tabster works, we have to wait a bit for the focus to be correctly set
  function waitForFocus(selector: string) {
    return waitUntil(
      function () {
        return document.activeElement === find(selector);
      },
      { timeout: 2000 }
    );
  }

  test('renders with correct aria attributes', async function (assert) {
    await render(
      <template>
        <PortalTargets />

        <MenuBar class="menubar">
          <:default as |mb|>
            <mb.Menu as |m|>
              <m.Trigger class="trigger-1">
                File
              </m.Trigger>

              <m.Content class="content-1" as |c|>
                <c.Item>New</c.Item>
                <c.Item>Open</c.Item>
                <c.Separator />
                <c.Item>Save</c.Item>
              </m.Content>
            </mb.Menu>

            <mb.Menu as |m|>
              <m.Trigger class="trigger-2">
                Edit
              </m.Trigger>

              <m.Content class="content-2" as |c|>
                <c.Item>Undo</c.Item>
                <c.Item>Redo</c.Item>
              </m.Content>
            </mb.Menu>
          </:default>
        </MenuBar>
      </template>
    );

    assert.dom('.menubar').exists({ count: 1 });
    assert.dom('.menubar').hasAttribute('role', 'menubar');
    assert.dom('.trigger-1').exists({ count: 1 });
    assert.dom('.trigger-1').hasTagName('button');
    assert.dom('.trigger-1').hasAttribute('aria-haspopup', 'menu');
    assert.dom('.trigger-1').hasAttribute('aria-expanded', 'false');
    assert.dom('.trigger-2').exists({ count: 1 });
    assert.dom('.trigger-2').hasTagName('button');
    assert.dom('.trigger-2').hasAttribute('aria-haspopup', 'menu');
    assert.dom('.trigger-2').hasAttribute('aria-expanded', 'false');
    assert.dom('.content-1').doesNotExist();
    assert.dom('.content-2').doesNotExist();
  });

  test('can open/close individual menus', async function (assert) {
    await render(
      <template>
        <PortalTargets />

        <MenuBar class="menubar">
          <:default as |mb|>
            <mb.Menu as |m|>
              <m.Trigger class="trigger-1">
                File
              </m.Trigger>

              <m.Content class="content-1" as |c|>
                <c.Item>New</c.Item>
                <c.Item>Open</c.Item>
                <c.Separator />
                <c.Item>Save</c.Item>
              </m.Content>
            </mb.Menu>

            <mb.Menu as |m|>
              <m.Trigger class="trigger-2">
                Edit
              </m.Trigger>

              <m.Content class="content-2" as |c|>
                <c.Item>Undo</c.Item>
                <c.Item>Redo</c.Item>
              </m.Content>
            </mb.Menu>
          </:default>
        </MenuBar>
      </template>
    );

    assert.dom('.content-1').doesNotExist();
    assert.dom('.content-2').doesNotExist();

    await click('.trigger-1');

    assert.dom('.content-1').exists({ count: 1 });
    assert.dom('.trigger-1').hasAttribute('aria-expanded', 'true');
    assert.dom('.content-2').doesNotExist();

    const items1 = findAll('.content-1 [role="menuitem"]');

    assert.strictEqual(items1.length, 3);
    assert.dom(items1[0]).hasText('New');
    assert.dom(items1[1]).hasText('Open');
    assert.dom(items1[2]).hasText('Save');
    assert.dom('.content-1 [role="separator"]').exists({ count: 1 });

    await click('.trigger-1');

    assert.dom('.trigger-1').hasAttribute('aria-expanded', 'false');
    assert.dom('.content-1').doesNotExist();

    await click('.trigger-2');

    assert.dom('.content-2').exists({ count: 1 });
    assert.dom('.trigger-2').hasAttribute('aria-expanded', 'true');
    assert.dom('.content-1').doesNotExist();

    const items2 = findAll('.content-2 [role="menuitem"]');

    assert.strictEqual(items2.length, 2);
    assert.dom(items2[0]).hasText('Undo');
    assert.dom(items2[1]).hasText('Redo');
  });

  test('can be closed by clicking a menu item', async function (assert) {
    await render(
      <template>
        <PortalTargets />

        <MenuBar class="menubar">
          <:default as |mb|>
            <mb.Menu as |m|>
              <m.Trigger class="trigger-1">
                File
              </m.Trigger>

              <m.Content class="content-1" as |c|>
                <c.Item>New</c.Item>
              </m.Content>
            </mb.Menu>
          </:default>
        </MenuBar>
      </template>
    );

    assert.dom('.content-1').doesNotExist();

    await click('.trigger-1');

    assert.dom('.content-1').exists({ count: 1 });
    assert.dom('.trigger-1').hasAttribute('aria-expanded', 'true');

    await click('[role="menuitem"]');

    assert.dom('.trigger-1').hasAttribute('aria-expanded', 'false');
    assert.dom('.content-1').doesNotExist();
  });

  test('selection works', async function (assert) {
    function select(value: string) {
      assert.step(value);
    }

    await render(
      <template>
        <PortalTargets />

        <MenuBar class="menubar">
          <:default as |mb|>
            <mb.Menu as |m|>
              <m.Trigger class="trigger-1">
                File
              </m.Trigger>

              <m.Content class="content-1" as |c|>
                <c.Item @onSelect={{fn select "new"}}>New</c.Item>
                <c.Item @onSelect={{fn select "open"}}>Open</c.Item>
              </m.Content>
            </mb.Menu>
          </:default>
        </MenuBar>
      </template>
    );

    await click('.trigger-1');

    assert.dom('.content-1').exists({ count: 1 });

    const items = findAll('[role="menuitem"]');

    await click(items[0] as HTMLElement);

    assert.dom('.content-1').doesNotExist();

    assert.verifySteps(['new']);
  });

  test('keyboard navigation works within menu', async function (assert) {
    await render(
      <template>
        <PortalTargets />

        <MenuBar class="menubar">
          <:default as |mb|>
            <mb.Menu as |m|>
              <m.Trigger class="trigger-1">
                File
              </m.Trigger>

              <m.Content class="content-1" as |c|>
                <c.Item>New</c.Item>
                <c.Item>Open</c.Item>
                <c.Item>Save</c.Item>
              </m.Content>
            </mb.Menu>
          </:default>
        </MenuBar>
      </template>
    );

    await focus('.trigger-1');

    assert.dom('.trigger-1').isFocused();

    await click('.trigger-1');

    assert.dom('.content-1').exists({ count: 1 });
    debugAssert(`Cannot use triggerKeyEvent with no activeElement`, document.activeElement);

    const items = findAll('.content-1 [role="menuitem"]');

    assert.dom(items[0]).isFocused();

    await triggerKeyEvent(document.activeElement, 'keydown', 'ArrowDown');

    assert.dom(items[1]).isFocused();

    await triggerKeyEvent(document.activeElement, 'keydown', 'ArrowDown');

    assert.dom(items[2]).isFocused();

    await triggerKeyEvent(document.activeElement, 'keydown', 'Escape');

    assert.dom('.content-1').doesNotExist();

    await waitForFocus('.trigger-1');

    assert.dom('.trigger-1').isFocused();
  });

  test('clicking outside closes the content', async function (assert) {
    await render(
      <template>
        <PortalTargets />

        <div id="outside-element"></div>

        <MenuBar class="menubar">
          <:default as |mb|>
            <mb.Menu as |m|>
              <m.Trigger class="trigger-1">
                File
              </m.Trigger>

              <m.Content class="content-1" as |c|>
                <c.Item>New</c.Item>
                <c.Item>Open</c.Item>
              </m.Content>
            </mb.Menu>
          </:default>
        </MenuBar>
      </template>
    );

    await click('.trigger-1');

    assert.dom('.content-1').exists({ count: 1 });

    await click('#outside-element');

    assert.dom('.content-1').doesNotExist();

    await waitForFocus('.trigger-1');

    assert.dom('.trigger-1').isFocused();
  });

  test('horizontal keyboard navigation works between triggers', async function (assert) {
    await render(
      <template>
        <PortalTargets />

        <MenuBar class="menubar">
          <:default as |mb|>
            <mb.Menu as |m|>
              <m.Trigger class="trigger-1">
                File
              </m.Trigger>

              <m.Content class="content-1" as |c|>
                <c.Item>New</c.Item>
              </m.Content>
            </mb.Menu>

            <mb.Menu as |m|>
              <m.Trigger class="trigger-2">
                Edit
              </m.Trigger>

              <m.Content class="content-2" as |c|>
                <c.Item>Undo</c.Item>
              </m.Content>
            </mb.Menu>

            <mb.Menu as |m|>
              <m.Trigger class="trigger-3">
                View
              </m.Trigger>

              <m.Content class="content-3" as |c|>
                <c.Item>Zoom In</c.Item>
              </m.Content>
            </mb.Menu>
          </:default>
        </MenuBar>
      </template>
    );

    await focus('.trigger-1');

    assert.dom('.trigger-1').isFocused();

    debugAssert(`Cannot use triggerKeyEvent with no activeElement`, document.activeElement);

    await triggerKeyEvent(document.activeElement, 'keydown', 'ArrowRight');

    await waitForFocus('.trigger-2');

    assert.dom('.trigger-2').isFocused();

    await triggerKeyEvent(document.activeElement, 'keydown', 'ArrowRight');

    await waitForFocus('.trigger-3');

    assert.dom('.trigger-3').isFocused();

    // Test cyclic navigation
    await triggerKeyEvent(document.activeElement, 'keydown', 'ArrowRight');

    await waitForFocus('.trigger-1');

    assert.dom('.trigger-1').isFocused();

    // Test left arrow
    await triggerKeyEvent(document.activeElement, 'keydown', 'ArrowLeft');

    await waitForFocus('.trigger-3');

    assert.dom('.trigger-3').isFocused();
  });

  test('yielded isOpen has correct value', async function (assert) {
    await render(
      <template>
        <PortalTargets />

        <MenuBar class="menubar">
          <:default as |mb|>
            <mb.Menu as |m|>
              <m.Trigger class="trigger-1">
                {{if m.isOpen "open" "closed"}}
              </m.Trigger>

              <m.Content class="content-1" as |c|>
                <c.Item>New</c.Item>
              </m.Content>
            </mb.Menu>
          </:default>
        </MenuBar>
      </template>
    );

    assert.dom('.trigger-1').hasText('closed');

    await click('.trigger-1');

    assert.dom('.trigger-1').hasText('open');
  });
});
