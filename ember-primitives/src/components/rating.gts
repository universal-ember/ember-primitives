import Component from "@glimmer/component";
import { cached } from "@glimmer/tracking";
import { assert } from "@ember/debug";
import { hash } from "@ember/helper";
import { on } from "@ember/modifier";

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-expect-error
import { localCopy } from "tracked-toolbox";

import { uniqueId } from "../utils.ts";

import type { ComponentLike } from "@glint/template";

type ComponentIcons = {
  /**
   * It's possible to completely manage the state of an individual Icon yourself
   * by passing a component that has ...attributes on its outer element and receives
   * a @isSelected argument which is true for selected and false for unselected.
   *
   * There is also argument passed which is the percent-amount of selection if you want fractional ratings, @selectedPercent
   */
  icon: ComponentLike<{
    Element: HTMLElement;
    Args: { isDisabled: boolean; selectedPercent: number; value: number; readonly: boolean };
  }>;
};

interface StringIcons {
  /**
   * The symbol to use for an unselected variant of the icon
   *
   * Defaults to "★";
   *  Can change color when selected.
   */
  icon?: string;
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
     * Callback when the selected rating changes.
     * Can include half-ratings if the iconHalf argument is passed.
     */
    onChange?: (value: number) => void;
  };
  Blocks: {
    default: [
      internalApi: {
        stars: number[];
        value: number;
        total: number;
        handleInput: (event: Event) => void;
      },
      publicApi: {
        value: number;
        total: number;
      },
    ];
  };
}

function lte(a: number, b: number) {
  return a <= b;
}

function percentSelected(a: number, b: number) {
  const diff = b + 1 - a;

  if (diff < 0) return 0;
  if (diff > 1) return 100;
  if (a === b) return 100;

  const percent = diff * 100;

  return percent;
}

function isString(x: unknown) {
  return typeof x === "string";
}

export class RatingState extends Component<StateSignature> {
  // eslint-disable-next-line @typescript-eslint/no-unsafe-call
  @localCopy("args.value") declare _value: number;

