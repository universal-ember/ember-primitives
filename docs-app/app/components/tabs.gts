/**
 * Styled tabs for documentation demos
 */

import {
  type ButtonType,
  type ContainerType,
  type ContentType,
  Tabs as PrimitiveTabs,
} from 'ember-primitives/components/tabs';

import type { TOC } from '@ember/component/template-only';
import type { ComponentLike, WithBoundArgs } from '@glint/template';

function isString(x: unknown): x is string {
  return typeof x === 'string';
}

const StyledButton: TOC<{
  Element: HTMLButtonElement;
  Args: { button: ButtonType };
  Blocks: { default: [] };
}> = <template>
  <@button class="tab">
    {{yield}}
  </@button>

  <style scoped>
    .tab {
      position: relative;
      display: inline-flex;
      align-items: center;
      padding: 0.45rem 0.85rem 0.7rem;
      border: 0;
      border-radius: 0;
      background: transparent;
      color: var(--doc-text-3);
      font-family: var(--font-sans);
      font-size: 0.8125rem;
      font-weight: 500;
      cursor: pointer;
      box-shadow: none;
      outline: none;
      transition: color 0.12s ease;
    }

    .tab:hover {
      color: var(--doc-text-1);
    }

    .tab[aria-selected="true"] {
      color: var(--doc-brand-1);
      font-weight: 600;
    }

    .tab[aria-selected="true"]::after {
      content: "";
      position: absolute;
      left: 0.55rem;
      right: 0.55rem;
      bottom: -1px;
      height: 2px;
      border-radius: 2px 2px 0 0;
      background: var(--doc-brand-1);
    }
  </style>
</template>;

const StyledContent: TOC<{
  Element: HTMLDivElement;
  Args: { content: ContentType };
  Blocks: { default: [] };
}> = <template>
  <@content class="tabpanel">
    {{yield}}
  </@content>

  <style scoped>
    .tabpanel {
      padding: 1.15rem 1.1rem;
      color: var(--doc-text-1);
      font-family: var(--font-mono);
      font-size: 0.875rem;
      line-height: 1.6;
      background: transparent;
      overflow: auto;
      max-height: 20rem;
      width: 100%;
      max-width: 100%;
    }
  </style>
</template>;

const StyledTab: TOC<
  | {
      Args: {
        tab: ContainerType;
        label: never;
        content: never;
      };
      Blocks: {
        default: [button: ButtonType, content: ContentType];
      };
    }
  | {
      Args: {
        label: string | ComponentLike;
        content: string | ComponentLike;
        tab: ContainerType;
      };
      Blocks: {
        default: [];
      };
    }
> = <template>
  <@tab as |UnstyledButton UnstyledContent|>
    {{#let
      (component StyledButton button=UnstyledButton)
      (component StyledContent content=UnstyledContent)
      as |Button Content|
    }}

      {{#if @label}}
        <Button>
          {{#if (isString @label)}}
            {{@label}}
          {{else}}
            <@label />
          {{/if}}
        </Button>

        <Content>
          {{#if @content}}
            {{#if (isString @content)}}
              {{@content}}
            {{else}}
              <@content />
            {{/if}}
          {{else}}
            {{yield}}
          {{/if}}
        </Content>
      {{else}}
        {{yield Button Content}}
      {{/if}}
    {{/let}}
  </@tab>
</template>;

export const Tabs: TOC<{
  Blocks: {
    default: [WithBoundArgs<typeof StyledTab, 'tab'>];
  };
}> = <template>
  <PrimitiveTabs class="docs-tabs" as |Tab|>
    {{yield (component StyledTab tab=Tab)}}
  </PrimitiveTabs>

  <style scoped>
    .docs-tabs {
      margin: 0;
      border: 1px solid var(--doc-border);
      border-radius: var(--doc-radius-md);
      background: var(--doc-bg-alt);
      overflow: hidden;
    }

    .docs-tabs > .ember-primitives__tabs__label {
      padding: 0.7rem 1rem 0;
      font-size: 0.75rem;
      font-weight: 600;
      letter-spacing: 0.04em;
      text-transform: uppercase;
      color: var(--doc-text-3);
    }

    .docs-tabs > [role="tablist"] {
      display: flex;
      flex-wrap: wrap;
      gap: 0;
      width: 100%;
      min-width: 0;
      padding: 0.55rem 0.65rem 0;
      border-bottom: 1px solid var(--doc-border);
      background: transparent;
    }
  </style>
</template>;
