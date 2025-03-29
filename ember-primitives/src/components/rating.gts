import Component from "@glimmer/component";
import { cached } from "@glimmer/tracking";
import { fn, hash } from "@ember/helper";
import { on } from "@ember/modifier";

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-expect-error
import { localCopy } from "tracked-toolbox";

import { uniqueId } from "../utils.ts";
import { Label } from "./-private/typed-elements.gts";

import type { TOC } from "@ember/component/template-only";
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
  iconSelected?: string;
}

export interface StateSignature {
  Args: {
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
    disabled?: boolean;

    /**
     * Callback when the selected rating changes.
     * Can include half-ratings if the iconHalf argument is passed.
     */
    onChange?: (value: number) => void;
  };
  Blocks: {
    default: [
      item: {
        onClick: () => void;
        number: number;
        percentSelected: number;
        isSelected: boolean;
      },
    ];
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

const Item: TOC<{
  Args: StringIcons & {
    value: number;
    total: number;
    percentSelected: number;
    onClick: () => void;
    isSelected: boolean;
    readonly: boolean | undefined;
  };
}> = <template>
  <button
    class="ember-primitives__rating__icon"
    aria-label="{{@value}} of {{@total}} stars"
    data-number={{@value}}
    data-percent-selected={{@percentSelected}}
    data-selected={{@isSelected}}
    data-readonly={{@readonly}}
    {{! @glint-expect-error }}
    {{(unless @readonly (modifier on "click" @onClick))}}
  >
    {{#if (isString @icon)}}
      {{if @isSelected @iconSelected @icon}}
    {{/if}}
  </button>
</template>;

export class RatingState extends Component<StateSignature> {
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
    <div
      class="ember-primitives__rating"
      data-total={{this.stars.length}}
      data-value={{this.value}}
    >
      {{#each this.stars as |star|}}
        {{yield
          (hash
            onClick=(fn this.setRating star)
            number=star
            percentSelected=(percentSelected star this.value)
            isSelected=(lte star this.value)
          )
        }}
      {{/each}}
    </div>
  </template>
}

export interface Signature {
  Args: /* ComponentIcons | */ StringIcons & {
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
    disabled?: boolean;

    /**
     * Callback when the selected rating changes.
     * Can include half-ratings if the iconHalf argument is passed.
     */
    onChange?: (value: number) => void;
  };
}

export const Rating: TOC<Signature> = <template>
  <RatingState
    @max={{@max}}
    @value={{@value}}
    @readonly={{@readonly}}
    @disabled={{@disabled}}
    @onChange={{@onChange}}
    as |r|
  >
    <span visually-hidden>Rated {{r.value}} out of {{r.total}}</span>

    {{#each r.stars as |star|}}
      <span>{{star}}</span>
    {{/each}}
  </RatingState>
</template>;

export interface ControlSignature {
  Element: HTMLDivElement;
  Args: {
    max?: number;
    value?: number;
    readonly?: boolean;
    disabled?: boolean;
  };
  Blocks: {
    default: [
      star: {
        Label: ComponentLike<{}>;
        Button: ComponentLike<{}>;
        number: number;
        isSelected: boolean;
        percentSelected: boolean;
      },
    ];
  };
}

export const RatingControl: TOC<ControlSignature> = <template>
  <div ...attributes>
    <RatingState
      @max={{@max}}
      @value={{@value}}
      @readonly={{@readonly}}
      @disabled={{@disabled}}
      as |r|
    >
      {{#let (uniqueId) as |id|}}
        {{yield
          (hash
            Button=(component r.Button id=id)
            Label=(component Label for=id)
            number=r.number
            isSelected=r.isSelected
            percentSelected=r.percentSelected
          )
        }}
      {{/let}}
    </RatingState>
  </div>
</template>;
