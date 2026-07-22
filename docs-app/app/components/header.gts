import { ExternalLink } from 'ember-primitives';

import { Flask, GitHub } from '@universal-ember/docs-support/icons';

export const TestsLink = <template>
  <ExternalLink href="/tests" class="header-icon-link" aria-label="Tests">
    <Flask class="header-icon" />
  </ExternalLink>

  <style scoped>
    .header-icon-link {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 2rem;
      height: 2rem;
      border-radius: var(--doc-radius-sm);
      text-decoration: none;
    }
    .header-icon-link:hover {
      background: var(--doc-brand-soft);
    }
    .header-icon-link:hover .header-icon {
      fill: var(--doc-brand-1);
    }
    .header-icon {
      width: 1.25rem;
      height: 1.25rem;
      fill: var(--doc-text-2);
      transition: fill 0.12s ease;
    }
  </style>
</template>;

export const GitHubLink = <template>
  <ExternalLink
    class="header-icon-link"
    href="https://github.com/universal-ember/ember-primitives"
    aria-label="GitHub"
  >
    <GitHub class="header-icon" />
  </ExternalLink>

  <style scoped>
    .header-icon-link {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 2rem;
      height: 2rem;
      border-radius: var(--doc-radius-sm);
      text-decoration: none;
    }
    .header-icon-link:hover {
      background: var(--doc-brand-soft);
    }
    .header-icon-link:hover .header-icon {
      fill: var(--doc-brand-1);
    }
    .header-icon {
      width: 1.25rem;
      height: 1.25rem;
      fill: var(--doc-text-2);
      transition: fill 0.12s ease;
    }
  </style>
</template>;
