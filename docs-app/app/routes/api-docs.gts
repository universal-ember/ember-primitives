import { APIDocs as KolayAPIDocs, ComponentSignature as KolayComponentSignature } from 'kolay';

import type { TOC } from '@ember/component/template-only';

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
