import { on } from '@ember/modifier';

import { createLayout, stagger } from 'animejs';
import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';

type LayoutInstance = {
  revert?: () => void;
  record: () => void;
  animate: (options?: { duration?: number; delay?: unknown; ease?: string }) => void;
};

type Tone = 'sky' | 'violet' | 'emerald' | 'rose' | 'amber' | 'lime';
type Card = { id: string; title: string; detail: string; tone: Tone };

let nextId = 9;

const cards = cell<Card[]>([
  { id: '1', title: 'Observe', detail: 'Watch the layout shift', tone: 'sky' },
  { id: '2', title: 'Record', detail: 'Capture current layout', tone: 'violet' },
  { id: '3', title: 'Mutate', detail: 'Add/remove items', tone: 'emerald' },
  { id: '4', title: 'Animate', detail: 'Auto Layout does the rest', tone: 'rose' },
  { id: '5', title: 'Polish', detail: 'Stagger + easing', tone: 'amber' },
  { id: '6', title: 'Respect', detail: 'Reduced motion', tone: 'lime' },
]);

let layout: LayoutInstance | undefined;

const setupLayout = modifier((root: HTMLElement) => {
  layout = createLayout(root, {
    children: '[data-card]',
    duration: 750,
    ease: 'inOut(3.5)',
    enterFrom: { opacity: 0, scale: 0.9 },
    leaveTo: { opacity: 0, scale: 0.9 },
  }) as LayoutInstance;

  return () => {
    layout?.revert?.();
    layout = undefined;
  };
});

function afterDomUpdateAnimate() {
  requestAnimationFrame(() => {
    requestAnimationFrame(() => {
      layout?.animate({
        duration: 800,
        delay: stagger(30),
        ease: 'inOut(3.5)',
      });
    });
  });
}

function addCard() {
  if (!layout) return;

  layout.record();

  const id = String(nextId++);

  const tones: Tone[] = ['sky', 'violet', 'emerald', 'rose', 'amber', 'lime'];
  const tone = tones[(Number(id) - 1) % tones.length] ?? 'sky';

  cards.set([...cards.current, { id, title: `Card ${id}`, detail: 'Enters with enterFrom', tone }]);

  afterDomUpdateAnimate();
}

function removeCard(id: string) {
  if (!layout) return;

  layout.record();
  cards.set(cards.current.filter((card) => card.id !== id));
  afterDomUpdateAnimate();
}

function removeClicked(event: Event) {
  const target = event.currentTarget as HTMLElement | null;
  const id = target?.dataset?.remove;

  if (id) {
    removeCard(id);
  }
}

function reset() {
  if (!layout) return;

  layout.record();
  nextId = 9;
  cards.set([
    { id: '1', title: 'Observe', detail: 'Watch the layout shift', tone: 'sky' },
    { id: '2', title: 'Record', detail: 'Capture current layout', tone: 'violet' },
    { id: '3', title: 'Mutate', detail: 'Add/remove items', tone: 'emerald' },
    { id: '4', title: 'Animate', detail: 'Auto Layout does the rest', tone: 'rose' },
    { id: '5', title: 'Polish', detail: 'Stagger + easing', tone: 'amber' },
    { id: '6', title: 'Respect', detail: 'Reduced motion', tone: 'lime' },
  ]);

  afterDomUpdateAnimate();
}

