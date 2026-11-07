import "./theme-toggle.css"
import "./index-page.css"
import "./site-css/site.css"
import "./site-css/components.css"
import "./site-css/featured-demo.css"
import "./site-css/shiki.css"
import "./site-css/shell.css"
import "./site-css/prose.css"
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';
import { LightBulb, Menu, Sun, Moon } from './icons.js';
import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';
import { PageNav, Page } from 'kolay/components';
import { ExternalLink } from 'ember-primitives/components/external-link';
import MenuWrapper from 'ember-mobile-menu/components/mobile-menu-wrapper';
import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { sentenceCase } from 'change-case';
import { service, link } from 'ember-primitives/helpers';
import { getAnchor } from 'should-handle-link';
import { Switch } from 'ember-primitives';
import { colorScheme } from 'ember-primitives/color-scheme';
import { Hero } from 'ember-primitives/layout/hero';
import 'ember-mobile-menu/themes/android';

const Article = setComponentTemplate(precompileTemplate("<article class=\"prose\" ...attributes>\n  {{yield}}\n</article>", {
  strictMode: true
}), templateOnly());

const Callout = setComponentTemplate(precompileTemplate("<div class=\"callout\">\n  <LightBulb class=\"callout__icon\" />\n  <div class=\"callout__body\">\n    <div class=\"callout__content\">\n      {{yield}}\n    </div>\n  </div>\n</div>\n\n<style scoped>\n  .callout {\n    display: flex;\n    padding: 1.5rem;\n    margin-top: 2rem;\n    margin-bottom: 2rem;\n    border-radius: 1.5rem;\n    background-color: #f0f9ff;\n  }\n\n  :is(html[style*=\"color-scheme: dark\"]) .callout {\n    background-color: rgb(30 41 59 / 0.6);\n    outline: 1px solid rgb(203 213 225 / 0.1);\n  }\n\n  .callout__icon {\n    flex: none;\n    width: 2rem;\n    height: 2rem;\n  }\n\n  .callout__body {\n    flex: 1 1 auto;\n    min-width: 0;\n    margin-left: 1rem;\n  }\n\n  .callout__content {\n    color: #075985;\n  }\n\n  .callout__content > *:first-child {\n    margin-top: 0;\n  }\n\n  .callout__content > *:last-child {\n    margin-bottom: 0;\n  }\n\n  :is(html[style*=\"color-scheme: dark\"]) .callout__content {\n    color: #f8fafc;\n  }\n</style>", {
  strictMode: true,
  scope: () => ({
    LightBulb
  })
}), templateOnly());

const InternalLink = setComponentTemplate(precompileTemplate("<a class=\"styled-link\" href=\"#\" ...attributes>\n  {{yield}}\n</a>", {
  strictMode: true
}), templateOnly());
const Link = setComponentTemplate(precompileTemplate("<ExternalLink class=\"styled-link\" ...attributes>\n  {{yield}}\n</ExternalLink>", {
  strictMode: true,
  scope: () => ({
    ExternalLink
  })
}), templateOnly());

function fixWords(text) {
  switch (text.toLowerCase()) {
    case 'ui':
      return 'UI';
    case 'iframe':
      return 'IFrame';
    default:
      return text;
  }
}
/**
 * Converts 1-2-hyphenated-thing
 * to
 *   Hyphenated Thing
 */
const titleize = str => {
  return str.split(/-|\s/).filter(Boolean).filter(text => !text.match(/^[\d]+$/)).map(text => `${text[0]?.toLocaleUpperCase()}${text.slice(1, text.length)}`).map(text => fixWords(text)).join(' ').split('.')[0] || '';
};
function nameFor(x) {
  if ('componentName' in x) {
    return String(x.componentName);
  }
  const page = x;
  return page.title ? page.title : sentenceCase(page.name);
}
const asComponent = str => {
  return `<${str.split('.')[0]?.replaceAll(' ', '')} />`;
};
/**
 * Docs pages are reachable both with and without their file extension
 * (prose cross-links produce `/2-usage/data.md`, while the nav's own
 * hrefs are extension-less), and collection index pages are reachable
 * at both `/2-usage` and `/2-usage/index`. Normalize both sides before
 * comparing, so the nav highlight survives however the reader got to
 * the page.
 */
