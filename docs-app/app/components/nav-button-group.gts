import { Link } from 'ember-primitives';
import { selected } from 'kolay';

import type { TOC } from '@ember/component/template-only';

function isActiveSection(path: string, sectionPattern: string): boolean {
  return path.includes(sectionPattern);
}

export const NavButtonGroup: TOC = <template>
  {{#let (selected this) as |sel|}}
    <div
      class="hidden md:flex gap-1 items-center justify-center absolute left-1/2 transform -translate-x-1/2"
      role="group"
      aria-label="Section navigation"
    >
      <Link
        href="/1-get-started/index.md"
        class="px-4 py-2 text-sm font-medium transition-colors rounded-md text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800
          {{if (isActiveSection sel.path '1-get-started') 'bg-slate-100 dark:bg-slate-800' 'bg-transparent'}}"
      >
        Primitives
      </Link>
      <Link
        href="/7-animations/index.md"
        class="px-4 py-2 text-sm font-medium transition-colors rounded-md text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800
          {{if (isActiveSection sel.path '7-animations') 'bg-slate-100 dark:bg-slate-800' 'bg-transparent'}}"
      >
        Animations
      </Link>
      <Link
        href="/9-blocks/index.md"
        class="px-4 py-2 text-sm font-medium transition-colors rounded-md text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800
          {{if (isActiveSection sel.path '9-blocks') 'bg-slate-100 dark:bg-slate-800' 'bg-transparent'}}"
      >
        Blocks
      </Link>
    </div>
  {{/let}}
</template>;
