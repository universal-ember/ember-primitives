import Service, { service } from '@ember/service';

import { use } from 'ember-resources';
import { keepLatest } from 'ember-resources/util/keep-latest';
import { RemoteData } from 'ember-resources/util/remote-data';

import { MarkdownToComponent } from './markdown';

import type DocsService from './docs';
import type { Page } from './types';
import type RouterService from '@ember/routing/router-service';

export default class Selected extends Service {
  @service declare router: RouterService;
  @service declare docs: DocsService;

  /*********************************************************************
   * These load the files from /public and handle loading / error state.
   *
   * When the path changes for each of these, the previous request will
   * be cancelled if it was still pending.
   *******************************************************************/

  @use proseFile = RemoteData<string>(() => `/docs${this.path}`);
  // @use proseCompiled = MarkdownToHTML(() => this.proseFile.value);
  @use proseCompiled = MarkdownToComponent(() => this.proseFile.value);

  /*********************************************************************
   * This is a pattern to help reduce flashes of content during
   * the intermediate states of the above request fetchers.
   * When a new request starts, we'll hold on the old value for as long as
   * we can, and only swap out the old data when the new data is done loading.
   *
   ********************************************************************/

  @use prose = keepLatest({
    value: () => this.proseCompiled.html,
    when: () => !this.proseCompiled.ready,
  });

  /**
   * Once this whole thing is "true", we can start
   * rendering without extra flashes.
   */
  get isReady() {
    // Instead of inlining these, we want to access
    // these values without short-circuiting so that
    // the requests run in parallel.
    let prose = this.prose;

    return prose;
  }

  get hasProse() {
    return Boolean(this.prose);
  }

  get path(): string | undefined {
    let [path] = this.router.currentURL.split('?');

    return path && path !== '/' ? path : this.#manifest?.first.path;
  }

  get page(): Page | undefined {
    if (!this.path) return;

    return this.#findByPath(this.path);
  }

  get #manifest() {
    return this.docs.docs.value;
  }

  #findByPath = (path: string) => {
    return this.docs.flatList.find((page) => page.path === path);
  };
}

// DO NOT DELETE: this is how TypeScript knows how to look up your services.
declare module '@ember/service' {
  interface Registry {
    selected: Selected;
  }
}
