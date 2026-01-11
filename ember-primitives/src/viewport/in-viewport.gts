import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { assert } from "@ember/debug";

import { element } from "ember-element-helper";
import { modifier } from "ember-modifier";

import { viewport } from "./viewport.ts";

export type InViewportMode = "replace" | "contain";

/**
 * Configuration for the InViewport component
 */
export interface InViewportSignature {
  Element: HTMLElement;
  Args: {
    /**
     * The tag name for the placeholder element.
     * Can be any valid HTML tag name.
     * Default: 'div'
     */
    tagName?: string;

    /**
     * The mode determines how yielded content is rendered:
     * - 'replace': yielded content replaces the placeholder element
     * - 'contain': yielded content is rendered within the placeholder
     * Default: 'contain'
     */
    mode?: InViewportMode;
  };
  Blocks: {
    /**
     * Default block - rendered when the element is in the viewport
     */
    default: [];
  };
}

/**
 * A component that only renders its content when the element is near the viewport.
 *
 * This is useful for deferring the rendering of heavy components until they're
 * actually needed, improving performance for pages with many components.
 *
 * Example usage:
 * ```gjs
 * import { InViewport } from 'ember-primitives';
 *
 * <template>
 *   <InViewport>
 *     <ExpensiveComponent />
 *   </InViewport>
 * </template>
 * ```
 *
 * The component uses the Intersection Observer API to detect when the element
 * is near the viewport. Once detected, the observer is destroyed and the content
 * is rendered permanently.
 */
export class InViewport extends Component<InViewportSignature> {
  /**
   * Whether the element has been detected as in/near the viewport
   */
  @tracked hasIntersected = false;

  get #viewport() {
    return viewport(this);
  }

  setupObserver = modifier((element: Element) => {
    if (this.hasIntersected) {
      return;
    }

    // Some browsers have surprising `IntersectionObserver` behavior when the
    // observed element has a 0×0 bounding box (either never intersecting, or
    // intersecting immediately). Since `<InViewport />` often starts with an
    // empty placeholder element, ensure the observed element has a minimal size.
    //
    // We only apply styles when necessary and revert them on teardown.
    let restoreStyles: (() => void) | undefined;

    if (element instanceof HTMLElement) {
      const rect = element.getBoundingClientRect();

      if (rect.width === 0 && rect.height === 0) {
        const originalMinHeight = element.style.minHeight;
        const originalMinWidth = element.style.minWidth;
        const originalDisplay = element.style.display;

        element.style.minHeight = "1px";
        element.style.minWidth = "1px";

        // `min-*` won't affect `display: inline` elements.
        if (window.getComputedStyle(element).display === "inline") {
          element.style.display = "inline-block";
        }

        restoreStyles = () => {
          element.style.minHeight = originalMinHeight;
          element.style.minWidth = originalMinWidth;
          element.style.display = originalDisplay;
        };
      }
    }

    this.#viewport.observe(element, this.handle);

    return () => {
      this.#viewport.unobserve(element, this.handle);
      restoreStyles?.();
    };
  });

  handle = (entry: IntersectionObserverEntry) => {
    if (entry?.isIntersecting) {
      this.hasIntersected = true;

      this.#viewport.unobserve(entry.target, this.handle);
    }
  };

  get mode(): InViewportMode {
    assert(
      'InViewport mode must be either "replace" or "contain"',
      !this.args.mode || this.args.mode === "replace" || this.args.mode === "contain",
    );

    return this.args.mode ?? "contain";
  }

  get tagName(): string {
    return this.args.tagName ?? "div";
  }

  get hasReachedViewport(): boolean {
    return this.hasIntersected;
  }

  get isReplacing(): boolean {
    return this.mode === "replace";
  }

  <template>
    {{#let (element this.tagName) as |El|}}
      {{#if this.isReplacing}}
        {{#if this.hasReachedViewport}}
          {{yield}}
        {{else}}
          <El {{this.setupObserver}} ...attributes />
        {{/if}}
      {{else}}
        <El {{this.setupObserver}} ...attributes>
          {{#if this.hasReachedViewport}}
            {{yield}}
          {{/if}}
        </El>
      {{/if}}
    {{/let}}
  </template>
}
