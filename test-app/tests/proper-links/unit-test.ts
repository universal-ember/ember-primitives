import { module, test } from 'qunit';

import { shouldHandle } from 'ember-primitives/proper-links';

module('@properLinks', function () {
  module('shouldHandle', function () {
    test('hash-only links', async function (assert) {
      function assertShouldHandle(
        expected: boolean,
        { location, href }: { location: string; href: string }
      ) {
        let url = new URL(location, 'https://example.com');

        let anchor = document.createElement('a');

        anchor.href = new URL(href, url).href;

        let ignored: string[] = [];
        let simpleClickEvent = new MouseEvent('click');

        assert.strictEqual(shouldHandle(url.href, anchor, ignored, simpleClickEvent), expected);
      }

      assertShouldHandle(false, { location: '/foo', href: '/foo#bar' });
      assertShouldHandle(false, { location: '/foo', href: '#bar' });
      assertShouldHandle(false, { location: '/foo#bar', href: '/foo#other' });

      assertShouldHandle(true, { location: '/foo', href: '/abc#xyz' });
      assertShouldHandle(true, { location: '/foo#bar', href: '/abc#xyz' });
      assertShouldHandle(true, { location: '/foo#bar', href: '/foo' });
    });
  });
});
