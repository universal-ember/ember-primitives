export type Orientation = 'horizontal' | 'vertical';
interface GroupOptions {
    orientation: () => Orientation | undefined;
    onLayoutChange: () => ((sizes: number[]) => void) | undefined;
}
export declare class GroupState {
    #private;
    element: HTMLElement | null;
    constructor(options: GroupOptions);
    get orientation(): Orientation;
    /**
     * This group's panels, in document order.
     * Panels of nested groups belong to their own group, not this one.
     */
    get panels(): HTMLElement[];
    get handles(): HTMLElement[];
    get sizes(): number[];
    /**
     * Called (via modifier) when the group element is inserted.
     * Watches for panels being added/removed (and the orientation
     * changing) and performs the initial layout.
     */
    attach: (element: HTMLElement) => (() => void);
    startDrag(handleElement: HTMLElement, event: PointerEvent): void;
    /**
     * Keyboard support for the WAI-ARIA window-splitter pattern.
     */
    handleKeyDown(handleElement: HTMLElement, event: KeyboardEvent): void;
}
export {};
//# sourceMappingURL=state.d.ts.map