function isActivePath(currentURL, href) {
  if (!currentURL) return false;
  const normalize = path => (path.split('?')[0] ?? '').replace(/\.gjs\.md$|\.gjs$|\.md$/, '').replace(/\/index$/, '').replace(/\/$/, '');
  return normalize(currentURL) === normalize(href);
}
const isComponents = str => str === 'components';
const SectionLink = setComponentTemplate(precompileTemplate("{{#let (link @href) (getService \"router\") as |l router|}}\n  <a href={{@href}} class=\"section-link {{if (isActivePath router.currentURL @href) \"is-active\"}}\" {{on \"click\" l.handleClick}} ...attributes>\n    {{#if (isComponents @name)}}\n      {{asComponent (titleize @name)}}\n    {{else}}\n      {{titleize @name}}\n    {{/if}}\n  </a>\n{{/let}}", {
  strictMode: true,
  scope: () => ({
    link,
    getService: service,
    isActivePath,
    on,
    isComponents,
    asComponent,
    titleize
  })
}), templateOnly());
const SubSectionLink = setComponentTemplate(precompileTemplate("{{#let (link @href) (getService \"router\") as |l router|}}\n  <a href={{@href}} class=\"subsection-link {{if (isActivePath router.currentURL @href) \"is-active\"}}\" {{on \"click\" l.handleClick}} ...attributes>\n    {{#if (isComponents @name)}}\n      {{asComponent (titleize @name)}}\n    {{else}}\n      {{titleize @name}}\n    {{/if}}\n  </a>\n{{/let}}", {
  strictMode: true,
  scope: () => ({
    link,
    getService: service,
    isActivePath,
    on,
    isComponents,
    asComponent,
    titleize
  })
}), templateOnly());
class SideNav extends Component {
  closeNav = event => {
    if (!getAnchor(event)) return;
    this.args.onClick?.();
  };
  /**
  *
  * This nav needs an aria-label to get around
  *  "Ensure landmarks are unique"
  *  because some demos render navs, and it's important that those
  *  demos are as simple as possible.
  *
  *
  *  nav isn't actually made in to an interactive element,
  *  it's an event delegation handler.
  *  The links themselves remain the actual interactive elements.
  */
  static {
    setComponentTemplate(precompileTemplate("<aside class=\"side-nav\" ...attributes>\n  <PageNav aria-label=\"Main Navigation\">\n    <:page as |x|>\n      <SubSectionLink @href={{x.page.path}} @name={{nameFor x.page}} {{on \"click\" this.closeNav}} />\n    </:page>\n\n    <:collection as |x|>\n      {{#if x.index}}\n        <SectionLink @href={{x.index.page.path}} @name={{titleize x.collection.name}} {{on \"click\" this.closeNav}} />\n      {{else}}\n        <h2>\n          {{titleize x.collection.name}}\n        </h2>\n      {{/if}}\n    </:collection>\n  </PageNav>\n</aside>\n\n<style scoped>\n  .side-nav {\n    background-color: white;\n  }\n\n  .side-nav ul {\n    list-style: none;\n    margin: 0;\n    padding: 0;\n  }\n\n  .side-nav h2 {\n    font-size: 1rem;\n    font-weight: 500;\n    font-family: var(--font-display, \"Helvetica\", \"Arial\", sans-serif);\n    color: #0f172a;\n    margin: 0;\n  }\n\n  :is(html[style*=\"color-scheme: dark\"]) .side-nav h2 {\n    color: white;\n  }\n\n  :is(html[style*=\"color-scheme: dark\"]) .side-nav {\n    background-color: #02020e;\n  }\n\n  .section-link {\n    font-weight: 500;\n    font-family: var(--font-display, \"Helvetica\", \"Arial\", sans-serif);\n    color: #0f172a;\n  }\n\n  :is(html[style*=\"color-scheme: dark\"]) .section-link {\n    color: white;\n  }\n\n  .section-link:hover {\n    color: #475569;\n  }\n\n  :is(html[style*=\"color-scheme: dark\"]) .section-link:hover {\n    color: #cbd5e1;\n  }\n\n  .section-link.is-active {\n    color: #0ea5e9;\n  }\n\n  .subsection-link {\n    display: block;\n    width: 100%;\n    position: relative;\n    color: #64748b;\n  }\n\n  .subsection-link::before {\n    content: \"\";\n    pointer-events: none;\n    position: absolute;\n    left: -0.25rem;\n    top: 50%;\n    height: 0.375rem;\n    width: 0.375rem;\n    transform: translateY(-50%);\n    border-radius: 9999px;\n    background-color: #cbd5e1;\n    display: none;\n  }\n\n  .subsection-link:hover {\n    color: #475569;\n  }\n\n  .subsection-link:hover::before {\n    display: block;\n  }\n\n  :is(html[style*=\"color-scheme: dark\"]) .subsection-link {\n    color: #94a3b8;\n  }\n\n  :is(html[style*=\"color-scheme: dark\"]) .subsection-link::before {\n    background-color: #334155;\n  }\n\n  :is(html[style*=\"color-scheme: dark\"]) .subsection-link:hover {\n    color: #cbd5e1;\n  }\n\n  .subsection-link.is-active {\n    font-weight: 600;\n    color: #0ea5e9;\n  }\n</style>", {
      strictMode: true,
      scope: () => ({
        PageNav,
        SubSectionLink,
        nameFor,
        on,
        SectionLink,
        titleize
      })
    }), this);
  }
}

