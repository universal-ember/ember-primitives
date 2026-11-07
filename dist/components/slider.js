import "./slider.css"
import Component from '@glimmer/component';
import { hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { SliderStore } from './slider/store.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

;

const Track = setComponentTemplate(precompileTemplate("<span ...attributes class=\"ember-primitives__slider__track\">\n  {{yield}}\n</span>", {
  strictMode: true
}), templateOnly());
const Range = setComponentTemplate(precompileTemplate("<span ...attributes class=\"ember-primitives__slider__range\" style={{@rangeStyle}} />", {
  strictMode: true
}), templateOnly());
class ThumbComponent extends Component {
  get index() {
    return this.args.thumb?.index ?? this.args.index ?? 0;
  }
  get value() {
    // When using tick values, the `input` needs the internal index.
    return this.args.thumb?.inputValue ?? this.args.value ?? this.args.store.internalMin;
  }
  /** With tick values the input holds an index, which means nothing when read aloud. */
  get valueText() {
    const tick = this.args.store.tickValues?.[this.value];
    return tick === undefined ? undefined : String(tick);
  }
  get isActive() {
    return this.args.store.activeThumbIndex === this.index;
  }
  get positionStyle() {
    const percent = this.args.thumb?.percent ?? this.args.store.thumbPercents[this.index] ?? 0;
    return this.args.store.thumbPositionStyle(percent);
  }
  readValue(event) {
    // In docs live previews the component may run in an iframe/shadow realm,
    // where `instanceof HTMLInputElement` is not reliable. `currentTarget` is
    // the element the handler is attached to.
    const el = event.currentTarget;
    const raw = el?.value;
    const parsed = raw === undefined ? NaN : Number.parseFloat(raw);
    return Number.isFinite(parsed) ? parsed : this.value;
  }
  onInput = event => {
    this.args.store.handleThumbActivate(this.index);
    this.args.store.handleThumbInput(this.index, this.readValue(event));
  };
  onChange = event => {
    this.args.store.handleThumbActivate(this.index);
    this.args.store.handleThumbChange(this.index, this.readValue(event));
  };
  onPointerUp = () => {
    this.args.store.handleThumbActivate(this.index);
  };
  onGotPointerCapture = () => {
    this.args.store.handleThumbActivate(this.index);
  };
  onFocus = () => {
    this.args.store.handleThumbActivate(this.index);
  };
  static {
    setComponentTemplate(precompileTemplate("<input aria-valuetext={{this.valueText}} ...attributes class=\"ember-primitives__slider__thumb-input\" type=\"range\" min={{@store.internalMin}} max={{@store.internalMax}} step={{@store.internalStep}} value={{this.value}} disabled={{@store.disabled}} data-active={{if this.isActive \"\"}} {{on \"gotpointercapture\" this.onGotPointerCapture}} {{on \"pointerup\" this.onPointerUp}} {{on \"focus\" this.onFocus}} {{on \"input\" this.onInput}} {{on \"change\" this.onChange}} />\n<span class=\"ember-primitives__slider__thumb\" style={{this.positionStyle}} data-active={{if this.isActive \"\"}} data-disabled={{if @store.disabled \"\"}} aria-hidden=\"true\">{{yield}}</span>", {
      strictMode: true,
      scope: () => ({
        on
      })
    }), this);
  }
}
class Slider extends Component {
  store;
  constructor(owner, args) {
    super(owner, args);
    this.store = new SliderStore(() => this.args);
  }
  static {
    setComponentTemplate(precompileTemplate("<span ...attributes class=\"ember-primitives__slider\" data-orientation={{this.store.orientation}} data-disabled={{if this.store.disabled \"\"}} data-multi={{if this.store.isMulti \"\"}}>\n  {{#if (has-block)}}\n    {{yield (hash Track=Track Range=(component Range rangeStyle=this.store.rangeStyle) Thumb=(component ThumbComponent store=this.store) values=this.store.values tickValues=this.store.tickValues thumbs=this.store.thumbs min=this.store.min max=this.store.max step=this.store.step)}}\n  {{else}}\n    <Track>\n      <Range @rangeStyle={{this.store.rangeStyle}} />\n\n      {{#each this.store.thumbs as |thumb|}}\n        <ThumbComponent @store={{this.store}} @thumb={{thumb}} aria-label={{this.store.defaultThumbLabel thumb.index}} />\n      {{/each}}\n    </Track>\n  {{/if}}\n</span>", {
      strictMode: true,
      scope: () => ({
        hash,
        Track,
        Range,
        ThumbComponent
      })
    }), this);
  }
}

export { Slider, Slider as default };
//# sourceMappingURL=slider.js.map
