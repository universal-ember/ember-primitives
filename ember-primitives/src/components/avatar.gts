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
        /**
          * NOTE: Image#onerror is a global error.
          *       So in testing, the error escapes the confines
          *       of this promise handler (trackedFunction)
          *
          * We need to "swallow the rejection" and re-throw
          * by wrapping in an extra promise.
          */
        let image = new window.Image();

        function loadImage() {
          /**
            * Note tha lack of reject callback.
            * This is what allows us to capture "global errors"
            * thrown by image.onerror
            *
            * Additionally, the global error does not have a stack trace.
            * And we want to provide a stack trace for easier debugging.
            *
            */
          return new Promise((resolve) => {
            image.onload = resolve;

          /**
            * The error passed to onerror doesn't look that useful.
            *  But we'll log it just in case.
            *
            */
            image.onerror = (error) => {
              console.error(`Image failed to load at ${url}`, error);

              /**
                * If we use real reject, we cause an un-catchable error
                */
              resolve('soft-rejected');
            }

            image.src = url;
          });
        }

        return await loadImage();
      }),
    );


    /**
      * Here we both forward the state of trackedFunction
      * as well as re-define how we want to determine what isError, value, and isResolved
      * mean.
        *
        * This is because trackedFunction does not capture errors.
        * I believe it _should_ though, so this may be a bug.
        *
        * If it ends up being a bug in trackedFunction,
      * then we can delete all this, and only do:
        *
        * return () => readonlyReactive.current;
      */
    const isError = () => readonlyReactive.current.value === 'soft-rejected';

    return {
      get isError() {
        return isError();
      },
      get value() {
        if (isError()) return null;

        return readonlyReactive.current.value;
      },
      get isResolved() {
        if (isError()) return false;

        return readonlyReactive.current.isResolved;
      },
      get isLoading() {
        return readonlyReactive.current.isLoading;
      },
    }
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
