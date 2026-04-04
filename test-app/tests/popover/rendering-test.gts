import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Popover, PortalTargets } from 'ember-primitives';

module('Rendering | popover', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders with CSS Anchor Positioning styles', async function (assert) {
    await render(
      <template>
        <PortalTargets />

        <Popover @placement="bottom" @offsetOptions={{8}} as |p|>
          <div id="reference" {{p.reference}}>Anchor</div>
          <p.Content id="floating">Floating content</p.Content>
        </Popover>
      </template>
    );

    assert.dom('#reference').exists();
    assert.dom('#reference').hasAttribute('style');

    const referenceEl = document.querySelector('#reference') as HTMLElement;

    assert.ok(
      referenceEl.style.getPropertyValue('anchor-name').startsWith('--ep-'),
      'reference element has anchor-name set'
    );

    const floatingEl = document.querySelector('#floating') as HTMLElement;

    assert.strictEqual(
      floatingEl.style.getPropertyValue('position'),
      'fixed',
      'floating element has position: fixed'
    );
    assert.ok(
      floatingEl.style.getPropertyValue('position-anchor').startsWith('--ep-'),
      'floating element has position-anchor set'
    );
    assert.strictEqual(
      floatingEl.style.getPropertyValue('position-area'),
      'bottom',
      'floating element has correct position-area for placement=bottom'
    );
    assert.strictEqual(
      floatingEl.style.getPropertyValue('margin-top'),
      '8px',
      'floating element has correct offset margin'
    );
    assert.strictEqual(
      floatingEl.style.getPropertyValue('position-try-fallbacks'),
      'flip-block, flip-inline, flip-block flip-inline',
      'floating element has flip fallbacks'
    );
  });

  test('placement top-end uses correct position-area', async function (assert) {
    await render(
      <template>
        <PortalTargets />

        <Popover @placement="top-end" as |p|>
          <div id="reference" {{p.reference}}>Anchor</div>
          <p.Content id="floating">Content</p.Content>
        </Popover>
      </template>
    );

    const floatingEl = document.querySelector('#floating') as HTMLElement;

    assert.strictEqual(
      floatingEl.style.getPropertyValue('position-area'),
      'top span-left',
      'top-end maps to position-area: top span-left'
    );
    assert.strictEqual(
      floatingEl.style.getPropertyValue('justify-self'),
      'end',
      'top-end uses justify-self: end'
    );
  });

  test('placement left uses correct position-area', async function (assert) {
    await render(
      <template>
        <PortalTargets />

        <Popover @placement="left" as |p|>
          <div id="reference" {{p.reference}}>Anchor</div>
          <p.Content id="floating">Content</p.Content>
        </Popover>
      </template>
    );

    const floatingEl = document.querySelector('#floating') as HTMLElement;

    assert.strictEqual(
      floatingEl.style.getPropertyValue('position-area'),
      'left',
      'left maps to position-area: left'
    );
    assert.strictEqual(
      floatingEl.style.getPropertyValue('align-self'),
      'anchor-center',
      'left uses align-self: anchor-center'
    );
  });

  test('strategy can be set to absolute', async function (assert) {
    await render(
      <template>
        <PortalTargets />

        <Popover @strategy="absolute" as |p|>
          <div id="reference" {{p.reference}}>Anchor</div>
          <p.Content id="floating">Content</p.Content>
        </Popover>
      </template>
    );

    const floatingEl = document.querySelector('#floating') as HTMLElement;

    assert.strictEqual(
      floatingEl.style.getPropertyValue('position'),
      'absolute',
      'floating element uses absolute positioning'
    );
  });

  test('arrow modifier applies CSS anchor positioning', async function (assert) {
    await render(
      <template>
        <PortalTargets />

        <Popover @placement="bottom" as |p|>
          <div id="reference" {{p.reference}}>Anchor</div>
          <p.Content id="floating" @inline={{true}}>
            Content
            <div id="arrow" {{p.arrow}}></div>
          </p.Content>
        </Popover>
      </template>
    );

    const arrowEl = document.querySelector('#arrow') as HTMLElement;

    assert.strictEqual(
      arrowEl.style.getPropertyValue('position'),
      'absolute',
      'arrow has position: absolute'
    );
    assert.ok(
      arrowEl.style.getPropertyValue('position-anchor').startsWith('--ep-'),
      'arrow has position-anchor set'
    );
    assert.strictEqual(
      arrowEl.style.getPropertyValue('left'),
      'anchor(center)',
      'arrow is horizontally centered relative to anchor'
    );
    assert.strictEqual(
      arrowEl.style.getPropertyValue('top'),
      '-4px',
      'arrow is at the top edge of the floating element for bottom placement'
    );
  });

  test('deprecated args are accepted without errors', async function (assert) {
    const middleware = [{ name: 'test', fn: () => ({}) }];
    const flipOptions = { fallbackPlacements: ['top'] };
    const shiftOptions = { padding: 5 };

    await render(
      <template>
        <PortalTargets />

        <Popover
          @middleware={{middleware}}
          @flipOptions={{flipOptions}}
          @shiftOptions={{shiftOptions}}
          as |p|
        >
          <div {{p.reference}}>Anchor</div>
          <p.Content id="floating">Content</p.Content>
        </Popover>
      </template>
    );

    assert.dom('#floating').exists('renders despite deprecated args');
  });
});
