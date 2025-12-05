import { module, test } from 'qunit';

import { getSectionHeadingLevel } from 'which-heading-do-i-need';

module('Unit | getSectionHeadingLevel', function () {
  test('nearest h3 is found', function (assert) {
    const doc = `
        <h3>
          hello there
        </h3>
        <section>
        </section>
      `;

    const root = document.createElement('div');

    root.innerHTML = doc;

    const ref = document.createTextNode('');

    root.querySelector('section')?.append(ref);

    const level = getSectionHeadingLevel(ref);

    assert.strictEqual(level, 4);
  });

  test('no existing heading', function (assert) {
    const doc = `
        <section>
        </section>
      `;

    const root = document.createElement('div');

    root.innerHTML = doc;

    const ref = document.createTextNode('');

    root.querySelector('section')?.append(ref);

    const level = getSectionHeadingLevel(ref);

    assert.strictEqual(level, 1);
  });

  test('can specify an offset', function (assert) {
    const doc = `
        <section>
        </section>
      `;

    const root = document.createElement('div');

    root.innerHTML = doc;

    const ref = document.createTextNode('');

    root.querySelector('section')?.append(ref);

    const level = getSectionHeadingLevel(ref, { startAt: 2 });

    assert.strictEqual(level, 2);
  });

  test('offset has no effect when level would be lower', function (assert) {
    const doc = `
        <h3>
          hello there
        </h3>
        <section>
        </section>
      `;

    const root = document.createElement('div');

    root.innerHTML = doc;

    const ref = document.createTextNode('');

    root.querySelector('section')?.append(ref);

    const level = getSectionHeadingLevel(ref, { startAt: 2 });

    assert.strictEqual(level, 4);
  });

  test('offset has no effect when level determined by neighbor', function (assert) {
    const doc = `
        <h3>
          hello there
        </h3>
        <section>
        </section>
      `;

    const root = document.createElement('div');

    root.innerHTML = doc;

    const ref = document.createTextNode('');

    root.querySelector('section')?.append(ref);

    const level = getSectionHeadingLevel(ref, { startAt: 5 });

    assert.strictEqual(level, 4);
  });
});
