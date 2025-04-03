import { on } from "@ember/modifier";

import type { TOC } from "@ember/component/template-only";

export const RatingRange: TOC<{
  Element: HTMLInputElement;
  Args: {
    name: string;
    max: number;
    value: number;
    handleChange: (event: Event) => void;
  };
}> = <template>
  <input
    ...attributes
    name={{@name}}
    type="range"
    max={{@max}}
    value={{@value}}
    {{on "change" @handleChange}}
  />
</template>;
