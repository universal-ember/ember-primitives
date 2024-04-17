import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { hash } from '@ember/helper';

import { modifier } from 'ember-modifier';

import VelcroModifier from './modifier.ts';

import type { Signature as ModifierSignature } from './modifier.ts';
import type { MiddlewareArguments } from '@floating-ui/dom';
import type { ModifierLike } from '@glint/template';

type ModifierArgs = ModifierSignature['Args']['Named'];

interface Signature {
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
        loop: ModifierLike<{
          Element: HTMLElement;
        }>;
        data: MiddlewareArguments;
      }
    ];
  };
}

interface HookSignature {
  Element: HTMLElement | SVGElement;
}

export default class Velcro extends Component<Signature> {
  @tracked hook?: HTMLElement | SVGElement = undefined;

  // set by VelcroModifier
  @tracked velcroData?: MiddlewareArguments = undefined;

  setVelcroData = (data: MiddlewareArguments) => void (this.velcroData = data);

  setHook = (element: HTMLElement | SVGElement) => {
    this.hook = element;
  };

  velcroHook = modifier<HookSignature>(
    (element: HTMLElement | SVGElement) => {
      this.setHook(element);
    },
  );

  <template>
    {{yield (hash
      hook=this.velcroHook
      setHook=this.setHook
      loop=(if this.hook (modifier VelcroModifier
        this.hook
        flipOptions=@flipOptions
        hideOptions=@hideOptions
        middleware=@middleware
        offsetOptions=@offsetOptions
        placement=@placement
        shiftOptions=@shiftOptions
        strategy=@strategy
        setVelcroData=this.setVelcroData
      ))
      data=this.velcroData
    )}}
  </template>
}
