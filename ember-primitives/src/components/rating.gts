import Component from "@glimmer/component";
import { cached, tracked } from "@glimmer/tracking";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";

import type { ComponentLike } from "@glint/template";

interface Signature {
  Args: {
    /**
     * The symbol to use for an unselected variant of the icon
     *
     * Defaults to "☆";
     */
    icon: string | ComponentLike;
    /**
     * The symbol to use for the half-selected variant of the icon
     *
     * Defaults to undefined, disallowing non-integer ratings.
     */
    iconHalf?: ComponentLike;
    /**
     * The symbol to use for an selected variant of the icon
     *
     * Defaults to "★";
     */
    iconSelected: string | ComponentLike;

    /**
     * How to describe each icon
     */
    iconAriaLabel?: string | undefined;

    /**
     * Color of unselected icons.
     */
    color?: string;
    /**
     * Color of the half-icons.
     *
     * Default's to the @selectedColor
     */
    colorHalf?: string;
    /**
     * Color of selected icons.
     */
    colorSelected?: string;

    /**
     * The number of stars/whichever-icon to show
     *
     * Defaults to 5
     */
    max?: number;
    /**
     * The current number of stars/whichever-icon to show as selected
     *
     * Defaults to 0
     */
    value?: number;
    /**
     * Prevents click events on the icons and sets aria-readonly.
     *
     * Also sets data-readonly=true on the wrapping element
     */
    readonly?: boolean;
    /**
     * Prevents click events on the icons and sets aria-disabled
     *
     * Also sets data-disabled=true on the wrapping element
     */
    disable?: boolean;
    /**
     * Callback when the selected rating changes.
     * Can include half-ratings if the iconHalf argument is passed.
     */
    onChange?: (value: number) => void;
  };
}
export class Rating extends Component<Signature> {
  @tracked rating = this.args.value ?? 0;
  icon = this.args.icon ?? "★";
  iconEmpty = this.args.iconEmpty ?? "☆";
  iconColor = this.args.iconColor ?? "gold";

  @cached
  get stars() {
    return Array.from({ length: this.args.max ?? 5 }, (_, index) => index + 1);
  }

  setRating = (value: number) => {
    if (this.args.readonly) {
      return;
    }

    this.rating = value;

    this.args.onChange?.(value);
  };

  <template>
    <div class="rating-component">
      {{#each this.stars as |star|}}
        <span
          class="rating-icon"
          style="cursor: {{if @readonly 'default' 'pointer'}}; font-size: {{@size}}; color: {{if
            (lte star this.rating)
            this.iconColor
            'lightgray'
          }};"
          {{on "click" (fn this.setRating star)}}
        >
          {{if (lte star this.rating) this.icon this.iconEmpty}}
        </span>
      {{/each}}
    </div>
  </template>
}
