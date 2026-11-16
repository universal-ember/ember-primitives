import { GitHubLink, TestsLink } from 'docs-app/components/header';
import { Logo } from 'docs-app/components/icons';
import { ExternalLink } from 'ember-primitives/components/external-link';

import { IndexPage, InternalLink, Link, TopRight } from '@universal-ember/docs-support';
import {
  BlueSky,
  Discord,
  GitHub,
  Mastodon,
  Threads,
  XTwitter,
} from '@universal-ember/docs-support/icons';

type FeaturePart = {
  href?: string;
  label?: string;
  text?: string;
};

type Feature = {
  text?: string;
  parts?: FeaturePart[];
};

const FEATURES: Feature[] = [
  { text: 'Accessibility as a first class concern' },
  { text: 'Composes with your design system' },
  {
    parts: [{ href: 'https://tabster.io/', label: 'Tabster' }, { text: ' integration' }],
  },
  { text: 'Fully Documented' },
  { text: 'Built by experienced Ember contributors' },
  { text: 'Built on top of platform primitives' },
  { text: 'Headless, bring your own styles' },
  { text: 'Own the code, install into your codebase' },
];

type WorthLookingAt = {
  href: string;
  name: string;
  desc: string;
  tone: string;
  by?: string;
};

const WORTH_LOOKING_AT: WorthLookingAt[] = [
  {
    href: 'https://github.com/nullVoxPopuli/form-data-utils',
    name: 'form-data-utils',
    desc: 'Utilities for working with FormData.',
    tone: 'magenta',
  },
  {
    href: 'https://github.com/NullVoxPopuli/should-handle-link',
    name: 'should-handle-link',
    desc: 'Utilities for managing native link clicks in single-page apps.',
    tone: 'green',
  },
  {
    href: 'https://github.com/universal-ember/test-support',
    name: '@universal-ember/test-support',
    desc: 'Extra helpers for testing.',
    tone: 'orange',
  },
  {
    href: 'https://github.com/universal-ember/reactiveweb',
    name: 'reactiveweb',
    desc: 'Reactive utilities used in some components.',
    tone: 'blue',
  },
  {
    href: 'https://github.com/nickschot/ember-mobile-menu',
    name: 'ember-mobile-menu',
    by: '@nickschot',
    desc: 'Draggable mobile sidebars - used in these docs.',
    tone: 'violet',
  },
  {
    href: 'https://github.com/ijlee2/ember-container-query',
    name: 'ember-container-query',
    by: '@ijlee2',
    desc: 'Respond to an element’s size - still no native JS API for this.',
    tone: 'cyan',
  },
];

