import { highlight } from 'docs-app/components/highlight';
import { RemoteData } from 'ember-resources/util/remote-data';

import type { TOC } from '@ember/component/template-only';
import type { DeclarationReflection } from 'typedoc';

export function findChildDeclaration(info: DeclarationReflection, name: string) {
  return info.children?.find((child) => child.variant === 'declaration' && child.name === name);
}

export const infoFor = (data: DeclarationReflection, module: string, name: string) => {
  let moduleType =
  data.children
    ?.find((child) => child.name === module)

    console.log(data, moduleType);

  let found = moduleType
    ?.children?.find((grandChild) => grandChild.name === name);

  return found as DeclarationReflection | undefined;
};

export const Query: TOC<{
  Args: { module: string; name: string; info: DeclarationReflection };
  Blocks: { default: [DeclarationReflection]; notFound: [] };
}> = <template>
  {{#let (infoFor @info @module @name) as |info|}}
    {{#if info}}
      {{yield info}}
    {{else}}
      {{yield to='notFound'}}
    {{/if}}
  {{/let}}
</template>;

function isDeclarationReflection(info: unknown): info is DeclarationReflection {
  return true;
}

export const Load: TOC<{
  Args: { module: string; name: string };
  Blocks: { default: [DeclarationReflection] };
}> = <template>
  {{#let (RemoteData '/api-docs.json') as |request|}}
    {{#if request.isLoading}}
      Loading api docs...
    {{/if}}

    {{#if request.value}}
      <section {{highlight request.value}}>
        {{#if (isDeclarationReflection request.value)}}
          <Query @info={{request.value}} @module={{@module}} @name={{@name}} as |type|>
            {{yield type}}
          </Query>
        {{/if}}
      </section>
    {{/if}}
  {{/let}}
</template>;
