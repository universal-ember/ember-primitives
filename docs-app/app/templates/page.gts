import Component from '@glimmer/component';
import { service } from '@ember/service';

import { GitHubLink, TestsLink } from 'docs-app/components/header';
import { Logo, Logomark } from 'docs-app/components/icons';
import { ExternalLink } from 'ember-primitives';

import { OopsError, PageLayout } from '@universal-ember/docs-support';

import type RouterService from '@ember/routing/router-service';

const baseDocs =
  'https://github.com/universal-ember/ember-primitives/edit/main/docs-app/app/templates';

function urlFor(path: string) {
  return `${baseDocs}/${path.replace('.md', '')}.gjs.md`;
}

export default class Page extends Component {
  @service declare router: RouterService;

  <template>
    <PageLayout>
      <:logoLink>
        <Logomark class="logo-small" />
        <Logo class="logo-large" />
      </:logoLink>
      <:topRight>
        <TestsLink />
        <GitHubLink />
      </:topRight>
      <:error as |error|>
        <OopsError @error={{error}}>
          If you have a GitHub account (and the time),
          <ReportingAnIssue />
          would be most helpful! 🎉
        </OopsError>
      </:error>
      <:editLink as |Link|>
        {{#if this.router.currentURL}}
          <Link @href={{urlFor this.router.currentURL}}>
            Edit this page
          </Link>
        {{/if}}
      </:editLink>
    </PageLayout>

    <style scoped>
      .logo-small {
        height: 2.25rem;
        width: 7rem;
      }

      @media (min-width: 1024px) {
        .logo-small {
          display: none;
        }
      }

      .logo-large {
        display: none;
        width: auto;
        height: 2.25rem;
        fill: #334155;
      }

      :is(html[style*="color-scheme: dark"]) .logo-large {
        fill: #e0f2fe;
      }

      @media (min-width: 1024px) {
        .logo-large {
          display: block;
        }
      }
    </style>
  </template>
}

const ReportingAnIssue = <template>
  <ExternalLink href="https://github.com/universal-ember/ember-primitives/issues/new">
    reporting an issue
  </ExternalLink>
</template>;
