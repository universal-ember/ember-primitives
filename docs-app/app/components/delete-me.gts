import type { ComponentLike } from '@glint/template';

type Generic<X = unknown> = ComponentLike<{
  Args: {
    x: X;
  };
  Blocks: {
    default: [X];
  };
}>;

export const Demo: Generic = <template>{{yield @x}}</template>;

export const NoGenerics = <template>
  <Demo @x={{2}} as |num|>
    {{num}}
  </Demo>
  <Demo @x="hello" as |str|>
    {{str}}
  </Demo>
</template>;
