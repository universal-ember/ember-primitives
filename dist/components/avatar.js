import { hash } from '@ember/helper';
import { ReactiveImage } from 'reactiveweb/image';
import { WaitUntil } from 'reactiveweb/wait-until';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

const Fallback = setComponentTemplate(precompileTemplate("\n  {{#unless @isLoaded}}\n    {{#let (WaitUntil @delayMs) as |delayFinished|}}\n      {{#if delayFinished}}\n        {{yield}}\n      {{/if}}\n    {{/let}}\n  {{/unless}}\n", {
  strictMode: true,
  scope: () => ({
    WaitUntil
  })
}), templateOnly());
const Image = setComponentTemplate(precompileTemplate("\n  {{#if @isLoaded}}\n    <img alt=\"__missing__\" ...attributes src={{@src}} />\n  {{/if}}\n", {
  strictMode: true
}), templateOnly());
const Avatar = setComponentTemplate(precompileTemplate("\n  {{#let (ReactiveImage @src) as |imgState|}}\n    <span data-prim-avatar ...attributes data-loading={{imgState.isLoading}} data-error={{imgState.isError}}>\n      {{yield (hash Image=(component Image src=@src isLoaded=imgState.isResolved) Fallback=(component Fallback isLoaded=imgState.isResolved) isLoading=imgState.isLoading isError=imgState.isError)}}\n    </span>\n  {{/let}}\n", {
  strictMode: true,
  scope: () => ({
    ReactiveImage,
    hash,
    Image,
    Fallback
  })
}), templateOnly());

export { Avatar, Avatar as default };
//# sourceMappingURL=avatar.js.map
