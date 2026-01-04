import type { TOC } from '@ember/component/template-only';
import { ExternalLink } from 'ember-primitives/components/external-link';

const linkClasses = `
  text-sm font-semibold
  dark:text-sky-400
  no-underline shadow-[inset_0_-2px_0_0_var(--tw-prose-background,#fff),inset_0_calc(-1*(var(--tw-prose-underline-size,4px)+2px))_0_0_var(--tw-prose-underline,theme(colors.sky.300))]
  hover:[--tw-prose-underline-size:6px]
  dark:[--tw-prose-background:theme(colors.slate.900)]
  dark:shadow-[inset_0_calc(-1*var(--tw-prose-underline-size,2px))_0_0_var(--tw-prose-underline,theme(colors.sky.800))]
  dark:hover:[--tw-prose-underline-size:6px]
`;

export const InternalLink: TOC<{
  Element: HTMLAnchorElement;
  Blocks: { default: [] };
}> = <template>
  <a class={{linkClasses}} href="#" ...attributes>
    {{yield}}
  </a>
</template>;

export const Link: TOC<{
  Element: HTMLAnchorElement;
  Blocks: { default: [] };
}> = <template>
  <ExternalLink class={{linkClasses}} ...attributes>
    {{yield}}
  </ExternalLink>
</template>;
