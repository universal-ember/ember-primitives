
import Component from '@glimmer/component';
import { assert } from '@ember/debug';
import { hash } from '@ember/helper';
import { localCopy } from 'tracked-toolbox';
import { A as AccordionItem } from '../item-CwIzoqlC.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import { g, i } from 'decorator-transforms/runtime';

class Accordion extends Component {
  static {
    setComponentTemplate(precompileTemplate("\n    <div data-disabled={{@disabled}} ...attributes>\n      {{yield (hash Item=(component AccordionItem selectedValue=this.selectedValue toggleItem=this.toggleItem disabled=@disabled))}}\n    </div>\n  ", {
      strictMode: true,
      scope: () => ({
        hash,
        AccordionItem
      })
    }), this);
  }
  // eslint-disable-next-line @typescript-eslint/no-unsafe-call
  static {
    g(this.prototype, "_internallyManagedValue", [localCopy("args.defaultValue")]);
  }
  #_internallyManagedValue = (i(this, "_internallyManagedValue"), void 0);
  get selectedValue() {
    return this.args.value ?? this._internallyManagedValue;
  }
  toggleItem = value => {
    if (this.args.disabled) {
      return;
    }
    if (this.args.type === "single") {
      this.toggleItemSingle(value);
    } else if (this.args.type === "multiple") {
      this.toggleItemMultiple(value);
    }
  };
  toggleItemSingle = value => {
    assert("Cannot call `toggleItemSingle` when `disabled` is true.", !this.args.disabled);
    assert("Cannot call `toggleItemSingle` when `type` is not `single`.", this.args.type === "single");
    if (value === this.selectedValue && !this.args.collapsible) {
      return;
    }
    const newValue = value === this.selectedValue ? undefined : value;
    if (this.args.onValueChange) {
      this.args.onValueChange(newValue);
    } else {
      this._internallyManagedValue = newValue;
    }
  };
  toggleItemMultiple = value => {
    assert("Cannot call `toggleItemMultiple` when `disabled` is true.", !this.args.disabled);
    assert("Cannot call `toggleItemMultiple` when `type` is not `multiple`.", this.args.type === "multiple");
    const currentValues = this.selectedValue ?? [];
    const indexOfValue = currentValues.indexOf(value);
    let newValue;
    if (indexOfValue === -1) {
      newValue = [...currentValues, value];
    } else {
      newValue = [...currentValues.slice(0, indexOfValue), ...currentValues.slice(indexOfValue + 1)];
    }
    if (this.args.onValueChange) {
      this.args.onValueChange(newValue);
    } else {
      this._internallyManagedValue = newValue;
    }
  };
}

export { Accordion, Accordion as default };
//# sourceMappingURL=accordion.js.map
