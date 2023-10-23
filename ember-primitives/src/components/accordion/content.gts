import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { waitForPromise } from '@ember/test-waiters';

import { modifier } from 'ember-modifier';

import { getDataState } from './item';

export interface AccordionContentExternalSignature {
  Element: HTMLDivElement;
  Blocks: {
    default: [];
  };
  Args: {};
}

interface Signature extends AccordionContentExternalSignature {
  Args: AccordionContentExternalSignature['Args'] & {
    isExpanded: boolean;
    value: string;
    disabled?: boolean;
  };
}

export class AccordionContent extends Component<Signature> {
  <template>
    <div
      {{this.setHeightAndWidthCssProperties @isExpanded}}
      {{this.handleHiddenState @isExpanded}}
      role='region'
      id={{@value}}
      data-state={{getDataState @isExpanded}}
      hidden={{this.isHidden}}
      data-disabled={{@disabled}}
      ...attributes
    >
      {{yield}}
    </div>
  </template>

  @tracked isHidden = !this.args.isExpanded;

  setHeightAndWidthCssProperties = modifier((element: HTMLDivElement, [_]) => {
    const hidden = element.hidden;

    element.hidden = false;
    element.style.transitionDuration = '0s';
    element.style.animationName = 'none';

    const { height, width } = element.getBoundingClientRect();

    element.style.setProperty('--accordion-content-height', `${height}px`);
    element.style.setProperty('--accordion-content-width', `${width}px`);

    element.hidden = hidden;
    element.style.transitionDuration = '';
    element.style.animationName = '';
  });

  handleHiddenState = modifier((element: HTMLDivElement, [isExpanded]) => {
    if (isExpanded) {
      this.isHidden = false;

      return;
    }

    // Wait for all animations to finish before hiding the element
    waitForPromise(Promise.allSettled(element.getAnimations().map((a) => a.finished))).then(() => {
      this.isHidden = true;
    });
  });
}

export default AccordionContent;
