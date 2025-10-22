/**
 * References:
 * - https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles/tablist_role
 * - https://www.w3.org/WAI/ARIA/apg/patterns/tabs/
 *
 *
 * Keyboard behaviors (optionally) provided by tabster
 */

import type { TOC } from "@ember/component/template-only";

export const Tabs: TOC<{
  Element: HTMLDivElement;
  Args: {
    /**
     *
     */
    value?: string;
    /**
     *
     */
    onChange: (selectedTab: string, previousTab: string) => void;
  };
  Blocks: { default: [] };
}> = <template>
  <div ...attributes>

  </div>
</template>;
