import { hash } from '@ember/helper';

import { arrow } from '@floating-ui/dom';
import { element } from 'ember-element-helper';
import { modifier as eModifier } from 'ember-modifier';
import { cell } from 'ember-resources';

import { FloatingUI } from '../floating-ui.ts';
import { Portal } from './portal.gts';
import { TARGETS } from './portal-targets.gts';

import type { Signature as FloatingUiComponentSignature } from '../floating-ui/component.ts';
import type { Signature as HookSignature } from '../floating-ui/modifier.ts';
import type { TOC } from '@ember/component/template-only';
import type { ElementContext, Middleware } from '@floating-ui/dom';
import type { ModifierLike, WithBoundArgs } from '@glint/template';

export interface Signature {
  Args: {
    /**
     * See the Floating UI's [flip docs](https://floating-ui.com/docs/flip) for possible values.
     *
     * This argument is forwarded to `ember-velcro`'s `<Velcro>` component.
     */
    flipOptions?: HookSignature['Args']['Named']['flipOptions'];
    /**
     * Array of one or more objects to add to Floating UI's list of [middleware](https://floating-ui.com/docs/middleware)
     *
     * This argument is forwarded to `ember-velcro`'s `<Velcro>` component.
     */
    middleware?: HookSignature['Args']['Named']['middleware'];
    /**
     * See the Floating UI's [offset docs](https://floating-ui.com/docs/offset) for possible values.
     *
     * This argument is forwarded to `ember-velcro`'s `<Velcro>` component.
     */
    offsetOptions?: HookSignature['Args']['Named']['offsetOptions'];
    /**
     * One of the possible [`placements`](https://floating-ui.com/docs/computeposition#placement). The default is 'bottom'.
     *
     * Possible values are
     * - top
     * - bottom
     * - right
     * - left
     *
     * And may optionally have `-start` or `-end` added to adjust position along the side.
     *
     * This argument is forwarded to `ember-velcro`'s `<Velcro>` component.
     */
    placement?: `${'top' | 'bottom' | 'left' | 'right'}${'' | '-start' | '-end'}`;
    /**
     * See the Floating UI's [shift docs](https://floating-ui.com/docs/shift) for possible values.
     *
     * This argument is forwarded to `ember-velcro`'s `<Velcro>` component.
     */
    shiftOptions?: HookSignature['Args']['Named']['shiftOptions'];
    /**
     * CSS position property, either `fixed` or `absolute`.
     *
     * Pros and cons of each strategy are explained on [Floating UI's Docs](https://floating-ui.com/docs/computePosition#strategy)
     *
     * This argument is forwarded to `ember-velcro`'s `<Velcro>` component.
     */
    strategy?: HookSignature['Args']['Named']['strategy'];

    /**
     * By default, the popover is portaled.
     * If you don't control your CSS, and the positioning of the popover content
     * is misbehaving, you may pass "@inline={{true}}" to opt out of portalling.
     *
     * Inline may also be useful in nested menus, where you know exactly how the nesting occurs
     */
    inline?: boolean;
  };
  Blocks: {
    default: [
      {
        reference: FloatingUiComponentSignature['Blocks']['default'][0];
        setReference: FloatingUiComponentSignature['Blocks']['default'][2]['setReference'];
        Content: WithBoundArgs<typeof Content, 'floating'>;
        data: FloatingUiComponentSignature['Blocks']['default'][2]['data'];
        arrow: WithBoundArgs<ModifierLike<AttachArrowSignature>, 'arrowElement' | 'data'>;
      },
    ];
  };
}

function getElementTag(tagName: undefined | string) {
  return tagName || 'div';
}

/**
 * Allows lazy evaluation of the portal target (do nothing until rendered)
 * This is useful because the algorithm for finding the portal target isn't cheap.
 */
const Content: TOC<{
  Element: HTMLDivElement;
  Args: {
    floating: ModifierLike<{ Element: HTMLElement }>;
    inline?: boolean;
    /**
     * By default the popover content is wrapped in a div.
     * You may change this by supplying the name of an element here.
     *
     * For example:
     * ```gjs
     * <Popover as |p|>
     *  <p.Content @as="dialog">
     *    this is now focus trapped
     *  </p.Content>
     * </Popover>
     * ```
     */
    as?: string;
  };
  Blocks: { default: [] };
}> = <template>
  {{#let (element (getElementTag @as)) as |El|}}
    {{#if @inline}}
      {{! @glint-ignore
            https://github.com/tildeio/ember-element-helper/issues/91
            https://github.com/typed-ember/glint/issues/610
      }}
      <El {{@floating}} ...attributes>
        {{yield}}
      </El>
    {{else}}
      <Portal @to={{TARGETS.popover}}>
        {{! @glint-ignore
              https://github.com/tildeio/ember-element-helper/issues/91
              https://github.com/typed-ember/glint/issues/610
        }}
        <El {{@floating}} ...attributes>
          {{yield}}
        </El>
      </Portal>
    {{/if}}
  {{/let}}
</template>;

interface AttachArrowSignature {
  Element: HTMLElement;
  Args: {
    Named: {
      arrowElement: ReturnType<typeof ArrowElement>;
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      data?: any;
    };
  };
}

const arrowSides = {
  top: 'bottom',
  right: 'left',
  bottom: 'top',
  left: 'right',
};

type Direction = 'top' | 'bottom' | 'left' | 'right';
type Placement = `${Direction}${'' | '-start' | '-end'}`;

const attachArrow = eModifier<AttachArrowSignature>((element, _: [], named) => {
  if (element === named.arrowElement.current) {
    if (!named.data) return;
    if (!named.data.middlewareData) return;

    let { arrow } = named.data.middlewareData;
    let { placement } = named.data;

    if (!arrow) return;
    if (!placement) return;

    let { x: arrowX, y: arrowY } = arrow;
    let otherSide = (placement as Placement).split('-')[0] as Direction;
    let staticSide = arrowSides[otherSide];

    Object.assign(named.arrowElement.current.style, {
      left: arrowX != null ? `${arrowX}px` : '',
      top: arrowY != null ? `${arrowY}px` : '',
      right: '',
      bottom: '',
      [staticSide]: '-4px',
    });

    return;
  }

  (async () => {
    await Promise.resolve();
    named.arrowElement.set(element);
  })();
});

const ArrowElement: () => ReturnType<typeof cell<HTMLElement>> = () => cell<HTMLElement>();

function maybeAddArrow(middleware: Middleware[] | undefined, element: Element | undefined) {
  let result = [...(middleware || [])];

  if (element) {
    result.push(arrow({ element }));
  }

  return result;
}

function flipOptions(options: HookSignature['Args']['Named']['flipOptions']) {
  return {
    elementContext: 'reference' as ElementContext,
    ...options,
  };
}

export const Popover: TOC<Signature> = <template>
  {{#let (ArrowElement) as |arrowElement|}}
    <FloatingUI
      @placement={{@placement}}
      @strategy={{@strategy}}
      @middleware={{maybeAddArrow @middleware arrowElement.current}}
      @flipOptions={{flipOptions @flipOptions}}
      @shiftOptions={{@shiftOptions}}
      @offsetOptions={{@offsetOptions}}
      as |reference floating extra|
    >
      {{yield
        (hash
          reference=reference
          setReference=extra.setReference
          Content=(component Content floating=floating inline=@inline)
          data=extra.data
          arrow=(modifier attachArrow arrowElement=arrowElement data=extra.data)
        )
      }}
    </FloatingUI>
  {{/let}}
</template>;

export default Popover;
