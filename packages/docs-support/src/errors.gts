import { PageError } from './page-layout.gts';

import type { TOC } from '@ember/component/template-only';

export const OopsError: TOC<{
  Args: { error: any };
  Blocks: { default: [] };
}> = <template>
  <div
    data-page-error
    class="dark:text-white text:slate-900"
    style="border: 1px solid red; padding: 1rem; word-break: break-all;"
  >
    <h1>Oops!</h1><br />
    <PageError @error={{@error}} />

    <br />
    <br />
    {{yield}}
  </div>
</template>;
