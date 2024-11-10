import { OopsError, PageLayout } from '@universal-ember/docs-support';
import { Header } from 'docs-app/components/header';
import { Nav } from 'docs-app/components/nav';
import { ExternalLink, service } from 'ember-primitives';
import Route from 'ember-route-template';

const DocsPage = <template>
  <PageLayout>
    <:nav as |n|>
      <Nav @onClick={{n.close}} />
    </:nav>
    <:header as |Toggle|>
      <Header>
        <Toggle />
      </Header>
    </:header>
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
          href="https://github.com/universal-ember/ember-primitives/edit/main/docs-app/public/docs{{docs.selected.path}}.md"
        >
          Edit this page
        </Link>
      {{/let}}
    </:editLink>
  </PageLayout>
</template>;

export default Route(DocsPage);

const ReportingAnIssue = <template>
  <ExternalLink href="https://github.com/universal-ember/ember-primitives/issues/new">
    reporting an issue
  </ExternalLink>
</template>;
