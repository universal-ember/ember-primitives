/**
Styled tabs for documentation
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

const StyledButton: TOC<{ Args: { button: ButtonType }; Blocks: { default: [] } }> = <template>
  <@button class="tab">
    {{yield}}
  </@button>

  <style scoped>
    .tab {
      color: black;
      display: inline-block;
      padding: 0.25rem 0.5rem;
      background: hsl(220deg 20% 94%);
      outline: none;
      font-weight: bold;
      cursor: pointer;
      box-shadow: inset 0 0px 1px black;
    }
    .tab[aria-selected="true"] {
      background: white;
      box-shadow: inset 0 -4px 0px orange;
    }
    .tab:first-of-type {
      border-top-left-radius: 0.25rem;
    }
    .tab:last-of-type {
      border-top-right-radius: 0.25rem;
    }
  </style>
</template>;

const StyledContent: TOC<{ Args: { content: ContentType }; Blocks: { default: [] } }> = <template>
  <@content class="tabpanel">
    {{yield}}
  </@content>

  <style scoped>
    .tabpanel {
      color: black;
      overflow: auto;
      max-height: 20rem;
      width: 100%;
      max-width: 100%;
      border-radius: 0.75rem;
      background-image: linear-gradient(to right, var(--tw-gradient-stops));
      --tw-gradient-from: #7c3aed var(--tw-gradient-from-position);
      --tw-gradient-to: rgb(124 58 237 / 0) var(--tw-gradient-to-position);
      --tw-gradient-stops: var(--tw-gradient-from), var(--tw-gradient-to);
      --tw-gradient-to: #4f46e5 var(--tw-gradient-to-position);
      padding: 5rem;
      --tw-text-opacity: 1;
      color: rgb(248 250 252 / var(--tw-text-opacity, 1));
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
        {{! @glint-expect-error The types here are too crazy so I ignore them and define the public API}}
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
      padding: 1rem;

      > [role="tablist"] {
        min-width: 100%;
        padding-left: 0.75rem;
      }
    }
  </style>
</template>;
