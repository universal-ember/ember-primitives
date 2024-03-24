import Component from '@glimmer/component';
import { hash } from '@ember/helper';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import { on } from '@ember/modifier';
import templateOnly from '@ember/component/template-only';

const AccordionTrigger = setComponentTemplate(precompileTemplate("\n  <button type=\"button\" aria-controls={{@value}} aria-expanded={{@isExpanded}} data-state={{getDataState @isExpanded}} data-disabled={{@disabled}} aria-disabled={{if @disabled \"true\" \"false\"}} {{on \"click\" @toggleItem}} ...attributes>\n    {{yield}}\n  </button>\n", {
  scope: () => ({
    getDataState,
    on
  }),
  strictMode: true
}), templateOnly());

const AccordionHeader = setComponentTemplate(precompileTemplate("\n  <div role=\"heading\" aria-level=\"3\" data-state={{getDataState @isExpanded}} data-disabled={{@disabled}} ...attributes>\n    {{yield (hash Trigger=(component Trigger value=@value isExpanded=@isExpanded disabled=@disabled toggleItem=@toggleItem))}}\n  </div>\n", {
  scope: () => ({
    getDataState,
    hash,
    Trigger: AccordionTrigger
  }),
  strictMode: true
}), templateOnly());

class AccordionContent extends Component {
  static {
    setComponentTemplate(precompileTemplate("\n    <div role=\"region\" id={{@value}} data-state={{getDataState @isExpanded}} hidden={{this.isHidden}} data-disabled={{@disabled}} ...attributes>\n      {{yield}}\n    </div>\n  ", {
      scope: () => ({
        getDataState
      }),
      strictMode: true
    }), this);
  }
  get isHidden() {
    return !this.args.isExpanded;
  }
}

function getDataState(isExpanded1) {
  return isExpanded1 ? 'open' : 'closed';
}
class AccordionItem extends Component {
  static {
    setComponentTemplate(precompileTemplate("\n    <div data-state={{getDataState this.isExpanded}} data-disabled={{@disabled}} ...attributes>\n      {{yield (hash isExpanded=this.isExpanded Header=(component Header value=@value isExpanded=this.isExpanded disabled=@disabled toggleItem=this.toggleItem) Content=(component Content value=@value isExpanded=this.isExpanded disabled=@disabled))}}\n    </div>\n  ", {
      scope: () => ({
        getDataState,
        hash,
        Header: AccordionHeader,
        Content: AccordionContent
      }),
      strictMode: true
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

export { AccordionItem as A, AccordionTrigger as a, AccordionHeader as b, AccordionContent as c, getDataState as g };
//# sourceMappingURL=item-HBCzMJwv.js.map
