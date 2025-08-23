import { assert } from "@ember/debug";
import { isDevelopingApp, macroCondition } from "@embroider/macros";

import { modifier } from "ember-modifier";
import { TrackedMap, TrackedSet } from "tracked-built-ins";

import type { TOC } from "@ember/component/template-only";

const cache = new TrackedMap<string, Set<Element>>();

export const TARGETS = Object.freeze({
  popover: "ember-primitives__portal-targets__popover",
  tooltip: "ember-primitives__portal-targets__tooltip",
  modal: "ember-primitives__portal-targets__modal",
});

export function findNearestTarget(origin: Element, name: string): Element | undefined {
  assert(`first argument to \`findNearestTarget\` must be an element`, origin instanceof Element);
  assert(`second argument to \`findNearestTarget\` must be a string`, typeof name === `string`);

  let element: Element | undefined | null = null;

  let parent = origin.parentNode;

  const manuallyRegisteredSet = cache.get(name);
  const manuallyRegistered: Element[] | null = manuallyRegisteredSet?.size
    ? [...manuallyRegisteredSet]
    : null;

  /**
   * For use with <PortalTarget @name="hi" />
   */
  function findRegistered(host: ParentNode): Element | undefined {
    return manuallyRegistered?.find((element) => {
      if (host.contains(element)) {
        return element;
      }
    });
  }

  const selector = Object.values(TARGETS as Record<string, string>).includes(name)
    ? `[data-portal-name=${name}]`
    : name;

  /**
   * Default portals / non-registered -- here we match a query selector instead of an element
   */
  function findDefault(host: ParentNode): Element | undefined {
    return host.querySelector(selector) as Element;
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
    (window as any).prime0 = origin;
  }

  if (name.startsWith("ember-primitives")) {
    assert(
      `Could not find element by the given name: \`${name}\`.` +
        ` The known names are ` +
        `${Object.values(TARGETS).join(", ")} ` +
        `-- but any name will work as long as it is set to the \`data-portal-name\` attribute ` +
        `(or if the name has been specifically registered via the <PortalTarget /> component). ` +
        `Double check that the element you're wanting to portal to is rendered. ` +
        `The element passed to \`findNearestTarget\` is stored on \`window.prime0\` ` +
        `You can debug in your browser's console via ` +
        `\`document.querySelector('[data-portal-name="${name}"]')\``,
      element,
    );
  }

  return element ?? undefined;
}

const register = modifier((element: Element, [name]: [name: string]) => {
  assert(`@name is required when using <PortalTarget>`, name);

  void (async () => {
    // Bad TypeScript lint.
    // eslint-disable-next-line @typescript-eslint/await-thenable
    await 0;

    let existing = cache.get(name);

    if (!existing) {
      existing = new TrackedSet<Element>();
      cache.set(name, existing);
    }

    existing.add(element);
  })();

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

/**
 * For manually registering a PortalTarget for use with Portal
 */
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
