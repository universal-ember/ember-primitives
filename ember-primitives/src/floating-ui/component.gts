import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { hash } from '@ember/helper';

import { modifier } from 'ember-modifier';

import VelcroModifier from './modifier.ts';

import type { Signature as ModifierSignature } from './modifier.ts';
import type { MiddlewareState } from '@floating-ui/dom';
import type { WithBoundArgs, WithBoundPositionals } from '@glint/template';
import type { ModifierLike } from '@glint/template';

type ModifierArgs = ModifierSignature['Args']['Named'];

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

interface HookSignature {
  Element: HTMLElement | SVGElement;
}

export default class Velcro extends Component<Signature> {
  @tracked hook?: HTMLElement | SVGElement = undefined;

  // set by VelcroModifier
  @tracked velcroData?: MiddlewareState = undefined;

  setVelcroData: ModifierArgs['setVelcroData'] = (data) => (this.velcroData = data);

  setHook = (element: HTMLElement | SVGElement) => {
    this.hook = element;
  };

  velcroHook = modifier<HookSignature>((element: HTMLElement | SVGElement) => {
    this.setHook(element);
  });

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
        {{yield
          (hash hook=this.velcroHook setHook=this.setHook loop=loopWithHook data=this.velcroData)
        }}
      {{/let}}
    {{/let}}
  </template>
}
