import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';

import { modifier } from 'ember-modifier';


export interface AccordionContentSignature {
  Element: HTMLDivElement;
  Blocks: {
    default: [];
  };
  Args: {
    isExpanded: boolean;
    value: string;
  }
}

export class AccordionContent extends Component<AccordionContentSignature> {
  <template>
    <div {{this.register @isExpanded}} role="region" id={{@value}} data-state={{if @isExpanded "open" "closed"}} hidden={{this.isHidden}} ...attributes>
      {{yield}}
    </div>
  </template>

  @tracked isHidden = !this.args.isExpanded;

  register = modifier((element: HTMLDivElement, [isExpanded]) => {
    if (isExpanded) {
      this.isHidden = false;

      return;
    }

    // Wait for all animations to finish before hiding the element
    Promise.allSettled(element.getAnimations().map((a) => a.finished)).then(() => { this.isHidden = true })
  });
}

export default AccordionContent;
