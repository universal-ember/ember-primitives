import Application from '@ember/application';
import { renderComponent } from '@ember/renderer';

import { setupTabster } from 'ember-primitives/tabster';

import type { ComponentLike } from '@glint/template';

class App extends Application {
  modules = {};
}

const scenarios = import.meta.glob<{ default: ComponentLike }>('/tests/*/*/scenario.gts');

const path = new URLSearchParams(location.search).get('scenario');
const load = scenarios[`/tests/${path}/scenario.gts`];

if (!load) {
  throw new Error(`No scenario at tests/${path}/scenario.gts`);
}

const { default: Scenario } = await load();

const owner = App.create({ autoboot: false }).buildInstance();

await owner.boot();
await setupTabster(owner);

renderComponent(Scenario, { into: document.querySelector('#root') as Element, owner });

document.body.dataset['ready'] = 'true';
