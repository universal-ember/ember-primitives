import type { TOC } from '@ember/component/template-only';

export const Callout: TOC<{ Blocks: { default: [] } }> = <template>
  <div class='callout'>
    <span class='icon'>✨</span>
    <p class='text'>
      {{yield}}
    </p>
  </div>

  <style>
    .callout { display: grid; grid-auto-flow: column; gap: 1rem; border: 1px solid #edc; padding:
    1rem; border-left: 0.5rem solid #edc; } .callout > .icon {} .callout > .text { font-style:
    italic; } .callout p { /* override prose styles */ margin: 0; }
  </style>
</template>;

export default Callout;
