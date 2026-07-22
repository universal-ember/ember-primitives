import { LightBulb } from './icons.gts';

import type { TOC } from '@ember/component/template-only';

export const Callout: TOC<{ Blocks: { default: [] } }> = <template>
  <div class="callout">
    <LightBulb class="callout__icon" />
    <div class="callout__body">
      <div class="callout__content">
        {{yield}}
      </div>
    </div>
  </div>

  <style scoped>
    .callout {
      display: flex;
      padding: 1rem 1.25rem;
      margin-top: 2rem;
      margin-bottom: 2rem;
      border-radius: var(--doc-radius-sm);
      background-color: var(--doc-brand-soft);
      border: 1px solid color-mix(in srgb, var(--doc-brand-1) 35%, transparent);
    }

    .callout__icon {
      flex: none;
      width: 1.75rem;
      height: 1.75rem;
    }

    .callout__body {
      flex: 1 1 auto;
      min-width: 0;
      margin-left: 0.875rem;
    }

    .callout__content {
      color: var(--doc-text-1);
      font-size: 0.9375rem;
    }

    .callout__content > *:first-child {
      margin-top: 0;
    }

    .callout__content > *:last-child {
      margin-bottom: 0;
    }
  </style>
</template>;
