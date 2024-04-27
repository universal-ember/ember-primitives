import { LightBulb } from './icons';

import type { TOC } from '@ember/component/template-only';

export const Callout: TOC<{ Blocks: { default: [] } }> = <template>
  <div
    class="flex p-6 my-8 rounded-3xl bg-sky-50 dark:bg-slate-800/60 dark:ring-1 dark:ring-slate-300/10"
  >
    <LightBulb class="flex-none w-8 h-8" />
    <div class="flex-auto min-w-0 ml-4">
      <div
        class="text-sky-800 [--tw-prose-background:theme(colors.sky.50)] prose-a:text-sky-900 dark:text-slate-50 [&>*:first-child]:mt-0 [&>*:last-child]:mb-0"
      >
        {{yield}}
      </div>
    </div>
  </div>
</template>;

export default Callout;
