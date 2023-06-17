import { highlight } from 'docs-app/components/highlight';
import { Compiled, defaultOptions } from 'docs-app/markdown';

import { Load } from './utils';

import type { TOC } from '@ember/component/template-only';
import type {
  DeclarationReference,
  DeclarationReflection,
  NamedTupleMember,
  ReferenceType,
  SomeType,
  TupleType,
} from 'typedoc';

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
  };
}> = <template>
  <Load @module='{{@module}}' @name='{{name}}' as |info|>
    <Declaration @info={{info}} />
  </Load>
</template>;

export const CommentQuery: TOC<{
  Args: {
    module: string;
    name: string;
  };
}> = <template>
  <Load @module={{@module}} @name={{@name}} as |info|>
    <Comment @info={{info}} />
  </Load>
</template>;

const join = (lines: string[]) => lines.join('\n');
const text = (lines: { text: string }[]) => lines.map((line) => line.text);

export function isGlimmerComponent(info: DeclarationReference) {
  let extended = (info as any)?.extendedTypes?.[0];

  if (!extended) return false;

  return extended.name === 'default' && extended.package === '@glimmer/component';
}

export const Comment: TOC<{
  Args: {
    info: {
      comment?: {
        summary?: { text: string }[];
      };
    };
  };
}> = <template>
  {{#if @info.comment.summary}}
    {{#let (Compiled (join (text @info.comment.summary)) defaultOptions) as |compiled|}}
      {{#if compiled.isReady}}
        <div class='typedoc-rendered-comment' {{highlight}}>
          <compiled.component />
        </div>
      {{/if}}
    {{/let}}
  {{/if}}
</template>;

const isIgnored = (name: string) => ['__type', 'TOC', 'TemplateOnlyComponent'].includes(name);
const isConst = (x: { flags: { isConst: boolean } }) => x.flags.isConst;
const not = (x: unknown) => !x;

const Declaration: TOC<{
  Args: {
    info: DeclarationReflection | undefined;
  };
}> = <template>
  {{#if @info}}
    <div class='typedoc-declaration'>
      {{#if (not (isIgnored @info.name))}}
        <span class='typedoc-declaration-name'>{{@info.name}}</span>
      {{/if}}

      {{#if (isConst @info)}}
        <Comment @info={{@info}} />
      {{/if}}

      {{#if @info.type}}
        <Type @info={{@info.type}} />
      {{/if}}

      {{#if @info.children}}
        <ul class='typedoc-declaration-children'>
          {{#each @info.children as |child|}}
            <li><Declaration @info={{child}} /></li>
          {{/each}}
        </ul>
      {{/if}}

      {{#if @info.signatures}}
        <ul class='typedoc-declaration-signatures'>
          {{#each @info.signatures as |child|}}
            {{! @glint-expect-error }}
            <li><Type @info={{child}} /></li>
          {{/each}}
        </ul>
      {{/if}}

      {{#if (not (isConst @info))}}
        {{#if @info.comment.summary}}
          <Comment @info={{@info}} />
        {{/if}}
      {{/if}}
    </div>
  {{/if}}
</template>;

const Reflection: TOC<{ info: { declaration: DeclarationReflection } }> = <template>
  <Declaration @info={{@info.declaration}} />
</template>;

const isReference = (x: { type: string }) => x.type === 'reference';
const isReflection = (x: { type: string }) => x.type === 'reflection';

export const isIntrinsic = (x: { type: string }) => x.type === 'intrinsic';

const isTuple = (x: { type: string }) => x.type === 'tuple';
const isNamedTuple = (x: SomeType | undefined): x is NamedTupleMember =>
  x?.type === 'namedTupleMember';
const isVoidIntrinsic = (x: unknown | undefined) => {
  if (!x) return false;
  if (typeof x !== 'object') return false;
  if (x === null) return false;
  if (!('type' in x)) return false;

  if (typeof x.type === 'object' && x.type !== null) {
    if ('type' in x.type && 'name' in x.type) {
      return x.type.type === 'intrinsic' && x.type.name === 'void';
    }
  }

  return false;
};

// function typeArg(info: DeclarationReference) {
//   let extended = info?.extendedTypes?.[0]

//   if (!extended) return false;

//   return extended.typeArguments[0]
// }

const Reference: TOC<{ info: ReferenceType }> = <template>
  {{#if (not (isIgnored @info.name))}}
    <pre class='typedoc-reference'>{{@info.name}}</pre>
  {{/if}}
  {{#each @info.typeArguments as |typeArg|}}
    <Type @info={{typeArg}} />
  {{/each}}
</template>;

const Intrinsic: TOC<{ info: { name: string } }> = <template>
  <span class='typedoc-intrinsic'>{{@info.name}}</span>
</template>;

const VoidIntrinsic: TOC<{ info: { name: string } }> = <template>
  {{! @glint-expect-error }}
  <Declaration @info={{@info}} />
</template>;

const Tuple: TOC<{ Args: { info: TupleType } }> = <template>
  {{#each @info.elements as |element|}}
    <Type @info={{element}} />
  {{/each}}
</template>;

const NamedTuple: TOC<{ Args: { info: NamedTupleMember } }> = <template>
  <div class='typedoc-named-tuple'>
    <div class='typedoc-name'>{{@info.name}}</div>
    <Type @info={{@info.element}} />
  </div>
</template>;

export const Type: TOC<{ Args: { info: SomeType } }> = <template>
  {{#if (isReference @info)}}
    {{! @glint-expect-error }}
    <Reference @info={{@info}} />
  {{else if (isReflection @info)}}
    {{! @glint-expect-error }}
    <Reflection @info={{@info}} />
  {{else if (isIntrinsic @info)}}
    {{! @glint-expect-error }}
    <Intrinsic @info={{@info}} />
  {{else if (isTuple @info)}}
    {{! @glint-expect-error }}
    <Tuple @info={{@info}} />
  {{else if (isNamedTuple @info)}}
    <NamedTuple @info={{@info}} />
  {{else if (isVoidIntrinsic @info)}}
    {{! @glint-expect-error }}
    <VoidIntrinsic @info={{@info}} />
  {{else}}
    {{! template-lint-disable no-log }}
    {{log 'Unknown Type' @info}}
  {{/if}}
</template>;
