import Route from 'ember-route-template';

export default Route(
  <template>
    <section class="grid gap-6">
      <header class="grid gap-2">
        <h1 class="text-3xl font-semibold tracking-tight text-slate-900 dark:text-slate-100">
          Animations
        </h1>
        <p class="max-w-2xl text-slate-600 dark:text-slate-300">
          A small gallery of animation patterns. These demos use Anime.js v4 Auto Layout to animate
          between layout states that are normally hard to animate (grid changes, DOM order changes,
          enter/exit).
        </p>
      </header>

      <div class="grid gap-4 md:grid-cols-2">
        <a
          href="/animations/layout-toggle"
          class="group rounded-2xl border border-slate-200 bg-white p-5 shadow-sm transition hover:-translate-y-0.5 hover:shadow-md dark:border-slate-800 dark:bg-slate-900"
        >
          <p class="text-sm font-semibold text-slate-500 dark:text-slate-400">Anime.js Layout</p>
          <h2 class="mt-1 text-lg font-semibold text-slate-900 dark:text-slate-100">
            Grid / list toggle
          </h2>
          <p class="mt-2 text-slate-600 dark:text-slate-300">
            Animate between list, 2-col, and 4-col layouts.
          </p>
        </a>

        <a
          href="/animations/dom-order"
          class="group rounded-2xl border border-slate-200 bg-white p-5 shadow-sm transition hover:-translate-y-0.5 hover:shadow-md dark:border-slate-800 dark:bg-slate-900"
        >
          <p class="text-sm font-semibold text-slate-500 dark:text-slate-400">Anime.js Layout</p>
          <h2 class="mt-1 text-lg font-semibold text-slate-900 dark:text-slate-100">
            DOM order changes
          </h2>
          <p class="mt-2 text-slate-600 dark:text-slate-300">
            Shuffle and reverse a list while Auto Layout handles the motion.
          </p>
        </a>

        <a
          href="/animations/enter-exit"
          class="group rounded-2xl border border-slate-200 bg-white p-5 shadow-sm transition hover:-translate-y-0.5 hover:shadow-md dark:border-slate-800 dark:bg-slate-900"
        >
          <p class="text-sm font-semibold text-slate-500 dark:text-slate-400">Anime.js Layout</p>
          <h2 class="mt-1 text-lg font-semibold text-slate-900 dark:text-slate-100">Enter / Exit</h2>
          <p class="mt-2 text-slate-600 dark:text-slate-300">
            Add/remove cards with enterFrom/leaveTo transitions.
          </p>
        </a>

        <a
          href="/animations/expand-cards"
          class="group rounded-2xl border border-slate-200 bg-white p-5 shadow-sm transition hover:-translate-y-0.5 hover:shadow-md dark:border-slate-800 dark:bg-slate-900"
        >
          <p class="text-sm font-semibold text-slate-500 dark:text-slate-400">ReactBits-ish</p>
          <h2 class="mt-1 text-lg font-semibold text-slate-900 dark:text-slate-100">
            Expanding cards
          </h2>
          <p class="mt-2 text-slate-600 dark:text-slate-300">
            Click to expand a card while the grid reflows smoothly.
          </p>
        </a>
      </div>

      <div class="rounded-2xl border border-slate-200 bg-white p-5 dark:border-slate-800 dark:bg-slate-900">
        <p class="text-sm text-slate-600 dark:text-slate-300">
          Learn more: <a class="font-semibold text-sky-600 hover:underline dark:text-sky-400" href="https://animejs.com/documentation/layout/">Anime.js Layout documentation</a>
        </p>
      </div>
    </section>
  </template>
);
