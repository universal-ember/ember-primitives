import { hash } from '@ember/helper';

import { Velcro } from 'ember-velcro';

import { Portal } from './portal';
import { TARGETS } from './portal-targets';

import type { TOC } from '@ember/component/template-only';
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

export const Popover: TOC<Signature> = <template>
  <Velcro
    @placement={{@placement}}
    @strategy={{@strategy}}
    @middleware={{@middleware}}
    @flipOptions={{@flipOptions}}
    @shiftOptions={{@shiftOptions}}
    @offsetOptions={{@offsetOptions}}
    as |velcro|
  >
    {{yield (hash hook=velcro.hook Content=(component Content loop=velcro.loop))}}
  </Velcro>
</template>;

export default Popover;
