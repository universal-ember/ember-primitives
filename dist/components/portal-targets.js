import { assert } from '@ember/debug';
import { macroCondition, isDevelopingApp } from '@embroider/macros';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

const TARGETS = Object.freeze({
  popover: "ember-primitives__portal-targets__popover",
  tooltip: "ember-primitives__portal-targets__tooltip",
  modal: "ember-primitives__portal-targets__modal"
});
function findNearestTarget(origin, name) {
  assert(`first argument to \`findNearestTarget\` must be an element`, origin instanceof Element);
  assert(`second argument to \`findNearestTarget\` must be a string`, typeof name === `string`);
  let element = null;
  let parent = origin.parentNode;
  while (!element && parent) {
    element = parent.querySelector(`[data-portal-name=${name}]`);
    if (element) break;
    parent = parent.parentNode;
  }
  if (macroCondition(isDevelopingApp())) {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
    window.prime0 = origin;
  }
  assert(`Could not find element by the given name: \`${name}\`.` + ` The known names are ` + `${Object.values(TARGETS).join(", ")} ` + `-- but any name will work as long as it is set to the \`data-portal-name\` attribute. ` + `Double check that the element you're wanting to portal to is rendered. ` + `The element passed to \`findNearestTarget\` is stored on \`window.prime0\` ` + `You can debug in your browser's console via ` + `\`document.querySelector('[data-portal-name="${name}"]')\``, element);
  return element;
}
const PortalTargets = setComponentTemplate(precompileTemplate("\n  <div data-portal-name={{TARGETS.popover}}></div>\n  <div data-portal-name={{TARGETS.tooltip}}></div>\n  <div data-portal-name={{TARGETS.modal}}></div>\n", {
  strictMode: true,
  scope: () => ({
    TARGETS
  })
}), templateOnly());

export { PortalTargets, TARGETS, PortalTargets as default, findNearestTarget };
//# sourceMappingURL=portal-targets.js.map
