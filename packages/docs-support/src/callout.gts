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
      padding: 1.5rem;
      margin-top: 2rem;
      margin-bottom: 2rem;
      border-radius: 1.5rem;
      background-color: #f0f9ff;
    }

    :is(html[style*="color-scheme: dark"]) .callout {
      background-color: rgb(30 41 59 / 0.6);
      outline: 1px solid rgb(203 213 225 / 0.1);
    }

    .callout__icon {
      flex: none;
      width: 2rem;
      height: 2rem;
    }

    .callout__body {
      flex: 1 1 auto;
      min-width: 0;
      margin-left: 1rem;
    }

    .callout__content {
      color: #075985;
    }

    .callout__content > *:first-child {
      margin-top: 0;
    }

    .callout__content > *:last-child {
      margin-bottom: 0;
    }

    :is(html[style*="color-scheme: dark"]) .callout__content {
      color: #f8fafc;
    }
  </style>
</template>;
