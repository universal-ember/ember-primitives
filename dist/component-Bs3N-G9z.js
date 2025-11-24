
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { hash } from '@ember/helper';
import { modifier } from 'ember-modifier';
import { assert } from '@ember/debug';
import { autoUpdate, computePosition, offset, flip, shift, hide } from '@floating-ui/dom';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import { g, i } from 'decorator-transforms/runtime';

function exposeMetadata() {
  return {
    name: 'metadata',
    fn: data => {
      // https://floating-ui.com/docs/middleware#always-return-an-object
      return {
        data
      };
    }
  };
}

/**
 * A modifier to apply to the _floating_ element.
 * This is what will anchor to the reference element.
 *
 * Example
 * ```gjs
 * import { anchorTo } from 'ember-primitives/floating-ui';
 *
 * <template>
 *   <button id="my-button"> ... </button>
 *   <menu {{anchorTo "#my-button"}}> ... </menu>
 * </template>
 * ```
 */
const anchorTo = modifier((floatingElement, [_referenceElement], {
  strategy = 'fixed',
  offsetOptions = 0,
  placement = 'bottom',
  flipOptions,
  shiftOptions,
  middleware = [],
  setData
}) => {
  const referenceElement = typeof _referenceElement === 'string' ? document.querySelector(_referenceElement) : _referenceElement;
  assert('no reference element defined', referenceElement instanceof HTMLElement || referenceElement instanceof SVGElement);
  assert('no floating element defined', floatingElement instanceof HTMLElement || _referenceElement instanceof SVGElement);
  assert('reference and floating elements cannot be the same element', floatingElement !== _referenceElement);
  assert('@middleware must be an array of one or more objects', Array.isArray(middleware));
  Object.assign(floatingElement.style, {
    position: strategy,
    top: '0',
    left: '0'
  });
  const update = async () => {
    const {
      middlewareData,
      x,
      y
    } = await computePosition(referenceElement, floatingElement, {
      middleware: [offset(offsetOptions), flip(flipOptions), shift(shiftOptions), ...middleware, hide({
        strategy: 'referenceHidden'
      }), hide({
        strategy: 'escaped'
      }), exposeMetadata()],
      placement,
      strategy
    });
    const referenceHidden = middlewareData.hide?.referenceHidden;
    Object.assign(floatingElement.style, {
      top: `${y}px`,
      left: `${x}px`,
      margin: 0,
      visibility: referenceHidden ? 'hidden' : 'visible'
    });

    // eslint-disable-next-line @typescript-eslint/no-unsafe-argument
    void setData?.(middlewareData['metadata']);
  };
  void update();

  // eslint-disable-next-line @typescript-eslint/no-misused-promises
  const cleanup = autoUpdate(referenceElement, floatingElement, update);

  /**
   * in the function-modifier manager, teardown of the previous modifier
   * occurs before setup of the next
   * https://github.com/ember-modifier/ember-modifier/blob/main/ember-modifier/src/-private/function-based/modifier-manager.ts#L58
   */
  return cleanup;
});

const ref = modifier((element, positional) => {
  const fn = positional[0];
  fn(element);
});
/**
 * A component that provides no DOM and yields two modifiers for creating
 * creating floating uis, such as menus, popovers, tooltips, etc.
 * This component currently uses [Floating UI](https://floating-ui.com/)
 * but will be switching to [CSS Anchor Positioning](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_anchor_positioning) when that lands.
 *
 * Example usage:
 * ```gjs
 * import { FloatingUI } from 'ember-primitives/floating-ui';
 *
 * <template>
 *   <FloatingUI as |reference floating|>
 *     <button {{reference}}> ... </button>
 *     <menu {{floating}}> ... </menu>
 *   </FloatingUI>
 * </template>
 * ```
 */
class FloatingUI extends Component {
  static {
    g(this.prototype, "reference", [tracked], function () {
      return undefined;
    });
  }
  #reference = (i(this, "reference"), void 0);
  static {
    g(this.prototype, "data", [tracked], function () {
      return undefined;
    });
  }
  #data = (i(this, "data"), void 0);
  setData = data => this.data = data;
  setReference = element => {
    this.reference = element;
  };
  static {
    setComponentTemplate(precompileTemplate("\n    {{#let (modifier anchorTo flipOptions=@flipOptions hideOptions=@hideOptions middleware=@middleware offsetOptions=@offsetOptions placement=@placement shiftOptions=@shiftOptions strategy=@strategy setData=this.setData) as |prewiredAnchorTo|}}\n      {{#let (if this.reference (modifier prewiredAnchorTo this.reference)) as |floating|}}\n        {{!-- @glint-nocheck -- Excessively deep, possibly infinite --}}\n        {{yield (modifier ref this.setReference) floating (hash setReference=this.setReference data=this.data)}}\n      {{/let}}\n    {{/let}}\n  ", {
      strictMode: true,
      scope: () => ({
        anchorTo,
        ref,
        hash
      })
    }), this);
  }
}

export { FloatingUI as F, anchorTo as a };
//# sourceMappingURL=component-Bs3N-G9z.js.map
