import Component from '@glimmer/component';
import { isDestroyed, isDestroying } from '@ember/destroyable';
import { hash } from '@ember/helper';

import { modifier } from 'ember-modifier';

/**
 * Utility component for helping with scrolling in any direction within
 * any of the 4 directions: up, down, left, right.
 *
 * This can be used to auto-scroll content as new content is inserted into the scrollable area, or possibly to bring focus to something on the page.
 */
export class Scroller extends Component<{
  /**
   * A containing element is required - in this case, a div.
   * It must be scrollable for this component to work, but can be customized.
   */
  Element: HTMLDivElement;
  Blocks: {
    default: [
      {
        /**
         * Scroll the content to the bottom
         *
         * ```gjs
         * import { Scroller } from 'ember-primitives';
         *
         * <template>
         *   <Scroller as |s|>
         *      ...
         *
         *      {{ (s.scrollToBottom) }}
         *   </Scroller>
         * </template>
         * ```
         */
        scrollToBottom: () => void;
        /**
         * Scroll the content to the top
         *
         * ```gjs
         * import { Scroller } from 'ember-primitives';
         *
         * <template>
         *   <Scroller as |s|>
         *      ...
         *
         *      {{ (s.scrollToTop) }}
         *   </Scroller>
         * </template>
         * ```
         */
        scrollToTop: () => void;
        /**
         * Scroll the content to the left
         *
         * ```gjs
         * import { Scroller } from 'ember-primitives';
         *
         * <template>
         *   <Scroller as |s|>
         *      ...
         *
         *      {{ (s.scrollToLeft) }}
         *   </Scroller>
         * </template>
         * ```
         */
        scrollToLeft: () => void;
        /**
         * Scroll the content to the right
         *
         * ```gjs
         * import { Scroller } from 'ember-primitives';
         *
         * <template>
         *   <Scroller as |s|>
         *      ...
         *
         *      {{ (s.scrollToRight) }}
         *   </Scroller>
         * </template>
         * ```
         */
        scrollToRight: () => void;
      },
    ];
  };
}> {
  declare withinElement: HTMLDivElement;

  ref = modifier((el: HTMLDivElement) => {
    this.withinElement = el;
  });

  #frame?: number;

  scrollToBottom = () => {
    if (this.#frame) {
      cancelAnimationFrame(this.#frame);
    }

    this.#frame = requestAnimationFrame(() => {
      if (isDestroyed(this) || isDestroying(this)) return;

      this.withinElement.scrollTo({
        top: this.withinElement.scrollHeight,
        behavior: 'smooth',
      });
    });
  };

  scrollToTop = () => {
    if (this.#frame) {
      cancelAnimationFrame(this.#frame);
    }

    this.#frame = requestAnimationFrame(() => {
      if (isDestroyed(this) || isDestroying(this)) return;

      this.withinElement.scrollTo({
        top: 0,
        behavior: 'smooth',
      });
    });
  };

  scrollToLeft = () => {
    if (this.#frame) {
      cancelAnimationFrame(this.#frame);
    }

    this.#frame = requestAnimationFrame(() => {
      if (isDestroyed(this) || isDestroying(this)) return;

      this.withinElement.scrollTo({
        left: 0,
        behavior: 'smooth',
      });
    });
  };

  scrollToRight = () => {
    if (this.#frame) {
      cancelAnimationFrame(this.#frame);
    }

    this.#frame = requestAnimationFrame(() => {
      if (isDestroyed(this) || isDestroying(this)) return;

      this.withinElement.scrollTo({
        left: this.withinElement.scrollWidth,
        behavior: 'smooth',
      });
    });
  };

  <template>
    <div tabindex="0" ...attributes {{this.ref}}>
      {{yield
        (hash
          scrollToBottom=this.scrollToBottom
          scrollToTop=this.scrollToTop
          scrollToLeft=this.scrollToLeft
          scrollToRight=this.scrollToRight
        )
      }}
    </div>
  </template>
}
