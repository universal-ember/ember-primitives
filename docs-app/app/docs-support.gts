import { highlight } from 'docs-app/components/highlight';
import { Compiled, defaultOptions } from 'docs-app/markdown';
import { RemoteData } from 'ember-resources/util/remote-data';

import type { TOC } from '@ember/component/template-only';
import type { DeclarationReference,DeclarationReflection,ReferenceType,ReflectionGroup, SomeType } from 'typedoc';

const infoFor = (data: ReflectionGroup, module: string, name: string) => {
  let found = data.children
  .find(child => child.name === module)
  ?.children?.find(grandChild => grandChild.name === name);

  return found as DeclarationReflection | undefined;
};

/**
  * Assumptions:
  * - we are documenting public API
  *   - component properties and methods are not public API
  *     - including the constructor, inherited methods, etc
  *   - only the signature describes what the public API is.
  */
export const APIDocs: TOC<{
  Args: {
    module: string;
    name: string;
  }
}> = <template>
  {{#let (RemoteData '/api-docs.json') as |request|}}
    {{#if request.isLoading}}
      Loading api docs...
    {{/if}}

    {{#if request.value}}
      <Styles />

      <section {{highlight request.value}}>
        {{#let (infoFor request.value @module @name) as |info|}}
          {{#if (isGlimmerComponent info)}}
            <GlimmerComponent @info={{info}} />
          {{else}}
            <Declaration @info={{info}} />
          {{/if}}

        {{/let}}
      </section>
    {{/if}}
  {{/let}}
</template>;

function isGlimmerComponent(info: DeclarationReference) {
  let extended = info?.extendedTypes?.[0]

  if (!extended) return false;

  return extended.name === 'default' && extended.package === '@glimmer/component';
}

function typeArg(info: DeclarationReference) {
  let extended = info?.extendedTypes?.[0]

  if (!extended) return false;

  return extended.typeArguments[0]
}

const GlimmerComponent: TOC<{ Args: { info: SomeType }}> = <template>
  <Type @info={{typeArg @info}} />
</template>;

const join = (lines: string[]) => lines.join('\n');
const text = (lines: { text: string }[]) => lines.map(line => line.text);
const isIgnored = (name: string) => ['__type', 'TOC', 'TemplateOnlyComponent'].includes(name);
const isConst = (x) => x.flags.isConst;
const not = x => !x;

const RenderedComment: TOC<{}> = <template>
  {{#let (Compiled (join (text @text)) defaultOptions) as |compiled|}}
    {{#if compiled.isReady}}
      <compiled.component />
    {{/if}}
  {{/let}}
</template>;

const Declaration: TOC<{
  Args: {
    info: DeclarationReflection | undefined
  }
}> = <template>
  {{#if @info}}
    {{log @info.name @info}}
    {{#if (not (isIgnored @info.name))}}
      <h3 class="typedoc-declaration-name">{{@info.name}}</h3>
    {{/if}}

    {{#if (isConst @info)}}
      {{#if @info.comment.summary}}
        <RenderedComment @text={{@info.comment.summary}} />
      {{/if}}
    {{/if}}

    {{#if @info.type}}
      <Type @info={{@info.type}} />
    {{/if}}

    <ul>
      {{#each @info.children as |child|}}
        <li><Declaration @info={{child}} /></li>
      {{/each}}
    </ul>
    {{#if (not (isConst @info))}}
      {{#if @info.comment.summary}}
        <RenderedComment @text={{@info.comment.summary}} />
      {{/if}}
    {{/if}}

  {{/if}}
</template>;

const Reflection: TOC<{ info: { declaration: DeclarationReflection }}> = <template>
  <Declaration @info={{@info.declaration}} />
</template>;

const isReference = (x: { type: string }) => x.type === 'reference';
const isReflection = (x: { type: string }) => x.type === 'reflection';
const isIntrinsic = (x: { type: string }) => x.type === 'intrinsic';
const isTuple = (x: { type: string }) => x.type === 'tuple';

const Reference: TOC<{ info: ReferenceType }> = <template>
  {{log @info}}
  {{#if (not (isIgnored @info.name))}}
    <pre class="typedoc-reference">{{@info.name}}</pre>
  {{/if}}
  {{#each @info.typeArguments as |typeArg|}}
     <Type @info={{typeArg}} />
  {{/each}}
</template>;

const Intrinsic: TOC<{}> = <template>
  <span class="typedoc-intrinsic">{{@info.name}}</span>
</template>;

const Tuple: TOC<{ Args: { info: SomeType }}> = <template>
  {{#each @info.elements as |element|}}
    <Type @info={{element}} />
  {{/each}}
</template>;

const Type: TOC<{ Args: { info: SomeType }}> = <template>
  {{#if (isReference @info)}}
    <Reference @info={{@info}} />
  {{else if (isReflection @info)}}
    <Reflection @info={{@info}} />
  {{else if (isIntrinsic @info)}}
    <Intrinsic @info={{@info}} />
  {{else if (isTuple @info)}}
    <Tuple @info={{@info}} />
  {{else}}
    {{log 'x' @info}}
  {{/if}}
</template>;

const Styles = <template>
  <style>
    .typedoc-reference,
    .typedoc-intrinsic {
      border: 1px solid #222;
      background: #eee;
      display: inline-block;
      padding: 0.125rem 0.25rem;
      font-style: italic;
      font-family: monospace;
      margin: 0;
    }
    .typedoc-declaration-name {
      margin: 0;
      display: inline-block;
      line-height: 1.5rem;
    }

  </style>
</template>;
