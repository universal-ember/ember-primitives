import { hash } from '@ember/helper';

import type { TOC } from '@ember/component/template-only';

const Item: TOC<{
  Element: HTMLLIElement;
  Blocks: {
    default: [];
  };
}> = <template>
  <li ...attributes>
    {{yield}}
  </li>
</template>;

const BreadcrumbLink: TOC<{
  Element: HTMLAnchorElement;
  Args: {
    /**
     * The `href` string value to set on the anchor element.
     */
    href: string;
  };
  Blocks: {
    default: [];
  };
}> = <template>
  <a href={{@href}} ...attributes>
    {{yield}}
  </a>
</template>;

const Separator: TOC<{
  Element: HTMLSpanElement;
  Blocks: {
    default: [];
  };
}> = <template>
  <span aria-hidden="true" ...attributes>
    {{yield}}
  </span>
</template>;

export interface Signature {
  Element: HTMLElement;
  Args: {
    /**
     * The accessible label for the breadcrumb navigation.
     * Defaults to "Breadcrumb"
     */
    label?: string;
  };
  Blocks: {
    default: [
      {
        /**
         * A breadcrumb item component.
         * Use this to wrap each breadcrumb link or text.
         */
        Item: typeof Item;
        /**
         * A link component for breadcrumb items.
         * Use this for navigable breadcrumb items.
         */
        Link: typeof BreadcrumbLink;
        /**
         * A separator component to place between breadcrumb items.
         * Typically renders as "/" or ">" with aria-hidden="true".
         */
        Separator: typeof Separator;
      },
    ];
  };
}

/**
 * A breadcrumb navigation component that displays the current page's location within a navigational hierarchy.
 *
 * Breadcrumbs help users understand their current location and provide a way to navigate back through the hierarchy.
 *
 * For example:
 *
 * ```gjs live preview
 * import { Breadcrumb } from 'ember-primitives';
 *
 * <template>
 *   <Breadcrumb as |b|>
 *     <b.Item>
 *       <b.Link @href="/">Home</b.Link>
 *     </b.Item>
 *     <b.Separator>/</b.Separator>
 *     <b.Item>
 *       <b.Link @href="/docs">Docs</b.Link>
 *     </b.Item>
 *     <b.Separator>/</b.Separator>
 *     <b.Item aria-current="page">
 *       Breadcrumb
 *     </b.Item>
 *   </Breadcrumb>
 * </template>
 * ```
 */
export const Breadcrumb: TOC<Signature> = <template>
  <nav aria-label={{if @label @label "Breadcrumb"}} ...attributes>
    <ol>
      {{yield (hash Item=Item Link=BreadcrumbLink Separator=Separator)}}
    </ol>
  </nav>
</template>;

export default Breadcrumb;
