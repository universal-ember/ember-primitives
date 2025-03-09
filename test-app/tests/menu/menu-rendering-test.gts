import { assert as debugAssert } from '@ember/debug';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import {
  click,
  find,
  focus,
  render,
  triggerEvent,
  triggerKeyEvent,
  waitUntil,
} from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Menu, PortalTargets } from 'ember-primitives';

import { setupTabster } from 'ember-primitives/test-support';

module('Rendering | menu', function (hooks) {
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

    const content = find('.content');

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

  test('can be opened/closed using the trigger and has correct aria attributes (using trigger modifier)', async function (assert) {
    await render(
      <template>
        <PortalTargets />

        <Menu as |m|>
          <button type="button" class="trigger" {{m.trigger}}>
            Trigger
          </button>

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

    const content = find('.content');

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

  test('selection works', async function (assert) {
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

  test('moving pointer hover item focuses it', async function (assert) {
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

    await click('.trigger');

    assert.dom('.content').exists({ count: 1 });

    assert.dom('[role="menuitem"]:nth-of-type(1)').isFocused();

    await triggerEvent('[role="menuitem"]:nth-of-type(3)', 'pointermove');

    assert.dom('[role="menuitem"]:nth-of-type(3)').isFocused();
  });

  test('yielded isOpen has correct value', async function (assert) {
    await render(
      <template>
        <PortalTargets />

        <Menu as |m|>
          <m.Trigger class="trigger">
            {{if m.isOpen "open" "closed"}}
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

    assert.dom('.trigger').hasText('closed');

    await click('.trigger');

    assert.dom('.trigger').hasText('open');
  });

  test('using stopPropagation={{true}} stops the click event from bubbling (trigger component)', async function (assert) {
    let didReachParent = false;

    function parentClick() {
      didReachParent = true;
    }

    await render(
      <template>
        <PortalTargets />

        {{! template-lint-disable no-invalid-interactive }}
        <div {{on "click" parentClick}}>
          <Menu as |m|>
            <m.Trigger class="trigger" @stopPropagation={{true}}>
              Trigger
            </m.Trigger>

            <m.Content class="content" as |c|>
              <c.Item>Item 1</c.Item>
              <c.Item>Item 2</c.Item>
              <c.Separator />
              <c.Item>Item 3</c.Item>
            </m.Content>
          </Menu>
        </div>
      </template>
    );

    await click('.trigger');

    assert.dom('.content').exists({ count: 1 });
    assert.notOk(didReachParent);
  });

  test('using stopPropagation={{true}} stops the click event from bubbling (trigger modifier)', async function (assert) {
    let didReachParent = false;

    function parentClick() {
      didReachParent = true;
    }

    await render(
      <template>
        <PortalTargets />

        {{! template-lint-disable no-invalid-interactive }}
        <div {{on "click" parentClick}}>
          <Menu as |m|>
            <button type="button" class="trigger" {{m.trigger stopPropagation=true}}>
              Trigger
            </button>

            <m.Content class="content" as |c|>
              <c.Item>Item 1</c.Item>
              <c.Item>Item 2</c.Item>
              <c.Separator />
              <c.Item>Item 3</c.Item>
            </m.Content>
          </Menu>
        </div>
      </template>
    );

    await click('.trigger');

    assert.dom('.content').exists({ count: 1 });
    assert.notOk(didReachParent);
  });

  test('using stopPropagation={{false}} allows the click event to bubble (trigger component)', async function (assert) {
    let didReachParent = false;

    function parentClick() {
      didReachParent = true;
    }

    await render(
      <template>
        <PortalTargets />

        {{! template-lint-disable no-invalid-interactive }}
        <div {{on "click" parentClick}}>
          <Menu as |m|>
            <m.Trigger class="trigger" @stopPropagation={{false}}>
              Trigger
            </m.Trigger>

            <m.Content class="content" as |c|>
              <c.Item>Item 1</c.Item>
              <c.Item>Item 2</c.Item>
              <c.Separator />
              <c.Item>Item 3</c.Item>
            </m.Content>
          </Menu>
        </div>
      </template>
    );

    await click('.trigger');

    assert.dom('.content').exists({ count: 1 });
    assert.ok(didReachParent);
  });

  test('using stopPropagation={{false}} allows the click event to bubble (trigger modifier)', async function (assert) {
    let didReachParent = false;

    function parentClick() {
      didReachParent = true;
    }

    await render(
      <template>
        <PortalTargets />

        {{! template-lint-disable no-invalid-interactive }}
        <div {{on "click" parentClick}}>
          <Menu as |m|>
            <button type="button" class="trigger" {{m.trigger stopPropagation=false}}>
              Trigger
            </button>

            <m.Content class="content" as |c|>
              <c.Item>Item 1</c.Item>
              <c.Item>Item 2</c.Item>
              <c.Separator />
              <c.Item>Item 3</c.Item>
            </m.Content>
          </Menu>
        </div>
      </template>
    );

    await click('.trigger');

    assert.dom('.content').exists({ count: 1 });
    assert.ok(didReachParent);
  });

  test('using preventDefault={{true}} calls preventDefault() on the event (trigger component)', async function (assert) {
    let wasDefaultPrevented = false;

    function parentClick(ev: MouseEvent) {
      wasDefaultPrevented = ev.defaultPrevented;
    }

    await render(
      <template>
        <PortalTargets />

        {{! template-lint-disable no-invalid-interactive }}
        <div {{on "click" parentClick}}>
          <Menu as |m|>
            <m.Trigger class="trigger" @preventDefault={{true}}>
              Trigger
            </m.Trigger>

            <m.Content class="content" as |c|>
              <c.Item>Item 1</c.Item>
              <c.Item>Item 2</c.Item>
              <c.Separator />
              <c.Item>Item 3</c.Item>
            </m.Content>
          </Menu>
        </div>
      </template>
    );

    await click('.trigger');

    assert.dom('.content').exists({ count: 1 });
    assert.ok(wasDefaultPrevented);
  });

  test('using preventDefault={{true}} calls preventDefault() on the event (trigger modifier)', async function (assert) {
    let wasDefaultPrevented = false;

    function parentClick(ev: MouseEvent) {
      wasDefaultPrevented = ev.defaultPrevented;
    }

    await render(
      <template>
        <PortalTargets />

        {{! template-lint-disable no-invalid-interactive }}
        <div {{on "click" parentClick}}>
          <Menu as |m|>
            <button type="button" class="trigger" {{m.trigger preventDefault=true}}>
              Trigger
            </button>

            <m.Content class="content" as |c|>
              <c.Item>Item 1</c.Item>
              <c.Item>Item 2</c.Item>
              <c.Separator />
              <c.Item>Item 3</c.Item>
            </m.Content>
          </Menu>
        </div>
      </template>
    );

    await click('.trigger');

    assert.dom('.content').exists({ count: 1 });
    assert.ok(wasDefaultPrevented);
  });

  test('using preventDefault={{false}} does not call preventDefault() on the event (trigger component)', async function (assert) {
    let wasDefaultPrevented = false;

    function parentClick(ev: MouseEvent) {
      wasDefaultPrevented = ev.defaultPrevented;
    }

    await render(
      <template>
        <PortalTargets />

        {{! template-lint-disable no-invalid-interactive }}
        <div {{on "click" parentClick}}>
          <Menu as |m|>
            <m.Trigger class="trigger" @preventDefault={{false}}>
              Trigger
            </m.Trigger>

            <m.Content class="content" as |c|>
              <c.Item>Item 1</c.Item>
              <c.Item>Item 2</c.Item>
              <c.Separator />
              <c.Item>Item 3</c.Item>
            </m.Content>
          </Menu>
        </div>
      </template>
    );

    await click('.trigger');

    assert.dom('.content').exists({ count: 1 });
    assert.notOk(wasDefaultPrevented);
  });

  test('using preventDefault={{false}} does not call preventDefault() on the event (trigger modifier)', async function (assert) {
    let wasDefaultPrevented = false;

    function parentClick(ev: MouseEvent) {
      wasDefaultPrevented = ev.defaultPrevented;
    }

    await render(
      <template>
        <PortalTargets />

        {{! template-lint-disable no-invalid-interactive }}
        <div {{on "click" parentClick}}>
          <Menu as |m|>
            <button type="button" class="trigger" {{m.trigger preventDefault=false}}>
              Trigger
            </button>

            <m.Content class="content" as |c|>
              <c.Item>Item 1</c.Item>
              <c.Item>Item 2</c.Item>
              <c.Separator />
              <c.Item>Item 3</c.Item>
            </m.Content>
          </Menu>
        </div>
      </template>
    );

    await click('.trigger');

    assert.dom('.content').exists({ count: 1 });
    assert.notOk(wasDefaultPrevented);
  });
});
