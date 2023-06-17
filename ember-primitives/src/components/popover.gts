import { hash } from '@ember/helper';

import { Velcro } from 'ember-velcro';

import { Portal } from './portal';
import { TARGETS } from './portal-targets';

import type { TOC } from '@ember/component/template-only';
import type { ModifierLike, WithBoundArgs } from '@glint/template';
import type { Signature as HookSignature } from 'ember-velcro/modifiers/velcro';

export interface Signature {
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
  <Velcro as |velcro|>
    {{yield (hash hook=velcro.hook Content=(component Content loop=velcro.loop))}}
  </Velcro>
</template>;

export default Popover;
