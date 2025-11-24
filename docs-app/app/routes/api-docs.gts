import {
  APIDocs as KolayAPIDocs,
  CommentQuery as KolayCommentQuery,
  ComponentSignature as KolayComponentSignature,
  ModifierSignature as KolayModifierSignature,
} from 'kolay';

import type { TOC } from '@ember/component/template-only';

export function comment(name: string, declaration: string) {
  return <template>
    <KolayCommentQuery
      @package="ember-primitives"
      @module="declarations/{{declaration}}"
      @name={{name}}
    />
  </template>;
}

export const APIDocs: TOC<{
  Args: { declaration: string; name: string };
}> = <template>
  <KolayAPIDocs
    @package="ember-primitives"
    @module="declarations/{{@declaration}}"
    @name={{@name}}
  />
</template>;

export const ComponentSignature: TOC<{
  Args: { declaration: string; name: string };
}> = <template>
  <KolayComponentSignature
    @package="ember-primitives"
    @module="declarations/{{@declaration}}"
    @name={{@name}}
  />
</template>;

export const ModifierSignature: TOC<{
  Args: { declaration: string; name: string };
}> = <template>
  <KolayModifierSignature
    @package="ember-primitives"
    @module="declarations/{{@declaration}}"
    @name={{@name}}
  />
</template>;
