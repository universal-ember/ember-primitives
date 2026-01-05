import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import { service } from '@ember/service';

import { modifier as eModifier } from 'ember-modifier';
import { CommandPalette } from 'ember-primitives';
import { docsManager } from 'kolay';

import type RouterService from '@ember/routing/router-service';
import type { Page } from 'kolay';

interface PageData {
  path: string;
  title: string;
  category: string;
}

function titleize(str: string): string {
  return (
    str
      .split(/-|\s/)
      .filter(Boolean)
      .filter((text) => !text.match(/^[\d]+$/))
      .map((text) => `${text[0]?.toLocaleUpperCase()}${text.slice(1, text.length)}`)
      .join(' ')
      .split('.')[0] || ''
  );
}

function extractPages(pages: Page[], category = ''): PageData[] {
  const result: PageData[] = [];

  for (const page of pages) {
    if ('path' in page) {
      let title = titleize(page.name);

      if ('title' in page && typeof page.title === 'string') {
        title = page.title;
      }

      result.push({
        path: page.path,
        title,
        category: category || 'Documentation',
      });
    }

    if ('pages' in page && Array.isArray(page.pages)) {
      result.push(...extractPages(page.pages as Page[], titleize(page.name)));
    }
  }

  return result;
}

const registerKeyboardShortcut = eModifier<{
  Args: {
    Positional: [(event: KeyboardEvent) => void];
  };
}>((element, [callback]) => {
  function handleKeydown(event: KeyboardEvent) {
    // Cmd+K or Ctrl+K to open search
    if ((event.metaKey || event.ctrlKey) && event.key === 'k') {
      event.preventDefault();
      callback(event);
    }
  }

  document.addEventListener('keydown', handleKeydown);

  return () => {
    document.removeEventListener('keydown', handleKeydown);
  };
});

export class DocsSearch extends Component {
  @service declare router: RouterService;

  @tracked searchQuery = '';

  @tracked isOpen = false;

  get allPages(): PageData[] {
    const m = docsManager(this);

    if (!m) return [];

    return extractPages(m.pages || []);
  }

  get filteredPages(): PageData[] {
    if (!this.searchQuery) {
      return this.allPages.slice(0, 10); // Show first 10 when no query
    }

    const query = this.searchQuery.toLowerCase();

    return this.allPages
      .filter(
        (page) =>
          page.title.toLowerCase().includes(query) ||
          page.path.toLowerCase().includes(query) ||
          page.category.toLowerCase().includes(query)
      )
      .slice(0, 10); // Limit to 10 results
  }

  handleInput = (event: Event) => {
    const target = event.target as HTMLInputElement;

    this.searchQuery = target.value;
  };

  selectPage = (page: PageData) => {
    this.router.transitionTo(page.path);
    this.searchQuery = '';
    this.isOpen = false;
  };

  open = () => {
    this.isOpen = true;
  };

  close = () => {
    this.isOpen = false;
    this.searchQuery = '';
  };

  <template>
    {{! Register global keyboard shortcut }}
    {{registerKeyboardShortcut this.open}}
    <button
      type="button"
      class="group flex items-center gap-2 px-3 py-1.5 text-sm text-slate-500 transition bg-white dark:bg-slate-800 border border-slate-300 dark:border-slate-600 rounded-md hover:border-slate-400 dark:hover:border-slate-500 focus:outline-none focus:ring-2 focus:ring-sky-500"
      {{on "click" this.open}}
      aria-label="Search documentation"
    >
      <svg
        class="w-4 h-4"
        fill="none"
        stroke="currentColor"
        viewBox="0 0 24 24"
        xmlns="http://www.w3.org/2000/svg"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
        ></path>
      </svg>
      <span class="hidden sm:inline">Search docs...</span>
      <kbd
        class="hidden ml-auto text-xs font-semibold text-slate-400 sm:inline-flex items-center gap-0.5"
      >
        <abbr title="Command" class="no-underline">⌘</abbr>K
      </kbd>
    </button>

    <CommandPalette @open={{this.isOpen}} @onClose={{this.close}} as |cp|>
      <cp.Dialog>
        <div class="flex flex-col max-h-[60vh] bg-white dark:bg-slate-900 rounded-lg">
          <cp.Input
            class="w-full px-4 py-3 text-base border-b border-slate-200 dark:border-slate-700 bg-transparent text-slate-900 dark:text-slate-100 focus:outline-none placeholder-slate-400"
            placeholder="Search documentation..."
            value={{this.searchQuery}}
            {{on "input" this.handleInput}}
          />

          <cp.List class="overflow-y-auto px-2 py-2 max-h-[400px] focus:outline-none" tabindex="0">
            {{#if this.filteredPages.length}}
              {{#each this.filteredPages as |page|}}
                <cp.Item
                  class="flex flex-col px-3 py-2 rounded cursor-pointer focus:bg-slate-100 dark:focus:bg-slate-800 focus:outline-none hover:bg-slate-50 dark:hover:bg-slate-800/50"
                  @onSelect={{fn this.selectPage page}}
                >
                  <div class="font-medium text-slate-900 dark:text-slate-100">
                    {{page.title}}
                  </div>
                  <div class="text-xs text-slate-500 dark:text-slate-400">
                    {{page.category}}
                    •
                    {{page.path}}
                  </div>
                </cp.Item>
              {{/each}}
            {{else}}
              <div class="px-3 py-8 text-center text-slate-500 dark:text-slate-400">
                {{#if this.searchQuery}}
                  No results found for "{{this.searchQuery}}"
                {{else}}
                  Start typing to search...
                {{/if}}
              </div>
            {{/if}}
          </cp.List>
        </div>
      </cp.Dialog>
    </CommandPalette>
  </template>
}
