import { Shell } from '@universal-ember/docs-support';
import pageTitle from 'ember-page-title/helpers/page-title';
import Route from 'ember-route-template';

const Application = <template>
  <Shell>
    {{pageTitle "ember-primitives"}}

    {{outlet}}
  </Shell>
</template>;

export default Route(Application);
