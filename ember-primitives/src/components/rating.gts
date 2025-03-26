import "./rating.css";

import Component from "@glimmer/component";
import { cached } from "@glimmer/tracking";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-expect-error
import { localCopy } from "tracked-toolbox";

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
  icon?: string;

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
  Args: /* ComponentIcons | */ StringIcons & {
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

function lte(a: number, b: number) {
  return a <= b;
}

function percentSelected(a: number, b: number) {
  const diff = b - a;

  if (diff < 0) return 0;
  if (diff > 1) return 100;

  const percent = diff * 100;

  return percent;
}

function isString(x: unknown) {
  return typeof x === "string";
}

export class Rating extends Component<Signature> {
  // eslint-disable-next-line @typescript-eslint/no-unsafe-call
  @localCopy("args.value") declare _value: number;

  get value() {
    return this._value ?? 0;
  }

  get icon() {
    return this.args.icon ?? "☆";
  }

  get iconSelected() {
    return this.args.iconSelected ?? "★";
  }

  @cached
  get stars() {
    return Array.from({ length: this.args.max ?? 5 }, (_, index) => index + 1);
  }

  setRating = (value: number) => {
    if (this.args.readonly) {
      return;
    }

    if (value === this._value) {
      this._value = 0;
    } else {
      this._value = value;
    }

    this.args.onChange?.(value);
  };

  <template>
    <div class="ember-primitives__rating">
      {{#each this.stars as |star|}}
        <span
          class="ember-primitives__rating__icon"
          data-number={{star}}
          data-percent-selected={{percentSelected star this.value}}
          data-selected={{lte star this.value}}
          data-readonly={{@readonly}}
          {{! @glint-expect-error }}
          {{(unless @readonly (modifier on "click" (fn this.setRating star)))}}
        >
          {{#if (isString this.icon)}}
            {{if (lte star this.value) this.iconSelected this.icon}}
          {{/if}}
        </span>
      {{/each}}
    </div>
  </template>
}
