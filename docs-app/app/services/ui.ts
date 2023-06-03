import { tracked } from '@glimmer/tracking';
import Service from '@ember/service';

export default class UI extends Service {
  @tracked isNavOpen = false;

  toggleNav = () => (this.isNavOpen = !this.isNavOpen);
}

// DO NOT DELETE: this is how TypeScript knows how to look up your services.
declare module '@ember/service' {
  interface Registry {
    ui: UI;
  }
}
