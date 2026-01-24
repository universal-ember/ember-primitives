import { on } from '@ember/modifier';

import { createLayout, stagger, utils } from 'animejs';
import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';

type LayoutInstance = {
  revert?: () => void;
  record: () => void;
  animate: (options?: { duration?: number; delay?: unknown; ease?: string }) => void;
};

type Task = { id: string; title: string; meta: string };

const initialTasks: Task[] = [
  { id: 'A', title: 'Ship the release', meta: 'Cut tags, publish packages, announce.' },
  { id: 'B', title: 'Triage issues', meta: 'Group, label, and prioritize.' },
  { id: 'C', title: 'Polish docs', meta: 'Improve examples and guidance.' },
  { id: 'D', title: 'Record a demo', meta: 'Show the motion and UX.' },
  { id: 'E', title: 'Collect feedback', meta: 'Turn reactions into improvements.' },
  { id: 'F', title: 'Sweep perf', meta: 'Trim rerenders, audit layout thrash.' },
];

const tasks = cell<Task[]>([...initialTasks]);

let layout: LayoutInstance | undefined;

const setupLayout = modifier((root: HTMLElement) => {
  layout = createLayout(root, {
    children: '[data-layout-item]',
    duration: 700,
    ease: 'inOut(3.5)',
    enterFrom: { opacity: 0 },
    leaveTo: { opacity: 0 },
  }) as LayoutInstance;

  return () => {
    layout?.revert?.();
    layout = undefined;
  };
});

function animateReorder(change: () => void, delayStep = 30) {
  if (!layout) {
    change();

    return;
  }

  layout.record();
  change();

  requestAnimationFrame(() => {
    requestAnimationFrame(() => {
      layout?.animate({
        duration: 800,
        delay: stagger(delayStep),
        ease: 'inOut(3.5)',
      });
    });
  });
}

function shuffleTasks() {
  animateReorder(() => {
    tasks.set(utils.shuffle([...tasks.current]) as Task[]);
  }, 35);
}

function reverseTasks() {
  animateReorder(() => {
    tasks.set([...tasks.current].reverse());
  }, 25);
}

function resetTasks() {
  animateReorder(() => {
    tasks.set([...initialTasks]);
  }, 20);
}
export default <template>
  <section class="grid gap-5">
    <div class="grid gap-2">
      <p class="text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">
        Anime.js Auto Layout
      </p>
      <h1 class="text-2xl font-semibold tracking-tight text-slate-900 dark:text-slate-100">
        DOM order changes
      </h1>
      <p class="max-w-2xl text-slate-600 dark:text-slate-300">
        Uses <code>record()</code> → update Ember state → <code>animate()</code> to transition between DOM
        orders.
      </p>
    </div>

    <section
      class="order-shell mx-auto grid w-full max-w-[920px] gap-5 overflow-hidden rounded-[18px] border border-slate-200 bg-white/90 p-6 shadow-[0_14px_38px_rgba(15,23,42,0.08)] backdrop-blur dark:border-slate-800 dark:bg-slate-900/60"
      {{setupLayout}}
    >
      <header class="flex flex-wrap items-start justify-between gap-4" aria-label="DOM order controls">
        <p class="text-sm text-slate-600 dark:text-slate-300">Shuffle or reverse the list.</p>

        <div class="flex flex-wrap gap-2">
          <button
            type="button"
            class="rounded-xl border border-slate-900 bg-slate-900 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-slate-800 active:translate-y-px dark:border-slate-200 dark:bg-slate-100 dark:text-slate-900 dark:hover:bg-white"
            {{on 'click' shuffleTasks}}
          >
            Shuffle
          </button>
          <button
            type="button"
            class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-900 shadow-sm transition hover:bg-slate-50 active:translate-y-px dark:border-slate-700 dark:bg-slate-950 dark:text-slate-100 dark:hover:bg-slate-900"
            {{on 'click' reverseTasks}}
          >
            Reverse
          </button>
          <button
            type="button"
            class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-900 shadow-sm transition hover:bg-slate-50 active:translate-y-px dark:border-slate-700 dark:bg-slate-950 dark:text-slate-100 dark:hover:bg-slate-900"
            {{on 'click' resetTasks}}
          >
            Reset
          </button>
        </div>
      </header>

      <ol class="grid gap-4" role="list">
        {{#each tasks.current as |task|}}
          <li
            class="order-item relative grid min-h-[86px] grid-cols-[auto_1fr] items-center gap-4 overflow-hidden rounded-2xl border border-slate-200 bg-white/85 p-4 shadow-[0_12px_28px_rgba(15,23,42,0.08)] dark:border-slate-800 dark:bg-slate-950/40"
            data-layout-item
          >
            <div
              class="grid h-9 w-9 place-items-center rounded-full bg-gradient-to-br from-emerald-300 to-sky-400 font-extrabold text-slate-900 shadow-[0_0_0_6px_rgba(220,252,231,0.7)]"
              aria-hidden="true"
            >
              {{task.id}}
            </div>
            <div>
              <p class="m-0 font-extrabold text-slate-900 dark:text-slate-100">{{task.title}}</p>
              <p class="m-0 mt-1 text-sm text-slate-600 dark:text-slate-300">{{task.meta}}</p>
            </div>
          </li>
        {{/each}}
      </ol>

      <style>
        .order-shell {
          background: radial-gradient(1000px circle at 0% 0%, rgba(220, 252, 231, 0.85), transparent 50%),
            radial-gradient(900px circle at 95% 10%, rgba(219, 234, 254, 0.9), transparent 55%),
            linear-gradient(180deg, rgba(248, 250, 252, 0.9), rgba(255, 255, 255, 0.92));
        }

        :global(html.dark) .order-shell {
          background: radial-gradient(1000px circle at 0% 0%, rgba(34, 197, 94, 0.14), transparent 50%),
            radial-gradient(900px circle at 95% 10%, rgba(59, 130, 246, 0.12), transparent 55%),
            linear-gradient(180deg, rgba(2, 6, 23, 0.35), rgba(15, 23, 42, 0.25));
        }

        .order-item::before {
          content: '';
          position: absolute;
          inset: -40% -20% auto auto;
          width: 260px;
          height: 260px;
          background: radial-gradient(circle at 30% 30%, rgba(59, 130, 246, 0.22), transparent 65%);
          transform: rotate(18deg);
          pointer-events: none;
        }
      </style>
    </section>
  </section>

</template>;
