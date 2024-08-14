import { TopRight } from 'docs-app/components/header';
import { Logo } from 'docs-app/components/icons';
import { Hero } from 'ember-primitives/layout/hero';
import Route from 'ember-route-template';

import { Article, Link } from './page';

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
        <Link href="/1-get-started/index.md" class="text-2xl" style="color: white; text-shadow: 0px 3px 0px black;
  font-size: 2.125rem;">
          Get Started ➤
        </Link>
      </div>
    </Hero>

  <style>
    .gradient-background {
      background: linear-gradient(-45deg,#1252e3,#485de5,#7812e5,#e51285);
      background-size: 400% 400%;
      animation: gradient-animation 10s ease infinite;
      transition: all 0.5s ease;
    }

    body.dark .gradient-background {
      background: linear-gradient(-45deg,#120083,#440075,#280055,#150035);
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

    <footer>
       Footer content 
    </footer>
  </template>
);

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
