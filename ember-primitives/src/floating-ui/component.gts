import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { hash } from '@ember/helper';

import { modifier as eModifier } from 'ember-modifier';

import VelcroModifier from './modifier.ts';

import type { Signature as ModifierSignature } from './modifier.ts';
import type { MiddlewareState } from '@floating-ui/dom';
import type { WithBoundArgs, WithBoundPositionals } from '@glint/template';
import type { ModifierLike } from '@glint/template';

type ModifierArgs = ModifierSignature['Args']['Named'];

interface HookSignature {
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
      velcro: {
        hook: ModifierLike<HookSignature>;
        setHook: (element: HTMLElement | SVGElement) => void;
        loop?: WithBoundArgs<WithBoundPositionals<typeof VelcroModifier, 1>, keyof ModifierArgs>;
        data?: MiddlewareState;
      },
    ];
  };
}

const ref = eModifier<{
  Element: HTMLElement | SVGElement;
  Args: {
    Positional: [setRef: (element: HTMLElement | SVGElement) => void];
  }
}>((element: HTMLElement | SVGElement, positional) => {
  let fn = positional[0];

  fn(element);
});



export default class Velcro extends Component<Signature> {
  @tracked hook?: HTMLElement | SVGElement = undefined;

  // set by VelcroModifier
  @tracked velcroData?: MiddlewareState = undefined;

  setVelcroData: ModifierArgs['setVelcroData'] = (data) => (this.velcroData = data);

  setHook = (element: HTMLElement | SVGElement) => {
    this.hook = element;
  };

  <template>
    {{#let
      (modifier
        VelcroModifier
        flipOptions=@flipOptions
        hideOptions=@hideOptions
        middleware=@middleware
        offsetOptions=@offsetOptions
        placement=@placement
        shiftOptions=@shiftOptions
        strategy=@strategy
        setVelcroData=this.setVelcroData
      )
      as |loop|
    }}
      {{#let (if this.hook (modifier loop this.hook)) as |loopWithHook|}}
        {{! @glint-nocheck -- Excessively deep, possibly infinite }}
        {{yield
          (hash
            hook=(modifier ref this.setHook)
            setHook=this.setHook
            loop=loopWithHook
            data=this.velcroData
          )
        }}
      {{/let}}
    {{/let}}
  </template>
}