export default <template>
  <section class="grid gap-5">
    <div class="grid gap-2">
      <p class="text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">
        Anime.js Auto Layout
      </p>
      <h1 class="text-2xl font-semibold tracking-tight text-slate-900 dark:text-slate-100">
        Enter / Exit
      </h1>
      <p class="max-w-2xl text-slate-600 dark:text-slate-300">
        Add and remove items with <code>enterFrom</code>/<code>leaveTo</code>, while the remaining
        items reflow smoothly.
      </p>
    </div>

    <section
      class="enter-shell mx-auto grid w-full max-w-[900px] gap-5 overflow-hidden rounded-[18px] border border-slate-200 bg-white/90 p-6 shadow-[0_14px_38px_rgba(15,23,42,0.08)] backdrop-blur dark:border-slate-800 dark:bg-slate-900/60"
      {{setupLayout}}
    >
      <div class="flex flex-wrap items-start justify-between gap-4" aria-label="Enter/exit controls">
        <div class="grid gap-1">
          <p class="text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">
            Controls
          </p>
          <p class="text-sm text-slate-600 dark:text-slate-300">Add a card, remove a card, or reset.</p>
        </div>

        <div class="flex flex-wrap gap-2">
          <button
            type="button"
            class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-900 shadow-sm transition hover:bg-slate-50 active:translate-y-px dark:border-slate-700 dark:bg-slate-950 dark:text-slate-100 dark:hover:bg-slate-900"
            {{on 'click' reset}}
          >
            Reset
          </button>
          <button
            type="button"
            class="rounded-xl border border-slate-900 bg-slate-900 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-slate-800 active:translate-y-px dark:border-slate-200 dark:bg-slate-100 dark:text-slate-900 dark:hover:bg-white"
            {{on 'click' addCard}}
          >
            Add card
          </button>
        </div>
      </div>

      <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3" role="list">
        {{#each cards.current as |card|}}
          <div
            class="enter-card relative grid gap-3 overflow-hidden rounded-2xl border border-slate-200 bg-white/85 p-4 shadow-[0_12px_28px_rgba(15,23,42,0.08)] dark:border-slate-800 dark:bg-slate-950/40"
            role="listitem"
            data-card
            data-tone={{card.tone}}
          >
            <div class="flex items-start justify-between gap-3">
              <p class="m-0 font-extrabold text-slate-900 dark:text-slate-100">{{card.title}}</p>
              <button
                type="button"
                class="rounded-full border border-slate-200 bg-white px-3 py-1 text-xs font-semibold text-slate-900 shadow-sm transition hover:bg-slate-50 active:translate-y-px dark:border-slate-700 dark:bg-slate-950 dark:text-slate-100 dark:hover:bg-slate-900"
                aria-label="Remove {{card.title}}"
                data-remove={{card.id}}
                {{on 'click' removeClicked}}
              >
                Remove
              </button>
            </div>
            <p class="m-0 text-sm text-slate-600 dark:text-slate-300">{{card.detail}}</p>
          </div>
        {{/each}}
      </div>

      <style>
        .enter-shell {
          background: radial-gradient(1200px circle at 10% 10%, rgba(254, 226, 226, 0.9), transparent 45%),
            radial-gradient(900px circle at 90% 0%, rgba(224, 242, 254, 0.85), transparent 45%),
            linear-gradient(180deg, rgba(248, 250, 252, 0.9), rgba(255, 255, 255, 0.92));
        }

        :global(html.dark) .enter-shell {
          background: radial-gradient(1200px circle at 10% 10%, rgba(244, 63, 94, 0.14), transparent 45%),
            radial-gradient(900px circle at 90% 0%, rgba(14, 165, 233, 0.14), transparent 45%),
            linear-gradient(180deg, rgba(2, 6, 23, 0.35), rgba(15, 23, 42, 0.25));
        }

        .enter-card::before {
          content: '';
          position: absolute;
          inset: -40% -25% auto auto;
          width: 260px;
          height: 260px;
          background: var(--enter-glow);
          transform: rotate(18deg);
          pointer-events: none;
          opacity: 0.9;
        }

        .enter-card[data-tone='sky'] {
          --enter-glow: radial-gradient(circle at 30% 30%, rgba(14, 165, 233, 0.26), transparent 65%);
        }

        .enter-card[data-tone='violet'] {
          --enter-glow: radial-gradient(circle at 30% 30%, rgba(139, 92, 246, 0.26), transparent 65%);
        }

        .enter-card[data-tone='emerald'] {
          --enter-glow: radial-gradient(circle at 30% 30%, rgba(34, 197, 94, 0.24), transparent 65%);
        }

        .enter-card[data-tone='rose'] {
          --enter-glow: radial-gradient(circle at 30% 30%, rgba(244, 63, 94, 0.22), transparent 65%);
        }

        .enter-card[data-tone='amber'] {
          --enter-glow: radial-gradient(circle at 30% 30%, rgba(245, 158, 11, 0.24), transparent 65%);
        }

        .enter-card[data-tone='lime'] {
          --enter-glow: radial-gradient(circle at 30% 30%, rgba(132, 204, 22, 0.22), transparent 65%);
        }
      </style>
    </section>
  </section>
</template>;
