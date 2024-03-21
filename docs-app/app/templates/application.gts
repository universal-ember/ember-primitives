import Layout from 'docs-app/components/layout';
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import pageTitle from 'ember-page-title/helpers/page-title';
import Route from 'ember-route-template';

import { Footer } from '../components/footer';
import { Nav } from '../components/nav';

export default Route(
  <template>
    {{pageTitle "ember-primitives"}}

    <main id="layout">
      <Nav />
      <section>
        {{outlet}}
      </section>
    </main>
    <Footer />
  </template>
);
