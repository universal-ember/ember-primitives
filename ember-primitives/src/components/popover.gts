import { hash } from '@ember/helper';

import { arrow } from '@floating-ui/dom';
import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';
import { Velcro } from 'ember-velcro';

import { Portal } from './portal';
import { TARGETS } from './portal-targets';

import type { TOC } from '@ember/component/template-only';
import type { Middleware, MiddlewareData } from '@floating-ui/dom';
import type { ModifierLike, WithBoundArgs } from '@glint/template';
import type { Signature as HookSignature } from 'ember-velcro/modifiers/velcro';

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
  };
  Blocks: {
    default: [
      {
        hook: ModifierLike<HookSignature>;
        Content: WithBoundArgs<typeof Content, 'loop'>;
        data: MiddlewareData;
        arrow: WithBoundArgs<ModifierLike<AttachArrowSignature>, 'arrowElement' | 'data'>;
      }
    ];
  };
}

interface PrivateContentSignature {
  Element: HTMLDivElement;
  Args: {
    loop: ModifierLike<{ Element: HTMLElement }>;
  };
  Blocks: { default: [] };
}

/**
 * Allows lazy evaluation of the portal target (do nothing until rendered)
 * This is useful because the algorithm for finding the portal target isn't cheap.
 */
const Content: TOC<PrivateContentSignature> = <template>
  <Portal @to={{TARGETS.popover}}>
    <div {{@loop}} ...attributes>
      {{yield}}
    </div>
  </Portal>
</template>;

interface AttachArrowSignature {
  Element: HTMLElement;
  Args: {
    Named: {
      arrowElement: ReturnType<typeof ArrowElement>;
      data?: {
        middlewareData?: MiddlewareData;
        placement?: Placement;
      };
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

const attachArrow = modifier<AttachArrowSignature>((element, _: [], named) => {
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
    elementContext: 'reference',
    ...options,
  };
}

export const Popover: TOC<Signature> = <template>
  {{#let (ArrowElement) as |arrowElement|}}
    <Velcro
      @placement={{@placement}}
      @strategy={{@strategy}}
      @middleware={{maybeAddArrow @middleware arrowElement.current}}
      @flipOptions={{flipOptions @flipOptions}}
      @shiftOptions={{@shiftOptions}}
      @offsetOptions={{@offsetOptions}}
      as |velcro|
    >
      {{yield
        (hash
          hook=velcro.hook
          Content=(component Content loop=velcro.loop)
          data=velcro.data
          arrow=(modifier attachArrow arrowElement=arrowElement data=velcro.data)
        )
      }}
    </Velcro>
  {{/let}}
</template>;

export default Popover;
