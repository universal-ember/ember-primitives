import { Shell } from '@universal-ember/docs-support';
import pageTitle from 'ember-page-title/helpers/page-title';
import Route from 'ember-route-template';

export default Route(
  <template>
    <Shell>
      {{pageTitle "ember-primitives"}}

      {{outlet}}
    </Shell>
  </template>
);
