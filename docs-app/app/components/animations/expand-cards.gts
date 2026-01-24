import { on } from '@ember/modifier';

import { createLayout, stagger } from 'animejs';
import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';

type LayoutInstance = {
  revert?: () => void;
  update: (
    callback: (context: { root: HTMLElement }) => void,
    options?: { duration?: number; delay?: unknown; ease?: string }
  ) => void;
};

type Card = {
  id: string;
  title: string;
  subtitle: string;
  tone: 'sky' | 'violet' | 'emerald' | 'rose' | 'amber' | 'lime';
};

const cards = [
  { id: 'alpha', title: 'Alpha', subtitle: 'Click to expand', tone: 'sky' },
  { id: 'bravo', title: 'Bravo', subtitle: 'Auto layout reflow', tone: 'violet' },
  { id: 'charlie', title: 'Charlie', subtitle: 'No manual transforms', tone: 'emerald' },
  { id: 'delta', title: 'Delta', subtitle: 'Feels ReactBits-ish', tone: 'rose' },
  { id: 'echo', title: 'Echo', subtitle: 'Smooth + snappy', tone: 'amber' },
  { id: 'foxtrot', title: 'Foxtrot', subtitle: 'Try on mobile width', tone: 'lime' },
] satisfies Card[];

const activeId = cell<string | null>(null);

let layout: LayoutInstance | undefined;

const setupLayout = modifier((root: HTMLElement) => {
  layout = createLayout(root, {
    children: '[data-expand-card]',
    duration: 850,
    ease: 'inOut(3.5)',
    properties: ['borderRadius', 'boxShadow'],
  }) as LayoutInstance;

  root.dataset.active = '';

  return () => {
    layout?.revert?.();
    layout = undefined;
  };
});

function toggleCard(card: Card) {
  if (!layout) return;

  layout.update(
    ({ root }) => {
      const next = activeId.current === card.id ? null : card.id;

      activeId.set(next);
      root.dataset.active = next ?? '';
    },
    {
      duration: 900,
      delay: stagger(25),
      ease: 'inOut(3.5)',
    }
  );
}

function close() {
  if (!layout) return;

  layout.update(
    ({ root }) => {
      activeId.set(null);
      root.dataset.active = '';
    },
    {
      duration: 750,
      delay: stagger(20),
      ease: 'inOut(3.5)',
    }
  );
}

function toggleFromEvent(event: Event) {
  const target = event.currentTarget as HTMLElement | null;
  const id = target?.dataset?.id;
  const card = cards.find((c) => c.id === id);

  if (card) {
    toggleCard(card);
  }
}