<template>
  <IndexPage>
    <:logo>
      <Logo />
    </:logo>
    <:header>
      <TopRight>
        <TestsLink />
        <GitHubLink />
      </TopRight>
    </:header>
    <:tagline>
      <span class="index-hero__text">picking up where<br />the framework left off</span>
      <span class="index-hero__lead">
        Headless, styleless, accessibility-focused implementations of components, patterns, and
        utilities to help make building apps faster.
      </span>
    </:tagline>
    <:callToAction>
      <InternalLink href="/1-get-started/index.md" class="doc-button doc-button--primary">
        Get Started
      </InternalLink>
      <Link
        href="https://github.com/universal-ember/ember-primitives"
        class="doc-button doc-button--alt"
      >GitHub</Link>
    </:callToAction>
    <:content>
      <div class="home-body">
        <section class="home-section home-section--features" aria-label="Features">
          <ul class="home-features">
            {{#each FEATURES as |feature|}}
              <li class="home-feature">
                <span>
                  {{#if feature.parts}}
                    {{#each feature.parts as |part|}}
                      {{#if part.href}}
                        <Link href={{part.href}} class="home-link">{{part.label}}</Link>
                      {{else}}
                        {{part.text}}
                      {{/if}}
                    {{/each}}
                  {{else}}
                    {{feature.text}}
                  {{/if}}
                </span>
              </li>
            {{/each}}
          </ul>

          <div class="home-giants">
            <h2 class="home-section__title">Building on the backs of giants</h2>
            <ul class="home-stack">
              <li class="home-stack__item">
                <p class="home-stack__title">
                  <Link href="https://developer.mozilla.org/en-US/docs/Web" class="home-link">The
                    Platform</Link>
                </p>
                <p class="home-copy">
                  When possible, the platform should be used instead of custom implementations. When
                  applicable, the docs call out what and how to use each relevant part of the
                  platform.
                </p>
              </li>
              <li class="home-stack__item">
                <p class="home-stack__title">
                  <Link href="https://floating-ui.com/" class="home-link">@floating-ui/dom</Link>
                </p>
                <p class="home-copy">
                  Used for positioning floating elements. Will be replaced by
                  <Link
                    href="https://w3c.github.io/csswg-drafts/css-anchor-position/"
                    class="home-link"
                  >CSS Anchor Position</Link>
                  when that lands.
                </p>
              </li>
              <li class="home-stack__item">
                <p class="home-stack__title">
                  <Link href="https://tabster.io/" class="home-link">tabster</Link>
                </p>
                <p class="home-copy">
                  Used for managing roving focus in menus or menu-like patterns.
                </p>
              </li>
            </ul>
          </div>
        </section>

        <section class="home-section" aria-label="Overview">
          <div class="home-cards">
            <article class="home-card">
              <h2 class="home-section__title">Goals</h2>
              <ol class="home-list home-list--numbered">
                <li>high-quality components and utilities</li>
                <li>pay for only what you import</li>
                <li>pure data derivation</li>
                <li>no extra rendering</li>
                <li>no unneeded DOM</li>
                <li>be contextually aware</li>
                <li>be flexible</li>
                <li>use the latest technology</li>
              </ol>
            </article>

            <article class="home-card">
              <h2 class="home-section__title">Acknowledgements</h2>
              <p class="home-section__lede">Inspiration and code adapted from</p>
              <ul class="home-list home-list--links home-inspire">
                <li>
                  <Link href="https://primitives.solidjs.community/" class="home-link">Solid
                    primitives</Link>
                </li>
                <li>
                  <Link
                    href="https://www.radix-ui.com/primitives/docs/overview/introduction"
                    class="home-link"
                  >radix primitives</Link>
                </li>
                <li>
                  <Link
                    href="https://kobalte.dev/docs/core/overview/introduction"
                    class="home-link"
                  >Kobalte</Link>
                </li>
                <li>
                  <Link href="https://svelte-ux.techniq.dev/" class="home-link">Svelte UX</Link>
                </li>
                <li>
                  <Link href="https://quasar.dev/" class="home-link">Quasar</Link>
                </li>
                <li>
                  <Link href="https://www.bits-ui.com/docs/introduction" class="home-link">Bits UI</Link>
                </li>
                <li>
                  <Link href="https://ariakit.org/" class="home-link">AriaKit</Link>
                </li>
                <li>
                  <Link href="https://react-spectrum.adobe.com/react-aria/" class="home-link">React
                    Aria</Link>
                </li>
                <li>
                  <Link
                    href="https://ui.shadcn.com/docs/components/accordion"
                    class="home-link"
                  >ShadCN</Link>
                </li>
              </ul>
            </article>

            <article class="home-card">
              <h2 class="home-section__title">Projects using this...</h2>
              <ul class="home-list home-list--links">
                <li>
                  <Link href="https://optro.ai" class="home-link">Optro</Link>
                </li>
                <li>
                  <Link href="https://majors.nullvoxpopuli.com/" class="home-link">Package Majors</Link>
                </li>
                <li>
                  <Link href="https://game-of-life.nullvoxpopuli.com/" class="home-link">Conway's
                    Game of Life</Link>
                </li>
                <li>
                  <Link href="https://tutorial.glimdown.com" class="home-link">Tutorial</Link>
                </li>
                <li>
                  <Link href="https://limber.glimdown.com" class="home-link">REPL, Limber</Link>
                </li>
                <li>
                  <Link
                    href="https://github.com/universal-ember/ember-primitives/edit/main/docs-app/app/templates/index.gts"
                    class="home-link home-link--accent"
                  >Add yours, submit a PR!</Link>
                </li>
              </ul>
            </article>
          </div>
        </section>

        <section class="home-section home-section--deps" aria-labelledby="home-deps">
          <p id="home-deps" class="home-footer-label">Dependencies worth looking at</p>

          <div
            class="home-marquee"
            role="region"
            aria-label="Related projects"
            aria-describedby="home-deps"
          >
            <div class="home-marquee__viewport">
              <ul class="home-marquee__track">
                {{#each WORTH_LOOKING_AT as |item|}}
                  <li>
                    <Link href={{item.href}} class="home-chip home-chip--{{item.tone}}">
                      <span class="home-chip__name">{{item.name}}</span>
                      {{#if item.by}}
                        <span class="home-chip__by">{{item.by}}</span>
                      {{/if}}
                      <span class="home-chip__desc">{{item.desc}}</span>
                    </Link>
                  </li>
                {{/each}}
              </ul>
              <ul class="home-marquee__track" aria-hidden="true">
                {{#each WORTH_LOOKING_AT as |item|}}
                  <li>
                    <Link
                      href={{item.href}}
                      class="home-chip home-chip--{{item.tone}}"
                      tabindex="-1"
                    >
                      <span class="home-chip__name">{{item.name}}</span>
                      {{#if item.by}}
                        <span class="home-chip__by">{{item.by}}</span>
                      {{/if}}
                      <span class="home-chip__desc">{{item.desc}}</span>
                    </Link>
                  </li>
                {{/each}}
              </ul>
            </div>
          </div>
        </section>
      </div>
    </:content>

    <:footer>
      <div class="home-footer">
        <div class="home-footer__follow">
          <p class="home-footer-label">Follow</p>
          <Socials />
        </div>
      </div>
    </:footer>
  </IndexPage>

  <style>
    .home-body {
      --home-link: var(--home-brand-1, #e04e39);
      --home-link-hover: var(--home-brand-2, #c93f2d);
      --home-link-size: 0.9375rem;
      box-sizing: border-box;
      width: min(100%, var(--home-max, 72rem));
      max-width: 100%;
      margin-inline: auto;
      overflow-x: clip;
      padding-block: clamp(2rem, 5vw, 4rem) clamp(1.25rem, 3vw, 2.25rem);
      padding-inline: max(var(--home-gutter, 1.25rem), env(safe-area-inset-left, 0px))
        max(var(--home-gutter, 1.25rem), env(safe-area-inset-right, 0px));
    }

    .home-section + .home-section {
      margin-top: clamp(2.75rem, 5vw, 4rem);
    }

    .home-section__title {
      margin: 0;
      font-size: clamp(1.15rem, 1.05rem + 0.3vw, 1.35rem);
      font-weight: 700;
      line-height: 1.3;
      letter-spacing: -0.02em;
      color: var(--home-text-1, #0f172a);
    }

    .home-section__lede {
      margin: 0.5rem 0 0;
      color: var(--home-text-2, #64748b);
      font-size: 0.875rem;
      line-height: 1.55;
    }

    .home-section--features {
      display: grid;
      grid-template-columns: 1fr;
      gap: clamp(2rem, 4vw, 3rem);
      align-items: start;
    }

    @media (min-width: 960px) {
      .home-section--features {
        grid-template-columns: minmax(0, 1.05fr) minmax(0, 0.95fr);
        gap: clamp(2rem, 4vw, 3.5rem);
        padding-inline-end: 0.25rem;
      }

      .home-giants {
        padding-inline-start: clamp(1.5rem, 3vw, 2.5rem);
        border-inline-start: 1px solid var(--home-border, rgba(255, 255, 255, 0.08));
      }
    }

    .home-features {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 0.55rem;
      margin: 0;
      padding: 0;
      list-style: none;
    }

    @media (min-width: 520px) {
      .home-features {
        gap: 0.65rem;
      }
    }

    .home-feature {
      box-sizing: border-box;
      display: flex;
      align-items: center;
      justify-content: center;
      min-height: 3.75rem;
      min-width: 0;
      padding: 0.85rem 0.7rem;
      text-align: center;
      font-size: clamp(0.8125rem, 0.75rem + 0.35vw, 0.9375rem);
      font-weight: 600;
      line-height: 1.3;
      letter-spacing: -0.01em;
      color: var(--home-text-1, #f3f4f6);
      background: var(--home-soft, #202126);
      border: 1px solid var(--home-border, rgba(255, 255, 255, 0.06));
      border-radius: 0.65rem;
    }

    @media (min-width: 520px) {
      .home-feature {
        min-height: 4.5rem;
        padding: 1rem 1.1rem;
      }
    }

    .home-stack {
      display: flex;
      flex-direction: column;
      gap: 1.35rem;
      margin: 1.25rem 0 0;
      padding: 0;
      list-style: none;
    }

    .home-stack__item {
      margin: 0;
    }

    .home-stack__title {
      margin: 0 0 0.3rem;
      font-size: var(--home-link-size);
      font-weight: 600;
      line-height: 1.45;
    }

    .home-copy {
      margin: 0;
      color: var(--home-text-2, #9ca3af);
      font-size: 0.875rem;
      line-height: 1.6;
      text-wrap: pretty;
    }

    .home-cards {
      display: grid;
      grid-template-columns: 1fr;
      gap: 0.85rem;
      align-items: stretch;
    }

    @media (min-width: 860px) {
      .home-cards {
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 0.9rem;
      }
    }

    .home-card {
      box-sizing: border-box;
      min-width: 0;
      height: 100%;
      padding: 1.4rem 1.45rem 1.55rem;
      border-radius: 0.75rem;
      background: var(--home-soft, #202126);
      border: 1px solid var(--home-border, rgba(255, 255, 255, 0.06));
    }

    .home-list {
      display: flex;
      flex-direction: column;
      gap: 0.4rem;
      margin: 1rem 0 0;
      padding: 0;
      list-style: none;
      color: var(--home-text-2, #9ca3af);
      font-size: 0.875rem;
      line-height: 1.5;
    }

    .home-list--numbered {
      list-style: decimal;
      padding-inline-start: 1.25rem;
      gap: 0.35rem;
    }

    .home-list--numbered li {
      padding-inline-start: 0.15rem;
    }

    .home-list--links {
      gap: 0.25rem;
    }

    .home-list li {
      margin: 0;
    }

    .home-inspire {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 0.3rem 1rem;
    }

    .home-link {
      color: var(--home-link);
      font-size: inherit;
      font-weight: 600;
      line-height: inherit;
      text-decoration: none;
      transition: color 0.15s ease;
    }

    .home-link:hover {
      color: var(--home-link-hover);
      text-decoration: underline;
      text-underline-offset: 0.15em;
    }

    .home-link:focus-visible {
      outline: 2px solid var(--home-link);
      outline-offset: 3px;
      border-radius: 0.2rem;
    }

    .home-link--accent {
      color: var(--home-accent-blue, #6366f1);
    }

    .home-link--accent:hover {
      color: var(--home-accent-blue-hover, #818cf8);
    }

    .home-body a.styled-link,
    .home-footer a.styled-link,
    .index-hero__cta a.styled-link,
    :is(html[style*="color-scheme: dark"]) .home-body a.styled-link,
    :is(html[style*="color-scheme: dark"]) .home-footer a.styled-link,
    :is(html[style*="color-scheme: dark"]) .index-hero__cta a.styled-link {
      --link-prose-background: transparent;
      --link-prose-underline: transparent;
      box-shadow: none;
      font-size: inherit;
      line-height: inherit;
      font-weight: inherit;
      text-decoration: none;
    }

    .home-body a.styled-link.home-link,
    :is(html[style*="color-scheme: dark"]) .home-body a.styled-link.home-link {
      color: var(--home-link);
      font-weight: 600;
    }

    .home-body a.styled-link.home-link:hover,
    :is(html[style*="color-scheme: dark"]) .home-body a.styled-link.home-link:hover {
      color: var(--home-link-hover);
    }

    .home-body a.styled-link.home-link--accent,
    :is(html[style*="color-scheme: dark"]) .home-body a.styled-link.home-link--accent {
      color: var(--home-accent-blue, #6366f1);
    }

    .home-body a.styled-link.home-chip,
    :is(html[style*="color-scheme: dark"]) .home-body a.styled-link.home-chip {
      color: inherit;
      box-shadow: none;
      text-decoration: none;
      font-weight: inherit;
      background-image: none;
    }

    .home-section--deps {
      padding-top: 0.25rem;
    }

    .home-footer-label {
      display: block;
      margin: 0 0 1rem;
      font-size: 0.75rem;
      font-weight: 700;
      letter-spacing: 0.1em;
      text-transform: uppercase;
      color: var(--home-text-3, #6b7280);
    }

    .home-marquee {
      --marquee-gap: 0.75rem;
      --marquee-duration: 42s;
      position: relative;
      box-sizing: border-box;
      max-width: 100%;
      overflow: hidden;
      margin-inline: calc(-1 * max(var(--home-gutter, 1.25rem), env(safe-area-inset-left, 0px)));
      width: calc(
        100% + max(var(--home-gutter, 1.25rem), env(safe-area-inset-left, 0px)) +
          max(var(--home-gutter, 1.25rem), env(safe-area-inset-right, 0px))
      );
      mask-image: linear-gradient(90deg, transparent, #000 4%, #000 96%, transparent);
    }

    .home-marquee__viewport {
      display: flex;
      width: max-content;
      max-width: none;
      animation: home-marquee-scroll var(--marquee-duration) linear infinite;
    }

    .home-marquee:hover .home-marquee__viewport,
    .home-marquee:focus-within .home-marquee__viewport {
      animation-play-state: paused;
    }

    .home-marquee__track {
      display: flex;
      align-items: stretch;
      flex-shrink: 0;
      gap: var(--marquee-gap);
      margin: 0;
      padding: 0.15rem 0;
      padding-inline-end: var(--marquee-gap);
      list-style: none;
    }

    .home-marquee__track > li {
      flex: 0 0 auto;
      display: flex;
    }

    @keyframes home-marquee-scroll {
      from {
        transform: translate3d(0, 0, 0);
      }
      to {
        transform: translate3d(-50%, 0, 0);
      }
    }

    @media (prefers-reduced-motion: reduce) {
      .home-marquee {
        margin-inline: 0;
        width: 100%;
        mask-image: none;
      }

      .home-marquee__viewport {
        display: flex;
        flex-wrap: wrap;
        width: 100%;
        animation: none;
        gap: 0.65rem;
      }

      .home-marquee__track {
        display: contents;
        padding: 0;
      }

      .home-marquee__track[aria-hidden="true"] {
        display: none;
      }
    }

    .home-chip {
      --chip-width: 17.5rem;
      --chip-height: 7.25rem;
      box-sizing: border-box;
      display: flex;
      flex-direction: column;
      gap: 0.25rem;
      width: var(--chip-width);
      height: var(--chip-height);
      min-width: var(--chip-width);
      max-width: var(--chip-width);
      min-height: var(--chip-height);
      max-height: var(--chip-height);
      padding: 0.95rem 1.05rem 1.05rem;
      border-radius: 0.65rem;
      border: 1px solid var(--chip-border, transparent);
      background: transparent;
      text-decoration: none;
      color: inherit;
      overflow: hidden;
      transition:
        transform 0.15s ease,
        background-color 0.15s ease;
    }

    @media (max-width: 420px) {
      .home-chip {
        --chip-width: min(15.5rem, calc(100vw - 3rem));
        --chip-height: 6.75rem;
      }
    }

    .home-chip:hover {
      transform: translateY(-2px);
      background: color-mix(in srgb, var(--chip-accent, #e04e39) 8%, transparent);
    }

    .home-chip:focus-visible {
      outline: 2px solid var(--chip-accent, var(--home-brand-1));
      outline-offset: 3px;
    }

    .home-chip__name {
      flex-shrink: 0;
      font-size: 0.95rem;
      font-weight: 700;
      letter-spacing: -0.015em;
      line-height: 1.3;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      color: var(--chip-accent, var(--home-text-1));
    }

    .home-chip__by {
      flex-shrink: 0;
      font-size: 0.75rem;
      font-weight: 700;
      color: var(--chip-muted, var(--home-text-3));
    }

    .home-chip__desc {
      margin-top: 0.1rem;
      font-size: 0.8125rem;
      line-height: 1.45;
      color: var(--chip-muted, var(--home-text-2));
      display: -webkit-box;
      -webkit-box-orient: vertical;
      -webkit-line-clamp: 3;
      overflow: hidden;
    }

    .home-chip--magenta {
      --chip-accent: #e879a9;
      --chip-muted: #d8a0b8;
      --chip-border: color-mix(in srgb, #e879a9 70%, transparent);
    }

    .home-chip--green {
      --chip-accent: #4ade80;
      --chip-muted: #86c9a0;
      --chip-border: color-mix(in srgb, #4ade80 70%, transparent);
    }

    .home-chip--orange {
      --chip-accent: #fb923c;
      --chip-muted: #d4a574;
      --chip-border: color-mix(in srgb, #fb923c 70%, transparent);
    }

    .home-chip--blue {
      --chip-accent: #60a5fa;
      --chip-muted: #8eb4d8;
      --chip-border: color-mix(in srgb, #60a5fa 70%, transparent);
    }

    .home-chip--violet {
      --chip-accent: #c084fc;
      --chip-muted: #b9a0d4;
      --chip-border: color-mix(in srgb, #c084fc 70%, transparent);
    }

    .home-chip--cyan {
      --chip-accent: #22d3ee;
      --chip-muted: #7ec4d0;
      --chip-border: color-mix(in srgb, #22d3ee 70%, transparent);
    }

    :is(html:not([style*="color-scheme: dark"])) .home-chip--magenta {
      --chip-accent: #be185d;
      --chip-muted: #9d174d;
    }

    :is(html:not([style*="color-scheme: dark"])) .home-chip--green {
      --chip-accent: #15803d;
      --chip-muted: #166534;
    }

    :is(html:not([style*="color-scheme: dark"])) .home-chip--orange {
      --chip-accent: #c2410c;
      --chip-muted: #9a3412;
    }

    :is(html:not([style*="color-scheme: dark"])) .home-chip--blue {
      --chip-accent: #1d4ed8;
      --chip-muted: #1e40af;
    }

    :is(html:not([style*="color-scheme: dark"])) .home-chip--violet {
      --chip-accent: #7e22ce;
      --chip-muted: #6b21a8;
    }

    :is(html:not([style*="color-scheme: dark"])) .home-chip--cyan {
      --chip-accent: #0e7490;
      --chip-muted: #155e75;
    }

    .doc-button {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 0.4rem;
      min-height: 2.75rem;
      padding: 0.65rem 1.6rem;
      font-family: var(--font-sans);
      font-size: 0.9375rem;
      font-weight: 700;
      line-height: 1.4;
      letter-spacing: -0.01em;
      text-decoration: none;
      border-radius: 999px;
      border: 2px solid transparent;
      transition:
        background-color 0.15s ease,
        border-color 0.15s ease,
        color 0.15s ease,
        transform 0.15s ease,
        box-shadow 0.15s ease;
    }

    @media (max-width: 379px) {
      .doc-button {
        width: 100%;
      }
    }

    .doc-button--primary {
      background-color: #e04e39;
      color: #fff;
      box-shadow: 0 2px 0 rgb(0 0 0 / 0.25);
    }

    .doc-button--primary:hover {
      background-color: #c93f2d;
      color: #fff;
      transform: translateY(-1px);
      box-shadow: 0 4px 0 rgb(0 0 0 / 0.28);
    }

    .doc-button--alt {
      background-color: #fff;
      color: #0f172a;
      border-color: #fff;
    }

    .doc-button--alt:hover {
      background-color: #f8fafc;
      color: #0f172a;
      transform: translateY(-1px);
    }

    a.doc-button.styled-link,
    a.doc-button.styled-link:hover {
      text-decoration: none;
    }

    a.doc-button--primary.styled-link,
    a.doc-button--primary.styled-link:hover,
    :is(html[style*="color-scheme: dark"]) a.doc-button--primary.styled-link,
    :is(html[style*="color-scheme: dark"]) a.doc-button--primary.styled-link:hover {
      color: #fff;
      box-shadow: 0 2px 0 rgb(0 0 0 / 0.25);
    }

    a.doc-button--alt.styled-link,
    a.doc-button--alt.styled-link:hover,
    :is(html[style*="color-scheme: dark"]) a.doc-button--alt.styled-link,
    :is(html[style*="color-scheme: dark"]) a.doc-button--alt.styled-link:hover {
      color: #0f172a;
      box-shadow: none;
    }

    .doc-button:focus-visible {
      outline: 2px solid #fff;
      outline-offset: 3px;
    }

    .home-footer {
      display: flex;
      flex-direction: column;
      width: 100%;
      padding-top: clamp(1.5rem, 3vw, 2.25rem);
    }

    .home-footer__follow {
      min-width: 0;
      width: 100%;
    }
  </style>
</template>

const Socials = <template>
  <div class="socials">
    <ExternalLink href="https://github.com/NullVoxPopuli/" aria-label="GitHub">
      <GitHub class="social-icon" />
    </ExternalLink>
    <ExternalLink href="http://discord.gg/cTvtmJhFNY" aria-label="Discord">
      <Discord class="social-icon" />
    </ExternalLink>
    <ExternalLink href="https://x.com/nullvoxpopuli" aria-label="X">
      <XTwitter class="social-icon" />
    </ExternalLink>
    <ExternalLink href="https://mastodon.coffee/@nullvoxpopuli" aria-label="Mastodon">
      <Mastodon class="social-icon" />
    </ExternalLink>
    <ExternalLink href="https://bsky.app/profile/nullvoxpopuli.bsky.social" aria-label="Bluesky">
      <BlueSky class="social-icon" />
    </ExternalLink>
    <ExternalLink href="https://www.threads.net/@nullvoxpopuli" aria-label="Threads">
      <Threads class="social-icon" />
    </ExternalLink>
  </div>

  <style scoped>
    .socials {
      display: flex;
      flex-wrap: wrap;
      gap: 0.55rem;
      max-width: 100%;
    }

    .social-icon {
      width: 1.25rem;
      height: 1.25rem;
      fill: var(--home-text-2, #9ca3af);
      transition: fill 0.12s ease;
    }

    .socials a {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 2.5rem;
      height: 2.5rem;
      border: none;
      border-radius: 0.5rem;
      background: transparent;
      text-decoration: none;
      transition: background-color 0.15s ease;
    }

    .socials a:hover {
      background: var(--home-soft-hover, #2a2b31);
    }

    .socials a:hover .social-icon {
      fill: var(--home-brand-1, #e04e39);
    }

    .socials a:focus-visible {
      outline: 2px solid var(--home-brand-1, #e04e39);
      outline-offset: 2px;
    }
  </style>
</template>;
