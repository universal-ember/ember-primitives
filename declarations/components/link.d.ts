import type { TOC } from '@ember/component/template-only';
export interface Signature {
    Element: HTMLAnchorElement;
    Args: {
        /**
         * the `href` string value to set on the anchor element.
         */
        href: string;
        /**
         * When calculating the "active" state of the link, you may decide
         * whether or not you want to _require_ that all query params be considered (true)
         * or specify individual query params, ignoring anything not specified.
         *
         * For example:
         *
         * ```gjs live preview
         * import { Link } from 'ember-primitives';
         *
         * <template>
         *   <Link @href="/" @includeActiveQueryParams={{true}} as |a|>
         *     ...
         *   </Link>
         * </template>
         * ```
         *
         * the data-active state here will only be "true" on
         * - `/`
         * - `/?foo=2`
         * - `/?foo=&bar=`
         *
         */
        includeActiveQueryParams?: true | string[];
        /**
         * When calculating the "active" state of the link, you may decide
         * whether or not you want to consider sub paths to be active when
         * child routes/urls are active.
         *
         * For example:
         *
         * ```gjs live preview
         * import { Link } from 'ember-primitives';
         *
         * <template>
         *   <Link @href="/forum/1" @activeOnSubPaths={{true}} as |a|>
         *     ...
         *   </Link>
         * </template>
         * ```
         *
         * the data-active state here will be "true" on
         * - `/forum/1`
         * - `/forum/1/posts`
         * - `/forum/1/posts/comments`
         * - `/forum/1/*etc*`
         *
         * if `@activeOnSubPaths` is set to false or left off
         * the data-active state here will only be "true" on
         * - `/forum/1`
         *
         */
        activeOnSubPaths?: true;
    };
    Blocks: {
        default: [
            {
                /**
                 * Indicates if the passed `href` is pointing to an external site.
                 * Useful if you want your links to have additional context for when
                 * a user is about to leave your site.
                 *
                 * For example:
                 *
                 * ```gjs live preview
                 * import { Link } from 'ember-primitives';
                 *
                 * const MyLink = <template>
                 *   <Link @href={{@href}} as |a|>
                 *     {{yield}}
                 *     {{#if a.isExternal}}
                 *       ➚
                 *     {{/if}}
                 *   </Link>
                 * </template>;
                 *
                 * <template>
                 *   <MyLink @href="https://developer.mozilla.org">MDN</MyLink> &nbsp;&nbsp;
                 *   <MyLink @href="/">Home</MyLink>
                 *  </template>
                 * ```
                 */
                isExternal: boolean;
                /**
                 * Indicates if the passed `href` is *active*, or the user is on the same basepath.
                 * This allows consumers to style their link if they wish or style their text.
                 * The active state will also be present on a `data-active` attribute on the generated anchor tag.
                 *
                 *
                 * For example
                 * ```gjs
                 * import { Link, service } from 'ember-primitives';
                 *
                 * const MyLink = <template>
                 *   <Link @href="..."> as |a|>
                 *     <span class="{{if a.isActive 'underline'}}">
                 *     {{yield}}
                 *     </span>
                 *   </Link>
                 * </template>
                 *
                 * <template>
                 * {{#let (service 'router') as |router|}}
                 *     <MyLink @href={{router.currentURL}}>Ths page</MyLink> &nbsp;&nbsp;
                 *     <MyLink @href="/">Home</MyLink>
                 *   {{/let}}
                 *  </template>
                 * ```
                 *
                 * By default, the query params are omitted from `isActive` calculation, but you may
                 * configure the query params to be included if you wish
                 * See: `@includeActiveQueryParams`
                 *
                 * By default, only the exact route/url is considered for the `isActive` calculation,
                 * but you may configure sub routes/paths to also be considered active
                 * See: `@activeOnSubPaths`
                 *
                 * Note that external links are never active.
                 */
                isActive: boolean;
            }
        ];
    };
}
/**
 * A light wrapper around the [Anchor element][mdn-a], which will appropriately make your link an external link if the passed `@href` is not on the same domain.
 *
 *
 * [mdn-a]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a
 */
export declare const Link: TOC<Signature>;
export default Link;
//# sourceMappingURL=link.d.ts.map