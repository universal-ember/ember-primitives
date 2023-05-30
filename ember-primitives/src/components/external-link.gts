import type { TOC } from '@ember/component/template-only';

export const ExternalLink: TOC<{
  Element: HTMLAnchorElement;
  Blocks: {
    default: [];
  };
}> = <template>
  <a
    target='_blank'
    rel='noreferrer noopener'
    href='##missing##'
    ...attributes
  >
    <span>{{yield}}</span>
  </a>
</template>;

export default ExternalLink;
