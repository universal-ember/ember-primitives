import Component from '@glimmer/component';

import { GitHubLink, TestsLink } from 'docs-app/components/header';
import { Logo, Logomark } from 'docs-app/components/icons';
import { NavButtonGroup } from 'docs-app/components/nav-button-group';
import { ExternalLink } from 'ember-primitives';
import { selected } from 'kolay';

import { OopsError, PageLayout } from '@universal-ember/docs-support';

export default class Animations extends Component {
  get selectedPath() {
    return selected(this).path;
  }
  <template>
    <PageLayout>
      <:logoLink>
        <Logomark class="h-9 w-28 lg:hidden" />
        <Logo class="hidden w-auto h-9 fill-slate-700 lg:block dark:fill-sky-100" />
      </:logoLink>
      <:centerNav>
        <NavButtonGroup />
      </:centerNav>
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
        <Link
          href="https://github.com/universal-ember/ember-primitives/edit/main/docs-app/public/docs{{this.selectedPath}}.md"
        >
          Edit this page
        </Link>
      </:editLink>
    </PageLayout>
  </template>
}

const ReportingAnIssue = <template>
  <ExternalLink href="https://github.com/universal-ember/ember-primitives/issues/new">
    reporting an issue
  </ExternalLink>
</template>;
