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

  test('heading-less sections are transparent (no reset to h1)', function (assert) {
    const doc = `
        <h2>
          hello there
        </h2>
        <section>
          <section>
          </section>
        </section>
      `;

    const root = document.createElement('div');

    root.innerHTML = doc;

    const ref = document.createTextNode('');

    root.querySelector('section section')?.append(ref);

    const level = getSectionHeadingLevel(ref);

    assert.strictEqual(level, 3);
  });

  test('headings within sibling sections are not context', function (assert) {
    const doc = `
        <h2>
          hello there
        </h2>
        <section>
          <h3>a sibling section's heading</h3>
        </section>
        <section>
        </section>
      `;

    const root = document.createElement('div');

    root.innerHTML = doc;

    const ref = document.createTextNode('');

    root.querySelector('section + section')?.append(ref);

    const level = getSectionHeadingLevel(ref);

    assert.strictEqual(level, 3);
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
