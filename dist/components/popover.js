import templateOnly from '@ember/component/template-only';
import { setComponentTemplate } from '@ember/component';
import { precompileTemplate } from '@ember/template-compilation';
import { hash } from '@ember/helper';
import { arrow } from '@floating-ui/dom';
import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';
import { Velcro } from 'ember-velcro';
import { Portal } from './portal.js';
import { TARGETS } from './portal-targets.js';

/**
 * Allows lazy evaluation of the portal target (do nothing until rendered)
 * This is useful because the algorithm for finding the portal target isn't cheap.
 */
const Content = setComponentTemplate(precompileTemplate(`
  <Portal @to={{TARGETS.popover}}>
    <div {{@loop}} ...attributes>
      {{yield}}
    </div>
  </Portal>
`, {
  strictMode: true,
  scope: () => ({
    Portal,
    TARGETS
  })
}), templateOnly("popover", "Content"));
const arrowSides = {
  top: 'bottom',
  right: 'left',
  bottom: 'top',
  left: 'right'
};
const attachArrow = modifier((element, _, named) => {
  if (element === named.arrowElement.current) {
    if (!named.data) return;
    if (!named.data.middlewareData) return;
    let {
      arrow
    } = named.data.middlewareData;
    let {
      placement
    } = named.data;
    if (!arrow) return;
    if (!placement) return;
    let {
      x: arrowX,
      y: arrowY
    } = arrow;
    let otherSide = placement.split('-')[0];
    let staticSide = arrowSides[otherSide];
    Object.assign(named.arrowElement.current.style, {
      left: arrowX != null ? `${arrowX}px` : '',
      top: arrowY != null ? `${arrowY}px` : '',
      right: '',
      bottom: '',
      [staticSide]: '-4px'
    });
    return;
  }
  (async () => {
    await Promise.resolve();
    named.arrowElement.set(element);
  })();
});
const ArrowElement = () => cell();
function maybeAddArrow(middleware, element) {
  let result = [...(middleware || [])];
  if (element) {
    result.push(arrow({
      element
    }));
  }
  return result;
}
function flipOptions(options) {
  return {
    elementContext: 'reference',
    ...options
  };
}
const Popover = setComponentTemplate(precompileTemplate(`
  {{#let (ArrowElement) as |arrowElement|}}
    <Velcro
      @placement={{@placement}}
      @strategy={{@strategy}}
      @middleware={{maybeAddArrow @middleware arrowElement.current}}
      @flipOptions={{flipOptions @flipOptions}}
      @shiftOptions={{@shiftOptions}}
      @offsetOptions={{@offsetOptions}}
      as |velcro|
    >
      {{yield
        (hash
          hook=velcro.hook
          Content=(component Content loop=velcro.loop)
          data=velcro.data
          arrow=(modifier attachArrow arrowElement=arrowElement data=velcro.data)
        )
      }}
    </Velcro>
  {{/let}}
`, {
  strictMode: true,
  scope: () => ({
    ArrowElement,
    Velcro,
    maybeAddArrow,
    flipOptions,
    hash,
    Content,
    attachArrow
  })
}), templateOnly("popover", "Popover"));

export { Popover, Popover as default };
//# sourceMappingURL=popover.js.map
