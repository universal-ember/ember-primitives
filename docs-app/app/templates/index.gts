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
      <InternalLink
        href="/1-get-started/index.md"
        style="color: white; text-shadow: 0px 2px 0px black; transform: scale(2.5);"
      >
        Get Started ➤
      </InternalLink>
    </:callToAction>
    <:content>
      <Content />

      <br /><br />
      <br /><br />

      <div class="flex justify-center items-center">
        <GetStarted />
      </div>

      <br /><br />

      <div class="mx-auto" style="width: 66%">
        <Article class="flex flex-wrap gap-12 justify-around">

          <div>
            <H2>Building on the backs of giants.</H2>

            <ul class="dark:text-white text:slate-900">
              <li>
                <strong><em style="text-transform: uppercase; letter-spacing: 0.5rem;">The Platform</em></strong><br
                />
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

            <ul>
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

      <br /><br />
      <br /><br />

    </:content>

    <:footer>

      <div>
        <Text>Dependencies / Projects used by ember-primitives that are worth looking at.</Text>
        <nav class="dark:text-white text:slate-900">
          <ul>
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
</template>

const Socials = <template>
  <div class="flex gap-3">
    <ExternalLink href="https://github.com/NullVoxPopuli/">
      <GitHub class="dark:fill-white fill-slate-900 h-6 w-6" />
    </ExternalLink>
    <ExternalLink href="http://discord.gg/cTvtmJhFNY">
      <Discord class="dark:fill-white fill-slate-900 h-6 w-6" />
    </ExternalLink>
    <ExternalLink href="https://x.com/nullvoxpopuli">
      <XTwitter class="dark:fill-white fill-slate-900 h-6 w-6" />
    </ExternalLink>
    <ExternalLink href="https://mastodon.coffee/@nullvoxpopuli">
      <Mastodon class="dark:fill-white fill-slate-900 h-6 w-6" />
    </ExternalLink>
    <ExternalLink href="https://bsky.app/profile/nullvoxpopuli.bsky.social">
      <BlueSky class="dark:fill-white fill-slate-900 h-6 w-6" />
    </ExternalLink>
    <ExternalLink href="https://www.threads.net/@nullvoxpopuli">
      <Threads class="dark:fill-white fill-slate-900 h-6 w-6" />
    </ExternalLink>
  </div>
</template>;

const GetStarted = <template>
  <InternalLink href="/1-get-started/index.md" style="transform: scale(2.5);">
    Get Started ➤
  </InternalLink>
</template>;

const Content = <template>
  <br /><br />

  <div class="mx-auto" style="width: 66%">
    <Article class="flex flex-wrap gap-12 justify-between">
      <div>
        <H2>Projects using...</H2>

        <ul>
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

        <ul>
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

        <ul>
          <li>Accessible, by default</li>
          <li><Link href="https://tabster.io/">Tabster</Link> integration</li>
          <li>Documented</li>
          <li>Compatible with all CSS styles</li>
          <li>Compatible with all design systems</li>
        </ul>
      </div>
    </Article>
  </div>
</template>;
