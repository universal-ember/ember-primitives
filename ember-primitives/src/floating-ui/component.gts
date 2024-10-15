import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { hash } from '@ember/helper';

import { modifier as eModifier } from 'ember-modifier';

import { anchorTo } from './modifier.ts';

import type { Signature as ModifierSignature } from './modifier.ts';
import type { MiddlewareState } from '@floating-ui/dom';
import type { WithBoundArgs, WithBoundPositionals } from '@glint/template';
import type { ModifierLike } from '@glint/template';

type ModifierArgs = ModifierSignature['Args']['Named'];

interface ReferenceSignature {
  Element: HTMLElement | SVGElement;
}

export interface Signature {
  Args: {
    middleware?: ModifierArgs['middleware'];
    placement?: ModifierArgs['placement'];
    strategy?: ModifierArgs['strategy'];
    flipOptions?: ModifierArgs['flipOptions'];
    hideOptions?: ModifierArgs['hideOptions'];
    shiftOptions?: ModifierArgs['shiftOptions'];
    offsetOptions?: ModifierArgs['offsetOptions'];
  };
  Blocks: {
    default: [
      reference: ModifierLike<ReferenceSignature>,
      floating:
        | undefined
        | WithBoundArgs<WithBoundPositionals<typeof anchorTo, 1>, keyof ModifierArgs>,
      util: {
        setReference: (element: HTMLElement | SVGElement) => void;
        data?: MiddlewareState;
      },
    ];
  };
}

const ref = eModifier<{
  Element: HTMLElement | SVGElement;
  Args: {
    Positional: [setRef: (element: HTMLElement | SVGElement) => void];
  };
}>((element: HTMLElement | SVGElement, positional) => {
  let fn = positional[0];

  fn(element);
});

export default class FloatingUI extends Component<Signature> {
  @tracked reference?: HTMLElement | SVGElement = undefined;

  // set by VelcroModifier
  @tracked data?: MiddlewareState = undefined;

  setData: ModifierArgs['setData'] = (data) => (this.data = data);

  setReference = (element: HTMLElement | SVGElement) => {
    this.reference = element;
  };

  <template>
    {{#let
      (modifier
        anchorTo
        flipOptions=@flipOptions
        hideOptions=@hideOptions
        middleware=@middleware
        offsetOptions=@offsetOptions
        placement=@placement
        shiftOptions=@shiftOptions
        strategy=@strategy
        setData=this.setData
      )
      as |prewiredAnchorTo|
    }}
      {{#let (if this.reference (modifier prewiredAnchorTo this.reference)) as |floating|}}
        {{! @glint-nocheck -- Excessively deep, possibly infinite }}
        {{yield
          (modifier ref this.setReference)
          floating
          (hash setReference=this.setReference data=this.data)
        }}
      {{/let}}
    {{/let}}
  </template>
}
