import Component from '@glimmer/component';
import { hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { guidFor } from '@ember/object/internals';

import { modifier as eModifier } from 'ember-modifier';
import { cell } from 'ember-resources';
import { getTabster, getTabsterAttribute, MoverDirections, setTabsterAttribute } from 'tabster';

import { Popover, type Signature as PopoverSignature } from './popover.gts';

import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';

type Cell<V> = ReturnType<typeof cell<V>>;
type PopoverArgs = PopoverSignature['Args'];
type PopoverBlockParams = PopoverSignature['Blocks']['default'][0];

const TABSTER_CONFIG_CONTENT = getTabsterAttribute(
  {
    mover: {
      direction: MoverDirections.Both,
      cyclic: true,
    },
    deloser: {},
  },
  true
);

const TABSTER_CONFIG_TRIGGER = {
  deloser: {},
};

export interface Signature {
  Args: PopoverArgs;
  Blocks: {
    default: [
      {
        arrow: PopoverBlockParams['arrow'];
        trigger: WithBoundArgs<
          typeof trigger,
          'triggerElement' | 'contentId' | 'isOpen' | 'setReference'
        >;
        Trigger: WithBoundArgs<typeof Trigger, 'triggerModifier'>;
        Content: WithBoundArgs<
          typeof Content,
          'triggerElement' | 'contentId' | 'isOpen' | 'PopoverContent'
        >;
        isOpen: boolean;
      },
    ];
  };
}

export interface SeparatorSignature {
  Element: HTMLDivElement;
  Blocks: { default: [] };
}

const Separator: TOC<SeparatorSignature> = <template>
  <div role="separator" ...attributes>
    {{yield}}
  </div>
</template>;

/**
 * We focus items on `pointerMove` to achieve the following:
 *
 * - Mouse over an item (it focuses)
 * - Leave mouse where it is and use keyboard to focus a different item
 * - Wiggle mouse without it leaving previously focused item
 * - Previously focused item should re-focus
 *
 * If we used `mouseOver`/`mouseEnter` it would not re-focus when the mouse
 * wiggles. This is to match native menu implementation.
 */
function focusOnHover(e: PointerEvent) {
  const item = e.currentTarget;

  if (item instanceof HTMLElement) {
    item?.focus();
  }
}

export interface ItemSignature {
  Element: HTMLButtonElement;
  Args: { onSelect?: (event: Event) => void };
  Blocks: { default: [] };
}

const Item: TOC<ItemSignature> = <template>
  <button
    type="button"
    role="menuitem"
    {{! @glint-ignore !}}
    {{(if @onSelect (modifier on "click" @onSelect))}}
    {{on "pointermove" focusOnHover}}
    ...attributes
  >
    {{yield}}
  </button>
</template>;

const installContent = eModifier<{
  Element: HTMLElement;
  Args: {
    Named: {
      isOpen: Cell<boolean>;
      triggerElement: Cell<HTMLElement>;
    };
  };
}>((element, _: [], { isOpen, triggerElement }) => {
  // focus first focusable element on the content
  const tabster = getTabster(window);
  const firstFocusable = tabster?.focusable.findFirst({
    container: element,
  });

  firstFocusable?.focus();

  // listen for "outside" clicks
  function onDocumentClick(e: MouseEvent) {
    if (
      isOpen.current &&
      e.target &&
      !element.contains(e.target as HTMLElement) &&
      !triggerElement.current?.contains(e.target as HTMLElement)
    ) {
      isOpen.current = false;
    }
  }

  // listen for the escape key
  function onDocumentKeydown(e: KeyboardEvent) {
    if (isOpen.current && e.key === 'Escape') {
      isOpen.current = false;
    }
  }

  document.addEventListener('click', onDocumentClick);
  document.addEventListener('keydown', onDocumentKeydown);

  return () => {
    document.removeEventListener('click', onDocumentClick);
    document.removeEventListener('keydown', onDocumentKeydown);
  };
});

interface PrivateContentSignature {
  Element: HTMLDivElement;
  Args: {
    triggerElement: Cell<HTMLElement>;
    contentId: string;
    isOpen: Cell<boolean>;
    PopoverContent: PopoverBlockParams['Content'];
  };
  Blocks: { default: [{ Item: typeof Item; Separator: typeof Separator }] };
}

export interface ContentSignature {
  Element: PrivateContentSignature['Element'];
  Blocks: PrivateContentSignature['Blocks'];
}

const Content: TOC<PrivateContentSignature> = <template>
  {{#if @isOpen.current}}
    <@PopoverContent
      id={{@contentId}}
      role="menu"
      data-tabster={{TABSTER_CONFIG_CONTENT}}
      tabindex="0"
      {{installContent isOpen=@isOpen triggerElement=@triggerElement}}
      {{on "click" @isOpen.toggle}}
      ...attributes
    >
      {{yield (hash Item=Item Separator=Separator)}}
    </@PopoverContent>
  {{/if}}
</template>;

interface PrivateTriggerModifierSignature {
  Element: HTMLElement;
  Args: {
    Named: {
      triggerElement: Cell<HTMLElement>;
      isOpen: Cell<boolean>;
      contentId: string;
      setReference: PopoverBlockParams['setReference'];
      stopPropagation?: boolean;
      preventDefault?: boolean;
    };
  };
}

export interface TriggerModifierSignature {
  Element: PrivateTriggerModifierSignature['Element'];
}

const trigger = eModifier<PrivateTriggerModifierSignature>(
  (
    element,
    _: [],
    { triggerElement, isOpen, contentId, setReference, stopPropagation, preventDefault }
  ) => {
    element.setAttribute('aria-haspopup', 'menu');

    if (isOpen.current) {
      element.setAttribute('aria-controls', contentId);
      element.setAttribute('aria-expanded', 'true');
    } else {
      element.removeAttribute('aria-controls');
      element.setAttribute('aria-expanded', 'false');
    }

    setTabsterAttribute(element, TABSTER_CONFIG_TRIGGER);

    const onTriggerClick = (event: MouseEvent) => {
      if (stopPropagation) {
        event.stopPropagation();
      }

      if (preventDefault) {
        event.preventDefault();
      }

      isOpen.toggle();
    };

    element.addEventListener('click', onTriggerClick);

    triggerElement.current = element;
    // eslint-disable-next-line @typescript-eslint/no-unsafe-call
    setReference(element);

    return () => {
      element.removeEventListener('click', onTriggerClick);
    };
  }
);

interface PrivateTriggerSignature {
  Element: HTMLButtonElement;
  Args: {
    triggerModifier: WithBoundArgs<
      typeof trigger,
      'triggerElement' | 'contentId' | 'isOpen' | 'setReference'
    >;
    stopPropagation?: boolean;
    preventDefault?: boolean;
  };
  Blocks: { default: [] };
}

export interface TriggerSignature {
  Element: PrivateTriggerSignature['Element'];
  Blocks: PrivateTriggerSignature['Blocks'];
}

const Trigger: TOC<PrivateTriggerSignature> = <template>
  <button
    type="button"
    {{@triggerModifier stopPropagation=@stopPropagation preventDefault=@preventDefault}}
    ...attributes
  >
    {{yield}}
  </button>
</template>;

const IsOpen = () => cell<boolean>(false);
const TriggerElement = () => cell<HTMLElement>();

export class Menu extends Component<Signature> {
  contentId = guidFor(this);

  <template>
    {{#let (IsOpen) (TriggerElement) as |isOpen triggerEl|}}
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
        {{#let
          (modifier
            trigger
            triggerElement=triggerEl
            isOpen=isOpen
            contentId=this.contentId
            setReference=p.setReference
          )
          as |triggerModifier|
        }}
          {{yield
            (hash
              trigger=triggerModifier
              Trigger=(component Trigger triggerModifier=triggerModifier)
              Content=(component
                Content
                PopoverContent=p.Content
                isOpen=isOpen
                triggerElement=triggerEl
                contentId=this.contentId
              )
              arrow=p.arrow
              isOpen=isOpen.current
            )
          }}
        {{/let}}
      </Popover>
    {{/let}}
  </template>
}

export default Menu;
