const LOOKUP = new WeakMap<Text, number>();

const BOUNDARY_ELEMENTS = new Set([
  'SECTION',
  'ARTICLE',
  'ASIDE',
  'HEADER',
  'FOOTER',
  'MAIN',
  'NAV',
]);

/**
 * A set with both cases is more performant than calling toLowerCase
 */
const SECTION_HEADINGS = new Set([
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'H1',
  'H2',
  'H3',
  'H4',
  'H5',
  'H6',
]);
const TEST_BOUNDARY = 'ember-testing';

function isRoot(element: Element) {
  return (
    element === document.body ||
    element.id === TEST_BOUNDARY ||
    !(
      element.parentElement ||
      (element.parentNode as unknown as ShadowRoot)?.host
    )
  );
}

/**
 * node is our current traversal node as we head up the DOM tree (towards the root)
 * previous node is the immediate child within that current traversal node that we came from.
 *
 * The previousNode is used for an optimization so that we can iterate *from*
 * that child within the current traversal node, rather than always starting from the
 * first child of the current traversal node.
 */
function findHeadingIn(
  node: ParentNode | ChildNode,
  previousNode?: ParentNode,
): number | undefined {
  if (!(node instanceof Element)) return;

  if (SECTION_HEADINGS.has(node.tagName)) {
    const level = parseInt(node.tagName.replace('h', '').replace('H', ''));

    return level;
  }

  /**
   * Previous traversal does not search within the section boundaies
   * This is because previous traversal is looking for a similar heading level, and crossing a section boundary changes the section level.
   */
  if (previousNode) {
    let previous = previousNode.previousSibling;

    while (previous) {
      if (!(previous instanceof Element)) {
        previous = previous.previousSibling;
        continue;
      }

      if (BOUNDARY_ELEMENTS.has(previous.tagName)) {
        previous = previous.previousSibling;
        continue;
      }

      const level = findHeadingIn(previous);

      /**
       * We subtract one, because we may have found
       * an equal heading, due to it being a sibling
       */
      if (level) return level;

      previous = previous.previousSibling;
    }
  }

  /**
   * Fallback traversal if we still haven't found the
   * heading level, we check all the children
   * of the current node, because headings can be
   * within <a> tags and such.
   */
  for (const child of node.children) {
    const level = findHeadingIn(child);

    if (level) return level;
  }
}

/**
 * The Platform native 'closest' function can't punch through shadow-boundaries
 */
function nearestAncestor(
  node: Text | Element,
  matcher: (el: Element) => boolean,
) {
  let parent: ParentNode | null = node.parentElement;

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
function levelOf(node: Text): number {
  const ourBoundary = nearestAncestor(node, (el) =>
    BOUNDARY_ELEMENTS.has(el.tagName),
  );

  /**
   * We are the top-level
   */
  if (!ourBoundary) {
    return 1;
  }

  const stopAt = nearestAncestor(ourBoundary, (el) => {
    if (BOUNDARY_ELEMENTS.has(el.tagName)) return true;

    return isRoot(el);
  });

  if (!stopAt) {
    throw new Error(
      `[BUG]: Could not find a stopping boundary for automatic heading level detection. Checked for ${[...BOUNDARY_ELEMENTS, 'body', '#ember-testing'].map((x) => x.toLowerCase()).join(', ')}`,
    );
  }

  let previous: ParentNode = ourBoundary;
  let current: ParentNode | null = ourBoundary.parentNode;

  while (current) {
    const level = findHeadingIn(current, previous);

    if (level) {
      return level + 1;
    }

    if (current === stopAt) break;

    if (current instanceof ShadowRoot) {
      current = current.host;
    }

    previous = current;
    current = current.parentNode;
  }

  return 1;
}

/**
 * Determines what your heading level should be (h1 - h6).
 *
 * In your app, you can use any of `<section>`, `<article>`, and `<aside>` elements to denote when the [_Section Heading_][mdn-h] element should change its level.
 *
 * [mdn-h]: https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/Heading_Elements
 *
 * ```js
 * import { getSectionHeadingLevel } from 'which-heading-do-i-need';
 *
 * getSectionHeadingLevel(nodeRef);
 * ```
 *
 * Can also receive options, such as `startAt`
 * Which is the root heading level to use if traversal makes it to the "top"
 * of the available DOM tree.
 * Defaults to 1 (as in h1)
 *
 * ```js
 * import { getSectionHeadingLevel } from 'which-heading-do-i-need';
 *
 * getSectionHeadingLevel(nodeRef, { startAt: 3 });
 *
 */
export function getSectionHeadingLevel(
  node: Text,
  options?: {
    /**
     * The root heading level to use if traversal makes it to the "top"
     * of the available DOM tree.
     *
     * Defaults to 1 (as in h1)
     */
    startAt?: number;
  },
) {
  const existing = LOOKUP.get(node);

  if (existing) return existing;

  const parentLevel = levelOf(node);
  const myLevel = parentLevel;

  LOOKUP.set(node, myLevel);

  if (myLevel === 1 && options?.startAt) {
    return options.startAt;
  }

  return myLevel;
}
