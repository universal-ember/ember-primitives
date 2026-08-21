import { GitHubLink, TestsLink } from 'docs-app/components/header';
import { Logo } from 'docs-app/components/icons';
import { ExternalLink } from 'ember-primitives/components/external-link';

import {
  IndexPage,
  InternalLink,
  Link,
  TopRight,
} from '@universal-ember/docs-support';
import {
  BlueSky,
  Discord,
  GitHub,
  Mastodon,
  Threads,
  XTwitter,
} from '@universal-ember/docs-support/icons';

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
        <section class="home-section" aria-label="Overview">
          <div class="home-overview">
            <article class="home-panel">
              <h2 class="home-section__title">Projects using…</h2>
              <ul class="home-list home-list--links">
                <li>
                  <Link href="https://limber.glimdown.com" class="home-link">REPL, Limber</Link>
                </li>
                <li>
                  <Link href="https://tutorial.glimdown.com" class="home-link">Tutorial</Link>
                </li>
                <li>
                  <Link href="https://game-of-life.nullvoxpopuli.com/" class="home-link">Conway's Game
                    of Life</Link>
                </li>
                <li>
                  <Link href="https://majors.nullvoxpopuli.com/" class="home-link">Package Majors</Link>
                </li>
              </ul>
            </article>

            <article class="home-panel">
              <h2 class="home-section__title">Goals</h2>
              <ul class="home-list">
                <li>high-quality components and utilities</li>
                <li>pay for only what you import</li>
                <li>pure data derivation</li>
                <li>no extra rendering</li>
                <li>no unneeded DOM</li>
                <li>be contextually aware</li>
                <li>be flexible</li>
                <li>use the latest technology</li>
              </ul>
            </article>

            <article class="home-panel">
              <h2 class="home-section__title">Features</h2>
              <ul class="home-list">
                <li>Accessible, by default</li>
                <li>
                  <Link href="https://tabster.io/" class="home-link">Tabster</Link>
                  integration
                </li>
                <li>Documented</li>
                <li>Compatible with all CSS styles</li>
                <li>Compatible with all design systems</li>
              </ul>
            </article>
          </div>
        </section>

        <section class="home-section home-section--split" aria-labelledby="home-foundation">
          <div class="home-panel">
            <h2 id="home-foundation" class="home-section__title">Building on the backs of giants</h2>
            <ul class="home-stack">
              <li class="home-stack__item">
                <p class="home-kicker">The Platform</p>
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

          <div class="home-panel">
            <h2 class="home-section__title">Inspiration</h2>
            <p class="home-section__lede">Inspiration and code adapted from</p>
            <ul class="home-inspire">
              <li>
                <Link href="https://primitives.solidjs.community/" class="home-inspire__link">Solid
                  primitives</Link>
              </li>
              <li>
                <Link
                  href="https://www.radix-ui.com/primitives/docs/overview/introduction"
                  class="home-inspire__link"
                >radix primitives</Link>
              </li>
              <li>
                <Link
                  href="https://kobalte.dev/docs/core/overview/introduction"
                  class="home-inspire__link"
                >Kobalte</Link>
              </li>
              <li>
                <Link href="https://svelte-ux.techniq.dev/" class="home-inspire__link">Svelte UX</Link>
              </li>
              <li>
                <Link href="https://quasar.dev/" class="home-inspire__link">Quasar</Link>
              </li>
              <li>
                <Link href="https://www.bits-ui.com/docs/introduction" class="home-inspire__link">Bits
                  UI</Link>
              </li>
              <li>
                <Link href="https://ariakit.org/" class="home-inspire__link">AriaKit</Link>
              </li>
              <li>
                <Link
                  href="https://react-spectrum.adobe.com/react-aria/"
                  class="home-inspire__link"
                >React Aria</Link>
              </li>
              <li>
                <Link
                  href="https://ui.shadcn.com/docs/components/accordion"
                  class="home-inspire__link"
                >ShadCN</Link>
              </li>
            </ul>
          </div>
        </section>

        <section class="home-section" aria-labelledby="home-deps">
          <p id="home-deps" class="home-footer-label">Dependencies worth looking at</p>
          <nav aria-label="Related projects">
            <ul class="home-deps">
              <li>
                <Link href="https://github.com/universal-ember/reactiveweb" class="home-dep">
                  <span class="home-dep__name">reactiveweb</span>
                  <span class="home-dep__desc">Reactive utilities used in some components.</span>
                </Link>
              </li>
              <li>
                <Link href="https://github.com/nullVoxPopuli/form-data-utils" class="home-dep">
                  <span class="home-dep__name">form-data-utils</span>
                  <span class="home-dep__desc">Utilities for working with FormData.</span>
                </Link>
              </li>
              <li>
                <Link href="https://github.com/NullVoxPopuli/should-handle-link" class="home-dep">
                  <span class="home-dep__name">should-handle-link</span>
                  <span class="home-dep__desc">Utilities for managing native link clicks in
                    single-page apps.</span>
                </Link>
              </li>
              <li>
                <Link href="https://github.com/universal-ember/test-support" class="home-dep">
                  <span class="home-dep__name">@universal-ember/test-support</span>
                  <span class="home-dep__desc">Extra helpers for testing.</span>
                </Link>
              </li>
            </ul>
          </nav>
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
      --home-link: var(--home-brand-1, #3451b2);
      --home-link-hover: var(--home-brand-2, #3a5ccc);
      box-sizing: border-box;
      width: min(100%, var(--home-max, 72rem));
      margin-inline: auto;
      padding-block: clamp(2.75rem, 5vw, 4rem) clamp(1.5rem, 3vw, 2.25rem);
      padding-inline: max(var(--home-gutter, 1.25rem), env(safe-area-inset-left, 0px))
        max(var(--home-gutter, 1.25rem), env(safe-area-inset-right, 0px));
    }

    :is(html[style*="color-scheme: dark"]) .home-body {
      --home-link: var(--home-brand-1, #a8b1ff);
      --home-link-hover: #c4caff;
    }

    .home-section + .home-section {
      margin-top: clamp(3rem, 6vw, 4.5rem);
      padding-top: clamp(3rem, 6vw, 4.5rem);
      border-top: 1px solid var(--home-border, rgba(60, 60, 67, 0.12));
    }

    .home-section__title {
      margin: 0;
      font-size: clamp(1.15rem, 1.05rem + 0.3vw, 1.35rem);
      font-weight: 600;
      line-height: 1.3;
      letter-spacing: -0.02em;
      color: var(--home-text-1, #3c3c43);
    }

    .home-section__lede {
      margin: 0.5rem 0 0;
      color: var(--home-text-2, #67676c);
      font-size: 0.9375rem;
      line-height: 1.55;
    }

    .home-overview {
      display: grid;
      grid-template-columns: 1fr;
      gap: 0.75rem;
      align-items: stretch;
    }

    @media (min-width: 800px) {
      .home-overview {
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 0.85rem;
      }
    }

    .home-panel {
      box-sizing: border-box;
      min-width: 0;
      height: 100%;
      padding: 1.35rem 1.4rem 1.5rem;
      border-radius: 0.75rem;
      background: var(--home-soft, #f6f6f7);
    }

    .home-list {
      display: flex;
      flex-direction: column;
      gap: 0.45rem;
      margin: 1rem 0 0;
      padding: 0;
      list-style: none;
      color: var(--home-text-2, #67676c);
      font-size: 0.875rem;
      line-height: 1.5;
    }

    .home-list--links {
      gap: 0.2rem;
    }

    .home-list li {
      margin: 0;
    }

    .home-list--links .home-link {
      display: inline-flex;
      align-items: center;
      min-height: 1.75rem;
      padding: 0.1rem 0;
    }

    /* Foundation + inspiration split */
    .home-section--split {
      display: grid;
      grid-template-columns: 1fr;
      gap: clamp(1.75rem, 4vw, 2.5rem);
    }

    @media (min-width: 900px) {
      .home-section--split {
        grid-template-columns: minmax(0, 1.2fr) minmax(0, 0.8fr);
        gap: clamp(2rem, 4vw, 3rem);
      }
    }

    .home-kicker {
      margin: 0 0 0.3rem;
      text-transform: uppercase;
      letter-spacing: 0.12em;
      font-size: 0.6875rem;
      font-weight: 600;
      color: var(--home-text-3, #929295);
    }

    .home-stack {
      display: flex;
      flex-direction: column;
      gap: 1.15rem;
      margin: 1.1rem 0 0;
      padding: 0;
      list-style: none;
    }

    .home-stack__item {
      margin: 0;
    }

    .home-stack__title {
      margin: 0 0 0.25rem;
      font-size: 0.9375rem;
      font-weight: 600;
      color: var(--home-text-1, #3c3c43);
    }

    .home-copy {
      margin: 0;
      color: var(--home-text-2, #67676c);
      font-size: 0.875rem;
      line-height: 1.6;
      text-wrap: pretty;
    }

    .home-inspire {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(9.5rem, 1fr));
      gap: 0.35rem 1rem;
      margin: 0.85rem 0 0;
      padding: 0;
      list-style: none;
    }

    .home-inspire__link {
      display: inline-flex;
      align-items: center;
      min-height: 1.85rem;
      color: var(--home-link);
      font-size: 0.875rem;
      font-weight: 500;
      text-decoration: none;
      text-underline-offset: 0.18em;
      background-image: linear-gradient(currentColor, currentColor);
      background-position: 0 100%;
      background-repeat: no-repeat;
      background-size: 0 1px;
      transition:
        color 0.15s ease,
        background-size 0.18s ease;
    }

    .home-inspire__link:hover {
      color: var(--home-link-hover);
      background-size: 100% 1px;
    }

    .home-link {
      color: var(--home-link);
      font-weight: 500;
      text-decoration: none;
      text-underline-offset: 0.18em;
      background-image: linear-gradient(currentColor, currentColor);
      background-position: 0 100%;
      background-repeat: no-repeat;
      background-size: 0 1px;
      transition:
        color 0.15s ease,
        background-size 0.18s ease;
    }

    .home-link:hover {
      color: var(--home-link-hover);
      background-size: 100% 1px;
    }

    .home-link:focus-visible,
    .home-inspire__link:focus-visible {
      outline: 2px solid var(--home-link);
      outline-offset: 3px;
      border-radius: 0.25rem;
    }

    /* Kill global sky-cyan .styled-link on home */
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

    a.styled-link.home-link,
    a.styled-link.home-inspire__link,
    :is(html[style*="color-scheme: dark"]) a.styled-link.home-link,
    :is(html[style*="color-scheme: dark"]) a.styled-link.home-inspire__link {
      color: inherit;
    }

    a.styled-link.home-link {
      color: var(--home-link);
    }

    a.styled-link.home-inspire__link {
      color: var(--home-link);
    }

    a.styled-link.home-dep,
    :is(html[style*="color-scheme: dark"]) a.styled-link.home-dep {
      color: var(--home-text-1, #dfdfd6);
    }

    a.styled-link.home-dep .home-dep__name,
    a.styled-link.home-dep:hover .home-dep__name,
    :is(html[style*="color-scheme: dark"]) a.styled-link.home-dep .home-dep__name,
    :is(html[style*="color-scheme: dark"]) a.styled-link.home-dep:hover .home-dep__name {
      color: var(--home-text-1, #dfdfd6);
    }

    /* Footer — only Follow; sticky via .index-footer margin-top: auto */
    .home-footer {
      display: flex;
      flex-direction: column;
      width: 100%;
      padding-top: clamp(1.75rem, 3.5vw, 2.5rem);
      border-top: 1px solid var(--home-border, rgba(60, 60, 67, 0.12));
    }

    .home-footer__follow {
      min-width: 0;
      width: 100%;
    }

    .home-footer-label {
      display: block;
      margin: 0 0 0.9rem;
      font-size: 0.75rem;
      font-weight: 600;
      letter-spacing: 0.08em;
      text-transform: uppercase;
      color: var(--home-text-3, #929295);
    }

    .home-deps {
      display: grid;
      grid-template-columns: 1fr;
      gap: 0.55rem;
      margin: 0;
      padding: 0;
      list-style: none;
    }

    @media (min-width: 720px) {
      .home-deps {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
    }

    @media (min-width: 1100px) {
      .home-deps {
        grid-template-columns: repeat(4, minmax(0, 1fr));
      }
    }

    .home-dep {
      display: flex;
      flex-direction: column;
      gap: 0.25rem;
      min-height: 100%;
      padding: 0.95rem 1rem;
      border-radius: 0.75rem;
      background: var(--home-soft, #f6f6f7);
      text-decoration: none;
      transition: background-color 0.15s ease;
    }

    .home-dep:hover {
      background: var(--home-soft-hover, #ececef);
    }

    .home-dep:focus-visible {
      outline: 2px solid var(--home-text-2, #67676c);
      outline-offset: 2px;
    }

    .home-dep__name {
      font-size: 0.9rem;
      font-weight: 600;
      letter-spacing: -0.01em;
      color: var(--home-text-1, #3c3c43);
    }

    .home-dep__desc {
      color: var(--home-text-2, #67676c);
      font-size: 0.8125rem;
      line-height: 1.45;
    }

    /* CTAs */
    .doc-button {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 0.4rem;
      min-height: 2.5rem;
      padding: 0.55rem 1.35rem;
      font-family: var(--font-sans);
      font-size: 0.875rem;
      font-weight: 600;
      line-height: 1.4;
      letter-spacing: -0.01em;
      text-decoration: none;
      border-radius: 9999px;
      border: 1px solid transparent;
      transition:
        background-color 0.15s ease,
        border-color 0.15s ease,
        color 0.15s ease;
    }

    @media (max-width: 379px) {
      .doc-button {
        width: 100%;
      }
    }

    .doc-button--primary {
      background-color: var(--home-soft-hover, #ececef);
      color: var(--home-text-1, #3c3c43);
    }

    .doc-button--primary:hover {
      background-color: color-mix(in srgb, var(--home-text-1, #3c3c43) 12%, var(--home-soft-hover, #ececef));
      color: var(--home-text-1, #3c3c43);
    }

    :is(html[style*="color-scheme: dark"]) .doc-button--primary {
      background-color: #27272e;
    }

    :is(html[style*="color-scheme: dark"]) .doc-button--primary:hover {
      background-color: #2e2e36;
    }

    .doc-button--alt {
      background-color: var(--home-soft, #f6f6f7);
      color: var(--home-text-1, #3c3c43);
    }

    .doc-button--alt:hover {
      background-color: var(--home-soft-hover, #ececef);
      color: var(--home-text-1, #3c3c43);
    }

    a.doc-button.styled-link,
    a.doc-button.styled-link:hover {
      box-shadow: none;
      text-decoration: none;
    }

    a.doc-button--primary.styled-link,
    a.doc-button--primary.styled-link:hover,
    a.doc-button--alt.styled-link,
    a.doc-button--alt.styled-link:hover,
    :is(html[style*="color-scheme: dark"]) a.doc-button--primary.styled-link,
    :is(html[style*="color-scheme: dark"]) a.doc-button--primary.styled-link:hover,
    :is(html[style*="color-scheme: dark"]) a.doc-button--alt.styled-link,
    :is(html[style*="color-scheme: dark"]) a.doc-button--alt.styled-link:hover {
      color: var(--home-text-1, #dfdfd6);
    }

    .doc-button:focus-visible {
      outline: 2px solid var(--home-text-2, #67676c);
      outline-offset: 3px;
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
      fill: var(--home-text-2, #67676c);
      transition: fill 0.12s ease;
    }

    :is(html[style*="color-scheme: dark"]) .social-icon {
      fill: var(--home-text-2, #98989f);
    }

    .socials a {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 2.75rem;
      height: 2.75rem;
      border: 0;
      border-radius: 0.75rem;
      background: var(--home-soft, #f6f6f7);
      text-decoration: none;
      transition: background-color 0.15s ease;
    }

    .socials a:hover {
      background: var(--home-soft-hover, #ececef);
    }

    .socials a:hover .social-icon {
      fill: var(--home-brand-1, #3451b2);
    }

    :is(html[style*="color-scheme: dark"]) .socials a:hover .social-icon {
      fill: var(--home-brand-1, #a8b1ff);
    }

    .socials a:focus-visible {
      outline: 2px solid var(--home-brand-3, #5672cd);
      outline-offset: 2px;
    }
  </style>
</template>;
