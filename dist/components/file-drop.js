import '../visually-hidden-CGP1FSjt.js';
import Component from '@glimmer/component';
import { registerDestructor } from '@ember/destroyable';
import { hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { uniqueId } from '../utils.js';
import { DragState, hasFiles, filesFrom } from './file-drop/files.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';

/**
 * A zone to drop files on, or to click to pick files.
 *
 * ```gjs
 * import { FileDrop } from 'ember-primitives/components/file-drop';
 *
 * const load = (files) => console.log(files);
 *
 * <template>
 *   <FileDrop @accept="video/*" @onFiles={{load}}>
 *     Drop a video here, or click to choose one
 *   </FileDrop>
 * </template>
 * ```
 */
class FileDrop extends Component {
  drag = new DragState();
  inputId = uniqueId();
  onDragEnter = event => this.drag.enter(event);
  onDragLeave = event => this.drag.leave(event);
  /**
  * Without this, the browser does not allow the drop.
  */
  onDragOver = event => {
    if (hasFiles(event)) event.preventDefault();
  };
  /**
  * `preventDefault` also tells a `DocumentFileDrop` that this zone took the drop.
  */
  onDrop = event => {
    this.drag.end();
    if (!hasFiles(event)) return;
    event.preventDefault();
    this.take(event.dataTransfer?.files);
  };
  /**
  * The input is cleared after each pick, so that picking the same file again
  * is a change too.
  */
  onPick = event => {
    const input = event.currentTarget;
    this.take(input.files);
    input.value = "";
  };
  take(list) {
    const files = filesFrom(list, this.args.accept, this.args.multiple);
    if (files.length > 0) this.args.onFiles(files);
  }
  static {
    setComponentTemplate(precompileTemplate("<label for={{this.inputId}} data-dragging={{if this.drag.isDragging \"\"}} {{on \"dragenter\" this.onDragEnter}} {{on \"dragover\" this.onDragOver}} {{on \"dragleave\" this.onDragLeave}} {{on \"drop\" this.onDrop}} ...attributes>\n  {{yield (hash isDragging=this.drag.isDragging)}}\n  <input id={{this.inputId}} class=\"ember-primitives__visually-hidden\" type=\"file\" accept={{@accept}} multiple={{@multiple}} {{on \"change\" this.onPick}} />\n</label>", {
      strictMode: true,
      scope: () => ({
        on,
        hash
      })
    }), this);
  }
}
/**
 * Takes files dropped anywhere on the page. It renders no element.
 *
 * - The block gets `isDragging`, for example to show where a drop goes.
 * - A drop outside every `FileDrop` does not open the file in the browser tab.
 * - A drop on a `FileDrop` goes only to that `FileDrop`.
 *
 * ```gjs
 * import { DocumentFileDrop } from 'ember-primitives/components/file-drop';
 *
 * const load = (files) => console.log(files);
 *
 * <template>
 *   <DocumentFileDrop @accept="video/*" @onFiles={{load}} as |page|>
 *     {{#if page.isDragging}}
 *       <div class="overlay">Drop to load</div>
 *     {{/if}}
 *   </DocumentFileDrop>
 * </template>
 * ```
 */
class DocumentFileDrop extends Component {
  drag = new DragState();
  constructor(owner, args) {
    super(owner, args);
    document.addEventListener("dragenter", this.onDragEnter);
    document.addEventListener("dragover", this.onDragOver);
    document.addEventListener("dragleave", this.onDragLeave);
    document.addEventListener("drop", this.onDrop);
    registerDestructor(this, () => {
      document.removeEventListener("dragenter", this.onDragEnter);
      document.removeEventListener("dragover", this.onDragOver);
      document.removeEventListener("dragleave", this.onDragLeave);
      document.removeEventListener("drop", this.onDrop);
    });
  }
  onDragEnter = event => this.drag.enter(event);
  onDragLeave = event => this.drag.leave(event);
  onDragOver = event => {
    if (hasFiles(event)) event.preventDefault();
  };
  onDrop = event => {
    this.drag.end();
    if (!hasFiles(event) || event.defaultPrevented) return;
    event.preventDefault();
    const files = filesFrom(event.dataTransfer?.files, this.args.accept, this.args.multiple);
    if (files.length > 0) this.args.onFiles(files);
  };
  static {
    setComponentTemplate(precompileTemplate("{{yield (hash isDragging=this.drag.isDragging)}}", {
      strictMode: true,
      scope: () => ({
        hash
      })
    }), this);
  }
}

export { DocumentFileDrop, FileDrop };
//# sourceMappingURL=file-drop.js.map
