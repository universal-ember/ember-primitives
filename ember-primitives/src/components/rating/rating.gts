import Component from "@glimmer/component";
import { hash } from "@ember/helper";
import { on } from "@ember/modifier";

import { uniqueId } from "../../utils.ts";
import { RatingRange } from "./range.gts";
import { Stars } from "./stars.gts";
import { RatingState } from "./state.gts";

import type { ComponentIcons, StringIcons } from "./public-types.ts";
import type { WithBoundArgs } from "@glint/template";

export interface Signature {
  /*
   * The element all passed attributes / modifiers are applied to.
   *
   * This is a `<fieldset>`, becaues the rating elements are
   * powered by a group of radio buttons.
   */
  Element: HTMLFieldSetElement;
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
     * When generating the radio inputs, this changes what value of rating each radio
     * input will be incremented by.
     *
     * e.g.: Set to 0.5 for half-star ratings.
     *
     * Defaults to 1
     */
    step?: number;

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
    default: [
      rating: {
        /**
         * The maximum rating
         */
        max: number;
        /**
         * The maxium rating
         */
        total: number;
        /**
         * The current rating
         */
        value: number;
        /**
         * The name shared by the field group
         */
        name: string;
        /**
         * If the rating can be changed
         */
        isReadonly: boolean;
        /**
         * If the rating can be changed
         */
        isChangeable: boolean;
        /**
         * The stars / items radio group
         */
        Stars: WithBoundArgs<
          typeof Stars,
          "stars" | "icon" | "isReadonly" | "name" | "total" | "currentValue"
        >;
        /**
         * Input range for adjusting the rating via fractional means
         */
        Range: WithBoundArgs<typeof RatingRange, "max" | "value" | "name" | "handleChange">;
      },
    ];
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
      @step={{@step}}
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
