import "./visually-hidden.css";

import type { TOC } from "@ember/component/template-only";

export const VisuallyHidden: TOC<{
  Element: HTMLSpanElement;
  Blocks: {
    /**
     * Content to hide visually
     */
    default: [];
  };
}> = <template>
  <span class="ember-primitives__visually-hidden" ...attributes>{{yield}}</span>
</template>;
