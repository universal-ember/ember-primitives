import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { assert } from '@ember/debug';
import { element } from 'ember-element-helper';
import { modifier } from 'ember-modifier';
import { viewport } from './viewport.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import { g, i } from 'decorator-transforms/runtime';

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
class InViewport extends Component {
  static {
    g(this.prototype, "hasIntersected", [tracked], function () {
      return false;
    });
  }
  #hasIntersected = (i(this, "hasIntersected"), void 0);
  /**
  * Whether the element has been detected as in/near the viewport
  */
  get #viewport() {
    return viewport(this);
  }
  setupObserver = modifier(element => {
    if (this.hasIntersected) {
      return;
    }
    this.#viewport.observe(element, this.handle);
    return () => this.#viewport.unobserve(element, this.handle);
  });
  handle = entry => {
    if (entry?.isIntersecting) {
      this.hasIntersected = true;
      this.#viewport.unobserve(entry.target, this.handle);
    }
  };
  get mode() {
    assert('InViewport mode must be either "replace" or "contain"', !this.args.mode || this.args.mode === "replace" || this.args.mode === "contain");
    return this.args.mode ?? "contain";
  }
  get tagName() {
    return this.args.tagName ?? "div";
  }
  get hasReachedViewport() {
    return this.hasIntersected;
  }
  get isReplacing() {
    return this.mode === "replace";
  }
  static {
    setComponentTemplate(precompileTemplate("{{#let (element this.tagName) as |El|}}\n  {{#if this.isReplacing}}\n    {{#if this.hasReachedViewport}}\n      {{yield}}\n    {{else}}\n      <El {{this.setupObserver}} ...attributes />\n    {{/if}}\n  {{else}}\n    <El {{this.setupObserver}} ...attributes>\n      {{#if this.hasReachedViewport}}\n        {{yield}}\n      {{/if}}\n    </El>\n  {{/if}}\n{{/let}}", {
      strictMode: true,
      scope: () => ({
        element
      })
    }), this);
  }
}

export { InViewport };
//# sourceMappingURL=in-viewport.js.map
