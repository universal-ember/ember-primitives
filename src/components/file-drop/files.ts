import { tracked } from '@glimmer/tracking';

/**
 * One entry of an `accept` list: an extension (`.mp4`),
 * a type with a wildcard (`video/*`), or an exact type (`video/webm`).
 */
function acceptsOne(file: File, entry: string): boolean {
  if (entry.startsWith('.')) {
    return file.name.toLowerCase().endsWith(entry.toLowerCase());
  }

  if (entry.endsWith('/*')) {
    return file.type.startsWith(entry.slice(0, -1));
  }

  return file.type === entry;
}

/**
 * Matches a file against an `accept` list, as `<input type="file">` reads it.
 *
 * The file picker filters by `accept` itself, but a drop does not,
 * so dropped files need this check.
 */
export function accepts(file: File, accept: string | undefined): boolean {
  if (!accept) return true;

  const entries = accept.split(',');

  for (const entry of entries) {
    const trimmed = entry.trim();

    if (trimmed && acceptsOne(file, trimmed)) return true;
  }

  return false;
}

/**
 * A drag can carry text or a link instead of files.
 * During the drag, only the types are readable, not the files.
 */
export function hasFiles(event: DragEvent): boolean {
  const types = event.dataTransfer?.types;

  if (!types) return false;

  for (const type of types) {
    if (type === 'Files') return true;
  }

  return false;
}

/**
 * The files of a pick or a drop that match `accept`, and only the first one
 * unless `multiple` is set.
 */
export function filesFrom(
  list: FileList | null | undefined,
  accept: string | undefined,
  multiple: boolean | undefined
): File[] {
  const files: File[] = [];

  if (!list) return files;

  for (const file of list) {
    if (!accepts(file, accept)) continue;

    files.push(file);

    if (!multiple) break;
  }

  return files;
}

/**
 * Whether files are dragged over an element.
 *
 * `dragenter` and `dragleave` fire for every child that the pointer crosses,
 * so a single flag would flicker. The depth counts the enters that did not leave yet.
 */
export class DragState {
  @tracked isDragging = false;

  #depth = 0;

  enter(event: DragEvent): void {
    if (!hasFiles(event)) return;

    this.#depth++;
    this.isDragging = true;
  }

  leave(event: DragEvent): void {
    if (!hasFiles(event)) return;

    this.#depth = Math.max(0, this.#depth - 1);

    if (this.#depth === 0) this.isDragging = false;
  }

  end(): void {
    this.#depth = 0;
    this.isDragging = false;
  }
}
