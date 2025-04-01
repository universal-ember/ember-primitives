import Component from "@glimmer/component";
import { cached } from "@glimmer/tracking";
import { assert } from "@ember/debug";
import { hash } from "@ember/helper";
import { on } from "@ember/modifier";

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-expect-error
import { localCopy } from "tracked-toolbox";

import { uniqueId } from "../utils.ts";
import { Label } from "./-private/typed-elements.gts";

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
    console.log("eh", value);
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

  handleInput = (event: Event) => {
    assert(
      "[BUG]: must be on an element that has input events",
      event.target !== null && "value" in event.target,
    );

    const selected = event.target?.value;

    assert("[BUG]: value from input must be a string.", typeof selected === "string");

    const num = parseFloat(selected);

    if (isNaN(num)) {
      // something went wrong.
      // Since we're using event delegation,
      // this could be from an unrelated input
      return;
    }

    this.setRating(num);
  };

  <template>
    {{yield
      (hash
        stars=this.stars
        total=this.stars.length
        handleInput=this.handleInput
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
          <Label @for="input-{{id}}" tabindex="{{if @isReadonly '-1' '0'}}">
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
          </Label>

          <input
            id="input-{{id}}"
            type="radio"
            name={{@name}}
            value={{star}}
            readonly={{@isReadonly}}
            checked={{lte star @currentValue}}
            aria-label="{{star}} of {{@total}} stars"
          />
        </span>
      {{/let}}
    {{/each}}
  </div>
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
    let readonly = this.args.readonly ?? false;

    return !readonly && this.isInteractive;
  }

  get isReadonly() {
    return !this.isChangeable;
  }

  get needsDescription() {
    return !this.isInteractive;
  }

  /**
   * TODO: when in read-only mode, we may want to use `inert`
   *       to disable interactivity on the fieldset
   *
   */
  <template>
    <RatingState
      @max={{@max}}
      @value={{@value}}
      @readonly={{this.isReadonly}}
      @onChange={{@onChange}}
      as |r publicState|
    >
      <fieldset
        class="ember-primitives__rating"
        data-total={{r.total}}
        data-value={{r.value}}
        data-readonly={{this.isReadonly}}
        {{on "click" r.handleInput}}
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
            handleInput=r.handleInput
            currentValue=r.value
          )
          as |RatingStars|
        }}

          {{#if (has-block "default")}}
            {{yield
              (hash
                max=r.total
                total=r.total
                value=r.value
                name=this.name
                isReadonly=this.isReadonly
                isChangeable=this.isChangeable
                Stars=RatingStars
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
