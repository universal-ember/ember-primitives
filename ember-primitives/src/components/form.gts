import { assert } from '@ember/debug';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';

import type { TOC } from '@ember/component/template-only';

type FormDataEntryValue = NonNullable<ReturnType<FormData['get']>>;
type Data = { [key: string]: FormDataEntryValue | string[] };

import { dataFrom } from 'form-data-utils';

export const dataFromEvent = dataFrom;

const handleInput = (
  onChange: (data: Data, eventType: 'input' | 'submit', event: Event) => void,
  event: Event | SubmitEvent,
  eventType: 'input' | 'submit' = 'input'
) => {
  let data = dataFrom(event);

  onChange(data, eventType, event);
};

const handleSubmit = (
  onChange: (data: Data, eventType: 'input' | 'submit', event: Event | SubmitEvent) => void,
  event: SubmitEvent
) => {
  event.preventDefault();
  handleInput(onChange, event, 'submit');
};

export interface Signature {
  Element: HTMLFormElement;
  Args: {
    /**
     *  Any time the value of any field is changed this function will be called.
     */
    onChange: (
      /**
       * The data from the form as an Object of `{ [field name] => value }` pairs.
       * This is generated from the native [FormData](https://developer.mozilla.org/en-US/docs/Web/API/FormData)
       *
       * Additional fields/inputs/controls can be added to this data by specifying a
       * "name" attribute.
       */
      data: Data,
      /**
       * Indicates whether the `onChange` function was called from the `input` or `submit` event handlers.
       */
      eventType: 'input' | 'submit',
      /**
       * The raw event, if needed.
       */
      event: Event | SubmitEvent
    ) => void;
  };
  Blocks: {
    /**
     * The main content for the form. This is where inputs / fields / controls would go.
     * Within the `<form>` content, `<button type="submit">` will submit the form, which
     * triggers the `@onChange` event.
     */
    default: [];
  };
}

export const Form: TOC<Signature> = <template>
  <form
    {{on "input" (fn handleInput @onChange)}}
    {{on "submit" (fn handleSubmit @onChange)}}
    ...attributes
  >
    {{yield}}
  </form>
</template>;

export default Form;
