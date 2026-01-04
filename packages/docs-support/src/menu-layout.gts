// @ts-expect-error - no types are provided for ember-mobile-menu
import MenuWrapper from 'ember-mobile-menu/components/mobile-menu-wrapper';

import { Menu } from './icons.gts';
import { SideNav } from './side-nav.gts';

import type { TOC } from '@ember/component/template-only';
import type { ComponentLike, WithBoundArgs } from '@glint/template';

const Toggle: TOC<{
  Args: {
    toggle: ComponentLike<{ Blocks: { default: [] } }>;
  };
}> = <template>
  <@toggle>
    <Menu class="w-6 h-6 stroke-slate-500" />
  </@toggle>
</template>;

export const ResponsiveMenuLayout: TOC<{
  Blocks: {
    content: [];
    header: [toggle: WithBoundArgs<typeof Toggle, 'toggle'>];
  };
}> = <template>
  <MenuWrapper as |mmw|>
    <mmw.MobileMenu @mode="push" @maxWidth={{300}} as |mm|>
      <SideNav @onClick={{mm.actions.close}} />
    </mmw.MobileMenu>

    <mmw.Content>
      {{yield (component Toggle toggle=mmw.Toggle) to="header"}}

      <div class="outer-content">
        <SideNav />

        <main class="relative grid justify-center flex-auto w-full mx-auto max-w-8xl">
          {{yield to="content"}}
        </main>
      </div>
    </mmw.Content>
  </MenuWrapper>
</template>;
