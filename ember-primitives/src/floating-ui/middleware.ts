import type { Middleware } from '@floating-ui/dom';

export function exposeMetadata(): Middleware {
  return {
    name: 'metadata',
    fn: (data) => {
      // https://floating-ui.com/docs/middleware#always-return-an-object
      return {
        data,
      };
    },
  };
}
