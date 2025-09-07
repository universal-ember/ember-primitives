export declare class ZoetropeHelper {
    parentSelector: string;
    constructor(parentSelector?: string);
    scrollLeft(): Promise<void>;
    scrollRight(): Promise<void>;
    visibleItems(): Element[];
    visibleItemCount(): number;
}
