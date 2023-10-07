import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';

import { modifier } from 'ember-modifier';

import { getDataState } from './item';

export class AccordionContent extends Component<{
  Element: HTMLDivElement;
  Blocks: {
    default: [];
  };
  Args: {
    /**
     * Whether the content is expanded.
     */
    isExpanded: boolean;
    /**
     * The value of the accordion item.
     */
    value: string;
    /**
     * Whether the accordion item is disabled.
     */
    disabled?: boolean;
  }
}> {
  <template>
    <div {{this.handleHiddenState @isExpanded}} role="region" id={{@value}} data-state={{getDataState @isExpanded}} hidden={{this.isHidden}} data-disabled={{@disabled}} ...attributes>
      {{yield}}
    </div>
  </template>

  @tracked isHidden = !this.args.isExpanded;

  handleHiddenState = modifier((element: HTMLDivElement, [isExpanded]) => {
    if (isExpanded) {
      this.isHidden = false;

      return;
    }

    // Wait for all animations to finish before hiding the element
    Promise.allSettled(element.getAnimations().map((a) => a.finished)).then(() => { this.isHidden = true })
  });
}

export default AccordionContent;
