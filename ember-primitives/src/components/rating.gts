import Component from "@glimmer/component";
import { cached } from "@glimmer/tracking";
import { fn, hash } from "@ember/helper";
import { on } from "@ember/modifier";

import { element } from "ember-element-helper";
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-expect-error
import { localCopy } from "tracked-toolbox";

import { uniqueId } from "../utils.ts";
import { Label } from "./-private/typed-elements.gts";

import type { TOC } from "@ember/component/template-only";
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
      item: {
        onClick: () => void;
        number: number;
        percentSelected: number;
        isSelected: boolean;
      },
    ];
    legend: [];
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

function shouldClick(isReadonly: boolean, isDisabled: boolean) {
  return !isReadonly && !isDisabled;
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

  handleInput = (event: Event) => {
    let selected = event.target?.value;
    let num = parseFloat(selected);

    this.setRating(num);
  };

  <template>
    <fieldset
      class="ember-primitives__rating"
      data-total={{this.stars.length}}
      data-value={{this.value}}
      {{on "input" this.handleInput}}
      ...attributes
    >
      {{yield
        (hash stars=this.stars total=this.stars.length onClick=this.setRating value=this.value)
      }}
    </fieldset>
  </template>
}

export interface Signature {
  Element: HTMLDivElement;
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
}

export class Rating extends Component<Signature> {
  get icon() {
    return this.args.icon ?? "★";
  }

  get isInteractive() {
    return this.args.interactive ?? true;
  }

  get isChangeable() {
    return this.args.readonly || !this.isInteractive;
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
      @readonly={{this.isChangeable}}
      @onChange={{@onChange}}
      ...attributes
      as |r|
    >
      {{#if (has-block "legend")}}
        <legend>
          {{yield to="legend"}}
        </legend>
      {{/if}}

      {{#unless @interactive}}
        <span visually-hidden class="ember-primitives__rating__label">Rated
          {{r.value}}
          out of
          {{r.total}}</span>
      {{/unless}}

      <div class="ember-primitives__rating__items">
        {{#let (uniqueId) as |name|}}
          {{#each r.stars as |star|}}
            {{#let (uniqueId) as |id|}}
              <span
                class="ember-primitives__rating__item"
                data-number={{star}}
                data-percent-selected={{percentSelected star r.value}}
                data-selected={{lte star r.value}}
                data-readonly={{Boolean @readonly}}
              >
                <Label @for="input-{{id}}">
                  <span visually-hidden>{{star}} star</span>
                  <span aria-hidden="true">
                    {{#if (isString this.icon)}}
                      {{log "string" this.icon}}
                      {{this.icon}}
                    {{else}}
                      <this.icon
                        @value={{star}}
                        @isSelected={{lte star r.value}}
                        @percentSelected={{percentSelected star r.value}}
                        @readonly={{Boolean @readonly}}
                        ...attributes
                      />
                    {{/if}}

                  </span>
                </Label>

                <input
                  id="input-{{id}}"
                  type="radio"
                  name="rating-{{name}}"
                  value={{star}}
                  readonly={{Boolean @readonly}}
                  aria-label="{{star}} of {{@total}} stars"
                  {{on "click" toggleableRadio}}
                  ...attributes
                />
              </span>
            {{/let}}
          {{/each}}
        {{/let}}
      </div>
    </RatingState>
  </template>
}

function toggleableRadio(event: Event) {
  if (event.target.checked) {
    event.target.checked = false;
  }
}
