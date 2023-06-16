import { ExternalLink } from 'ember-primitives';

import { Comment, Type } from '../renderer';
import { findChildDeclaration, Load } from '../utils';

import type { TOC } from '@ember/component/template-only';
import type { DeclarationReflection } from 'typedoc';

function getSignature(info: DeclarationReflection) {
  /**
   * export const Foo: TOC<{ signature here }> = <template> ... </template>
   */
  if (info.type?.type === 'reference' && info.type?.typeArguments?.[0]?.type === 'reflection') {
    return info.type.typeArguments[0].declaration;
  }

  /**
   * export interface Signature { ... }
   */
  return info;
}

export const ComponentSignature: TOC<{ Args: { module: string; name: string } }> = <template>
  <Load @module={{@module}} @name={{@name}} as |declaration|>
    {{#let (getSignature declaration) as |info|}}
      <Element @info={{findChildDeclaration info 'Element'}} />
      <Args @info={{findChildDeclaration info 'Args'}} />
      <Blocks @info={{findChildDeclaration info 'Blocks'}} />
    {{/let}}
  </Load>
</template>;

const Args: TOC<{ Args: { info: any } }> = <template>
  {{#if @info}}
    <h3 class='typedoc-heading'>Arguments</h3>
    {{#each @info.type.declaration.children as |child|}}
      <span class='typedoc-component-arg'>
        <span class='typedoc-component-arg-info'>
          <pre class='typedoc-name'>@{{child.name}}</pre>
          <Type @info={{child.type}} />
        </span>
        <Comment @info={{child}} />
      </span>
    {{/each}}
  {{/if}}
</template>;

const mdnElement = (typeName: string) => {
  let element = typeName.replace('HTML', '').replace('Element', '').toLowerCase();

  return `https://developer.mozilla.org/en-US/docs/Web/HTML/Element/${element}`;
};

const Element: TOC<{ Args: { info: any } }> = <template>
  {{#if @info}}
    <span class='typedoc-component-element'>
      <span class='typedoc-name'>{{@info.name}}</span>
      <ExternalLink href={{mdnElement @info.type.name}} class='typedoc-type-link'>
        {{@info.type.name}}
        ➚
      </ExternalLink>
      <Comment @info={{@info}} />
    </span>
  {{/if}}
</template>;

const Blocks: TOC<{ Args: { info: any } }> = <template>
  {{#if @info}}
    <h3 class='typedoc-heading'>Blocks</h3>
    {{#each @info.type.declaration.children as |child|}}
      <span class='typedoc-component-block'>
        <pre class='typedoc-name'>&lt;:{{child.name}}&gt;</pre>
        <span class='typedoc-category'>Properties</span>
        <div>
          <Type @info={{child.type}} />
          <Comment @info={{child}} />
        </div>
      </span>
    {{/each}}
  {{/if}}
</template>;
