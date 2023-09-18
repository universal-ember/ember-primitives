import { hash } from '@ember/helper';

import { cell, resource, resourceFactory } from 'ember-resources';
import { trackedFunction } from 'ember-resources/util/function';

import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';

// TODO: Change to
// function ReactiveImage(url) {
//   when the babel plugin is complete
const ReactiveImage = resourceFactory((url) => {
  return resource(({ use }) => {
    let readonlyReactive = use(
      trackedFunction(async () => {
        let image = new window.Image();

        await new Promise((resolve, reject) => {
          image.onload = resolve;
          image.onerror = reject;
          image.src = url;
        });
      }),
    );

    return () => readonlyReactive.current;
  });
});

const WaitUntil = resourceFactory(delayMs => {
  return resource(({ on }) => {
    // If we don't have a delay, we can start with
    // immediately saying "we're done waiting"
    let initialValue = delayMs ? false : true;
    let delayFinished = cell(initialValue);

    if (delayMs) {
      let timer = setTimeout(() => delayFinished.current = true, delayMs);

      on.cleanup(() => clearTimeout(timer));
    }

    // Collapse the state that Cell provides to just a boolean
    return () => delayFinished.current;
  });
});

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
        Image: WithBoundArgs<typeof Image, 'src' | 'isLoaded'>;
        Fallback: WithBoundArgs<typeof Fallback, 'isLoaded'>;
        /**
          * true while the image is loading
          */
        isLoading: boolean;
        /**
          * If the image fails to load, this will be `true`
          */
        isError: boolean;
        /**
          * State representing when the image has finished trying to load
          */
        isFinished: boolean;
      },
    ];
  };
}> =
  <template>
  <span data-prim-avatar ...attributes>
    {{#let (ReactiveImage @src) as |imgState|}}
      {{yield (hash
        Image=(component Image src=@src isLoaded=imgState.isResolved)
        Fallback=(component Fallback isLoaded=imgState.isResolved)
        isLoading=imgState.isLoading
        isError=imgState.isError
        isFinished=imgState.isFinished
      )}}
    {{/let}}
  </span>
</template>;

export default Avatar;
