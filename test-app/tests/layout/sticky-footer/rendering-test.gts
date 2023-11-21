import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { StickyFooter } from 'ember-primitives';

module('Rendering | <Portal>', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders', async function (assert) {
    await render(<template>
      <StickyFooter>
        <:content>
          the content
        </:content>
        <:footer>
          the footer
        </:footer>
      </StickyFooter>
    </template>);

    assert.dom('.ember-primitives__sticky-footer__wrapper').exists();
    assert.dom('.ember-primitives__sticky-footer__container').exists();
    assert.dom('.ember-primitives__sticky-footer__content').hasText('the content');
    assert.dom('.ember-primitives__sticky-footer__footer').hasText('the footer');
  });
});
