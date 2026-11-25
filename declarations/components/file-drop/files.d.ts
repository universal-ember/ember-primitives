/**
 * Matches a file against an `accept` list, as `<input type="file">` reads it.
 *
 * The file picker filters by `accept` itself, but a drop does not,
 * so dropped files need this check.
 */
export declare function accepts(file: File, accept: string | undefined): boolean;
/**
 * A drag can carry text or a link instead of files.
 * During the drag, only the types are readable, not the files.
 */
export declare function hasFiles(event: DragEvent): boolean;
/**
 * The files of a pick or a drop that match `accept`, and only the first one
 * unless `multiple` is set.
 */
export declare function filesFrom(list: FileList | null | undefined, accept: string | undefined, multiple: boolean | undefined): File[];
/**
 * Whether files are dragged over an element.
 *
 * `dragenter` and `dragleave` fire for every child that the pointer crosses,
 * so a single flag would flicker. The depth counts the enters that did not leave yet.
 */
export declare class DragState {
    #private;
    isDragging: boolean;
    enter(event: DragEvent): void;
    leave(event: DragEvent): void;
    end(): void;
}
//# sourceMappingURL=files.d.ts.map