import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { assert } from "@ember/debug";

import { element } from "ember-element-helper";
import { modifier } from "ember-modifier";

import type Owner from "@ember/owner";

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

    /**
     * IntersectionObserver options.
     * Determines how close to the viewport the element needs to be
     * before it's considered "in viewport"
     */
    intersectionOptions?: IntersectionObserverInit;

    /**
     * CSS class to apply to the placeholder element
     */
    class?: string;
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

  /**
   * Reference to the IntersectionObserver instance
   */
  private observer: IntersectionObserver | null = null;

  /**
   * Reference to the placeholder element
   */
  private placeholderElement: Element | null = null;

  constructor(owner: Owner, args: InViewportSignature["Args"]) {
    super(owner, args);

    assert(
      'InViewport mode must be either "replace" or "contain"',
      !args.mode || args.mode === "replace" || args.mode === "contain",
    );
  }

  /**
   * Initializes the IntersectionObserver when the element is inserted into the DOM
   */
  setupObserver = modifier((element: Element) => {
    this.placeholderElement = element;

    if (this.hasIntersected) {
      // Already intersected, no need to observe
      return;
    }

    const options = this.args.intersectionOptions ?? {};

    // Default to 50% margin to catch elements that are "near" the viewport
    if (!options.rootMargin) {
      options.rootMargin = "50%";
    }

    this.observer = new IntersectionObserver(([entry]) => {
      if (entry?.isIntersecting) {
        this.hasIntersected = true;

        // Disconnect and clean up the observer
        if (this.observer) {
          this.observer.disconnect();
          this.observer = null;
        }
      }
    }, options);

    this.observer.observe(element);

    // Cleanup when the component is destroyed
    return () => {
      if (this.observer) {
        this.observer.disconnect();
        this.observer = null;
      }
    };
  });

  get mode(): InViewportMode {
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
          <El class={{@class}} {{this.setupObserver}} ...attributes />
        {{/if}}
      {{else}}
        <El class={{@class}} {{this.setupObserver}} ...attributes>
          {{#if this.hasReachedViewport}}
            {{yield}}
          {{/if}}
        </El>
      {{/if}}
    {{/let}}
  </template>
}
