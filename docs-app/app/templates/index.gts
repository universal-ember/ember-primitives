import { TopRight } from 'docs-app/components/header';
import { Logo } from 'docs-app/components/icons';
import { Hero } from 'ember-primitives/layout/hero';
import Route from 'ember-route-template';

import { Article } from './page';

import type { TOC } from '@ember/component/template-only';

export default Route(
  <template>
    <Hero class="shadow-xl shadow-slate-900/5 gradient-background">
      <header class="sticky top-0 z-50 p-4 flex items-center">
        <TopRight />
      </header>

      <div class="h-full flex justify-center items-center">
        <h1 style="width: 66%; margin: 0 auto; filter: drop-shadow(3px 5px 0px rgba(0, 0, 0, 0.4));">
          <Logo />
        </h1>
      </div>
    </Hero>

  <style>
.gradient-background {
  background: linear-gradient(167deg,#1252e3,#485de5,#585de5);
  background-size: 180% 180%;
  animation: gradient-animation 6s ease infinite;
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
      <Article class="flex gap-8 justify-center" >
        <div>
          <H2>Projects using ember-primitives</H2>

          <ul>
            <li></li>
          </ul>
        </div>

        <div>
          <H2>Goals</H2>

          <ul>
            <li>import only what you need</li>
            <li>pure data derivation</li>
            <li>no extra rendering</li>
          </ul>
        </div>
      </Article>
    </div>
</template>;


const H2: TOC<{ Blocks: { default: []}}> = <template>
  <h2 class="text-3xl">{{yield}}</h2>
</template>
