import { GitHubLink, TestsLink } from 'docs-app/components/header';
import { Logo } from 'docs-app/components/icons';
import { ExternalLink } from 'ember-primitives/components/external-link';

import {
  Article,
  H2,
  IndexPage,
  InternalLink,
  Link,
  Text,
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
      headless, styleless, accessibility focused implementations of components, patterns, and
      utilities to help make building apps faster.
      <br />
      <strong>picking up where the framework left off.</strong>
    </:tagline>
    <:callToAction>
      <InternalLink href="/1-get-started/index.md" class="doc-button doc-button--primary">
        Get Started ➤
      </InternalLink>
    </:callToAction>
    <:content>
      <div class="home-body">
        <Content />

        <div class="home-cta-mid">
          <GetStarted />
        </div>

        <div class="home-panels">
          <Article class="home-panels__grid not-prose">
            <div>
              <H2>Building on the backs of giants.</H2>

              <ul class="adaptive-text home-list">
                <li>
                  <strong><em class="home-kicker">The Platform</em></strong><br />
                  When possible, the platform should be used instead of custom implementations. When
                  applicable, the docs call out what and how to use each relevant part of the
                  platform.
                </li>
                <li>
                  <Link href="https://floating-ui.com/">@floating-ui/dom</Link><br />
                  Used for positioning floating elements. Will be replaced by
                  <Link href="https://w3c.github.io/csswg-drafts/css-anchor-position/">CSS Anchor
                    Position</Link>
                  when that lands.
                </li>
                <li>
                  <Link href="https://tabster.io/">tabster</Link><br />
                  Used for managing roving focus in menus or menu-like patterns.
                </li>
              </ul>
            </div>

            <div>
              <H2>Inspiration and code adapted from</H2>

              <ul class="home-list">
                <li>
                  <Link href="https://primitives.solidjs.community/">
                    Solid primitives
                  </Link>
                </li>
                <li>
                  <Link href="https://www.radix-ui.com/primitives/docs/overview/introduction">
                    radix primitives
                  </Link>
                </li>
                <li>
                  <Link href="https://kobalte.dev/docs/core/overview/introduction">
                    Kobalte
                  </Link>
                </li>
                <li>
                  <Link href="https://svelte-ux.techniq.dev/">
                    Svelte UX
                  </Link>
                </li>
                <li>
                  <Link href="https://quasar.dev/">
                    Quasar
                  </Link>
                </li>
                <li>
                  <Link href="https://www.bits-ui.com/docs/introduction">
                    Bits UI
                  </Link>
                </li>
                <li>
                  <Link href="https://ariakit.org/">
                    AriaKit
                  </Link>
                </li>
                <li>
                  <Link href="https://react-spectrum.adobe.com/react-aria/">
                    React Aria
                  </Link>
                </li>
                <li>
                  <Link href="https://ui.shadcn.com/docs/components/accordion">
                    ShadCN
                  </Link>
                </li>
              </ul>
            </div>
          </Article>
        </div>
      </div>
    </:content>

    <:footer>

      <div>
        <Text>Dependencies / Projects used by ember-primitives that are worth looking at.</Text>
        <nav class="adaptive-text">
          <ul class="home-list">
            <li>
              <Link href="https://github.com/universal-ember/reactiveweb">
                reactiveweb
              </Link><br />
              Reactive utilities used in some components.
            </li>
            <li>
              <Link href="https://github.com/nullVoxPopuli/form-data-utils">
                form-data-utils
              </Link><br />
              Utilities for working with
              <Link
                href="https://developer.mozilla.org/en-US/docs/Web/API/FormData"
              >FormData</Link>.
            </li>
            <li>
              <Link href="https://github.com/NullVoxPopuli/should-handle-link">
                should-handle-link
              </Link><br />
              Utilities for managing native link clicks in single-page-apps.
            </li>
            <li>
              <Link href="https://github.com/universal-ember/test-support">
                @universal-ember/test-support
              </Link><br />
              Extra helpers for testing.
            </li>
          </ul>
        </nav>
      </div>

      <div>
        <Socials />
      </div>
    </:footer>
  </IndexPage>

  <style>
    .home-body {
      width: min(66%, 960px);
      margin: 0 auto;
      padding: 3.5rem 1.5rem 1rem;
    }

    .home-panels {
      margin-top: 3.5rem;
    }

    .home-panels__grid {
      display: flex;
      flex-wrap: wrap;
      gap: 3rem;
      justify-content: space-around;
    }

    .home-cta-mid {
      display: flex;
      justify-content: center;
      margin: 3rem 0 0.5rem;
    }

    .home-list {
      display: flex;
      flex-direction: column;
      gap: 0.85rem;
      margin: 0.85rem 0 0;
      padding: 0;
      list-style: none;
      color: var(--doc-text-2);
      font-size: 0.9375rem;
      line-height: 1.6;
    }

    .home-list a {
      color: var(--doc-brand-1);
      text-decoration: none;
      font-weight: 500;
    }

    .home-list a:hover {
      text-decoration: underline;
      text-decoration-color: color-mix(in srgb, var(--doc-brand-1) 40%, transparent);
      text-underline-offset: 0.18em;
    }

    .home-list li {
      margin: 0;
    }

    .home-kicker {
      text-transform: uppercase;
      letter-spacing: 0.35em;
      font-style: normal;
      font-size: 0.75rem;
      color: var(--doc-text-3);
    }

    .home-section-grid {
      display: flex;
      flex-wrap: wrap;
      gap: 3rem;
      justify-content: space-between;
    }
  </style>
</template>

const Socials = <template>
  <div class="socials">
    <ExternalLink href="https://github.com/NullVoxPopuli/">
      <GitHub class="social-icon" />
    </ExternalLink>
    <ExternalLink href="http://discord.gg/cTvtmJhFNY">
      <Discord class="social-icon" />
    </ExternalLink>
    <ExternalLink href="https://x.com/nullvoxpopuli">
      <XTwitter class="social-icon" />
    </ExternalLink>
    <ExternalLink href="https://mastodon.coffee/@nullvoxpopuli">
      <Mastodon class="social-icon" />
    </ExternalLink>
    <ExternalLink href="https://bsky.app/profile/nullvoxpopuli.bsky.social">
      <BlueSky class="social-icon" />
    </ExternalLink>
    <ExternalLink href="https://www.threads.net/@nullvoxpopuli">
      <Threads class="social-icon" />
    </ExternalLink>
  </div>

  <style scoped>
    .socials {
      display: flex;
      gap: 0.5rem;
    }

    .social-icon {
      width: 1.35rem;
      height: 1.35rem;
      fill: var(--doc-text-2);
      transition: fill 0.12s ease;
    }

    .socials a {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 2.25rem;
      height: 2.25rem;
      border-radius: var(--doc-radius-sm);
      text-decoration: none;
    }

    .socials a:hover {
      background: var(--doc-brand-soft);
    }

    .socials a:hover .social-icon {
      fill: var(--doc-brand-1);
    }
  </style>
</template>;

const GetStarted = <template>
  <InternalLink href="/1-get-started/index.md" class="doc-button doc-button--primary">
    Get Started ➤
  </InternalLink>
</template>;

const Content = <template>
  <Article class="home-section-grid not-prose">
    <div>
      <H2>Projects using...</H2>

      <ul class="home-list">
        <li>
          <Link href="https://limber.glimdown.com">REPL, Limber</Link>
        </li>
        <li>
          <Link href="https://tutorial.glimdown.com">Tutorial</Link>
        </li>
        <li>
          <Link href="https://game-of-life.nullvoxpopuli.com/">Conway's Game of Life</Link>
        </li>
        <li>
          <Link href="https://majors.nullvoxpopuli.com/">Package Majors</Link>
        </li>
      </ul>
    </div>

    <div>
      <H2>Goals</H2>

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
    </div>

    <div>
      <H2>Features</H2>

      <ul class="home-list">
        <li>Accessible, by default</li>
        <li><Link href="https://tabster.io/">Tabster</Link> integration</li>
        <li>Documented</li>
        <li>Compatible with all CSS styles</li>
        <li>Compatible with all design systems</li>
      </ul>
    </div>
  </Article>
</template>;
