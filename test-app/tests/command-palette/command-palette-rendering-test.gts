import { assert as debugAssert } from '@ember/debug';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import {
  click,
  find,
  findAll,
  render,
  settled,
  triggerKeyEvent,
  waitUntil,
} from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { CommandPalette } from 'ember-primitives';
import { setupTabster } from 'ember-primitives/test-support';

module('Rendering | command-palette', function (hooks) {
  setupRenderingTest(hooks);
  setupTabster(hooks);

  async function closeDialog() {
    // We don't need to test "escape" because the browser already has
    // tests for that for us. So we can instead call the dialog's close method
    find('dialog')?.close();
    // NOTE: headless chrome has either:
    //       inconsistent timings, or is so fast, we actually do have a timing issue.
    //       TODO: consider how to tie the waiter system to the dialog close status
    await new Promise((resolve) => requestAnimationFrame(resolve));
    await settled();
  }

  function assertFind(selector: string) {
    const el = find(selector);

    debugAssert(`Expected ${selector} to exist`, el);

    return el;
  }

  // due to the way tabster works, we have to wait a bit for the focus to be correctly set
  function waitForFocus(selector: string) {
    return waitUntil(
      function () {
        return document.activeElement === find(selector);
      },
      { timeout: 2000 }
    );
  }

  test('can be opened and closed', async function (assert) {
    await render(
      <template>
        <CommandPalette as |cp|>
          <button id="trigger" type="button" {{on "click" cp.open}} {{cp.focusOnClose}}>
            Open Command Palette
          </button>

          <cp.Dialog>
            <cp.Input placeholder="Search..." />
            <cp.List>
              <cp.Item>Item 1</cp.Item>
              <cp.Item>Item 2</cp.Item>
            </cp.List>
          </cp.Dialog>
        </CommandPalette>
      </template>
    );

    assert.dom('dialog').exists();
    assert.dom('dialog').hasStyle({ display: 'none' });
    assert.dom('#trigger').isFocused();

    await click('#trigger');

    assert.dom('dialog').hasStyle({ display: 'block' });
    assert.dom('input[role="combobox"]').exists();
    assert.dom('input[role="combobox"]').isFocused();

    await closeDialog();

    assert.dom('dialog').hasStyle({ display: 'none' });
    assert.strictEqual(document.activeElement, assertFind('#trigger'));
  });

  test('input has correct ARIA attributes', async function (assert) {
    await render(
      <template>
        <CommandPalette as |cp|>
          <button type="button" {{on "click" cp.open}} {{cp.focusOnClose}}>
            Open
          </button>

          <cp.Dialog>
            <cp.Input placeholder="Search..." />
            <cp.List>
              <cp.Item>Item 1</cp.Item>
            </cp.List>
          </cp.Dialog>
        </CommandPalette>
      </template>
    );

    await click('button');

    const input = assertFind('input[role="combobox"]');
    const list = assertFind('[role="listbox"]');

    debugAssert('Input must have an id', input.id);
    debugAssert('List must have an id', list.id);

    assert.dom(input).hasAttribute('role', 'combobox');
    assert.dom(input).hasAttribute('aria-controls', list.id);
    assert.dom(input).hasAttribute('aria-expanded', 'true');
    assert.dom(input).hasAttribute('aria-autocomplete', 'list');
    assert.dom(input).hasAttribute('autocomplete', 'off');
  });

  test('list has correct ARIA attributes', async function (assert) {
    await render(
      <template>
        <CommandPalette as |cp|>
          <button type="button" {{on "click" cp.open}} {{cp.focusOnClose}}>
            Open
          </button>

          <cp.Dialog>
            <cp.Input placeholder="Search..." />
            <cp.List>
              <cp.Item>Item 1</cp.Item>
              <cp.Item>Item 2</cp.Item>
            </cp.List>
          </cp.Dialog>
        </CommandPalette>
      </template>
    );

    await click('button');

    const input = assertFind('input[role="combobox"]');
    const list = assertFind('[role="listbox"]');

    assert.dom(list).hasAttribute('role', 'listbox');
    assert.dom(list).hasAttribute('aria-labelledby', input.id);
    assert.dom(list).hasAttribute('tabindex', '0');

    const items = findAll('[role="option"]');

    assert.strictEqual(items.length, 2);
    assert.dom(items[0]).hasAttribute('role', 'option');
    assert.dom(items[0]).hasAttribute('tabindex', '-1');
    assert.dom(items[1]).hasAttribute('role', 'option');
    assert.dom(items[1]).hasAttribute('tabindex', '-1');
  });

  test('keyboard navigation works between items', async function (assert) {
    await render(
      <template>
        <CommandPalette as |cp|>
          <button type="button" {{on "click" cp.open}} {{cp.focusOnClose}}>
            Open
          </button>

          <cp.Dialog>
            <cp.Input placeholder="Search..." />
            <cp.List>
              <cp.Item>Item 1</cp.Item>
              <cp.Item>Item 2</cp.Item>
              <cp.Item>Item 3</cp.Item>
            </cp.List>
          </cp.Dialog>
        </CommandPalette>
      </template>
    );

    await click('button');

    const items = findAll('[role="option"]');
    const list = assertFind('[role="listbox"]');

    // Focus should be on input initially
    assert.dom('input[role="combobox"]').isFocused();

    // Tab to the list
    await triggerKeyEvent('input[role="combobox"]', 'keydown', 'Tab');
    await waitForFocus('[role="listbox"]');

    assert.dom(list).isFocused();

    // Arrow down should focus first item
    await triggerKeyEvent(list, 'keydown', 'ArrowDown');

    await waitUntil(() => document.activeElement === items[0], { timeout: 2000 });
    assert.dom(items[0] as HTMLElement).isFocused();

    // Arrow down should focus second item
    await triggerKeyEvent(items[0] as HTMLElement, 'keydown', 'ArrowDown');

    await waitUntil(() => document.activeElement === items[1], { timeout: 2000 });
    assert.dom(items[1] as HTMLElement).isFocused();

    // Arrow down should focus third item
    await triggerKeyEvent(items[1] as HTMLElement, 'keydown', 'ArrowDown');

    await waitUntil(() => document.activeElement === items[2], { timeout: 2000 });
    assert.dom(items[2] as HTMLElement).isFocused();

    // Arrow down should cycle back to first item
    await triggerKeyEvent(items[2] as HTMLElement, 'keydown', 'ArrowDown');

    await waitUntil(() => document.activeElement === items[0], { timeout: 2000 });
    assert.dom(items[0] as HTMLElement).isFocused();

    // Arrow up should go to last item
    await triggerKeyEvent(items[0] as HTMLElement, 'keydown', 'ArrowUp');

    await waitUntil(() => document.activeElement === items[2], { timeout: 2000 });
    assert.dom(items[2] as HTMLElement).isFocused();
  });

  test('escape key closes the command palette', async function (assert) {
    await render(
      <template>
        <CommandPalette as |cp|>
          <button id="trigger" type="button" {{on "click" cp.open}} {{cp.focusOnClose}}>
            Open
          </button>

          <cp.Dialog>
            <cp.Input placeholder="Search..." />
            <cp.List>
              <cp.Item>Item 1</cp.Item>
            </cp.List>
          </cp.Dialog>
        </CommandPalette>
      </template>
    );

    await click('#trigger');

    assert.dom('dialog').hasStyle({ display: 'block' });

    await triggerKeyEvent(document, 'keydown', 'Escape');
    await new Promise((resolve) => requestAnimationFrame(resolve));
    await settled();

    assert.dom('dialog').hasStyle({ display: 'none' });
    assert.strictEqual(document.activeElement, assertFind('#trigger'));
  });

  test('clicking an item closes the command palette', async function (assert) {
    await render(
      <template>
        <CommandPalette as |cp|>
          <button id="trigger" type="button" {{on "click" cp.open}} {{cp.focusOnClose}}>
            Open
          </button>

          <cp.Dialog>
            <cp.Input placeholder="Search..." />
            <cp.List>
              <cp.Item>Item 1</cp.Item>
              <cp.Item>Item 2</cp.Item>
            </cp.List>
          </cp.Dialog>
        </CommandPalette>
      </template>
    );

    await click('#trigger');

    assert.dom('dialog').hasStyle({ display: 'block' });

    const items = findAll('[role="option"]');

    await click(items[0] as HTMLElement);
    await new Promise((resolve) => requestAnimationFrame(resolve));
    await settled();

    assert.dom('dialog').hasStyle({ display: 'none' });
    assert.strictEqual(document.activeElement, assertFind('#trigger'));
  });

  test('onSelect callback is called when item is clicked', async function (assert) {
    function selectItem(value: string) {
      assert.step(value);
    }

    await render(
      <template>
        <CommandPalette as |cp|>
          <button type="button" {{on "click" cp.open}} {{cp.focusOnClose}}>
            Open
          </button>

          <cp.Dialog>
            <cp.Input placeholder="Search..." />
            <cp.List>
              <cp.Item @onSelect={{fn selectItem "item1"}}>Item 1</cp.Item>
              <cp.Item @onSelect={{fn selectItem "item2"}}>Item 2</cp.Item>
            </cp.List>
          </cp.Dialog>
        </CommandPalette>
      </template>
    );

    await click('button');

    const items = findAll('[role="option"]');

    await click(items[0] as HTMLElement);

    assert.verifySteps(['item1']);
  });

  test('moving pointer over item focuses it', async function (assert) {
    await render(
      <template>
        <CommandPalette as |cp|>
          <button type="button" {{on "click" cp.open}} {{cp.focusOnClose}}>
            Open
          </button>

          <cp.Dialog>
            <cp.Input placeholder="Search..." />
            <cp.List>
              <cp.Item>Item 1</cp.Item>
              <cp.Item>Item 2</cp.Item>
            </cp.List>
          </cp.Dialog>
        </CommandPalette>
      </template>
    );

    await click('button');

    const items = findAll('[role="option"]');
    const list = assertFind('[role="listbox"]');

    // Focus the list first
    await triggerKeyEvent('input[role="combobox"]', 'keydown', 'Tab');
    await waitForFocus('[role="listbox"]');

    // Move down to first item
    await triggerKeyEvent(list, 'keydown', 'ArrowDown');
    await waitUntil(() => document.activeElement === items[0], { timeout: 2000 });

    assert.dom(items[0] as HTMLElement).isFocused();

    // Move pointer to second item
    const pointerMoveEvent = new PointerEvent('pointermove', { bubbles: true });
    (items[1] as HTMLElement).dispatchEvent(pointerMoveEvent);

    await settled();

    assert.dom(items[1] as HTMLElement).isFocused();
  });

  test('yielded isOpen has correct value', async function (assert) {
    await render(
      <template>
        <CommandPalette as |cp|>
          <button type="button" {{on "click" cp.open}} {{cp.focusOnClose}}>
            {{if cp.isOpen "open" "closed"}}
          </button>

          <cp.Dialog>
            <cp.Input placeholder="Search..." />
            <cp.List>
              <cp.Item>Item 1</cp.Item>
            </cp.List>
          </cp.Dialog>
        </CommandPalette>
      </template>
    );

    assert.dom('button').hasText('closed');

    await click('button');

    assert.dom('button').hasText('open');

    await closeDialog();

    assert.dom('button').hasText('closed');
  });

  test('can set initial open state', async function (assert) {
    await render(
      <template>
        <CommandPalette @open={{true}} as |cp|>
          <button id="trigger" type="button" {{on "click" cp.open}} {{cp.focusOnClose}}>
            Open
          </button>

          <cp.Dialog>
            <cp.Input placeholder="Search..." />
            <cp.List>
              <cp.Item>Item 1</cp.Item>
            </cp.List>
          </cp.Dialog>
        </CommandPalette>
      </template>
    );

    assert.dom('dialog').hasStyle({ display: 'block' });
    assert.dom('input[role="combobox"]').isFocused();

    await closeDialog();

    assert.dom('dialog').hasStyle({ display: 'none' });
    assert.strictEqual(document.activeElement, assertFind('#trigger'));
  });

  test('onClose callback is called', async function (assert) {
    function handleClose() {
      assert.step('closed');
    }

    await render(
      <template>
        <CommandPalette @onClose={{handleClose}} as |cp|>
          <button type="button" {{on "click" cp.open}} {{cp.focusOnClose}}>
            Open
          </button>

          <cp.Dialog>
            <cp.Input placeholder="Search..." />
            <cp.List>
              <cp.Item>Item 1</cp.Item>
            </cp.List>
          </cp.Dialog>
        </CommandPalette>
      </template>
    );

    await click('button');

    await closeDialog();

    assert.verifySteps(['closed']);
  });
});
