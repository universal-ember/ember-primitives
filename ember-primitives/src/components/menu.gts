import { hash } from '@ember/helper';

import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';

import { Popover, type Signature as PopoverSignature } from './popover.gts';

import type { TOC } from '@ember/component/template-only';
import type { ModifierLike, WithBoundArgs } from '@glint/template';

export interface Signature {
  Args: PopoverSignature['Args'];
  Blocks: {
    default: [
      {
        trigger: ModifierLike<TriggerSignature>;
        arrow: PopoverSignature['Blocks']['default'][0]['arrow'];
        Content: WithBoundArgs<typeof Content, 'PopoverContent' | 'isOpen'>;
      },
    ];
  };
}

const Content: TOC<{
  Element: HTMLDivElement;
  Args: {
    isOpen: boolean;
    PopoverContent: PopoverSignature['Blocks']['default'][0]['Content'];
  };
  Blocks: { default: [] };
}> = <template>
  {{#if @isOpen}}
    <@PopoverContent ...attributes>
      {{yield}}
    </@PopoverContent>
  {{/if}}
</template>;

interface TriggerSignature {
  Element: HTMLElement;
  Args: {
    Named: {
      setHook: (element: HTMLElement | SVGElement) => void;
      isOpen: ReturnType<typeof cell<boolean>>;
    };
  };
}

const trigger = modifier<TriggerSignature>((element, _: [], named) => {
  named.setHook?.(element);

  element.addEventListener('click', named.isOpen.toggle);

  return () => {
    element.removeEventListener('click', named.isOpen.toggle);
  };
});

const IsOpen: () => ReturnType<typeof cell<boolean>> = () => cell<boolean>(false);

export const Menu: TOC<Signature> = <template>
  {{#let (IsOpen) as |isOpen|}}
    <Popover
      @flipOptions={{@flipOptions}}
      @middleware={{@middleware}}
      @offsetOptions={{@offsetOptions}}
      @placement={{@placement}}
      @shiftOptions={{@shiftOptions}}
      @strategy={{@strategy}}
      @inline={{@inline}}
      as |p|
    >
      {{yield
        (hash
          trigger=(modifier trigger setHook=p.setHook isOpen=isOpen)
          Content=(component Content PopoverContent=p.Content isOpen=isOpen.current)
          arrow=p.arrow
        )
      }}
    </Popover>
  {{/let}}
</template>;

export default Menu;
