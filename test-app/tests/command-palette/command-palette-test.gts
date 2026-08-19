import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import {
  clearRender,
  click,
  currentURL,
  fillIn,
  find,
  findAll,
  render,
  resetOnerror,
  setupOnerror,
  triggerEvent,
  triggerKeyEvent,
  visit,
} from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupApplicationTest, setupRenderingTest } from 'ember-qunit';

import { CommandPalette, Dialog, Modal } from 'ember-primitives';

import { setupRouting, setupTabster } from 'ember-primitives/test-support';

const COMMANDS = ['Open File', 'Open Folder', 'Close Window'];

function activeText() {
  const id = find('input')?.getAttribute('aria-activedescendant');

  return id ? document.getElementById(id)?.textContent?.trim() : undefined;
}

module('Rendering | command-palette', function (hooks) {
  setupRenderingTest(hooks);
  setupTabster(hooks);

  test('@items and a block together is an error', async function (assert) {
    setupOnerror((error: Error) => {
      assert.ok(/both `@items` and a block/.test(error.message), `got: ${error.message}`);
    });

    const ITEMS = ['One'];

    await render(
      <template>
        <CommandPalette @items={{ITEMS}} as |p|>
          <p.Input aria-label="Command" />
        </CommandPalette>
      </template>
    );

    resetOnerror();
  });

  test('with no block, it renders a whole palette from @items', async function (assert) {
    const chosen: unknown[] = [];
    const onSelect = (item: unknown) => chosen.push(item);

    const ITEMS = [
      { label: 'New File', description: 'Create a file in this folder', icon: '+' },
      { label: 'Close Window' },
      'Toggle Theme',
    ];

    await render(<template><CommandPalette @items={{ITEMS}} @onSelect={{onSelect}} /></template>);

    assert.dom('input').hasAttribute('role', 'combobox');
    assert.strictEqual(findAll('[role="option"]').length, 3);
    assert.dom('[role="option"]:first-child').containsText('New File');
    assert.dom('[role="option"]:first-child').containsText('Create a file in this folder');
    assert.dom('[role="option"]:last-child').hasText('Toggle Theme', 'a bare string is the label');

    await click('[role="option"]:last-child');

    assert.deepEqual(chosen, ['Toggle Theme'], '@onSelect is handed the entry');

    await click('[role="option"]:first-child');

    assert.strictEqual(chosen.length, 2, 'once per row, and it knows which');
    assert.deepEqual(chosen[1], ITEMS[0]);
  });

  test('an empty @items still renders the input to type into', async function (assert) {
    const NONE: string[] = [];

    await render(<template><CommandPalette @items={{NONE}} /></template>);

    assert.dom('input').exists('an empty array is falsy in a template, but the palette is not');
    assert.dom('[role="listbox"]').exists();
    assert.strictEqual(findAll('[role="option"]').length, 0);
  });

  test('wires the combobox to the listbox', async function (assert) {
    await render(
      <template>
        <CommandPalette as |p|>
          <p.Input aria-label="Command" />
          <p.List as |l|>
            {{#each COMMANDS as |command|}}
              <l.Item>{{command}}</l.Item>
            {{/each}}
          </p.List>
        </CommandPalette>
      </template>
    );

    assert.dom('input').hasAttribute('role', 'combobox');
    assert.dom('input').hasAttribute('aria-autocomplete', 'list');

    const list = find('[role="listbox"]');

    assert.dom('input').hasAttribute('aria-controls', list?.id ?? '');
    assert.strictEqual(findAll('[role="option"]').length, 3);
    assert.dom('input').doesNotHaveAttribute('aria-activedescendant', 'nothing is active yet');
  });

  test('the arrow keys move aria-activedescendant, not focus', async function (assert) {
    await render(
      <template>
        <CommandPalette as |p|>
          <p.Input aria-label="Command" />
          <p.List as |l|>
            {{#each COMMANDS as |command|}}
              <l.Item>{{command}}</l.Item>
            {{/each}}
          </p.List>
        </CommandPalette>
      </template>
    );

    const input = find('input');

    input?.focus();

    await triggerKeyEvent('input', 'keydown', 'ArrowDown');
    assert.strictEqual(activeText(), 'Open File');
    assert.strictEqual(document.activeElement, input, 'focus stayed in the input');

    await triggerKeyEvent('input', 'keydown', 'ArrowDown');
    assert.strictEqual(activeText(), 'Open Folder');

    await triggerKeyEvent('input', 'keydown', 'ArrowDown');
    await triggerKeyEvent('input', 'keydown', 'ArrowDown');
    assert.strictEqual(activeText(), 'Open File', 'wraps around');

    await triggerKeyEvent('input', 'keydown', 'ArrowUp');
    assert.strictEqual(activeText(), 'Close Window', 'wraps backwards');
  });

  test('Enter chooses the active item, or the first when none is', async function (assert) {
    const chosen: string[] = [];
    const choose = (event: Event) => {
      const target = event.target as HTMLElement;

      chosen.push(target.closest('[role="option"]')?.textContent?.trim() ?? '');
    };

    await render(
      <template>
        <CommandPalette @onSelect={{choose}} as |p|>
          <p.Input aria-label="Command" />
          <p.List as |l|>
            {{#each COMMANDS as |command|}}
              <l.Item>{{command}}</l.Item>
            {{/each}}
          </p.List>
        </CommandPalette>
      </template>
    );

    // no arrowing: Enter takes the first
    await triggerKeyEvent('input', 'keydown', 'Enter');
    assert.deepEqual(chosen, ['Open File']);

    await triggerKeyEvent('input', 'keydown', 'ArrowDown');
    await triggerKeyEvent('input', 'keydown', 'ArrowDown');
    await triggerKeyEvent('input', 'keydown', 'Enter');
    assert.deepEqual(chosen, ['Open File', 'Open Folder']);

    await click('[role="option"]:last-child');
    assert.deepEqual(chosen, ['Open File', 'Open Folder', 'Close Window']);
  });

  test('typing forgets what was active', async function (assert) {
    const matching = (query: string) =>
      COMMANDS.filter((command) => command.toLowerCase().includes(query.toLowerCase()));

    await render(
      <template>
        <CommandPalette as |p|>
          <p.Input aria-label="Command" />
          <p.List as |l|>
            {{#each (matching p.query) as |command|}}
              <l.Item>{{command}}</l.Item>
            {{/each}}
          </p.List>
        </CommandPalette>
      </template>
    );

    await triggerKeyEvent('input', 'keydown', 'ArrowDown');
    await triggerKeyEvent('input', 'keydown', 'ArrowDown');
    assert.strictEqual(activeText(), 'Open Folder');

    await fillIn('input', 'close');

    assert.strictEqual(findAll('[role="option"]').length, 1);
    assert.dom('input').doesNotHaveAttribute('aria-activedescendant');

    // and Enter still takes the best of the new results
    await triggerKeyEvent('input', 'keydown', 'ArrowDown');
    assert.strictEqual(activeText(), 'Close Window');

    await fillIn('input', 'nothing matches this');
    assert.strictEqual(findAll('[role="option"]').length, 0);

    // no options, no crash
    await triggerKeyEvent('input', 'keydown', 'Enter');
    await triggerKeyEvent('input', 'keydown', 'ArrowDown');
  });

  test('the pointer activates an item without stealing focus', async function (assert) {
    await render(
      <template>
        <CommandPalette as |p|>
          <p.Input aria-label="Command" />
          <p.List as |l|>
            {{#each COMMANDS as |command|}}
              <l.Item>{{command}}</l.Item>
            {{/each}}
          </p.List>
        </CommandPalette>
      </template>
    );

    const input = find('input');

    input?.focus();

    await triggerEvent('[role="option"]:last-child', 'pointermove');

    assert.strictEqual(activeText(), 'Close Window');
    assert.dom('[role="option"]:last-child').hasAttribute('data-active', 'true');
    assert.strictEqual(document.activeElement, input);
  });

  test('choosing is delegated, so a row needs no listener of its own', async function (assert) {
    const chosen: string[] = [];
    const choose = (event: Event) => {
      const target = event.target as HTMLElement;

      chosen.push(target.closest('[role="option"]')?.textContent?.trim() ?? '');
    };

    await render(
      <template>
        <CommandPalette @onSelect={{choose}} as |p|>
          <p.Input aria-label="Command" />
          <p.List as |l|>
            {{#each COMMANDS as |command|}}
              <l.Item>{{command}}</l.Item>
            {{/each}}
          </p.List>
        </CommandPalette>
      </template>
    );

    await click('[role="option"]:first-child');
    await click('[role="option"]:last-child');

    assert.deepEqual(chosen, ['Open File', 'Close Window'], 'once per row, via the event');
  });

  test('inside <Dialog>, @onSelect={{d.close}} and @onOpen={{d.open}} are the whole wiring', async function (assert) {
    const MOD = navigator.userAgent.includes('Mac OS') ? { metaKey: true } : { ctrlKey: true };

    await render(
      <template>
        <Dialog as |d|>
          <CommandPalette @onSelect={{d.close}} @onOpen={{d.open}} @hotkey="mod+k" as |p|>
            <p.Input aria-label="Command" />
            <p.List as |l|>
              {{#each COMMANDS as |command|}}
                <l.Item>{{command}}</l.Item>
              {{/each}}
            </p.List>
          </CommandPalette>
        </Dialog>
      </template>
    );

    assert.dom('dialog').doesNotHaveAttribute('open');

    await triggerKeyEvent(document.body, 'keydown', 'K', MOD);

    assert.dom('dialog').hasAttribute('open');

    await triggerKeyEvent('input', 'keydown', 'Enter');

    assert.dom('dialog').doesNotHaveAttribute('open');
  });

  test('a palette in <Modal> still composes the same way', async function (assert) {
    await render(
      <template>
        <Modal as |m|>
          <button type="button" {{on "click" m.open}}>Search</button>

          <m.Dialog>
            <CommandPalette @onSelect={{m.close}} as |p|>
              <p.Input aria-label="Command" />
              <p.List as |l|>
                {{#each COMMANDS as |command|}}
                  <l.Item>{{command}}</l.Item>
                {{/each}}
              </p.List>
            </CommandPalette>
          </m.Dialog>
        </Modal>
      </template>
    );

    await click('button');
    assert.dom('dialog').hasAttribute('open');

    await triggerKeyEvent('input', 'keydown', 'Enter');

    assert.dom('dialog').doesNotHaveAttribute('open');
  });

  test('@hotkey calls @onOpen from anywhere on the page', async function (assert) {
    const MOD = navigator.userAgent.includes('Mac OS') ? { metaKey: true } : { ctrlKey: true };

    await render(
      <template>
        <Modal as |m|>
          <m.Dialog>
            <CommandPalette @hotkey="mod+k" @onOpen={{m.open}} as |p|>
              <p.Input aria-label="Command" />
              <p.List as |l|>
                <l.Item>One</l.Item>
              </p.List>
            </CommandPalette>
          </m.Dialog>
        </Modal>
      </template>
    );

    assert.dom('dialog').doesNotHaveAttribute('open');

    await triggerKeyEvent(document.body, 'keydown', 'K', MOD);
    assert.dom('dialog').hasAttribute('open');

    // a bare `k` is just typing
    await triggerKeyEvent(document.body, 'keydown', 'K');
    assert.dom('dialog').hasAttribute('open');
  });

  test('@hotkey without @onOpen installs no listener', async function (assert) {
    const MOD = navigator.userAgent.includes('Mac OS') ? { metaKey: true } : { ctrlKey: true };

    await render(
      <template>
        <CommandPalette @hotkey="mod+k" as |p|>
          <p.Input aria-label="Command" />
          <p.List as |l|>
            <l.Item>One</l.Item>
          </p.List>
        </CommandPalette>
      </template>
    );

    await triggerKeyEvent(document.body, 'keydown', 'K', MOD);

    assert.dom('input').exists('nothing to open, and nothing thrown');
  });

  test('the hotkey listener goes when the palette does', async function (assert) {
    const MOD = navigator.userAgent.includes('Mac OS') ? { metaKey: true } : { ctrlKey: true };
    const opens: number[] = [];
    const onOpen = () => opens.push(1);

    await render(
      <template>
        <CommandPalette @hotkey="mod+k" @onOpen={{onOpen}} as |p|>
          <p.Input aria-label="Command" />
          <p.List as |l|>
            <l.Item>One</l.Item>
          </p.List>
        </CommandPalette>
      </template>
    );

    await triggerKeyEvent(document.body, 'keydown', 'K', MOD);
    assert.deepEqual(opens, [1]);

    await clearRender();

    // the listener is on `document`, which holds it, so nothing collects it
    await triggerKeyEvent(document.body, 'keydown', 'K', MOD);
    assert.deepEqual(opens, [1], 'a torn-down palette no longer answers its hotkey');
  });

  test('the query is controllable', async function (assert) {
    const queries: string[] = [];
    const onQueryChange = (query: string) => queries.push(query);

    await render(
      <template>
        <CommandPalette @query="initial" @onQueryChange={{onQueryChange}} as |p|>
          <p.Input aria-label="Command" />
          <p.List as |l|>
            <l.Item>One</l.Item>
          </p.List>

          <output>{{p.query}}</output>
          <button type="button" {{on "click" (fn p.setQuery "")}}>Clear</button>
        </CommandPalette>
      </template>
    );

    assert.dom('input').hasValue('initial');
    assert.dom('output').hasText('initial');

    await fillIn('input', 'typed');

    assert.dom('output').hasText('typed');
    assert.deepEqual(queries, ['typed']);

    await click('button');

    assert.dom('input').hasValue('');
    assert.deepEqual(queries, ['typed', '']);
  });
});

module('Application | command-palette', function (hooks) {
  setupApplicationTest(hooks);
  setupTabster(hooks);

  test('a LinkItem is an option and a link', async function (assert) {
    setupRouting(this.owner, function () {
      this.route('one');
      this.route('two');
    });

    this.owner.register(
      'template:application',
      <template>
        <CommandPalette as |p|>
          <p.Input aria-label="Search" />
          <p.List as |l|>
            <l.LinkItem @href="/one">One</l.LinkItem>
            <l.LinkItem @href="/two">Two</l.LinkItem>
          </p.List>
        </CommandPalette>
      </template>
    );

    await visit('/');

    assert.dom('a[href="/one"]').hasAttribute('role', 'option');

    await triggerKeyEvent('input', 'keydown', 'ArrowDown');
    await triggerKeyEvent('input', 'keydown', 'ArrowDown');
    assert.strictEqual(activeText(), 'Two');

    // Enter dispatches a real click on the anchor: the router navigates
    await triggerKeyEvent('input', 'keydown', 'Enter');

    assert.strictEqual(currentURL(), '/two');
  });
});
