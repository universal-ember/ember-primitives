
export const NavButtonGroup = <template>
  <div
    class="hidden md:flex gap-1 items-center justify-center absolute left-1/2 transform -translate-x-1/2"
    role="group"
    aria-label="Section navigation"
  >
    <a
      href="/1-get-started/index.md"
      class="px-4 py-2 text-sm font-medium transition-colors rounded-md text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800"
    >
      Primitives
    </a>
    <a
      href="/animations"
      class="px-4 py-2 text-sm font-medium transition-colors rounded-md text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800"
    >
      Animations
    </a>
    <a
      href="/9-blocks/index.md"
      class="px-4 py-2 text-sm font-medium transition-colors rounded-md text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800"
    >
      Blocks
    </a>
  </div>
</template>;
