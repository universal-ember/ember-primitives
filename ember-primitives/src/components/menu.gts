import Component from '@glimmer/component';
import { hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { guidFor } from '@ember/object/internals';

import { modifier as eModifier } from 'ember-modifier';
import { cell } from 'ember-resources';
import { getTabster, getTabsterAttribute, Types } from 'tabster';

import { Popover, type Signature as PopoverSignature } from './popover.gts';

import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';

type Cell<V> = ReturnType<typeof cell<V>>;

const TABSTER_CONFIG_CONTENT = getTabsterAttribute(
  {
    mover: {
      direction: Types.MoverDirections.Both,
      cyclic: true,
    },
    deloser: {},
  },
  true
);

const TABSTER_CONFIG_TRIGGER = getTabsterAttribute(
  {
    deloser: {},
  },
  true
);

export interface Signature {
  Args: PopoverSignature['Args'];
  Blocks: {
    default: [
      {
        arrow: PopoverSignature['Blocks']['default'][0]['arrow'];
        Trigger: WithBoundArgs<typeof Trigger, 'triggerElement' | 'contentId' | 'isOpen' | 'hook'>;
        Content: WithBoundArgs<
          typeof Content,
          'triggerElement' | 'contentId' | 'isOpen' | 'PopoverContent'
        >;
        isOpen: boolean;
      },
    ];
  };
}

const Separator: TOC<{
  Element: HTMLDivElement;
  Args: {};
  Blocks: { default: [] };
}> = <template>
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

const Item: TOC<{
  Element: HTMLButtonElement;
  Args: { onSelect?: (event: Event) => void };
  Blocks: { default: [] };
}> = <template>
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

const Content: TOC<{
  Element: HTMLDivElement;
  Args: {
    triggerElement: Cell<HTMLElement>;
    contentId: string;
    isOpen: Cell<boolean>;
    PopoverContent: PopoverSignature['Blocks']['default'][0]['Content'];
  };
  Blocks: { default: [{ Item: typeof Item; Separator: typeof Separator }] };
}> = <template>
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

const installTrigger = eModifier<{
  Element: HTMLElement;
  Args: { Named: { triggerElement: Cell<HTMLElement> } };
}>((element, _: [], { triggerElement }) => {
  triggerElement.current = element;
});

const Trigger: TOC<{
  Element: HTMLButtonElement;
  Args: {
    triggerElement: Cell<HTMLElement>;
    contentId: string;
    isOpen: Cell<boolean>;
    hook: PopoverSignature['Blocks']['default'][0]['hook'];
  };
  Blocks: { default: [] };
}> = <template>
  <button
    data-tabster={{TABSTER_CONFIG_TRIGGER}}
    type="button"
    aria-controls={{if @isOpen.current @contentId}}
    aria-haspopup="menu"
    aria-expanded={{if @isOpen.current "true" "false"}}
    {{@hook}}
    {{installTrigger triggerElement=@triggerElement}}
    {{on "click" @isOpen.toggle}}
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
        {{yield
          (hash
            Trigger=(component
              Trigger hook=p.hook isOpen=isOpen triggerElement=triggerEl contentId=this.contentId
            )
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
      </Popover>
    {{/let}}
  </template>
}

export default Menu;