// @ts-expect-error - no types are provided for ember-mobile-menu

const Toggle = setComponentTemplate(precompileTemplate("<@toggle>\n  <Menu style=\"width: 1.5rem; height: 1.5rem; stroke: #64748b;\" />\n</@toggle>", {
  strictMode: true,
  scope: () => ({
    Menu
  })
}), templateOnly());
const ResponsiveMenuLayout = setComponentTemplate(precompileTemplate("<MenuWrapper as |mmw|>\n  <mmw.MobileMenu @mode=\"push\" @maxWidth={{300}} as |mm|>\n    <SideNav @onClick={{mm.actions.close}} />\n  </mmw.MobileMenu>\n\n  <mmw.Content>\n    {{yield (component Toggle toggle=mmw.Toggle) to=\"header\"}}\n\n    <div class=\"outer-content\">\n      <SideNav />\n\n      <main class=\"page-main\">\n        {{yield to=\"content\"}}\n      </main>\n    </div>\n  </mmw.Content>\n</MenuWrapper>\n\n<style scoped>\n  .page-main {\n    position: relative;\n    display: grid;\n    justify-content: center;\n    flex: 1 1 auto;\n    width: 100%;\n    margin-left: auto;\n    margin-right: auto;\n    max-width: 88rem;\n  }\n</style>", {
  strictMode: true,
  scope: () => ({
    MenuWrapper,
    SideNav,
    Toggle
  })
}), templateOnly());

;

function toggleTheme() {
  if (colorScheme.current === 'dark') {
    colorScheme.update('light');
  } else {
    colorScheme.update('dark');
  }
}
function isDark() {
  return colorScheme.current === 'dark';
}
const ThemeToggle = setComponentTemplate(precompileTemplate("<Switch class=\"site-theme-toggle\" as |s|>\n  <s.Control name=\"color-scheme\" checked={{(isDark)}} {{on \"change\" toggleTheme}} />\n  <s.Label>\n    <span class=\"sr-only\">Toggle between light and dark mode</span>\n    {{!--\n      \uD83C\uDFB5 It's raining, it's pouring, ... \uD83C\uDFB5\n      https://www.youtube.com/watch?v=ll5ykbAumD4\n    --}}\n    <Moon style=\"fill: #38bdf8;\" />\n    <Sun style=\"fill: #facc15;\" />\n    <span class=\"ball\"></span>\n  </s.Label>\n</Switch>", {
  strictMode: true,
  scope: () => ({
    Switch,
    isDark,
    on,
    toggleTheme,
    Moon,
    Sun
  })
}), templateOnly());

