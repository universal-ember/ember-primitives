import "./visually-hidden.css";
import Component from "@glimmer/component";
import { DragState } from "./file-drop/files.ts";
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
            }
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
export declare class FileDrop extends Component<Signature> {
    drag: DragState;
    inputId: string;
    onDragEnter: (event: DragEvent) => void;
    onDragLeave: (event: DragEvent) => void;
    /**
     * Without this, the browser does not allow the drop.
     */
    onDragOver: (event: DragEvent) => void;
    /**
     * `preventDefault` also tells a `DocumentFileDrop` that this zone took the drop.
     */
    onDrop: (event: DragEvent) => void;
    /**
     * The input is cleared after each pick, so that picking the same file again
     * is a change too.
     */
    onPick: (event: Event) => void;
    take(list: FileList | null | undefined): void;
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
            }
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
export declare class DocumentFileDrop extends Component<DocumentSignature> {
    drag: DragState;
    constructor(owner: Owner, args: DocumentSignature["Args"]);
    onDragEnter: (event: DragEvent) => void;
    onDragLeave: (event: DragEvent) => void;
    onDragOver: (event: DragEvent) => void;
    onDrop: (event: DragEvent) => void;
}
export {};
//# sourceMappingURL=file-drop.d.ts.map