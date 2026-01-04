import Component from '@glimmer/component';
import { registerDestructor } from '@ember/destroyable';

import type Owner from '@ember/owner';

function findHeadings() {
  const headings = document.querySelectorAll(
    'main h1, main h2, main h3, main h4, main h5, main h6'
  );

  return [...headings].map((heading) => {
    return {
      level: heading.tagName.replace(/h/i, ''),
      text: heading.textContent.trim().replace(/\s+/g, ' '),
    };
  });
}

export class OnThisPage extends Component<{
  Blocks: [];
}> {
  // eslint-disable-next-line @typescript-eslint/no-empty-object-type
  constructor(owner: Owner, args: {}) {
    super(owner, args);

    const observer = new MutationObserver(this.updateHeadings);

    observer.observe(document.body, { childList: true, subtree: true });

    registerDestructor(this, () => {
      observer.disconnect();
    });
  }

  updateHeadings = (mutationList: unknown[]) => {
    console.log(mutationList, findHeadings());
  };

  <template>
    {{#each (findHeadings) as |heading|}}
      {{heading.text}}

    {{/each}}
  </template>
}
