import Component from '@glimmer/component';
import { assert } from '@ember/debug';
import { hash } from '@ember/helper';
import { localCopy } from 'tracked-toolbox';
import { A as AccordionItem } from '../item-DmpElnSZ.js';
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
  static {
    g(this.prototype, "_internallyManagedValue", [localCopy('args.defaultValue')]);
  }
  #_internallyManagedValue = (i(this, "_internallyManagedValue"), void 0);
  get selectedValue() {
    return this.args.value ?? this._internallyManagedValue;
  }
  toggleItem = value1 => {
    if (this.args.disabled) {
      return;
    }
    if (this.args.type === 'single') {
      this.toggleItemSingle(value1);
    } else if (this.args.type === 'multiple') {
      this.toggleItemMultiple(value1);
    }
  };
  toggleItemSingle = value1 => {
    assert('Cannot call `toggleItemSingle` when `disabled` is true.', !this.args.disabled);
    assert('Cannot call `toggleItemSingle` when `type` is not `single`.', this.args.type === 'single');
    if (value1 === this.selectedValue && !this.args.collapsible) {
      return;
    }
    const newValue1 = value1 === this.selectedValue ? undefined : value1;
    if (this.args.onValueChange) {
      this.args.onValueChange(newValue1);
    } else {
      this._internallyManagedValue = newValue1;
    }
  };
  toggleItemMultiple = value1 => {
    assert('Cannot call `toggleItemMultiple` when `disabled` is true.', !this.args.disabled);
    assert('Cannot call `toggleItemMultiple` when `type` is not `multiple`.', this.args.type === 'multiple');
    const currentValues1 = this.selectedValue ?? [];
    const indexOfValue1 = currentValues1.indexOf(value1);
    let newValue1;
    if (indexOfValue1 === -1) {
      newValue1 = [...currentValues1, value1];
    } else {
      newValue1 = [...currentValues1.slice(0, indexOfValue1), ...currentValues1.slice(indexOfValue1 + 1)];
    }
    if (this.args.onValueChange) {
      this.args.onValueChange(newValue1);
    } else {
      this._internallyManagedValue = newValue1;
    }
  };
}

export { Accordion, Accordion as default };
//# sourceMappingURL=accordion.js.map
