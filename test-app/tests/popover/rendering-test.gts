import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Popover } from 'ember-primitives';

module('Rendering | popover', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders with CSS Anchor Positioning styles', async function (assert) {
    await render(
      <template>
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
      'absolute',
      'floating element has position: absolute'
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
      'flip-block',
      'floating element has flip fallback'
    );
  });

  test('placement top-end uses correct position-area', async function (assert) {
    await render(
      <template>
        <Popover @placement="top-end" as |p|>
          <div id="reference" {{p.reference}}>Anchor</div>
          <p.Content id="floating">Content</p.Content>
        </Popover>
      </template>
    );

    const floatingEl = document.querySelector('#floating') as HTMLElement;

    // Browser may normalize "top span-left" to "span-left top"
    const positionArea = floatingEl.style.getPropertyValue('position-area');
    const parts = positionArea.split(' ').sort();

    assert.deepEqual(
      parts,
      ['span-left', 'top'],
      `top-end maps to position-area containing top and span-left, got: ${positionArea}`
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

  test('arrow modifier applies CSS anchor positioning', async function (assert) {
    await render(
      <template>
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
    assert.strictEqual(
      arrowEl.style.getPropertyValue('left'),
      '50%',
      'arrow is horizontally centered in floating content'
    );
    assert.strictEqual(
      arrowEl.style.getPropertyValue('top'),
      '-4px',
      'arrow is at the top edge of the floating element for bottom placement'
    );
  });
});
