import { assert } from '@ember/debug';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';

import type { TOC } from '@ember/component/template-only';

type FormDataEntryValue = NonNullable<ReturnType<FormData['get']>>;
type Data = { [key: string]: FormDataEntryValue; };

const handleInput = (onChange: (data: Data) => void, event: Event) => {
  assert('An unexpected event was passed to handleInput in <Form>', 'currentTarget' in event && event.currentTarget instanceof HTMLFormElement);

  let formData = new FormData(event.currentTarget);
  let data = Object.fromEntries(formData.entries());

  onChange(data);
}

const handleSubmit = (onChange: (data: Data) => void, event: SubmitEvent) => {
  event.preventDefault();
  handleInput(onChange, event);
};

export const Form: TOC<{
  Element: HTMLFormElement;
  Args: { onChange: (data: Data) => void };
  Blocks: { default: [] };
}> = <template>
  <form
    {{on 'input' (fn handleInput @onChange)}}
    {{on 'submit' (fn handleSubmit @onChange)}}
    ...attributes
  >
    {{yield}}
  </form>
</template>;

export default Form;
