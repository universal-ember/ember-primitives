import Component from "@glimmer/component";
import { cached, tracked } from "@glimmer/tracking";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";

import type { ComponentLike } from "@glint/template";

type ComponentIcons =
  | {
      /**
       * It's possible to completely manage the state of an individual Icon yourself
       * by passing a component that has ...attributes on its outer element and receives
       * a @selected argument which represents the selected state. 0 for unselected, 1 for selected.
       */
      icon: ComponentLike<{ Element: HTMLElement; Args: { selected: number } }>;
    }
  | {
      /**
       * The component to use for unselected icons
       */
      icon: ComponentLike;

      /**
       * The component to use for selected icons
       */
      iconSelected: ComponentLike;

      /**
       * The component to use for half-selected icons
       */
      iconHalf?: ComponentLike;
    };

interface StringIcons {
  /**
   * The symbol to use for an unselected variant of the icon
   *
   * Defaults to "☆";
   */
  icon: string;

  /**
   * The symbol to use for the half-selected variant of the icon
   *
   * Defaults to undefined, disallowing non-integer ratings.
   */
  iconHalf?: string;

  /**
   * The symbol to use for an selected variant of the icon
   *
   * Defaults to "★";
   */
  iconSelected: string;

  /**
   * Color of unselected icons.
   *
   * Default to
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
}

interface Signature {
  Args: (ComponentIcons | StringIcons) & {
    /**
     * How to describe each icon
     */
    iconAriaLabel?: string | undefined;

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
