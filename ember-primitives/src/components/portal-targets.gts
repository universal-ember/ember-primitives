import { assert } from "@ember/debug";
import { isDevelopingApp, macroCondition } from "@embroider/macros";

import { modifier } from "ember-modifier";
import { TrackedSet } from "tracked-built-ins";

import type { TOC } from "@ember/component/template-only";

export const TARGETS = Object.freeze({
  popover: "ember-primitives__portal-targets__popover",
  tooltip: "ember-primitives__portal-targets__tooltip",
  modal: "ember-primitives__portal-targets__modal",
});

export function findNearestTarget(origin: Element, name: string) {
  assert(`first argument to \`findNearestTarget\` must be an element`, origin instanceof Element);
  assert(`second argument to \`findNearestTarget\` must be a string`, typeof name === `string`);

  let element: Element | null = null;

  let parent = origin.parentNode;

  while (!element && parent) {
    element = parent.querySelector(`[data-portal-name=${name}]`);
    if (element) break;
    parent = parent.parentNode;
  }

  if (macroCondition(isDevelopingApp())) {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
    (window as any).prime0 = origin;
  }

  if (name.startsWith("ember-primitives")) {
    assert(
      `Could not find element by the given name: \`${name}\`.` +
        ` The known names are ` +
        `${Object.values(TARGETS).join(", ")} ` +
        `-- but any name will work as long as it is set to the \`data-portal-name\` attribute. ` +
        `Double check that the element you're wanting to portal to is rendered. ` +
        `The element passed to \`findNearestTarget\` is stored on \`window.prime0\` ` +
        `You can debug in your browser's console via ` +
        `\`document.querySelector('[data-portal-name="${name}"]')\``,
      element,
    );
  }

  return element;
}

const cache = new Map<string, Set<Element>>();
const register = modifier((element, [name]: [name: string]) => {
  let existing = cache.get(name);

  if (!existing) {
    existing = new TrackedSet();
    cache.set(name, existing);
  }

  existing.add(element);

  return () => {
    cache.delete(name);
  };
});

export interface Signature {
  Element: null;
}

export const PortalTargets: TOC<Signature> = <template>
  <div data-portal-name={{TARGETS.popover}}></div>
  <div data-portal-name={{TARGETS.tooltip}}></div>
  <div data-portal-name={{TARGETS.modal}}></div>
</template>;

export const PortalTarget: TOC<{
  Element: HTMLDivElement;
  Args: {
    /**
     * The name of the PortalTarget
     *
     * This exact string may be passed to `Portal`'s `@to` argument.
     */
    name: string;
  };
}> = <template>
  <div {{register @name}} ...attributes></div>
</template>;

export default PortalTargets;
