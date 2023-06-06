
import { Comment,Type } from '../renderer';
import { findChildDeclaration,Load } from '../utils';

import type { TOC } from '@ember/component/template-only';

export const ComponentSignature: TOC<{ Args: { module: string; name: string; }}> = <template>
  <Load @module={{@module}} @name={{@name}} as |info|>
    <Element @info={{findChildDeclaration info "Element"}} />
    <Args @info={{findChildDeclaration info "Args"}} />
    <Blocks @info={{findChildDeclaration info "Blocks"}} />
  </Load>
</template>;

const Args: TOC<{ Args: { info: any}}> = <template>
  {{#if @info}}
    <h3>Arguments</h3>
    {{#each @info.type.declaration.children as |child|}}
      <span class="typedoc-component-arg">
        <pre class="typedoc-name">@{{child.name}}</pre>
        <Type @info={{child.type}} />
        <Comment @info={{child}} />
      </span>
    {{/each}}
  {{/if}}
</template>;

const Element: TOC<{ Args: { info: any}}> = <template>
  {{#if @info}}
    <span class="typedoc-component-element">
      <span class="typedoc-name">{{@info.name}}</span>
      <Type @info={{@info.type}} />
      <Comment @info={{@info}} />
    </span>
  {{/if}}
</template>;

const Blocks: TOC<{ Args: { info: any}}> = <template>
  {{#if @info}}
    <h3>Blocks</h3>
    {{#each @info.type.declaration.children as |child|}}
      <span class="typedoc-component-block">
        <pre class="typedoc-name">&lt;:{{child.name}}&gt;</pre>
        <Type @info={{child.type}} />
        <Comment @info={{child}} />
      </span>
    {{/each}}
  {{/if}}
</template>;
