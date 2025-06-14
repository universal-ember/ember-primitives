import Component from '@glimmer/component';
import { hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { uniqueId } from '../../utils.js';
import { RatingRange } from './range.js';
import { Stars } from './stars.js';
import { RatingState } from './state.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';

class Rating extends Component {
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
  static {
    setComponentTemplate(precompileTemplate("\n    <RatingState @max={{@max}} @value={{@value}} @name={{this.name}} @readonly={{this.isReadonly}} @onChange={{@onChange}} as |r publicState|>\n      <fieldset class=\"ember-primitives__rating\" data-total={{r.total}} data-value={{r.value}} data-readonly={{this.isReadonly}} {{!-- We use event delegation, this isn't a primary interactive -- we're capturing events from inputs --}} {{!-- template-lint-disable no-invalid-interactive --}} {{on \"click\" r.handleClick}} ...attributes>\n        {{#let (component Stars stars=r.stars icon=this.icon isReadonly=this.isReadonly name=this.name total=r.total currentValue=r.value) as |RatingStars|}}\n\n          {{#if (has-block)}}\n            {{yield (hash max=r.total total=r.total value=r.value name=this.name isReadonly=this.isReadonly isChangeable=this.isChangeable Stars=RatingStars Range=(component RatingRange max=r.total value=r.value name=this.name handleChange=r.handleChange))}}\n          {{else}}\n            {{#if this.needsDescription}}\n              {{#if (has-block \"label\")}}\n                {{yield publicState to=\"label\"}}\n              {{else}}\n                <span visually-hidden class=\"ember-primitives__rating__label\">Rated\n                  {{r.value}}\n                  out of\n                  {{r.total}}</span>\n              {{/if}}\n            {{else}}\n              {{#if (has-block \"label\")}}\n                <legend>\n                  {{yield publicState to=\"label\"}}\n                </legend>\n              {{/if}}\n            {{/if}}\n\n            <RatingStars />\n          {{/if}}\n        {{/let}}\n\n      </fieldset>\n    </RatingState>\n  ", {
      strictMode: true,
      scope: () => ({
        RatingState,
        on,
        Stars,
        hash,
        RatingRange
      })
    }), this);
  }
}

export { Rating };
//# sourceMappingURL=index.js.map
