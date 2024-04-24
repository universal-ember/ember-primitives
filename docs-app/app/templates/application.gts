import Layout from 'docs-app/components/layout';
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import pageTitle from 'ember-page-title/helpers/page-title';
import Route from 'ember-route-template';

export default Route(
  <template>
    {{pageTitle "ember-primitives"}}

    <div class="flex w-full flex-col">
      <Layout />
    </div>
  </template>
);
