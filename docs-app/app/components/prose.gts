import { modifier as eModifier } from 'ember-modifier';
import { ExternalLink, service } from 'ember-primitives';

import { highlight } from './highlight';

import type { TOC } from '@ember/component/template-only';

const resetScroll = eModifier((element, [prose]) => {
  prose;
  window.scrollTo(0, 0);
});

export const Prose: TOC<{ Element: HTMLElement }> = <template>
  {{#let (service "docs") as |docs|}}
    <section
      class="flex-auto max-w-2xl min-w-0 px-4 py-16 lg:max-w-none lg:pl-8 lg:pr-0 xl:px-16"
      ...attributes
      {{resetScroll docs.selected.prose}}
    >

      <article
        class="prose prose-slate max-w-none dark:prose-invert dark:text-slate-400 prose-headings:inline-block prose-th:table-cell prose-headings:scroll-mt-28 prose-h1:text-3xl prose-headings:font-display prose-headings:font-normal lg:prose-headings:scroll-mt-[8.5rem] prose-lead:text-slate-500 dark:prose-lead:text-slate-400 prose-a:font-semibold dark:prose-a:text-sky-400 prose-a:no-underline prose-a:shadow-[inset_0_-2px_0_0_var(--tw-prose-background,#fff),inset_0_calc(-1*(var(--tw-prose-underline-size,4px)+2px))_0_0_var(--tw-prose-underline,theme(colors.sky.300))] hover:prose-a:[--tw-prose-underline-size:6px] dark:[--tw-prose-background:theme(colors.slate.900)] dark:prose-a:shadow-[inset_0_calc(-1*var(--tw-prose-underline-size,2px))_0_0_var(--tw-prose-underline,theme(colors.sky.800))] dark:hover:prose-a:[--tw-prose-underline-size:6px] prose-pre:rounded-xl prose-pre:bg-slate-900 prose-pre:shadow-lg dark:prose-pre:bg-slate-800/60 dark:prose-pre:shadow-none dark:prose-pre:ring-1 dark:prose-pre:ring-slate-300/10 dark:prose-hr:border-slate-800 dark:prose-code:text-slate-50"
        {{highlight docs.selected.prose}}
      >
        {{#if docs.selected.prose}}
          <docs.selected.prose />
        {{/if}}
      </article>

      <div class="flex justify-end pt-6 mt-12 border-t border-slate-200 dark:border-slate-800">
        <ExternalLink
          class="edit-page flex text-sm font-semibold dark:text-sky-400 no-underline shadow-[inset_0_-2px_0_0_var(--tw-prose-background,#fff),inset_0_calc(-1*(var(--tw-prose-underline-size,4px)+2px))_0_0_var(--tw-prose-underline,theme(colors.sky.300))] hover:[--tw-prose-underline-size:6px] dark:[--tw-prose-background:theme(colors.slate.900)] dark:shadow-[inset_0_calc(-1*var(--tw-prose-underline-size,2px))_0_0_var(--tw-prose-underline,theme(colors.sky.800))] dark:hover:[--tw-prose-underline-size:6px]"
          href="https://github.com/universal-ember/ember-primitives/edit/main/docs-app/public/docs{{docs.selected.path}}.md"
        >
          Edit this page
        </ExternalLink>
      </div>
    </section>
  {{/let}}
</template>;
