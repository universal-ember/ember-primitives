import { hash } from '@ember/helper';

import { ReactiveImage } from 'reactiveweb/image';
import { WaitUntil } from 'reactiveweb/wait-until';

import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';

const Fallback: TOC<{
  Blocks: { default: [] };
  Args: {
    /**
     * The number of milliseconds to wait for the image to load
     * before displaying the fallback
     */
    delayMs?: number;
    /**
     * @private
     * Bound internally by ember-primitives
     */
    isLoaded: boolean;
  };
}> = <template>
  {{#unless @isLoaded}}
    {{#let (WaitUntil @delayMs) as |delayFinished|}}
      {{#if delayFinished}}
        {{yield}}
      {{/if}}
    {{/let}}
  {{/unless}}
</template>;

const Image: TOC<{
  Element: HTMLImageElement;
  Args: {
    /**
     * @private
     * The `src` value for the image.
     *
     * Bound internally by ember-primitives
     */
    src: string;
    /**
     * @private
     * Bound internally by ember-primitives
     */
    isLoaded: boolean;
  };
}> = <template>
  {{#if @isLoaded}}
    <img alt="__missing__" ...attributes src={{@src}} />
  {{/if}}
</template>;


export const Avatar: TOC<{
  Element: HTMLSpanElement;
  Args: {
    /**
     * The `src` value for the image.
     */
    src: string;
  };
  Blocks: {
    default: [
      avatar: {
        /**
          * The image to render. It will only render when it has loaded.
          */
        Image: WithBoundArgs<typeof Image, 'src' | 'isLoaded'>;
        /**
         * An element that renders when the image hasn't loaded.
         * This means whilst it's loading, or if there was an error.
         * If you notice a flash during loading,
         * you can provide a delayMs prop to delay its rendering so it only renders for those with slower connections.
         */
        Fallback: WithBoundArgs<typeof Fallback, 'isLoaded'>;
        /**
          * true while the image is loading
          */
        isLoading: boolean;
        /**
          * If the image fails to load, this will be `true`
          */
        isError: boolean;
      },
    ];
  };
}> =
  <template>
  {{#let (ReactiveImage @src) as |imgState|}}
    <span data-prim-avatar ...attributes data-loading={{imgState.isLoading}} data-error={{imgState.isError}}>
      {{yield (hash
        Image=(component Image src=@src isLoaded=imgState.isResolved)
        Fallback=(component Fallback isLoaded=imgState.isResolved)
        isLoading=imgState.isLoading
        isError=imgState.isError
      )}}
    </span>
  {{/let}}
</template>;

export default Avatar;