export default <template>
  <section class="grid gap-5">
    <div class="grid gap-2">
      <p class="text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">
        ReactBits-ish
      </p>
      <h1 class="text-2xl font-semibold tracking-tight text-slate-900 dark:text-slate-100">
        Expanding cards
      </h1>
      <p class="max-w-2xl text-slate-600 dark:text-slate-300">
        Click a card to expand it. The CSS grid changes; Anime.js Auto Layout animates the
        transitions.
      </p>
    </div>

    <section
      class="expand-shell mx-auto grid w-full max-w-[980px] gap-5 overflow-hidden rounded-[18px] border border-slate-200 bg-white/90 p-6 shadow-[0_14px_38px_rgba(15,23,42,0.08)] backdrop-blur dark:border-slate-800 dark:bg-slate-900/60"
      {{setupLayout}}
    >
      <div class="flex flex-wrap items-center justify-between gap-3" aria-label="Expanding cards controls">
        <p class="text-sm text-slate-600 dark:text-slate-300">
          Active:
          <span class="font-semibold text-slate-900 dark:text-slate-100">
            {{if activeId.current activeId.current 'none'}}
          </span>
        </p>
        <button
          type="button"
          class="rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-semibold text-slate-900 shadow-sm transition hover:bg-slate-50 active:translate-y-px disabled:cursor-not-allowed disabled:opacity-60 dark:border-slate-700 dark:bg-slate-950 dark:text-slate-100 dark:hover:bg-slate-900"
          {{on 'click' close}}
          disabled={{if activeId.current false true}}
        >
          Close
        </button>
      </div>

      <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3" role="list">
        {{#each cards as |card|}}
          <button
            type="button"
            data-expand-card
            data-id={{card.id}}
            class="expand-card relative grid min-h-[130px] content-between gap-3 overflow-hidden rounded-2xl border border-slate-200 bg-white/85 p-4 text-left shadow-[0_12px_28px_rgba(15,23,42,0.08)] transition-colors hover:bg-white dark:border-slate-800 dark:bg-slate-950/40 dark:hover:bg-slate-950"
            data-tone={{card.tone}}
            aria-label="Toggle {{card.title}}"
            {{on 'click' toggleFromEvent}}
          >
            <div class="relative">
              <p class="m-0 text-[1.05rem] font-black tracking-tight text-slate-900 dark:text-slate-100">
                {{card.title}}
              </p>
              <p class="m-0 mt-1 text-sm text-slate-600 dark:text-slate-300">{{card.subtitle}}</p>
            </div>
            <div class="relative text-sm font-semibold text-slate-900/70 dark:text-slate-100/70">
              Click to toggle
            </div>
          </button>
        {{/each}}
      </div>

      <style>
        .expand-shell {
          background: radial-gradient(1200px circle at 0% 0%, rgba(237, 233, 254, 0.85), transparent 45%),
            radial-gradient(900px circle at 90% 0%, rgba(224, 242, 254, 0.85), transparent 45%),
            linear-gradient(180deg, rgba(248, 250, 252, 0.9), rgba(255, 255, 255, 0.92));
        }

        :global(html.dark) .expand-shell {
          background: radial-gradient(1200px circle at 0% 0%, rgba(139, 92, 246, 0.14), transparent 45%),
            radial-gradient(900px circle at 90% 0%, rgba(14, 165, 233, 0.14), transparent 45%),
            linear-gradient(180deg, rgba(2, 6, 23, 0.35), rgba(15, 23, 42, 0.25));
        }

        .expand-card::before {
          content: '';
          position: absolute;
          inset: -45% -35% auto auto;
          width: 340px;
          height: 340px;
          background: var(--expand-glow);
          transform: rotate(18deg);
          pointer-events: none;
          opacity: 0.9;
        }

        .expand-card[data-tone='sky'] {
          --expand-glow: radial-gradient(circle at 30% 30%, rgba(14, 165, 233, 0.26), transparent 65%);
        }

        .expand-card[data-tone='violet'] {
          --expand-glow: radial-gradient(circle at 30% 30%, rgba(139, 92, 246, 0.26), transparent 65%);
        }

        .expand-card[data-tone='emerald'] {
          --expand-glow: radial-gradient(circle at 30% 30%, rgba(34, 197, 94, 0.24), transparent 65%);
        }

        .expand-card[data-tone='rose'] {
          --expand-glow: radial-gradient(circle at 30% 30%, rgba(244, 63, 94, 0.22), transparent 65%);
        }

        .expand-card[data-tone='amber'] {
          --expand-glow: radial-gradient(circle at 30% 30%, rgba(245, 158, 11, 0.24), transparent 65%);
        }

        .expand-card[data-tone='lime'] {
          --expand-glow: radial-gradient(circle at 30% 30%, rgba(132, 204, 22, 0.22), transparent 65%);
        }

        .expand-shell[data-active='alpha'] .expand-card[data-id='alpha'],
        .expand-shell[data-active='bravo'] .expand-card[data-id='bravo'],
        .expand-shell[data-active='charlie'] .expand-card[data-id='charlie'],
        .expand-shell[data-active='delta'] .expand-card[data-id='delta'],
        .expand-shell[data-active='echo'] .expand-card[data-id='echo'],
        .expand-shell[data-active='foxtrot'] .expand-card[data-id='foxtrot'] {
          grid-column: 1 / -1;
          min-height: 220px;
        }
      </style>
    </section>
  </section>
</template>;
