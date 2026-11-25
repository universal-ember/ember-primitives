import "./visually-hidden.css";

import Component from "@glimmer/component";
import { registerDestructor } from "@ember/destroyable";
import { hash } from "@ember/helper";
import { on } from "@ember/modifier";

import { uniqueId } from "../utils.ts";
import { DragState, filesFrom, hasFiles } from "./file-drop/files.ts";

import type Owner from "@ember/owner";

interface FileArgs {
  /**
   * Called with the files that match `@accept`.
   * It is not called when no file matches.
   */
  onFiles: (files: File[]) => void;

  /**
   * Which files to take, in the format of the `accept` attribute
   * of `<input type="file">`, for example `"video/*,.mkv"`.
   *
   * The file picker shows only these files.
   * A drop of other files does nothing.
   */
  accept?: string;

  /**
   * Take more than one file. Without it, only the first file that matches.
   */
  multiple?: boolean;
}

export interface Signature {
  /**
   * A `<label>` for a hidden `<input type="file">`,
   * so a click or a key press on the zone opens the file picker.
   *
   * It has `data-dragging` while files are dragged over it.
   */
  Element: HTMLLabelElement;
  Args: FileArgs;
  Blocks: {
    default: [
      {
        /**
         * Files are dragged over the zone.
         */
        isDragging: boolean;
      },
    ];
  };
}

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
export class FileDrop extends Component<Signature> {
  drag = new DragState();
  inputId = uniqueId();

  onDragEnter = (event: DragEvent) => this.drag.enter(event);
  onDragLeave = (event: DragEvent) => this.drag.leave(event);

  /**
   * Without this, the browser does not allow the drop.
   */
  onDragOver = (event: DragEvent) => {
    if (hasFiles(event)) event.preventDefault();
  };

  /**
   * `preventDefault` also tells a `DocumentFileDrop` that this zone took the drop.
   */
  onDrop = (event: DragEvent) => {
    this.drag.end();

    if (!hasFiles(event)) return;

    event.preventDefault();
    this.take(event.dataTransfer?.files);
  };

  /**
   * The input is cleared after each pick, so that picking the same file again
   * is a change too.
   */
  onPick = (event: Event) => {
    const input = event.currentTarget as HTMLInputElement;

    this.take(input.files);
    input.value = "";
  };

  take(list: FileList | null | undefined) {
    const files = filesFrom(list, this.args.accept, this.args.multiple);

    if (files.length > 0) this.args.onFiles(files);
  }

  <template>
    <label
      for={{this.inputId}}
      data-dragging={{if this.drag.isDragging ""}}
      {{on "dragenter" this.onDragEnter}}
      {{on "dragover" this.onDragOver}}
      {{on "dragleave" this.onDragLeave}}
      {{on "drop" this.onDrop}}
      ...attributes
    >
      {{yield (hash isDragging=this.drag.isDragging)}}
      <input
        id={{this.inputId}}
        class="ember-primitives__visually-hidden"
        type="file"
        accept={{@accept}}
        multiple={{@multiple}}
        {{on "change" this.onPick}}
      />
    </label>
  </template>
}

export interface DocumentSignature {
  Args: FileArgs;
  Blocks: {
    default: [
      {
        /**
         * Files are dragged over the page.
         */
        isDragging: boolean;
      },
    ];
  };
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
export class DocumentFileDrop extends Component<DocumentSignature> {
  drag = new DragState();

  constructor(owner: Owner, args: DocumentSignature["Args"]) {
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

  onDragEnter = (event: DragEvent) => this.drag.enter(event);
  onDragLeave = (event: DragEvent) => this.drag.leave(event);

  onDragOver = (event: DragEvent) => {
    if (hasFiles(event)) event.preventDefault();
  };

  onDrop = (event: DragEvent) => {
    this.drag.end();

    if (!hasFiles(event) || event.defaultPrevented) return;

    event.preventDefault();

    const files = filesFrom(event.dataTransfer?.files, this.args.accept, this.args.multiple);

    if (files.length > 0) this.args.onFiles(files);
  };

  <template>{{yield (hash isDragging=this.drag.isDragging)}}</template>
}
