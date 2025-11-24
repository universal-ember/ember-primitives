
import Component from '@glimmer/component';
import { assert } from '@ember/debug';
import { element } from 'ember-element-helper';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';

const LOOKUP = new WeakMap();
const BOUNDARY_ELEMENTS = new Set(["SECTION", "ARTICLE", "ASIDE", "HEADER", "FOOTER", "MAIN", "NAV"]);
/**
 * A set with both cases is more performant than calling toLowerCase
 */
const SECTION_HEADINGS = new Set(["h1", "h2", "h3", "h4", "h5", "h6", "H1", "H2", "H3", "H4", "H5", "H6"]);
const TEST_BOUNDARY = "ember-testing";
function isRoot(element) {
  return element === document.body || element.id === TEST_BOUNDARY;
}
function findHeadingIn(node) {
  if (!(node instanceof Element)) return;
  if (SECTION_HEADINGS.has(node.tagName)) {
    const level = parseInt(node.tagName.replace("h", "").replace("H", ""));
    return level;
  }
  for (const child of node.children) {
    const level = findHeadingIn(child);
    if (level) return level;
  }
}
/**
 * The Platform native 'closest' function can't punch through shadow-boundaries
 */
function nearestAncestor(node, matcher) {
  let parent = node.parentElement;
  if (!parent) return;
  while (parent) {
    if (parent instanceof Element) {
      if (matcher(parent)) return parent;
    }
    if (parent instanceof ShadowRoot) {
      parent = parent.host;
    }
    parent = parent.parentNode;
  }
}
/**
 * The algorithm:
 *
 * section <- "our" level-changing boundary element
 *   h# <- the element we want to figure out the level of
 *
 * We start assuming we'll emit an h1.
 * We adjust this based on what we find crawling up the tree.
 *
 * While traversing up, when we go from the h# to the section,
 *  and ignore it. Because this alone has no bearing on if the h# should be an h2.
 *  We need to continue traversing upwards, until we hit the next boundary element.
 *
 * IF we would change the level the heading, we will find another heading between
 *  these two boundary elements.
 *  We'll need to check the subtrees between these elements, stopping if we
 *  encounter other boundary elements.
 *
 */
function levelOf(node) {
  const ourBoundary = nearestAncestor(node, el => BOUNDARY_ELEMENTS.has(el.tagName));
  /**
  * We are the top-level
  */
  if (!ourBoundary) {
    return 1;
  }
  const stopAt = nearestAncestor(ourBoundary, el => {
    if (BOUNDARY_ELEMENTS.has(el.tagName)) return true;
    return isRoot(el);
  });
  assert(`[BUG]: Could not find a stopping boundary for automatic heading level detection. Checked for ${[...BOUNDARY_ELEMENTS, "body", "#ember-testing"].map(x => x.toLowerCase()).join(", ")}`, stopAt);
  let current = ourBoundary.parentNode;
  while (current) {
    const level = findHeadingIn(current);
    if (level) {
      return level + 1;
    }
    if (current === stopAt) break;
    if (current instanceof ShadowRoot) {
      current = current.host;
    }
    current = current.parentNode;
  }
  return 1;
}
class Heading extends Component {
  headingScopeAnchor;
  constructor(owner, args) {
    super(owner, args);
    this.headingScopeAnchor = document.createTextNode("");
  }
  get level() {
    const existing = LOOKUP.get(this.headingScopeAnchor);
    if (existing) return existing;
    const parentLevel = levelOf(this.headingScopeAnchor);
    const myLevel = parentLevel;
    LOOKUP.set(this.headingScopeAnchor, myLevel);
    return myLevel;
  }
  get hLevel() {
    return `h${this.level}`;
  }
  static {
    setComponentTemplate(precompileTemplate("\n    {{this.headingScopeAnchor}}\n\n    {{#let (element this.hLevel) as |El|}}\n      <El ...attributes>\n        {{yield}}\n      </El>\n    {{/let}}\n  ", {
      strictMode: true,
      scope: () => ({
        element
      })
    }), this);
  }
}

export { Heading };
//# sourceMappingURL=heading.js.map
