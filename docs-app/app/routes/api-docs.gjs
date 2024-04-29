import { APIDocs as KolayAPIDocs, ComponentSignature as KolayComponentSignature } from 'kolay';

export const APIDocs = <template>
  <KolayAPIDocs
    @package="ember-primitives"
    @module="declarations/{{@declaration}}"
    @name={{@name}}
  />
</template>;

export const ComponentSignature = <template>
  <KolayComponentSignature
    @package="ember-primitives"
    @module="declarations/{{@declaration}}"
    @name={{@name}}
  />
</template>;
