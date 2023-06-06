import "./styles.css";

import { highlight } from 'docs-app/components/highlight';
import { RemoteData } from 'ember-resources/util/remote-data';

import type { TOC } from '@ember/component/template-only';
import type { DeclarationHierarchy,DeclarationReference,DeclarationReflection, Refl,Reflection,ReflectionGroup } from 'typedoc';

export function findChildDeclaration(info: Reflection , name: string) {
  return info.children?.find(child => child.variant === 'declaration' && child.name === name);
}

export const infoFor = (
  data: ReflectionGroup,
  module: string,
  name: string
) => {
  let found = data.children
    .find((child) => child.name === module)
    ?.children?.find((grandChild) => grandChild.name === name);

  return found as DeclarationReflection | undefined;
};

export const Query: TOC<{
  Args: { module: string; name: string; info: ReflectionGroup },
  Blocks: { default: [], notFound: [] }
}> = <template>
  {{#let (infoFor @info @module @name) as |info|}}
   {{#if info}}
      {{yield info}}
    {{else}}
      {{yield to="notFound"}}
    {{/if}}
  {{/let}}
</template>;

export const Load: TOC<{
  Args: { module: string; name: string; },
  Blocks: { default: [] }
}> = <template>
  {{#let (RemoteData '/api-docs.json') as |request|}}
    {{#if request.isLoading}}
      Loading api docs...
    {{/if}}

    {{#if request.value}}
      <section {{highlight request.value}}>
        <Query @info={{request.value}} @module={{@module}} @name={{@name}} as |type|>
          {{yield type}}
        </Query>
      </section>
    {{/if}}
  {{/let}}
</template>;
