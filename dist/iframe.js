/**
 * Returns true if the current frame is within an iframe.
 *
 * ```gjs
 * import { inIframe } from 'ember-primitives/iframe';
 *
 * <template>
 *   {{#if (inFrame)}}
 *     only show content in an iframe
 *   {{/if}}
 * </template>
 * ```
 */
const inIframe = () => window.self !== window.top;

/**
 * Returns true if the current frame is not within an iframe.
 *
 * ```gjs
 * import { notInIframe } from 'ember-primitives/iframe';
 *
 * <template>
 *   {{#if (notInIframe)}}
 *     only show content when not in an iframe
 *     This is also the default if your site/app
 *     does not use iframes
 *   {{/if}}
 * </template>
 * ```
 */
const notInIframe = () => !inIframe();

export { inIframe, notInIframe };
//# sourceMappingURL=iframe.js.map
