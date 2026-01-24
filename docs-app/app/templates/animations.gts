import { GitHubLink, TestsLink } from 'docs-app/components/header';
import { Logomark } from 'docs-app/components/icons';

export default <template>
  <div class="min-h-screen">
    <header
      class="sticky top-0 z-40 border-b border-slate-200 bg-white/85 backdrop-blur dark:border-slate-800 dark:bg-slate-900/80"
    >
      <div class="mx-auto flex max-w-6xl items-center justify-between gap-4 px-4 py-3">
        <a href="/animations" class="flex items-center gap-3 text-slate-900 dark:text-slate-100">
          <Logomark class="h-7 w-7" />
          <span class="font-semibold tracking-tight">Animations</span>
        </a>

        <nav class="hidden items-center gap-1 md:flex" aria-label="Animations navigation">
          <a
            href="/animations"
            class="rounded-md px-3 py-2 text-sm font-medium text-slate-700 transition-colors hover:bg-slate-100 dark:text-slate-300 dark:hover:bg-slate-800"
          >
            Overview
          </a>
          <a
            href="/animations/layout-toggle"
            class="rounded-md px-3 py-2 text-sm font-medium text-slate-700 transition-colors hover:bg-slate-100 dark:text-slate-300 dark:hover:bg-slate-800"
          >
            Layout Toggle
          </a>
          <a
            href="/animations/dom-order"
            class="rounded-md px-3 py-2 text-sm font-medium text-slate-700 transition-colors hover:bg-slate-100 dark:text-slate-300 dark:hover:bg-slate-800"
          >
            DOM Order
          </a>
          <a
            href="/animations/enter-exit"
            class="rounded-md px-3 py-2 text-sm font-medium text-slate-700 transition-colors hover:bg-slate-100 dark:text-slate-300 dark:hover:bg-slate-800"
          >
            Enter / Exit
          </a>
          <a
            href="/animations/expand-cards"
            class="rounded-md px-3 py-2 text-sm font-medium text-slate-700 transition-colors hover:bg-slate-100 dark:text-slate-300 dark:hover:bg-slate-800"
          >
            Expand Cards
          </a>
        </nav>

        <div class="flex items-center gap-5">
          <TestsLink />
          <GitHubLink />
        </div>
      </div>
    </header>

    <main class="mx-auto w-full max-w-6xl px-4 py-8">
      {{outlet}}
    </main>
  </div>
</template>;
