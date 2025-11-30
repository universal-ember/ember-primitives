
import { assert } from '@ember/debug';
import { macroCondition, isDevelopingApp } from '@embroider/macros';
import { modifier } from 'ember-modifier';
import { TrackedMap, TrackedSet } from 'tracked-built-ins';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

const cache = new TrackedMap();
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
  const manuallyRegisteredSet = cache.get(name);
  const manuallyRegistered = manuallyRegisteredSet?.size ? [...manuallyRegisteredSet] : null;
  /**
  * For use with <PortalTarget @name="hi" />
  */
  function findRegistered(host) {
    return manuallyRegistered?.find(element => {
      if (host.contains(element)) {
        return element;
      }
    });
  }
  const selector = Object.values(TARGETS).includes(name) ? `[data-portal-name=${name}]` : name;
  /**
  * Default portals / non-registered -- here we match a query selector instead of an element
  */
  function findDefault(host) {
    return host.querySelector(selector);
  }
  const finder = manuallyRegistered ? findRegistered : findDefault;
  /**
  * Crawl up the ancestry looking for our portal target
  */
  while (!element && parent) {
    element = finder(parent);
    if (element) break;
    parent = parent.parentNode;
  }
  if (macroCondition(isDevelopingApp())) {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
    window.prime0 = origin;
  }
  if (name.startsWith("ember-primitives")) {
    assert(`Could not find element by the given name: \`${name}\`.` + ` The known names are ` + `${Object.values(TARGETS).join(", ")} ` + `-- but any name will work as long as it is set to the \`data-portal-name\` attribute ` + `(or if the name has been specifically registered via the <PortalTarget /> component). ` + `Double check that the element you're wanting to portal to is rendered. ` + `The element passed to \`findNearestTarget\` is stored on \`window.prime0\` ` + `You can debug in your browser's console via ` + `\`document.querySelector('[data-portal-name="${name}"]')\``, element);
  }
  return element ?? undefined;
}
const register = modifier((element, [name]) => {
  assert(`@name is required when using <PortalTarget>`, name);
  void (async () => {
    // Bad TypeScript lint.
    // eslint-disable-next-line @typescript-eslint/await-thenable
    await 0;
    let existing = cache.get(name);
    if (!existing) {
      existing = new TrackedSet();
      cache.set(name, existing);
    }
    existing.add(element);
  })();
  return () => {
    cache.delete(name);
  };
});
const PortalTargets = setComponentTemplate(precompileTemplate("\n  <div data-portal-name={{TARGETS.popover}}></div>\n  <div data-portal-name={{TARGETS.tooltip}}></div>\n  <div data-portal-name={{TARGETS.modal}}></div>\n", {
  strictMode: true,
  scope: () => ({
    TARGETS
  })
}), templateOnly());
/**
 * For manually registering a PortalTarget for use with Portal
 */
const PortalTarget = setComponentTemplate(precompileTemplate("\n  <div {{register @name}} ...attributes></div>\n", {
  strictMode: true,
  scope: () => ({
    register
  })
}), templateOnly());

export { PortalTarget, PortalTargets, TARGETS, PortalTargets as default, findNearestTarget };
//# sourceMappingURL=portal-targets.js.map