  get value() {
    return this._value ?? 0;
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

  setFromString = (value: unknown) => {
    assert("[BUG]: value from input must be a string.", typeof value === "string");

    const num = parseFloat(value);

    if (isNaN(num)) {
      // something went wrong.
      // Since we're using event delegation,
      // this could be from an unrelated input
      return;
    }

    this.setRating(num);
  };

  /**
   * Click events are captured by
   * - radio changes (mouse and keyboard)
   *   - but only range clicks
   */
  handleClick = (event: Event) => {
    // Since we're doing event delegation on a click, we want to make sure
    // we don't do anything on other elements
    const isValid =
      event.target !== null &&
      "value" in event.target &&
      event.target.name === this.args.name &&
      event.target.type === "radio";

    if (!isValid) return;

    const selected = event.target?.value;

    this.setFromString(selected);
  };

  /**
   * Only attached to a range element, if present.
   * Range elements don't fire click events on keyboard usage, like radios do
   */
  handleChange = (event: Event) => {
    const isValid = event.target !== null && "value" in event.target;

    if (!isValid) return;

    this.setFromString(event.target.value);
  };

  <template>
    {{yield
      (hash
        stars=this.stars
        total=this.stars.length
        handleClick=this.handleClick
        handleChange=this.handleChange
        setRating=this.setRating
        value=this.value
      )
      (hash total=this.stars.length value=this.value)
    }}
  </template>
}

export const Stars: TOC<{
  Args: {
    // Configuration
    stars: number[];
    icon: string | ComponentLike;
    isReadonly: boolean;
    isChangeable: boolean;

    // HTML Boilerplate
    name: string;

    // State
    currentValue: number;
    total: number;
  };
}> = <template>
  <div class="ember-primitives__rating__items">
    {{#each @stars as |star|}}
      {{#let (uniqueId) as |id|}}
        <span
          class="ember-primitives__rating__item"
          data-number={{star}}
          data-percent-selected={{percentSelected star @currentValue}}
          data-selected={{lte star @currentValue}}
          data-readonly={{@isReadonly}}
        >
          <label for="input-{{id}}">
            <span visually-hidden>{{star}} star</span>
            <span aria-hidden="true">
              {{#if (isString @icon)}}
                {{@icon}}
              {{else}}
                <@icon
                  @value={{star}}
                  @isSelected={{lte star @currentValue}}
                  @percentSelected={{percentSelected star @currentValue}}
                  @readonly={{@isReadonly}}
                />
              {{/if}}
            </span>
          </label>

          <input
            id="input-{{id}}"
            type="radio"
            name={{@name}}
            value={{star}}
            readonly={{@isReadonly}}
            checked={{lte star @currentValue}}
          />
        </span>
      {{/let}}
    {{/each}}
  </div>
</template>;

const RatingRange = <template>
  <input
    ...attributes
    name={{@name}}
    type="range"
    max={{@max}}
    value={{@value}}
    {{on "change" @handleChange}}
  />
</template>;

export interface Signature {
  Element: HTMLElement;
  Args: (ComponentIcons | StringIcons) & {
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
     * Toggles the ability to interact with the rating component.
     * When `true` (the default), the Rating component can be as a form input
     * to gather user feedback.
     *
     * When false, only the `@value` will be shown, and it cannot be changed.
     */
    interactive?: boolean;

    /**
     * Callback when the selected rating changes.
     * Can include half-ratings if the iconHalf argument is passed.
     */
    onChange?: (value: number) => void;
  };

  Blocks: {
    label: [
      state: {
        /**
         * The current rating
         */
        value: number;

        /**
         * The maximum rating
         */
        total: number;
      },
    ];
  };
}

export class Rating extends Component<Signature> {
  name = `rating-${uniqueId()}`;

  get icon() {
    return this.args.icon ?? "★";
  }

  get isInteractive() {
    return this.args.interactive ?? true;
  }

  get isChangeable() {
    const readonly = this.args.readonly ?? false;

    return !readonly && this.isInteractive;
  }

  get isReadonly() {
    return !this.isChangeable;
  }

  get needsDescription() {
    return !this.isInteractive;
  }

  <template>
    <RatingState
      @max={{@max}}
      @value={{@value}}
      @name={{this.name}}
      @readonly={{this.isReadonly}}
      @onChange={{@onChange}}
      as |r publicState|
    >
      <fieldset
        class="ember-primitives__rating"
        data-total={{r.total}}
        data-value={{r.value}}
        data-readonly={{this.isReadonly}}
        {{! We use event delegation, this isn't a primary interactive -- we're capturing events from inputs }}
        {{! template-lint-disable no-invalid-interactive }}
        {{on "click" r.handleClick}}
        ...attributes
      >
        {{#let
          (component
            Stars
            stars=r.stars
            icon=this.icon
            isReadonly=this.isReadonly
            name=this.name
            total=r.total
            set=r.setRating
            currentValue=r.value
          )
          as |RatingStars|
        }}

          {{#if (has-block)}}
            {{yield
              (hash
                max=r.total
                total=r.total
                value=r.value
                name=this.name
                isReadonly=this.isReadonly
                isChangeable=this.isChangeable
                Stars=RatingStars
                Range=(component
                  RatingRange max=r.total value=r.value name=this.name handleChange=r.handleChange
                )
              )
            }}
          {{else}}
            {{#if this.needsDescription}}
              {{#if (has-block "label")}}
                {{yield publicState to="label"}}
              {{else}}
                <span visually-hidden class="ember-primitives__rating__label">Rated
                  {{r.value}}
                  out of
                  {{r.total}}</span>
              {{/if}}
            {{else}}
              {{#if (has-block "label")}}
                <legend>
                  {{yield publicState to="label"}}
                </legend>
              {{/if}}
            {{/if}}

            <RatingStars />
          {{/if}}
        {{/let}}

      </fieldset>
    </RatingState>
  </template>
}
