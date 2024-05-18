import { assert } from '@ember/debug';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';

import type { TOC } from '@ember/component/template-only';

type FormDataEntryValue = NonNullable<ReturnType<FormData['get']>>;
type Data = { [key: string]: FormDataEntryValue | string[] };

/**
 * A utility function for extracting the FormData as an object
 *
 * Each input within your `<form>` should have a `name` attribute.
 * (or else the `<form>` element doesn't know what inputs are relevant)
 *
 * This will provide values for all types of controls/fields,
 * - input
 *   - text
 *   - checkbox
 *   - radio
 *   - etc
 * - select
 *   - behavior is fixed from browser default behavior, where
 *     only the most recently selected value comes through in
 *     the FormData. This fix only affects `<select multiple>`
 *
 * Example:
 *
 * ```gjs
 * import { dataFromEvent } from 'ember-primitives/components/form';
 *
 * function handleSubmit(event) {
 *   event.preventDefault();
 *   // an object containing the key-value pairs of
 *   // the state of the form
 *   dataFromEvent(event);
 * }
 *
 * <template>
 *   <form onsubmit={{handleSubmit}}>
 *     <input type="text" name="firstName" />
 *     <button type="submit">Submit</button>
 *   </form>
 * </template>
 * ```
 *
 */
export function dataFromEvent(event: { currentTarget: EventTarget | null }): {
  [name: string]: FormDataEntryValue | string[];
} {
  assert(
    'An unexpected event was passed to formDataFrom in <Form>',
    'currentTarget' in event && event.currentTarget instanceof HTMLFormElement
  );

  let form = event.currentTarget;
  let formData = new FormData(form);
  let data: Data = Object.fromEntries(formData.entries());

  // Gather fields from the form, and set any missing
  // values to undefined.
  let fields = form.querySelectorAll('input,select');

  for (let field of fields) {
    let name = field.getAttribute('name');

    // The field is probably invalid
    if (!name) continue;

    let hasSubmitted = name in data;

    if (!hasSubmitted) data[name] = '';

    // If the field is a `select`, we need to better
    // handle the value, since only the most recently
    // clicked will beb available
    if (field instanceof HTMLSelectElement) {
      if (field.hasAttribute('multiple')) {
        let options = field.querySelectorAll('option');
        let values = [];

        for (let option of options) {
          if (option.selected) {
            values.push(option.value);
          }
        }

        data[field.name] = values;
      }
    }
  }

  return data;
}

const handleInput = (
  onChange: (data: Data, eventType: 'input' | 'submit', event: Event) => void,
  event: Event | SubmitEvent,
  eventType: 'input' | 'submit' = 'input'
) => {
  let data = dataFromEvent(event);

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
