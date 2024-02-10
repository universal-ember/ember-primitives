import Route from 'ember-route-template';
import { Page } from 'kolay/components';
import { ExternalLink } from 'ember-primitives';

// Removes the App Shell / welcome UI
// before initial rending and chunk loading finishes
function removeLoader() {
  document.querySelector('#initial-loader')?.remove();
}

const resetScroll = modifier((element, [prose]) => {
  prose;
  element.scrollTo(0, 0);
});

const ReportingAnIssue =
  <template>
  <ExternalLink href="https://github.com/universal-ember/ember-primitives/issues/new">
    reporting an issue
  </ExternalLink>
</template>;

export default Route(
  <template>
    <Page>

      <:error as |error|>
        <div style="border: 1px solid red; padding: 1rem;">
          <h1>Oops!</h1>
          {{error}}

          <br />
          <br />
          If you have a GitHub account (and the time),
          <ReportingAnIssue />
          would be most helpful! 🎉
        </div>
      </:error>

      <:success as |prose|>
        <div
          class="grid gap-4 overflow-auto px-4 pb-8 w-fit w-full prose"
          ...attributes
          {{resetScroll prose}}
        >
          <prose />
          {{(removeLoader)}}

          <hr class="border" />

          <ExternalLink
            class="edit-page"
            href="https://github.com/universal-ember/ember-primitives/edit/main/docs-app/public/docs{{docs.selected.path}}.md"
          >
            Edit this page
          </ExternalLink>
        </div>
      </:success>

    </Page>
  </template>
);
