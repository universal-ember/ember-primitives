/**
Styled tabs for documentation
*/

import {
  type ButtonType,
  type ContentType,
  type TabContainerType,
  Tabs as PrimitiveTabs,
} from 'ember-primitives/components/tabs';

import type { TOC } from '@ember/component/template-only';

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
      box-shadow: inset 0 -1px 1px black;
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
      border: 1px solid gray;
      color: black;
      padding: 1rem;
      border-radius: 0 0.25rem 0.25rem;
      background: white;
      width: 100%;
      overflow: auto;
      font-family: ui-monospace monospace;
    }
  </style>
</template>;

const StyledTab: TOC<{
  Args: {
    tab: TabContainerType;
  };
}> = <template>
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

export const Tabs = <template>
  <PrimitiveTabs class="docs-tabs" as |Tab|>
    {{yield (component StyledTab tab=Tab)}}
  </PrimitiveTabs>

  <style scoped>
    .docs-tabs {
      padding: 1rem;

      [role="tablist"] {
        min-width: 100%;
      }
    }
  </style>
</template>;
