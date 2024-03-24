import { assert } from '@ember/debug';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

const handleInput = (onChange1, event1, eventType1 = 'input') => {
  assert('An unexpected event was passed to handleInput in <Form>', 'currentTarget' in event1 && event1.currentTarget instanceof HTMLFormElement);
  let formData1 = new FormData(event1.currentTarget);
  let data1 = Object.fromEntries(formData1.entries());
  onChange1(data1, eventType1, event1);
};
const handleSubmit = (onChange1, event1) => {
  event1.preventDefault();
  handleInput(onChange1, event1, 'submit');
};
const Form = setComponentTemplate(precompileTemplate("\n  <form {{on \"input\" (fn handleInput @onChange)}} {{on \"submit\" (fn handleSubmit @onChange)}} ...attributes>\n    {{yield}}\n  </form>\n", {
  scope: () => ({
    on,
    fn,
    handleInput,
    handleSubmit
  }),
  strictMode: true
}), templateOnly());

export { Form, Form as default };
//# sourceMappingURL=form.js.map
