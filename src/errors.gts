import { PageError } from './page-layout.gts';

import type { TOC } from '@ember/component/template-only';

export const OopsError: TOC<{
  Args: { error: any };
  Blocks: { default: [] };
}> = <template>
  <div
    data-page-error
    class="adaptive-text"
    style="border: 1px solid red; padding: 1rem; word-break: break-all;"
  >
    <h1>Oops!</h1><br />
    <PageError @error={{@error}} />

    <br />
    <br />
    {{yield}}
  </div>

  <style scoped>
    .adaptive-text {
      color: #0f172a;
    }
    :is(html[style*="color-scheme: dark"]) .adaptive-text {
      color: white;
    }
  </style>
</template>;