function removeLoader() {
  document.querySelector('#initial-loader')?.remove();
}
function resetScroll(..._args) {
  document.querySelector('html')?.scrollTo(0, 0);
}
const isScrolled = cell(false);
const onWindowScroll = modifier(() => {
  function onScroll() {
    isScrolled.current = window.scrollY > 0;
  }
  onScroll();
  window.addEventListener('scroll', onScroll, {
    passive: true
  });
  return () => {
    window.removeEventListener('scroll', onScroll);
  };
});
const PageLoader = setComponentTemplate(precompileTemplate("<div class=\"loading-page\" role=\"status\">\n  {{yield}}\n</div>\n\n<style>\n  @keyframes shimmer {\n    0% {\n      background-position: -1000px 0;\n    }\n    100% {\n      background-position: 1000px 0;\n    }\n  }\n\n  .loading-page {\n    position: fixed;\n    top: 0rem;\n    padding: 0.5rem 1rem;\n    background: linear-gradient(\n      90deg,\n      rgba(40, 40, 50, 0.9),\n      rgba(60, 60, 70, 0.9),\n      rgba(40, 40, 50, 0.9)\n    );\n    background-size: 1000px 100%;\n    animation: shimmer 2s infinite;\n    filter: drop-shadow(0 0.5rem 0.5rem rgba(0, 0, 0, 0.8));\n    color: white;\n    right: 0;\n    width: 100%;\n    border-bottom-left-radius: 0.25rem;\n    border-bottom-right-radius: 0.25rem;\n  }\n\n  @media (prefers-reduced-motion: reduce) {\n    .loading-page {\n      animation: shimmer 10s infinite;\n    }\n  }\n</style>", {
  strictMode: true
}), templateOnly());
function hasReason(error) {
  return typeof error === 'object' && error !== null && 'reason' in error && typeof error.reason === 'string';
}
const PageError = setComponentTemplate(precompileTemplate("<div class=\"error\" data-page-error role=\"alert\">\n  {{#if (hasReason @error)}}\n    {{@error.reason}}\n    <details>\n      <summary>Original error</summary>\n      <pre>{{@error.original.stack}}</pre>\n    </details>\n  {{else}}\n    {{@error}}\n  {{/if}}\n</div>", {
  strictMode: true,
  scope: () => ({
    hasReason
  })
}), templateOnly());
const PageLayout = setComponentTemplate(precompileTemplate("<ResponsiveMenuLayout>\n  <:header as |Toggle|>\n    <header class=\"page-header {{if isScrolled.current \"is-scrolled\"}}\" {{onWindowScroll}}>\n      <div class=\"outer-content page-header__inner\">\n        <div class=\"page-header__toggle\">\n          <Toggle />\n        </div>\n        <div class=\"page-header__logo\">\n          <a href=\"/\" aria-label=\"Home page\">\n            {{yield to=\"logoLink\"}}\n          </a>\n        </div>\n        <TopRight>\n          {{yield to=\"topRight\"}}\n        </TopRight>\n      </div>\n    </header>\n  </:header>\n  <:content>\n    <section data-main-scroll-container class=\"page-content\">\n      <Article>\n        <Page>\n          <:pending>\n            <PageLoader>\n              Loading, Compiling, etc\n            </PageLoader>\n          </:pending>\n\n          <:error as |error|>\n            <section>\n              {{yield error to=\"error\"}}\n            </section>\n          </:error>\n\n          <:success as |prose|>\n            <prose />\n            {{(removeLoader)}}\n            {{resetScroll prose}}\n          </:success>\n        </Page>\n      </Article>\n\n      {{#if (has-block \"editLink\")}}\n\n        <div class=\"edit-link-container\">\n\n          {{yield EditLink to=\"editLink\"}}\n        </div>\n      {{/if}}\n    </section>\n  </:content>\n\n</ResponsiveMenuLayout>\n\n<style scoped>\n  .page-header {\n    position: sticky;\n    top: 0;\n    z-index: 50;\n    transition: all 0.5s;\n    box-shadow: 0 4px 6px -1px rgb(15 23 42 / 0.05);\n    background-color: rgb(255 255 255 / 0.95);\n  }\n\n  :is(html[style*=\"color-scheme: dark\"]) .page-header {\n    box-shadow: none;\n    background-color: rgb(2 2 14 / 0.95);\n  }\n\n  :is(html[style*=\"color-scheme: dark\"]) .page-header.is-scrolled {\n    backdrop-filter: blur(12px);\n  }\n\n  @supports (backdrop-filter: blur(0)) {\n    :is(html[style*=\"color-scheme: dark\"]) .page-header.is-scrolled {\n      background-color: rgb(2 2 14 / 0.75);\n    }\n  }\n\n  .page-header__inner {\n    display: flex;\n    flex: none;\n    flex-wrap: wrap;\n    align-items: center;\n    justify-content: space-between;\n    padding-top: 1rem;\n    padding-bottom: 1rem;\n  }\n\n  .page-header__toggle {\n    display: flex;\n    margin-right: 1.5rem;\n  }\n\n  @media (min-width: 1024px) {\n    .page-header__toggle {\n      display: none;\n    }\n  }\n\n  .page-header__logo {\n    position: relative;\n    display: flex;\n    align-items: center;\n    flex-grow: 1;\n    flex-basis: 0;\n  }\n\n  .page-content {\n    flex: 1 1 auto;\n    max-width: 42rem;\n    min-width: 0;\n    padding-top: 1rem;\n    padding-bottom: 1rem;\n  }\n\n  @media (min-width: 1024px) {\n    .page-content {\n      max-width: none;\n    }\n  }\n\n  .edit-link-container {\n    display: flex;\n    justify-content: flex-end;\n    padding-top: 1.5rem;\n    margin-top: 3rem;\n    border-top: 1px solid #e2e8f0;\n  }\n\n  :is(html[style*=\"color-scheme: dark\"]) .edit-link-container {\n    border-color: #1e293b;\n  }\n</style>", {
  strictMode: true,
  scope: () => ({
    ResponsiveMenuLayout,
    isScrolled,
    onWindowScroll,
    TopRight,
    Article,
    Page,
    PageLoader,
    removeLoader,
    resetScroll,
    EditLink
  })
}), templateOnly());
const EditLink = setComponentTemplate(precompileTemplate("<Link class=\"edit-page\" style=\"display: flex;\" href={{@href}}>\n  {{yield}}\n</Link>", {
  strictMode: true,
  scope: () => ({
    Link
  })
}), templateOnly());
const TopRight = setComponentTemplate(precompileTemplate("<div class=\"top-right\">\n  <ThemeToggle />\n  {{yield}}\n</div>\n\n<style scoped>\n  .top-right {\n    position: relative;\n    display: flex;\n    justify-content: flex-end;\n    gap: 1.5rem;\n    flex-basis: 0;\n  }\n\n  @media (min-width: 640px) {\n    .top-right {\n      gap: 2rem;\n    }\n  }\n\n  @media (min-width: 768px) {\n    .top-right {\n      flex-grow: 1;\n    }\n  }\n</style>", {
  strictMode: true,
  scope: () => ({
    ThemeToggle
  })
}), templateOnly());

