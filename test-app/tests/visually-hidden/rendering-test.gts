import { assert as debugAssert } from '@ember/debug';
import { click, find, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { VisuallyHidden } from 'ember-primitives';

module('Rendering | <VisuallyHidden>', function (hooks) {
  setupRenderingTest(hooks);

  test('it works', async function (assert) {
    await render(
      <template>
        <VisuallyHidden>
          this is visually hidden, but still rendered
        </VisuallyHidden>
      </template>
    );

    const span = find('span');

    debugAssert(`Could not find span`, span);

    const style = window.getComputedStyle(span);

    assert.dom('span').hasStyle(
      {
        width: '1px',
        margin: '-1px',
        clip: `rect(0px, 0px, 0px, 0px)`,
      },
      [
        `Expected style: `,
        `width: [ "1px", got: ${style.width}" ], `,
        `margin: [ "-1px", got: "${style.margin}" ], `,
        `clip: [ "rect(0px, 0px, 0px, 0px)", got: "${style.clip}" ]`,
      ].join('')
    );
  });
});
