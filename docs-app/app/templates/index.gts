import { TopRight } from 'docs-app/components/header';
import { Logo } from 'docs-app/components/icons';
import { BlueSky, Discord, GitHub, Mastodon, Threads, XTwitter } from 'docs-app/components/icons';
import { ExternalLink } from 'ember-primitives/components/external-link';
import { Hero } from 'ember-primitives/layout/hero';
import Route from 'ember-route-template';

import { Article, InternalLink, Link } from './page';

import type { TOC } from '@ember/component/template-only';

export default Route(
  <template>
    <Hero class="shadow-xl shadow-slate-900/5 gradient-background">
      <header class="sticky top-0 z-50 p-4 flex items-center">
        <TopRight />
      </header>

      <div class="h-full flex flex-col gap-8 justify-center items-center">
        <h1 style="transform: translateY(-50%); width: 66%; margin: 0 auto; filter: drop-shadow(3px 5px 0px rgba(0, 0, 0, 0.4));">
          <Logo />
        </h1>
        <InternalLink href="/1-get-started/index.md" class="text-2xl" style="color: white; text-shadow: 0px 3px 0px black;
  font-size: 2.125rem;">
          Get Started ➤
        </InternalLink>
      </div>
    </Hero>

  <style>
    .gradient-background {
      background-image: linear-gradient(-45deg in oklch, #1252e3, #485de5, #7812e5, #3512c5);
      background-size: 400% 400%;
      animation: gradient-animation 16s ease infinite;
    }

    body.dark .gradient-background {
      background-image: linear-gradient(-45deg in oklch, #110043, #182d75, #280065, #350076);
    }

    @keyframes gradient-animation {
      0% {
        background-position: 0% 50%;
      }
      50% {
        background-position: 100% 50%;
      }
      100% {
        background-position: 0% 50%;
      }
    }
  </style>

    <Content />

    <br><br>
    <br><br>

    <div class="flex justify-center items-center">
      <InternalLink href="/1-get-started/index.md" class="text-2xl" style="font-size: 2.125rem;">
        Get Started ➤
      </InternalLink>
    </div>

    <br><br>
    <br><br>

    <footer style="padding: 3rem; width: 66%;" class="mx-auto flex justify-between">
      <div>
        <span class="dark:text-white text:slate-900">Related Projects</span>
        <nav>
          <ul>
            <li>
              <Link href="https://github.com/universal-ember/test-support">
                @universal-ember/test-support
              </Link>
            </li>
            <li>
              <Link href="https://github.com/universal-ember/reactiveweb">
                reactiveweb
              </Link>
            </li>
            <li>
              <Link href="https://github.com/nullVoxPopuli/form-data-utils">
                form-data-utils
              </Link>
            </li>
            <li>
              <Link href="https://github.com/NullVoxPopuli/should-handle-link">
                should-handle-link
              </Link>
            </li>
         </ul>
        </nav>
      </div>

      <div>
        <Socials />
      </div>
    </footer>
  </template>
);

const Socials = <template>
  <div class="flex gap-3">
    <ExternalLink href="https://x.com/nullvoxpopuli">
      <XTwitter class="dark:fill-white fill-slate-900 h-6 w-6" />
    </ExternalLink>
    <ExternalLink href="https://github.com/NullVoxPopuli/">
      <GitHub class="dark:fill-white fill-slate-900  h-6 w-6" />
    </ExternalLink>
    <ExternalLink href="https://mastodon.coffee/@nullvoxpopuli">
      <Mastodon class="dark:fill-white fill-slate-900  h-6 w-6" />
    </ExternalLink>
    <ExternalLink href="https://bsky.app/profile/nullvoxpopuli.bsky.social">
      <BlueSky class="dark:fill-white fill-slate-900  h-6 w-6" />
    </ExternalLink>
    <ExternalLink href="https://www.threads.net/@nullvoxpopuli">
      <Threads class="dark:fill-white fill-slate-900  h-6 w-6" />
    </ExternalLink>
    <ExternalLink href="http://discord.gg/cTvtmJhFNY">
      <Discord class="dark:fill-white fill-slate-900  h-6 w-6" />
    </ExternalLink>
  </div>
</template>;

const Content = <template>
    <br><br>

    <div class="mx-auto" style="width: 66%">
      <Article class="flex gap-12 justify-between" >
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
            <li>import only what you need</li>
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


const H2: TOC<{ Blocks: { default: []}}> = <template>
  <h2 class="text-3xl">{{yield}}</h2>
</template>
