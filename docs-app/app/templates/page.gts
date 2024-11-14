import { OopsError, PageLayout } from '@universal-ember/docs-support';
import { GitHubLink, TestsLink } from 'docs-app/components/header';
import { Logo, Logomark } from 'docs-app/components/icons';
import { ExternalLink, service } from 'ember-primitives';
import Route from 'ember-route-template';

export default Route(
  <template>
    <PageLayout>
      <:logoLink>
        <Logomark class="h-9 w-28 lg:hidden" />
        <Logo class="hidden w-auto h-9 fill-slate-700 lg:block dark:fill-sky-100" />
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
        {{#let (service "kolay/docs") as |docs|}}
          <Link
            @href="https://github.com/universal-ember/ember-primitives/edit/main/docs-app/public/docs{{docs.selected.path}}.md"
          >
            Edit this page
          </Link>
        {{/let}}
      </:editLink>
    </PageLayout>
  </template>
);

const ReportingAnIssue = <template>
  <ExternalLink href="https://github.com/universal-ember/ember-primitives/issues/new">
    reporting an issue
  </ExternalLink>
</template>;
