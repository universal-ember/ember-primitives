import { on } from '@ember/modifier';

import { createLayout, stagger } from 'animejs';
import { modifier } from 'ember-modifier';

type LayoutInstance = {
  revert?: () => void;
  update: (
    callback: (context: { root: HTMLElement }) => void,
    options?: { duration?: number; delay?: unknown; ease?: string }
  ) => void;
};

let layout: LayoutInstance | undefined;
let gridMode = 1;
const items = [1, 2, 3, 4, 5, 6, 7, 8];

const setupLayout = modifier((root: HTMLElement) => {
  layout = createLayout(root, {
    children: '.layout-item',
    duration: 800,
    ease: 'inOut(3.5)',
    properties: ['borderRadius', 'boxShadow'],
  }) as LayoutInstance;

  root.dataset.grid = '1';

  return () => {
    layout?.revert?.();
    layout = undefined;
  };
});

function cycleLayout() {
  if (!layout) return;

  layout.update(
    ({ root }: { root: HTMLElement }) => {
      gridMode = (gridMode % 3) + 1;
      root.dataset.grid = String(gridMode);
    },
    {
      duration: 900,
      delay: stagger(45),
      ease: 'inOut(3.5)',
    }
  );
}

function toggleDense() {
  if (!layout) return;

  layout.update(
    ({ root }: { root: HTMLElement }) => {
      root.classList.toggle('dense');
    },
    {
      duration: 700,
      delay: stagger(25),
      ease: 'inOut(3.5)',
    }
  );
}

const Demo = <template>
  <section
    class="layout-shell mx-auto grid w-full max-w-[860px] gap-5 overflow-hidden rounded-[18px] border border-slate-200 bg-white/90 p-6 shadow-[0_14px_38px_rgba(15,23,42,0.08)] backdrop-blur dark:border-slate-800 dark:bg-slate-900/60"
    {{setupLayout}}
  >
    <div class="flex flex-wrap items-start justify-between gap-4" aria-label="Layout toggle controls">
      <div class="grid gap-1">
        <p
          class="text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400"
        >
          Layout states
        </p>
        <p class="text-sm text-slate-600 dark:text-slate-300">
          Cycle between list, 2-col, and 4-col. Toggle dense to change gaps.
        </p>
      </div>

      <div class="flex flex-wrap gap-2">
        <button
          type="button"
          class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-900 shadow-sm transition hover:bg-slate-50 active:translate-y-px dark:border-slate-700 dark:bg-slate-950 dark:text-slate-100 dark:hover:bg-slate-900"
          {{on 'click' toggleDense}}
        >
          Toggle dense
        </button>
        <button
          type="button"
          class="rounded-xl border border-slate-900 bg-slate-900 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-slate-800 active:translate-y-px dark:border-slate-200 dark:bg-slate-100 dark:text-slate-900 dark:hover:bg-white"
          {{on 'click' cycleLayout}}
        >
          Cycle layout
        </button>
      </div>
    </div>

    <div class="layout-grid grid gap-4" role="list">
      {{#each items as |n|}}
        <div
          class="layout-item grid min-h-[72px] grid-cols-[auto_1fr] items-center gap-4 rounded-2xl border border-slate-200 bg-white/85 p-4 shadow-[0_12px_28px_rgba(15,23,42,0.08)] dark:border-slate-800 dark:bg-slate-950/40"
          role="listitem"
        >
          <div
            class="grid h-9 w-9 place-items-center rounded-full bg-gradient-to-br from-sky-400 to-violet-400 font-extrabold text-slate-900 shadow-[0_0_0_6px_rgba(224,242,254,0.8)]"
            aria-hidden="true"
          >
            {{n}}
          </div>
          <div>
            <p class="m-0 font-extrabold text-slate-900 dark:text-slate-100">Card {{n}}</p>
            <p class="m-0 mt-1 text-sm text-slate-600 dark:text-slate-300">
              Auto Layout animates position + size changes.
            </p>
          </div>
        </div>
      {{/each}}
    </div>

    <style>
      .layout-shell {
        background: radial-gradient(1200px circle at 10% 10%, rgba(224, 242, 254, 0.9), transparent 45%),
          radial-gradient(900px circle at 90% 0%, rgba(237, 233, 254, 0.85), transparent 45%),
          linear-gradient(180deg, rgba(248, 250, 252, 0.9), rgba(255, 255, 255, 0.92));
      }

      :global(html.dark) .layout-shell {
        background: radial-gradient(1200px circle at 10% 10%, rgba(14, 165, 233, 0.18), transparent 45%),
          radial-gradient(900px circle at 90% 0%, rgba(139, 92, 246, 0.16), transparent 45%),
          linear-gradient(180deg, rgba(2, 6, 23, 0.35), rgba(15, 23, 42, 0.25));
      }

      .layout-shell[data-grid='1'] .layout-grid {
        grid-template-columns: 1fr;
      }

      .layout-shell[data-grid='2'] .layout-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }

      .layout-shell[data-grid='3'] .layout-grid {
        grid-template-columns: repeat(4, minmax(0, 1fr));
      }

      .layout-shell.dense .layout-grid {
        gap: 0.55rem;
      }

      .layout-item {
        display: grid;
        grid-template-columns: auto 1fr;
        gap: 0.85rem;
        align-items: center;
        padding: 0.95rem 1rem;
        border-radius: 16px;
        background: rgba(255, 255, 255, 0.9);
        border: 1px solid #e2e8f0;
        box-shadow: 0 12px 28px rgba(15, 23, 42, 0.08);
        min-height: 72px;
      }

      .layout-shell[data-grid='3'] .layout-item {
        grid-template-columns: 1fr;
        text-align: left;
        min-height: 98px;
      }

      .layout-shell[data-grid='3'] .layout-item:nth-child(1),
      .layout-shell[data-grid='3'] .layout-item:nth-child(6) {
        grid-column: span 2;
      }
    </style>
  </section>
</template>;

export default <template>
  <section class="grid gap-5">
    <div class="grid gap-2">
      <p class="text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">
        Anime.js Auto Layout
      </p>
      <h1 class="text-2xl font-semibold tracking-tight text-slate-900 dark:text-slate-100">
        Grid / list toggle
      </h1>
      <p class="max-w-2xl text-slate-600 dark:text-slate-300">
        Creates a layout instance once, then calls <code>layout.update</code> when toggling CSS
        layout states.
      </p>
    </div>

    <Demo />
  </section>
</template>;
