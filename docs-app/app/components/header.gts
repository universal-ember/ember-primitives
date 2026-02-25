import { ExternalLink } from 'ember-primitives';

import { Flask, GitHub } from '@universal-ember/docs-support/icons';

export const TestsLink = <template>
  <ExternalLink href="/tests" class="header-icon-link" aria-label="Tests">
    <Flask class="header-icon" />
  </ExternalLink>

  <style scoped>
    .header-icon-link {
      display: block;
    }
    .header-icon-link:hover .header-icon {
      fill: #64748b;
    }
    .header-icon {
      width: 1.5rem;
      height: 1.5rem;
      fill: #94a3b8;
    }
    :is(html[style*="color-scheme: dark"]) .header-icon-link:hover .header-icon {
      fill: #cbd5e1;
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
      display: block;
    }
    .header-icon-link:hover .header-icon {
      fill: #64748b;
    }
    .header-icon {
      width: 1.5rem;
      height: 1.5rem;
      fill: #94a3b8;
    }
    :is(html[style*="color-scheme: dark"]) .header-icon-link:hover .header-icon {
      fill: #cbd5e1;
    }
  </style>
</template>;
