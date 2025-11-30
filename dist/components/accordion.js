
import Component from '@glimmer/component';
import { assert } from '@ember/debug';
import { hash } from '@ember/helper';
import { localCopy } from 'tracked-toolbox';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import { on } from '@ember/modifier';
import templateOnly from '@ember/component/template-only';
import { g, i } from 'decorator-transforms/runtime';

class AccordionContent extends Component {
  static {
    setComponentTemplate(precompileTemplate("\n    <div role=\"region\" id={{@value}} data-state={{getDataState @isExpanded}} hidden={{this.isHidden}} data-disabled={{@disabled}} ...attributes>\n      {{yield}}\n    </div>\n  ", {
      strictMode: true,
      scope: () => ({
        getDataState
      })
    }), this);
  }
  get isHidden() {
    return !this.args.isExpanded;
  }
}

const AccordionTrigger = setComponentTemplate(precompileTemplate("\n  <button type=\"button\" aria-controls={{@value}} aria-expanded={{@isExpanded}} data-state={{getDataState @isExpanded}} data-disabled={{@disabled}} aria-disabled={{if @disabled \"true\" \"false\"}} {{on \"click\" @toggleItem}} ...attributes>\n    {{yield}}\n  </button>\n", {
  strictMode: true,
  scope: () => ({
    getDataState,
    on
  })
}), templateOnly());

const AccordionHeader = setComponentTemplate(precompileTemplate("\n  <div role=\"heading\" aria-level=\"3\" data-state={{getDataState @isExpanded}} data-disabled={{@disabled}} ...attributes>\n    {{yield (hash Trigger=(component Trigger value=@value isExpanded=@isExpanded disabled=@disabled toggleItem=@toggleItem))}}\n  </div>\n", {
  strictMode: true,
  scope: () => ({
    getDataState,
    hash,
    Trigger: AccordionTrigger
  })
}), templateOnly());

function getDataState(isExpanded) {
  return isExpanded ? "open" : "closed";
}
class AccordionItem extends Component {
  static {
    setComponentTemplate(precompileTemplate("\n    <div data-state={{getDataState this.isExpanded}} data-disabled={{@disabled}} ...attributes>\n      {{yield (hash isExpanded=this.isExpanded Header=(component Header value=@value isExpanded=this.isExpanded disabled=@disabled toggleItem=this.toggleItem) Content=(component Content value=@value isExpanded=this.isExpanded disabled=@disabled))}}\n    </div>\n  ", {
      strictMode: true,
      scope: () => ({
        getDataState,
        hash,
        Header: AccordionHeader,
        Content: AccordionContent
      })
    }), this);
  }
  get isExpanded() {
    if (Array.isArray(this.args.selectedValue)) {
      return this.args.selectedValue.includes(this.args.value);
    }
    return this.args.selectedValue === this.args.value;
  }
  toggleItem = () => {
    if (this.args.disabled) return;
    this.args.toggleItem(this.args.value);
  };
}

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
