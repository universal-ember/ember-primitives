import { PageError } from './page-layout.gts';

import type { TOC } from '@ember/component/template-only';

export const OopsError: TOC<{
  Args: { error: any };
  Blocks: { default: [] };
}> = <template>
  <div data-page-error class="oops-error" role="alert">
    <h1 class="oops-error__title">Oops!</h1>
    <PageError @error={{@error}} />
    <div class="oops-error__actions">
      {{yield}}
    </div>
  </div>

  <style scoped>
    .oops-error {
      color: var(--doc-text-1);
      max-width: 40rem;
      margin: 2rem 0;
      padding: 1.25rem 1.35rem;
      border: 1px solid color-mix(in srgb, var(--doc-danger) 35%, var(--doc-border));
      border-radius: var(--doc-radius-sm);
      background: color-mix(in srgb, var(--doc-danger) 8%, var(--doc-bg));
      word-break: break-word;
    }

    .oops-error__title {
      margin: 0 0 0.75rem;
      font-size: 1.25rem;
      font-weight: 600;
      letter-spacing: -0.02em;
    }

    .oops-error__actions {
      margin-top: 1.25rem;
    }
  </style>
</template>;
