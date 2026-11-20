import "./hero.css";

import type { TOC } from "@ember/component/template-only";

export const Hero: TOC<{
  /**
   * The wrapper element of the whole layout.
   */
  Element: HTMLDivElement;
  Blocks: {
    default: [];
  };
}> = <template>
  <div class="ember-primitives__hero__wrapper" ...attributes>
    {{yield}}
  </div>
</template>;
