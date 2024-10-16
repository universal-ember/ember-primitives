import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import { dataFrom } from 'form-data-utils';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

const dataFromEvent = dataFrom;
const handleInput = (onChange1, event1, eventType1 = 'input') => {
  let data1 = dataFrom(event1);
  onChange1(data1, eventType1, event1);
};
const handleSubmit = (onChange1, event1) => {
  event1.preventDefault();
  handleInput(onChange1, event1, 'submit');
};
const Form = setComponentTemplate(precompileTemplate("\n  <form {{on \"input\" (fn handleInput @onChange)}} {{on \"submit\" (fn handleSubmit @onChange)}} ...attributes>\n    {{yield}}\n  </form>\n", {
  strictMode: true,
  scope: () => ({
    on,
    fn,
    handleInput,
    handleSubmit
  })
}), templateOnly());

export { Form, dataFromEvent, Form as default };
//# sourceMappingURL=form.js.map
