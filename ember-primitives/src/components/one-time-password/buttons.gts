import { assert } from '@ember/debug';
import { on } from '@ember/modifier';

import type { TOC } from '@ember/component/template-only';

const reset = (event: Event) => {
  assert('[BUG]: reset called without an event.target', event.target instanceof HTMLElement);

  let form = event.target.closest('form');

  assert(
    'Form is missing. Cannot use <Reset> without being contained within a <form>',
    form instanceof HTMLFormElement
  );

  form.reset();
};

export const Submit: TOC<{
  Element: HTMLButtonElement;
  Blocks: { default: [] };
}> = <template><button type="submit" ...attributes>Submit</button></template>;

export const Reset: TOC<{
  Element: HTMLButtonElement;
  Blocks: { default: [] };
}> = <template>
  <button type="button" {{on "click" reset}} ...attributes>{{yield}}</button>
</template>;