const OopsError = setComponentTemplate(precompileTemplate("<div data-page-error class=\"adaptive-text\" style=\"border: 1px solid red; padding: 1rem; word-break: break-all;\">\n  <h1>Oops!</h1><br />\n  <PageError @error={{@error}} />\n\n  <br />\n  <br />\n  {{yield}}\n</div>\n\n<style scoped>\n  .adaptive-text {\n    color: #0f172a;\n  }\n  :is(html[style*=\"color-scheme: dark\"]) .adaptive-text {\n    color: white;\n  }\n</style>", {
  strictMode: true,
  scope: () => ({
    PageError
  })
}), templateOnly());

const H2 = setComponentTemplate(precompileTemplate("<h2 style=\"font-size: 1.875rem; line-height: 2.25rem;\">{{yield}}</h2>", {
  strictMode: true
}), templateOnly());

;

const IndexPage = setComponentTemplate(precompileTemplate("<Hero class=\"index-hero gradient-background\">\n  <header class=\"index-hero__header\">\n    {{yield to=\"header\"}}\n  </header>\n\n  <div class=\"index-hero__body\">\n    <div style=\"width: 66%; margin: 0 auto; transform: translateY(-20%);\" class=\"index-hero__grid\">\n      <h1 style=\"filter: drop-shadow(3px 5px 0px rgba(0, 0, 0, 0.4));\">\n        {{yield to=\"logo\"}}\n      </h1>\n      <p class=\"index-hero__tagline\">\n        {{yield to=\"tagline\"}}\n      </p>\n    </div>\n    {{yield to=\"callToAction\"}}\n  </div>\n</Hero>\n\n{{yield to=\"content\"}}\n\n<hr />\n<footer style=\"padding: 3rem; width: 66%;\" class=\"index-footer\">\n  {{yield to=\"footer\"}}\n</footer>\n\n<style scoped>\n  .index-hero {\n    box-shadow: 0 10px 15px -3px rgb(15 23 42 / 0.05);\n  }\n\n  .index-hero__header {\n    position: absolute;\n    right: 0;\n    bottom: 0;\n    z-index: 50;\n    padding: 1rem;\n    display: flex;\n    align-items: center;\n  }\n\n  @media (min-width: 768px) {\n    .index-hero__header {\n      position: sticky;\n      top: 0;\n    }\n  }\n\n  .index-hero__body {\n    height: 100%;\n    display: flex;\n    flex-direction: column;\n    gap: 2rem;\n    justify-content: center;\n    align-items: center;\n  }\n\n  .index-hero__grid {\n    display: grid;\n    gap: 1rem;\n  }\n\n  .index-hero__tagline {\n    font-style: italic;\n    color: white;\n    width: 100%;\n    margin-left: auto;\n    margin-right: auto;\n  }\n\n  @media (min-width: 768px) {\n    .index-hero__tagline {\n      width: 50%;\n    }\n  }\n\n  .index-footer {\n    margin-left: auto;\n    margin-right: auto;\n    gap: 3rem;\n    flex-wrap: wrap;\n    display: flex;\n    justify-content: space-between;\n  }\n</style>", {
  strictMode: true,
  scope: () => ({
    Hero
  })
}), templateOnly());

;

;

;

;

;

;

const Shell = setComponentTemplate(precompileTemplate("{{(syncBodyClass)}}\n{{yield}}", {
  strictMode: true,
  scope: () => ({
    syncBodyClass
  })
}), templateOnly());
function syncBodyClass() {
  if (colorScheme.isDark) {
    document.body.classList.add('dark');
    document.body.classList.add('theme-dark');
    document.body.classList.remove('theme-light');
    document.body.classList.remove('light');
  } else {
    document.body.classList.remove('theme-dark');
    document.body.classList.remove('dark');
    document.body.classList.add('theme-light');
    document.body.classList.add('light');
  }
}

const Text = setComponentTemplate(precompileTemplate("<span class=\"adaptive-text\">{{yield}}</span>\n\n<style scoped>\n  .adaptive-text {\n    color: #0f172a;\n  }\n  :is(html[style*=\"color-scheme: dark\"]) .adaptive-text {\n    color: white;\n  }\n</style>", {
  strictMode: true
}), templateOnly());

export { Article, Callout, H2, IndexPage, InternalLink, Link, OopsError, PageError, PageLayout, PageLoader, ResponsiveMenuLayout, Shell, Text, ThemeToggle, TopRight, hasReason };
//# sourceMappingURL=index.js.map
