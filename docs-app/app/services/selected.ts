import Service, { service } from '@ember/service';

import * as emberPrimitives from 'ember-primitives';
import { Shadowed } from 'ember-primitives';
// import { Compiled } from 'ember-repl';
import { compile } from 'ember-repl';
import { cell, resource, resourceFactory, use } from 'ember-resources';
import { keepLatest } from 'ember-resources/util/keep-latest';
import { RemoteData } from 'ember-resources/util/remote-data';

import type DocsService from './docs';
import type { Page } from './types';
import type RouterService from '@ember/routing/router-service';
import type { ComponentLike } from '@glint/template';

type Format = 'glimdown' | 'gjs' | 'hbs';
type Input = string | undefined | null;
interface Options {
  format: Format;
  importMap: Record<string, Record<string, unknown>>;
}


/**
  * Populate a cache of all the documents.
  *
  * Network can be slow, and compilation is fast.
  * So after we get the requested page, let's get
* everything else
  */
const fillCache = (path: string) => {
  fetch(`/docs/${path}`)
};


// TODO: upstream these tweaks to ember-repl
const Compiled = resourceFactory(
  (markdownText: Input | (() => Input), options: Options) => {
    return resource(() => {
      let { format = 'glimdown', importMap } = options ?? {};

      let input =
        typeof markdownText === 'function' ? markdownText() : markdownText;
      let ready = cell(false);
      let error = cell();
      let result = cell<ComponentLike>();

      if (input) {
        compile(input, {
          format,
          importMap,
          topLevelScope: {
            Shadowed,
          },
          ShadowComponent: 'Shadowed',
          onSuccess: async (component) => {
            result.current = component;
            ready.set(true);
            error.set(null);
          },
          onError: async (e) => {
            error.set(e);
          },
          onCompileStart: async () => {
            ready.set(false);
          },
        });
      }

      return () => ({
        isReady: ready.current,
        error: error.current,
        component: result.current,
      });
    });
  }
);

export default class Selected extends Service {
  @service declare router: RouterService;
  @service declare docs: DocsService;

  /*********************************************************************
   * These load the files from /public and handle loading / error state.
   *
   * When the path changes for each of these, the previous request will
   * be cancelled if it was still pending.
   *******************************************************************/

  @use proseFile = RemoteData<string>(() => `/docs${this.path}.md`);
  // @use proseCompiled = MarkdownToHTML(() => this.proseFile.value);
  @use proseCompiled = Compiled(() => this.proseFile.value, {
    format: 'glimdown',
    importMap: {
      'ember-primitives': emberPrimitives,
    },
  });

  /*********************************************************************
   * This is a pattern to help reduce flashes of content during
   * the intermediate states of the above request fetchers.
   * When a new request starts, we'll hold on the old value for as long as
   * we can, and only swap out the old data when the new data is done loading.
   *
   ********************************************************************/

  @use prose = keepLatest({
    value: () => this.proseCompiled.component,
    when: () => !this.proseCompiled.isReady,
  });

  /**
   * Once this whole thing is "true", we can start
   * rendering without extra flashes.
   */
  get isReady() {
    return this.proseCompiled.isReady;
  }

  get hasError() {
    return this.proseCompiled.error;
  }
  get error() {
    return String(this.proseCompiled.error);
  }

  get hasProse() {
    return Boolean(this.prose);
  }

  get path(): string | undefined {
    let [path] = this.router.currentURL.split('?');
    let result = path && path !== '/' ? path : this.#manifest?.first.path;

    return result?.replace(/\.md$/, '');
  }

  get page(): Page | undefined {
    if (!this.path) return;

    return this.#findByPath(this.path);
  }

  get #manifest() {
    return this.docs.docs.value;
  }

  #findByPath = (path: string) => {
    return this.docs.flatList.find((page) => page.path === `${path}.md`);
  };
}

// DO NOT DELETE: this is how TypeScript knows how to look up your services.
declare module '@ember/service' {
  interface Registry {
    selected: Selected;
  }
}
